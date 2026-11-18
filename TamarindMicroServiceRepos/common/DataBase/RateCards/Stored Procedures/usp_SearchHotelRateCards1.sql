
--DECLARE @Action NVARCHAR(10) = 'S';
--DECLARE @CurrencyCode NVARCHAR(10) = 'INR';
--DECLARE @RateCardModeType NVARCHAR(50) = '1,2,3,4';
--DECLARE @TaxID INT = 2;
--DECLARE @HotelID INT = 45235;
--DECLARE @RatingFrom INT = 0;
--DECLARE @RatingTo INT = 0;
--DECLARE @MISSequence NVARCHAR(100) = '';
--DECLARE @PreferredMarketIDs NVARCHAR(MAX) = '';
--DECLARE @RateSheetIDs NVARCHAR(MAX) = '';
--DECLARE @PreferredHotel BIT = 0;
--DECLARE @CityID NVARCHAR(10) = 'BOM';
--DECLARE @CheckIn DATETIME = '2025-06-11T00:00:00';
--DECLARE @CheckOut DATETIME = '2025-06-24T00:00:00';
--DECLARE @Occupancy NVARCHAR(100) = 'SGL'; -- Stored as CSV or separate table if multiple
--DECLARE @CityAndHotelName NVARCHAR(200) = '';
--DECLARE @QuotationID INT = 2;

-- If needed, @Occupancy and DateRange can be parsed as separate rows using table-valued parameters or XML/JSON methods.


create PROCEDURE [RateCards].[usp_SearchHotelRateCards1]

--exec [RateCards].[usp_SearchHotelRateCards] 'DEL',3345,'2025-05-11 00:00:00.000','2025-05-21 00:00:00.000','SGL','USD','1,2',1,null,null,0,'','',null



	
	@CityID VARCHAR(3),
    @HotelID BIGINT = NULL,
    @CheckIn DATETIME=NULL,
    @CheckOut DATETIME=NULL,
	@Occupancy VARCHAR(MAX)= NULL,
    @CurrencyCode VARCHAR(10) = 'INR',
    @RateCardModeType NVARCHAR(MAX) = NULL,
    @TaxID INT = NULL,
    @RatingFrom INT = NULL,
    @RatingTo INT = NULL,
    @MISSequence NVARCHAR(50) = NULL,
    @PreferredMarketIDs VARCHAR(MAX) = NULL,
    @RateSheetIDs VARCHAR(MAX) = NULL,
    @PreferredHotel BIT = NULL,
	@QuotationID   INT        = NULL


AS
BEGIN
     SET NOCOUNT ON;

    CREATE TABLE #PreferredMarkets (ID INT);
    CREATE TABLE #RateSheets (ID INT);
 

    --IF @PreferredMarketIDs IS NOT NULL
    --BEGIN
    --    INSERT INTO #PreferredMarkets (ID)
    --    SELECT TRY_CAST(value AS INT) FROM STRING_SPLIT(@PreferredMarketIDs, ',') WHERE TRY_CAST(value AS INT) IS NOT NULL;
    --END

    --IF @RateSheetIDs IS NOT NULL
    --BEGIN
    --    INSERT INTO #RateSheets (ID)
    --    SELECT TRY_CAST(value AS INT) FROM STRING_SPLIT(@RateSheetIDs, ',') WHERE TRY_CAST(value AS INT) IS NOT NULL;
    --END


	IF NULLIF(@PreferredMarketIDs, '') IS NOT NULL
BEGIN
    INSERT INTO #PreferredMarkets (ID)
    SELECT TRY_CAST(value AS INT)
    FROM STRING_SPLIT(@PreferredMarketIDs, ',')
    WHERE TRY_CAST(value AS INT) IS NOT NULL;
END

IF NULLIF(@RateSheetIDs, '') IS NOT NULL
BEGIN
    INSERT INTO #RateSheets (ID)
    SELECT TRY_CAST(value AS INT)
    FROM STRING_SPLIT(@RateSheetIDs, ',')
    WHERE TRY_CAST(value AS INT) IS NOT NULL;
END



    
	DECLARE @RateCardModeTable TABLE (ModeID INT)

-- Convert names to IDs and insert into table
INSERT INTO @RateCardModeTable (ModeID)
SELECT DISTINCT TRY_CAST(value AS INT)
FROM STRING_SPLIT(@RateCardModeType, ',')
WHERE TRY_CAST(value AS INT) IS NOT NULL

DECLARE @HasRegular BIT = 0, @HasCustom BIT = 0;

IF EXISTS (SELECT 1 FROM @RateCardModeTable WHERE ModeID IN (1, 2, 3))
    SET @HasRegular = 1;

IF EXISTS (SELECT 1 FROM @RateCardModeTable WHERE ModeID = 4)
    SET @HasCustom = 1;


   

	-- Parse @Occupancy into a list of RateType values like 'SGL', 'DBL'
CREATE TABLE #OccupancyRateTypes (RateType VARCHAR(10));

IF @Occupancy IS NOT NULL
BEGIN
    INSERT INTO #OccupancyRateTypes (RateType)
    SELECT TRIM(value)
    FROM STRING_SPLIT(@Occupancy, ',')
    WHERE TRIM(value) <> '';
END

;WITH CombinedRateCards AS (

    SELECT
	
		HRM.HotelRateID,
		'RateCard' as Type,
        H.HotelID,
		--H.HotelName+' '+isnull(HR.Code,'') as HotelName,
       H.HotelName + ' ' + CAST(HR.Ratings AS VARCHAR) + '*' AS HotelName,
		 CASE 
    WHEN EXISTS (
        SELECT 1 
        FROM HotelPreferred HP
        WHERE HP.HotelID = H.HotelID 
          AND HP.IsPreferred = 1
          AND CONVERT(DATE, @CheckIn) >= CONVERT(DATE, HP.ValidFrom)
          AND CONVERT(DATE, @CheckOut) <= CONVERT(DATE, HP.ValidTo)
    ) THEN 1 ELSE 0 
END AS HotelPreferred,

        HRM.CityID,
        RCD.HotelRateDetailID,
        RCD.RoomCategoryID,
        RoomCat.Name AS RoomCategory,
        RCD.MISSequence,
        RCD.Days,
       
CONCAT(
    CASE WHEN SUBSTRING(RCD.Days,1,1) = '1' THEN 'M' ELSE '' END,
    CASE WHEN SUBSTRING(RCD.Days,2,1) = '1' THEN 'T' ELSE '' END,
    CASE WHEN SUBSTRING(RCD.Days,3,1) = '1' THEN 'W' ELSE '' END,
    CASE WHEN SUBSTRING(RCD.Days,4,1) = '1' THEN 'T' ELSE '' END,
    CASE WHEN SUBSTRING(RCD.Days,5,1) = '1' THEN 'F' ELSE '' END,
    CASE WHEN SUBSTRING(RCD.Days,6,1) = '1' THEN 'S' ELSE '' END,
    CASE WHEN SUBSTRING(RCD.Days,7,1) = '1' THEN 'S' ELSE '' END
) AS DaysOfWeek,

HRM.RateCardModeTypeID,
      
        -- New: MealPlan info
        MP.Code AS MealPlanCode,
        MP.Breakfast,
        MP.Lunch,
        MP.Dinner,
		RCD.TransferID,
TM.TransferValue,
		  -- Flags
    ISNULL(CAST((
    SELECT 
        CASE 
            WHEN EXISTS (
                SELECT 1 
                FROM RateCards.Rules 
                WHERE RateCardID = HRM.HotelRateID
            ) 
            THEN 1 ELSE 0 
        END
) AS BIT), 0) AS HasRules,


 ISNULL(CAST((
    SELECT TOP 1 
        1
    FROM dbo.LinkedDocuments ld 
    INNER JOIN dbo.UploadDocuments ud 
        ON ld.DocumentID = ud.DocumentID 
    WHERE ld.ParentID = HRM.HotelRateID 
      AND ud.ParentTypeID = 1
) AS BIT), 0) AS HasDocument,
RCD.OfferTypeID,
HRM.CurrencyID as Currency,
dbo.fnGetPurchaseRate(HRM.CurrencyID,@CurrencyCode,@CheckIn) as PurchaseRate,
HRM.ValueAddOn,
HRM.InfoForOperation,
HRM.InfoForRemark,

(
    SELECT 
        RC.RateCommisionID as RateCommissionID,
        RCM.CommMasterID as CommissionMasterID,
        RCM.CommMasterID as MasterCommissionID,
        RCM.RateType,
        
        RC.TaxPercentage,
        RC.TaxAmount,

        RC.GrossAmountIncludingTax as GrossAmountIncludingTax,
        --dbo.fnSearchCalculateROE(ISNULL(RC.GrossAmountIncludingTax, 0), @CheckIn, C1.Code, @CurrencyCode) AS GrossAmountIncludingTax,
		  RC.GrossAmountIncludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS GrossAmountIncludingTax_Con,

        RC.GrossAmountExcludingTax as GrossAmountExcludingTax,
        --dbo.fnSearchCalculateROE(ISNULL(RC.GrossAmountExcludingTax, 0), @CheckIn, C1.Code, @CurrencyCode) as GrossAmountExcludingTax,
		 RC.GrossAmountExcludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS GrossAmountExcludingTax_Con,

        RC.CommisionPercentage,
        RC.CommissionAmount as CommissionAmount,
        --dbo.fnSearchCalculateROE(ISNULL(RC.CommissionAmount, 0), @CheckIn, C1.Code, @CurrencyCode) AS CommissionAmount,
		RC.CommissionAmount * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS CommissionAmount_Con,

        RC.NetAmountIncludingTax as NetAmountIncludingTax,
        --dbo.fnSearchCalculateROE(ISNULL(RC.NetAmountIncludingTax, 0), @CheckIn, C1.Code, @CurrencyCode) as NetAmountIncludingTax,
		 RC.NetAmountIncludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS NetAmountIncludingTax_Con,

        RC.NetAmountExcludingTax as NetAmountExcludingTax,
        --dbo.fnSearchCalculateROE(ISNULL(RC.NetAmountExcludingTax, 0), @CheckIn, C1.Code, @CurrencyCode) as NetAmountExcludingTax,
		RC.NetAmountExcludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS NetAmountExcludingTax_Con,

        ISNULL(RC.IsTax, 0) as IsTax,
        ISNULL(RC.IsActive, 0) as IsActive

		FROM RateCards.RateCommisionDetails RC
    INNER JOIN RateCommissionMaster RCM ON RC.CommissionMasterID = RCM.CommMasterID
    WHERE 
        RC.HotelRateDetailID = RCD.HotelRateDetailID
        AND 
		RC.IsActive = 1
        AND (
            NOT EXISTS (SELECT 1 FROM #OccupancyRateTypes)
            OR RCM.RateType IN (SELECT RateType FROM #OccupancyRateTypes)
			)

    --FROM RateCommissionMaster RCM
    --LEFT JOIN RateCards.RateCommisionDetails RC 
    --    ON RC.CommissionMasterID = RCM.CommMasterID 
    --    AND RC.HotelRateDetailID = RCD.HotelRateDetailID
    --    AND RC.IsActive = 1
    --WHERE RCM.Type = 1
    FOR JSON PATH
) AS CommissionJSON,


--  
       (
    SELECT
        M.HotelRateMealID,
        M.HotelRateDetailID,
     
        MealType.RateType AS MealType,
        M.GstPercentage,
        M.GstAmount,

        -- Conditionally select NetAmount based on @TaxID
       M.NetAmountIncludingTax as NetAmountIncludingTax,
       --dbo.fnSearchCalculateROE(M.NetAmountIncludingTax, @CheckIn, C1.Code, @CurrencyCode) AS NetAmountIncludingTax,
	   M.NetAmountIncludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS NetAmountIncludingTax_Con,

       M.NetAmountExcludingTax as NetAmountExcludingTax,
       --dbo.fnSearchCalculateROE(M.NetAmountExcludingTax, @CheckIn, C1.Code, @CurrencyCode) AS NetAmountExcludingTax,
	    M.NetAmountExcludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS NetAmountExcludingTax_Con,
      
        M.MasterCommissionID,
       
        M.IsMealDetails,
        M.DefineAmount
    FROM RateCards.HotelMealOverviewMaster M
    LEFT JOIN RateCommissionMaster MealType ON M.MasterCommissionID = MealType.CommMasterID
    WHERE M.HotelRateDetailID = RCD.HotelRateDetailID AND M.IsActive = 1
    FOR JSON PATH
) AS MealOverviewJSON,

(
    SELECT 
        OC.OfferID,
        OC.HotelRateDetailID,
        OC.Days,
        OC.FromDate,
        OC.ToDate,
        OC.TotalNights,
        OC.PaidNights,
        OC.FreeNights,
        OC.IsExtendible,
        OC.IsActive,
		

        -- OfferType label based on OfferTypeID from parent RCD
        CASE 
            WHEN RCD.OfferTypeID = 1 THEN 'EBO'
            WHEN RCD.OfferTypeID = 2 THEN 'PayOnStay'
            ELSE 'Unknown'
        END AS OfferType,

        -- Offer Commission as nested JSON array including RateType
        (
            SELECT 
                OCC.OfferCommissionID,
                OCC.OfferConfigurationID,
                OCC.MasterCommissionID,
                RCM.RateType, -- added from RateCommissionMaster
                OCC.Discount,
                OCC.DiscountAmount,
                OCC.Tax,
                OCC.TaxAmount,
                OCC.PaidNightAmountExcludingTax,
				 OCC.PaidNightAmountExcludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS PaidNightAmountExcludingTax_Con,
                OCC.PaidNightAmountIncludingTax,
				 OCC.PaidNightAmountIncludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS PaidNightAmountIncludingTax_Con,
                OCC.FreeNightAmountExcludingTax,
				 OCC.FreeNightAmountExcludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS FreeNightAmountExcludingTax_Con,
                OCC.FreeNightAmountIncludingTax,
				 OCC.FreeNightAmountIncludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS FreeNightAmountIncludingTax_Con,
                OCC.GrossAmountExcludingTax,
				 OCC.GrossAmountExcludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS GrossAmountExcludingTax_Con,
                OCC.GrossAmountIncludingTax,
				 OCC.GrossAmountIncludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS GrossAmountIncludingTax_Con,
                OCC.NetAmountExcludingTax,
				OCC.NetAmountExcludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS NetAmountExcludingTax_Con,
                OCC.NetAmountIncludingTax,
				OCC.NetAmountIncludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS NetAmountIncludingTax_Con,
                OCC.IsActive
            FROM RateCards.HotelRateOfferConfigurationCommission OCC
            LEFT JOIN RateCommissionMaster RCM 
                ON OCC.MasterCommissionID = RCM.CommMasterID
            WHERE 
				OCC.OfferConfigurationID = OC.OfferID
				AND OCC.IsActive = 1
				AND (OCC.IsDeleted = 0 OR OCC.IsDeleted IS NULL)
				AND ISNULL(OCC.IsDeleted,0)<>1
            FOR JSON PATH
        ) AS OfferCommission

    FROM RateCards.HotelRateOfferConfiguration OC
    WHERE OC.HotelRateDetailID = RCD.HotelRateDetailID
      AND OC.IsActive = 1
	  AND ISNULL(OC.IsDeleted,0)<>1
    FOR JSON PATH
) AS OfferConfigurationJSON,

-- Hotel Announcements JSON
(
    SELECT 
        C.Name AS City,
        HA.AnnouncementDetails,
        CONVERT(VARCHAR(12), HA.ValidTo, 106) AS ValidTill,
        HA.AnnouncementID,
        HA.ValidTo
    FROM HotelAnnouncement HA
    INNER JOIN City C ON C.IATACode = H.CityIATACode
    WHERE HA.HotelID = H.HotelID
    FOR JSON PATH
) AS HotelAnnouncementsJSON,

-- Contact Details JSON
(
    SELECT 
        Country.IATACode, 
        CD.FirstName, 
        CD.LastName, 
        H.HotelName AS DisplayName,
        CD.CityIATACode,
        City.Name AS CityName, 
        CD.DesignationOrDepartment, 
        CD.EmailID, 
        CD.ContactDetailsID, 
        CD.DateofBirth, 
        CD.CreatedBy, 
        H.FaxNo, 
        H.HotelID, 
        CD.IsPrimaryContact, 
        CD.IsForContracting, 
        CD.IsCC, 
        CD.IsActive, 
        CD.IsBills, 
        CD.IsAccStatement, 
        CD.InsertedDate, 
        CD.TypeID, 
        CD.SalutationID, 
        CD.ParentID, 
        CD.OfficeNo, 
        CD.MobileNo
    FROM ContactDetails CD
    INNER JOIN City ON CD.CityIATACode = City.IATACode
    INNER JOIN STATE ON City.State_IATACode = STATE.State_ID
    INNER JOIN Country ON STATE.Country_IATACode = Country.IATACode
    WHERE 
        CD.TypeID = 1
        
        AND  CD.ParentID = H.HotelID
    FOR JSON PATH
) AS ContactDetailsJSON,

-- Rules JSON
(
    SELECT 
        rul.ID,
        rul.RateCardTypeID,
        rul.RateCardID,
        rul.RuleID,
        rg.Name AS [Rule],
        rul.MISSeqeunce AS MISSequence,
        CASE 
            WHEN rul.ApplicableID = '1' THEN 'ALL' 
            WHEN rul.ApplicableID = '2' THEN 'B2B Agent'
            WHEN rul.ApplicableID = '3' THEN 'Operations'
        END AS Applicable,
        rul.ApplicableID,
        rul.[Description],
        rul.IsActive
    FROM RateCards.Rules rul
    LEFT JOIN RuleGroups rg ON rg.ID = rul.RuleID
    WHERE rul.RateCardID = HRM.HotelRateID 
      AND rul.RateCardTypeID = 1
    FOR JSON PATH
) AS RulesJSON,


        -- Market JSON: joined via MasterID
        (
            SELECT MKT.MarketRateID
			
            FROM RateCards.HotelRateMarketMasterLookup MKT
            WHERE MKT.HotelRateID = HRM.HotelRateID AND MKT.IsActive = 1
            FOR JSON PATH
        ) AS MarketJSON,

        -- RateSheet JSON: joined via MasterID
        (
            SELECT RS.RateSheetID
            FROM RateCards.HotelRatesheetMasterLookup RS
            WHERE RS.HotelRateID = HRM.HotelRateID AND RS.IsActive = 1
            FOR JSON PATH
        ) AS RateSheetJSON,
	HRM.CreatedOn,
	 1 AS SortOrder

    FROM RateCards.HotelRateMaster HRM
    INNER JOIN RateCards.HotelRateDetails RCD ON HRM.HotelRateID = RCD.HotelRateID
    INNER JOIN HotelMaster H ON HRM.HotelID = H.HotelID
    INNER JOIN HotelRating HR ON HR.ID = H.HotelRatingID
    INNER JOIN CurrencyMaster C1 ON HRM.CurrencyID = C1.CurrencyCode
    LEFT JOIN HotelRoomCategory HRC ON HRM.HotelID = HRC.HotelID AND HRC.RoomCategoryID = RCD.RoomCategoryID
    LEFT JOIN RoomCategory RoomCat ON RCD.RoomCategoryID = RoomCat.ID
   
    LEFT JOIN MealPlan MP ON RCD.MealPlanID = MP.ID AND MP.IsActive = 1
	 LEFT JOIN dbo.TransferMaster TM ON RCD.TransferID = TM.TransferID
    WHERE 
        HRM.IsActive = 1 AND RCD.IsActive = 1
        AND HRM.CityID = @CityID
        AND (@HotelID IS NULL OR HRM.HotelID = @HotelID)
   AND HRM.RateCardModeTypeID IN (SELECT ModeID FROM @RateCardModeTable)
       AND (
    @MISSequence IS NULL 
    OR @MISSequence = 0 
    OR LTRIM(RTRIM(@MISSequence)) = '' 
    OR RCD.MISSequence = @MISSequence
)
        --AND (@PreferredHotel IS NULL OR @PreferredHotel = 0 OR H.HotelPreferred = 1)

		AND (
    @PreferredHotel IS NULL OR @PreferredHotel = 0 OR EXISTS (
        SELECT 1
        FROM HotelPreferred HP
        WHERE HP.HotelID = H.HotelID 
          AND HP.IsPreferred = 1
          AND CONVERT(DATE, @CheckIn) >= CONVERT(DATE, HP.ValidFrom)
          AND CONVERT(DATE, @CheckOut) <= CONVERT(DATE, HP.ValidTo)
    )
)

        

        AND ((@RatingFrom IS NULL OR @RatingTo IS NULL OR @RatingFrom =0 OR @RatingTo=0) OR (HR.Ratings BETWEEN @RatingFrom AND @RatingTo))
        AND (
            NOT EXISTS (SELECT 1 FROM #PreferredMarkets) 
            OR EXISTS (
                SELECT 1 FROM #PreferredMarkets PM 
                INNER JOIN RateCards.HotelRateMarketMasterLookup MKT ON MKT.MarketRateID = PM.ID
                WHERE MKT.HotelRateID = HRM.HotelRateID AND MKT.IsActive = 1
            )
        )
        AND (
            NOT EXISTS (SELECT 1 FROM #RateSheets) 
            OR EXISTS (
                SELECT 1 FROM #RateSheets RS 
                INNER JOIN RateCards.HotelRatesheetMasterLookup Sheet ON Sheet.RateSheetID = RS.ID
                WHERE Sheet.HotelRateID = HRM.HotelRateID AND Sheet.IsActive = 1
            )
        )
        --AND SUBSTRING(RCD.Days, DATEPART(WEEKDAY, @CheckIn), 1) = '1'
      --AND HRM.PaymentTypeID = @TaxID										Requested by Front End Team
       AND EXISTS (
    SELECT 1
    FROM RateCards.RateValidityMaster RVM
    WHERE RVM.HotelRateDetailID = RCD.HotelRateDetailID
      AND RVM.IsActive = 1
      AND RVM.RateValidFrom <= @CheckOut
      AND RVM.RateValidTo >= @CheckIn
)
UNION

	SELECT
		CHRM.HotelRateID,
		'CustomRateCard' as Type,
		CHRM.HotelID,
		--ISNULL(H.HotelName,'-')+' '+isnull(HR.Code,'') as HotelName,
		ISNULL(H.HotelName,'-')+' '+ CAST(HR.Ratings AS VARCHAR) + '*' as HotelName,
		0 as HotelPreferred,
		CHRM.CityID,
		0 AS HotelRateDetailID,
		RoomCategoryID,
		ISNULL(RoomCat.Name,'-') AS RoomCategory,
		0 as MISSequence,
		'' as Days,
		'' as DaysOfWeek,
		0 as RateCardModeTypeID,
		isnull(MP.Code,'-') as MealPlanCode,
		MP.Breakfast,
		MP.Lunch,
		MP.Dinner,
		0 as TransferID,
		'' as TransferValue,
		-- Flags
		0 AS HasRules,
		0 AS HasDocument,
		0 as OfferTypeID,
		CHRM.CurrencyID as Currency,
		dbo.fnGetPurchaseRate(CHRM.CurrencyID,@CurrencyCode,@CheckIn) as PurchaseRate,
		'' as ValueAddOn,
'' as InfoForOperation,
'' as InfoForRemark,


--		(
--			SELECT 
--				RC.RateCommisionID as RateCommissionID,
--				RCM.CommMasterID as CommissionMasterID,
--				RCM.CommMasterID as MasterCommissionID,
--				RCM.RateType,
        
--				RC.TaxPercentage,
--				RC.TaxAmount,

--				RC.GrossAmountIncludingTax as GrossAmountIncludingTax_Org,
--				dbo.fnSearchCalculateROE(ISNULL(RC.GrossAmountIncludingTax, 0), @CheckIn, C1.Code, @CurrencyCode) AS GrossAmountIncludingTax,

--				RC.GrossAmountExcludingTax as GrossAmountExcludingTax_Org,
--				dbo.fnSearchCalculateROE(ISNULL(RC.GrossAmountExcludingTax, 0), @CheckIn, C1.Code, @CurrencyCode) as GrossAmountExcludingTax,

--				RC.CommisionPercentage,
--				RC.CommissionAmount as CommissionAmount_Org,
--				dbo.fnSearchCalculateROE(ISNULL(RC.CommissionAmount, 0), @CheckIn, C1.Code, @CurrencyCode) AS CommissionAmount,

--				RC.NetAmountIncludingTax as NetAmountIncludingTax_Org,
--				dbo.fnSearchCalculateROE(ISNULL(RC.NetAmountIncludingTax, 0), @CheckIn, C1.Code, @CurrencyCode) as NetAmountIncludingTax,

--				RC.NetAmountExcludingTax as NetAmountExcludingTax_Org,
--				dbo.fnSearchCalculateROE(ISNULL(RC.NetAmountExcludingTax, 0), @CheckIn, C1.Code, @CurrencyCode) as NetAmountExcludingTax,

--				ISNULL(RC.IsTax, 0) as IsTax,
--				ISNULL(RC.IsActive, 0) as IsActive

--			FROM 
--				[CustomRateCards].[HotelRateCommisionDetails] RC WITH (NOLOCK)  
--				LEFT OUTER JOIN RateCommissionMaster RCM WITH (NOLOCK) ON
--				RC.CommissionMasterID = RCM.CommMasterID
--			WHERE 
--				RC.HotelRateID = CHRM.HotelRateId
--				AND RCM.Type = 1
--				AND RC.IsActive = 1
--			FOR JSON PATH
--		) AS CommissionJSON,
(
					SELECT 
						RC.RateCommisionID as RateCommissionID,
						RCM.CommMasterID as CommissionMasterID,
						RCM.CommMasterID as MasterCommissionID,
						RCM.RateType,
        
						RC.TaxPercentage,
						RC.TaxAmount,

						RC.GrossAmountIncludingTax as GrossAmountIncludingTax_Org,

						--dbo.fnSearchCalculateROE(ISNULL(RC.GrossAmountIncludingTax, 0), @CheckIn, C1.Code, @CurrencyCode) AS GrossAmountIncludingTax,
						RC.GrossAmountIncludingTax as GrossAmountIncludingTax,

						RC.GrossAmountExcludingTax as GrossAmountExcludingTax_Org,

						--dbo.fnSearchCalculateROE(ISNULL(RC.GrossAmountExcludingTax, 0), @CheckIn, C1.Code, @CurrencyCode) as GrossAmountExcludingTax,
						RC.GrossAmountExcludingTax as GrossAmountExcludingTax,

						RC.CommisionPercentage,
						RC.CommissionAmount as CommissionAmount_Org,
						--dbo.fnSearchCalculateROE(ISNULL(RC.CommissionAmount, 0), @CheckIn, C1.Code, @CurrencyCode) AS CommissionAmount,
						RC.CommissionAmount as CommissionAmount,

						RC.NetAmountIncludingTax as NetAmountIncludingTax_Org,

						--dbo.fnSearchCalculateROE(ISNULL(RC.NetAmountIncludingTax, 0), @CheckIn, C1.Code, @CurrencyCode) as NetAmountIncludingTax,
						RC.NetAmountIncludingTax as NetAmountIncludingTax,

						RC.NetAmountExcludingTax as NetAmountExcludingTax_Org,

						--dbo.fnSearchCalculateROE(ISNULL(RC.NetAmountExcludingTax, 0), @CheckIn, C1.Code, @CurrencyCode) as NetAmountExcludingTax,
						RC.NetAmountExcludingTax as NetAmountExcludingTax,

						RC.GrossAmountIncludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS GrossAmountIncludingTax_Con,
						RC.GrossAmountExcludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS GrossAmountExcludingTax_Con,
						RC.CommissionAmount * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS CommissionAmount_Con,
						RC.NetAmountIncludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS NetAmountIncludingTax_Con,
						RC.NetAmountExcludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS NetAmountExcludingTax_Con,

						ISNULL(RC.IsTax, 0) as IsTax,
						ISNULL(RC.IsActive, 0) as IsActive

					FROM 
						[CustomRateCards].[HotelRateCommisionDetails] RC WITH (NOLOCK)  
						LEFT OUTER JOIN RateCommissionMaster RCM WITH (NOLOCK) ON
						RC.CommissionMasterID = RCM.CommMasterID
					WHERE 
						RC.HotelRateID = CHRM.HotelRateId
						--AND RCM.Type = 1
						--AND RC.IsActive = 1
						AND (
            NOT EXISTS (SELECT 1 FROM #OccupancyRateTypes)
            OR RCM.RateType IN (SELECT RateType FROM #OccupancyRateTypes)
			)
					FOR JSON PATH
				) AS CommissionJSON,
			-- Meal Overview JSON
--		(
--			SELECT
--				M.HotelRateMealID,
--				0 as HotelRateDetailID,
     
--				MealType.RateType AS MealType,
--				M.GstPercentage,
--				M.GstAmount,

--				-- Conditionally select NetAmount based on @TaxID
--				M.NetAmountIncludingTax as NetAmountIncludingTax_Org,
--				dbo.fnSearchCalculateROE(M.NetAmountIncludingTax, @CheckIn, C1.Code, @CurrencyCode) AS NetAmountIncludingTax,

--				M.NetAmountExcludingTax as NetAmountExcludingTax_Org,
--				dbo.fnSearchCalculateROE(M.NetAmountExcludingTax, @CheckIn, C1.Code, @CurrencyCode) AS NetAmountExcludingTax,

      
--				M.MasterCommissionID,
       
--				M.IsMealDetails,
--				M.DefineAmount
--			FROM 
--				[CustomRateCards].[HotelRateMealOverview] M WITH (NOLOCK)
--				LEFT OUTER JOIN RateCommissionMaster MealType  WITH (NOLOCK) ON M.MasterCommissionID = MealType.CommMasterID
--			WHERE 
--				M.HotelRateID = CHRM.HotelRateID
--				AND M.IsActive = 1
--			FOR JSON PATH
--		) AS MealOverviewJSON,
(
					SELECT
						M.HotelRateMealID,
						0 as HotelRateDetailID,
     
						MealType.RateType AS MealType,
						M.GstPercentage,
						M.GstAmount,

						-- Conditionally select NetAmount based on @TaxID
						M.NetAmountIncludingTax as NetAmountIncludingTax_Org,
						--dbo.fnSearchCalculateROE(M.NetAmountIncludingTax, @CheckIn, C1.Code, @CurrencyCode) AS NetAmountIncludingTax,
						M.NetAmountIncludingTax as NetAmountIncludingTax,

						M.NetAmountExcludingTax as NetAmountExcludingTax_Org,
						--dbo.fnSearchCalculateROE(M.NetAmountExcludingTax, @CheckIn, C1.Code, @CurrencyCode) AS NetAmountExcludingTax,
						M.NetAmountExcludingTax as NetAmountExcludingTax,
						M.NetAmountIncludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS NetAmountIncludingTax_Con,
						M.NetAmountExcludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS NetAmountExcludingTax_Con,
						M.MasterCommissionID,
       
						M.IsMealDetails,
						M.DefineAmount
					FROM 
						[CustomRateCards].[HotelRateMealOverview] M WITH (NOLOCK)
						--LEFT OUTER JOIN RateCommissionMaster MealType  WITH (NOLOCK) ON M.MasterCommissionID = MealType.CommMasterID
						LEFT OUTER JOIN RateCommissionMaster MealType  WITH (NOLOCK) ON M.MealTypeID = MealType.CommMasterID
					WHERE 
						M.HotelRateID = CHRM.HotelRateID
						--AND M.IsActive = 1
					FOR JSON PATH
				) AS MealOverviewJSON,
		'' as OfferConfigurationJSON,
		'' as HotelAnnouncementsJSON,
		'' as ContactDetailsJSON,
		'' as RulesJSON,
		'' as MarketJSON,
		'' as RateSheetJSON,
		CHRM.CreatedOn,
		 0 AS SortOrder
	FROM
		CustomRateCards.HotelRateMaster CHRM WITH (NOLOCK)
		INNER JOIN HotelMaster H WITH (NOLOCK) ON CHRM.HotelID = H.HotelID
		INNER JOIN HotelRating HR WITH (NOLOCK) ON  H.HotelRatingID = HR.ID 
		LEFT OUTER JOIN RoomCategory RoomCat WITH (NOLOCK) ON CHRM.RoomCategoryID = RoomCat.ID
		LEFT OUTER JOIN MealPlan MP WITH (NOLOCK) ON CHRM.MealPlanID = MP.ID AND MP.IsActive = 1
		LEFT OUTER JOIN CurrencyMaster C1 WITH (NOLOCK) ON CHRM.CurrencyID = C1.CurrencyCode
	WHERE
		CHRM.RateType=5
		AND CHRM.IsActive = 1 
  --      AND CHRM.CityID = @CityID
  --      AND (@HotelID IS NULL OR CHRM.HotelID = @HotelID)
		
		--AND (@PreferredHotel IS NULL OR @PreferredHotel = 0 OR CHRM.HotelPreferred = 1)
		AND CHRM.QuotationID=@QuotationID
		AND CAST(CHRM.CheckIn AS DATE) <= CAST(@CheckOut AS DATE)
		AND CAST(CHRM.CheckOut AS DATE) >= CAST(@CheckIn AS DATE)
		AND ((@RatingFrom IS NULL OR @RatingTo IS NULL OR @RatingFrom =0 OR @RatingTo=0) OR (HR.Ratings BETWEEN @RatingFrom AND @RatingTo))
		
		--ORDER BY CreatedOn DESC
		)

		SELECT *
    FROM CombinedRateCards
    ORDER BY SortOrder, CreatedOn DESC;

	

    DROP TABLE #PreferredMarkets;
    DROP TABLE #RateSheets;

	drop table #OccupancyRateTypes
END;


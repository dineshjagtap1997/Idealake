
<<<<<<< HEAD
<<<<<<< HEAD
-- Updated version of [RateCards].[usp_SearchHotelRateCards]
-- Filters logic based on RateCardModeType: executes
-- - First query for 1,2,3
-- - Second query for 4
-- - Both if all are present
-- exec [RateCards].[usp_SearchHotelRateCards] 'BOM','12','2025-07-03T00:00:00','2025-07-03T00:00:00','SGL,DBL','INR','1,2,3',0,0,0,'','','',0
CREATE PROCEDURE [RateCards].[usp_SearchHotelRateCards] @CityID VARCHAR(3)
	,@HotelID BIGINT = NULL
	,@CheckIn DATETIME = NULL
	,@CheckOut DATETIME = NULL
	,@Occupancy VARCHAR(MAX) = NULL
	,@CurrencyCode VARCHAR(10) = 'INR'
	,@RateCardModeType NVARCHAR(MAX) = NULL
	,@TaxID INT = NULL
	,@RatingFrom INT = NULL
	,@RatingTo INT = NULL
	,@MISSequence NVARCHAR(50) = NULL
	,@PreferredMarketIDs VARCHAR(MAX) = NULL
	,@RateSheetIDs VARCHAR(MAX) = NULL
	,@PreferredHotel BIT = NULL
	,@QuotationID INT = NULL
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

CREATE PROCEDURE [RateCards].[usp_SearchHotelRateCards] --@CityID VARCHAR(3)='BOM'
@CityID VARCHAR(3) = 'BOM',
@HotelID BIGINT = 42336,
@CheckIn DATETIME = '2025-08-12T05:09:24.807Z',--'2025-08-02 00:00:00.000',
@CheckOut DATETIME ='2025-09-12T05:09:24.807Z',-- '2025-08-08 00:00:00.000',
@Occupancy VARCHAR(MAX) = '["SGL","DBL","EBA","EBC","CNB"]',--'["SGL","DBL"]',  -- JSON-style array string
@CurrencyCode VARCHAR(10) = 'INR',--'INR',
@RateCardModeType NVARCHAR(MAX) = '1,2,3,4',
@TaxID INT = 0,
@RatingFrom INT = 0,
@RatingTo INT = 0,
@MISSequence NVARCHAR(50) = null,  -- Empty from JSON
@PreferredMarketIDs VARCHAR(MAX) = '',  -- Empty from JSON
@RateSheetIDs VARCHAR(MAX) = '',  -- Empty from JSON
@PreferredHotel BIT = 0,
@QuotationID INT = 0,
@IsFromBooking BIT = NULL,
@BookingID BIGINT = null,
@FIT BIT = 1,
@GIT BIT = NULL,
@BusinessType INT = NULL,
@VendorID BIGINT = NULL,
@HotelRateID bigint =null

<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
AS
BEGIN
	SET NOCOUNT ON;

	-- Temp Tables
	CREATE TABLE #PreferredMarkets (ID INT);

	CREATE TABLE #RateSheets (ID INT);

	CREATE TABLE #OccupancyRateTypes (RateType VARCHAR(10));
<<<<<<< HEAD
<<<<<<< HEAD
=======
		DEclare @RatingFromInt Int =0,@RatingToInt Int =0;
	set @RatingFromInt = case when @RatingFrom >0 then (select Ratings from HotelRating where ID=@RatingFrom) else 0 end 
	set @RatingToInt = case when @RatingTo >0 then (select Ratings from HotelRating where ID=@RatingTo) else 0 end 
>>>>>>> dev
=======
		DEclare @RatingFromInt Int =0,@RatingToInt Int =0;
	set @RatingFromInt = case when @RatingFrom >0 then (select Ratings from HotelRating where ID=@RatingFrom) else 0 end 
	set @RatingToInt = case when @RatingTo >0 then (select Ratings from HotelRating where ID=@RatingTo) else 0 end 
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

	-- Parse PreferredMarketIDs
	IF NULLIF(@PreferredMarketIDs, '') IS NOT NULL
	BEGIN
		INSERT INTO #PreferredMarkets (ID)
		SELECT TRY_CAST(value AS INT)
		FROM STRING_SPLIT(@PreferredMarketIDs, ',')
		WHERE TRY_CAST(value AS INT) IS NOT NULL;
	END

	-- Parse RateSheetIDs
	IF NULLIF(@RateSheetIDs, '') IS NOT NULL
	BEGIN
		INSERT INTO #RateSheets (ID)
		SELECT TRY_CAST(value AS INT)
		FROM STRING_SPLIT(@RateSheetIDs, ',')
		WHERE TRY_CAST(value AS INT) IS NOT NULL;
	END

	-- Parse Occupancy
	IF @Occupancy IS NOT NULL
	BEGIN
<<<<<<< HEAD
<<<<<<< HEAD
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

	IF (@IsFromBooking = 1)
	BEGIN
		INSERT INTO #OccupancyRateTypes (RateType)
		SELECT TRIM(value)
		FROM STRING_SPLIT('SGL,DBL,EBA,EBC,CNB', ',')
		WHERE TRIM(value) <> '';
		END
		ELSE
		BEGIN
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
		INSERT INTO #OccupancyRateTypes (RateType)
		SELECT TRIM(value)
		FROM STRING_SPLIT(@Occupancy, ',')
		WHERE TRIM(value) <> '';
<<<<<<< HEAD
<<<<<<< HEAD
=======
		END
>>>>>>> dev
=======
		END
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
	END

	-- Parse RateCardModeType
	DECLARE @RateCardModeTable TABLE (ModeID INT);

	INSERT INTO @RateCardModeTable (ModeID)
	SELECT DISTINCT TRY_CAST(value AS INT)
	FROM STRING_SPLIT(@RateCardModeType, ',')
	WHERE TRY_CAST(value AS INT) IS NOT NULL;

	DECLARE @HasRegular BIT = 0
		,@HasCustom BIT = 0;

	IF EXISTS (
			SELECT 1
			FROM @RateCardModeTable
			WHERE ModeID IN (
					1
					,2
					,3
					)
			)
		SET @HasRegular = 1;

	IF EXISTS (
			SELECT 1
			FROM @RateCardModeTable
			WHERE ModeID = 4
			)
		SET @HasCustom = 1;

<<<<<<< HEAD
<<<<<<< HEAD
	-- Result staging
=======


>>>>>>> dev
=======


>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
	CREATE TABLE #CombinedRateCards (
		HotelRateID BIGINT
		,Type VARCHAR(50)
		,HotelID BIGINT
		,HotelName NVARCHAR(255)
<<<<<<< HEAD
<<<<<<< HEAD
		,HotelPreferred BIT
		,CityID VARCHAR(10)
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
		,RatingCode INT
		,HotelPreferred INT
		,PreferedDaterange varchar(500)
		,CityID VARCHAR(10)
		,CityName NVARCHAR(100)
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
		,HotelRateDetailID INT
		,RoomCategoryID INT
		,RoomCategory NVARCHAR(100)
		,MISSequence INT
		,Days VARCHAR(10)
		,DaysOfWeek VARCHAR(10)
<<<<<<< HEAD
<<<<<<< HEAD
=======
		,DaysNumber VARCHAR(10)
>>>>>>> dev
=======
		,DaysNumber VARCHAR(10)
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
		,RateCardModeTypeID INT
		,MealPlanCode VARCHAR(50)
		,Breakfast BIT
		,Lunch BIT
		,Dinner BIT
		,TransferID INT
		,TransferValue VARCHAR(100)
		,HasRules BIT
		,HasDocument BIT
		,OfferTypeID INT
		,Currency VARCHAR(10)
		,PurchaseRate DECIMAL(18, 6)
		,ValueAddOn NVARCHAR(MAX)
		,InfoForOperation NVARCHAR(MAX)
		,InfoForRemark NVARCHAR(MAX)
		,CommissionJSON NVARCHAR(MAX)
		,MealOverviewJSON NVARCHAR(MAX)
		,OfferConfigurationJSON NVARCHAR(MAX)
<<<<<<< HEAD
<<<<<<< HEAD
=======
		,HotelOfferRateCardJSON NVARCHAR(MAX)

>>>>>>> dev
=======
		,HotelOfferRateCardJSON NVARCHAR(MAX)

>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
		,HotelAnnouncementsJSON NVARCHAR(MAX)
		,ContactDetailsJSON NVARCHAR(MAX)
		,RulesJSON NVARCHAR(MAX)
		,MarketJSON NVARCHAR(MAX)
		,RateSheetJSON NVARCHAR(MAX)
		,CreatedOn DATETIME
<<<<<<< HEAD
<<<<<<< HEAD
		,SortOrder INT
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
		,CreatedBy uniqueidentifier
		,UserName NVARCHAR(max)
		,HotelType NVARCHAR(100)
		,ZoneName NVARCHAR(100)
		,VendorName NVARCHAR(100)
		,ExtraBedMattress NVARCHAR(50)
		,CreditApplicable BIT
		,CreditCurrencyCode VARCHAR(10)
		,CreditPeriod INT
		,CreditAmount DECIMAL(18, 2)
		,CreditApproveBy NVARCHAR(100)
		,EmailFinance NVARCHAR(100)
		,SortOrder INT
		,CardNumber NVARCHAR(500)
		 ,BookFrom VARCHAR(10),      -- Added
    BookTo VARCHAR(10)
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
		);

	-- First query (RateCards.HotelRateMaster)
	IF @HasRegular = 1
	BEGIN
<<<<<<< HEAD
<<<<<<< HEAD
		SELECT HRM.HotelRateID
			,'RateCard' AS Type
			,H.HotelID
			,
			--H.HotelName+' '+isnull(HR.Code,'') as HotelName,
			H.HotelName + ' ' + CAST(HR.Code AS VARCHAR) + '*' AS HotelName
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
	

		INSERT INTO #CombinedRateCards (
			HotelRateID
			,Type
			,HotelID
			,HotelName
			,RatingCode
			,HotelPreferred
			,PreferedDaterange
			,CityID
			,CityName
			,HotelRateDetailID
			,RoomCategoryID
			,RoomCategory
			,MISSequence
			,Days
			,DaysOfWeek
			,DaysNumber
			,RateCardModeTypeID
			,MealPlanCode
			,Breakfast
			,Lunch
			,Dinner
			,TransferID
			,TransferValue
			,HasRules
			,HasDocument
			,OfferTypeID
			,Currency
			,PurchaseRate
			,ValueAddOn
			,InfoForOperation
			,InfoForRemark
			,CommissionJSON
			,MealOverviewJSON
			,OfferConfigurationJSON
			,HotelOfferRateCardJSON
			,HotelAnnouncementsJSON
			,ContactDetailsJSON
			,RulesJSON
			,MarketJSON
			,RateSheetJSON
			,CreatedOn
			,CreatedBy
			,UserName
			,HotelType
			,ZoneName
			,VendorName
			,ExtraBedMattress
			,CreditApplicable
			,CreditCurrencyCode
			,CreditPeriod
			,CreditAmount
			,CreditApproveBy
			,EmailFinance
			,SortOrder
			,CardNumber
			 ,BookFrom
			  ,BookTo
			)
		SELECT HRM.HotelRateID
			,'RateCard' AS Type
			,H.HotelID
			--,H.HotelName + ' ' + CAST(HR.Code AS VARCHAR) + '*' AS HotelName,
			,H.HotelName + ' ' + CAST(HR.Code AS VARCHAR)  AS HotelName,
			HR.ratings as RatingCode
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
			,CASE 
				WHEN EXISTS (
						SELECT 1
						FROM HotelPreferred HP
						WHERE HP.HotelID = H.HotelID
							AND HP.IsPreferred = 1
							AND CONVERT(DATE, @CheckIn) >= CONVERT(DATE, HP.ValidFrom)
							AND CONVERT(DATE, @CheckOut) <= CONVERT(DATE, HP.ValidTo)
						)
					THEN 1
				ELSE 0
<<<<<<< HEAD
<<<<<<< HEAD
				END AS HotelPreferred
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
				END AS HotelPreferred,

				(
						SELECT Convert(Varchar(500), HP.ValidFrom)+'-'+ Convert(Varchar(500),HP.ValidTo)
						FROM HotelPreferred HP
						WHERE HP.HotelID = H.HotelID
							AND HP.IsPreferred = 1
							AND CONVERT(DATE, @CheckIn) >= CONVERT(DATE, HP.ValidFrom)
							AND CONVERT(DATE, @CheckOut) <= CONVERT(DATE, HP.ValidTo)
						) AS PreferedDaterange

<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
			,HRM.CityID
			,C.Name as CityName
			,RCD.HotelRateDetailID
			,RCD.RoomCategoryID
			,RoomCat.Name AS RoomCategory
			,RCD.MISSequence
			,RCD.Days
			,CONCAT (
				CASE 
					WHEN SUBSTRING(RCD.Days, 1, 1) = '1'
						THEN 'M'
					ELSE ''
					END
				,CASE 
					WHEN SUBSTRING(RCD.Days, 2, 1) = '1'
						THEN 'T'
					ELSE ''
					END
				,CASE 
					WHEN SUBSTRING(RCD.Days, 3, 1) = '1'
						THEN 'W'
					ELSE ''
					END
				,CASE 
					WHEN SUBSTRING(RCD.Days, 4, 1) = '1'
						THEN 'T'
					ELSE ''
					END
				,CASE 
					WHEN SUBSTRING(RCD.Days, 5, 1) = '1'
						THEN 'F'
					ELSE ''
					END
				,CASE 
					WHEN SUBSTRING(RCD.Days, 6, 1) = '1'
						THEN 'S'
					ELSE ''
					END
				,CASE 
					WHEN SUBSTRING(RCD.Days, 7, 1) = '1'
						THEN 'S'
					ELSE ''
					END
<<<<<<< HEAD
<<<<<<< HEAD
				) AS DaysOfWeek
			,HRM.RateCardModeTypeID
			,
			-- New: MealPlan info
			MP.Code AS MealPlanCode
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
				) AS DaysOfWeek,
				CASE WHEN RCD.DAYS = '1111111' THEN 'ALL'
				ELSE
					CONCAT (
					CASE 
						WHEN SUBSTRING(RCD.Days, 1, 1) = '1'
							THEN '1'
						ELSE '-'
						END
					,CASE 
						WHEN SUBSTRING(RCD.Days, 2, 1) = '1'
							THEN '2'
						ELSE '-'
						END
					,CASE 
						WHEN SUBSTRING(RCD.Days, 3, 1) = '1'
							THEN '3'
						ELSE '-'
						END
					,CASE 
						WHEN SUBSTRING(RCD.Days, 4, 1) = '1'
							THEN '4'
						ELSE '-'
						END
					,CASE 
						WHEN SUBSTRING(RCD.Days, 5, 1) = '1'
							THEN '5'
						ELSE '-'
						END
					,CASE 
						WHEN SUBSTRING(RCD.Days, 6, 1) = '1'
							THEN '6'
						ELSE '-'
						END
					,CASE 
						WHEN SUBSTRING(RCD.Days, 7, 1) = '1'
							THEN '7'
						ELSE '-'
						END
					)
				END AS DaysNumber
			,HRM.RateCardModeTypeID
			,MP.Code AS MealPlanCode
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
			,MP.Breakfast
			,MP.Lunch
			,MP.Dinner
			,RCD.TransferID
			,TM.TransferValue
<<<<<<< HEAD
<<<<<<< HEAD
			,
			-- Flags
			ISNULL(CAST((
=======
			,ISNULL(CAST((
>>>>>>> dev
=======
			,ISNULL(CAST((
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
						SELECT CASE 
								WHEN EXISTS (
										SELECT 1
										FROM RateCards.Rules
										WHERE RateCardID = HRM.HotelRateID
										)
									THEN 1
								ELSE 0
								END
						) AS BIT), 0) AS HasRules
			,ISNULL(CAST((
						SELECT TOP 1 1
						FROM dbo.LinkedDocuments ld
						INNER JOIN dbo.UploadDocuments ud ON ld.DocumentID = ud.DocumentID
						WHERE ld.ParentID = HRM.HotelRateID
							AND ud.ParentTypeID = 1
						) AS BIT), 0) AS HasDocument
			,RCD.OfferTypeID
			,HRM.CurrencyID AS Currency
			,dbo.fnGetPurchaseRate(HRM.CurrencyID, @CurrencyCode, @CheckIn) AS PurchaseRate
			,HRM.ValueAddOn
			,HRM.InfoForOperation
			,HRM.InfoForRemark
			,(
				SELECT RC.RateCommisionID AS RateCommissionID
					,RCM.CommMasterID AS CommissionMasterID
					,RCM.CommMasterID AS MasterCommissionID
					,RCM.RateType
					,RC.TaxPercentage
					,RC.TaxAmount
					,RC.GrossAmountIncludingTax AS GrossAmountIncludingTax
<<<<<<< HEAD
<<<<<<< HEAD
					,
					--dbo.fnSearchCalculateROE(ISNULL(RC.GrossAmountIncludingTax, 0), @CheckIn, C1.Code, @CurrencyCode) AS GrossAmountIncludingTax,
					RC.GrossAmountIncludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS GrossAmountIncludingTax_Con
					,RC.GrossAmountExcludingTax AS GrossAmountExcludingTax
					,
					--dbo.fnSearchCalculateROE(ISNULL(RC.GrossAmountExcludingTax, 0), @CheckIn, C1.Code, @CurrencyCode) as GrossAmountExcludingTax,
					RC.GrossAmountExcludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS GrossAmountExcludingTax_Con
					,RC.CommisionPercentage
					,RC.CommissionAmount AS CommissionAmount
					,
					--dbo.fnSearchCalculateROE(ISNULL(RC.CommissionAmount, 0), @CheckIn, C1.Code, @CurrencyCode) AS CommissionAmount,
					RC.CommissionAmount * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS CommissionAmount_Con
					,RC.NetAmountIncludingTax AS NetAmountIncludingTax
					,
					--dbo.fnSearchCalculateROE(ISNULL(RC.NetAmountIncludingTax, 0), @CheckIn, C1.Code, @CurrencyCode) as NetAmountIncludingTax,
					RC.NetAmountIncludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS NetAmountIncludingTax_Con
					,RC.NetAmountExcludingTax AS NetAmountExcludingTax
					,
					--dbo.fnSearchCalculateROE(ISNULL(RC.NetAmountExcludingTax, 0), @CheckIn, C1.Code, @CurrencyCode) as NetAmountExcludingTax,
					RC.NetAmountExcludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS NetAmountExcludingTax_Con
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
					,RC.GrossAmountIncludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS GrossAmountIncludingTax_Con
					,RC.GrossAmountExcludingTax AS GrossAmountExcludingTax
					,RC.GrossAmountExcludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS GrossAmountExcludingTax_Con
					,RC.CommisionPercentage
					,RC.CommissionAmount AS CommissionAmount
					,RC.CommissionAmount * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS CommissionAmount_Con
					,RC.NetAmountIncludingTax AS NetAmountIncludingTax
					,RC.NetAmountIncludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS NetAmountIncludingTax_Con
					,RC.NetAmountExcludingTax AS NetAmountExcludingTax
					,RC.NetAmountExcludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS NetAmountExcludingTax_Con
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
					,ISNULL(RC.IsTax, 0) AS IsTax
					,ISNULL(RC.IsActive, 0) AS IsActive
				FROM RateCards.RateCommisionDetails RC
				INNER JOIN RateCommissionMaster RCM ON RC.CommissionMasterID = RCM.CommMasterID
				WHERE RC.HotelRateDetailID = RCD.HotelRateDetailID
					AND RC.IsActive = 1
<<<<<<< HEAD
<<<<<<< HEAD
					AND (
						NOT EXISTS (
							SELECT 1
							FROM #OccupancyRateTypes
							)
						OR RCM.RateType IN (
							SELECT RateType
							FROM #OccupancyRateTypes
							)
						)
				--FROM RateCommissionMaster RCM
				--LEFT JOIN RateCards.RateCommisionDetails RC 
				--    ON RC.CommissionMasterID = RCM.CommMasterID 
				--    AND RC.HotelRateDetailID = RCD.HotelRateDetailID
				--    AND RC.IsActive = 1
				--WHERE RCM.Type = 1
				FOR JSON PATH
				) AS CommissionJSON
			,
			--  
			(
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
					--AND (
					--	NOT EXISTS (
					--		SELECT 1
					--		FROM #OccupancyRateTypes
					--		)
					--	OR RCM.RateType IN (
					--		SELECT RateType
					--		FROM #OccupancyRateTypes
					--		)
					--	)
				FOR JSON PATH
				) AS CommissionJSON
			,(
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
				SELECT M.HotelRateMealID
					,M.HotelRateDetailID
					,MealType.RateType AS MealType
					,M.GstPercentage
					,M.GstAmount
<<<<<<< HEAD
<<<<<<< HEAD
					,
					-- Conditionally select NetAmount based on @TaxID
					M.NetAmountIncludingTax AS NetAmountIncludingTax
					,
					--dbo.fnSearchCalculateROE(M.NetAmountIncludingTax, @CheckIn, C1.Code, @CurrencyCode) AS NetAmountIncludingTax,
					M.NetAmountIncludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS NetAmountIncludingTax_Con
					,M.NetAmountExcludingTax AS NetAmountExcludingTax
					,
					--dbo.fnSearchCalculateROE(M.NetAmountExcludingTax, @CheckIn, C1.Code, @CurrencyCode) AS NetAmountExcludingTax,
					M.NetAmountExcludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS NetAmountExcludingTax_Con
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
					,M.NetAmountIncludingTax AS NetAmountIncludingTax
					,M.NetAmountIncludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS NetAmountIncludingTax_Con
					,M.NetAmountExcludingTax AS NetAmountExcludingTax
					,M.NetAmountExcludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS NetAmountExcludingTax_Con
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
					,M.MasterCommissionID
					,M.IsMealDetails
					,M.DefineAmount
				FROM RateCards.HotelMealOverviewMaster M
<<<<<<< HEAD
<<<<<<< HEAD
				LEFT JOIN RateCommissionMaster MealType ON M.MasterCommissionID = MealType.CommMasterID
=======
				INNER JOIN RateCommissionMaster MealType ON M.MasterCommissionID = MealType.CommMasterID
>>>>>>> dev
=======
				INNER JOIN RateCommissionMaster MealType ON M.MasterCommissionID = MealType.CommMasterID
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
				WHERE M.HotelRateDetailID = RCD.HotelRateDetailID
					AND M.IsActive = 1
				FOR JSON PATH
				) AS MealOverviewJSON
			,(
				SELECT OC.OfferID
					,OC.HotelRateDetailID
					,OC.Days
					,OC.FromDate
					,OC.ToDate
					,OC.TotalNights
					,OC.PaidNights
					,OC.FreeNights
					,OC.IsExtendible
					,OC.IsActive
<<<<<<< HEAD
<<<<<<< HEAD
					,
					-- OfferType label based on OfferTypeID from parent RCD
					CASE 
=======
					,CASE 
>>>>>>> dev
=======
					,CASE 
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
						WHEN RCD.OfferTypeID = 1
							THEN 'EBO'
						WHEN RCD.OfferTypeID = 2
							THEN 'PayOnStay'
						ELSE 'Unknown'
						END AS OfferType
<<<<<<< HEAD
<<<<<<< HEAD
					,
					-- Offer Commission as nested JSON array including RateType
					(
=======
					,(
>>>>>>> dev
=======
					,(
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
						SELECT OCC.OfferCommissionID
							,OCC.OfferConfigurationID
							,OCC.MasterCommissionID
							,RCM.RateType
<<<<<<< HEAD
<<<<<<< HEAD
							,-- added from RateCommissionMaster
							OCC.Discount
=======
							,OCC.Discount
>>>>>>> dev
=======
							,OCC.Discount
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
							,OCC.DiscountAmount
							,OCC.Tax
							,OCC.TaxAmount
							,OCC.PaidNightAmountExcludingTax
							,OCC.PaidNightAmountExcludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS PaidNightAmountExcludingTax_Con
							,OCC.PaidNightAmountIncludingTax
							,OCC.PaidNightAmountIncludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS PaidNightAmountIncludingTax_Con
							,OCC.FreeNightAmountExcludingTax
							,OCC.FreeNightAmountExcludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS FreeNightAmountExcludingTax_Con
							,OCC.FreeNightAmountIncludingTax
							,OCC.FreeNightAmountIncludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS FreeNightAmountIncludingTax_Con
							,OCC.GrossAmountExcludingTax
							,OCC.GrossAmountExcludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS GrossAmountExcludingTax_Con
							,OCC.GrossAmountIncludingTax
							,OCC.GrossAmountIncludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS GrossAmountIncludingTax_Con
							,OCC.NetAmountExcludingTax
							,OCC.NetAmountExcludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS NetAmountExcludingTax_Con
							,OCC.NetAmountIncludingTax
							,OCC.NetAmountIncludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS NetAmountIncludingTax_Con
							,OCC.IsActive
						FROM RateCards.HotelRateOfferConfigurationCommission OCC
<<<<<<< HEAD
<<<<<<< HEAD
						LEFT JOIN RateCommissionMaster RCM ON OCC.MasterCommissionID = RCM.CommMasterID
=======
						INNER JOIN RateCommissionMaster RCM ON OCC.MasterCommissionID = RCM.CommMasterID
>>>>>>> dev
=======
						INNER JOIN RateCommissionMaster RCM ON OCC.MasterCommissionID = RCM.CommMasterID
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
						WHERE OCC.OfferConfigurationID = OC.OfferID
							AND OCC.IsActive = 1
							AND (
								OCC.IsDeleted = 0
								OR OCC.IsDeleted IS NULL
								)
							AND ISNULL(OCC.IsDeleted, 0) <> 1
<<<<<<< HEAD
<<<<<<< HEAD
						FOR JSON PATH
=======
										FOR JSON PATH
>>>>>>> dev
=======
										FOR JSON PATH
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
						) AS OfferCommission
				FROM RateCards.HotelRateOfferConfiguration OC
				WHERE OC.HotelRateDetailID = RCD.HotelRateDetailID
					AND OC.IsActive = 1
					AND ISNULL(OC.IsDeleted, 0) <> 1
<<<<<<< HEAD
<<<<<<< HEAD
				FOR JSON PATH
				) AS OfferConfigurationJSON
			,
			-- Hotel Announcements JSON
			(
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
					AND (
       (RCD.OfferTypeID = 1 AND DATEDIFF(DAY, GETDATE(), @CheckIn) >= OC.Days)

        OR (RCD.OfferTypeID = 2 AND DATEDIFF(DAY, @CheckIn, @CheckOut) >= OC.TotalNights)
    )
			
				FOR JSON PATH
				) AS OfferConfigurationJSON,
				(SELECT HotelOfferJSON
    FROM [RateCards].[fn_GetHotelOfferJSON](H.HotelID, @CheckIn, @CheckOut)
				) AS HotelOfferRateCardJSON
			,(
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
				SELECT C.Name AS City
					,HA.AnnouncementDetails
					,CONVERT(VARCHAR(12), HA.ValidTo, 106) AS ValidTill
					,HA.AnnouncementID
					,HA.ValidTo
				FROM HotelAnnouncement HA
				INNER JOIN City C ON C.IATACode = H.CityIATACode
<<<<<<< HEAD
<<<<<<< HEAD
				WHERE HA.HotelID = H.HotelID
				FOR JSON PATH
				) AS HotelAnnouncementsJSON
			,
			-- Contact Details JSON
			(
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
				WHERE HA.HotelID = HRM.HotelID
				FOR JSON PATH
				) AS HotelAnnouncementsJSON
			,(
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
				SELECT Country.IATACode
					,CD.FirstName
					,CD.LastName
					,H.HotelName AS DisplayName
					,CD.CityIATACode
					,City.Name AS CityName
					,CD.DesignationOrDepartment
					,CD.EmailID
					,CD.ContactDetailsID
					,CD.DateofBirth
					,CD.CreatedBy
					,H.FaxNo
					,H.HotelID
					,CD.IsPrimaryContact
					,CD.IsForContracting
					,CD.IsCC
					,CD.IsActive
					,CD.IsBills
					,CD.IsAccStatement
					,CD.InsertedDate
					,CD.TypeID
					,CD.SalutationID
					,CD.ParentID
					,CD.OfficeNo
					,CD.MobileNo
				FROM ContactDetails CD
				INNER JOIN City ON CD.CityIATACode = City.IATACode
				INNER JOIN STATE ON City.State_IATACode = STATE.State_ID
				INNER JOIN Country ON STATE.Country_IATACode = Country.IATACode
				WHERE CD.TypeID = 1
					AND CD.ParentID = H.HotelID
				FOR JSON PATH
				) AS ContactDetailsJSON
<<<<<<< HEAD
<<<<<<< HEAD
			,
			-- Rules JSON
			(
=======
			,(
>>>>>>> dev
=======
			,(
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
				SELECT rul.ID
					,rul.RateCardTypeID
					,rul.RateCardID
					,rul.RuleID
					,rg.Name AS [Rule]
					,rul.MISSeqeunce AS MISSequence
					,CASE 
						WHEN rul.ApplicableID = '1'
							THEN 'ALL'
						WHEN rul.ApplicableID = '2'
							THEN 'B2B Agent'
						WHEN rul.ApplicableID = '3'
							THEN 'Operations'
						END AS Applicable
					,rul.ApplicableID
					,rul.[Description]
					,rul.IsActive
				FROM RateCards.Rules rul
				LEFT JOIN RuleGroups rg ON rg.ID = rul.RuleID
				WHERE rul.RateCardID = HRM.HotelRateID
					AND rul.RateCardTypeID = 1
				FOR JSON PATH
				) AS RulesJSON
<<<<<<< HEAD
<<<<<<< HEAD
			,
			-- Market JSON: joined via MasterID
			(
				SELECT MKT.MarketRateID
				FROM RateCards.HotelRateMarketMasterLookup MKT
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
			,(
				SELECT MKT.MarketRateID,
				M.Name as MarketName
				FROM RateCards.HotelRateMarketMasterLookup MKT
				inner join dbo.Market M on M.ID = MKT.MarketRateID
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
				WHERE MKT.HotelRateID = HRM.HotelRateID
					AND MKT.IsActive = 1
				FOR JSON PATH
				) AS MarketJSON
<<<<<<< HEAD
<<<<<<< HEAD
			,
			-- RateSheet JSON: joined via MasterID
			(
=======
			,(
>>>>>>> dev
=======
			,(
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
				SELECT RS.RateSheetID
				FROM RateCards.HotelRatesheetMasterLookup RS
				WHERE RS.HotelRateID = HRM.HotelRateID
					AND RS.IsActive = 1
				FOR JSON PATH
				) AS RateSheetJSON
			,HRM.CreatedOn
<<<<<<< HEAD
<<<<<<< HEAD
			,1 AS SortOrder
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
			,HRM.CreatedBy
			,EM.EmpName as UserName
			,HTM.TypeValue as HotelType
			,ZM.ZoneName
			,VM.VendorName
			,CASE WHEN HRC.ExtraBedMattress=0 THEN 'Not Defined'                                              
   WHEN HRC.ExtraBedMattress=1 THEN 'NA'                                                    
   WHEN HRC.ExtraBedMattress=2 THEN 'Bed'                                                    
   WHEN HRC.ExtraBedMattress=3 THEN 'Mattress'END AS ExtraBedMattress
   ,H.CreditApplicable
   ,H.CreditCurrencyCode
   ,H.CreditPeriod
   ,H.CreditAmount
   ,H.CreditApproveBy
   ,H.EmailFinance
			,1 AS SortOrder
			,TRIM(HRM.CardNumber) as CardNumber,
			ISNULL(CONVERT(VARCHAR(10), RV.BookFrom, 105), '') AS BookFrom,
    ISNULL(CONVERT(VARCHAR(10), RV.BookTo, 105), '') AS BookTo

<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
		FROM RateCards.HotelRateMaster HRM
		INNER JOIN RateCards.HotelRateDetails RCD ON HRM.HotelRateID = RCD.HotelRateID
		INNER JOIN HotelMaster H ON HRM.HotelID = H.HotelID
		INNER JOIN HotelRating HR ON HR.ID = H.HotelRatingID
<<<<<<< HEAD
<<<<<<< HEAD
		INNER JOIN CurrencyMaster C1 ON HRM.CurrencyID = C1.CurrencyCode
		LEFT JOIN City c on c.IATACode=HRM.CityID
		LEFT JOIN HotelRoomCategory HRC ON HRM.HotelID = HRC.HotelID
			AND HRC.RoomCategoryID = RCD.RoomCategoryID
			AND HRC.IsActive = 1
		LEFT JOIN RoomCategory RoomCat ON RCD.RoomCategoryID = RoomCat.ID
		LEFT JOIN MealPlan MP ON RCD.MealPlanID = MP.ID
			AND MP.IsActive = 1
		LEFT JOIN dbo.TransferMaster TM ON RCD.TransferID = TM.TransferID
		WHERE HRM.IsActive = 1
			AND RCD.IsActive = 1
			AND (DATEDIFF(DAY, @CheckIn, @CheckOut) between RCD.MinNights and RCD.MaxNights)
			AND (HRM.CityID = @CityID)
			AND (
				@HotelID IS NULL OR @HotelID =0
				OR HRM.HotelID = @HotelID
				)
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
		INNER JOIN HotelTypeMaster HTM ON HTM.HotelTypeID = H.HotelTypeID
		INNER JOIN CurrencyMaster C1 ON HRM.CurrencyID = C1.CurrencyCode
		OUTER APPLY (
	SELECT TOP 1
		RVM.BookFrom,
		RVM.BookTo
	FROM RateCards.RateValidityMaster RVM
	WHERE RVM.HotelRateDetailID = RCD.HotelRateDetailID
		AND RVM.IsActive = 1
		AND CONVERT(INT, FORMAT(@CheckIn, 'yyyyMMdd')) >= CONVERT(INT, FORMAT(RVM.RateValidFrom, 'yyyyMMdd'))
		AND CONVERT(INT, FORMAT(@CheckOut, 'yyyyMMdd')) <= CONVERT(INT, FORMAT(RVM.RateValidTo, 'yyyyMMdd'))
	ORDER BY RVM.RateValidFrom -- or RateValidTo based on requirement
) RV
		--LEFT JOIN RateCards.RateValidityMaster RV ON RV.HotelRateDetailID = RCD.HotelRateDetailID

		Inner JOIN City c on c.IATACode=HRM.CityID
		Inner JOIN HotelRoomCategory HRC ON HRM.HotelID = HRC.HotelID
			AND HRC.RoomCategoryID = RCD.RoomCategoryID
			AND HRC.IsActive = 1
		Inner JOIN RoomCategory RoomCat ON RCD.RoomCategoryID = RoomCat.ID
		Inner JOIN MealPlan MP ON RCD.MealPlanID = MP.ID
			AND MP.IsActive = 1
		Inner JOIN dbo.TransferMaster TM ON RCD.TransferID = TM.TransferID
		LEFT JOIN dbo.ZoneMaster ZM ON ZM.ZoneID = H.ZoneID
		LEFT join dbo.VendorMaster VM on VM.VendorID= HRM.VendorID
		inner Join dbo.EmployeeMaster EM on EM.UserID=HRM.CreatedBy
		WHERE (HRM.HotelRateID=@HotelRateID and (Isnull(@HotelRateID,0)<>0)  ) or((Isnull(@HotelRateID,0)=0) and (HRM.IsActive = 1	
			AND RCD.IsActive = 1
			--AND (DATEDIFF(DAY, @CheckIn, @CheckOut) between RCD.MinNights and RCD.MaxNights)
			AND (
				(RCD.MinNights = 0 AND RCD.MaxNights = 0)OR
				(CASE 
					WHEN @CheckIn = @CheckOut THEN 1 
					ELSE DATEDIFF(DAY, @CheckIn, @CheckOut) 
					END BETWEEN RCD.MinNights AND RCD.MaxNights)
				)
			--AND (HRM.CityID = @CityID)
			--AND (
			--	@HotelID IS NULL OR @HotelID =0
			--	OR HRM.HotelID = @HotelID
			--	)



<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
			AND HRM.RateCardModeTypeID IN (
				SELECT ModeID
				FROM @RateCardModeTable
				)
			AND (
				@MISSequence IS NULL
				OR @MISSequence = 0
<<<<<<< HEAD
<<<<<<< HEAD
				OR LTRIM(RTRIM(@MISSequence)) = ''
				OR RCD.MISSequence = @MISSequence
				)
			----AND (@PreferredHotel IS NULL OR @PreferredHotel = 0 OR H.HotelPreferred = 1)
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
				----OR LTRIM(RTRIM(@MISSequence)) = ''
				OR Convert(int,RCD.MISSequence) <= Convert(int,@MISSequence) 
				----OR Convert(int,RCD.MISSequence) <= Convert(int,@MISSequence) 

				)
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
			AND (
				@PreferredHotel IS NULL
				OR( @PreferredHotel = 0 )
				OR (@PreferredHotel = 1 AND EXISTS (
					SELECT 1
					FROM HotelPreferred HP
					WHERE HP.HotelID = H.HotelID
						AND HP.IsPreferred = 1
						AND CONVERT(DATE, @CheckIn) >= CONVERT(DATE, HP.ValidFrom)
						AND CONVERT(DATE, @CheckOut) <= CONVERT(DATE, HP.ValidTo)
					))
				)
<<<<<<< HEAD
<<<<<<< HEAD
			AND (
				(
					@RatingFrom IS NULL
					OR @RatingTo IS NULL
					OR @RatingFrom = 0
					OR @RatingTo = 0
					)
				OR (
					HR.Ratings BETWEEN @RatingFrom
						AND @RatingTo
					)
				)
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

				AND (
    ((@RatingFrom > 0 OR @RatingTo > 0)
    AND HR.Ratings BETWEEN 
        ISNULL(NULLIF(@RatingFromInt, 0), 1) 
        AND @RatingToInt)    
	OR(@RatingToInt =0 and @RatingFromInt > 0 and HR.Ratings>=@RatingFromInt)
	OR(@RatingFromInt=0 and @RatingToInt> 0  and HR.Ratings<=@RatingFromInt)
	OR (@RatingFrom IS NULL AND @RatingTo IS NULL)
    OR (@RatingFrom = 0 AND @RatingTo = 0)
)

			--AND (
			--	(
			--		@RatingFrom IS NULL
			--		OR @RatingTo IS NULL
			--		OR @RatingFrom = 0
			--		OR @RatingTo = 0
			--		)
			--	OR (
			--		HR.Ratings BETWEEN @RatingFrom
			--			AND @RatingTo
			--		)
			--	)
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
			AND (
				NOT EXISTS (
					SELECT 1
					FROM #PreferredMarkets
					)
				OR EXISTS (
					SELECT 1
					FROM #PreferredMarkets PM
					INNER JOIN RateCards.HotelRateMarketMasterLookup MKT ON MKT.MarketRateID = PM.ID
					WHERE MKT.HotelRateID = HRM.HotelRateID
						AND MKT.IsActive = 1
					)
				)
			AND (
				NOT EXISTS (
					SELECT 1
					FROM #RateSheets
					)
				OR EXISTS (
					SELECT 1
					FROM #RateSheets RS
					INNER JOIN RateCards.HotelRatesheetMasterLookup Sheet ON Sheet.RateSheetID = RS.ID
					WHERE Sheet.HotelRateID = HRM.HotelRateID
						AND Sheet.IsActive = 1
					)
				)
<<<<<<< HEAD
<<<<<<< HEAD
			------AND SUBSTRING(RCD.Days, DATEPART(WEEKDAY, @CheckIn), 1) = '1'
			------AND HRM.PaymentTypeID = @TaxID										Requested by Front End Team
=======
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
			AND EXISTS (
				SELECT 1
				FROM RateCards.RateValidityMaster RVM
				WHERE RVM.HotelRateDetailID = RCD.HotelRateDetailID
<<<<<<< HEAD
<<<<<<< HEAD
					AND RVM.IsActive = 1
					--AND CONVERT(DATE, @CheckIn) >= CONVERT(DATE, RVM.RateValidFrom)
					--AND CONVERT(DATE, @CheckOut) <= CONVERT(DATE, RVM.RateValidTo)
					AND  Convert(int,Format(@CheckIn,'yyyyMMdd')) >=  Convert(int,Format(RVM.RateValidFrom,'yyyyMMdd'))
					AND  Convert(int,Format(@CheckOut,'yyyyMMdd'))<=   Convert(int,Format(RVM.RateValidTo,'yyyyMMdd'))

					--AND RVM.RateValidFrom <= @CheckOut
					--AND RVM.RateValidTo >= @CheckIn
				)
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
				AND RVM.IsActive = 1
					AND  Convert(int,Format(@CheckIn,'yyyyMMdd')) >=  Convert(int,Format(RVM.RateValidFrom,'yyyyMMdd'))
					AND  Convert(int,Format(@CheckOut,'yyyyMMdd'))<=   Convert(int,Format(RVM.RateValidTo,'yyyyMMdd'))
				)

			AND( (( HRM.BookingID=@BookingID and HRM.RateCardModeTypeID=3) or(HRM.BookingID is null and HRM.RateCardModeTypeID in (1,2,3,4))) or (@BookingID is null) or (@BookingID =0 ))

AND ((@FIT IS NULL OR RCD.FIT = @FIT)
OR (@GIT IS NULL OR RCD.GIT = @GIT))
AND (
    (@BusinessType IS NULL OR @BusinessType <> 1) -- no filter if not 1
    OR RCD.BusinessType = 1
)
AND (@VendorID IS NULL OR @VendorID = 0 OR HRM.VendorID = @VendorID)
	
			
AND (
    @CityID IS NULL OR LTRIM(RTRIM(@CityID)) = '' OR HRM.CityID = @CityID
)
AND (
    @HotelID IS NULL OR @HotelID = 0 OR HRM.HotelID = @HotelID
)		)	)
ORDER BY 
HR.Ratings DESC,
H.HotelName ASC,
RCD.MISSequence,
RV.RateValidFrom ASC,
HRM.HotelRateID
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
	END

	-- Second query (CustomRateCards.HotelRateMaster)
	IF @HasCustom = 1
	BEGIN
<<<<<<< HEAD
<<<<<<< HEAD
		SELECT CHRM.HotelRateID
			,'CustomRateCard' AS Type
			,CHRM.HotelID
			,
			--ISNULL(H.HotelName,'-')+' '+isnull(HR.Code,'') as HotelName,
			ISNULL(H.HotelName, '-') + ' ' + CAST(HR.Code AS VARCHAR) + '*' AS HotelName
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
		


		INSERT INTO #CombinedRateCards (
			HotelRateID
			,Type
			,HotelID
			,HotelName
			,RatingCode
			,HotelPreferred
			,CityID
			,CityName
			,HotelRateDetailID
			,RoomCategoryID
			,RoomCategory
			,MISSequence
			,Days
			,DaysOfWeek
			,RateCardModeTypeID
			,MealPlanCode
			,Breakfast
			,Lunch
			,Dinner
			,TransferID
			,TransferValue
			,HasRules
			,HasDocument
			,OfferTypeID
			,Currency
			,PurchaseRate
			,ValueAddOn
			,InfoForOperation
			,InfoForRemark
			,CommissionJSON
			,MealOverviewJSON
			,OfferConfigurationJSON
			,HotelOfferRateCardJSON
			,HotelAnnouncementsJSON
			,ContactDetailsJSON
			,RulesJSON
			,MarketJSON
			,RateSheetJSON
			,CreatedOn
			,CreatedBy
			,HotelType
			,ZoneName
			,VendorName
			,ExtraBedMattress
			,CreditApplicable
			,CreditCurrencyCode
			,CreditPeriod
			,CreditAmount
			,CreditApproveBy
			,EmailFinance
			,SortOrder
			,CardNumber
			, BookFrom
    ,BookTo
			)
		SELECT CHRM.HotelRateID
			,'CustomRateCard' AS Type
			,CHRM.HotelID
			,H.HotelName + ' ' + CAST(HR.Code AS VARCHAR) AS HotelName,
			HR.Ratings as RatingCode
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
			,0 AS HotelPreferred
			,CHRM.CityID
			,C.Name as CityName
			,0 AS HotelRateDetailID
<<<<<<< HEAD
<<<<<<< HEAD
			,RoomCategoryID
=======
			,CHRM.RoomCategoryID
>>>>>>> dev
=======
			,CHRM.RoomCategoryID
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
			,ISNULL(RoomCat.Name, '-') AS RoomCategory
			,0 AS MISSequence
			,'' AS Days
			,'' AS DaysOfWeek
			,0 AS RateCardModeTypeID
			,isnull(MP.Code, '-') AS MealPlanCode
			,MP.Breakfast
			,MP.Lunch
			,MP.Dinner
			,0 AS TransferID
			,'' AS TransferValue
<<<<<<< HEAD
<<<<<<< HEAD
			,
			-- Flags
			0 AS HasRules
=======
			,0 AS HasRules
>>>>>>> dev
=======
			,0 AS HasRules
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
			,0 AS HasDocument
			,0 AS OfferTypeID
			,CHRM.CurrencyID AS Currency
			,dbo.fnGetPurchaseRate(CHRM.CurrencyID, @CurrencyCode, @CheckIn) AS PurchaseRate
			,'' AS ValueAddOn
			,'' AS InfoForOperation
			,'' AS InfoForRemark
<<<<<<< HEAD
<<<<<<< HEAD
			,
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
=======
			,(
>>>>>>> dev
=======
			,(
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
				SELECT RC.RateCommisionID AS RateCommissionID
					,RCM.CommMasterID AS CommissionMasterID
					,RCM.CommMasterID AS MasterCommissionID
					,RCM.RateType
					,RC.TaxPercentage
					,RC.TaxAmount
					,RC.GrossAmountIncludingTax AS GrossAmountIncludingTax_Org
<<<<<<< HEAD
<<<<<<< HEAD
					,
					--dbo.fnSearchCalculateROE(ISNULL(RC.GrossAmountIncludingTax, 0), @CheckIn, C1.Code, @CurrencyCode) AS GrossAmountIncludingTax,
					RC.GrossAmountIncludingTax AS GrossAmountIncludingTax
					,RC.GrossAmountExcludingTax AS GrossAmountExcludingTax_Org
					,
					--dbo.fnSearchCalculateROE(ISNULL(RC.GrossAmountExcludingTax, 0), @CheckIn, C1.Code, @CurrencyCode) as GrossAmountExcludingTax,
					RC.GrossAmountExcludingTax AS GrossAmountExcludingTax
					,RC.CommisionPercentage
					,RC.CommissionAmount AS CommissionAmount_Org
					,
					--dbo.fnSearchCalculateROE(ISNULL(RC.CommissionAmount, 0), @CheckIn, C1.Code, @CurrencyCode) AS CommissionAmount,
					RC.CommissionAmount AS CommissionAmount
					,RC.NetAmountIncludingTax AS NetAmountIncludingTax_Org
					,
					--dbo.fnSearchCalculateROE(ISNULL(RC.NetAmountIncludingTax, 0), @CheckIn, C1.Code, @CurrencyCode) as NetAmountIncludingTax,
					RC.NetAmountIncludingTax AS NetAmountIncludingTax
					,RC.NetAmountExcludingTax AS NetAmountExcludingTax_Org
					,
					--dbo.fnSearchCalculateROE(ISNULL(RC.NetAmountExcludingTax, 0), @CheckIn, C1.Code, @CurrencyCode) as NetAmountExcludingTax,
					RC.NetAmountExcludingTax AS NetAmountExcludingTax
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
					,RC.GrossAmountIncludingTax AS GrossAmountIncludingTax
					,RC.GrossAmountExcludingTax AS GrossAmountExcludingTax_Org
					,RC.GrossAmountExcludingTax AS GrossAmountExcludingTax
					,RC.CommisionPercentage
					,RC.CommissionAmount AS CommissionAmount_Org
					,RC.CommissionAmount AS CommissionAmount
					,RC.NetAmountIncludingTax AS NetAmountIncludingTax_Org
					,RC.NetAmountIncludingTax AS NetAmountIncludingTax
					,RC.NetAmountExcludingTax AS NetAmountExcludingTax_Org
					,RC.NetAmountExcludingTax AS NetAmountExcludingTax
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
					,RC.GrossAmountIncludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS GrossAmountIncludingTax_Con
					,RC.GrossAmountExcludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS GrossAmountExcludingTax_Con
					,RC.CommissionAmount * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS CommissionAmount_Con
					,RC.NetAmountIncludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS NetAmountIncludingTax_Con
					,RC.NetAmountExcludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS NetAmountExcludingTax_Con
					,ISNULL(RC.IsTax, 0) AS IsTax
					,ISNULL(RC.IsActive, 0) AS IsActive
				FROM [CustomRateCards].[HotelRateCommisionDetails] RC WITH (NOLOCK)
<<<<<<< HEAD
<<<<<<< HEAD
				LEFT OUTER JOIN RateCommissionMaster RCM WITH (NOLOCK) ON RC.CommissionMasterID = RCM.CommMasterID
				WHERE RC.HotelRateID = CHRM.HotelRateId
					--AND RCM.Type = 1
					--AND RC.IsActive = 1
					AND (
						NOT EXISTS (
							SELECT 1
							FROM #OccupancyRateTypes
							)
						OR RCM.RateType IN (
							SELECT RateType
							FROM #OccupancyRateTypes
							)
						)
				FOR JSON PATH
				) AS CommissionJSON
			,
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
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
				INNER JOIN RateCommissionMaster RCM WITH (NOLOCK) ON RC.CommissionMasterID = RCM.CommMasterID
				WHERE RC.HotelRateID = CHRM.HotelRateId
					--AND (
					--	NOT EXISTS (
					--		SELECT 1
					--		FROM #OccupancyRateTypes
					--		)
					--	OR RCM.RateType IN (
					--		SELECT RateType
					--		FROM #OccupancyRateTypes
					--		)
					--	)
				FOR JSON PATH
				) AS CommissionJSON
			,(
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
				SELECT M.HotelRateMealID
					,0 AS HotelRateDetailID
					,MealType.RateType AS MealType
					,M.GstPercentage
					,M.GstAmount
<<<<<<< HEAD
<<<<<<< HEAD
					,
					-- Conditionally select NetAmount based on @TaxID
					M.NetAmountIncludingTax AS NetAmountIncludingTax_Org
					,
					--dbo.fnSearchCalculateROE(M.NetAmountIncludingTax, @CheckIn, C1.Code, @CurrencyCode) AS NetAmountIncludingTax,
					M.NetAmountIncludingTax AS NetAmountIncludingTax
					,M.NetAmountExcludingTax AS NetAmountExcludingTax_Org
					,
					--dbo.fnSearchCalculateROE(M.NetAmountExcludingTax, @CheckIn, C1.Code, @CurrencyCode) AS NetAmountExcludingTax,
					M.NetAmountExcludingTax AS NetAmountExcludingTax
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
					,M.NetAmountIncludingTax AS NetAmountIncludingTax_Org
					,M.NetAmountIncludingTax AS NetAmountIncludingTax
					,M.NetAmountExcludingTax AS NetAmountExcludingTax_Org
					,M.NetAmountExcludingTax AS NetAmountExcludingTax
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
					,M.NetAmountIncludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS NetAmountIncludingTax_Con
					,M.NetAmountExcludingTax * dbo.fnGetPurchaseRate(C1.CurrencyCode, @CurrencyCode, @CheckIn) AS NetAmountExcludingTax_Con
					,M.MasterCommissionID
					,M.IsMealDetails
					,M.DefineAmount
				FROM [CustomRateCards].[HotelRateMealOverview] M WITH (NOLOCK)
<<<<<<< HEAD
<<<<<<< HEAD
				--LEFT OUTER JOIN RateCommissionMaster MealType  WITH (NOLOCK) ON M.MasterCommissionID = MealType.CommMasterID
				LEFT OUTER JOIN RateCommissionMaster MealType WITH (NOLOCK) ON M.MealTypeID = MealType.CommMasterID
				WHERE M.HotelRateID = CHRM.HotelRateID
				--AND M.IsActive = 1
				FOR JSON PATH
				) AS MealOverviewJSON
			,'' AS OfferConfigurationJSON
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
				LEFT OUTER JOIN RateCommissionMaster MealType WITH (NOLOCK) ON M.MealTypeID = MealType.CommMasterID
				WHERE M.HotelRateID = CHRM.HotelRateID
				FOR JSON PATH
				) AS MealOverviewJSON
			,'' AS OfferConfigurationJSON
			,'' AS HotelOfferRateCardJSON
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
			,'' AS HotelAnnouncementsJSON
			,'' AS ContactDetailsJSON
			,'' AS RulesJSON
			,'' AS MarketJSON
			,'' AS RateSheetJSON
			,CHRM.CreatedOn
<<<<<<< HEAD
<<<<<<< HEAD
			,0 AS SortOrder
		FROM CustomRateCards.HotelRateMaster CHRM WITH (NOLOCK)
		INNER JOIN HotelMaster H WITH (NOLOCK) ON CHRM.HotelID = H.HotelID
		LEFT JOIN City c on c.IATACode=CHRM.CityID
		INNER JOIN HotelRating HR WITH (NOLOCK) ON H.HotelRatingID = HR.ID
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
			,CHRM.CreatedBy
			,HTM.TypeValue as HotelType
			,ZM.ZoneName
			,VM.VendorName
			,CASE WHEN HRC.ExtraBedMattress=0 THEN 'Not Defined'                                              
   WHEN HRC.ExtraBedMattress=1 THEN 'NA'                                                    
   WHEN HRC.ExtraBedMattress=2 THEN 'Bed'                                                    
   WHEN HRC.ExtraBedMattress=3 THEN 'Mattress'END AS ExtraBedMattress
   ,H.CreditApplicable
   ,H.CreditCurrencyCode
   ,H.CreditPeriod
   ,H.CreditAmount
   ,H.CreditApproveBy
   ,H.EmailFinance
			,0 AS SortOrder
			,'' as CardNumber
			,'' as BookFrom
    ,'' as BookTo
			FROM CustomRateCards.HotelRateMaster CHRM WITH (NOLOCK)
		INNER JOIN HotelMaster H WITH (NOLOCK) ON CHRM.HotelID = H.HotelID
		
		INNER JOIN HotelRating HR WITH (NOLOCK) ON H.HotelRatingID = HR.ID
		INNER JOIN HotelTypeMaster HTM ON HTM.HotelTypeID = H.HotelTypeID
		LEFT JOIN City c on c.IATACode=CHRM.CityID
		LEFT JOIN HotelRoomCategory HRC ON CHRM.HotelID = HRC.HotelID
			AND HRC.RoomCategoryID = CHRM.RoomCategoryID
			AND HRC.IsActive = 1
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
		LEFT OUTER JOIN RoomCategory RoomCat WITH (NOLOCK) ON CHRM.RoomCategoryID = RoomCat.ID
		LEFT OUTER JOIN MealPlan MP WITH (NOLOCK) ON CHRM.MealPlanID = MP.ID
			AND MP.IsActive = 1
		LEFT OUTER JOIN CurrencyMaster C1 WITH (NOLOCK) ON CHRM.CurrencyID = C1.CurrencyCode
<<<<<<< HEAD
<<<<<<< HEAD
=======
		LEFT JOIN dbo.ZoneMaster ZM ON ZM.ZoneID = H.ZoneID
		left join dbo.VendorMaster VM on VM.VendorID= CHRM.VendorID
>>>>>>> dev
=======
		LEFT JOIN dbo.ZoneMaster ZM ON ZM.ZoneID = H.ZoneID
		left join dbo.VendorMaster VM on VM.VendorID= CHRM.VendorID
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
		WHERE CHRM.RateType = 5
			AND CHRM.IsActive = 1
			--      AND CHRM.CityID = @CityID
			--      AND (@HotelID IS NULL OR CHRM.HotelID = @HotelID)
			--AND (@PreferredHotel IS NULL OR @PreferredHotel = 0 OR CHRM.HotelPreferred = 1)
			AND CHRM.QuotationID = @QuotationID
			AND CAST(CHRM.CheckIn AS DATE) <= CAST(@CheckOut AS DATE)
			AND CAST(CHRM.CheckOut AS DATE) >= CAST(@CheckIn AS DATE)
			AND (
				(
					@RatingFrom IS NULL
					OR @RatingTo IS NULL
					OR @RatingFrom = 0
					OR @RatingTo = 0
					)
				OR (
<<<<<<< HEAD
<<<<<<< HEAD
					HR.Ratings BETWEEN @RatingFrom
						AND @RatingTo
					)
				)

		ORDER BY 
		HR.Ratings DESC,
		H.HotelName ASC,
		CHRM.CheckIn ASC,
		CHRM.HotelRateID
			--ORDER BY CreatedOn DESC
	END

	-- Return combined results
	SELECT *
	FROM #CombinedRateCards
	ORDER BY SortOrder
		,CreatedOn DESC;
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
					HR.Ratings BETWEEN @RatingFromInt
						AND @RatingToInt
					)
					OR(@RatingToInt =0 and @RatingFromInt > 0 and HR.Ratings>=@RatingFromInt)
	OR(@RatingFromInt=0 and @RatingToInt> 0  and HR.Ratings<=@RatingFromInt)
				)
	END

	-- Return combined results
	SELECT distincT *
	FROM #CombinedRateCards
	--ORDER BY
	--	RatingCode Desc;
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

	-- Cleanup
	DROP TABLE #PreferredMarkets;

	DROP TABLE #RateSheets;

	DROP TABLE #OccupancyRateTypes;

	DROP TABLE #CombinedRateCards;
END
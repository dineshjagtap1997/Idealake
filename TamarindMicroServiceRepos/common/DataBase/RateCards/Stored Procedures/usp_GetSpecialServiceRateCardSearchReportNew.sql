<<<<<<< HEAD
<<<<<<< HEAD
﻿--declare
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
﻿
  --exec [RateCards].[usp_GetSpecialServiceRateCardSearchReportNew] 'INR','1,2',1,'JAI',10,0,1,null,null,'2025-08-21T00:00:00','2025-09-21T00:00:00',0,null,0

--declare
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
--	@DisplayRate        VARCHAR(5) = NULL,
--    @RateCardModeTypeID  Varchar(10)        = NULL,
--    @TaxID             int      = NULL,
--	@CityIata           CHAR(3)    = NULL,
--    @Service            INT        = NULL,
--	@VendorID          INT        = NULL,
--    @NationalityID      INT        = NULL,
--	@Child            INT        = NULL,
--	@Adult             INT        = NULL,
--    @ValidFrom          DATETIME   = NULL,
--    @ValidTo            DATETIME   = NULL
<<<<<<< HEAD
<<<<<<< HEAD

=======
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
--{"Action":"S","CurrencyID":"INR","RateCardModeTypeID":"1","TaxID":1,"CityID":"BOM","SpecialServiceRateID":362,"VendorID":272,"NationalityID":1,"Adult":"","Child":"","ValidFrom":"2025-05-01T00:00:00","ValidTo":"2025-05-31T00:00:00","CityName":"Mumbai (Bombay)","PaxMaximum":0}
----exec [RateCards].[usp_GetSpecialServiceRateCardSearchReportNew] 'INR','1,2', 1,'BOM',343,0,'', NULL,NULL,'2025-09-01 00:00:00.000','2025-09-30 00:00:00.000'
---exec [RateCards].[usp_GetSpecialServiceRateCardSearchReport]  'INR','1', '1','BOM',360,1447,3, NULL,NULL,'2025-05-01 00:00:00.000','2025-05-14 00:00:00.000'
---exec [RateCards].[usp_GetSpecialServiceRateCardSearchReport]  'INR','1', 1,'BOM',362,272,2, NULL,NULL,'2025-05-01 00:00:00.000','2025-05-14 00:00:00.000'
<<<<<<< HEAD
<<<<<<< HEAD
CREATE PROCEDURE [RateCards].[usp_GetSpecialServiceRateCardSearchReportNew] 
(

    @DisplayRate        VARCHAR(5) = NULL,
    @RateCardModeTypeID  Varchar(10)        = NULL,
    @TaxID             int      = NULL,
	@CityIata           CHAR(3)    = NULL,
    @Service            INT        = NULL,
	@VendorID          INT        = NULL,
    @NationalityID      INT        = NULL,
	@Child            INT        = NULL,
	@Adult             INT        = NULL,
    @ValidFrom          DATETIME   = NULL,
    @ValidTo            DATETIME   = NULL,
	@QuotationID        INT        = NULL
)
AS
BEGIN
    SET NOCOUNT ON;  

	DECLARE @RateCardModeTable TABLE (ModeID INT)

	DECLARE @TotalPax INT = ISNULL(@Adult, 0) + ISNULL(@Child, 0)


INSERT INTO @RateCardModeTable (ModeID)
SELECT DISTINCT TRY_CAST(value AS INT)
FROM STRING_SPLIT(@RateCardModeTypeID, ',')
WHERE TRY_CAST(value AS INT) IS NOT NULL

    SELECT 

		SSRM.SpecialServiceRateID,
		'RateCard' as Type,
	    SSRD.SpecialServiceRateDetailID,
        SCRD.SpecialServiceRateCommissionID,
        CT.Name AS City,
		VM.VendorName,
		CT.ID AS CityID,
        N.Nationality,
        SS.Name AS [TransportService],
		SSRD.TaxID,
		SCRD.CommissionMasterID,

        CONVERT(VARCHAR, SSRD.ValidFrom, 106) AS [ValidFrom],
        CONVERT(VARCHAR, SSRD.ValidTo, 106) AS [ValidTo],

        CONVERT(VARCHAR, SCRD.MinimumPax) + ' - ' + CONVERT(VARCHAR, SCRD.MaximumPax) AS PaxRange,

        @DisplayRate AS Currency,

			 --CASE 
    --        WHEN @TaxID = 1 THEN 
     --           CAST(CAST(dbo.fnSearchCalculateROE(SCRD.NetAmountIncludingTax, @ValidFrom, @DisplayRate, SSRM.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20))   as NetAmountIncludingTax,
				 --CAST(CAST(dbo.fnSearchCalculateROE(SCRD.NetAmountExcludingTax, @ValidFrom, @DisplayRate, SSRM.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20))   as NetAmountExcludingTax,
        --    WHEN @TaxID = 2 THEN 
        --        CAST(CAST(dbo.fnSearchCalculateROE(SCRD.NetAmountExcludingTax, @ValidFrom, @DisplayRate, SSRM.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20))  
        --    ELSE 
        --        CAST(CAST(dbo.fnSearchCalculateROE(SCRD.NetAmountIncludingTax, @ValidFrom, @DisplayRate, SSRM.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20)) 
        --END AS [GrossRate],

		      --  CASE 
        --    WHEN @TaxID = 1 THEN 
        --        CAST(CAST(dbo.fnSearchCalculateROE(SCRD.NetAmountIncludingTax, @ValidFrom, @DisplayRate, SSRM.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20))  
        --    WHEN @TaxID = 2 THEN 
        --        CAST(CAST(dbo.fnSearchCalculateROE(SCRD.NetAmountExcludingTax, @ValidFrom, @DisplayRate, SSRM.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20))  
        --    ELSE 
        --        CAST(CAST(dbo.fnSearchCalculateROE(SCRD.NetAmountIncludingTax, @ValidFrom, @DisplayRate, SSRM.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20)) 
        --END AS [SellingRate],

		SCRD.TaxPercentage, 
        SCRD.TaxAmount, 
		SCRD.NetAmountExcludingTax, 
		SCRD.NetAmountIncludingTax,
		SCRD.NetAmountExcludingTax * dbo.fnGetPurchaseRate(Cu.Code, @DisplayRate, GETDATE()) AS NetAmountExcludingTax_Con,
		    SCRD.NetAmountIncludingTax * dbo.fnGetPurchaseRate(Cu.Code, @DisplayRate, GETDATE()) AS NetAmountIncludingTax_Con,
        SSRM.InfoForOperation,
        SSRM.InfoForRemark,
		SSRD.NationalityID,

        CASE SSRM.RateCardModeTypeID
            WHEN 1 THEN 'Contract'
            WHEN 2 THEN 'Adhoc'
            WHEN 3 THEN 'Negotiated'
        END AS RateCardType,

        SSRM.CardNumber,
        SSRM.RateCardModeTypeID,
        SS.ID AS SpecialServiceID,
		SSRM.ContractDate,
		SSRM.CurrencyID,
		SSRM.StateID,
		SSRM.VendorID,
		SSRM.InfoForOperation,
		SSRM.InfoForAgent,
		SSRM.InfoForRemark,
		SSRM.IsActive,
--		SSRM.CreatedBy,
--		SSRM.CreatedOn,
----		SSRM.UpdatedBy,
--		SSRM.UpdatedOn,
		SSRM.GSTStatus,
        SSRM.RateCardModeTypeID,
        SSRM.CityID,
		SS.name as SpecialService,

		
		    (
        SELECT 
            CASE 
                WHEN EXISTS (SELECT 1 FROM [RateCards].[Rules] WHERE RateCardID = SSRM.SpecialServiceRateID) 
                THEN CAST(1 AS BIT) 
                ELSE CAST(0 AS BIT) 
            END
    ) AS HasRules,
    (SELECT TOP 1 
        CASE 
            WHEN ud.DocumentID IS NOT NULL THEN CAST(1 AS BIT) 
            ELSE CAST(0 AS BIT) 
        END
     FROM dbo.LinkedDocuments ld 
     INNER JOIN dbo.UploadDocuments ud 
         ON ld.ParentID = SSRM.SpecialServiceRateID  
         AND ud.DocumentID = ld.DocumentID 
         AND ud.ParentTypeID = 2
    ) AS HasDocument,

	COALESCE(RCM.Ratetype, 'Consolidated') AS Ratetype,

        SSRM.VendorID,
        SSRM.HotelID,
        SCRD.MinimumPax,
        SCRD.MaximumPax,
        SCRD.TaxPercentage,
        SCRD.TaxAmount,
		SSRM.CreatedOn,
		 SSRM.InfoForOperation,
SSRM.InfoForRemark



    FROM RateCards.SpecialServiceRateMaster SSRM
    INNER JOIN RateCards.SpecialServiceRateDeatils SSRD 
        ON SSRD.SpecialServiceRateID = SSRM.SpecialServiceRateID
    INNER JOIN Nationality N 
        ON N.ID = SSRD.NationalityID
    LEFT JOIN RateCards.SpecialServiceRateCommissionDeatils SCRD 
        ON SCRD.SpecialServiceRateDetailID = SSRD.SpecialServiceRateDetailID
    LEFT JOIN City CT 
        ON CT.IATACode = SSRM.CityID
    LEFT JOIN VendorMaster VM 
        ON VM.VendorID = SSRM.VendorID
    LEFT JOIN HotelMaster HM 
        ON HM.HotelID = SSRM.HotelID
    LEFT JOIN SpecialServices SS 
        ON SS.ID = SSRM.SpecialServiceID
    LEFT JOIN Currency Cu 
        ON Cu.Code = SSRM.CurrencyID
	LEFT JOIN RateCommissionMaster RCM 
        ON RCM.CommMasterID = SCRD.CommissionMasterID

    WHERE 
        (SSRM.SpecialServiceID = @Service)
--	--	AND (
 --   NOT EXISTS (SELECT 1 FROM @RateCardModeTable) 
 --   OR SSRM.RateCardModeTypeID IN (SELECT ModeID FROM @RateCardModeTable)
	--)

	 AND SSRM.RateCardModeTypeID IN (SELECT ModeID FROM @RateCardModeTable)
        AND SSRM.CityID = @CityIata 
		AND (SSRM.VendorID = @VendorID OR @VendorID IS NULL OR @VendorID = 0)

     AND (SSRD.NationalityID = @NationalityID  OR @NationalityID IS NULL OR @NationalityID = 0) 
	   --AND (SSRD.TaxID = @TaxID OR @TaxID IS NULL)
		--AND (SSRD.ValidFrom	 >= @ValidFrom)
		--AND (SSRD.ValidTo  <= @ValidTo  OR @ValidTo IS NULL) 
		AND SSRD.ValidFrom <= @ValidTo AND SSRD.ValidTo >= @ValidFrom
--		AND (
--    (@Child > 0 AND SCRD.CommissionMasterID = 8)
--    OR (@Adult > 0 AND SCRD.CommissionMasterID = 7)
--    OR ((@Child IS NULL OR @Child = 0) AND (@Adult IS NULL OR @Adult = 0))
--)

AND (
    @TotalPax = 0
    OR @TotalPax BETWEEN ISNULL(SCRD.MinimumPax, 0) AND ISNULL(SCRD.MaximumPax, 1000)
)

		
        AND
		SSRM.IsActive = 1
        AND SSRD.IsActive = 1

   -- ORDER BY CT.Name, SS.Name, SSRD.ValidFrom;

   UNION

   Select
		CHRM.HotelRateId as SpecialServiceRateID,
		'CustomRateCard' as Type,
		0 as SpecialServiceRateDetailID,
        RC.RateCommisionID as SpecialServiceRateCommissionID,
		CT.Name AS City,
		VM.VendorName,
		CT.ID AS CityID,
        N.Nationality,
        '' AS [TransportService],
		0 as TaxID,
		0 as CommissionMasterID,

		'' AS [ValidFrom],
		'' AS [ValidTo],

       CONVERT(VARCHAR, RC.MinimumPax) + ' - ' + CONVERT(VARCHAR, RC.MaximumPax) AS PaxRange,

        @DisplayRate AS Currency,

	
  --      CAST(CAST(dbo.fnSearchCalculateROE(RC.NetAmountIncludingTax, @ValidFrom, @DisplayRate, CHRM.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20))   as NetAmountIncludingTax,
		--CAST(CAST(dbo.fnSearchCalculateROE(RC.NetAmountExcludingTax, @ValidFrom, @DisplayRate, CHRM.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20))   as NetAmountExcludingTax,
		RC.NetAmountIncludingTax,
		RC.NetAmountExcludingTax,
		RC.NetAmountExcludingTax * dbo.fnGetPurchaseRate(CHRM.CurrencyID, @DisplayRate, GETDATE()) AS NetAmountExcludingTax_Con,
		    RC.NetAmountIncludingTax * dbo.fnGetPurchaseRate(CHRM.CurrencyID, @DisplayRate, GETDATE()) AS NetAmountIncludingTax_Con,
      

		RC.TaxPercentage, 
		RC.TaxAmount, 
		
        '' as InfoForOperation,
		'' as InfoForRemark,
		CHRM.NationalityID,

		'' AS RateCardType,

        '' as CardNumber,
        0 as RateCardModeTypeID,
		0 as SpecialServiceID,
		'' as ContractDate,
		CHRM.CurrencyID,
		0 as StateID,
		CHRM.VendorID,
			
        '' as InfoForOperation,
		'' as InfoForRemark,
		'' as InfoForRemark,
		CHRM.IsActive,

		'' as GSTStatus,
		'' as RateCardModeTypeID,
		CHRM.CityID,
		SS.name as SpecialService,

		
		0 AS HasRules,
		0 AS HasDocument,

			COALESCE(RCM.Ratetype, 'Consolidated') AS Ratetype,

        CHRM.VendorID,
        CHRM.HotelID,
        RC.MinimumPax,
        RC.MaximumPax,
        RC.TaxPercentage,
        RC.TaxAmount,
		CHRM.CreatedOn,
		'' as InfoForOperation,
'' InfoForRemark

   	FROM
		CustomRateCards.HotelRateMaster CHRM WITH (NOLOCK)
		LEFT OUTER JOIN [CustomRateCards].[HotelRateCommisionDetails] RC WITH (NOLOCK) ON RC.HotelRateID = CHRM.HotelRateId
		LEFT OUTER JOIN Nationality N WITH (NOLOCK) ON N.ID = CHRM.NationalityID 
		LEFT OUTER JOIN City CT WITH (NOLOCK) ON CT.IATACode = CHRM.CityID
		LEFT JOIN VendorMaster VM WITH (NOLOCK)  ON VM.VendorID = CHRM.VendorID
		LEFT JOIN RateCommissionMaster RCM 
        ON RCM.CommMasterID = RC.CommissionMasterID
		LEFT JOIN SpecialServices SS 
        ON SS.ID = CHRM.ServiceID
	WHERE
		CHRM.rateType=4
        AND CHRM.IsActive = 1
	--AND (@QuotationID IS NULL OR @QuotationID = 0 OR CHRM.QuotationID = @QuotationID)
		AND CHRM.QuotationID = @QuotationID
		AND (CHRM.VendorID = @VendorID OR @VendorID IS NULL OR @VendorID = 0)
		AND (
    @TotalPax = 0
    OR @TotalPax BETWEEN ISNULL(RC.MinimumPax, 0) AND ISNULL(RC.MaximumPax, 1000)
)
		AND
		(
			(@ValidFrom IS NOT NULL AND @ValidTo IS NOT NULL AND CAST(CHRM.CheckIn AS DATE) <= CAST(@ValidTo AS DATE) AND CAST(CHRM.CheckOut AS DATE) >= CAST(@ValidFrom AS DATE))
			OR
			(@ValidFrom IS NOT NULL AND @ValidTo IS NULL AND CAST(CHRM.CheckOut AS DATE) >= CAST(@ValidFrom AS DATE))
			OR
			(@ValidFrom IS NULL AND @ValidTo IS NOT NULL AND CAST(CHRM.CheckIn AS DATE) <= CAST(@ValidTo AS DATE))
			OR
			(@ValidFrom IS NULL AND @ValidTo IS NULL)
		)

	ORDER BY CreatedOn DESC
    SET NOCOUNT OFF;
END
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
CREATE PROCEDURE [RateCards].[usp_GetSpecialServiceRateCardSearchReportNew] (
	--@DisplayRate VARCHAR(5) = NULL
	--,@RateCardModeTypeID VARCHAR(10) = NULL
	--,@TaxID INT = NULL
	--,@CityIata CHAR(3) = NULL
	--,@Service INT = NULL
	--,@VendorID INT = NULL
	--,@NationalityID INT = NULL
	--,@Child INT = NULL
	--,@Adult INT = NULL
	--,@ValidFrom DATETIME = NULL
	--,@ValidTo DATETIME = NULL
	--,@QuotationID INT = NULL,
	--@BookingID bigint =null,
	--@SpecialServiceRateID bigint = null

	@DisplayRate VARCHAR(5) = NULL, -- Not in JSON
@RateCardModeTypeID VARCHAR(10) = '1', -- From "RateCardModeTypeID": "1"
@TaxID INT = 1, -- From "TaxID": 1
@CityIata CHAR(3) = NULL, -- From "CityID": "" (empty)
@Service INT = NULL, -- Not directly provided
@VendorID INT = 0, -- From "VendorID": 0
@NationalityID INT = 0, -- From "NationalityID": 0
@Child INT = NULL, -- Not in JSON
@Adult INT = NULL, -- Not in JSON
@ValidFrom DATETIME = '2025-08-01T00:00:00', -- From "ValidFrom"
@ValidTo DATETIME = '2025-08-31T00:00:00', -- From "ValidTo"
@QuotationID INT = 0, -- From "QuotationID": 0
@BookingID BIGINT = 0, -- From "BookingID": 0
@SpecialServiceRateID BIGINT = 129674 -- From "SpecialServiceRateID"
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @RateCardModeTable TABLE (ModeID INT)
	DECLARE @TotalPax INT = ISNULL(@Adult, 0) + ISNULL(@Child, 0)

	INSERT INTO @RateCardModeTable (ModeID)
	SELECT DISTINCT TRY_CAST(value AS INT)
	FROM STRING_SPLIT(@RateCardModeTypeID, ',')
	WHERE TRY_CAST(value AS INT) IS NOT NULL

	SELECT
	
	
	SSRM.SpecialServiceRateID
		,'RateCard' AS Type
		,SSRD.SpecialServiceRateDetailID
		,SCRD.SpecialServiceRateCommissionID
		,CT.Name AS City
		,VM.VendorName
		,CT.ID AS CityID
		,N.Nationality
		,SS.Name AS [TransportService]
		,SSRD.TaxID
		,SCRD.CommissionMasterID
		,CONVERT(VARCHAR, SSRD.ValidFrom, 106) AS [ValidFrom]
		,CONVERT(VARCHAR, SSRD.ValidTo, 106) AS [ValidTo]
		,CONVERT(VARCHAR, SCRD.MinimumPax) + ' - ' + CONVERT(VARCHAR, SCRD.MaximumPax) AS PaxRange
		,@DisplayRate AS Currency
		,
		
		SCRD.TaxPercentage
		,SCRD.TaxAmount
		,SCRD.NetAmountExcludingTax
		,SCRD.NetAmountIncludingTax
		,SCRD.NetAmountExcludingTax * dbo.fnGetPurchaseRate(SSRM.CurrencyID, @DisplayRate, GETDATE()) AS NetAmountExcludingTax_Con
		,SCRD.NetAmountIncludingTax * dbo.fnGetPurchaseRate(SSRM.CurrencyID, @DisplayRate, GETDATE()) AS NetAmountIncludingTax_Con
		,SSRM.InfoForOperation
		,SSRM.InfoForRemark
		,SSRD.NationalityID
		,CASE SSRM.RateCardModeTypeID
			WHEN 1
				THEN 'Contract'
			WHEN 2
				THEN 'Adhoc'
			WHEN 3
				THEN 'Negotiated'
			END AS RateCardType
		,SSRM.CardNumber
		,SSRM.RateCardModeTypeID
		,SS.ID AS SpecialServiceID
		,SSRM.ContractDate
		,SSRM.CurrencyID
		,SSRM.StateID
		,SSRM.VendorID
		,SSRM.InfoForOperation
		,SSRM.InfoForAgent
		,SSRM.InfoForRemark
		,SSRM.IsActive
		,
		
		SSRM.GSTStatus
		,SSRM.RateCardModeTypeID
		,SSRM.CityID
		,SS.name AS SpecialService
		,(
			SELECT CASE 
					WHEN EXISTS (
							SELECT 1
							FROM [RateCards].[Rules]
							WHERE RateCardID = SSRM.SpecialServiceRateID
							)
						THEN CAST(1 AS BIT)
					ELSE CAST(0 AS BIT)
					END
			) AS HasRules
		,(
			SELECT TOP 1 CASE 
					WHEN ud.DocumentID IS NOT NULL
						THEN CAST(1 AS BIT)
					ELSE CAST(0 AS BIT)
					END
			FROM dbo.LinkedDocuments ld
			INNER JOIN dbo.UploadDocuments ud ON ld.ParentID = SSRM.SpecialServiceRateID
				AND ud.DocumentID = ld.DocumentID
				AND ud.ParentTypeID = 2
			) AS HasDocument
		,COALESCE(RCM.Ratetype, 'Consolidated') AS Ratetype
		,SSRM.VendorID
		,SSRM.HotelID
		,SCRD.MinimumPax
		,SCRD.MaximumPax
		,SCRD.TaxPercentage
		,SCRD.TaxAmount
		,SSRM.CreatedOn
		,SSRM.InfoForOperation
		,SSRM.InfoForRemark
		,XORemark
		,XoRemarks AS XORemarkName
	FROM RateCards.SpecialServiceRateMaster SSRM
	LEFT JOIN RateCards.SpecialServiceRateDeatils SSRD ON SSRD.SpecialServiceRateID = SSRM.SpecialServiceRateID
	LEFT JOIN Nationality N ON N.ID = SSRD.NationalityID
	LEFT JOIN RateCards.SpecialServiceRateCommissionDeatils SCRD ON SCRD.SpecialServiceRateDetailID = SSRD.SpecialServiceRateDetailID
	LEFT JOIN City CT ON CT.IATACode = SSRM.CityID
	LEFT JOIN VendorMaster VM ON VM.VendorID = SSRM.VendorID
	LEFT JOIN HotelMaster HM ON HM.HotelID = SSRM.HotelID
	LEFT JOIN SpecialServices SS ON SS.ID = SSRM.SpecialServiceID
	LEFT JOIN CurrencyMaster Cu ON Cu.CurrencyCode = SSRM.CurrencyID
	LEFT JOIN RateCommissionMaster RCM ON RCM.CommMasterID = SCRD.CommissionMasterID
	LEFT JOIN XORemarks XO ON XO.XOID = SSRM.XORemark
	WHERE 
	(
	--ISnull(@SpecialServiceRateID,0)<>0 and SSRM.SpecialServiceRateID=@SpecialServiceRateID ) or (ISnull(@SpecialServiceRateID,0)=0 
	ISnull(@SpecialServiceRateID,0)<>0 and SSRM.SpecialServiceID=@SpecialServiceRateID ) or (ISnull(@SpecialServiceRateID,0)=0 
	AND
	 (@Service IS NULL OR @Service = 0 OR SSRM.SpecialServiceID = @Service)
		
		AND SSRM.RateCardModeTypeID IN (
			SELECT ModeID
			FROM @RateCardModeTable
			)
		AND SSRM.CityID = @CityIata
		AND (
			SSRM.VendorID = @VendorID
			OR @VendorID IS NULL
			OR @VendorID = 0
			)
		AND (
			SSRD.NationalityID = @NationalityID
			OR @NationalityID IS NULL
			OR @NationalityID = 0
			)
		
		AND SSRD.ValidFrom <= @ValidTo
		AND SSRD.ValidTo >= @ValidFrom
		
		AND (
			@TotalPax = 0
			OR @TotalPax BETWEEN ISNULL(SCRD.MinimumPax, 0)
				AND ISNULL(SCRD.MaximumPax, 1000)
			)
		AND SSRM.IsActive = 1
		AND SSRD.IsActive = 1
		   AND( (( SSRM.BookingID=@BookingID and SSRM.RateCardModeTypeID=3) or(SSRM.BookingID is null and SSRM.RateCardModeTypeID in (1,2,3,4))) or (@BookingID is null) or (@BookingID =0 ))
		   )
	
	
	UNION
	
	SELECT 
	CHRM.HotelRateId AS SpecialServiceRateID
		,'CustomRateCard' AS Type
		,0 AS SpecialServiceRateDetailID
		,RC.RateCommisionID AS SpecialServiceRateCommissionID
		,CT.Name AS City
		,VM.VendorName
		,CT.ID AS CityID
		,N.Nationality
		,'' AS [TransportService]
		,0 AS TaxID
		,0 AS CommissionMasterID
		,'' AS [ValidFrom]
		,'' AS [ValidTo]
		,CONVERT(VARCHAR, RC.MinimumPax) + ' - ' + CONVERT(VARCHAR, RC.MaximumPax) AS PaxRange
		,@DisplayRate AS Currency
		,
		--      CAST(CAST(dbo.fnSearchCalculateROE(RC.NetAmountIncludingTax, @ValidFrom, @DisplayRate, CHRM.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20))   as NetAmountIncludingTax,
		--CAST(CAST(dbo.fnSearchCalculateROE(RC.NetAmountExcludingTax, @ValidFrom, @DisplayRate, CHRM.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20))   as NetAmountExcludingTax,
		RC.NetAmountIncludingTax
		,RC.NetAmountExcludingTax
		,RC.NetAmountExcludingTax * dbo.fnGetPurchaseRate(CHRM.CurrencyID, @DisplayRate, GETDATE()) AS NetAmountExcludingTax_Con
		,RC.NetAmountIncludingTax * dbo.fnGetPurchaseRate(CHRM.CurrencyID, @DisplayRate, GETDATE()) AS NetAmountIncludingTax_Con
		,RC.TaxPercentage
		,RC.TaxAmount
		,'' AS InfoForOperation
		,'' AS InfoForRemark
		,CHRM.NationalityID
		,'' AS RateCardType
		,'' AS CardNumber
		,0 AS RateCardModeTypeID
		,0 AS SpecialServiceID
		,'' AS ContractDate
		,CHRM.CurrencyID
		,0 AS StateID
		,CHRM.VendorID
		,'' AS InfoForOperation
		,'' AS InfoForRemark
		,'' AS InfoForRemark
		,CHRM.IsActive
		,'' AS GSTStatus
		,'' AS RateCardModeTypeID
		,CHRM.CityID
		,SS.name AS SpecialService
		,0 AS HasRules
		,0 AS HasDocument
		,COALESCE(RCM.Ratetype, 'Consolidated') AS Ratetype
		,CHRM.VendorID
		,CHRM.HotelID
		,RC.MinimumPax
		,RC.MaximumPax
		,RC.TaxPercentage
		,RC.TaxAmount
		,CHRM.CreatedOn
		,'' AS InfoForOperation
		,'' InfoForRemark
		,'' AS XORemark
		,'' AS XORemarkName
	FROM CustomRateCards.HotelRateMaster CHRM WITH (NOLOCK)
	LEFT OUTER JOIN [CustomRateCards].[HotelRateCommisionDetails] RC WITH (NOLOCK) ON RC.HotelRateID = CHRM.HotelRateId
	LEFT OUTER JOIN Nationality N WITH (NOLOCK) ON N.ID = CHRM.NationalityID
	LEFT OUTER JOIN City CT WITH (NOLOCK) ON CT.IATACode = CHRM.CityID
	LEFT JOIN VendorMaster VM WITH (NOLOCK) ON VM.VendorID = CHRM.VendorID
	LEFT JOIN RateCommissionMaster RCM ON RCM.CommMasterID = RC.CommissionMasterID
	LEFT JOIN SpecialServices SS ON SS.ID = CHRM.ServiceID
	WHERE CHRM.rateType = 4
		AND CHRM.IsActive = 1
		--AND (@QuotationID IS NULL OR @QuotationID = 0 OR CHRM.QuotationID = @QuotationID)
		AND CHRM.QuotationID = @QuotationID
		AND (
			CHRM.VendorID = @VendorID
			OR @VendorID IS NULL
			OR @VendorID = 0
			)
		AND (
			@TotalPax = 0
			OR @TotalPax BETWEEN ISNULL(RC.MinimumPax, 0)
				AND ISNULL(RC.MaximumPax, 1000)
			)
		AND (
			(
				@ValidFrom IS NOT NULL
				AND @ValidTo IS NOT NULL
				AND CAST(CHRM.CheckIn AS DATE) <= CAST(@ValidTo AS DATE)
				AND CAST(CHRM.CheckOut AS DATE) >= CAST(@ValidFrom AS DATE)
				)
			OR (
				@ValidFrom IS NOT NULL
				AND @ValidTo IS NULL
				AND CAST(CHRM.CheckOut AS DATE) >= CAST(@ValidFrom AS DATE)
				)
			OR (
				@ValidFrom IS NULL
				AND @ValidTo IS NOT NULL
				AND CAST(CHRM.CheckIn AS DATE) <= CAST(@ValidTo AS DATE)
				)
			OR (
				@ValidFrom IS NULL
				AND @ValidTo IS NULL
				)
			)
	--ORDER BY CreatedOn DESC
	ORDER BY City,[TransportService],ValidFrom

	SET NOCOUNT OFF;
<<<<<<< HEAD
END
>>>>>>> dev
=======
END
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

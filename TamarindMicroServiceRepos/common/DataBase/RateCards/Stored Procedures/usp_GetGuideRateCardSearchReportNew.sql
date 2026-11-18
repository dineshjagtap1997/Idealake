
--DECLARE 
--    @DisplayRate       VARCHAR(5)   = 'RAI',  -- default, not in JSON
--    @RateCardModeType  VARCHAR(50)  = '1,2,3,4',
--    @TaxID             INT          = 1,
--    @CityIata          CHAR(3)      = 'BOM',
--    @Service           INT          = 0,   -- GuideServiceID from JSON
--    @Vendor            INT          = 0,
--    @Language          CHAR(2)      = NULL, -- empty string in JSON
--    @NoofPax           INT          = 0,
--    @ValidFrom         DATETIME     = '2025-09-09T00:00:00',
--    @ValidTo           DATETIME     = '2025-09-09T00:00:00',
--    @QuotationID       INT          = 0,
--    @BookingID         BIGINT       = 498,
--    @GuidRateID        BIGINT       = NULL;



 ---Including     --exec [RateCards].[usp_GetGuideRateCardSearchReport] 'INR','Adhoc', 'Inclusive', 'DEL',7,2957,'HI',3,'2025-05-01 00:00:00.000','2025-05-30 00:00:00.000'
 ----exec [RateCards].[usp_GetGuideRateCardSearchReport] 'USD','Adhoc,Contract', 'Inclusive', 'DEL',7,0,'',3,'2025-05-01 00:00:00.000','2025-05-30 00:00:00.000'
  ----exec [RateCards].[usp_GetGuideRateCardSearchReport] 'INR','Adhoc', 'Inclusive', 'DEL',7,2957,'HI',3,'2025-05-01 00:00:00.000','2025-05-30 00:00:00.000'
-- Excluding Tax  --exec [usp_GetGuideRateCardSearchReport] 'INR','1', '2',  'BOM',207,2956,'EN',7,'2025-05-01 00:00:00.000','2025-05-30 00:00:00.000' 

---exec [usp_GetGuideRateCardSearchReport] 'INR','Contract', 'Exclusive',  'BOM',207,2956,'EN',7,'2025-05-01 00:00:00.000','2025-05-30 00:00:00.000'


----exec [RateCards].[usp_GetGuideRateCardSearchReportNew] 'AED','1', 26, 'BOM',205,206,'',0,'2025-08-01 00:00:00.000','2025-08-31 00:00:00.000'

CREATE PROCEDURE [RateCards].[usp_GetGuideRateCardSearchReportNew]
(
<<<<<<< HEAD
<<<<<<< HEAD
    @DisplayRate           VARCHAR(5)  = 'RAI',   --- Available
    @RateCardModeType    Varchar(50)         = 2,   --- Available
    @TaxID                 INT        = 26,
    @CityIata              CHAR(3)     = 'BOM',   --- Available
    @Service               INT         = 151,   --- Available
    @Vendor                INT         = 1417,   --- Available
    @Language              CHAR(2)     = NULL,
    @NoofPax               INT         = 0,
    @ValidFrom             DATETIME    = '2025-07-03 00:00:00',
    @ValidTo               DATETIME    = '2025-07-30 00:00:00',
	@QuotationID                 INT        = 103
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
  @DisplayRate         VARCHAR(5)     = 'RAI',                       -- Not in JSON, defaulted
@RateCardModeType    VARCHAR(50)    = '1,2,3,4',                   -- From JSON
@TaxID               INT            = 1,                           -- From JSON
@CityIata            CHAR(3)        = 'BOM',                       -- From JSON "CityID"
@Service             INT            = '',                         -- From JSON "GuideServiceID"
@Vendor              INT            = 0,                           -- From JSON "VendorID"
@Language            CHAR(2)        = NULL,                        -- From JSON "LanguageID" (empty)
@NoofPax             INT            = 0,                           -- From JSON "PaxMaximum"
@ValidFrom           DATETIME       = '2025-08-01 00:00:00',       -- From JSON
@ValidTo             DATETIME       = '2025-08-01 00:00:00',       -- From JSON
@QuotationID         INT            = 0,                           -- From JSON
@BookingID           BIGINT         = 10261,                        -- From JSON
@GuidRateID bigint =null
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
)
AS
BEGIN
    SET NOCOUNT ON;  

	DECLARE @RateCardModeTable TABLE (ModeID INT)

-- Convert names to IDs and insert into table
INSERT INTO @RateCardModeTable (ModeID)
SELECT DISTINCT TRY_CAST(value AS INT)
FROM STRING_SPLIT(@RateCardModeType, ',')
WHERE TRY_CAST(value AS INT) IS NOT NULL

	--SET @TaxID = CASE 
 --               WHEN @TaxID = 'Inclusive' THEN 1 
 --               ELSE 2 
 --            END;

    SELECT 
		GRM.GuideRateID,
		'RateCard' as Type,
		GRD.GuideRateDetailID,
		GRC.GuideRateCommissionID,
		GRM.GuideServiceID,
		GRM.CardNumber,
		GRM.Heading,
		GRM.ContractDate,
		GRM.CityID,
		GRM.VendorID ,
		GRM.CurrencyID,
		GRM.LanguageID,
        CT.Name AS City,
        GS.Name AS GuideService,
        VM.VendorName AS Vendor,
		GRM.InfoForOperation,
		GRM.InfoForAgent,
		GRM.InfoForRemark,
		GRM.IsActive,
		GRM.CreatedOn,
	--	GRM.CreatedBy,
		GRM.UpdatedOn,
	--	GRM.UpdatedBy,
		GRM.Notes,
		GRM.StateID,
		GRM.VendorID,
        L.Language,
        CONCAT(GRC.PaxMinimum, ' - ', GRC.PaxMaximum) AS PaxRange,
        GRD.ValidFrom,
        GRD.ValidTo,
		GRC.PaxMinimum,
		GRC.PaxMaximum,
		GRD.MISSequence,
        GRM.CurrencyID,
        CASE GRM.RateCardModeTypeID 
            WHEN 1 THEN 'Contract' 
            WHEN 2 THEN 'Adhoc' 
            WHEN 3 THEN 'Negotiated' 
        END AS RateCardModeType,
        GRM.RateCardModeTypeID,
    (
        SELECT 
            CASE 
                WHEN EXISTS (SELECT 1 FROM [RateCards].[Rules] WHERE RateCardID = grm.GuideRateID) 
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
         ON ld.ParentID = grm.GuideRateID 
         AND ud.DocumentID = ld.DocumentID 
         AND ud.ParentTypeID = 2
    ) AS HasDocument,
	    CAST(CAST(dbo.fnSearchCalculateROE(CASE  WHEN @TaxID = 2 THEN GRC.NetAmountExcludingTax ELSE GRC.NetAmountIncludingTax END, @ValidFrom, @DisplayRate, GRM.CurrencyID ) AS NUMERIC(18, 0)) AS VARCHAR(20)) AS [GrossRate],
        CAST(CAST(dbo.fnSearchCalculateROE(CASE  WHEN @TaxID = 2 THEN GRC.NetAmountExcludingTax ELSE GRC.NetAmountIncludingTax END, @ValidFrom, @DisplayRate, GRM.CurrencyID ) AS NUMERIC(18, 0)) AS VARCHAR(20)) AS [SellingRate],

		 GRC.TaxPercentage,
         GRC.TaxAmount,
         GRC.NetAmountIncludingTax,
         GRC.NetAmountExcludingTax,
<<<<<<< HEAD
<<<<<<< HEAD
		  GRC.NetAmountExcludingTax * dbo.fnGetPurchaseRate(C.Code, @DisplayRate, GETDATE()) AS NetAmountExcludingTax_Con,
		   GRC.NetAmountIncludingTax * dbo.fnGetPurchaseRate(C.Code, @DisplayRate, GETDATE()) AS NetAmountIncludingTax_Con,
=======
		  GRC.NetAmountExcludingTax * dbo.fnGetPurchaseRate(GRM.CurrencyID, @DisplayRate, GETDATE()) AS NetAmountExcludingTax_Con,
		   GRC.NetAmountIncludingTax * dbo.fnGetPurchaseRate(GRM.CurrencyID, @DisplayRate, GETDATE()) AS NetAmountIncludingTax_Con,
>>>>>>> dev
=======
		  GRC.NetAmountExcludingTax * dbo.fnGetPurchaseRate(GRM.CurrencyID, @DisplayRate, GETDATE()) AS NetAmountExcludingTax_Con,
		   GRC.NetAmountIncludingTax * dbo.fnGetPurchaseRate(GRM.CurrencyID, @DisplayRate, GETDATE()) AS NetAmountIncludingTax_Con,
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
		   GRM.InfoForOperation,
GRM.InfoForRemark,
GRM.notes as ValueAddOn
    FROM RateCards.GuideRateMaster GRM
    INNER JOIN RateCards.GuideRateDetails GRD ON GRD.GuideRateID = GRM.GuideRateID
    LEFT JOIN [Language] L ON L.ID = GRM.LanguageID
    LEFT JOIN RateCards.GuideRateCommissionDetails GRC  ON GRC.GuideRateDetailID = GRD.GuideRateDetailID
    LEFT JOIN City CT  ON CT.IATACode = GRM.CityID
    LEFT JOIN VendorMaster VM  ON VM.VendorID = GRM.VendorID
    LEFT JOIN GuideServices GS ON GS.Code = GRM.GuideServiceID
<<<<<<< HEAD
<<<<<<< HEAD
    LEFT JOIN Currency C ON C.Code = GRM.CurrencyID
=======
    LEFT JOIN CurrencyMaster C ON C.CurrencyCode = GRM.CurrencyID
>>>>>>> dev
=======
    LEFT JOIN CurrencyMaster C ON C.CurrencyCode = GRM.CurrencyID
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6


	 
    WHERE 
<<<<<<< HEAD
<<<<<<< HEAD
        (GRM.GuideServiceID = @Service)
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
	 (GRM.GuideRateID =@GuidRateID and Isnull(@GuidRateID,0)<>0) Or

       ( (Isnull(@GuidRateID,0)=0) and 
        (GRM.GuideServiceID = @Service OR @Service='' OR @Service=0 OR @Service IS NULL)
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
   -- NOT EXISTS (SELECT 1 FROM @RateCardModeTable) 
       AND GRM.RateCardModeTypeID IN (SELECT ModeID FROM @RateCardModeTable)

        AND (GRM.CityID = @CityIata)
        AND GRM.VendorID = COALESCE(NULLIF(@Vendor, 0), GRM.VendorID)
		AND GRM.LanguageID = COALESCE(NULLIF(@Language, ''), GRM.LanguageID)
        --AND (GRD.TaxID = @TaxID OR @TaxID IS NULL)
        --AND GRD.ValidFrom >= @ValidFrom
        --AND (GRD.ValidTo <= @ValidTo OR @ValidTo IS NULL) 
		AND GRD.ValidFrom <= @ValidFrom AND GRD.ValidTo >=  @ValidTo

        AND GRM.IsActive = 1
        AND GRD.IsActive = 1
		AND (
			NULLIF(@NoofPax, '') IS NULL
			OR @NoofPax BETWEEN GRC.PaxMinimum AND GRC.PaxMaximum
		)
<<<<<<< HEAD
<<<<<<< HEAD
=======
						   AND( (( GRM.BookingID=@BookingID and GRM.RateCardModeTypeID=3) or(GRM.BookingID is null and GRM.RateCardModeTypeID in (1,2,3,4))) or (@BookingID is null) or (@BookingID =0 ))
)
>>>>>>> dev
=======
						   AND( (( GRM.BookingID=@BookingID and GRM.RateCardModeTypeID=3) or(GRM.BookingID is null and GRM.RateCardModeTypeID in (1,2,3,4))) or (@BookingID is null) or (@BookingID =0 ))
)
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
  --  ORDER BY GRM.CityID, GS.Name, GRD.ValidFrom;

  UNION
  SELECT
		CHRM.HotelRateID as GuideRateID,
		'CustomRateCard' as Type,
		0 as GuideRateDetailID,
		RC.RateCommisionID as GuideRateCommissionID,
		CHRM.ServiceID as GuideServiceID,
		'' as CardNumber,
		'' as Heading,
		'' as ContractDate,
		CHRM.CityID,
		CHRM.VendorID,
		CHRM.CurrencyID,
		CHRM.LanguageID,

		CT.Name AS City,
        GS.Name AS GuideService,
        VM.VendorName AS Vendor,
		'' as InfoForOperation,
		'' as InfoForAgent,
		'' as InfoForRemark,
		CHRM.IsActive,
		CHRM.CreatedOn,
		CHRM.UpdatedOn,
		'' as Notes,
		0 as StateID,
		CHRM.VendorID,
	    L.Language,
       CONCAT(RC.MinimumPax, ' - ', RC.MaximumPax) AS PaxRange,
       '' as ValidFrom,
       '' as ValidTo,
		RC.MinimumPax as PaxMinimum,
		RC.MaximumPax as PaxMaximum,
		0 as MISSequence,
        CHRM.CurrencyID,
        '' AS RateCardModeType,
		0 as RateCardModeTypeID,
		0 AS HasRules,
		0 AS HasDocument,
	    CAST(CAST(dbo.fnSearchCalculateROE(CASE  WHEN @TaxID = 2 THEN RC.NetAmountExcludingTax ELSE RC.NetAmountIncludingTax END, @ValidFrom, @DisplayRate, CHRM.CurrencyID ) AS NUMERIC(18, 0)) AS VARCHAR(20)) AS [GrossRate],
        CAST(CAST(dbo.fnSearchCalculateROE(CASE  WHEN @TaxID = 2 THEN RC.NetAmountExcludingTax ELSE RC.NetAmountIncludingTax END, @ValidFrom, @DisplayRate, CHRM.CurrencyID ) AS NUMERIC(18, 0)) AS VARCHAR(20)) AS [SellingRate],

		 RC.TaxPercentage,
        RC.TaxAmount,
         RC.NetAmountIncludingTax,
        RC.NetAmountExcludingTax,
		 RC.NetAmountExcludingTax * dbo.fnGetPurchaseRate(CHRM.CurrencyID, @DisplayRate, GETDATE()) AS NetAmountExcludingTax_Con,
		   RC.NetAmountIncludingTax * dbo.fnGetPurchaseRate(CHRM.CurrencyID, @DisplayRate, GETDATE()) AS NetAmountIncludingTax_Con
	 ,'' as InfoForOperation,
'' as InfoForRemark,
'' as ValueAddOn
	FROM
		CustomRateCards.HotelRateMaster CHRM WITH (NOLOCK)
		LEFT OUTER JOIN [CustomRateCards].[HotelRateCommisionDetails] RC WITH (NOLOCK) ON RC.HotelRateID = CHRM.HotelRateId
		LEFT OUTER JOIN City CT WITH (NOLOCK) ON CT.IATACode = CHRM.CityID
		LEFT JOIN VendorMaster VM WITH (NOLOCK)  ON VM.VendorID = CHRM.VendorID
		LEFT OUTER JOIN GuideServices GS WITH (NOLOCK)  ON GS.Code = CHRM.ServiceID 
		LEFT OUTER JOIN [Language] L WITH (NOLOCK)  ON L.ID = CHRM.LanguageID
	WHERE
		CHRM.RateType=1
		--AND  (CHRM.ServiceID = @Service)
  --      AND (CHRM.CityID = @CityIata)
  --      AND CHRM.VendorID = COALESCE(NULLIF(@Vendor, 0), CHRM.VendorID)
		AND CHRM.LanguageID = COALESCE(NULLIF(@Language, ''), CHRM.LanguageID)
		AND CHRM.IsActive = 1
		--AND (
		--	NULLIF(@NoofPax, '') IS NULL
		--	OR @NoofPax BETWEEN RC.MinimumPax AND RC.MaximumPax
		--)
		AND CHRM.QuotationID=@QuotationID
		AND CHRM.VendorID = COALESCE(NULLIF(@Vendor, 0), CHRM.VendorID)
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



	--ORDER BY CreatedOn DESC
	ORDER BY City,GuideService,ValidFrom



    SET NOCOUNT OFF;
END

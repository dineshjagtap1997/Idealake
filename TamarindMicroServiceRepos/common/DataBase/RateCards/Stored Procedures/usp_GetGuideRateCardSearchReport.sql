



 ---Including     --exec [RateCards].[usp_GetGuideRateCardSearchReport] 'INR','Adhoc', 'Inclusive', 'DEL',7,2957,'HI',3,'2025-05-01 00:00:00.000','2025-05-30 00:00:00.000'
 ----exec [RateCards].[usp_GetGuideRateCardSearchReport] 'USD','Adhoc,Contract', 'Inclusive', 'DEL',7,0,'',3,'2025-05-01 00:00:00.000','2025-05-30 00:00:00.000'
  ----exec [RateCards].[usp_GetGuideRateCardSearchReport] 'INR','Adhoc', 'Inclusive', 'DEL',7,2957,'HI',3,'2025-05-01 00:00:00.000','2025-05-30 00:00:00.000'
-- Excluding Tax  --exec [usp_GetGuideRateCardSearchReport] 'INR','1', '2',  'BOM',207,2956,'EN',7,'2025-05-01 00:00:00.000','2025-05-30 00:00:00.000' 

---exec [usp_GetGuideRateCardSearchReport] 'INR','Contract', 'Exclusive',  'BOM',207,2956,'EN',7,'2025-05-01 00:00:00.000','2025-05-30 00:00:00.000'

CREATE PROCEDURE [RateCards].[usp_GetGuideRateCardSearchReport]
(
    @DisplayRate           VARCHAR(5)  = NULL,   --- Available
    @RateCardModeType    Varchar(50)         = NULL,   --- Available
    @TaxID                 INT        = NULL,
    @CityIata              CHAR(3)     = NULL,   --- Available
    @Service               INT         = NULL,   --- Available
    @Vendor                INT         = NULL,   --- Available
    @Language              CHAR(2)     = NULL,
    @NoofPax               INT         = NULL,
    @ValidFrom             DATETIME    = NULL,
    @ValidTo               DATETIME    = NULL
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
        END AS RateCardType,
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
         GRC.NetAmountExcludingTax
    FROM RateCards.GuideRateMaster GRM
    INNER JOIN RateCards.GuideRateDetails GRD ON GRD.GuideRateID = GRM.GuideRateID
    LEFT JOIN [Language] L ON L.ID = GRM.LanguageID
    LEFT JOIN RateCards.GuideRateCommissionDetails GRC  ON GRC.GuideRateDetailID = GRD.GuideRateDetailID
    LEFT JOIN City CT  ON CT.IATACode = GRM.CityID
    LEFT JOIN VendorMaster VM  ON VM.VendorID = GRM.VendorID
    LEFT JOIN GuideServices GS ON GS.Code = GRM.GuideServiceID
    LEFT JOIN Currency C ON C.Code = GRM.CurrencyID

    WHERE 
        (GRM.GuideServiceID = @Service)
   -- NOT EXISTS (SELECT 1 FROM @RateCardModeTable) 
        AND GRM.RateCardModeTypeID IN (SELECT ModeID FROM @RateCardModeTable)

        AND (GRM.CityID = @CityIata)
        AND GRM.VendorID = COALESCE(NULLIF(@Vendor, 0), GRM.VendorID)
		AND GRM.LanguageID = COALESCE(NULLIF(@Language, ''), GRM.LanguageID)
     --   AND (GRD.TaxID = @TaxID OR @TaxID IS NULL)
        AND GRD.ValidFrom >= @ValidFrom
        AND (GRD.ValidTo <= @ValidTo OR @ValidTo IS NULL) 
        AND GRM.IsActive = 1
        AND GRD.IsActive = 1
		AND (
			NULLIF(@NoofPax, '') IS NULL
			OR @NoofPax BETWEEN GRC.PaxMinimum AND GRC.PaxMaximum
		)
    ORDER BY GRM.CityID, GS.Name, GRD.ValidFrom;

    SET NOCOUNT OFF;
END

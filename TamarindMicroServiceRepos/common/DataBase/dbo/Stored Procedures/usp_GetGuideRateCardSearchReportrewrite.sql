
 ---Including     --exec [usp_GetGuideRateCardSearchReportrewrite] 'INR','2', '1', 'DEL',7,2957,'HI',3,'2025-05-01 00:00:00.000','2025-05-30 00:00:00.000'

-- Excluding Tax  --exec [usp_GetGuideRateCardSearchReport] 'INR','1', '2',  'BOM',207,2956,'EN',7,'2025-05-01 00:00:00.000','2025-05-30 00:00:00.000'

CREATE PROCEDURE [dbo].[usp_GetGuideRateCardSearchReportrewrite]
(
    @DisplayRate           VARCHAR(5)  = NULL,
    @RateCardModeTypeID    INT         = NULL,
    @TaxID                 INT         = NULL,
    @CityIata              CHAR(3)     = NULL,
    @Service               INT         = NULL,
    @Vendor                INT         = NULL,
    @Language              CHAR(2)     = NULL,
    @NoofPax               INT         = NULL,
    @ValidFrom             DATETIME    = NULL,
    @ValidTo               DATETIME    = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        CT.Name AS City,
        GS.Name AS GuideService,
        VM.VendorName AS Vendor,
        L.Language,
        CONCAT(GRC.PaxMinimum, ' - ', GRC.PaxMaximum) AS PaxRange,
        GRD.ValidFrom,
        GRD.ValidTo,
        GRM.CurrencyID,
        CASE GRM.RateCardModeTypeID 
            WHEN 1 THEN 'Contract' 
            WHEN 2 THEN 'Adhoc' 
            WHEN 3 THEN 'Negotiated' 
        END AS RateCardType,
        GRM.RateCardModeTypeID,
        CAST(CAST(
            dbo.fnSearchCalculateROE(
                CASE 
                    WHEN @TaxID = 2 THEN GRC.NetAmountExcludingTax
                    ELSE GRC.NetAmountIncludingTax
                END,
                @ValidFrom,
                @DisplayRate,
                GRM.CurrencyID
            ) AS NUMERIC(18, 0)
        ) AS VARCHAR(20)) AS [Selling Rate]
    FROM RateCards.GuideRateMaster GRM
    INNER JOIN RateCards.GuideRateDetails GRD ON GRD.GuideRateID = GRM.GuideRateID
    INNER JOIN [Language] L ON L.ID = GRM.LanguageID
    LEFT JOIN RateCards.GuideRateCommissionDetails GRC  ON GRC.GuideRateDetailID = GRD.GuideRateDetailID
    LEFT JOIN City CT  ON CT.IATACode = GRM.CityID
    LEFT JOIN VendorMaster VM  ON VM.VendorID = GRM.VendorID
    LEFT JOIN GuideServices GS ON GS.Code = GRM.GuideServiceID
    LEFT JOIN Currency C ON C.Code = GRM.CurrencyID
    WHERE 
        (@Service IS NULL OR GRM.GuideServiceID = @Service)
        AND (@RateCardModeTypeID IS NULL OR GRM.RateCardModeTypeID = @RateCardModeTypeID)
        AND (@CityIata IS NULL OR GRM.CityID = @CityIata)
        AND (@Vendor IS NULL OR GRM.VendorID = @Vendor)
        AND (@Language IS NULL OR GRM.LanguageID = @Language)
        AND GRD.TaxID = @TaxID
        AND GRD.ValidFrom <= @ValidTo
        AND GRD.ValidTo >= @ValidFrom
        AND GRM.IsActive = 1
        AND GRD.IsActive = 1
        AND @NoofPax BETWEEN GRC.PaxMinimum AND GRC.PaxMaximum
    ORDER BY GRM.CityID, GS.Name, GRD.ValidFrom;

    SET NOCOUNT OFF;
END

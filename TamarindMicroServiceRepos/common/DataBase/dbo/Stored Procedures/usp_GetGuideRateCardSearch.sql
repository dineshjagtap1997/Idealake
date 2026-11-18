CREATE PROCEDURE [dbo].[usp_GetGuideRateCardSearch]
--exec [usp_GetGuideRateCardSearch] 10,2,'INR','EN','MUM',44,'2025-02-26 00:00:00.000','2025-02-26 00:00:00.000'

(
    @Service INT = NULL,
    @RateCardModeTypeID INT = NULL,
    @DisplayRate VARCHAR(5) = NULL,
    @Language CHAR(2) = NULL,
    @CityIata CHAR(3) = NULL,
    @Vendor INT = NULL,
    @ValidFrom DATETIME = NULL,
    @ValidTo DATETIME = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        CT.Name AS City,
        VM.VendorName AS Vendor,
        GS.Name AS GuideService,
        A.ValidFrom,
        A.ValidTo,
        CONCAT(A.PaxFrom, ' - ', A.PaxTo) AS PaxRange,
        A.Language,
        A.CurrencyID,
        CASE 
            WHEN dbo.fnSearchCalculateROE(A.NetAmountIncludingTax, @ValidFrom, @DisplayRate, A.CurrencyID) = -101 
            THEN 'NA' 
            ELSE CAST(CAST(dbo.fnSearchCalculateROE(A.NetAmountIncludingTax, @ValidFrom, @DisplayRate, A.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20)) 
        END AS Rate,
        A.InfoForOperation,
        CASE A.RateCardModeTypeID 
            WHEN 1 THEN 'Contract' 
            WHEN 2 THEN 'Adhoc' 
            WHEN 3 THEN 'Negotiated' 
        END AS RateCardType,
        A.CardNumber AS CardNo,
        A.RateCardModeTypeID,
        A.GuideRateID,
        A.GuideRateDetailID,
        A.CityID,
        A.Language,
        A.VendorID
        --A.TaxPercentage,
        --A.TaxAmount,
        --A.NetAmountIncludingTax,
        --A.NetAmountExcludingTax
    FROM 
    (
        SELECT 
            GRM.GuideRateID,
            GRM.CardNumber,
            GRM.RateCardModeTypeID,
            GRM.CityID,
            GRM.VendorID,
            GRM.CurrencyID,
            GRM.GuideServiceID,
            GRM.InfoForOperation,
            GRC.PaxMinimum AS PaxFrom,
            GRC.PaxMaximum AS PaxTo,
            GRD.ValidFrom,
            GRD.ValidTo,
            L.Language,
            GRD.GuideRateDetailID,
            GRC.TaxPercentage,
            GRC.TaxAmount,
            GRC.NetAmountIncludingTax,
            GRC.NetAmountExcludingTax
        FROM RateCards.GuideRateMaster GRM
        INNER JOIN RateCards.GuideRateDetails GRD ON GRD.GuideRateID = GRM.GuideRateID
        INNER JOIN [dbo].[Language] L ON L.ID = GRM.LanguageID
        LEFT JOIN RateCards.GuideRateCommissionDetails GRC ON GRC.GuideRateDetailID = GRD.GuideRateDetailID
        WHERE 
<<<<<<< HEAD
<<<<<<< HEAD
            (@Service IS NULL OR GRM.GuideServiceID = @Service)
=======
            (@Service IS NULL OR @Service = 0 OR GRM.GuideServiceID = @Service)
>>>>>>> dev
=======
            (@Service IS NULL OR @Service = 0 OR GRM.GuideServiceID = @Service)
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
            AND (@RateCardModeTypeID IS NULL OR GRM.RateCardModeTypeID = @RateCardModeTypeID)
            AND (@CityIata IS NULL OR GRM.CityID = @CityIata)
            AND (@Vendor IS NULL OR GRM.VendorID = @Vendor)
            AND (@Language IS NULL OR GRM.LanguageID = @Language)
            AND GRD.ValidFrom <= @ValidTo
            AND GRD.ValidTo >= @ValidFrom
            AND GRM.IsActive = 1
            AND GRD.IsActive = 1
    ) A
    LEFT JOIN City CT ON CT.IATACode = A.CityID
    LEFT JOIN VendorMaster VM ON VM.VendorID = A.VendorID
    LEFT JOIN GuideServices GS ON GS.code = A.GuideServiceID
    LEFT JOIN Currency Cu ON Cu.Code = A.CurrencyID
    ORDER BY City, GS.Name, A.ValidFrom;

    SET NOCOUNT OFF;
END

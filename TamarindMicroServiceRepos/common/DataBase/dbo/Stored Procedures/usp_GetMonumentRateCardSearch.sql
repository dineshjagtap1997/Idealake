CREATE PROCEDURE [dbo].[usp_GetMonumentRateCardSearch]  
--exec [usp_GetMonumentRateCardSearch] 11,1,'INR',1,'AGH',10,'2023-03-13 00:00:00.000','2023-03-13 00:00:00.000'

(                                                   
    @Service  INT = NULL,                                                           
    @RateCardModeTypeID INT = NULL, 
    @DisplayRate VARCHAR(5) = NULL,                                                     
    @NationalityID  INT = NULL,                                                      
    @CityIata  CHAR(3) = NULL,                                                     
    @Vendor INT = NULL,                                                     
    @ValidFrom  DATETIME = NULL,                                                     
    @ValidTo  DATETIME = NULL                                                   
)                                                   
AS                                                    
BEGIN
    SET NOCOUNT ON;

    
    -- Main Query
    SELECT 
        CT.Name AS City, 
        VM.VendorName AS Vendor, 
        MS.Name AS MonumentService, 
        A.Nationality, 
        A.InfoForOperation, 
        A.InfoForRemark, 
        A.ValidFrom, 
        A.ValidTo, 
        A.CurrencyID, 
        --ISNULL(CAST(ROECalc.NetAmountConverted AS NUMERIC(18,2)), 0) AS NetAmountIncludingTax,
		CASE 
            WHEN dbo.fnSearchCalculateROE(A.NetAmountIncludingTax, @ValidFrom, @DisplayRate, A.CurrencyID) = -101 
            THEN 'NA' 
            ELSE CAST(CAST(dbo.fnSearchCalculateROE(A.NetAmountIncludingTax, @ValidFrom, @DisplayRate, A.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20)) 
        END AS Rate,
        CASE A.RateCardModeTypeID 
            WHEN 1 THEN 'Contract' 
            WHEN 2 THEN 'Adhoc' 
            WHEN 3 THEN 'Negotiated' 
        END AS RateCardModeType, 
        A.CardNumber AS CardNo, 
        A.RateCardModeTypeID,
        A.MonumentRateID, 
        A.MonumentDetailID, 
        A.CityID, 
        MS.ClosedOn, 
        MS.ID, 
        A.NationalityID, 
        A.VendorID,
        A.TaxPercentage, 
        A.TaxAmount, 
        A.NetAmountIncludingTax, 
        A.NetAmountExcludingTax, 
        RCM.RateType 
    FROM 
    (
        SELECT 
            MRM.MonumentRateID, 
            MRM.CardNumber, 
            MRM.RateCardModeTypeID, 
            MRM.CityID, 
            MRM.VendorID, 
            MRM.CurrencyID,
            MRM.MonumentServiceID, 
            MRM.InfoForOperation, 
            MRM.InfoForRemark, 
            CAST(MRD.ValidFrom AS DATE) AS ValidFrom, 
            CAST(MRD.ValidTo AS DATE) AS ValidTo, 
            --@DisplayRate AS Currency,
            N.Nationality, 
            MRD.MonumentDetailID, 
            MRD.NationalityID,
            CRC.CommissionMasterID, 
            CRC.TaxPercentage,
            CRC.TaxAmount, 
            CRC.NetAmountIncludingTax, 
            CRC.NetAmountExcludingTax
        FROM RateCards.MonumentRateMaster MRM
        INNER JOIN RateCards.MonumentRateDetails MRD ON MRD.MonumentRateID = MRM.MonumentRateID
        INNER JOIN Nationality N ON N.ID = MRD.NationalityID
        LEFT JOIN RateCards.MonumentRateCommissionDetails CRC ON CRC.MonumentDetailID = MRD.MonumentDetailID
        WHERE 
            (@Service IS NULL OR MRM.MonumentServiceID = @Service)
            AND (@RateCardModeTypeID IS NULL OR MRM.RateCardModeTypeID = @RateCardModeTypeID)
            AND (@CityIata IS NULL OR MRM.CityID = @CityIata) 
            AND (@Vendor IS NULL OR MRM.VendorID = @Vendor)
            AND (MRD.NationalityID = COALESCE(@NationalityID, MRD.NationalityID) OR MRD.NationalityID = 3)
            AND MRD.ValidFrom <= @ValidTo 
            AND MRD.ValidTo >= @ValidFrom
            AND MRM.IsActive = 1
            AND MRD.IsActive = 1
    ) A
    LEFT JOIN City CT ON CT.IATACode = A.CityID
    LEFT JOIN VendorMaster VM ON VM.VendorID = A.VendorID
    LEFT JOIN MonumentService MS ON MS.ID = A.MonumentServiceID
    LEFT JOIN Currency Cu ON Cu.Code = A.CurrencyID
    LEFT JOIN RateCommissionMaster RCM ON RCM.CommMasterID = A.CommissionMasterID
   
    ORDER BY City, MS.Name, A.ValidFrom;

    SET NOCOUNT OFF;
END
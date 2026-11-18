CREATE PROCEDURE [dbo].[usp_GetSpecialServiceRateCardSearch] 
(
<<<<<<< HEAD
<<<<<<< HEAD
    @Service INT = NULL,
    @RateCardModeTypeID INT = NULL,
    @DisplayRate VARCHAR(5) = NULL,
    @NationalityID INT = NULL,
    @CityIata CHAR(3) = NULL,
    @IsVendorOrHotel TINYINT = NULL,
    @VendorOrHotel INT = NULL,
    @ValidFrom DATETIME = NULL,
    @ValidTo DATETIME = NULL
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    --@Service INT = NULL,
    --@RateCardModeTypeID INT = NULL,
    --@DisplayRate VARCHAR(5) = NULL,
    --@NationalityID INT = NULL,
    --@CityIata CHAR(3) = NULL,
    --@IsVendorOrHotel TINYINT = NULL,
    --@VendorOrHotel INT = NULL,
    --@ValidFrom DATETIME = NULL,
    --@ValidTo DATETIME = NULL

	@Service INT = 129674, -- from SpecialServiceRateID
@RateCardModeTypeID INT = 1, 
@DisplayRate VARCHAR(5) = NULL, -- Not provided in JSON
@NationalityID INT = 0,
@CityIata CHAR(3) = NULL, -- CityID is empty in JSON
@IsVendorOrHotel TINYINT = NULL, -- Could be 1 if Vendor or Hotel used
@VendorOrHotel INT = 0, -- VendorID or HotelID is 0
@ValidFrom DATETIME = '2025-08-01T00:00:00',
@ValidTo DATETIME = '2025-08-31T00:00:00'
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        CT.Name AS City,
CASE 
        WHEN @IsVendorOrHotel = 1 THEN 'Vendor : ' + VM.VendorName 
        ELSE 'Hotel : ' + HM.HotelName 
    END AS VendorOrHotelName,        A.Nationality,
        SS.Name AS 'Special Service',
        A.[Valid From],
        A.[Valid To],
        CONVERT(VARCHAR, A.MinimumPax) + ' - ' + CONVERT(VARCHAR, A.MaximumPax) AS PaxRange,
        A.Currency,
        CASE WHEN dbo.fnSearchCalculateROE(A.NetAmountIncludingTax, @ValidFrom, @DisplayRate, A.CurrencyID) = -101 THEN 'NA'
             ELSE CAST(CAST(dbo.fnSearchCalculateROE(A.NetAmountIncludingTax, @ValidFrom, @DisplayRate, A.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20)) END AS NetAmountIncludingTax,
        CASE WHEN dbo.fnSearchCalculateROE(A.NetAmountExcludingTax, @ValidFrom, @DisplayRate, A.CurrencyID) = -101 THEN 'NA'
             ELSE CAST(CAST(dbo.fnSearchCalculateROE(A.NetAmountExcludingTax, @ValidFrom, @DisplayRate, A.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20)) END AS NetAmountExcludingTax,
        
        A.InfoForOperation,
        A.InfoForRemark,
        CASE WHEN A.RateCardModeTypeID = 1 THEN 'Contract'
             WHEN A.RateCardModeTypeID = 2 THEN 'Adhoc'
             WHEN A.RateCardModeTypeID = 3 THEN 'Negotiated' END AS RateCardType,
        A.CardNumber AS CardNo,
        A.RateCardModeTypeID,
        SS.ID,
        A.SpecialServiceRateDetailID,
        A.SpecialServiceRateID,
        
        A.VendorID,
		A.HotelID,
        A.MinimumPax,
        A.MaximumPax,
        A.TaxPercentage,
        A.TaxAmount
       
    FROM (
        SELECT 
            SSRM.SpecialServiceRateID,
            SSRM.CardNumber,
            SSRM.RateCardModeTypeID,
            SSRM.CityID,
            SSRM.HotelID,
			SSRM.VendorID,
            SSRM.CurrencyID,
            SSRM.SpecialServiceID,
            SSRM.InfoForOperation,
            SSRM.InfoForAgent,
			 SSRM.InfoForRemark,
            SSRM.IsActive,
            SCRD.MinimumPax,
            SCRD.MaximumPax,
			SCRD.NetAmountIncludingTax,
			SCRD.NetAmountExcludingTax,
			SCRD.TaxPercentage,
			SCRD.TaxAmount,
            --SSRD.Adult,
            --SSRD.Child,
            --SSRD.Consolidated,
            SSRD.SpecialServiceRateDetailID,
           -- SSRM.IsVendorHotel,
            CONVERT(VARCHAR, SSRD.ValidFrom, 106) AS 'Valid From',
            CONVERT(VARCHAR, SSRD.ValidTo, 106) AS 'Valid To',
            N.Nationality,
            @DisplayRate AS 'Currency'
        FROM RateCards.SpecialServiceRateMaster SSRM
<<<<<<< HEAD
<<<<<<< HEAD
        INNER JOIN RateCards.SpecialServiceRateDeatils SSRD ON SSRD.SpecialServiceRateID = SSRM.SpecialServiceRateID
        INNER JOIN [Nationality] N ON N.ID = SSRD.NationalityID
=======
        LEFT JOIN RateCards.SpecialServiceRateDeatils SSRD ON SSRD.SpecialServiceRateID = SSRM.SpecialServiceRateID
        LEFT JOIN [Nationality] N ON N.ID = SSRD.NationalityID
>>>>>>> dev
=======
        LEFT JOIN RateCards.SpecialServiceRateDeatils SSRD ON SSRD.SpecialServiceRateID = SSRM.SpecialServiceRateID
        LEFT JOIN [Nationality] N ON N.ID = SSRD.NationalityID
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
        LEFT JOIN RateCards.SpecialServiceRateCommissionDeatils SCRD ON SCRD.SpecialServiceRateDetailID = SSRD.SpecialServiceRateDetailID
        WHERE 
            (SSRM.SpecialServiceID = COALESCE(@Service, SSRM.SpecialServiceID))
            AND (@RateCardModeTypeID IS NULL OR SSRM.RateCardModeTypeID = @RateCardModeTypeID)
            AND SSRM.CityID = @CityIata
             AND (@ValidFrom <= SSRD.ValidTo AND @ValidTo >= SSRD.ValidFrom)

            AND (
    (@IsVendorOrHotel = 1 AND SSRM.VendorID = @VendorOrHotel) 
    OR 
    (@IsVendorOrHotel = 0 AND SSRM.HotelID = @VendorOrHotel)
)

            AND (SSRD.NationalityID = CASE WHEN @NationalityID <> '' THEN @NationalityID ELSE SSRD.NationalityID END OR SSRD.NationalityID = 3)
            AND SSRM.IsActive = 1
            AND SSRD.IsActive = 1
    ) A
    LEFT JOIN City CT ON CT.IATACode = A.CityID
    LEFT JOIN VendorMaster VM ON VM.VendorID = A.VendorID
    LEFT JOIN HotelMaster HM ON HM.HotelID = A.HotelID
    LEFT JOIN SpecialServices SS ON SS.ID = A.SpecialServiceID
    LEFT JOIN Currency Cu ON Cu.Code = A.CurrencyID
    ORDER BY City, SS.Name, A.[Valid From]
END

CREATE PROCEDURE [dbo].[usp_GetTransportRateCardSearch]
--exec [usp_GetTransportRateCardSearch] 10,2,'INR','MUM',1,6,'3034-03-07 00:00:00.000','3035-03-06 00:00:00.000',2
(
    @Service INT = NULL,
    @RateCardModeTypeID INT = NULL,
    @DisplayRate VARCHAR(5) = NULL,
    @CityIata CHAR(3) = NULL,
    @IsVendorOrHotel TINYINT = NULL,
    @VendorOrHotel INT = NULL,
    @ValidFrom DATETIME = NULL,
    @ValidTo DATETIME = NULL,
    @VTypeID INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        CT.Name AS City,
        TS.Name AS TransportService,
        
        A.VehicleBaseID AS [Vehicle Base Type], 
        A.VehicleType,
        A.[Valid From], 
        A.[Valid To],
        A.Currency,
        CASE 
            WHEN dbo.fnSearchCalculateROE(A.NetAmountIncludingTax, @ValidFrom, @DisplayRate, A.CurrencyID) = -101 THEN 'NA' 
            ELSE CAST(CAST(dbo.fnSearchCalculateROE(A.NetAmountIncludingTax, @ValidFrom, @DisplayRate, A.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20)) 
        END AS [Total],
        --CASE 
        --    WHEN dbo.fnSearchCalculateROE(A.ExtraChargePerHr, @ValidFrom, @DisplayRate, A.CurrencyID) = -101 THEN 'NA' 
        --    ELSE CAST(CAST(dbo.fnSearchCalculateROE(A.ExtraChargePerHr, @ValidFrom, @DisplayRate, A.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20)) 
        --END AS [ExtraChargePerHr],
        --CASE 
        --    WHEN dbo.fnSearchCalculateROE(A.ExtraChargePerKm, @ValidFrom, @DisplayRate, A.CurrencyID) = -101 THEN 'NA' 
        --    ELSE CAST(CAST(dbo.fnSearchCalculateROE(A.ExtraChargePerKm, @ValidFrom, @DisplayRate, A.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20)) 
        --END AS [ExtraChargePerKm],
        CASE WHEN @IsVendorOrHotel = 1 THEN VM.VendorName ELSE HM.HotelName END AS VendorOrHotelName,
        A.[Info for Ops],
        A.[XO Remark],
        --A.TransportCode AS Code,
		A.TransportServceID,
        
        CardNumber AS CardNo,
         CASE A.RateCardModeTypeID 
            WHEN 1 THEN 'Contract' 
            WHEN 2 THEN 'Adhoc' 
            WHEN 3 THEN 'Negotiated' 
        END AS RateCardModeType,
        TransportRateDetailID,
        TransportRateID,
        A.CityID,
        ModeOfTransport,
		A.RateType,
        A.VendorID,
		A.HotelID,
        A.ID,
        CASE WHEN TS.ModeOfTransport IN (1,2) THEN 1 ELSE 0 END AS Arrival,
        CASE WHEN TS.ModeOfTransport = 1 THEN 1 ELSE 0 END AS Departure
    FROM (
        SELECT 
            TRM.TransportRateID,
            CardNumber,
           RateCardModeTypeID,
            CityID,
            
            CurrencyID,
            --TransportCode,
			TransportServceID,
            InfoForOperation,
            InfoForAgent,
            InfoForRemark,
            --Remarks,
            TRM.IsActive,
            --TRD.Total,
			TRCD.NetAmountIncludingTax,
			TRCD.NetAmountExcludingTax,
            TRD.TransportRateDetailID,
            --TRD.ExtraChargePerHr,
            --TRD.ExtraChargePerKm,
            CONVERT(VARCHAR, TRD.ValidFrom, 103) AS 'Valid From',
            TRD.VehicleBaseID,
            VT.VehicleType,
            CONVERT(VARCHAR, TRD.ValidTo, 103) AS 'Valid To',
            TRM.InfoForOperation AS 'Info for Ops',
            TRM.InfoForRemark AS 'XO Remark',
            TRM.VendorID,
			TRM.HotelID,
            @DisplayRate AS 'Currency',
            
            TRD.MISSequence,
            VT.ID,
            dbo.fnGetZoneForTransport(TRM.TransportRateID) AS ZoneName,
            TRZD.ZoneID,
            RCM.RateType
        FROM RateCards.TransportRateMaster TRM
        INNER JOIN RateCards.TransportRateDetails TRD ON TRD.TransportRateID = TRM.TransportRateID
        INNER JOIN VehicleTypeMaster VT ON VT.ID = TRD.VehicleCategoryID
        LEFT JOIN TransportRateZoneDetails TRZD ON TRZD.TransportRateID = TRD.TransportRateID
        LEFT JOIN RateCards.TransportRateCommissionDetails TRCD ON TRCD.TransportRateDetailID = TRD.TransportRateDetailID
        LEFT JOIN RateCommissionMaster RCM ON RCM.CommMasterID = TRCD.CommissionMasterID
        WHERE 
            (TRM.TransportServceID = ISNULL(@Service, TRM.TransportServceID))
            AND (@RateCardModeTypeID IS NULL OR TRM.RateCardModeTypeID = @RateCardModeTypeID)
            AND (TRM.CityID = ISNULL(@CityIata, TRM.CityID))
            AND (
                (@IsVendorOrHotel = 1 AND TRM.VendorID = ISNULL(@VendorOrHotel, TRM.VendorID))
                OR (@IsVendorOrHotel = 0 AND TRM.HotelID = ISNULL(@VendorOrHotel, TRM.HotelID))
            )
            AND TRM.IsActive = 1
            AND TRD.IsActive = 1
            AND (VT.ID = ISNULL(@VTypeID, VT.ID))
            
    ) A
    LEFT JOIN City CT ON CT.IATACode = A.CityID
    LEFT JOIN VendorMaster VM ON VM.VendorID = A.VendorID
    LEFT JOIN HotelMaster HM ON HM.HotelID = A.HotelID
    INNER JOIN TransportServices TS ON TS.Code = A.TransportServceID
    LEFT JOIN Currency Cu ON Cu.Code = A.CurrencyID
    ORDER BY TS.Name, VendorOrHotelName, A.MISSequence, A.[Valid From];
END

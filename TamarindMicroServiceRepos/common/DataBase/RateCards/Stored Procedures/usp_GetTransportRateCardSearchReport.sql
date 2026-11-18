CREATE PROCEDURE [RateCards].[usp_GetTransportRateCardSearchReport]
(
    @DisplayRate        VARCHAR(5)  = NULL,
    @RateCardModeTypeID VARCHAR(10) = NULL,
    @TaxID              INT         = NULL,
    @Service            INT         = NULL,
    @CityIata           CHAR(3)     = NULL,
    @VendorID           INT         = NULL,
    @ValidFrom          DATETIME    = NULL,
    @ValidTo            DATETIME    = NULL,
    @VTypeID            INT         = NULL,
    @TransportRateDetailID INT      = NULL  -- Fetch specific record
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @RateCardModeTable TABLE (ModeID INT);

    -- Split RateCardModeTypeID CSV
    INSERT INTO @RateCardModeTable (ModeID)
    SELECT DISTINCT TRY_CAST(value AS INT)
    FROM STRING_SPLIT(@RateCardModeTypeID, ',')
    WHERE TRY_CAST(value AS INT) IS NOT NULL;

    -- Select with JSON commission
    SELECT DISTINCT 
        TRD.TransportRateDetailID,
        TRM.TransportRateID,
        CT.Name AS City,
        TS.Name AS TransportService,
        VTM.VehicleType,
        TRD.ValidFrom,
        TRD.ValidTo,
        @DisplayRate AS Currency,
        TRM.CardNumber,
        TRM.ContractDate,
        TRM.CurrencyID,
        TRM.StateID,
        TRM.VendorID,
       VM.VendorName,
        TRM.InfoForOperation,
        TRM.InfoForAgent,
        TRM.InfoForRemark,
        TRM.IsActive,
        TRM.CreatedOn,
        TRM.UpdatedOn,
        TRM.GSTStatus,
        TRM.RateCardModeTypeID,
        TRM.CityID,
        TRD.TaxID,
        TRM.TransportServceID,
        CASE TRM.RateCardModeTypeID
            WHEN 1 THEN 'Contract'
            WHEN 2 THEN 'Adhoc'
            WHEN 3 THEN 'Negotiated'
        END AS RateCardModeType,
        --TS.ModeOfTransport,
        --CASE WHEN TS.ModeOfTransport IN (1,2) THEN 1 ELSE 0 END AS Arrival,
        --CASE WHEN TS.ModeOfTransport = 1 THEN 1 ELSE 0 END AS Departure,
        --VTM.ID AS VehicleCategoryID,

     (
    SELECT *
    FROM
    (
        -- First object: grouped totals
        SELECT
			Null as TransportCommissionDetailID,
            NULL AS CommissionMasterID,
            NULL AS RateType,
		
            SUM(TaxAmount) AS TaxAmount,
            SUM(NetAmountExcludingTax) AS NetAmountExcludingTax,
            SUM(NetAmountIncludingTax) AS NetAmountIncludingTax,
            'Total' AS CommissionType
        FROM RateCards.TransportRateCommissionDetails
        WHERE TransportRateDetailID = TRD.TransportRateDetailID
          AND CommissionMasterID IN (9, 10, 13, 14, 15, 18, 19)

        UNION ALL

        -- Individual commissions
        SELECT
			TRCD.TransportCommissionDetailID,
            TRCD.CommissionMasterID,
		
            RCM.RateType,
            TRCD.TaxAmount,
            TRCD.NetAmountExcludingTax,
            TRCD.NetAmountIncludingTax,
            'Detail' AS CommissionType
        FROM RateCards.TransportRateCommissionDetails TRCD
        INNER JOIN RateCommissionMaster RCM ON RCM.CommMasterID = TRCD.CommissionMasterID
        WHERE TRCD.TransportRateDetailID = TRD.TransportRateDetailID
          AND TRCD.CommissionMasterID NOT IN (9, 10, 13, 14, 15, 18, 19)

    ) AS CombinedCommissions
    FOR JSON PATH
) AS TransportRateCommissionDetails

    FROM RateCards.TransportRateMaster TRM
    INNER JOIN RateCards.TransportRateDetails TRD ON TRD.TransportRateID = TRM.TransportRateID 
    LEFT JOIN VendorMaster VM ON VM.VendorID = TRM.VendorID
    LEFT JOIN City CT ON CT.IATACode = TRM.CityID
    INNER JOIN TransportServices TS ON TS.Code = TRM.TransportServceID
    LEFT JOIN VehicleTypeMaster VTM ON VTM.ID = TRD.VehicleCategoryID

    WHERE 
        ( @TransportRateDetailID IS NULL OR @TransportRateDetailID = '' OR TRD.TransportRateDetailID = @TransportRateDetailID  
        )
    --    OR
    --    (
    --        @TransportRateDetailID IS NULL AND
    --        TRM.TransportServceID = @Service
           AND TRM.RateCardModeTypeID IN (SELECT ModeID FROM @RateCardModeTable)
           AND TRM.CityID = @CityIata
       AND (@VendorID IS NULL OR @VendorID = 0 OR TRM.VendorID = @VendorID)

       --     AND (@TaxID IS NULL OR TRD.TaxID = @TaxID)
    --   --     AND (@VTypeID IS NULL  OR @VendorID = 0 OR VTM.ID = @VTypeID)
            AND TRM.IsActive = 1 
            AND TRD.IsActive = 1 
          --  AND (TRD.ValidFrom >= @ValidFrom AND TRD.ValidTo <= @ValidTo)
    --    )
    ORDER BY TRD.TransportRateDetailID;

    SET NOCOUNT OFF;
END

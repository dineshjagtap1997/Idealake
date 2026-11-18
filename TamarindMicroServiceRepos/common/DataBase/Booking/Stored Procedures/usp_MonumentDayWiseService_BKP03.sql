CREATE PROCEDURE [Booking].[usp_MonumentDayWiseService_BKP03]
    @CheckIn DATE,
    @CheckOut DATE,
    @Adult INT = 2,
    @Child INT = 1,
    @Service INT = 159,
    @BookingID INT = 29,
    @QuotationID INT = 21,
    @RateID BIGINT = 6,
    @RateDetailID NVARCHAR(MAX),
    @UserID UNIQUEIDENTIFIER     
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ReturnCode NVARCHAR(3),
            @ReturnMessage NVARCHAR(MAX),
            @SupplierTax_InCluding TINYINT = 0,
            @OthersRateRefrenceID BIGINT,
            @CurrentRateDetailID NVARCHAR(MAX),
            @CurrentDate DATE;

    SET @SupplierTax_InCluding = (SELECT TOP 1 SupplierTax_InCluding FROM Booking.tbl_Booking WHERE ID = @BookingID);

    CREATE TABLE #OthersRateReferenceIDs (OthersRateRefrenceID BIGINT);
    
    CREATE TABLE #RateDetails (RateDetailID NVARCHAR(MAX));
    INSERT INTO #RateDetails (RateDetailID) 
    SELECT value FROM STRING_SPLIT(@RateDetailID, ',');

    DECLARE @RateDetailCount INT = (SELECT COUNT(*) FROM #RateDetails);
    DECLARE @RateDetailIndex INT = 1;

    WHILE @RateDetailIndex <= @RateDetailCount
    BEGIN
        SELECT @CurrentRateDetailID = RateDetailID FROM (
            SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNum, RateDetailID
            FROM #RateDetails
        ) AS Temp
        WHERE RowNum = @RateDetailIndex;

        --PRINT 'Current RateDetailID: ' + @CurrentRateDetailID;

        INSERT INTO [Booking].[OthersRateCardMasterBooking] (
            RateId,
            ServiceID,
            RateType,
            CardNumber,
            Heading,
            ContractDate,
            RateCardModeTypeID,
            CurrencyID,
            VendorID,
            CityID,
            StateID,
            GstStatus,
            InfoForOperation,
            InfoForAgent,
            InfoForRemark,
            IsActive,
            LanguageID,
            Notes,
            ReferenceRateDetailID,
            ValidFrom,
            ValidTo,
            MISSequence,
            QuotationID,
            Disclaimer,
            ReasonID,
            NationalityID,
            FromDate,
            ToDate,
            BookingID,
            AddedfromBooking,
            CreatedBy,
            CreatedOn,
            IsCustom,
            TaxID
        )
        SELECT DISTINCT 
            grd.MonumentRateID,
            grm.MonumentServiceID,
            2,
            grm.CardNumber,
            grm.Heading,
            grm.ContractDate,
            grm.RateCardModeTypeID,
            grm.CurrencyID,
            grm.VendorID,
            grm.CityID,
            grm.StateID,
            grm.GstStatus,
            grm.InfoForOperation,
            grm.InfoForAgent,
            grm.InfoForRemark,
            grm.IsActive,
            '',
            '',
            @CurrentRateDetailID,
            grd.ValidFrom,
            grd.ValidTo,
            grd.MISSequence,
            @QuotationID,
            '',
            0,
            grd.NationalityID,
            @CheckIn,
            @CheckOut,
            @BookingID,
            1,
            @UserID,
            GETDATE(),
            0,
            grd.TaxID
        FROM 
            [RateCards].[MonumentRateDetails] grd
            INNER JOIN [RateCards].[MonumentRateMaster] grm ON grm.MonumentRateID = grd.MonumentRateID
        WHERE 
            grd.MonumentDetailID = @CurrentRateDetailID;

        SET @OthersRateRefrenceID = SCOPE_IDENTITY();

        INSERT INTO #OthersRateReferenceIDs (OthersRateRefrenceID)
        VALUES (@OthersRateRefrenceID);

        INSERT INTO [Booking].[OthersRateCardCommissionBooking] (
            CommissionRefrenceID,
            RateID,
            MinimumPax,
            MaximumPax,
            TaxPercentage,
            TaxAmount,
            NetAmountExcludingTax,
            NetAmountIncludingTax,
            GrossRate,
            IsActive,
            OthersRateRefrenceID,
            BookingId,
            AddedfromBooking,
            CreatedBy,
            CommissionMasterID
        )
        SELECT 
            DISTINCT
            grc.MonumentCommissionDetailID,
            grd.MonumentDetailID,
            NULL,
            NULL,
            grc.TaxPercentage,
            grc.TaxAmount,
            grc.NetAmountExcludingTax,
            grc.NetAmountIncludingTax,
            CASE
                WHEN ISNULL(@SupplierTax_InCluding, 0) = 0 THEN grc.NetAmountExcludingTax
                WHEN ISNULL(@SupplierTax_InCluding, 0) = 1 THEN grc.NetAmountIncludingTax
            END,
            grm.IsActive,
            @OthersRateRefrenceID,
            @BookingID,
            1,
            @UserID,
            grc.CommissionMasterID
        FROM 
            [RateCards].[MonumentRateDetails] grd
            INNER JOIN [RateCards].[MonumentRateMaster] grm ON grm.MonumentRateID = grd.MonumentRateID
            LEFT JOIN [RateCards].[MonumentRateCommissionDetails] grc ON grd.MonumentDetailID = grc.MonumentDetailID
        WHERE 
            grd.MonumentDetailID = @CurrentRateDetailID;

        SET @RateDetailIndex = @RateDetailIndex + 1;
    END

    DROP TABLE #RateDetails;

    CREATE TABLE #DateRange (Date DATE);

    WITH DateRange AS (
        SELECT @CheckIn AS [Date]
        UNION ALL
        SELECT DATEADD(DAY, 1, [Date])
        FROM DateRange
        WHERE [Date] < @CheckOut
    )
    INSERT INTO #DateRange (Date)
    SELECT [Date] FROM DateRange;

    DECLARE @DateCount INT = (SELECT COUNT(*) FROM #DateRange);
    DECLARE @DateIndex INT = 1;

    WHILE @DateIndex <= @DateCount
    BEGIN
        SELECT @CurrentDate = Date FROM (
            SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNum, Date
            FROM #DateRange
        ) AS Temp
        WHERE RowNum = @DateIndex;

        --SELECT 'currentDate: ' + CAST(@CurrentDate AS VARCHAR);
        
        --SELECT * FROM #OthersRateReferenceIDs;  

        INSERT INTO Booking.DayWiseBooking (
            DayWiseDate,
            City,
            Vendor,
            Nationality,
            Adult,
            Child,
            BookingID,
            RateTypeID,
            ServiceName,
            ServiceID,
            IsActive,
            RateId,
            RateDetailID,
            CreatedBy,
            Currency,
            CreatedOn,
            BORMID,
            Adult_Rate,
            Child_Rate,
            Consolidated
        )
        SELECT 
            D.[Date],
            MRM.CityID,
            MRM.VendorID,
            MRD.NationalityID,
            @Adult,
            @Child,
            @BookingID,
            2,
            MS.Name,
            MS.ID,
            1,
            MRD.MonumentRateID,
            MRD.MonumentDetailID,
            @UserID,
            MRM.CurrencyID,
            GETDATE(),
            ORID.OthersRateRefrenceID,
            0,
            0,
            0
        FROM #DateRange D
        JOIN RateCards.MonumentRateMaster MRM ON 1 = 1
        INNER JOIN RateCards.MonumentRateDetails MRD ON MRD.MonumentRateID = MRM.MonumentRateID
        INNER JOIN MonumentService MS ON MS.ID = MRM.MonumentServiceID
        CROSS JOIN #OthersRateReferenceIDs ORID
        WHERE MRD.MonumentDetailID IN (SELECT value FROM STRING_SPLIT(@RateDetailID, ','));

        SET @DateIndex = @DateIndex + 1;
    END

    DROP TABLE #DateRange;
    DROP TABLE #OthersRateReferenceIDs;

    SELECT '200' AS returnCode, 'New record added successfully.' AS returnMessage;        
END

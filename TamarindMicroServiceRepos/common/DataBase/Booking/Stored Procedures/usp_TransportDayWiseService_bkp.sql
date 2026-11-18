
CREATE PROCEDURE [Booking].[usp_TransportDayWiseService_bkp] 
    @Service INT = 2042,
    @CheckIn DATE = '2025-06-09',
    @CheckOut DATE = '2025-06-10',
    @BookingID INT = 48,
    @QuotationID INT = NULL,
    @UserID UNIQUEIDENTIFIER = NULL,
    @RateID BIGINT = 7,
    @RateDetailID NVARCHAR(Max) = '23,24'  -- Ensure we only use IDs 23 and 24
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ReturnCode NVARCHAR(3),
            @ReturnMessage NVARCHAR(MAX),
            @SupplierTax_InCluding TINYINT = 0;

    -- Create a temporary table to store OthersRateRefrenceID
    CREATE TABLE #TempOthersRateReference (
        ID BIGINT
    );

    SET @SupplierTax_InCluding = (
        SELECT TOP 1 SupplierTax_InCluding
        FROM Booking.tbl_Booking
        WHERE ID = @BookingID
    );

    -- Insert into OthersRateCardMasterBooking and capture generated IDs
    INSERT INTO Booking.OthersRateCardMasterBooking (
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
        TransportModeTypeID,
        HotelZone,
        CityID2,
        QuotationID,
        VehicleCategoryID,
        FromDate,
        ToDate,
        BookingID,
        AddedfromBooking,
        IsCustom,
        TaxID
    )
    OUTPUT INSERTED.ID INTO #TempOthersRateReference(ID)  -- Capture generated IDs
    SELECT DISTINCT 
        grd.TransportRateID,
        grm.TransportServceID,
        3,
        grm.CardNumber,
        grm.Heading,
        grm.ContractDate,
        RateCardModeTypeID,
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
        grd.TransportRateDetailID,
        grd.ValidFrom,
        grd.ValidTo,
        grd.MISSequence,
        grm.TransportModeTypeID,
        grm.HotelZone,
        grm.CityID2,
        @QuotationID,
        grd.VehicleCategoryID,
        @CheckIn,
        @CheckOut,
        @BookingID,
        1,
        0,
        grd.TaxID
    FROM 
        [RateCards].[TransportRateDetails] grd
    INNER JOIN [RateCards].[TransportRateMaster] grm ON grm.TransportRateID = grd.TransportRateID
    WHERE 
        grd.TransportRateDetailID IN (SELECT value FROM STRING_SPLIT(@RateDetailID, ','));

    -- Prepare for booking insertion
    DECLARE @CurrentDate DATE = @CheckIn;
    
    WHILE @CurrentDate <= @CheckOut
    BEGIN
        -- Insert 2 unique entries into DayWiseBooking for each date using the temp table
        DECLARE @InsertedCount INT = 0;  -- Track number of inserted entries
        
        -- Loop to insert 2 unique BORMIDs for each date
        WHILE @InsertedCount < 2
        BEGIN
            INSERT INTO Booking.DayWiseBooking (
                DayWiseDate,
                City,
                ServiceID,
                Vehical,
                Vendor,
                Count,
                BookingID,
                RateTypeID,
                QuotationID,
                ServiceName,
                IsActive,
                CreatedBy,
                CreatedOn,
                RateID,
                RateDetailID,
                Currency,
                BORMID
            )
            SELECT 
                @CurrentDate AS DayWiseDate,
                CT.IATACode AS City,
                TS.Code AS TransportService,
                VTM.ID AS Vehicle,
                TRM.VendorID,
                0 AS [Count],
                @BookingID,
                3 AS RateTypeID,
                @QuotationID,
                TS.Name AS ServiceName,
                1 AS IsActive,
                @UserID AS CreatedBy,
                GETDATE() AS CreatedOn,
                TRD.TransportRateID,
                TRD.TransportRateDetailID,
                CurrencyID,
                TMP.ID  -- Use the ID from the temp table
            FROM 
                RateCards.TransportRateMaster TRM
            JOIN 
                RateCards.TransportRateDetails TRD ON TRD.TransportRateID = TRM.TransportRateID
            LEFT JOIN 
                VendorMaster VM ON VM.VendorID = TRM.VendorID
            LEFT JOIN 
                City CT ON CT.IATACode = TRM.CityID
            JOIN 
                TransportServices TS ON TS.Code = TRM.TransportServceID
            LEFT JOIN 
                VehicleTypeMaster VTM ON VTM.ID = TRD.VehicleCategoryID
            CROSS JOIN 
                (SELECT TOP 2 ID FROM #TempOthersRateReference ORDER BY NEWID()) TMP -- Select 2 random IDs
            WHERE 
                TRD.TransportRateDetailID IN (SELECT value FROM STRING_SPLIT(@RateDetailID, ','))
                AND NOT EXISTS (
                    SELECT 1 
                    FROM Booking.DayWiseBooking DWB
                    WHERE DWB.DayWiseDate = @CurrentDate 
                      AND DWB.BORMID = TMP.ID  -- Check for duplicates based on DayWiseDate and BORMID
                );

            SET @InsertedCount = @InsertedCount + @@ROWCOUNT;  -- Increment the count of inserted rows
        END

        -- Move to the next date
        SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
    END

    -- Clean up the temporary table
    DROP TABLE #TempOthersRateReference;

    SELECT '200' AS returnCode, 'New record added successfully.' AS returnMessage;
END;

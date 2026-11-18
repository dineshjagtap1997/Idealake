
CREATE PROCEDURE [Booking].[usp_TransportDayWiseService-BKP_Ash] 
    @Service INT = 2042,
    @CheckIn DATE = '2025-06-09',
    @CheckOut DATE = '2025-06-10',
    @BookingID INT = 48,
    @QuotationID INT = NULL,
    @UserID UNIQUEIDENTIFIER = NULL,
    @RateID BIGINT = 7,
    @RateDetailID NVARCHAR(MAX) = '23,24'
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Initialize transaction count variables
    DECLARE @TranCount INT = @@TRANCOUNT;
    
    BEGIN TRY
        -- Only start transaction if we're not already in one
        IF @TranCount = 0
            BEGIN TRANSACTION;
        ELSE
            SAVE TRANSACTION usp_TransportDayWiseService_bkp1;
        
        DECLARE @ReturnCode NVARCHAR(3) = '200';
        DECLARE @ReturnMessage NVARCHAR(MAX) = 'Operation completed successfully';
        DECLARE @SupplierTax_InCluding TINYINT = 0;
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;
        DECLARE @ErrorProcedure NVARCHAR(128);
        DECLARE @ErrorLine INT;
        DECLARE @ErrorMessage NVARCHAR(4000);

        -- Validate input parameters
        IF @CheckIn IS NULL OR @CheckOut IS NULL OR @CheckIn > @CheckOut
        BEGIN
            SELECT '400' AS returnCode, 'Invalid date range provided' AS returnMessage;
            RETURN;
        END

        -- Step 1: Prepare temp table for input RateDetailIDs
        CREATE TABLE #InputRateDetails (TransportRateDetailID BIGINT);
        
        -- Handle NULL or empty RateDetailID
        IF @RateDetailID IS NOT NULL AND LTRIM(RTRIM(@RateDetailID)) <> ''
        BEGIN
            INSERT INTO #InputRateDetails (TransportRateDetailID)
            SELECT TRY_CAST(value AS BIGINT) 
            FROM STRING_SPLIT(@RateDetailID, ',')
            WHERE TRY_CAST(value AS BIGINT) IS NOT NULL;
        END
        ELSE
        BEGIN
            SELECT '400' AS returnCode, 'No RateDetailIDs provided' AS returnMessage;
            RETURN;
        END

        -- Verify we got valid RateDetailIDs
        IF NOT EXISTS (SELECT 1 FROM #InputRateDetails)
        BEGIN
            SELECT '400' AS returnCode, 'No valid RateDetailIDs provided' AS returnMessage;
            RETURN;
        END

        -- Step 2: Prepare temp table for output mapping
        CREATE TABLE #TempOthersRateReference (
            ID BIGINT,
            TransportRateDetailID BIGINT
        );

        -- Step 3: Prepare source data in a temp table (fix for the OUTPUT clause issue)
        CREATE TABLE #SourceData (
            TransportRateID BIGINT,
            TransportServceID INT,
            RateType INT,
            CardNumber NVARCHAR(50),
            Heading NVARCHAR(100),
            ContractDate DATE,
            RateCardModeTypeID INT,
            VendorID INT,
            CityID NVARCHAR(10),
            StateID INT,
            GstStatus BIT,
            InfoForOperation NVARCHAR(MAX),
            InfoForAgent NVARCHAR(MAX),
            InfoForRemark NVARCHAR(MAX),
            IsActive BIT,
            LanguageID NVARCHAR(10),
            Notes NVARCHAR(MAX),
            TransportRateDetailID BIGINT,
            ValidFrom DATE,
            ValidTo DATE,
            MISSequence INT,
            TransportModeTypeID INT,
            HotelZone NVARCHAR(100),
            CityID2 NVARCHAR(10),
            QuotationID INT,
            VehicleCategoryID INT,
            FromDate DATE,
            ToDate DATE,
            BookingID INT,
            AddedfromBooking BIT,
            IsCustom BIT,
            TaxID INT,
            rn INT
        );

        -- Populate the source data temp table with proper BIT conversions
        INSERT INTO #SourceData
        SELECT 
            grd.TransportRateID,
            grm.TransportServceID,
            3 AS RateType,
            grm.CardNumber,
            grm.Heading,
            grm.ContractDate,
            grm.RateCardModeTypeID,
            grm.VendorID,
            grm.CityID,
            grm.StateID,
            CASE WHEN grm.GstStatus = 'Active' THEN 1 ELSE 0 END, -- Convert string to BIT
            grm.InfoForOperation,
            grm.InfoForAgent,
            grm.InfoForRemark,
            1 AS IsActive,
            '' AS LanguageID,
            '' AS Notes,
            grd.TransportRateDetailID,
            grd.ValidFrom,
            grd.ValidTo,
            grd.MISSequence,
            grm.TransportModeTypeID,
            grm.HotelZone,
            grm.CityID2,
            @QuotationID AS QuotationID,
            grd.VehicleCategoryID,
            @CheckIn AS FromDate,
            @CheckOut AS ToDate,
            @BookingID AS BookingID,
            1 AS AddedfromBooking,
            0 AS IsCustom,
            grd.TaxID,
            ROW_NUMBER() OVER (ORDER BY grd.TransportRateDetailID) AS rn
        FROM 
            [RateCards].[TransportRateDetails] grd
        INNER JOIN 
            [RateCards].[TransportRateMaster] grm ON grm.TransportRateID = grd.TransportRateID
        INNER JOIN 
            #InputRateDetails Source ON Source.TransportRateDetailID = grd.TransportRateDetailID;

        -- Verify we have source data
        IF NOT EXISTS (SELECT 1 FROM #SourceData)
        BEGIN
            SELECT '404' AS returnCode, 'No matching rate details found' AS returnMessage;
            RETURN;
        END

        -- Step 4: Insert and capture mapping - FIXED OUTPUT CLAUSE
        -- First insert into a temp table with the IDs we need
        DECLARE @InsertedIDs TABLE (ID BIGINT, TransportRateDetailID BIGINT);
        
        INSERT INTO Booking.OthersRateCardMasterBooking (
            RateId,
            ServiceID,
            RateType,
            CardNumber,
            Heading,
            ContractDate,
            RateCardModeTypeID,
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
        OUTPUT INSERTED.ID, INSERTED.ReferenceRateDetailID INTO @InsertedIDs
        SELECT 
            TransportRateID,
            TransportServceID,
            RateType,
            CardNumber,
            Heading,
            ContractDate,
            RateCardModeTypeID,
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
            TransportRateDetailID,
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
        FROM #SourceData;

        -- Now insert into our mapping table
        INSERT INTO #TempOthersRateReference (ID, TransportRateDetailID)
        SELECT ID, TransportRateDetailID FROM @InsertedIDs;

        -- Verify we got mappings
        IF NOT EXISTS (SELECT 1 FROM #TempOthersRateReference)
        BEGIN
            SELECT '500' AS returnCode, 'Failed to create rate mappings' AS returnMessage;
            RETURN;
        END

        -- Step 5: Insert into DayWiseBooking
        DECLARE @CurrentDate DATE = @CheckIn;
        
        WHILE @CurrentDate <= @CheckOut
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
                1,
                @UserID AS CreatedBy,
                GETDATE() AS CreatedOn,
                TRD.TransportRateID,
                TRD.TransportRateDetailID,
                TMP.ID
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
            JOIN 
                #TempOthersRateReference TMP ON TMP.TransportRateDetailID = TRD.TransportRateDetailID
            WHERE 
                TRD.TransportRateDetailID IN (SELECT TransportRateDetailID FROM #InputRateDetails)
                AND NOT EXISTS (
                    SELECT 1 
                    FROM Booking.DayWiseBooking DWB
                    WHERE DWB.DayWiseDate = @CurrentDate 
                      AND DWB.BORMID = TMP.ID
                );

            SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
        END

        -- Clean up
        DROP TABLE #TempOthersRateReference;
        DROP TABLE #InputRateDetails;
        DROP TABLE #SourceData;

        -- Only commit if we started the transaction
        IF @TranCount = 0
            COMMIT TRANSACTION;
        
        SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;
    END TRY
    BEGIN CATCH
        -- Only rollback if we started the transaction
        IF @TranCount = 0 AND @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        -- If we're in a nested transaction, rollback to the savepoint
        ELSE IF @TranCount > 0 AND @@TRANCOUNT > 0
            ROLLBACK TRANSACTION usp_TransportDayWiseService_bkp1;
            
        SELECT 
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE(),
            @ErrorProcedure = ERROR_PROCEDURE(),
            @ErrorLine = ERROR_LINE(),
            @ErrorMessage = ERROR_MESSAGE();
            
        SELECT '500' AS returnCode, 
               'Error in procedure ' + ISNULL(@ErrorProcedure, '') + 
               ' on line ' + CAST(ISNULL(@ErrorLine, 0) AS NVARCHAR(10)) + 
               ': ' + ISNULL(@ErrorMessage, 'Unknown error') AS returnMessage;
    END CATCH
END;

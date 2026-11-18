
create PROCEDURE [Booking].[usp_MonumentDayWiseService_bkp1]
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
    
    -- Initialize transaction count variables
    DECLARE @TranCount INT = @@TRANCOUNT;
    
    BEGIN TRY
        -- Only start transaction if we're not already in one
        IF @TranCount = 0
            BEGIN TRANSACTION;
        ELSE
            SAVE TRANSACTION usp_MonumentDayWise; -- Shortened savepoint name
        
        DECLARE @ReturnCode NVARCHAR(3) = '200';
        DECLARE @ReturnMessage NVARCHAR(MAX) = 'Operation completed successfully';
        DECLARE @SupplierTax_InCluding TINYINT = 0;
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;
        DECLARE @ErrorProcedure NVARCHAR(128);
        DECLARE @ErrorLine INT;
        DECLARE @ErrorMessage NVARCHAR(4000);

        -- Get supplier tax setting
        SET @SupplierTax_InCluding = (SELECT TOP 1 SupplierTax_InCluding FROM Booking.tbl_Booking WHERE ID = @BookingID);

        -- Validate input parameters
        IF @CheckIn IS NULL OR @CheckOut IS NULL OR @CheckIn > @CheckOut
        BEGIN
            SELECT '400' AS returnCode, 'Invalid date range provided' AS returnMessage;
            RETURN;
        END

        -- Step 1: Prepare temp table for input RateDetailIDs
        CREATE TABLE #InputRateDetails (MonumentDetailID BIGINT);
        
        -- Handle NULL or empty RateDetailID
        IF @RateDetailID IS NOT NULL AND LTRIM(RTRIM(@RateDetailID)) <> ''
        BEGIN
            INSERT INTO #InputRateDetails (MonumentDetailID)
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
            MonumentDetailID BIGINT
        );

        -- Step 3: Prepare source data in a temp table
        CREATE TABLE #SourceData (
            MonumentRateID BIGINT,
            MonumentServiceID INT,
            RateType INT,
            CardNumber NVARCHAR(50),
            Heading NVARCHAR(100),
            ContractDate DATE,
            RateCardModeTypeID INT,
            CurrencyID INT,
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
            ReferenceRateDetailID BIGINT,
            ValidFrom DATE,
            ValidTo DATE,
            MISSequence INT,
            QuotationID INT,
            Disclaimer NVARCHAR(MAX),
            ReasonID INT,
            NationalityID INT,
            FromDate DATE,
            ToDate DATE,
            BookingID INT,
            AddedfromBooking BIT,
            CreatedBy UNIQUEIDENTIFIER,
            CreatedOn DATETIME,
            IsCustom BIT,
            TaxID INT,
            rn INT
        );

        -- Populate the source data temp table
        INSERT INTO #SourceData
        SELECT 
            grd.MonumentRateID,
            grm.MonumentServiceID,
            2 AS RateType,
            grm.CardNumber,
            grm.Heading,
            grm.ContractDate,
            grm.RateCardModeTypeID,
            grm.CurrencyID,
            grm.VendorID,
            grm.CityID,
            grm.StateID,
            CASE WHEN grm.GstStatus = 'Active' THEN 1 ELSE 0 END,
            grm.InfoForOperation,
            grm.InfoForAgent,
            grm.InfoForRemark,
            grm.IsActive,
            '' AS LanguageID,
            '' AS Notes,
            grd.MonumentDetailID,
            grd.ValidFrom,
            grd.ValidTo,
            grd.MISSequence,
            @QuotationID AS QuotationID,
            '' AS Disclaimer,
            0 AS ReasonID,
            grd.NationalityID,
            @CheckIn AS FromDate,
            @CheckOut AS ToDate,
            @BookingID AS BookingID,
            1 AS AddedfromBooking,
            @UserID AS CreatedBy,
            GETDATE() AS CreatedOn,
            0 AS IsCustom,
            grd.TaxID,
            ROW_NUMBER() OVER (ORDER BY grd.MonumentDetailID) AS rn
        FROM 
            [RateCards].[MonumentRateDetails] grd
        INNER JOIN 
            [RateCards].[MonumentRateMaster] grm ON grm.MonumentRateID = grd.MonumentRateID
        INNER JOIN 
            #InputRateDetails Source ON Source.MonumentDetailID = grd.MonumentDetailID;

        -- Verify we have source data
        IF NOT EXISTS (SELECT 1 FROM #SourceData)
        BEGIN
            SELECT '404' AS returnCode, 'No matching rate details found' AS returnMessage;
            RETURN;
        END

        -- Step 4: Insert and capture mapping
        DECLARE @InsertedIDs TABLE (ID BIGINT, MonumentDetailID BIGINT);
        
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
        OUTPUT INSERTED.ID, INSERTED.ReferenceRateDetailID INTO @InsertedIDs
        SELECT 
            MonumentRateID,
            MonumentServiceID,
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
        FROM #SourceData;

        -- Now insert into our mapping table
        INSERT INTO #TempOthersRateReference (ID, MonumentDetailID)
        SELECT ID, MonumentDetailID FROM @InsertedIDs;

        -- Verify we got mappings
        IF NOT EXISTS (SELECT 1 FROM #TempOthersRateReference)
        BEGIN
            SELECT '500' AS returnCode, 'Failed to create rate mappings' AS returnMessage;
            RETURN;
        END

        -- Step 5: Insert commission data
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
            grc.MonumentCommissionDetailID,
            grd.MonumentDetailID,
            NULL,
            NULL,
            grc.TaxPercentage,
            grc.TaxAmount,
            grc.NetAmountExcludingTax,
            grc.NetAmountIncludingTax,
            CASE WHEN ISNULL(@SupplierTax_InCluding, 0) = 0 THEN grc.NetAmountExcludingTax
                 ELSE grc.NetAmountIncludingTax END,
            grm.IsActive,
            TMP.ID,
            @BookingID,
            1,
            @UserID,
            grc.CommissionMasterID
        FROM [RateCards].[MonumentRateDetails] grd
        INNER JOIN [RateCards].[MonumentRateMaster] grm ON grm.MonumentRateID = grd.MonumentRateID
        LEFT JOIN [RateCards].[MonumentRateCommissionDetails] grc ON grd.MonumentDetailID = grc.MonumentDetailID
        INNER JOIN #TempOthersRateReference TMP ON TMP.MonumentDetailID = grd.MonumentDetailID
        WHERE grd.MonumentDetailID IN (SELECT MonumentDetailID FROM #InputRateDetails);

        -- Step 6: Insert into DayWiseBooking
        DECLARE @CurrentDate DATE = @CheckIn;
        
        WHILE @CurrentDate <= @CheckOut
        BEGIN
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
                @CurrentDate,
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
                TMP.ID,
                0,
                0,
                0
            FROM 
                RateCards.MonumentRateMaster MRM
            INNER JOIN 
                RateCards.MonumentRateDetails MRD ON MRD.MonumentRateID = MRM.MonumentRateID
            INNER JOIN 
                MonumentService MS ON MS.ID = MRM.MonumentServiceID
            INNER JOIN 
                #TempOthersRateReference TMP ON TMP.MonumentDetailID = MRD.MonumentDetailID
            WHERE 
                MRD.MonumentDetailID IN (SELECT MonumentDetailID FROM #InputRateDetails)
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
            ROLLBACK TRANSACTION usp_MonumentDayWise;
            
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
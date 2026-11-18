
CREATE PROCEDURE [Booking].[usp_SpecialServiceDayWiseService_bkp2] 
    @CheckIn DATE = '2025-07-01',
    @CheckOut DATE = '2025-07-02',
    @Adult INT = 1,
    @Child INT = 2,
    @Service INT = 363,
    @BookingID INT = 42,
    @QuotationID INT = NULL,
    @UserID UNIQUEIDENTIFIER = 'feeceb69-c92c-41a9-98de-fa86fcc009e9',
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
            SAVE TRANSACTION usp_SpecialService;
        
        DECLARE @ReturnCode NVARCHAR(3) = '200';
        DECLARE @ReturnMessage NVARCHAR(MAX) = 'Operation completed successfully';
        DECLARE @SupplierTax_InCluding TINYINT = 0;
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;
        DECLARE @ErrorProcedure NVARCHAR(128);
        DECLARE @ErrorLine INT;
        DECLARE @ErrorMessage NVARCHAR(4000);

        -- Get supplier tax setting
        SET @SupplierTax_InCluding = (
            SELECT TOP 1 SupplierTax_InCluding
            FROM Booking.tbl_Booking
            WHERE ID = @BookingID
        );

        -- Validate input parameters
        IF @CheckIn IS NULL OR @CheckOut IS NULL OR @CheckIn > @CheckOut
        BEGIN
            SELECT '400' AS returnCode, 'Invalid date range provided' AS returnMessage;
            RETURN;
        END

        -- Step 1: Prepare temp table for input RateDetailIDs
        CREATE TABLE #InputRateDetails (SpecialServiceRateDetailID BIGINT);
        
        -- Handle NULL or empty RateDetailID
        IF @RateDetailID IS NOT NULL AND LTRIM(RTRIM(@RateDetailID)) <> ''
        BEGIN
            INSERT INTO #InputRateDetails (SpecialServiceRateDetailID)
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
            SpecialServiceRateDetailID BIGINT
        );

        -- Step 3: Prepare source data in a temp table
        CREATE TABLE #SourceData (
            SpecialServiceRateID BIGINT,
            SpecialServiceID INT,
            RateType INT,
            CardNumber NVARCHAR(50),
            Heading NVARCHAR(100),
            ContractDate DATE,
            RateCardModeTypeID INT,
            CurrencyID NVARCHAR(10),
            VendorID INT,
            CityID NVARCHAR(10),
            StateID INT,
            GstStatus BIT,
            InfoForOperation NVARCHAR(MAX),
            InfoForAgent NVARCHAR(MAX),
            InfoForRemark NVARCHAR(MAX),
            IsActive BIT,
            LanguageID NVARCHAR(10),
            ReferenceRateDetailID BIGINT,
            ValidFrom DATE,
            ValidTo DATE,
            MISSequence INT,
            CreatedOn DATETIME,
            QuotationID INT,
            Disclaimer NVARCHAR(MAX),
            FromDate DATE,
            ToDate DATE,
            NationalityID INT,
            CreatedBy UNIQUEIDENTIFIER,
            BookingID INT,
            IsCustom BIT,
            TaxID INT,
            RatePreferenceID INT,
            rn INT
        );

        -- Populate the source data temp table
        INSERT INTO #SourceData
        SELECT 
            grd.SpecialServiceRateID,
            grm.SpecialServiceID,
            4 AS RateType,
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
            grd.SpecialServiceRateDetailID,
            grd.ValidFrom,
            grd.ValidTo,
            grd.MISSequence,
            GETDATE() AS CreatedOn,
            @QuotationID AS QuotationID,
            '' AS Disclaimer,
            @CheckIn AS FromDate,
            @CheckOut AS ToDate,
            grd.NationalityID,
            @UserID AS CreatedBy,
            @BookingID AS BookingID,
            0 AS IsCustom,
            grd.TaxID,
            grd.RatePreferenceID,
            ROW_NUMBER() OVER (ORDER BY grd.SpecialServiceRateDetailID) AS rn
        FROM 
            [RateCards].[SpecialServiceRateDeatils] grd
        INNER JOIN 
            [RateCards].[SpecialServiceRateMaster] grm ON grm.SpecialServiceRateID = grd.SpecialServiceRateID
        INNER JOIN 
            #InputRateDetails Source ON Source.SpecialServiceRateDetailID = grd.SpecialServiceRateDetailID;

        -- Verify we have source data
        IF NOT EXISTS (SELECT 1 FROM #SourceData)
        BEGIN
            SELECT '404' AS returnCode, 'No matching rate details found' AS returnMessage;
            RETURN;
        END

        -- Step 4: Insert and capture mapping
        DECLARE @InsertedIDs TABLE (ID BIGINT, SpecialServiceRateDetailID BIGINT);
        
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
            ReferenceRateDetailID,
            ValidFrom,
            ValidTo,
            MISSequence,
            CreatedOn,
            QuotationID,
            Disclaimer,
            FromDate,
            ToDate,
            NationalityID,
            CreatedBy,
            BookingID,
            IsCustom,
            TaxID,
            RatePreferenceID
        )
        OUTPUT INSERTED.ID, INSERTED.ReferenceRateDetailID INTO @InsertedIDs
        SELECT 
            SpecialServiceRateID,
            SpecialServiceID,
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
            ReferenceRateDetailID,
            ValidFrom,
            ValidTo,
            MISSequence,
            CreatedOn,
            QuotationID,
            Disclaimer,
            FromDate,
            ToDate,
            NationalityID,
            CreatedBy,
            BookingID,
            IsCustom,
            TaxID,
            RatePreferenceID
        FROM #SourceData;

        -- Now insert into our mapping table
        INSERT INTO #TempOthersRateReference (ID, SpecialServiceRateDetailID)
        SELECT ID, SpecialServiceRateDetailID FROM @InsertedIDs;

        -- Verify we got mappings
        IF NOT EXISTS (SELECT 1 FROM #TempOthersRateReference)
        BEGIN
            SELECT '500' AS returnCode, 'Failed to create rate mappings' AS returnMessage;
            RETURN;
        END

        -- Step 5: Insert commission data
        INSERT INTO [Booking].[OthersRateCardCommissionBooking] (
            CommissionRefrenceID,
            MinimumPax,
            MaximumPax,
            IsAmtIncludedInBasic,
            TaxPercentage,
            TaxAmount,
            NetAmountExcludingTax,
            NetAmountIncludingTax,
            GrossRate,
            IsActive,
            OthersRateRefrenceID,
            RateID,
            BookingID,
            CommissionMasterID
        )
        SELECT 
            grc.SpecialServiceRateCommissionID,
            grc.MinimumPax,
            grc.MaximumPax,
            NULL,
            grc.TaxPercentage,
            grc.TaxAmount,
            grc.NetAmountExcludingTax,
            grc.NetAmountIncludingTax,
            CASE WHEN ISNULL(@SupplierTax_InCluding, 0) = 0 THEN grc.NetAmountExcludingTax
                 ELSE grc.NetAmountIncludingTax END,
            grm.IsActive,
            TMP.ID,
            grd.SpecialServiceRateID,
            @BookingID,
            grc.CommissionMasterID
        FROM [RateCards].[SpecialServiceRateDeatils] grd
        INNER JOIN [RateCards].[SpecialServiceRateMaster] grm ON grm.SpecialServiceRateID = grd.SpecialServiceRateID
        LEFT JOIN [RateCards].[SpecialServiceRateCommissionDeatils] grc ON grd.SpecialServiceRateDetailID = grc.SpecialServiceRateDetailID
        INNER JOIN #TempOthersRateReference TMP ON TMP.SpecialServiceRateDetailID = grd.SpecialServiceRateDetailID
        WHERE grd.SpecialServiceRateDetailID IN (SELECT SpecialServiceRateDetailID FROM #InputRateDetails);

        -- Step 6: Insert into DayWiseBooking
        DECLARE @CurrentDate DATE = @CheckIn;
        
        WHILE @CurrentDate <= @CheckOut
        BEGIN
            INSERT INTO Booking.DayWiseBooking (
                DayWiseDate,
                City,
                ServiceID,
                Vendor,
                Nationality,
                Adult,
                Child,
                BookingID,
                QuotationID,
                RateTypeID,
                ServiceName,
                IsActive,
                CreatedBy,
                CreatedOn,
                RateID,
                RateDetailID,
                Currency,
                Adult_Rate,
                Child_Rate,
                Consolidated,
                BORMID
            )
            SELECT 
                @CurrentDate AS DayWiseDate,
                SSRM.CityID,
                SSRM.SpecialServiceID,
                SSRM.VendorID,
                SSRD.NationalityID,
                0 AS Adult,
                0 AS Child,
                @BookingID,
                @QuotationID,
                4 AS RateTypeID,
                SS.Name AS ServiceName,
                1 AS IsActive,
                @UserID AS CreatedBy,
                GETDATE() AS CreatedOn,
                SSRM.SpecialServiceRateID,
                SSRD.SpecialServiceRateDetailID,
                SSRM.CurrencyID,
                0 AS Adult_Rate,
                0 AS Child_Rate,
                0 AS Consolidated,
                TMP.ID AS BORMID
            FROM 
                RateCards.SpecialServiceRateMaster SSRM
            INNER JOIN 
                RateCards.SpecialServiceRateDeatils SSRD ON SSRD.SpecialServiceRateID = SSRM.SpecialServiceRateID
            INNER JOIN 
                SpecialServices SS ON SS.ID = SSRM.SpecialServiceID
            INNER JOIN 
                #TempOthersRateReference TMP ON TMP.SpecialServiceRateDetailID = SSRD.SpecialServiceRateDetailID
            WHERE 
                SSRD.SpecialServiceRateDetailID IN (SELECT SpecialServiceRateDetailID FROM #InputRateDetails)
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
            ROLLBACK TRANSACTION usp_SpecialService;
            
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
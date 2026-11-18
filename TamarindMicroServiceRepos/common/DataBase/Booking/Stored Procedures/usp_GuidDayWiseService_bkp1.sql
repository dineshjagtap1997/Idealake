
create PROCEDURE [Booking].[usp_GuidDayWiseService_bkp1] 
    @CheckIn DATE = '2025-06-16',
    @CheckOut DATE = '2025-06-18',
    @Service INT = 151,
    @BookingID INT = 49,
    @QuotationID INT = NULL,
    @UserID UNIQUEIDENTIFIER = NULL,
    @RateID BIGINT = 7,
    @RateDetailID NVARCHAR(MAX) = '14,15'
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Initialize transaction count variables
    DECLARE @TranCount INT = @@TRANCOUNT;
    DECLARE @TransactionStarted BIT = 0;
    
    BEGIN TRY
        -- Only start transaction if we're not already in one
        IF @TranCount = 0
        BEGIN
            BEGIN TRANSACTION;
            SET @TransactionStarted = 1;
        END
        ELSE
            SAVE TRANSACTION usp_GuideDayWise;
        
        DECLARE @ReturnCode NVARCHAR(3) = '200';
        DECLARE @ReturnMessage NVARCHAR(MAX) = 'Operation completed successfully';
        DECLARE @OthersRateRefrenceID BIGINT;
        DECLARE @SupplierTax_InCluding TINYINT = 0;
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;
        DECLARE @ErrorProcedure NVARCHAR(128);
        DECLARE @ErrorLine INT;
        DECLARE @ErrorMessage NVARCHAR(4000);
        
        -- Declare table variable for inserted IDs
        DECLARE @InsertedIDs TABLE (ID BIGINT);

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
            IF @TransactionStarted = 1 ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Step 1: Prepare temp table for input RateDetailIDs
        CREATE TABLE #InputRateDetails (GuideRateDetailID BIGINT);
        
        -- Handle NULL or empty RateDetailID
        IF @RateDetailID IS NOT NULL AND LTRIM(RTRIM(@RateDetailID)) <> ''
        BEGIN
            INSERT INTO #InputRateDetails (GuideRateDetailID)
            SELECT TRY_CAST(value AS BIGINT) 
            FROM STRING_SPLIT(@RateDetailID, ',')
            WHERE TRY_CAST(value AS BIGINT) IS NOT NULL;
        END
        ELSE
        BEGIN
            SELECT '400' AS returnCode, 'No RateDetailIDs provided' AS returnMessage;
            IF @TransactionStarted = 1 ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Verify we got valid RateDetailIDs
        IF NOT EXISTS (SELECT 1 FROM #InputRateDetails)
        BEGIN
            SELECT '400' AS returnCode, 'No valid RateDetailIDs provided' AS returnMessage;
            IF @TransactionStarted = 1 ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Step 2: Insert into OthersRateCardMasterBooking
        INSERT INTO [Booking].OthersRateCardMasterBooking (
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
            CreatedOn,
            QuotationID,
            Disclaimer,
            FromDate,
            ToDate,
            AddedFromBooking,
            CreatedBy,
            BookingID,
            IsCustom,
            TaxID
        )
        OUTPUT INSERTED.ID INTO @InsertedIDs
        SELECT DISTINCT 
            grm.GuideRateID,
            grm.GuideServiceID,
            1,
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
            grm.LanguageID,
            grm.Notes,
            grd.GuideRateDetailID,
            grd.ValidFrom,
            grd.ValidTo,
            grd.MISSequence,
            GETDATE(),
            @QuotationID,
            '',
            @CheckIn,
            @CheckOut,
            1,
            @UserID,
            @BookingID,
            0,
            grd.TaxID
        FROM [RateCards].[GuideRateDetails] grd
        INNER JOIN [RateCards].[GuideRateMaster] GRM ON GRM.GuideRateID = grd.GuideRateID
        INNER JOIN #InputRateDetails Source ON Source.GuideRateDetailID = grd.GuideRateDetailID;

        SET @OthersRateRefrenceID = SCOPE_IDENTITY();

        -- Verify we got an ID
        IF @OthersRateRefrenceID IS NULL
        BEGIN
            SELECT '500' AS returnCode, 'Failed to create rate master record' AS returnMessage;
            IF @TransactionStarted = 1 ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Step 3: Insert commission data
        INSERT INTO [Booking].[OthersRateCardCommissionBooking] (
            CommissionRefrenceID,
            RateID,
            CommissionMasterID,
            MinimumPax,
            MaximumPax,
            IsAmtIncludedInBasic,
            TaxPercentage,
            TaxAmount,
            NetAmountExcludingTax,
            NetAmountIncludingTax,
            IsActive,
            OthersRateRefrenceID,
            CreatedOn,
            GrossRate,
            BookingID
        )
        SELECT DISTINCT 
            grc.GuideRateCommissionID,
            grd.GuideRateDetailID,
            grc.GuideRateCommissionID,
            grc.PaxMinimum,
            grc.PaxMaximum,
            NULL,
            grc.TaxPercentage,
            grc.TaxAmount,
            grc.NetAmountExcludingTax,
            grc.NetAmountIncludingTax,
            GRM.IsActive,
            @OthersRateRefrenceID,
            GETDATE(),
            CASE WHEN ISNULL(@SupplierTax_InCluding, 0) = 0 
                 THEN grc.NetAmountExcludingTax
                 ELSE grc.NetAmountIncludingTax END,
            @BookingID
        FROM [RateCards].[GuideRateDetails] grd
        INNER JOIN [RateCards].[GuideRateMaster] GRM ON GRM.GuideRateID = grd.GuideRateID
        LEFT JOIN [RateCards].[GuideRateCommissionDetails] grc ON grd.GuideRateDetailID = grc.GuideRateDetailID
        INNER JOIN #InputRateDetails Source ON Source.GuideRateDetailID = grd.GuideRateDetailID;

        -- Step 4: Insert into DayWiseBooking
        DECLARE @CurrentDate DATE = @CheckIn;
        
        WHILE @CurrentDate <= @CheckOut
        BEGIN
            INSERT INTO Booking.DayWiseBooking (
                DayWiseDate,
                City,
                ServiceID,
                Guide,
                LANGUAGE,
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
            SELECT DISTINCT 
                @CurrentDate,
                GRM.CityID,
                grm.GuideRateID,
                GRM.GuideServiceID,
                GRM.LanguageID,
                GRM.VendorID,
                0 AS [Count],
                @BookingID,
                1,
                @QuotationID,
                GS.Name,
                1,
                @UserID,
                GETDATE(),
                GRD.GuideRateID,
                GRD.GuideRateDetailID,
                CurrencyID,
                @OthersRateRefrenceID
            FROM 
                RateCards.GuideRateMaster GRM
            INNER JOIN 
                RateCards.GuideRateDetails GRD ON GRD.GuideRateID = GRM.GuideRateID
            LEFT JOIN 
                GuideServices GS ON GS.Code = GRM.GuideServiceID
            INNER JOIN 
                #InputRateDetails Source ON Source.GuideRateDetailID = GRD.GuideRateDetailID
            WHERE 
                GRM.IsActive = 1
                AND GRD.IsActive = 1
                AND NOT EXISTS (
                    SELECT 1 
                    FROM Booking.DayWiseBooking DWB
                    WHERE DWB.DayWiseDate = @CurrentDate 
                      AND DWB.BORMID = @OthersRateRefrenceID
                );

            SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
        END

        -- Clean up
        DROP TABLE #InputRateDetails;

        -- Only commit if we started the transaction
        IF @TransactionStarted = 1
            COMMIT TRANSACTION;
        
        SELECT @ReturnCode AS returnCode, 
               @ReturnMessage AS returnMessage,
               @OthersRateRefrenceID AS ID;
    END TRY
    BEGIN CATCH
        -- Only rollback if we started the transaction
        IF @TransactionStarted = 1
            ROLLBACK TRANSACTION;
        -- If we're in a nested transaction, rollback to the savepoint
        ELSE IF @TranCount > 0 AND @@TRANCOUNT > 0
            ROLLBACK TRANSACTION usp_GuideDayWise;
            
        SELECT 
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE(),
            @ErrorProcedure = ERROR_PROCEDURE(),
            @ErrorLine = ERROR_LINE(),
            @ErrorMessage = ERROR_MESSAGE();
            
        SELECT '500' AS returnCode, 
               'Error in procedure ' + ISNULL(@ErrorProcedure, '') + 
               ' on line ' + CAST(ISNULL(@ErrorLine, 0) AS NVARCHAR(10)) + 
               ': ' + ISNULL(@ErrorMessage, 'Unknown error') AS returnMessage,
               NULL AS ID;
    END CATCH
END;
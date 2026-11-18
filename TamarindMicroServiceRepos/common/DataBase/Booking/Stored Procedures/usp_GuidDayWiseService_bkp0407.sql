
CREATE PROCEDURE [Booking].[usp_GuidDayWiseService_bkp0407] 
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
            IF @TransactionStarted = 1 ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Step 1: Prepare temp table for input RateDetailIDs
        CREATE TABLE #InputRateDetails (
            GuideRateDetailID BIGINT PRIMARY KEY,
            RowNum INT IDENTITY(1,1)
        );
        
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

        -- Step 2: Create temp table to store OthersRateRefrenceIDs with their RateDetailIDs
        CREATE TABLE #RateMappings (
            OthersRateRefrenceID BIGINT PRIMARY KEY,
            GuideRateDetailID BIGINT UNIQUE,
            GuideRateID BIGINT,
            GuideServiceID INT,
            CurrencyID NVARCHAR(10),
            VendorID INT,
            CityID NVARCHAR(10),
            LanguageID NVARCHAR(10),
            CardNumber NVARCHAR(50),
            Heading NVARCHAR(100),
            ContractDate DATE,
            RateCardModeTypeID INT,
            StateID INT,
            GstStatus Varchar(100),
            InfoForOperation NVARCHAR(MAX),
            InfoForAgent NVARCHAR(MAX),
            InfoForRemark NVARCHAR(MAX),
            IsActive bit,
            Notes NVARCHAR(MAX),
            ValidFrom DATE,
            ValidTo DATE,
            MISSequence INT,
            TaxID INT
        );
		
		
        -- Populate mappings table with rate details
        INSERT INTO #RateMappings (
            GuideRateDetailID,
            GuideRateID,
            GuideServiceID,
            CurrencyID,
            VendorID,
            CityID,
            LanguageID,
            CardNumber,
            Heading,
            ContractDate,
            RateCardModeTypeID,
            StateID,
            GstStatus,
            InfoForOperation,
            InfoForAgent,
            InfoForRemark,
            IsActive,
            Notes,
            ValidFrom,
            ValidTo,
            MISSequence,
            TaxID
        )
        SELECT 
            grd.GuideRateDetailID,
            grm.GuideRateID,
            grm.GuideServiceID,
            grm.CurrencyID,
            grm.VendorID,
            grm.CityID,
            grm.LanguageID,
            grm.CardNumber,
            grm.Heading,
            grm.ContractDate,
            grm.RateCardModeTypeID,
            grm.StateID,
            grm.GstStatus,
            grm.InfoForOperation,
            grm.InfoForAgent,
            grm.InfoForRemark,
            grm.IsActive,
            grm.Notes,
            grd.ValidFrom,
            grd.ValidTo,
            grd.MISSequence,
            grd.TaxID
        FROM #InputRateDetails ird
        JOIN [RateCards].[GuideRateDetails] grd ON ird.GuideRateDetailID = grd.GuideRateDetailID
        JOIN [RateCards].[GuideRateMaster] grm ON grd.GuideRateID = grm.GuideRateID;

		
		print 'T1'
        -- Insert into OthersRateCardMasterBooking for each mapping
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
        SELECT 
            rm.GuideRateID,
            rm.GuideServiceID,
            1,
            rm.CardNumber,
            rm.Heading,
            rm.ContractDate,
            rm.RateCardModeTypeID,
            rm.CurrencyID,
            rm.VendorID,
            rm.CityID,
            rm.StateID,
            rm.GstStatus,
            rm.InfoForOperation,
            rm.InfoForAgent,
            rm.InfoForRemark,
            rm.IsActive ,
            rm.LanguageID,
            rm.Notes,
            rm.GuideRateDetailID,
            rm.ValidFrom,
            rm.ValidTo,
            rm.MISSequence,
            GETDATE(),
            @QuotationID,
            '',
            @CheckIn,
            @CheckOut,
            1,
            @UserID,
            @BookingID,
            0,
            rm.TaxID
        FROM #RateMappings rm;

        -- Update mappings with the actual IDs from OthersRateCardMasterBooking
        UPDATE rm
        SET rm.OthersRateRefrenceID = ormb.ID
        FROM #RateMappings rm
        JOIN [Booking].OthersRateCardMasterBooking ormb ON 
            ormb.ReferenceRateDetailID = rm.GuideRateDetailID AND
            ormb.BookingID = @BookingID;

        -- Insert commission data for each RateDetailID
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
        SELECT 
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
            grm.IsActive ,
            rm.OthersRateRefrenceID,
            GETDATE(),
            CASE WHEN ISNULL(@SupplierTax_InCluding, 0) = 0 
                 THEN grc.NetAmountExcludingTax
                 ELSE grc.NetAmountIncludingTax END,
            @BookingID
        FROM #RateMappings rm
        JOIN [RateCards].[GuideRateDetails] grd ON rm.GuideRateDetailID = grd.GuideRateDetailID
        JOIN [RateCards].[GuideRateMaster] grm ON grd.GuideRateID = grm.GuideRateID
        LEFT JOIN [RateCards].[GuideRateCommissionDetails] grc ON grd.GuideRateDetailID = grc.GuideRateDetailID;

        -- Step 4: Insert into DayWiseBooking for each date and each RateDetailID
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
            SELECT 
                @CurrentDate,
                rm.CityID,
                rm.GuideRateID,
                rm.GuideServiceID,
                rm.LanguageID,
                rm.VendorID,
                0 AS [Count],
                @BookingID,
                1,
                @QuotationID,
                GS.Name,
                1,
                @UserID,
                GETDATE(),
                rm.GuideRateID,
                rm.GuideRateDetailID,
                rm.CurrencyID,
                rm.OthersRateRefrenceID
            FROM #RateMappings rm
            LEFT JOIN GuideServices GS ON GS.Code = rm.GuideServiceID
            WHERE NOT EXISTS (
                SELECT 1 
                FROM Booking.DayWiseBooking DWB
                WHERE DWB.DayWiseDate = @CurrentDate 
                AND DWB.BORMID = rm.OthersRateRefrenceID
            );

            SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
        END

        -- Clean up
        DROP TABLE #InputRateDetails;
        DROP TABLE #RateMappings;

        -- Only commit if we started the transaction
        IF @TransactionStarted = 1
            COMMIT TRANSACTION;
        
        SELECT @ReturnCode AS returnCode, 
               @ReturnMessage AS returnMessage,
               (SELECT TOP 1 ID FROM [Booking].OthersRateCardMasterBooking 
                WHERE BookingID = @BookingID 
                AND ReferenceRateDetailID IN (SELECT value FROM STRING_SPLIT(@RateDetailID, ','))) AS ID;
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

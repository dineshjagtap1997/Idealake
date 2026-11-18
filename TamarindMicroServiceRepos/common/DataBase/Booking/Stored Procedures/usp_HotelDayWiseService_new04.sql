
CREATE PROCEDURE [Booking].[usp_HotelDayWiseService_new04]
    @HotelID INT = 1,
    @HotelRateDetailID INT = NULL,
    @CheckIn DATE = '2025-08-01',
    @CheckOut DATE = '2025-08-02',
    @QuotationID INT = NULL,
    @BookingID INT = 20,
    @UserID UNIQUEIDENTIFIER = NULL,
    @RateID BIGINT = 1,
    @RateDetailID NVARCHAR(MAX) = '7,8'
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
            HotelRateDetailID INT PRIMARY KEY,
            RowNum INT IDENTITY(1,1)
        );
        
        -- Handle NULL or empty RateDetailID
        IF @RateDetailID IS NOT NULL AND LTRIM(RTRIM(@RateDetailID)) <> ''
        BEGIN
            INSERT INTO #InputRateDetails (HotelRateDetailID)
            SELECT TRY_CAST(value AS INT) 
            FROM STRING_SPLIT(@RateDetailID, ',')
            WHERE TRY_CAST(value AS INT) IS NOT NULL;
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

        -- Step 2: Create temp table to store HotelRateRefrenceIDs with their RateDetailIDs
        CREATE TABLE #RateMappings (
            RowID INT IDENTITY(1,1) PRIMARY KEY,
            HotelRateDetailID INT,
            HotelRateID BIGINT,
            HotelID INT,
            CurrencyID NVARCHAR(10),
            VendorID INT,
            CityID NVARCHAR(10),
            CardNumber NVARCHAR(50),
            Heading NVARCHAR(100),
            ContractDate DATE,
            RateCardModeTypeID INT,
            StateID INT,
            GstStatus VARCHAR(100),
            InfoForOperation NVARCHAR(MAX),
            InfoForAgent NVARCHAR(MAX),
            InfoForRemark NVARCHAR(MAX),
            IsActive BIT,
            RoomCategoryID INT,
            MealPlanID INT,
            Days NVARCHAR(50),
            QuotationHotelRateID INT NULL -- Changed to nullable as we'll populate this later
        );
        
        -- Populate mappings table with rate details
        INSERT INTO #RateMappings (
            HotelRateDetailID,
            HotelRateID,
            HotelID,
            CurrencyID,
            VendorID,
            CityID,
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
            RoomCategoryID,
            MealPlanID,
            Days
        )
        SELECT 
            hrd.HotelRateDetailID,
            hrm.HotelRateID,
            hrm.HotelID,
            hrm.CurrencyId,
            hrm.VendorID,
            hrm.CityID,
            hrm.CardNumber,
            hrm.Heading,
            hrm.ContractDate,
            hrm.RateCardModeTypeID,
            hrm.StateID,
            hrm.GstStatus,
            hrm.InfoForOperation,
            hrm.InfoForAgent,
            hrm.InfoForRemark,
            hrd.IsActive,
            hrd.RoomCategoryID,
            hrd.MealPlanID,
            hrd.Days
        FROM #InputRateDetails ird
        JOIN [RateCards].[HotelRateDetails] hrd ON ird.HotelRateDetailID = hrd.HotelRateDetailID
        JOIN [RateCards].[HotelRateMaster] hrm ON hrd.HotelRateID = hrm.HotelRateID;

        -- Insert into HotelRateCardMasterBooking for each mapping
        INSERT INTO Booking.HotelRateCardMasterBooking (
            HotelRateID, HotelRateDetailID, HotelID, CardNumber, ContractDate, Days,
            RoomCategoryID, MealPlanID, CurrencyID, InfoForRemark, StateID, GstStatus,
            CityID, Heading, InfoForAgent, InfoForOperation, PaymentTypeID, RateCardModeTypeID,
            RateTypeID, ValueAddOn, IsActive, QuotationID, Disclaimer, CheckIn, CheckOut,
            BookingID, AddedFromBooking, IsCustom
        )
        OUTPUT inserted.HotelRateDetailID, inserted.ID INTO #RateMappings(HotelRateDetailID, QuotationHotelRateID)
        SELECT 
            rm.HotelRateID,
            rm.HotelRateDetailID,
            rm.HotelID,
            rm.CardNumber,
            rm.ContractDate,
            rm.Days,
            rm.RoomCategoryID,
            rm.MealPlanID,
            rm.CurrencyID,
            rm.InfoForRemark,
            rm.StateID,
            rm.GstStatus,
            rm.CityID,
            rm.Heading,
            rm.InfoForAgent,
            rm.InfoForOperation,
            1, -- Default PaymentTypeID
            rm.RateCardModeTypeID,
            1, -- Default RateTypeID
            0, -- Default ValueAddOn
            rm.IsActive,
            @QuotationID,
            '',
            @CheckIn,
            @CheckOut,
            @BookingID,
            1,
            0
        FROM #RateMappings rm;

        -- Insert commission data for each RateDetailID
        INSERT INTO Booking.HotelRateCommissionDetailsBooking (
            QuotationHotelRateID, RateCommisionID, CommissionMasterID, GrossRate, TaxPercentage,
            TaxAmount, GrossAmountIncludingTax, GrossAmountExcludingTax, CommisionPercentage, CreatedOn,
            CreatedBy, IsActive, HotelRateID, HotelRateDetailID, QuotationID, NetAmountIncludingTax,
            NetAmountExcludingTax, BookingID, AddedFromBooking
        )
        SELECT 
            rm.QuotationHotelRateID,
            rcd.RateCommisionID,
            ISNULL(rcd.CommissionMasterID, 0),
            CASE WHEN ISNULL(@SupplierTax_InCluding, 0) = 0 THEN rcd.NetAmountExcludingTax
                 WHEN ISNULL(@SupplierTax_InCluding, 0) = 1 THEN rcd.NetAmountIncludingTax END,
            ISNULL(rcd.TaxPercentage, 0),
            ISNULL(rcd.TaxAmount, 0),
            ISNULL(rcd.GrossAmountIncludingTax, 0),
            ISNULL(rcd.GrossAmountExcludingTax, 0),
            ISNULL(rcd.CommisionPercentage, 0),
            GETDATE(),
            @UserID,
            ISNULL(rcd.IsActive, 0),
            rm.HotelRateID,
            rm.HotelRateDetailID,
            @QuotationID,
            rcd.NetAmountIncludingTax,
            rcd.NetAmountExcludingTax,
            @BookingID,
            1
        FROM #RateMappings rm
        JOIN [RateCards].[RateCommisionDetails] rcd ON rm.HotelRateDetailID = rcd.HotelRateDetailID;

        -- Insert meal plan details
        INSERT INTO Booking.HotelRateMealPlanMasterBooking (
            QuotationHotelRateID, MealTypeID, GstPercentage, GstAmount, NetAmountIncludingTax,
            NetAmountExcludingTax, IsActive, CreatedBy, CreatedOn, MasterCommissionID, IsMealDetails,
            DefineAmount, HotelRateID, HotelRateDetailID, QuotationID, AddedFromBooking
        )
        SELECT
            rm.QuotationHotelRateID,
            mp.ID,
            hmm.GstPercentage,
            hmm.GstAmount,
            hmm.NetAmountIncludingTax,
            hmm.NetAmountExcludingTax,
            hmm.IsActive,
            @UserID,
            GETDATE(),
            hmm.MasterCommissionID,
            hmm.IsMealDetails,
            hmm.DefineAmount,
            rm.HotelRateID,
            rm.HotelRateDetailID,
            @QuotationID,
            1
        FROM #RateMappings rm
        JOIN [RateCards].[HotelMealOverviewMaster] hmm ON rm.HotelRateDetailID = hmm.HotelRateDetailID
        JOIN [MealPlan] mp ON rm.MealPlanID = mp.ID AND mp.IsActive = 1
        WHERE hmm.IsActive = 1;

        -- Step 4: Insert into DayWiseBooking for each date and each RateDetailID
        DECLARE @CurrentDate DATE = @CheckIn;
        
        WHILE @CurrentDate < @CheckOut
        BEGIN
            INSERT INTO Booking.DayWiseBooking (
                DayWiseDate,
                City,
                HotelName,
                RoomCategory,
                DBL,
                EBA,
                EBC,
                CNB,
                SGL,
                DBL_Rate,
                EBA_Rate,
                EBC_Rate,
                CNB_Rate,
                SGL_Rate,
                MealPlan,
                Breakfast,
                Lunch,
                Dinner,
                RateTypeID,
                ServiceName,
                Isactive,
                CreatedBy,
                CreatedOn,
                RateID,
                RateDetailID,
                GrossRate,
                Currency,
                BookingID,
                BHRMID,
                Vendor
            )
            SELECT 
                @CurrentDate,
                rm.CityID,
                hm.HotelName,
                rc.Name AS RoomCategory,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                mp.Code AS MealPlan,
                mp.Breakfast,
                mp.Lunch,
                mp.Dinner,
                5,
                'Hotel',
                1,
                @UserID,
                GETDATE(),
                rm.HotelRateID,
                rm.HotelRateDetailID,
                CASE WHEN ISNULL(@SupplierTax_InCluding, 0) = 0 
                     THEN rcd.NetAmountExcludingTax
                     ELSE rcd.NetAmountIncludingTax END,
                rm.CurrencyID,
                @BookingID,
                rm.QuotationHotelRateID,
                rm.VendorID
            FROM #RateMappings rm
            JOIN [HotelMaster] hm ON rm.HotelID = hm.HotelID
            LEFT JOIN [RoomCategory] rc ON rm.RoomCategoryID = rc.ID
            LEFT JOIN [MealPlan] mp ON rm.MealPlanID = mp.ID AND mp.IsActive = 1
            LEFT JOIN [RateCards].[RateCommisionDetails] rcd ON rm.HotelRateDetailID = rcd.HotelRateDetailID
            WHERE NOT EXISTS (
                SELECT 1 
                FROM Booking.DayWiseBooking dwb
                WHERE dwb.DayWiseDate = @CurrentDate 
                AND dwb.BHRMID = rm.QuotationHotelRateID
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
               (SELECT TOP 1 ID FROM Booking.HotelRateCardMasterBooking 
                WHERE BookingID = @BookingID 
                AND HotelRateDetailID IN (SELECT value FROM STRING_SPLIT(@RateDetailID, ','))) AS ID;
    END TRY
    BEGIN CATCH
        -- Only rollback if we started the transaction
        IF @TransactionStarted = 1
            ROLLBACK TRANSACTION;
            
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

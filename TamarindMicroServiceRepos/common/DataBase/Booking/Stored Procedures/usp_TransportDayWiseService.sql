
CREATE PROCEDURE [Booking].[usp_TransportDayWiseService] 
    @Service INT = 2042,
    @CheckIn DATE = '2025-08-01',
    @CheckOut DATE = '2025-08-02',
    @BookingID INT = 36,
    @QuotationID INT = NULL,
    @UserID UNIQUEIDENTIFIER = 'FEECEB69-C92C-41A9-98DE-FA86FCC009E9',
    @RateID BIGINT = 7,
    @RateDetailID NVARCHAR(MAX) = '6,6,7,7'
AS
BEGIN
     SET NOCOUNT ON;
    
    -- Initialize transaction count variables
    DECLARE @TranCount INT = @@TRANCOUNT;
    DECLARE @TransactionStarted BIT = 0;
    DECLARE @NewDayWiseIDs TABLE (ID BIGINT);
	Declare @ID BIGINT;
	DECLARE @EmptyMealList dbo.BookingMealPlanTableType;
    BEGIN TRY
        -- Only start transaction if we're not already in one
        IF @TranCount = 0
        BEGIN
            BEGIN TRANSACTION;
            SET @TransactionStarted = 1;
        END
        ELSE
            SAVE TRANSACTION usp_TransportDayWiseService;
        
        DECLARE @ReturnCode NVARCHAR(3) = '200';
        DECLARE @ReturnMessage NVARCHAR(MAX) = 'The selected item has been added to the Daywise successfully';
		DECLARE @OthersRateRefrenceID BIGINT;
        DECLARE @SupplierTax_InCluding TINYINT = 0;
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;
        DECLARE @ErrorProcedure NVARCHAR(128);
        DECLARE @ErrorLine INT;
        DECLARE @ErrorMessage NVARCHAR(4000);
		
		--Declaring Variable for cursor
		
            DECLARE 
			@TransportRateID BIGINT,
            @ServiceID INT,
            @RateType INT ,
            @CardNumber NVARCHAR(255),
            @Heading  NVARCHAR(255),
            @ContractDate DATETIME,
            @RateCardModeTypeID INT,
            @CurrencyID VARCHAR(50),
            @VendorID INT,
            @CityID NVARCHAR(50),
            @StateID INT,
            @GstStatus VARCHAR(50),
            @InfoForOperation NVARCHAR(255),
            @InfoForAgent NVARCHAR(255),
            @InfoForRemark NVARCHAR(255),
            @IsActive BIT,
            @LanguageID CHAR(5),
            @Notes NVARCHAR(MAX),
            @ReferenceRateDetailID BIGINT,
            @ValidFrom DATETIME,
            @ValidTo DATETIME,
            @MISSequence NVARCHAR(255),
            @CreatedOn DATETIME,
            @Disclaimer NVARCHAR(255),
            @FromDate DATETIME,
            @ToDate DATETIME,
            @AddedFromBooking BIT,
            @CreatedBy UNIQUEIDENTIFIER,
            @IsCustom INT,
            @TaxID INT;
        
        
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

		DECLARE OthersRateCardMasterBooking_cursor CURSOR FOR
			 SELECT DISTINCT grm.TransportRateID,grm.TransportServceID as ServiceID,
				3 as RateType,grm.CardNumber,grm.Heading,
				grm.ContractDate,grm.RateCardModeTypeID,grm.CurrencyID,grm.VendorID,grm.CityID,
				grm.StateID,grm.GstStatus,grm.InfoForOperation,grm.InfoForAgent,grm.InfoForRemark,
				grm.IsActive,'' as LanguageID,'' as Notes,grd.TransportRateDetailID,grd.ValidFrom,
				grd.ValidTo,grd.MISSequence,GETDATE() as CreatedOn,@QuotationID as QuotationID,'' as Disclaimer,
				@CheckIn as FromDate,@CheckOut as ToDate,1 as AddedFromBooking, @UserID as CreatedBy, 
				@BookingID as BookingID,0 as IsCustom,grd.TaxID
			FROM [RateCards].[TransportRateDetails] grd
            INNER JOIN [RateCards].[TransportRateMaster] grm ON grm.TransportRateID = grd.TransportRateID
			WHERE GRD.TransportRateDetailID IN (SELECT value FROM STRING_SPLIT(@RateDetailID, ',')) and GRD.IsActive = 1;
			
			OPEN OthersRateCardMasterBooking_Cursor;
			FETCH NEXT
					FROM OthersRateCardMasterBooking_Cursor
					INTO 
					@TransportRateID,@ServiceID,@RateType,@CardNumber,@Heading,@ContractDate,@RateCardModeTypeID,@CurrencyID,
					@VendorID,@CityID,@StateID,@GstStatus,@InfoForOperation,@InfoForAgent,@InfoForRemark,@IsActive,
					@LanguageID,@Notes,@ReferenceRateDetailID,@ValidFrom,@ValidTo,@MISSequence,@CreatedOn,
					@QuotationID,@Disclaimer,@FromDate,@ToDate,@AddedFromBooking,@CreatedBy,@BookingID,
					@IsCustom,@TaxID;

			WHILE @@FETCH_STATUS = 0
					BEGIN
						-- Populate mappings table with rate details
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
						) Values (
							@TransportRateID,
							@ServiceID,
							@RateType,
							@CardNumber,
							@Heading,
							@ContractDate,
							@RateCardModeTypeID,
							@CurrencyID,
							@VendorID,
							@CityID,
							@StateID,
							@GstStatus,
							@InfoForOperation,
							@InfoForAgent,
							@InfoForRemark,
							@IsActive,
							@LanguageID,
							@Notes,
							@ReferenceRateDetailID,
							@ValidFrom,
							@ValidTo,
							@MISSequence,
							@CreatedOn,
							@QuotationID,
							@Disclaimer,
							@FromDate,
							@ToDate,
							@AddedFromBooking,
							@CreatedBy,
							@BookingID,
							@IsCustom,
							@TaxID
						);
       
						SET @OthersRateRefrenceID = SCOPE_IDENTITY();

						-- Insert commission data for each RateDetailID
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
							grc.TransportCommissionDetailID,
							grd.TransportRateDetailID,
							NULL,
							NULL,
							grc.TaxPercentage,
							grc.TaxAmount,
							grc.NetAmountExcludingTax,
							grc.NetAmountIncludingTax,
							CASE WHEN ISNULL(@SupplierTax_InCluding, 0) = 0 THEN grc.NetAmountExcludingTax
								 ELSE grc.NetAmountIncludingTax END,
							grm.IsActive,
							@OthersRateRefrenceID as OthersRateRefrenceID,
							@BookingID,
							1,
							@UserID,
							grc.CommissionMasterID
						FROM 
							[RateCards].[TransportRateDetails] grd
							INNER JOIN [RateCards].[TransportRateMaster] grm ON grm.TransportRateID = grd.TransportRateID
							LEFT JOIN [RateCards].[TransportRateCommissionDetails] grc ON grd.TransportRateDetailID = grc.TransportRateDetailID and grc.CommissionMasterID NOT IN (21,22)
						WHERE 
							grd.TransportRateDetailID = @ReferenceRateDetailID and grd.IsActive = 1;

						-- Step 4: Insert into DayWiseBooking for each date and each RateDetailID
       						WITH DateRange
					AS (
						SELECT @CheckIn AS [Date]
		
						UNION ALL
		
						SELECT DATEADD(DAY, 1, [Date])
						FROM DateRange
						WHERE [Date] < @CheckOut  
						)
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
						BORMID,
						Currency
					)OUTPUT INSERTED.ID INTO @NewDayWiseIDs(ID)
					SELECT 
					D.[Date],
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
					@OthersRateRefrenceID as BORMID,
					TRM.CurrencyID
					FROM DateRange D
					JOIN RateCards.TransportRateMaster TRM ON 1 = 1
					LEFT JOIN RateCards.TransportRateDetails TRD ON TRD.TransportRateID = TRM.TransportRateID
					LEFT JOIN TransportServices TS ON TS.Code = TRM.TransportServceID
					LEFT JOIN VendorMaster VM ON VM.VendorID = TRM.VendorID
					LEFT JOIN VehicleTypeMaster VTM ON VTM.ID = TRD.VehicleCategoryID
					LEFT JOIN City CT ON CT.IATACode = TRM.CityID
					WHERE TRD.TransportRateDetailID = @ReferenceRateDetailID
					AND TRM.IsActive = 1 AND TRD.IsActive = 1

					FETCH NEXT
						FROM OthersRateCardMasterBooking_Cursor
						INTO 
						@TransportRateID,@ServiceID,@RateType,@CardNumber,@Heading,@ContractDate,@RateCardModeTypeID,@CurrencyID,
						@VendorID,@CityID,@StateID,@GstStatus,@InfoForOperation,@InfoForAgent,@InfoForRemark,@IsActive,
						@LanguageID,@Notes,@ReferenceRateDetailID,@ValidFrom,@ValidTo,@MISSequence,@CreatedOn,
						@QuotationID,@Disclaimer,@FromDate,@ToDate,@AddedFromBooking,@CreatedBy,@BookingID,
						@IsCustom,@TaxID;
					END
					
					--DECLARE cur CURSOR FOR SELECT ID FROM @NewDayWiseIDs;
					--OPEN cur;
					--FETCH NEXT FROM cur INTO @ID;
					--WHILE @@FETCH_STATUS = 0
					--BEGIN
					--	EXEC Booking.UpdateDayWiseBooking
					--		@Action = 'IXO',
					--		@ID = @ID,@SGL_Rate = NULL,@MealList = @EmptyMealList;
					--	FETCH NEXT FROM cur INTO @ID;
					--END
					--CLOSE cur;
					--DEALLOCATE cur;

					update book set book.currency=c.id, book.modifiedon=getdate() from Booking.tbl_Booking book
					inner join booking.daywisebooking dwb on dwb.bookingid=book.id 
					left join CurrencyMaster c on c.CurrencyCode=dwb.Currency
					where dwb.bookingid=@BookingID
        -- Only commit if we started the transaction
        IF @TransactionStarted = 1
            COMMIT TRANSACTION;
        
        SELECT @ReturnCode AS returnCode, 
               @ReturnMessage AS returnMessage,
               (SELECT TOP 1 ID FROM [Booking].OthersRateCardMasterBooking 
                WHERE BookingID = @BookingID 
                AND ReferenceRateDetailID IN (SELECT value FROM STRING_SPLIT(@RateDetailID, ','))) AS ID,
					getdate() as LastSavedOn;

				CLOSE OthersRateCardMasterBooking_Cursor;
				DEALLOCATE OthersRateCardMasterBooking_Cursor;
    END TRY
    BEGIN CATCH
        -- Only rollback if we started the transaction
		CLOSE OthersRateCardMasterBooking_Cursor;
		DEALLOCATE OthersRateCardMasterBooking_Cursor;
        IF @TransactionStarted = 1
            ROLLBACK TRANSACTION;
        -- If we're in a nested transaction, rollback to the savepoint
        ELSE IF @TranCount > 0 AND @@TRANCOUNT > 0
            ROLLBACK TRANSACTION usp_TransportDayWiseService;
            
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
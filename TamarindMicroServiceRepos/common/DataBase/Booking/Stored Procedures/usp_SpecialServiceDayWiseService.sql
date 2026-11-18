CREATE PROCEDURE [Booking].[usp_SpecialServiceDayWiseService] 
@CheckIn       DATE = '2025-07-25',
@CheckOut      DATE = '2025-07-31',
@Service       INT = 250,
@BookingID     INT = 1,
@UserID        UNIQUEIDENTIFIER = 'feeceb69-c92c-41a9-98de-fa86fcc009e9',
@RateDetailID  NVARCHAR(MAX) = '1',
    @Adult INT = 1,
    @Child INT = 2,
    @QuotationID INT = NULL,
    @RateID BIGINT = 7
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Initialize transaction count variables
    DECLARE @TranCount INT = @@TRANCOUNT;
    DECLARE @TransactionStarted BIT = 0;
    DECLARE @NewDayWiseIDs TABLE (ID BIGINT);
	DECLARE @EmptyMealList dbo.BookingMealPlanTableType;
	Declare @ID BIGINT;
    BEGIN TRY
        -- Only start transaction if we're not already in one
        IF @TranCount = 0
        BEGIN
            BEGIN TRANSACTION;
            SET @TransactionStarted = 1;
        END
        ELSE
            SAVE TRANSACTION usp_SpecialServiceDayWiseService;
        
        DECLARE @ReturnCode NVARCHAR(3) = '200';
        DECLARE @ReturnMessage NVARCHAR(MAX) = 'Operation completed successfully';
		DECLARE @OthersRateRefrenceID BIGINT;
        DECLARE @SupplierTax_InCluding TINYINT = 0;
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;
        DECLARE @ErrorProcedure NVARCHAR(128);
        DECLARE @ErrorLine INT;
        DECLARE @ErrorMessage NVARCHAR(4000);
		
		--Declaring Variable for cursor
		
            DECLARE 
			@SpecialServiceRateID BIGINT,
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
			 SELECT DISTINCT grm.SpecialServiceRateID,grm.SpecialServiceID as ServiceID,
				4 as RateType,grm.CardNumber,grm.Heading,
				grm.ContractDate,grm.RateCardModeTypeID,grm.CurrencyID,grm.VendorID,grm.CityID,
				grm.StateID,grm.GstStatus,grm.InfoForOperation,grm.InfoForAgent,grm.InfoForRemark,
				grm.IsActive,'' as LanguageID,'' as Notes,grd.SpecialServiceRateDetailID,grd.ValidFrom,
				grd.ValidTo,grd.MISSequence,GETDATE() as CreatedOn,@QuotationID as QuotationID,'' as Disclaimer,
				@CheckIn as FromDate,@CheckOut as ToDate,1 as AddedFromBooking, @UserID as CreatedBy, 
				@BookingID as BookingID,0 as IsCustom,grd.TaxID
			FROM [RateCards].[SpecialServiceRateDeatils] grd
			INNER JOIN [RateCards].[SpecialServiceRateMaster] grm ON grm.SpecialServiceRateID = grd.SpecialServiceRateID
			LEFT JOIN [RateCards].[SpecialServiceRateCommissionDeatils] grc ON grd.SpecialServiceRateDetailID = grc.SpecialServiceRateDetailID	
			WHERE grd.SpecialServiceRateDetailID IN (SELECT value FROM STRING_SPLIT(@RateDetailID, ',')) and grd.IsActive = 1;
			
			OPEN OthersRateCardMasterBooking_Cursor;
			FETCH NEXT
					FROM OthersRateCardMasterBooking_Cursor
					INTO 
					@SpecialServiceRateID,@ServiceID,@RateType,@CardNumber,@Heading,@ContractDate,@RateCardModeTypeID,@CurrencyID,
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
							@SpecialServiceRateID,
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


						INSERT INTO [Booking].[OthersRateCardCommissionBooking] (
							CommissionRefrenceID
							,MinimumPax
							,MaximumPax
							,IsAmtIncludedInBasic
							,TaxPercentage
							,TaxAmount
							,NetAmountExcludingTax
							,NetAmountIncludingTax
							,GrossRate
							,IsActive
							,OthersRateRefrenceID
							,RateID
							,BookingID
							,CommissionMasterID
							)
						SELECT grc.SpecialServiceRateCommissionID
							,grc.MinimumPax
							,grc.MaximumPax
							,NULL
							,grc.TaxPercentage
							,grc.TaxAmount
							,grc.NetAmountExcludingTax
							,grc.NetAmountIncludingTax
							,(
								CASE 
									WHEN Isnull((
												SELECT Isnull(SupplierTax_InCluding, 0)
												FROM Booking.tbl_Booking
												WHERE ID = @BookingID
												), 0) = 0
										THEN grc.NetAmountExcludingTax
									ELSE grc.NetAmountIncludingTax
									END
								)
							,GRM.IsActive
							,@OthersRateRefrenceID
							,grd.SpecialServiceRateID,
							@BookingID
							,grc.CommissionMasterID
						FROM [RateCards].[SpecialServiceRateDeatils] grd
						LEFT JOIN [RateCards].[SpecialServiceRateMaster] GRM ON GRM.SpecialServiceRateID = grd.SpecialServiceRateID
						LEFT JOIN [RateCards].[SpecialServiceRateCommissionDeatils] grc ON grd.SpecialServiceRateDetailID = grc.SpecialServiceRateDetailID
							WHERE grd.SpecialServiceRateDetailID = @ReferenceRateDetailID and grd.IsActive = 1;
						
						WITH DateRange
							AS (
								SELECT @CheckIn AS [Date]
		
								UNION ALL
		
								SELECT DATEADD(DAY, 1, [Date])
								FROM DateRange
								WHERE [Date] < @CheckOut
								)
							INSERT INTO Booking.DayWiseBooking (
								DayWiseDate
								,City
								,ServiceID
								,Vendor
								,Nationality
								,Adult
								,Child
								,BookingID
								,QuotationID
								,RateTypeID
								,ServiceName
								,IsActive
								,CreatedBy
								,CreatedOn
								,RateID
								,RateDetailID
								,Currency
								,Adult_Rate
								,Child_Rate
								,Consolidated
								,BORMID
								)OUTPUT INSERTED.ID INTO @NewDayWiseIDs(ID)
							SELECT DISTINCT 
								 D.[Date]
								,SSRM.CityID
								,SSRM.SpecialServiceID
								,SSRM.VendorID
								,SSRD.NationalityID
								,0
								,0
								,@BookingID
								,@QuotationID
								,4
								,SS.Name
								,1
								,@UserID
								,GETDATE()
								,SSRM.SpecialServiceRateID
								,SSRD.SpecialServiceRateDetailID
								,CurrencyID
								--,CASE
								--	WHEN grc.CommissionMasterID=7 AND @SupplierTax_InCluding=1 THEN grc.NetAmountIncludingTax
								--	WHEN grc.CommissionMasterID=7 AND @SupplierTax_InCluding=0 THEN grc.NetAmountExcludingTax
								--	ELSE 0
								--END
								--,CASE
								--	WHEN grc.CommissionMasterID=8 AND @SupplierTax_InCluding=1 THEN grc.NetAmountIncludingTax
								--	WHEN grc.CommissionMasterID=8 AND @SupplierTax_InCluding=0 THEN grc.NetAmountExcludingTax
								--	ELSE 0
								--END
								--,CASE
								--	WHEN grc.CommissionMasterID=0 AND @SupplierTax_InCluding=1 THEN grc.NetAmountIncludingTax
								--	WHEN grc.CommissionMasterID=0 AND @SupplierTax_InCluding=0 THEN grc.NetAmountExcludingTax
								--	ELSE 0
								--END		
								,0
								,0
								,0		
								,@OthersRateRefrenceID
							FROM DateRange D
							JOIN RateCards.SpecialServiceRateMaster SSRM ON 1 = 1
							LEFT JOIN RateCards.SpecialServiceRateDeatils SSRD ON SSRD.SpecialServiceRateID = SSRM.SpecialServiceRateID
							LEFT JOIN SpecialServices SS ON SS.ID = SSRM.SpecialServiceID
							LEFT JOIN [RateCards].[SpecialServiceRateCommissionDeatils] grc ON SSRD.SpecialServiceRateDetailID = grc.SpecialServiceRateDetailID
							WHERE SSRD.SpecialServiceRateDetailID = @ReferenceRateDetailID and SSRD.IsActive = 1 --AND grc.IsActive=1



					FETCH NEXT
						FROM OthersRateCardMasterBooking_Cursor
						INTO 
						@SpecialServiceRateID,@ServiceID,@RateType,@CardNumber,@Heading,@ContractDate,@RateCardModeTypeID,@CurrencyID,
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
                AND ReferenceRateDetailID IN (SELECT value FROM STRING_SPLIT(@RateDetailID, ','))) AS ID, GETDATE() as LastSavedOn;

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
            ROLLBACK TRANSACTION usp_SpecialServiceDayWiseService;
            
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
CREATE PROCEDURE [Booking].[usp_GuidDayWiseService] 
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
    DECLARE @TranCount INT = @@TRANCOUNT, @ID BIGINT;
    DECLARE @TransactionStarted BIT = 0;
    DECLARE @NewDayWiseIDs TABLE (ID BIGINT);
	DECLARE @EmptyMealList dbo.BookingMealPlanTableType;
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
            @ServiceID INT,
			@GuideRateID BIGINT,
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
		Print 'T1'
		DECLARE OthersRateCardMasterBooking_cursor CURSOR FOR
			 SELECT DISTINCT grm.GuideRateID,grm.GuideServiceID as ServiceID,
				1 as RateType,grm.CardNumber,grm.Heading,
				grm.ContractDate,grm.RateCardModeTypeID,grm.CurrencyID,grm.VendorID,grm.CityID,
				grm.StateID,grm.GstStatus,grm.InfoForOperation,grm.InfoForAgent,grm.InfoForRemark,
				grm.IsActive,grm.LanguageID,grm.Notes,grd.GuideRateDetailID,grd.ValidFrom,
				grd.ValidTo,grd.MISSequence,GETDATE() as CreatedOn,@QuotationID as QuotationID,'' as Disclaimer,
				@CheckIn as FromDate,@CheckOut as ToDate,1 as AddedFromBooking, @UserID as CreatedBy, 
				@BookingID as BookingID,0 as IsCustom,grd.TaxID
			FROM [RateCards].[GuideRateDetails] grd
			JOIN [RateCards].[GuideRateMaster] grm ON grd.GuideRateID = grm.GuideRateID
			WHERE GRD.GuideRateDetailID IN (SELECT value FROM STRING_SPLIT(@RateDetailID, ','))
			and GRD.IsActive = 1;
			
			OPEN OthersRateCardMasterBooking_Cursor;
			FETCH NEXT
					FROM OthersRateCardMasterBooking_Cursor
					INTO 
					@GuideRateID,@ServiceID,@RateType,@CardNumber,@Heading,@ContractDate,@RateCardModeTypeID,@CurrencyID,
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
							@GuideRateID,
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
							GETDATE(),
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
							CommissionRefrenceID
							,RateID
							,CommissionMasterID
							,MinimumPax
							,MaximumPax
							,IsAmtIncludedInBasic
							,TaxPercentage
							,TaxAmount
							,NetAmountExcludingTax
							,NetAmountIncludingTax
							,IsActive
							,OthersRateRefrenceID
							,CreatedOn
							,CreatedBy
							,GrossRate
							,BookingID
						)
					   SELECT DISTINCT 
						grd.GuideRateID
						,grc.GuideRateDetailID
						,grc.GuideRateCommissionID
						,grc.PaxMinimum
						,grc.PaxMaximum
						,NULL
						,grc.TaxPercentage
						,grc.TaxAmount
						,grc.NetAmountExcludingTax
						,grc.NetAmountIncludingTax
						,GRM.IsActive
						,@OthersRateRefrenceID
						,GETDATE()
						,@CreatedBy
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
						,@BookingID
					FROM [RateCards].[GuideRateDetails] grd
					INNER JOIN [RateCards].[GuideRateMaster] GRM ON GRM.GuideRateID = grd.GuideRateID
					LEFT JOIN [RateCards].[GuideRateCommissionDetails] grc ON grd.GuideRateDetailID = grc.GuideRateDetailID
					WHERE GRD.GuideRateDetailID = @ReferenceRateDetailID and GRD.IsActive = 1;

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
						DayWiseDate
						,City
						,ServiceID
						,Guide
						,LANGUAGE
						,Vendor
						,Count
						,BookingID
						,RateTypeID
						,QuotationID
						,ServiceName
						,IsActive
						,CreatedBy
						,CreatedOn
						,RateID
						,RateDetailID
						,Currency
						,BORMID

						)OUTPUT INSERTED.ID INTO @NewDayWiseIDs(ID)
					SELECT DISTINCT 
						 D.[Date]
						,GRM.CityID
						,grm.GuideRateID
						,GRM.GuideServiceID
						,GRM.LanguageID
						,GRM.VendorID
						,0 AS [Count]
						,@BookingID
						,1
						,@QuotationID
						,GS.Name
						,1
						,@UserID
						,getdate()
						,GRD.GuideRateID
						,GRD.GuideRateDetailID
						,CurrencyID
						,@OthersRateRefrenceID as BORMID
					FROM DateRange D
					JOIN RateCards.GuideRateMaster GRM ON 1 = 1
					INNER JOIN RateCards.GuideRateDetails GRD ON GRD.GuideRateID = GRM.GuideRateID
					LEFT JOIN GuideServices GS ON GS.Code = GRM.GuideServiceID
					WHERE GRD.GuideRateDetailID = @ReferenceRateDetailID
						AND GRM.IsActive = 1 AND GRD.IsActive = 1

						Print 'T2';

					FETCH NEXT
						FROM OthersRateCardMasterBooking_Cursor
						INTO 
						@GuideRateID,@ServiceID,@RateType,@CardNumber,@Heading,@ContractDate,@RateCardModeTypeID,@CurrencyID,
						@VendorID,@CityID,@StateID,@GstStatus,@InfoForOperation,@InfoForAgent,@InfoForRemark,@IsActive,
						@LanguageID,@Notes,@ReferenceRateDetailID,@ValidFrom,@ValidTo,@MISSequence,@CreatedOn,
						@QuotationID,@Disclaimer,@FromDate,@ToDate,@AddedFromBooking,@CreatedBy,@BookingID,
						@IsCustom,@TaxID;
					END
        
		
					update book set book.currency=c.id, book.modifiedon=getdate() from Booking.tbl_Booking book
					inner join booking.daywisebooking dwb on dwb.bookingid=book.id 
					left join CurrencyMaster c on c.CurrencyCode=dwb.Currency
					where dwb.bookingid=@BookingID

					--Adding Groupkey to daywiseid
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

        -- Only commit if we started the transaction
        IF @TransactionStarted = 1
            COMMIT TRANSACTION;
        CLOSE OthersRateCardMasterBooking_Cursor;
		DEALLOCATE OthersRateCardMasterBooking_Cursor;

        SELECT @ReturnCode AS returnCode, 
               @ReturnMessage AS returnMessage,
               (SELECT TOP 1 ID FROM [Booking].OthersRateCardMasterBooking 
                WHERE BookingID = @BookingID 
                AND ReferenceRateDetailID IN (SELECT value FROM STRING_SPLIT(@RateDetailID, ','))) AS ID;
    END TRY
    BEGIN CATCH
        -- Only rollback if we started the transaction
		CLOSE OthersRateCardMasterBooking_Cursor;
		DEALLOCATE OthersRateCardMasterBooking_Cursor;
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
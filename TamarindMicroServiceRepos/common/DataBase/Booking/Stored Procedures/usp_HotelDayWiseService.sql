CREATE PROCEDURE [Booking].[usp_HotelDayWiseService] @HotelID INT = 1,
	 @HotelRateDetailID INT = 0
, @CheckIn DATE = '2025-07-24'       -- Converted from ISO datetime
, @CheckOut DATE = '2025-07-30'
, @QuotationID INT = NULL
, @BookingID INT = 10249
, @UserID UNIQUEIDENTIFIER = 'feeceb69-c92c-41a9-98de-fa86fcc009e9'
, @RateID BIGINT = NULL         -- Not present in JSON, so set NULL or default
, @RateDetailID NVARCHAR(MAX) = '127' -- You could also pass '127,128' if multiple
, @offerIncluded BIT = 0
 ,@SGL INT = NULL,
 @Twin INT = NULL,

    @DBL INT = NULL,
    @EBA INT = NULL,
    @EBC INT = NULL,
    @CNB INT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ReturnCode NVARCHAR(3),@ReturnMessage NVARCHAR(MAX);
	DECLARE @QuotationHotelRateID INT = 0,@SupplierTax_InCluding TINYINT = 0;
	DECLARE @NewDayWiseIDs TABLE (ID BIGINT);
	DECLARE @EmptyMealList dbo.BookingMealPlanTableType;
	Declare @ID BIGINT;
	-- Declaring variable for cursor

	DECLARE @HotelRateID BIGINT
	,@CardNumber NVARCHAR(50)
	,@ContractDate DATETIME
	,@Days NVARCHAR(100)
	,@RoomCategoryID INT
	,@MealPlanID INT
	,@CurrencyID NVARCHAR(10)
	,@InfoForRemark NVARCHAR(500)
	,@StateID INT
	,@GstStatus NVARCHAR(10)
	,@CityID NVARCHAR(10)
	,@Heading NVARCHAR(200)
	,@InfoForAgent NVARCHAR(MAX)
	,@InfoForOperation NVARCHAR(MAX)
	,@PaymentTypeID INT
	,@RateCardModeTypeID INT
	,@RateTypeID INT
	,@ValueAddOn NVARCHAR(MAX)
	,@IsActive BIT
	,@Disclaimer NVARCHAR(500)
	,@AddedFromBooking BIT
	,@IsCustom INT
	,@VendorID BIGINT;

	SET @SupplierTax_InCluding = (
			SELECT TOP 1 SupplierTax_InCluding
			FROM Booking.tbl_Booking
			WHERE ID = @BookingID
			);

	BEGIN TRY
		BEGIN TRANSACTION;

			DECLARE HotelRateCardMasterBooking_cursor CURSOR FOR
			SELECT DISTINCT HRD.HotelRateID,HRD.HotelRateDetailID,HRM.HotelID,HRM.CardNumber
				,HRM.ContractDate,HRD.Days,HRD.RoomCategoryID,HRD.MealPlanID,HRM.CurrencyId	
				,HRM.InfoForRemark,HRM.StateID,HRM.GstStatus,HRM.CityID,HRM.Heading
				,HRM.InfoForAgent,HRM.InfoForOperation,HRM.PaymentTypeID,HRM.RateCardModeTypeID
				,HRM.RateTypeID,HRM.ValueAddOn,HRD.IsActive,@QuotationID as QuotationID
				,'' as Disclaimer,@CheckIn as CheckIn,@CheckOut as CheckOut,@BookingID as BookingID,
				1 as AddedFromBooking,0 as IsCustom,CASE WHEN @offerIncluded=1 THEN HRD.OfferTypeID	ELSE 0 END as offerIncluded,VendorID
			FROM RateCards.HotelRateDetails HRD
			LEFT OUTER JOIN RateCards.HotelRateMaster HRM ON HRD.HotelRateID = HRM.HotelRateID
			WHERE HRD.HotelRateDetailID IN (SELECT value FROM STRING_SPLIT(@RateDetailID, ','))
			
			OPEN HotelRateCardMasterBooking_Cursor;
			FETCH NEXT
					FROM HotelRateCardMasterBooking_Cursor
					INTO 
						@HotelRateID,@HotelRateDetailID,@HotelID,@CardNumber,@ContractDate
						,@Days,@RoomCategoryID,@MealPlanID,@CurrencyID,@InfoForRemark
						,@StateID,@GstStatus,@CityID,@Heading,@InfoForAgent,@InfoForOperation
						,@PaymentTypeID,@RateCardModeTypeID,@RateTypeID,@ValueAddOn,@IsActive
						,@QuotationID,@Disclaimer,@CheckIn,@CheckOut,@BookingID,@AddedFromBooking
						,@IsCustom,@offerIncluded,@VendorID

			WHILE @@FETCH_STATUS = 0
					BEGIN

						INSERT INTO Booking.HotelRateCardMasterBooking (
							HotelRateID
							,HotelRateDetailID
							,HotelID
							,CardNumber
							,ContractDate
							,Days
							,RoomCategoryID
							,MealPlanID
							,CurrencyID
							,InfoForRemark
							,StateID
							,GstStatus
							,CityID
							,Heading
							,InfoForAgent
							,InfoForOperation
							,PaymentTypeID
							,RateCardModeTypeID
							,RateTypeID
							,ValueAddOn
							,IsActive
							,QuotationID
							,Disclaimer
							,CheckIn
							,CheckOut
							,BookingID
							,AddedFromBooking
							,IsCustom
							,OfferTypeID
							,VendorID
						) values (
							@HotelRateID
							,@HotelRateDetailID
							,@HotelID
							,@CardNumber
							,@ContractDate
							,@Days
							,@RoomCategoryID
							,@MealPlanID
							,@CurrencyID
							,@InfoForRemark
							,@StateID
							,@GstStatus
							,@CityID
							,@Heading
							,@InfoForAgent
							,@InfoForOperation
							,@PaymentTypeID
							,@RateCardModeTypeID
							,@RateTypeID
							,@ValueAddOn
							,@IsActive
							,@QuotationID
							,@Disclaimer
							,@CheckIn
							,@CheckOut
							,@BookingID
							,@AddedFromBooking
							,@IsCustom
							,@offerIncluded
							,@VendorID
						);
						

						SET @QuotationHotelRateID = SCOPE_IDENTITY();
				
						INSERT INTO Booking.HotelRateCommissionDetailsBooking (
						QuotationHotelRateID
						,RateCommisionID
						,CommissionMasterID
						,GrossRate
						,TaxPercentage
						,TaxAmount
						,GrossAmountIncludingTax
						,GrossAmountExcludingTax
						,CommisionPercentage
						,CreatedOn
						,CreatedBy
						,IsActive
						,HotelRateID
						,HotelRateDetailID
						,QuotationID
						,NetAmountIncludingTax
						,NetAmountExcludingTax
						,BookingID
						,AddedFromBooking
						,CommissionAmount
						)
						SELECT @QuotationHotelRateID as QuotationHotelRateID
							,RCD.RateCommisionID
							,ISNULL(RCD.CommissionMasterID, 0)
							,CASE 
								WHEN ISNULL(@SupplierTax_InCluding, 0) = 0
									THEN RCD.NetAmountExcludingTax
								WHEN ISNULL(@SupplierTax_InCluding, 0) = 1
									THEN RCD.NetAmountIncludingTax
								END
							,ISNULL(RCD.TaxPercentage, 0)
							,ISNULL(RCD.TaxAmount, 0)
							,ISNULL(RCD.GrossAmountIncludingTax, 0)
							,ISNULL(RCD.GrossAmountExcludingTax, 0)
							,ISNULL(RCD.CommisionPercentage, 0)
							,GETDATE()
							,@Userid
							,ISNULL(RCD.IsActive, 0)
							,HRD.HotelRateID
							,HRD.HotelRateDetailID
							,@QuotationID
							,RCD.NetAmountIncludingTax
							,RCD.NetAmountExcludingTax
							,@BookingID
							,1
							,RCD.CommissionAmount
						FROM RateCards.RateCommisionDetails RCD
						LEFT JOIN RateCards.HotelRateDetails HRD ON RCD.HotelRateDetailID = HRD.HotelRateDetailID
						LEFT JOIN RateCards.HotelRateMaster HRM ON HRD.HotelRateID = HRM.HotelRateID
						WHERE HRD.HotelRateDetailID = @HotelRateDetailID
				
						INSERT INTO Booking.HotelRateMealPlanMasterBooking (
						QuotationHotelRateID
						,MealTypeID
						,GstPercentage
						,GstAmount
						,NetAmountIncludingTax
						,NetAmountExcludingTax
						,IsActive
						,CreatedBy
						,CreatedOn
						,MasterCommissionID
						,IsMealDetails
						,DefineAmount
						,HotelRateID
						,HotelRateDetailID
						,QuotationID
						,AddedFromBooking
						,BookingID
						)
					SELECT @QuotationHotelRateID as QuotationHotelRateID
						,MP.ID
						,HMM.GstPercentage
						,HMM.GstAmount
						,HMM.NetAmountIncludingTax
						,HMM.NetAmountExcludingTax
						,HMM.IsActive
						,@UserID
						,GETDATE()
						,HMM.MasterCommissionID
						,HMM.IsMealDetails
						,HMM.DefineAmount
						,HRD.HotelRateID
						,HRD.HotelRateDetailID
						,@QuotationID
						,1
						,@BookingID
					FROM RateCards.HotelMealOverviewMaster HMM
					LEFT OUTER JOIN RateCards.HotelRateDetails HRD ON HMM.HotelRateDetailID = HRD.HotelRateDetailID
					LEFT OUTER JOIN RateCards.HotelRateMaster HRM ON HRD.HotelRateID = HRM.HotelRateID
					LEFT JOIN MealPlan MP ON HRD.MealPlanID = MP.ID
						AND MP.IsActive = 1
					WHERE HRD.HotelRateDetailID = @HotelRateDetailID AND HMM.IsActive = 1;

						----------------------------------------------------DayWise Booking --------------------------------------------------


						--WITH DateRange
						--AS (
						--	SELECT @CheckIn AS [Date]
		
						--	UNION ALL
		
						--	SELECT DATEADD(DAY, 1, [Date])
						--	FROM DateRange
						--	WHERE [Date] < DATEADD(DAY, -1, @CheckOut)
						--	)
						declare @Code varchar(7)='1111111';
						set @Code=(select a.[Days] from RateCards.HotelRateDetails a where HotelRateDetailID =@HotelRateDetailID);
						WITH DateRange AS 
						(
						SELECT 
							@CheckIn AS [Date],
							dbo.fn_IsDayEnabled(@code, @CheckIn) AS IsEnabled
						UNION ALL
						SELECT 
							DATEADD(DAY, 1, [Date]),
							dbo.fn_IsDayEnabled(@code, DATEADD(DAY, 1, [Date]))
						FROM DateRange
						WHERE [Date] < DATEADD(DAY, -1, @CheckOut)
						)
							INSERT INTO Booking.DayWiseBooking (
								DayWiseDate
								,City
								,HotelName
								,RoomCategory
								,DBL
								,EBA
								,EBC
								,CNB
								,SGL
								,Twin
								,DBL_Rate
								,EBA_Rate
								,EBC_Rate
								,CNB_Rate
								,SGL_Rate
								,Twin_Rate
								,Adult_Rate
								,Child_Rate
								,MealPlan
								,Breakfast
								,Lunch
								,Dinner
								,RateTypeID
								,ServiceName
								,Isactive
								,CreatedBy
								,CreatedOn
								,RateID
								,RateDetailID
								,GrossRate
								,Currency
								,BookingID
								,BHRMID
								,Vendor
								)OUTPUT INSERTED.ID INTO @NewDayWiseIDs(ID)
							SELECT Distinct D.[Date]
								,HRM.CityID
								,H.HotelName
								,RoomCat.Name AS RoomCategory
								,@DBL
								,@EBA
								,@EBC
								,@CNB
								,@SGL
								,Isnull(@Twin,0)
								,(select (dbo.fn_GetNetAmountForSupplier(@SupplierTax_InCluding,@QuotationHotelRateID,2)))
								,(select (dbo.fn_GetNetAmountForSupplier(@SupplierTax_InCluding,@QuotationHotelRateID,3)))
								,(select (dbo.fn_GetNetAmountForSupplier(@SupplierTax_InCluding,@QuotationHotelRateID,23)))
								,(select (dbo.fn_GetNetAmountForSupplier(@SupplierTax_InCluding,@QuotationHotelRateID,24)))
								,(select (dbo.fn_GetNetAmountForSupplier(@SupplierTax_InCluding,@QuotationHotelRateID,1)))
								,(select (dbo.fn_GetNetAmountForSupplier(@SupplierTax_InCluding,@QuotationHotelRateID,25)))
								,(select (dbo.fn_GetNetAmountForSupplier(@SupplierTax_InCluding,@QuotationHotelRateID,7)))
								,(select (dbo.fn_GetNetAmountForSupplier(@SupplierTax_InCluding,@QuotationHotelRateID,8)))

								,mp.Code AS MealPlan
								,mp.Breakfast
								,mp.Lunch
								,mp.Dinner
								,5
								,'Hotel'
								,1
								,@userID
								,getdate()
								,RCD.HotelRateID
								,RCD.HotelRateDetailID
								,0
								,CurrencyID
								,@BookingID
								,@QuotationHotelRateID as BHRMID
								,hrm.vendorid
							FROM DateRange D
							JOIN RateCards.HotelRateMaster HRM ON 1 = 1
							INNER JOIN RateCards.HotelRateDetails RCD ON HRM.HotelRateID = RCD.HotelRateID
							INNER JOIN HotelMaster H ON HRM.HotelID = H.HotelID
							INNER JOIN HotelRating HR ON HR.ID = H.HotelRatingID
							INNER JOIN City city1 ON HRM.CityID = city1.IATACode
							LEFT JOIN HotelRoomCategory HRC ON HRM.HotelID = HRC.HotelID
								AND HRC.RoomCategoryID = RCD.RoomCategoryID
							LEFT JOIN RoomCategory RoomCat ON RCD.RoomCategoryID = RoomCat.ID
							LEFT JOIN MealPlan MP ON RCD.MealPlanID = MP.ID
								AND MP.IsActive = 1
							LEFT JOIN RateCards.RateCommisionDetails HRCD ON HRCD.HotelRateDetailID = rcd.HotelRateDetailID
							WHERE RCD.HotelRateDetailID = @HotelRateDetailID  and D.IsEnabled=1

						FETCH NEXT
						FROM HotelRateCardMasterBooking_Cursor
						INTO @HotelRateID,@HotelRateDetailID,@HotelID,@CardNumber,@ContractDate
						,@Days,@RoomCategoryID,@MealPlanID,@CurrencyID,@InfoForRemark
						,@StateID,@GstStatus,@CityID,@Heading,@InfoForAgent,@InfoForOperation
						,@PaymentTypeID,@RateCardModeTypeID,@RateTypeID,@ValueAddOn,@IsActive
						,@QuotationID,@Disclaimer,@CheckIn,@CheckOut,@BookingID,@AddedFromBooking
						,@IsCustom,@offerIncluded,@VendorID;
					END
					IF(@SGL > 0 OR @Twin > 0 OR @DBL > 0)
					BEGIN
						DECLARE cur CURSOR FOR SELECT ID FROM @NewDayWiseIDs;
						OPEN cur;
						FETCH NEXT FROM cur INTO @ID;
						WHILE @@FETCH_STATUS = 0
						BEGIN
							EXEC Booking.UpdateDayWiseBooking
								@Action = 'IXO',
								@ID = @ID,@SGL_Rate = NULL,@MealList = @EmptyMealList;
							FETCH NEXT FROM cur INTO @ID;
						END
						CLOSE cur;
						DEALLOCATE cur;
					END
					update book set book.currency=c.id, book.modifiedon=getdate() from Booking.tbl_Booking book
					inner join booking.daywisebooking dwb on dwb.bookingid=book.id 
					left join CurrencyMaster c on c.CurrencyCode=dwb.Currency
					where dwb.bookingid=@BookingID
		IF (isnull(@offerIncluded,0) = 1)
			BEGIN
				IF EXISTS (
					SELECT 1
					FROM RateCards.HotelRateDetails HRD
					WHERE 
						@IsCustom = 0 AND
						HRD.HotelRateDetailID = @HotelRateDetailID AND
						HRD.IsActive = 1 AND
						HRD.OfferTypeID IN (1, 2)
				)
				BEGIN
					-- Insert Offer Configuration if it exists
					IF EXISTS (
						SELECT 1
						FROM RateCards.HotelRateOfferConfiguration
						WHERE HotelRateDetailID = @HotelRateDetailID
					)
					BEGIN
						INSERT INTO [Booking].[HotelRateOfferConfigurationBooking]
						(
							HotelRateDetailID,
							Days,
							FromDate,
							ToDate,
							TotalNights,
							PaidNights,
							FreeNights,
							IsExtendible,
							IsActive,
							IsDeleted,
							BookingHotelRateID
						)
						SELECT
							HotelRateDetailID,
							Days,
							FromDate,
							ToDate,
							TotalNights,
							PaidNights,
							FreeNights,
							IsExtendible,
							IsActive,
							IsDeleted,
							@QuotationHotelRateID
						FROM RateCards.HotelRateOfferConfiguration
						WHERE HotelRateDetailID = @HotelRateDetailID
					END

					-- Insert Offer Configuration Commission if it exists
					IF EXISTS (
						SELECT 1
						FROM RateCards.HotelRateOfferConfigurationCommission
						WHERE OfferConfigurationID IN (
							SELECT OfferID
							FROM RateCards.HotelRateOfferConfiguration
							WHERE HotelRateDetailID = @HotelRateDetailID
						)
					)
					BEGIN
						INSERT INTO [Booking].[HotelRateOfferConfigurationCommissionBooking]
						(
							OfferConfigurationID,
							MasterCommissionID,
							Discount,
							DiscountAmount,
							Tax,
							TaxAmount,
							PaidNightAmountExcludingTax,
							PaidNightAmountIncludingTax,
							FreeNightAmountExcludingTax,
							FreeNightAmountIncludingTax,
							GrossAmountExcludingTax,
							GrossAmountIncludingTax,
							NetAmountExcludingTax,
							NetAmountIncludingTax,
							IsActive,
							IsDeleted,
							BookingHotelRateID
						)
						SELECT
							OfferConfigurationID,
							MasterCommissionID,
							Discount,
							DiscountAmount,
							Tax,
							TaxAmount,
							PaidNightAmountExcludingTax,
							PaidNightAmountIncludingTax,
							FreeNightAmountExcludingTax,
							FreeNightAmountIncludingTax,
							GrossAmountExcludingTax,
							GrossAmountIncludingTax,
							NetAmountExcludingTax,
							NetAmountIncludingTax,
							IsActive,
							IsDeleted,
							@QuotationHotelRateID
						FROM RateCards.HotelRateOfferConfigurationCommission
						WHERE OfferConfigurationID IN (
							SELECT OfferID
							FROM RateCards.HotelRateOfferConfiguration
							WHERE HotelRateDetailID = @HotelRateDetailID
						)
					END
				END
			END
			SELECT '200' AS returnCode
				,'The selected item has been added to the Daywise successfully.' AS returnMessage,
					getdate() as LastSavedOn;
					COMMIT TRANSACTION;

		CLOSE HotelRateCardMasterBooking_Cursor;
		DEALLOCATE HotelRateCardMasterBooking_Cursor;
	END TRY

	BEGIN CATCH
		-- Roll back the transaction if an error occurs
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		-- Releasing Cursor in case of error
		CLOSE HotelRateCardMasterBooking_Cursor;
		DEALLOCATE HotelRateCardMasterBooking_Cursor;

		-- Optionally re-throw or return the error
		DECLARE @ErrorMessage NVARCHAR(4000)
			,@ErrorSeverity INT
			,@ErrorState INT;

		SELECT @ErrorMessage = ERROR_MESSAGE()
			,@ErrorSeverity = ERROR_SEVERITY()
			,@ErrorState = ERROR_STATE();

		RAISERROR (
				@ErrorMessage
				,@ErrorSeverity
				,@ErrorState
				);
	END CATCH
	
	
END
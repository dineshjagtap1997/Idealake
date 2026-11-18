


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE  [Booking].[UpdateBookingCommissionDetails] 
(
  @BookingID BIGINT,	
  @Action CHAR(1),
  @HotelRateCardMasterJSON NVARCHAR(MAX), 
  @HotelRateCommissionDetailsJSON NVARCHAR(MAX),
  @HotelRateMealPlanMasterJSON NVARCHAR(MAX),
  @OthersRateCardMasterJSON NVARCHAR(MAX)
)
AS
BEGIN

	DECLARE @ID INT;
	DECLARE @CCOUNT INT;
	DECLARE @AdultCOUNT INT;
	DECLARE @ChildCOUNT INT;
	DECLARE @ConsolidateCOUNT INT;
	DECLARE @IsActive INT;
	DECLARE @ServiceType NVARCHAR(150);
	DECLARE @LogID INT;  
	DECLARE @MealType NVARCHAR(150);
	DECLARE @MealIsActive INT;
	DECLARE @Breakfast INT;
	DECLARE @Lunch INT;
	DECLARE @Dinner INT;
	DECLARE @IsSupplementary BIT;
SET NOCOUNT ON;

 BEGIN TRY
        BEGIN TRANSACTION;

		If Isnull(@HotelRateCardMasterJSON, '') <> '' 			
			BEGIN
			    If @Action = 'A' 
				 Begin
					Update [Booking].[HotelRateCardMasterBooking] set IsActive = 0 where BookingID = @BookingID;
				 End;
				DECLARE HotelRateCardMasterBooking_Cursor CURSOR FOR
					-- Parse each object from the array
					SELECT ID, IsActive
					FROM OPENJSON(@HotelRateCardMasterJSON)
					WITH (
					  ID INT,
					  IsActive INT
					);

					Print 'Json1';

					OPEN HotelRateCardMasterBooking_Cursor;
					FETCH NEXT FROM HotelRateCardMasterBooking_Cursor INTO 
					@ID,@IsActive;

					WHILE @@FETCH_STATUS = 0
					BEGIN

					  -- If @Action = 'A' 
							--Update [Booking].[HotelRateCardMasterBooking] set IsActive = @IsActive where ID = @ID;
					  -- Else If @Action = 'R'
							--Update [Booking].[HotelRateCardMasterBooking] set IsActive = @IsActive where ID = @ID;
       --                Else
							Update [Booking].[HotelRateCardMasterBooking] set IsActive = @IsActive where ID = @ID;

						FETCH NEXT FROM HotelRateCardMasterBooking_Cursor INTO 
						@ID,@IsActive;
					END

					CLOSE HotelRateCardMasterBooking_Cursor;
					DEALLOCATE HotelRateCardMasterBooking_Cursor;
			END;

		If Isnull(@HotelRateCommissionDetailsJSON, '') <> '' 			
			BEGIN
				If @Action = 'A' 
					Begin
						Update [Booking].[HotelRateCommissionDetailsBooking] set IsActive = 0 where BookingID = @BookingID;
					End;
					

				DECLARE HotelRateCommissionDetailsBooking_Cursor CURSOR FOR
					-- Parse each object from the array
					SELECT ID, CCount, IsActive,MealType,MealIsActive,Breakfast,Lunch,Dinner
					FROM OPENJSON(@HotelRateCommissionDetailsJSON)
					WITH (
					  ID INT,
					  CCount INT,
					  IsActive INT,
					  MealType NVARCHAR(150),
					  MealIsActive INT,Breakfast bit,Lunch bit,Dinner bit
					);

					Print 'Json2';

					OPEN HotelRateCommissionDetailsBooking_Cursor;
					FETCH NEXT FROM HotelRateCommissionDetailsBooking_Cursor INTO 
					@ID,@CCount,@IsActive,@MealType,@MealIsActive,@Breakfast,@Lunch,@Dinner;

					WHILE @@FETCH_STATUS = 0
					BEGIN

						If @Action = 'A' 
							IF LOWER(@MealType) = 'breakfast' 
								Update [Booking].[HotelRateCommissionDetailsBooking] set [Count] = @CCount, IsActive = @IsActive, Breakfast = @Breakfast where QuotationHotelRateCommissionId = @ID;
							Else If LOWER(@MealType) = 'lunch'
								Update [Booking].[HotelRateCommissionDetailsBooking] set [Count] = @CCount, IsActive = @IsActive, Lunch = @Lunch where QuotationHotelRateCommissionId = @ID;
							Else
								Update [Booking].[HotelRateCommissionDetailsBooking] set [Count] = @CCount, IsActive = @IsActive, Dinner = @Dinner where QuotationHotelRateCommissionId = @ID;
						Else If @Action = 'R'
							Update [Booking].[HotelRateCommissionDetailsBooking] set [Count] = 1, IsActive = 0 where QuotationHotelRateCommissionId = @ID;
						Else
							Update [Booking].[HotelRateCommissionDetailsBooking] set [Count] = @CCount, IsActive = 1 where QuotationHotelRateCommissionId = @ID;

						FETCH NEXT FROM HotelRateCommissionDetailsBooking_Cursor INTO 
						@ID,@CCount,@IsActive,@MealType,@MealIsActive,@Breakfast,@Lunch,@Dinner;
					END

					CLOSE HotelRateCommissionDetailsBooking_Cursor;
					DEALLOCATE HotelRateCommissionDetailsBooking_Cursor;
			END;
		
		If Isnull(@HotelRateMealPlanMasterJSON, '') <> '' 			
			BEGIN
				If @Action = 'A' 
					Begin
						Update [Booking].[HotelRateMealPlanMasterBooking] set IsActive = 0,IsSupplementary=0 where BookingID = @BookingID;
					End;

				DECLARE HotelRateMealPlanMasterBooking_Cursor CURSOR FOR
					-- Parse each object from the array
					SELECT ID, IsActive, IsSupplementary
					FROM OPENJSON(@HotelRateMealPlanMasterJSON)
					WITH (
					  ID INT,  
					  IsActive INT,
					  IsSupplementary bit
					);

					OPEN HotelRateMealPlanMasterBooking_Cursor;
					FETCH NEXT FROM HotelRateMealPlanMasterBooking_Cursor INTO 
					@ID,@IsActive,@IsSupplementary;

					WHILE @@FETCH_STATUS = 0
					BEGIN

						--If @Action = 'A' 
						--	Update [Booking].[HotelRateMealPlanMasterBooking] set IsActive = 1 where QuotationHotelRateMealId = @ID;
						--Else If @Action = 'R'
						--	Update [Booking].[HotelRateMealPlanMasterBooking] set IsActive = 0 where QuotationHotelRateMealId = @ID;
						--Else
							Update [Booking].[HotelRateMealPlanMasterBooking] set IsActive = @IsActive,IsSupplementary=@IsSupplementary where QuotationHotelRateMealId = @ID;

						FETCH NEXT FROM HotelRateMealPlanMasterBooking_Cursor INTO 
						@ID,@IsActive,@IsSupplementary;
					END

					CLOSE HotelRateMealPlanMasterBooking_Cursor;
					DEALLOCATE HotelRateMealPlanMasterBooking_Cursor;
			END;

		If Isnull(@OthersRateCardMasterJSON, '') <> '' 			
			BEGIN
				If @Action = 'A'
					Begin
						Update [Booking].[OthersRateCardMasterBooking] set IsActive = 0 where BookingID = @BookingID;
					End;

				DECLARE OthersRateCardMaster_Cursor CURSOR FOR
					-- Parse each object from the array
					SELECT ID, CCount, AdultCOUNT, ChildCOUNT, ConsolidateCOUNT, ServiceType, IsActive
					FROM OPENJSON(@OthersRateCardMasterJSON)
					WITH (
					  ID INT, 
					  CCount INT,
					  AdultCOUNT INT,
					  ChildCOUNT INT,
					  ConsolidateCOUNT INT,
					  ServiceType NVARCHAR(150),
					  IsActive INT
					);

					OPEN OthersRateCardMaster_Cursor;
					FETCH NEXT FROM OthersRateCardMaster_Cursor INTO 
					@ID,@CCount,@AdultCOUNT,@ChildCOUNT,@ConsolidateCOUNT,@ServiceType,@IsActive;

					WHILE @@FETCH_STATUS = 0
					BEGIN
						IF @Action = 'A'
							Begin
								IF @ServiceType = 'Transport'						
									Update [Booking].[OthersRateCardMasterBooking] set CountOfVehicles = @CCOUNT, IsActive = @IsActive where ID = @ID;
								ELSE IF @ServiceType = 'Guide'
									Update [Booking].[OthersRateCardMasterBooking] set CountOfGuide = @CCOUNT, IsActive = @IsActive where ID = @ID;
								ELSE IF @ServiceType = 'Monument'
									Update [Booking].[OthersRateCardMasterBooking] set CountOfAdult = @AdultCOUNT, CountOfChild = @ChildCOUNT, IsActive = @IsActive where ID = @ID;
								ELSE IF @ServiceType = 'Special Service'
									Update [Booking].[OthersRateCardMasterBooking] set Adult = @AdultCOUNT, PerPersonChild = @ChildCOUNT,consolidate = @ConsolidateCOUNT, IsActive = @IsActive where ID = @ID;
							End;
						If @Action = 'R'
							Begin
								IF @ServiceType = 'Transport'						
									Update [Booking].[OthersRateCardMasterBooking] set CountOfVehicles = 1, IsActive = @IsActive where ID = @ID;
								ELSE IF @ServiceType = 'Guide'
									Update [Booking].[OthersRateCardMasterBooking] set CountOfGuide = 1, IsActive = @IsActive where ID = @ID;
								ELSE IF @ServiceType = 'Monument'
									Update [Booking].[OthersRateCardMasterBooking] set CountOfAdult = 1, CountOfChild = 1, IsActive = @IsActive where ID = @ID;
								ELSE IF @ServiceType = 'Special Service'
									Update [Booking].[OthersRateCardMasterBooking] set Adult = 1, PerPersonChild = 1, consolidate = 1, IsActive = @IsActive where ID = @ID;
							End;
						FETCH NEXT FROM OthersRateCardMaster_Cursor INTO 
						@ID,@CCount,@AdultCOUNT,@ChildCOUNT,@ConsolidateCOUNT,@ServiceType,@IsActive;
					END

					CLOSE OthersRateCardMaster_Cursor;
					DEALLOCATE OthersRateCardMaster_Cursor;
			END;
        COMMIT TRANSACTION;

		SET @LogID = (SELECT ID FROM Booking.tbl_Booking WHERE ID = @BookingID);                                              
         SELECT '200' AS returnCode, 'Record updated successfully.' AS returnMessage, @LogID AS ID; 

    END TRY
    BEGIN CATCH
        -- Roll back the transaction if an error occurs
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

			--Release Cursor in case of Exeption
			CLOSE HotelRateCardMasterBooking_Cursor;
			DEALLOCATE HotelRateCardMasterBooking_Cursor;
			CLOSE HotelRateCommissionDetailsBooking_Cursor;
			DEALLOCATE HotelRateCommissionDetailsBooking_Cursor;
			CLOSE HotelRateMealPlanMasterBooking_Cursor;
			DEALLOCATE HotelRateMealPlanMasterBooking_Cursor;
			CLOSE OthersRateCardMaster_Cursor;
			DEALLOCATE OthersRateCardMaster_Cursor;

			SET @LogID = (SELECT ID FROM Booking.tbl_Booking WHERE ID = @BookingID);                                              
         SELECT '500' AS returnCode, 'Error While updating Record.' AS returnMessage, @LogID AS ID;

        -- Optionally re-throw or return the error
        DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH

END
	
CREATE PROCEDURE [RateCards].[CreateOrUpdate_HotelRateDetail] -- 672224
(
@Operation VARCHAR(10) = 'INSERT',
@ID BIGINT = 0,
@TaxID INT = NULL,
@RoomCategoryID INT = 0,
@Days VARCHAR(7),
@GIT BIT = NULL,
@FIT BIT = NULL,
@MealPlanID INT = 0,
@TransferID INT = 0,
@MinNights INT = 0,
@MaxNights INT = 0,
@RateTypeID INT = 0,
@OfferTypeID INT = 0,
@MISSequence VARCHAR(50)= NULL,
@IsActive BIT = 1,
@BusinessType int =0,
@CreatedBy UNIQUEIDENTIFIER = NULL,
@UpdatedBy UNIQUEIDENTIFIER = NULL,
@HotelRateID BIGINT,
@HotelRateDetailID BIGINT OUTPUT
)
AS
BEGIN
	IF @Operation = 'INSERT'
	BEGIN

		INSERT INTO RateCards.HotelRateDetails(HotelRateID,RoomCategoryID,[Days],FIT,GIT,TaxID,
		MealPlanID,TransferID,MinNights,MaxNights,RateTypeID,OfferTypeID,MISSequence,CreatedBy,CreatedOn,IsActive,BusinessType)
		VALUES (@HotelRateID,@RoomCategoryID,@Days,@FIT,@GIT,@TaxID,@MealPlanID,@TransferID,@MinNights,@MaxNights,
		@RateTypeID,@OfferTypeID,@MISSequence,@CreatedBy,GETDATE(),@IsActive,@BusinessType)

		SET @HotelRateDetailID = @@IDENTITY
		SELECT '200' AS returnCode, 'New record added successfully.' AS returnMessage, @HotelRateDetailID AS ID     
	END
	IF @Operation = 'UPDATE' AND @ID > 0
	BEGIN

		UPDATE RateCards.HotelRateDetails 
		SET RoomCategoryID = @RoomCategoryID ,[Days] = @Days,FIT = @FIT,GIT = @GIT, TaxID = @TaxID,
		MealPlanID = @MealPlanID,TransferID = @TransferID,MinNights = @MinNights,MaxNights = @MaxNights,RateTypeID = @RateTypeID,
		OfferTypeID = @OfferTypeID,MISSequence = @MISSequence,UpdatedBy = @UpdatedBy,UpdatedOn = GETDATE(),IsActive = @IsActive,BusinessType=@BusinessType
		WHERE HotelRateDetailID = @ID

		SET @HotelRateDetailID = @ID
	     SELECT '200' AS returnCode, 'New record added successfully.' AS returnMessage, @HotelRateDetailID AS ID 
	END
END
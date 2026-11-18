CREATE PROCEDURE [RateCards].[CreateOrUpdate_HotelRateOfferConfiguration]
(
@Operation VARCHAR(10) = 'INSERT',
@ID BIGINT NULL,
@HotelRateDetailID BIGINT NULL,
@Days INT NULL,
@FromDate DATETIME NULL,
@ToDate DATETIME NULL,
@TotalNights INT NULL,
@PaidNights INT NULL,
@FreeNights INT NULL,
@IsExtendible BIT NULL,
@IsActive BIT,
@IsDeleted BIT NULL=0,
@OfferID BIGINT OUTPUT
)
AS
BEGIN
	IF @Operation = 'INSERT'
	BEGIN
		INSERT INTO [RateCards].[HotelRateOfferConfiguration](HotelRateDetailID,[Days],FromDate,ToDate,TotalNights,PaidNights,FreeNights,IsExtendible,IsActive,IsDeleted)
		VALUES(@HotelRateDetailID,@Days,@FromDate,@ToDate,@TotalNights,@PaidNights,@FreeNights,@IsExtendible,@IsActive,0)

		SET @OfferID = @@IDENTITY;
		--Update [RateCards].[HotelRateDetails] set OfferTypeID=@OfferID where HotelRateDetailID=@HotelRateDetailID;

	END
	IF @Operation = 'UPDATE' AND @ID > 0
	BEGIN
		UPDATE [RateCards].[HotelRateOfferConfiguration] 
		SET [Days] = @Days, FromDate = @FromDate,ToDate = @ToDate,TotalNights = @TotalNights,PaidNights = @PaidNights,
		FreeNights = @FreeNights,IsExtendible = @IsExtendible,IsActive= @IsActive, IsDeleted=@IsDeleted
		WHERE OfferID = @ID;

		SET @OfferID = @ID
	END
END
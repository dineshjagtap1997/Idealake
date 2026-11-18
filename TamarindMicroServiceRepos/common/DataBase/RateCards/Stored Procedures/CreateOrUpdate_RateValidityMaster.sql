CREATE PROCEDURE [RateCards].[CreateOrUpdate_RateValidityMaster]
(
@Operation VARCHAR(10) = 'INSERT',
@ID BIGINT = 0,
@BookFrom DATETIME NULL,
@BookTo DATETIME NULL,
@RateValidFrom DATETIME NULL,
@RateValidTo DATETIME = NULL,
@CreatedBy UNIQUEIDENTIFIER = NULL,
@CreatedOn DATETIME = NULL,
@UpdatedBy UNIQUEIDENTIFIER = NULL,
@UpdatedOn DATETIME = NULL,
@HotelRateDetailID BIGINT = NULL,
@IsActive BIT = 1,
<<<<<<< HEAD
<<<<<<< HEAD
=======
@IsUpdated INT = 1,
>>>>>>> dev
=======
@IsUpdated INT = 1,
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
@RateValidityID BIGINT OUTPUT
)
AS
BEGIN
<<<<<<< HEAD
<<<<<<< HEAD
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
	IF(@IsUpdated = 0)
	BEGIN
		Update RateCards.RateValidityMaster set IsActive=0 where HotelRateDetailID=@HotelRateDetailID;
	END
	
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
	IF @Operation = 'INSERT'
	BEGIN
		INSERT INTO RateCards.RateValidityMaster(BookFrom,BookTo,RateValidFrom,RateValidTo,
		HotelRateDetailID,CreatedBy,CreatedOn,IsActive)
		VALUES (@BookFrom,@BookTo,@RateValidFrom,@RateValidTo,@HotelRateDetailID,@CreatedBy,
<<<<<<< HEAD
<<<<<<< HEAD
		GETDATE(),@IsActive)
=======
		GETDATE(),1)
>>>>>>> dev
=======
		GETDATE(),1)
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

		SET @RateValidityID = @@IDENTITY
	END
	IF @Operation = 'UPDATE' AND @ID > 0
	BEGIN
		UPDATE RateCards.RateValidityMaster
		SET BookFrom = @BookFrom,BookTo = @BookTo,RateValidFrom = @RateValidFrom,RateValidTo = @RateValidTo,
		UpdatedBy = @UpdatedBy,UpdatedOn = GETDATE(),IsActive = @IsActive
		WHERE RateValidityID = @ID
		SET @RateValidityID = @ID
	END
<<<<<<< HEAD
<<<<<<< HEAD
END
=======
END
>>>>>>> dev
=======
END
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

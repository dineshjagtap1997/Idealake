<<<<<<< HEAD
<<<<<<< HEAD
﻿CREATE PROCEDURE [RateCards].[CreateOrUpdate_TransportRateDetail]
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
﻿

--exec [RateCards].[CreateOrUpdate_TransportRateDetail] 'INSERT',0,0,181,0,'2025-07-14T18:30:00.000Z','2025-07-29T18:30:00.000Z',null,1,'00000000-0000-0000-0000-000000000000',null,19,0


CREATE PROCEDURE [RateCards].[CreateOrUpdate_TransportRateDetail]
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
(
@Operation VARCHAR(10) = 'INSERT',
@ID BIGINT = 0,
@TaxID INT = NULL,
@VehicleCategoryID INT = 0,
@VehicleBaseID INT = 0,
@ValidFrom DATETIME NULL,
@ValidTo DATETIME NULL,
@MISSequence VARCHAR(50)= NULL,
@IsActive BIT = 1,
@CreatedBy UNIQUEIDENTIFIER = NULL,
@UpdatedBy UNIQUEIDENTIFIER = NULL,
@TransportRateID BIGINT,
@TransportRateDetailID BIGINT OUTPUT
)
AS
BEGIN
	IF @Operation = 'INSERT'
	BEGIN
<<<<<<< HEAD
<<<<<<< HEAD
		IF NOT EXISTS (SELECT 1 FROM RateCards.TransportRateDetails WHERE 
		VehicleCategoryID = @VehicleCategoryID AND CAST(ValidFrom AS DATE) <= CAST(@ValidTo AS DATE)
      AND CAST(ValidTo AS DATE) >= CAST(@ValidFrom AS DATE))
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
		DECLARE @RateCardModeTypeID INT;
		DECLARE @IsValid BIT = 0;
		-- Step 1: Get RateCardModeTypeID from master
		SELECT @RateCardModeTypeID = RateCardModeTypeID FROM RateCards.TransportRateMaster WHERE TransportRateID = @TransportRateID;
		IF @RateCardModeTypeID = 3
		BEGIN
			-- Skip validation check, consider it valid
			SET @IsValid = 1;
		END
		ELSE
		BEGIN
			IF NOT EXISTS (SELECT 1 FROM RateCards.TransportRateDetails TRD 
			WHERE VehicleCategoryID = @VehicleCategoryID AND CAST(ValidFrom AS DATE) <= CAST(@ValidTo AS DATE)
			AND CAST(ValidTo AS DATE) >= CAST(@ValidFrom AS DATE) and TransportRateID=@TransportRateID)
			BEGIN
				SET @IsValid = 1;
			END
		END


		IF @IsValid = 1
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
		BEGIN
			INSERT INTO RateCards.TransportRateDetails(TransportRateID,TaxID,VehicleCategoryID,VehicleBaseID,MISSequence,
			ValidFrom,ValidTo,CreatedBy,CreatedOn,IsActive)
			VALUES (@TransportRateID,@TaxID,@VehicleCategoryID,@VehicleBaseID,@MISSequence,@ValidFrom,@ValidTo,@CreatedBy,GETDATE(),@IsActive)

			SET @TransportRateDetailID = @@IDENTITY
<<<<<<< HEAD
<<<<<<< HEAD
=======
			
>>>>>>> dev
=======
			
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
		END
		Else
		BEGIN
			SET @TransportRateDetailID = 0;
<<<<<<< HEAD
<<<<<<< HEAD
=======
			
>>>>>>> dev
=======
			
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
		END
	END
	IF @Operation = 'UPDATE' AND @ID > 0
	BEGIN

		UPDATE RateCards.TransportRateDetails
		SET VehicleCategoryID = @VehicleCategoryID ,TaxID = @TaxID,VehicleBaseID = @VehicleBaseID, ValidFrom = @ValidFrom,ValidTo = @ValidTo,
		MISSequence = @MISSequence,UpdatedBy = @UpdatedBy,UpdatedOn = GETDATE(),IsActive = @IsActive
		WHERE TransportRateDetailID = @ID

		SET @TransportRateDetailID = @ID
	END
END
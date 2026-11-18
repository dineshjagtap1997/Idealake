<<<<<<< HEAD
<<<<<<< HEAD
﻿CREATE PROCEDURE [RateCards].[CreateOrUpdate_MonumentRateDetail]
(
@Operation VARCHAR(10) = 'INSERT',
@ID BIGINT = 0,
@TaxID INT = NULL,
@ValidFrom DATETIME NULL,
@ValidTo DATETIME NULL,
@NationalityID INT = 0,
@MISSequence VARCHAR(100) NULL,
@IsActive BIT = 1,
@CreatedBy UNIQUEIDENTIFIER = NULL,
@UpdatedBy UNIQUEIDENTIFIER = NULL,
@MonumentRateID BIGINT = NULL,
@MonumentRateDetailID BIGINT OUTPUT
)
AS
BEGIN
	IF @Operation = 'INSERT'
	BEGIN
		IF NOT EXISTS (SELECT 1 FROM RateCards.MonumentRateDetails WHERE ValidFrom = @ValidFrom AND ValidTo = @ValidTo AND NationalityID = @NationalityID)
		BEGIN
			INSERT INTO RateCards.MonumentRateDetails(TaxID,ValidFrom,ValidTo,NationalityID,MISSequence,IsActive,CreatedBy,CreatedOn,MonumentRateID)
			VALUES (@TaxID,@ValidFrom,@ValidTo,@NationalityID,@MISSequence,@IsActive,@CreatedBy,GETDATE(),@MonumentRateID)

			SET @MonumentRateDetailID = @@IDENTITY
		END
		Else
		BEGIN
			SET @MonumentRateDetailID = 0;
		END

		
	END
	IF @Operation = 'UPDATE' AND @ID > 0
	BEGIN

		UPDATE RateCards.MonumentRateDetails
		SET TaxID = @TaxID ,ValidFrom = @ValidFrom,ValidTo = @ValidTo,
		NationalityID = @NationalityID,MISSequence = @MISSequence,IsActive = @IsActive,
		UpdatedBy = @UpdatedBy,UpdatedOn = GETDATE()
		WHERE MonumentDetailID = @ID

		SET @MonumentRateDetailID = @ID
	END
END
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
﻿
CREATE PROCEDURE [RateCards].[CreateOrUpdate_MonumentRateDetail]
(
    @Operation VARCHAR(10) = 'INSERT',
    @ID BIGINT = 0,
    @TaxID INT = NULL,
    @ValidFrom DATETIME NULL,
    @ValidTo DATETIME NULL,
    @NationalityID INT = 0,
    @MISSequence VARCHAR(100) NULL,
    @IsActive BIT = 1,
    @CreatedBy UNIQUEIDENTIFIER = NULL,
    @UpdatedBy UNIQUEIDENTIFIER = NULL,
    @MonumentRateID BIGINT = NULL,
    @MonumentRateDetailID BIGINT OUTPUT
)
AS
BEGIN
    DECLARE @IsValid BIT = 0;
    DECLARE @RateCardModeTypeID INT;

    IF @Operation = 'INSERT'
    BEGIN
        -- Step 1: Get RateCardModeTypeID from MonumentRateMaster
        SELECT @RateCardModeTypeID = RateCardModeTypeID 
        FROM RateCards.MonumentRateMaster 
        WHERE MonumentRateID = @MonumentRateID;

        -- Step 2: Apply validation rules
        IF @RateCardModeTypeID = 3
        BEGIN
            SET @IsValid = 1; -- Skip overlap validation
        END
        ELSE
        BEGIN
            -- Step 3: Validate no overlapping entries exist
            IF NOT EXISTS (
                SELECT 1 
                FROM RateCards.MonumentRateDetails 
                WHERE NationalityID = @NationalityID
                    AND CAST(ValidFrom AS DATE) <= CAST(@ValidTo AS DATE)
                    AND CAST(ValidTo AS DATE) >= CAST(@ValidFrom AS DATE)
            )
            BEGIN
                SET @IsValid = 1;
            END
        END

        -- Step 4: Insert or set output = 0
        IF @IsValid = 1
        BEGIN
            INSERT INTO RateCards.MonumentRateDetails(
                TaxID, ValidFrom, ValidTo, NationalityID, MISSequence, 
                IsActive, CreatedBy, CreatedOn, MonumentRateID
            )
            VALUES (
                @TaxID, @ValidFrom, @ValidTo, @NationalityID, @MISSequence, 
                @IsActive, @CreatedBy, GETDATE(), @MonumentRateID
            )

            SET @MonumentRateDetailID = @@IDENTITY
        END
        ELSE
        BEGIN
            SET @MonumentRateDetailID = 0;
        END
    END

    IF @Operation = 'UPDATE' AND @ID > 0
    BEGIN
        UPDATE RateCards.MonumentRateDetails
        SET 
            TaxID = @TaxID,
            ValidFrom = @ValidFrom,
            ValidTo = @ValidTo,
            NationalityID = @NationalityID,
            MISSequence = @MISSequence,
            IsActive = @IsActive,
            UpdatedBy = @UpdatedBy,
            UpdatedOn = GETDATE()
        WHERE MonumentDetailID = @ID

        SET @MonumentRateDetailID = @ID
    END
END
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

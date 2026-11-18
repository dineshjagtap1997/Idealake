CREATE PROCEDURE [RateCards].[CreateOrUpdate_SpecialServiceRateDetail]
(
@Operation VARCHAR(10) = 'INSERT',
@ID BIGINT = 0,
@TaxID BIT = 1,
@ValidFrom DATETIME NULL,
@ValidTo DATETIME NULL,
@NationalityID INT = 0,
@RatePreferenceID INT = 0,
@MISSequence VARCHAR(100) NULL,
@IsActive BIT = 1,
@CreatedBy UNIQUEIDENTIFIER = NULL,
@UpdatedBy UNIQUEIDENTIFIER = NULL,
@SpecialServiceRateID BIGINT,
@SpecialServiceRateDetailID BIGINT OUTPUT
)
AS
BEGIN
	IF @Operation = 'INSERT'
	BEGIN
		IF NOT EXISTS (SELECT 1 FROM RateCards.[SpecialServiceRateDeatils] WHERE ValidFrom = @ValidFrom AND ValidTo = @ValidTo AND NationalityID = @NationalityID)
		BEGIN
			INSERT INTO [RateCards].[SpecialServiceRateDeatils](ID,TaxID,ValidFrom,ValidTo,NationalityID,MISSequence,IsActive,CreatedBy,
			CreatedOn,RatePreferenceID,SpecialServiceRateID)
			VALUES (Newid(),@TaxID,@ValidFrom,@ValidTo,@NationalityID,@MISSequence,@IsActive,@CreatedBy,GETDATE(),@RatePreferenceID,@SpecialServiceRateID)

			SET @SpecialServiceRateDetailID = @@IDENTITY
		END
		Else
		BEGIN
			SET @SpecialServiceRateDetailID = 0;
		END
		
	END
	IF @Operation = 'UPDATE' AND @ID > 0
	BEGIN

		UPDATE [RateCards].[SpecialServiceRateDeatils]
		SET TaxID = @TaxID ,ValidFrom = @ValidFrom,ValidTo = @ValidTo,
		NationalityID = @NationalityID,MISSequence = @MISSequence,IsActive = @IsActive,
		UpdatedBy = @UpdatedBy,UpdatedOn = GETDATE(),RatePreferenceID = @RatePreferenceID
		WHERE SpecialServiceRateDetailID = @ID

		SET @SpecialServiceRateDetailID = @ID
	END
END
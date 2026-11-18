CREATE PROCEDURE [RateCards].[CreateOrUpdate_SpecialServiceRateCommissionDetail]
(
@Operation VARCHAR(10) = 'INSERT',
@ID BIGINT = 0,
@MinimumPax INT NULL,
@MaximumPax INT NULL,
@CommissionMasterID INT = NULL,
@TaxPercentage DECIMAL(18,2) = 0,
@TaxAmount DECIMAL(18,2) = 0,
@NetAmountIncludingTax DECIMAL(18,2) = 0,
@NetAmountExcludingTax DECIMAL(18,2) = 0,
@SpecialServiceRateDetailID BIGINT = 0,
@CreatedBy UNIQUEIDENTIFIER = NULL,
@UpdatedBy UNIQUEIDENTIFIER = NULL,
@IsActive BIT = 1, 
@SpecialServiceRateCommissionID BIGINT OUTPUT
)
AS
BEGIN
	IF @Operation = 'INSERT'
	BEGIN
		INSERT INTO RateCards.SpecialServiceRateCommissionDeatils(ID,MinimumPax,MaximumPax,TaxPercentage,TaxAmount,NetAmountIncludingTax,
		NetAmountExcludingTax,SpecialServiceRateDetailID,CreatedBy,CreatedOn,IsActive,CommissionMasterID)
		VALUES (NEWID(),@MinimumPax,@MaximumPax,@TaxPercentage,@TaxAmount,@NetAmountIncludingTax,@NetAmountExcludingTax,
		@SpecialServiceRateDetailID,@CreatedBy,GETDATE(),@IsActive,@CommissionMasterID)

		SET @SpecialServiceRateCommissionID = @@IDENTITY
	END
	IF @Operation = 'UPDATE' AND @ID > 0
	BEGIN
		UPDATE RateCards.SpecialServiceRateCommissionDeatils
		SET TaxPercentage = @TaxPercentage,TaxAmount = @TaxAmount,MinimumPax = @MinimumPax, MaximumPax = @MaximumPax,
		NetAmountIncludingTax = @NetAmountIncludingTax, NetAmountExcludingTax = @NetAmountExcludingTax, IsActive = @IsActive,
		UpdatedBy = @UpdatedBy, UpdatedOn = GETDATE()
		WHERE SpecialServiceRateCommissionID = @ID

		SET @SpecialServiceRateCommissionID = @ID
	END
END


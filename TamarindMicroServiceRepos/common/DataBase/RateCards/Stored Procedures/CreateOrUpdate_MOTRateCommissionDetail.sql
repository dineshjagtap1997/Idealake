
ALTER PROCEDURE [RateCards].[CreateOrUpdate_MOTRateCommissionDetail]
(
@Operation VARCHAR(20) = 'INSERT',
@ID BIGINT = 0,
@MOTRateDetailID BIGINT = 0,
@CategoryID INT = NULL,
@Tax DECIMAL(18,2) = NULL,
@TaxAmount DECIMAL(18,2) = NULL,
@NetAmountIncludingTax DECIMAL(18,2) = NULL,
@NetAmountExcludingTax DECIMAL(18,2) = NULL,
@IsActive BIT = 1,
@CreatedBy uniqueidentifier = '',
@UpdatedBy uniqueidentifier = '',
@CommissionMasterID int =7
)
AS
BEGIN
	IF @Operation = 'INSERT'
	BEGIN
		--SELECT * FROM [RateCards].MOTRateCommissionDetail
		INSERT INTO [RateCards].MOTRateCommissionDetail(MOTRateDetailID,CategoryID,Tax,TaxAmount,
		NetAmountIncludingTax,NetAmountExcludingTax,IsActive,CreatedBy,CreatedOn,CommissionMasterID)
		VALUES(@MOTRateDetailID,@CategoryID,@Tax,@TaxAmount,@NetAmountIncludingTax,@NetAmountExcludingTax,@IsActive,@CreatedBy,GETDATE(),@CommissionMasterID)

		--SET @MOTRateCommissionDetailID = @@IDENTITY
	END
	IF @Operation = 'UPDATE' AND @ID > 0
	BEGIN
		IF EXISTS (SELECT 1 FROM [RateCards].MOTRateCommissionDetail WHERE MotRateCommissionDetailID = @ID)
		BEGIN
			UPDATE [RateCards].MOTRateCommissionDetail
			SET CategoryID = @CategoryID, NetAmountExcludingTax = @NetAmountExcludingTax,
			Tax = @Tax, TaxAmount = @TaxAmount, NetAmountIncludingTax = @NetAmountIncludingTax,IsActive = @IsActive,
			UpdatedBy = @UpdatedBy, UpdatedOn = GETDATE()
			WHERE MotRateCommissionDetailID = @ID
		END
	END
END
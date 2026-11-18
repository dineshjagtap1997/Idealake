CREATE PROCEDURE [RateCards].[CreateOrUpdate_MonumentRateCommissionDetails]
(
@Operation VARCHAR(10) = 'INSERT',
@ID BIGINT = 0,
@MasterCommissionID INT = 0,
@TaxPercentage DECIMAL(18,2) = 0,
@TaxAmount DECIMAL(18,2) = 0,
@NetAmountIncludingTax DECIMAL(18,2) = 0,
@NetAmountExcludingTax DECIMAL(18,2) = 0,
@MonumentDetailID BIGINT = 0,
@CreatedBy UNIQUEIDENTIFIER = NULL,
@UpdatedBy UNIQUEIDENTIFIER = NULL,
@IsActive BIT = 1, 
@MonumentRateCommissionID BIGINT OUTPUT
)
AS
BEGIN
	IF @Operation = 'INSERT'
	BEGIN
		INSERT INTO RateCards.MonumentRateCommissionDetails(CommissionMasterID,TaxPercentage,TaxAmount,NetAmountIncludingTax,
		NetAmountExcludingTax,MonumentDetailID,CreatedBy,CreatedOn,IsActive)
		VALUES (@MasterCommissionID,@TaxPercentage,@TaxAmount,@NetAmountIncludingTax,@NetAmountExcludingTax,
		@MonumentDetailID,@CreatedBy,GETDATE(),@IsActive)

		SET @MonumentRateCommissionID = @@IDENTITY
	END
	IF @Operation = 'UPDATE' AND @ID > 0
	BEGIN
		UPDATE RateCards.MonumentRateCommissionDetails
		SET TaxPercentage = @TaxPercentage,TaxAmount = @TaxAmount,
		NetAmountIncludingTax = @NetAmountIncludingTax, NetAmountExcludingTax = @NetAmountExcludingTax, IsActive = @IsActive,
		UpdatedBy = @UpdatedBy, UpdatedOn = GETDATE()
		WHERE MonumentCommissionDetailID = @ID

		SET @MonumentRateCommissionID = @ID
	END
END
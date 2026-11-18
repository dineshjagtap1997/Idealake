CREATE PROCEDURE [RateCards].CreateOrUpdate_GuideRateCommissionDetail
(
@Operation VARCHAR(10) = 'INSERT',
@ID BIGINT = 0,
@TaxPercentage DECIMAL(18,2) = NULL,
@TaxAmount DECIMAL(18,2) = NULL,
@NetAmountIncludingTax DECIMAL(18,2) = NULL,
@NetAmountExcludingTax DECIMAL(18,2) = NULL,
@PaxMinimum INT = NULL,
@PaxMaximum INT = NULL,
@GuideRateDetailID BIGINT,
@IsActive BIT = 1,
@CreatedBy UNIQUEIDENTIFIER = NULL,
@UpdatedBy UNIQUEIDENTIFIER = NULL,
@GuideRateCommissionID BIGINT OUTPUT
)
AS
BEGIN
	IF @Operation = 'INSERT'
	BEGIN
		
		INSERT INTO [RateCards].[GuideRateCommissionDetails](TaxPercentage,TaxAmount,NetAmountIncludingTax,NetAmountExcludingTax,
		PaxMinimum,PaxMaximum,IsActive,CreatedBy,CreatedOn,GuideRateDetailID)
		VALUES(@TaxPercentage,@TaxAmount,@NetAmountIncludingTax,@NetAmountExcludingTax,@PaxMinimum,@PaxMaximum,@IsActive,
		@CreatedBy,GETDATE(),@GuideRateDetailID)

		SET @GuideRateCommissionID = @@IDENTITY
	END
	IF @Operation = 'UPDATE' AND @ID > 0
	BEGIN
		
		UPDATE [RateCards].[GuideRateCommissionDetails]
		SET TaxPercentage = @TaxPercentage,TaxAmount = @TaxAmount,NetAmountIncludingTax =@NetAmountIncludingTax,
		NetAmountExcludingTax = @NetAmountExcludingTax,PaxMinimum = @PaxMinimum,PaxMaximum = @PaxMaximum,IsActive = @IsActive,
		UpdatedBy = NEWID(),UpdatedOn = GETDATE()
		WHERE GuideRateCommissionID = @ID

		SET @GuideRateCommissionID = @ID
	END
END
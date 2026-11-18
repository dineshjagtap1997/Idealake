CREATE PROCEDURE [RateCards].[CreateOrUpdate_RateCommissionDetail]
(
@Operation VARCHAR(10) = 'INSERT',
@ID BIGINT = 0,
@MasterCommissionID INT = 0,
@TaxPercentage DECIMAL(18,2) = 0,
@TaxAmount DECIMAL(18,2) = 0,
@GrossAmountIncludingTax DECIMAL(18,2) = 0,
@GrossAmountExcludingTax DECIMAL(18,2) = 0,
@NetAmountIncludingTax DECIMAL(18,2) = 0,
@NetAmountExcludingTax DECIMAL(18,2) = 0,
@CommissionPercentage DECIMAL(18,2) = 0,
@CommissionAmount DECIMAL(18,2) = 0,
@HotelRateDetailID BIGINT = 0,
@IsTax BIT = 1,
@CreatedBy UNIQUEIDENTIFIER = NULL,
@UpdatedBy UNIQUEIDENTIFIER = NULL,
@IsActive BIT = 1, 
@RateCommissionID BIGINT OUTPUT
)
AS
BEGIN
	IF @Operation = 'INSERT'
	BEGIN
		INSERT INTO [RateCards].RateCommisionDetails(CommissionMasterID,TaxPercentage,TaxAmount,GrossAmountIncludingTax,
		GrossAmountExcludingTax,CommisionPercentage,CommissionAmount,NetAmountIncludingTax,
		NetAmountExcludingTax,HotelRateDetailID,IsTax,CreatedBy,CreatedOn,IsActive)
		VALUES (@MasterCommissionID,@TaxPercentage,@TaxAmount,@GrossAmountIncludingTax,@GrossAmountExcludingTax,@CommissionPercentage,
		@CommissionAmount,@NetAmountIncludingTax,@NetAmountExcludingTax,
		@HotelRateDetailID,@IsTax,@CreatedBy,GETDATE(),@IsActive)

		SET @RateCommissionID = @@IDENTITY
	END
	IF @Operation = 'UPDATE' AND @ID > 0
	BEGIN
		UPDATE [RateCards].RateCommisionDetails 
		SET TaxPercentage = @TaxPercentage,TaxAmount = @TaxAmount,GrossAmountExcludingTax = @GrossAmountExcludingTax,
		GrossAmountIncludingTax = @GrossAmountIncludingTax,CommissionAmount = @CommissionAmount,CommisionPercentage = @CommissionPercentage,
		NetAmountIncludingTax=@NetAmountIncludingTax, NetAmountExcludingTax = @NetAmountExcludingTax, IsTax = @IsTax, IsActive = @IsActive,
		UpdatedBy = @UpdatedBy, UpdatedOn = GETDATE()
		,CommissionMasterID=@MasterCommissionID
		WHERE RateCommisionID = @ID

		SET @RateCommissionID = @ID
	END
END
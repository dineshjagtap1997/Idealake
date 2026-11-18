CREATE PROCEDURE [RateCards].[CreateOrUpdate_TransportRateCommissionDetail]
(
@Operation VARCHAR(10) = 'INSERT',
@ID BIGINT = 0,
@MasterCommissionID INT = 0,
@TaxPercentage DECIMAL(18,2) = 0,
@TaxAmount DECIMAL(18,2) = 0,
@NetAmountIncludingTax DECIMAL(18,2) = 0,
@NetAmountExcludingTax DECIMAL(18,2) = 0,
@TransportRateDetailID BIGINT = 0,
@IsAmtIncludedInTax BIT = 1,
@CreatedBy UNIQUEIDENTIFIER = NULL,
@UpdatedBy UNIQUEIDENTIFIER = NULL,
@IsActive BIT = 1, 
@TransportRateCommissionID BIGINT OUTPUT
)
AS
BEGIN
	IF @Operation = 'INSERT'
	BEGIN
		INSERT INTO RateCards.TransportRateCommissionDetails(CommissionMasterID,TaxPercentage,TaxAmount,NetAmountExcludingTax,
		NetAmountIncludingTax,TransportRateDetailID,IsAmtIncludedInBasic,CreatedBy,CreatedOn,IsActive)
		VALUES (@MasterCommissionID,@TaxPercentage,@TaxAmount,@NetAmountExcludingTax,@NetAmountIncludingTax,@TransportRateDetailID 
		,@IsAmtIncludedInTax,@CreatedBy,GETDATE(),@IsActive)

		SET @TransportRateCommissionID = @@IDENTITY
	END
	IF @Operation = 'UPDATE' AND @ID > 0
	BEGIN
		UPDATE RateCards.TransportRateCommissionDetails
		SET TaxPercentage = @TaxPercentage,TaxAmount = @TaxAmount,
		NetAmountIncludingTax= @NetAmountIncludingTax, NetAmountExcludingTax = @NetAmountExcludingTax, IsAmtIncludedInBasic = @IsAmtIncludedInTax, IsActive = @IsActive,
		UpdatedBy = @UpdatedBy, UpdatedOn = GETDATE()
		WHERE TransportCommissionDetailID = @ID

		SET @TransportRateCommissionID = @ID
	END
END
CREATE PROCEDURE [RateCards].[CreateOrUpdate_HotelRateOfferConfigurationCommission]
(
@Operation VARCHAR(10) = 'INSERT',
@OfferID BIGINT NULL,
@MasterCommissionID INT NULL,
@Discount DECIMAL(18,2) NULL,
@DiscountAmount DECIMAL(18,2) NULL,
@Tax DECIMAL(18,2) NULL,
@TaxAmount DECIMAL(18,2) NULL,
@PaidNightAmountExcludingTax DECIMAL(18,2) NULL,
@PaidNightAmountIncludingTax DECIMAL(18,2) NULL,
@FreeNightAmountExcludingTax DECIMAL(18,2) NULL,
@FreeNightAmountIncludingTax DECIMAL(18,2) NULL,
@GrossAmountExcludingTax DECIMAL(18,2) NULL,
@GrossAmountIncludingTax DECIMAL(18,2) NULL,
@NetAmountExcludingTax DECIMAL(18,2) NULL,
@NetAmountIncludingTax DECIMAL(18,2) NULL,
@OfferCommissionID BIGINT NULL=0
)
AS
BEGIN
	IF @Operation = 'INSERT'
	BEGIN
		INSERT INTO [RateCards].[HotelRateOfferConfigurationCommission](OfferConfigurationID,MasterCommissionID,Discount,DiscountAmount,Tax,TaxAmount,
		PaidNightAmountExcludingTax,PaidNightAmountIncludingTax,FreeNightAmountExcludingTax,FreeNightAmountIncludingTax,GrossAmountExcludingTax,
		GrossAmountIncludingTax,NetAmountExcludingTax,NetAmountIncludingTax)
		VALUES(@OfferID,@MasterCommissionID,@Discount,@DiscountAmount,@Tax,@TaxAmount,
		@PaidNightAmountExcludingTax,@PaidNightAmountIncludingTax,@FreeNightAmountExcludingTax,@FreeNightAmountIncludingTax,@GrossAmountExcludingTax,
		@GrossAmountIncludingTax,@NetAmountExcludingTax,@NetAmountIncludingTax)
	END
	IF @Operation = 'UPDATE' AND @OfferCommissionID > 0
	BEGIN
		UPDATE [RateCards].[HotelRateOfferConfigurationCommission] 
		SET MasterCommissionID=@MasterCommissionID,DiscountAmount=@DiscountAmount,Discount=@Discount,Tax=@Tax,TaxAmount=@TaxAmount,
		PaidNightAmountExcludingTax=@PaidNightAmountExcludingTax,PaidNightAmountIncludingTax=@PaidNightAmountIncludingTax,FreeNightAmountExcludingTax=@FreeNightAmountExcludingTax,
		FreeNightAmountIncludingTax=@FreeNightAmountIncludingTax,GrossAmountExcludingTax=@GrossAmountExcludingTax,GrossAmountIncludingTax=@GrossAmountIncludingTax,
		NetAmountExcludingTax=@NetAmountExcludingTax,NetAmountIncludingTax=@NetAmountIncludingTax, OfferConfigurationID=@OfferID where OfferCommissionID = @OfferCommissionID
	END
END
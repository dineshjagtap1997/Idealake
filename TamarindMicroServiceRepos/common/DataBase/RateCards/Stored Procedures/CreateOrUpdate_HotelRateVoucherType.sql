CREATE PROCEDURE [RateCards].[CreateOrUpdate_HotelRateVoucherType]
(
@Operation VARCHAR(10) NULL,
@HotelRateID BIGINT NULL,
@VoucherTypeID INT = 0
)
AS
BEGIN
	IF @Operation = 'DELETE'
		BEGIN

			UPDATE RateCards.HotelRateVoucherTypeLookup
			SET IsActive = 0
			WHERE HotelRateID = @HotelRateID
		END
	IF @Operation = 'ADD'
		BEGIN
			INSERT INTO RateCards.HotelRateVoucherTypeLookup(VoucherTypeID,HotelRateID,IsActive)
			VALUES (@VoucherTypeID,@HotelRateID,1)
		END
END
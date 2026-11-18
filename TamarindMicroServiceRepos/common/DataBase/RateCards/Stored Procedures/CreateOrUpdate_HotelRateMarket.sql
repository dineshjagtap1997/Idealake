CREATE PROCEDURE [RateCards].[CreateOrUpdate_HotelRateMarket]
(
@Operation VARCHAR(10) NULL,
@HotelRateID BIGINT NULL,
@RateSheetID INT = 0 
)


AS
BEGIN
	IF @Operation = 'DELETE'
		BEGIN

			UPDATE RateCards.HotelRateMarketMasterLookup 
			SET IsActive = 0
			WHERE HotelRateID = @HotelRateID
		END
	IF @Operation = 'ADD'
		BEGIN
			INSERT INTO RateCards.HotelRateMarketMasterLookup(MarketRateID,HotelRateID,IsActive)
			VALUES (@RateSheetID,@HotelRateID,1)
		END
END
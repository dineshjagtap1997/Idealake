CREATE PROCEDURE [RateCards].[CreateOrUpdate_HotelOfferMarket]
(
@Operation VARCHAR(10) NULL,
@HotelOfferID BIGINT NULL,
@MarketRateID INT = 0 
)


AS
BEGIN
	IF @Operation = 'DELETE'
		BEGIN
			UPDATE RateCards.HotelOfferMarketMasterLookup
			SET IsActive = 0
			WHERE HotelOfferID = @HotelOfferID
		END
	IF @Operation = 'ADD'
		BEGIN
			INSERT INTO RateCards.HotelOfferMarketMasterLookup(MarketRateID,HotelOfferID)
			VALUES (@MarketRateID,@HotelOfferID)
		END
END
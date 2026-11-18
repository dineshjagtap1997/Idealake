CREATE PROCEDURE [RateCards].[CreateOrUpdate_HotelOfferMapping]
(
@Operation VARCHAR(10) NULL,
@HotelOfferID BIGINT NULL,
@HotelID INT = 0 
)


AS
BEGIN
	IF @Operation = 'DELETE'
		BEGIN
			UPDATE RateCards.HotelOfferMapping
			SET IsActive = 0
			WHERE HotelOfferID = @HotelOfferID
		END
	IF @Operation = 'ADD'
		BEGIN
			INSERT INTO RateCards.HotelOfferMapping(HotelID,HotelOfferID)
			VALUES (@HotelID,@HotelOfferID)
		END
END
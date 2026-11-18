CREATE PROCEDURE [RateCards].[CreateOrUpdate_HotelOfferMarketSheet]
(
@Operation VARCHAR(10) NULL,
@HotelOfferID BIGINT NULL,
@RateSheetID INT = 0
)
AS
BEGIN
	IF @Operation = 'DELETE'
		BEGIN
			UPDATE RateCards.HotelOfferRateSheetMasterLookup
			SET IsActive = 0
			WHERE HotelOfferID = @HotelOfferID
		END
	IF @Operation = 'ADD'
		BEGIN
			INSERT INTO RateCards.HotelOfferRateSheetMasterLookup(RateSheetID,HotelOfferID)
			VALUES (@RateSheetID,@HotelOfferID)
		END
END
CREATE PROCEDURE [RateCards].[CreateOrUpdate_HotelRateMarketSheet]
(
@Operation VARCHAR(10) NULL,
@HotelRateID BIGINT NULL,
@RateSheetID INT = 0
)
AS
BEGIN
	IF @Operation = 'DELETE'
		BEGIN
			UPDATE RateCards.HotelRatesheetMasterLookup
			SET IsActive = 0
			WHERE HotelRateID = @HotelRateID
		END
	IF @Operation = 'ADD'
		BEGIN
			INSERT INTO RateCards.HotelRatesheetMasterLookup(RateSheetID,HotelRateID,IsActive)
			VALUES (@RateSheetID,@HotelRateID,1)
		END
END
CREATE PROCEDURE RateCards.Get_HotelRateOfferConfigurations
(
@HotelDetailID BIGINT NULL
)
AS
BEGIN	
		DECLARE @OfferID BIGINT;
		SELECT @OfferID = OfferID FROM [RateCards].[HotelRateOfferConfiguration] WHERE HotelRateDetailID = @HotelDetailID

		SELECT OfferID,HotelRateDetailID,[Days],FromDate,ToDate,TotalNights,PaidNights,FreeNights,IsExtendible,IsActive
		FROM [RateCards].[HotelRateOfferConfiguration] WHERE HotelRateDetailID = @HotelDetailID

		SELECT * FROM [RateCards].[HotelRateOfferConfigurationCommission] WHERE OfferConfigurationID = @OfferID
END
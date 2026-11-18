CREATE PROCEDURE [RateCards].[Delete_HotelRateOfferConfigurationCommission]
(
@Operation VARCHAR(10) = 'DELETE',
@OfferID BIGINT NULL,
@HotelRateDetailID BIGINT NULL
)
AS
BEGIN
	IF @Operation = 'DELETE' AND @OfferID > 0
	BEGIN
		DELETE FROM [RateCards].[HotelRateOfferConfigurationCommission] WHERE OfferConfigurationID = @OfferID
	END
	IF @Operation =  'DELETEALL' AND @HotelRateDetailID > 0
		BEGIN

			--First deletes all commissions 
			UPDATE [RateCards].[HotelRateOfferConfigurationCommission]
			SET IsDeleted = 1
			WHERE OfferConfigurationID IN 
			(SELECT OfferID FROM [RateCards].[HotelRateOfferConfiguration] WHERe HotelRateDetailID = @HotelRateDetailID)

			--then delete offer config record
			UPDATE [RateCards].[HotelRateOfferConfiguration]
			SET IsDeleted = 1
			WHERe HotelRateDetailID = @HotelRateDetailID
		END
END




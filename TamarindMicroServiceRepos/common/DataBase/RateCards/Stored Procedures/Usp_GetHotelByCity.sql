CREATE PROCEDURE [RateCards].[Usp_GetHotelByCity]
@CityCode VARCHAR(10)= NULL
AS
--EXEC [RateCards].[Usp_GetHotelByCity] @CityCode = AJM
BEGIN
	SET NOCOUNT ON;
	SELECT HotelID,HotelCode,HotelName FROM [dbo].[HotelMaster]
	WHERE IsActive = 1 AND CityIATACode = @CityCode ORDER BY HotelName DESC
END
create Procedure [dbo].[USP_GetAllItineraryInclusionsExclusionsDetails]
AS
BEGIN

	SELECT IIE.ID, CR.Name AS 'CountryName', 
	CASE WHEN IIE.City_IATACODE = '1' THEN 'AllCities' ELSE C.Name END AS 'CityName', 
	IIE.Type, IIE.Header, IIE.Description, IIE.IsActive, IIE.Country_IATACode, IIE.City_IATACode, IIE.IsDefault,
	IIE.SeqNo
	FROM ItineraryInclusionsExclusions IIE
	LEFT JOIN Country CR ON IIE.Country_IATACode = CR.IATACode
	LEFT JOIN City C ON IIE.City_IATACode = C.IATACode
	ORDER BY IIE.OperationOn DESC

END
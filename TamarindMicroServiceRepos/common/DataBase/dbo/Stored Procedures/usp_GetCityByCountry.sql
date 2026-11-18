         
CREATE PROCEDURE [dbo].[usp_GetCityByCountry]          
(          
@CountryIATACode char(4)          
)          
AS          
BEGIN          
Select C.IATACode AS CityIATACode ,C.Name AS CityName,C.STDCode,          
  State_IATACode,S.Name AS StateName,          
  CTY.IATACode AS CountryIATACode,CTY.Name AS CountryName,        
  CTY.ISDCode          
FROM City C          
INNER JOIN [State] S ON S.State_ID = C.State_IATACode          
INNER JOIN Country CTY ON CTY.IATACode = S.Country_IATACode          
WHERE CTY.IATACode=@CountryIATACode AND C.IsActive=1     
Order by  C.Name        
END   
  
CREATE PROCEDURE [dbo].[usp_GetItineraryExclusions]              
@City_IATACode1 CHAR(3),      
@City_IATACode2 CHAR(3),
@Action CHAR(2),
@Active bit              
AS              
BEGIN 
if(@Action='EX')
BEGIN
if(@Active=1)              
 BEGIN              
  SELECT Country_IATACode, City_IATACode, Type,Header, Description, CASE WHEN IsDefault='1' THEN 'Yes' WHEN IsDefault='0' THEN 'No' END AS IsDefault, SeqNo,CASE WHEN  IsActive='1' THEN 'True' WHEN IsActive='0' THEN 'False' END AS IsActive     
  FROM ItineraryInclusionsExclusions       
  WHERE Type = 'Exclusion' AND (City_IATACode = @City_IATACode1 or @City_IATACode1 is null or @City_IATACode1 = '') AND IsActive = 1       
  OR Type = 'Exclusion' AND (City_IATACode = @City_IATACode2 or @City_IATACode2 = '' or @City_IATACode2 is null)  AND IsActive = 1       
  --WHERE Type = 'Exclusions' AND City_IATACode = @City_IATACode1 OR City_IATACode = @City_IATACode2 AND IsActive = 1       
  ORDER BY Description ASC      
  --SELECT ID, Country_IATACode, City_IATACode, Type,Header, Description, IsDefault, SeqNo, IsActive      
  --FROM ItineraryInclusionsExclusions       
  --WHERE Type = 'Exclusions' AND IsActive = 1 ORDER BY Description ASC      
 END              
 ELSE              
 BEGIN              
  SELECT Country_IATACode, City_IATACode, Type,Header, Description,  CASE WHEN IsDefault='1' THEN 'Yes' WHEN IsDefault='0' THEN 'No' END AS IsDefault, SeqNo, CASE WHEN  IsActive='1' THEN 'True' WHEN IsActive='0' THEN 'False' END AS IsActive           
  FROM ItineraryInclusionsExclusions       
  WHERE Type = 'Exclusion' AND (City_IATACode = @City_IATACode1 or @City_IATACode1 is null or @City_IATACode1 = '')  
  OR Type = 'Exclusion' AND (City_IATACode = @City_IATACode2 or @City_IATACode2 is null or @City_IATACode2 = '')  
  --WHERE Type = 'Exclusions' AND City_IATACode = @City_IATACode1 OR City_IATACode = @City_IATACode2      
  ORDER BY Description ASC      
  --SELECT ID, Country_IATACode, City_IATACode, Type,Header, Description, IsDefault, SeqNo, IsActive      
  --FROM ItineraryInclusionsExclusions       
  --WHERE Type = 'Exclusions' ORDER BY Description ASC      
 END        
END
ELSE
BEGIN
 if(@Active=1)              
 BEGIN              
  SELECT ID, Country_IATACode, City_IATACode, Type,Header, Description, IsDefault, SeqNo, IsActive      
  FROM ItineraryInclusionsExclusions       
  WHERE Type = 'Exclusion' AND (City_IATACode = @City_IATACode1 or @City_IATACode1 is null or @City_IATACode1 = '') AND IsActive = 1       
  OR Type = 'Exclusion' AND (City_IATACode = @City_IATACode2 or @City_IATACode2 = '' or @City_IATACode2 is null)  AND IsActive = 1       
  --WHERE Type = 'Exclusions' AND City_IATACode = @City_IATACode1 OR City_IATACode = @City_IATACode2 AND IsActive = 1       
  ORDER BY Description ASC      
  --SELECT ID, Country_IATACode, City_IATACode, Type,Header, Description, IsDefault, SeqNo, IsActive      
  --FROM ItineraryInclusionsExclusions       
  --WHERE Type = 'Exclusions' AND IsActive = 1 ORDER BY Description ASC      
 END              
 ELSE              
 BEGIN              
  SELECT ID, Country_IATACode, City_IATACode, Type,Header, Description, IsDefault, SeqNo, IsActive      
  FROM ItineraryInclusionsExclusions       
  WHERE Type = 'Exclusion' AND (City_IATACode = @City_IATACode1 or @City_IATACode1 is null or @City_IATACode1 = '')  
  OR Type = 'Exclusion' AND (City_IATACode = @City_IATACode2 or @City_IATACode2 is null or @City_IATACode2 = '')  
  --WHERE Type = 'Exclusions' AND City_IATACode = @City_IATACode1 OR City_IATACode = @City_IATACode2      
  ORDER BY Description ASC      
  --SELECT ID, Country_IATACode, City_IATACode, Type,Header, Description, IsDefault, SeqNo, IsActive      
  --FROM ItineraryInclusionsExclusions       
  --WHERE Type = 'Exclusions' ORDER BY Description ASC      
 END     
 END
END 
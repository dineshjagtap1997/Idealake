      
CREATE PROCEDURE [dbo].[usp_GetCity_ByNameNID]          
(          
 @Active bit,  
 @Name  varchar(50),        
 @IATACode char(3)           
)          
AS            
BEGIN            
IF(@Active=0)          
 BEGIN          
   SELECT C.IATACode,CR.IATACode as Country_IATACode,CR.Name as CountryName,State_IATACode, C.Name, STDCode, C.IsActive ,S.Name AS StateName          
   FROM City C          
   INNER JOIN [State] S WITH (NOLOCK) ON C.State_IATACode=S.State_ID           
   INNER JOIN [Country] CR  WITH (NOLOCK) ON S.Country_IATACode=CR.IATACode   
   WHERE  
   C.Name like CASE WHEN  ISNULL(@Name,'')<>'' THEN  '%' + @Name + '%'   ELSE   C.Name END        
  AND C.IATACode= CASE WHEN ISNULL(@IATACode,'')<>'' THEN @IATACode ELSE  C.IATACode END     
         
   ORDER BY c.Name        
  END          
ELSE          
 BEGIN          
  SELECT C.IATACode, State_IATACode, C.Name, STDCode, C.IsActive ,S.Name AS StateName           
  FROM City C          
  INNER JOIN [State] S  WITH (NOLOCK)ON C.State_IATACode=S.State_ID          
  INNER JOIN [Country] CR  WITH (NOLOCK) ON S.Country_IATACode=CR.IATACode             
  WHERE C.IsActive=1          
  AND C.Name like CASE WHEN  ISNULL(@Name,'')<>'' THEN  '%' + @Name + '%'   ELSE   C.Name END        
  AND C.IATACode= CASE WHEN ISNULL(@IATACode,'')<>'' THEN @IATACode ELSE  C.IATACode END    
  ORDER BY c.Name        
 END           
END     
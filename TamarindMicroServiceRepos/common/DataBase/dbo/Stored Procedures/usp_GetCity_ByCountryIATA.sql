
-- =============================================        
-- Author:  Albert        
-- Description: Retrieves Cities from City table with respect to its country        
-- Create date: 26 April 2024    
-- Description: 
-- =============================================        
CREATE PROCEDURE [dbo].[usp_GetCity_ByCountryIATA]        
(        
 @Active bit,
 @Name  varchar(50),      
 @IATACode char(3)         
)        
AS          
BEGIN          
IF(@Active=0)        
 BEGIN        
  SELECT C.IATACode, State_IATACode, C.Name, STDCode, C.IsActive ,S.Name AS StateName         
  FROM City C        
  INNER JOIN [State] S  WITH (NOLOCK)ON C.State_IATACode=S.State_ID        
  INNER JOIN [Country] CR  WITH (NOLOCK) ON S.Country_IATACode=CR.IATACode           
  WHERE 
  C.Name like CASE WHEN  ISNULL(@Name,'')<>'' THEN  '%' + @Name + '%'   ELSE   C.Name END      
  AND CR.IATACode= CASE WHEN ISNULL(@IATACode,'')<>'' THEN @IATACode ELSE  CR.IATACode END  
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
  AND CR.IATACode= CASE WHEN ISNULL(@IATACode,'')<>'' THEN @IATACode ELSE  CR.IATACode END  
  ORDER BY c.Name  
 END         
END   

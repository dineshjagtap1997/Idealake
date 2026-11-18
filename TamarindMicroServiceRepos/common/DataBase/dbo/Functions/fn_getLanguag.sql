
       
CREATE FUNCTION [dbo].[fn_getLanguag]      
(        
@LanguagesColumn VARCHAR(100)        
  )        
RETURNS VARCHAR(MAX)      
AS      
BEGIN      
DECLARE @SS VARCHAR(MAX)      
SET @SS=''      
(SELECT @SS=@SS+A.Language+',' FROM (      
 (SELECT L.Language FROM dbo.Split(@LanguagesColumn,',') S        
INNER JOIN Language L ON L.ID=S.items           
  WHERE items in (SELECT items FROM dbo.Split(@LanguagesColumn,',')))  )      
  A)    
SET  @SS=SUBSTRING(@SS,0,len(@SS))    
RETURN @SS      
END      
      

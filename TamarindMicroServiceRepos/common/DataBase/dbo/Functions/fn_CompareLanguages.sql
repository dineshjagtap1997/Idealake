
     
CREATE FUNCTION [dbo].[fn_CompareLanguages]      
(      
@LanguagesColumn VARCHAR(100),      
@LanguagesSearch VARCHAR(100)      
)      
RETURNS INT      
BEGIN      
      
DECLARE @RET INT=0      
IF EXISTS(SELECT * FROM dbo.Split(@LanguagesColumn,',')        
  WHERE items in (SELECT items FROM dbo.Split(@LanguagesSearch,',')))      
BEGIN      
 SET @RET=1      
END      
ELSE      
BEGIN      
 SET @RET=0      
END      
      
RETURN @RET      
      
END   

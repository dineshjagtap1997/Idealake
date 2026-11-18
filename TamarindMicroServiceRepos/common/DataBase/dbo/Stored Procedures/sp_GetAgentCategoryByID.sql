CREATE PROCEDURE [dbo].[sp_GetAgentCategoryByID]      
    @CategoryID INT=NULL,      
 @Action CHAR(2) = ''      
AS      
BEGIN      
     IF (@Action = 'S')      
    BEGIN      
    SELECT *       
    FROM AgentCategoryMaster      
    WHERE       
 (@CategoryID IS NULL OR @CategoryID = 0 OR CategoryID = @CategoryID)      
  SELECT '' AS returnCode, '' AS returnMessage      
    END  
	ELSE IF (@Action='EX')
	BEGIN
	 SELECT CategoryCode, CategoryValue,case when IsActive='1' then 'True'  WHEN IsActive = 0 THEN 'False' END as Isactive      
    FROM AgentCategoryMaster      
    WHERE       
 (@CategoryID IS NULL OR @CategoryID = 0 OR CategoryID = @CategoryID) 
	END
    ELSE      
    BEGIN      
  SELECT '201' AS returnCode, 'Invalid Action.' AS returnMessage      
    END      
END; 
CREATE PROCEDURE [dbo].[usp_GetAgentCategoryMaster]    
    @Action CHAR(2) = ''  
AS    
BEGIN
if(@Action='EX')
BEGIN
SELECT CategoryCode,CategoryValue,CASE WHEN IsActive='1' THEN 'True' WHEN IsActive='0' THEN 'False' END AS IsActive    
 FROM AgentCategoryMaster     
END
ELSE
BEGIN
 SELECT CategoryID,CategoryCode,CategoryValue,IsActive    
 FROM AgentCategoryMaster     
END 
END
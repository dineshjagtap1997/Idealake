-- =============================================        
-- Author:  Dhanya      
-- Create date: 14th July 2011        
-- Description: Retrieves all record Sec_Modules      
-- =============================================        
CREATE PROCEDURE [dbo].[usp_GetModules]        
AS          
BEGIN          
      
  SELECT ModuleID,ModuleName,ParentModuleID    
  FROM Sec_Modules where ParentModuleID IS NULL    
      
  Select ModuleID,ModuleName,ParentModuleID    
  FROM Sec_Modules where ParentModuleID IS NOT NULL         
      
END  
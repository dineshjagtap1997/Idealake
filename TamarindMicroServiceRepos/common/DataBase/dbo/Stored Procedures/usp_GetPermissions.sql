-- =============================================        
-- Author:  Dhanya      
-- Create date: 15th July 2011        
-- Description: Retrieves all record Sec_Permissions      
-- =============================================        
CREATE PROCEDURE [dbo].[usp_GetPermissions]        
AS          
BEGIN   
select PermissionID,PermissionName,PermissionCode from Sec_Permissions  
END  

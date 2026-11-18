-- =============================================    
-- Author:  Santosh  
-- Create date: 22nd June 2011    
-- Description: Retrieves all record aspnet_Roles  
-- =============================================    
CREATE PROCEDURE [dbo].[usp_GetAspnet_Roles]    
AS      
BEGIN      
  
  SELECT ApplicationId,RoleId,RoleName  
  FROM aspnet_Roles      
  
END  
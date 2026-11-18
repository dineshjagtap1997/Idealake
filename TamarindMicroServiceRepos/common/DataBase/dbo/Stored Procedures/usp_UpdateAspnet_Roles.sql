-- =============================================    
-- Author:  Santosh  
-- Create date: 22nd June 2011    
-- Description: Retrieves all record aspnet_Roles  
-- =============================================    
CREATE PROCEDURE [dbo].[usp_UpdateAspnet_Roles]    
(  
@RoleId uniqueidentifier,  
@ApplicationName nvarchar(512),  
@RoleName nvarchar(512),  
@ErrMsg varchar(100)OUT  
)  
AS      
BEGIN   
 DECLARE @ApplicationId uniqueidentifier  
 SET @ApplicationId =(SELECT ApplicationId FROM aspnet_Applications WHERE UPPER(ApplicationName)=UPPER(@ApplicationName))  
  
 IF EXISTS(SELECT RoleId FROM aspnet_Roles WHERE UPPER(RoleName)=UPPER(@RoleName)   
            AND ApplicationId=@ApplicationId   
            AND RoleId<>@RoleId )  
 BEGIN  
  SET @ErrMsg='Roles Name already exists.'   
 END  
ELSE  
BEGIN  
 UPDATE aspnet_Roles SET  
 RoleName=@RoleName,  
 LoweredRoleName=LOWER(@RoleName)  
 WHERE RoleId=@RoleId  
   
END  
END  
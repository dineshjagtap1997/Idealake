-- =============================================        
-- Modified by : Sarthak Mane        
-- Modified on : 09th December, 2024        
-- Reason : Insertes into Sec_RolePermissions Table      
-- =============================================        
CREATE PROCEDURE [dbo].[usp_InsertRoles_Permissions]        
@RoleID   UNIQUEIDENTIFIER,        
@ModuleID  INT,        
@Permissions INT,    
@Action CHAR(2) = ''     
AS        
BEGIN           
    DECLARE @ReturnCode NVARCHAR(3), @ReturnMessage NVARCHAR(MAX);      
      
    IF @Action = 'I'          
    BEGIN    
        IF EXISTS(SELECT TOP 1 1 FROM Sec_RolePermissions WHERE RoleID=@RoleID AND ModuleID=@ModuleID)          
        BEGIN         
            SET @ReturnCode = '201';      
            SET @ReturnMessage = 'This data already exists. Please check and try again';              
            SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;   
        END  
        ELSE              
        BEGIN    
            INSERT INTO Sec_RolePermissions (RoleID, ModuleID, [Permissions])        
            VALUES (@RoleID, @ModuleID, @Permissions);     
              
            SET @ReturnCode = '200';      
            SET @ReturnMessage = 'New record added successfully';          
            SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;      
        END          
    END      
      
    ELSE IF @Action = 'U'          
    BEGIN      
        IF EXISTS (SELECT TOP 1 1 FROM Sec_RolePermissions WHERE RoleID = @RoleID AND ModuleID = @ModuleID)          
        BEGIN      
            UPDATE Sec_RolePermissions     
            SET [Permissions] = @Permissions    
            WHERE RoleID = @RoleID AND ModuleID = @ModuleID;            
              
            SET @ReturnCode = '200';      
            SET @ReturnMessage = 'Record updated successfully.';           
            SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;      
        END      
        ELSE      
        BEGIN      
            SET @ReturnCode = '201';      
            SET @ReturnMessage = 'Role and Module combination not found!';      
            SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;      
        END          
    END      
      
    ELSE IF @Action = 'S'      
    BEGIN      
        SELECT RoleID, ModuleID, [Permissions]      
        FROM Sec_RolePermissions      
        WHERE (@RoleID IS NULL OR RoleID = @RoleID)      
        AND (@ModuleID IS NULL OR ModuleID = @ModuleID);      
      
        SET @ReturnCode = '200';      
        SET @ReturnMessage = 'Success';          
        SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;     
    END      
      
    ELSE      
    BEGIN      
        SET @ReturnCode = '201';      
        SET @ReturnMessage = 'Invalid Action';      
        SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;      
    END    
END  
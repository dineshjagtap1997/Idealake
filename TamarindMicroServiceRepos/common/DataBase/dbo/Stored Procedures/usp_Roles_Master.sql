CREATE PROCEDURE [dbo].[usp_Roles_Master] @Action CHAR(1),-- Operation flag: I (Insert), S (Select), U (Update), D (Delete)  
 @RoleId INT = NULL,-- Role ID (used for Update, Delete, and Select by ID)  
 @RoleName NVARCHAR(256) = NULL,-- Role Name (used for Insert/Update)  
 @Description NVARCHAR(256) = NULL,-- Role Description (used for Insert/Update)  
 @IsActive BIT = NULL,-- Indicates if the role is active (used for Insert/Update)  
 @CreatedBy INT = NULL,-- Created By (used for Insert)  
 @UpdatedBy INT = NULL, -- Updated By (used for Update)  
 @OperationBy UNIQUEIDENTIFIER = NULL    
AS  
BEGIN  
 DECLARE @ReturnCode NVARCHAR(3)  
  ,@ReturnMessage NVARCHAR(MAX);  
DECLARE @LogId int;  
 -- Insert Operation  
 IF @Action = 'I'  
 BEGIN  
  IF EXISTS (  
    SELECT TOP 1 1  
    FROM Roles  
    WHERE UPPER(RoleName) = UPPER(@RoleName)  
    )  
  BEGIN  
   SET @ReturnCode = '201';  
   SET @ReturnMessage = 'Role Name already exists!';  
   SET @RoleId = 0;  
  END  
  ELSE  
  BEGIN  
   INSERT INTO Roles (  
    RoleName  
    ,Description  
    ,IsActive  
    ,CreatedBy  
    ,CreatedDateTime  
    )  
   VALUES (  
    @RoleName  
    ,@Description  
    ,ISNULL(@IsActive, 1)  
    ,@CreatedBy  
    ,GETDATE()  
    );  
  
   SET @ReturnCode = '200';  
   SET @ReturnMessage = 'Data Inserted';  
   SET @RoleId = SCOPE_IDENTITY();  
  END  
 END  
   -- Select Operation  
 ELSE IF @Action = 'S'  
 BEGIN  
  IF @RoleId IS NULL OR @RoleId = 0  
  BEGIN  
  
  SELECT RoleId,RoleName,Description,IsActive  
   FROM ROLEs  
   WHERE IsActive = 1  
   ORDER BY RoleId DESC;  
     
  END  
  ELSE  
  BEGIN  
   -- Select by RoleId  
   SELECT RoleId,RoleName,Description  
   FROM Roles  
   WHERE RoleId = @RoleId and IsActive = 1;  
     
  END  
  SET @ReturnCode = '200';  
  SET @ReturnMessage = 'Data Fetched Successfully';  
 END  
   -- Update Operation  
 ELSE IF @Action = 'U'  
 BEGIN  
  UPDATE Roles  
  SET RoleName = ISNULL(@RoleName, RoleName)  
   ,-- Update RoleName if provided  
   Description = ISNULL(@Description, Description)  
   ,-- Update Description if provided  
   IsActive = ISNULL(@IsActive, IsActive)  
   ,-- Update IsActive if provided  
   UpdatedBy = @UpdatedBy  
   ,UpdatedDateTime = GETDATE()  
  WHERE RoleId = @RoleId;  
  
  SET @ReturnCode = '200';  
  SET @ReturnMessage = 'Data Updated';  
  SET @RoleId = @RoleId   
 END  
   -- Delete Operation  
 ELSE IF @Action = 'D'  
 BEGIN  
  UPDATE Roles  
  SET IsActive = 0  
   ,UpdatedBy = @UpdatedBy  
   ,UpdatedDateTime = GETDATE()  
  WHERE RoleId = @RoleId;  
  
  SET @ReturnCode = '200';  
  SET @ReturnMessage = 'Data Deleted';  
 END  
   -- Invalid Flag  
 ELSE  
 BEGIN  
  SET @ReturnCode = '201';  
  SET @ReturnMessage = 'Invalid Action';  
 END  
  
 SELECT @ReturnCode AS returnCode  
  ,@ReturnMessage AS returnMessage, @RoleId as ID  
END;  
  
  
  
  
CREATE PROCEDURE [dbo].[usp_InsertCity_Audit]    
@IATACode CHAR(3) = '',              
@State_IATACode INT = '',              
@Name VARCHAR(50) = '',              
@STDCode INT = '',              
@IsActive BIT='',              
@OperationBy UNIQUEIDENTIFIER = NULL,              
@Action VARCHAR(50) = ''     
AS    
BEGIN  
IF @Action = 'I'  
 set @Action = 'Insert'  
  
ELSE IF @Action = 'U'  
 set @Action = 'Update'  
  
 INSERT INTO City_Audit    
    (IATACode, State_IATACode,Name, STDCode, IsActive, Operation,  OperationBy,  OperationOn)    
 VALUES  (@IATACode, @State_IATACode, @Name, @STDCode, @IsActive, @Action, @OperationBy, GETDATE())    
END
CREATE PROCEDURE [dbo].[usp_Agent_Group]                
 @AgentGroupCode  VARCHAR(50)='',                
 @AgentGroupName  VARCHAR(50)='',                
 @IsActive   BIT=1,                 
 @OperationBy  UNIQUEIDENTIFIER=NULL,                
 --@ErrMsg    VARCHAR(50) OUT              
 @Action char(2)=''          
 ,@AgentGroupID Int =''         
AS            
BEGIN           
IF @Action='I'          
BEGIN                
                 
 IF EXISTS(SELECT AgentGroupCode FROM AgentGroup WHERE UPPER(AgentGroupCode) = UPPER(@AgentGroupCode))                
 BEGIN          
           
SELECT '201' AS returnCode, 'Agent Group Code already exists. Please check and try again.'  AS returnMessage;                
 END                
                 
 ELSE IF EXISTS(SELECT AgentGroupName FROM AgentGroup WHERE UPPER(AgentGroupName) = UPPER(@AgentGroupName))                
 BEGIN           
 SELECT '201' AS returnCode, 'Agent Group Name already exists. Please check and try again.'    AS returnMessage;          
 END                
                  
 ELSE                
 BEGIN               
               
    declare @MaxID int  = (Select MAX(OldID) from AgentGroup) + 1               
               
  INSERT INTO AgentGroup          
  (AgentGroupCode,          
  AgentGroupName,          
  IsActive,          
  Operation,          
  OperationBy,          
  OperationDate,          
  OldID)                
  VALUES           
  (UPPER(@AgentGroupCode),          
  @AgentGroupName,          
  @IsActive,          
  'Insert',          
  @OperationBy,          
  GETDATE(),          
  @MaxID)                
                
 END          
 SELECT '200' AS returnCode, 'New record added successfully.'     AS returnMessage;          
                 
END  --I          
ELSE IF @Action='U'          
BEGIN            
 IF EXISTS(SELECT AgentGroupCode FROM AgentGroup WHERE UPPER(AgentGroupCode) = UPPER(@AgentGroupCode) AND AgentGroupID <> @AgentGroupID)            
 BEGIN           
 SELECT '201' AS returnCode, 'Agent Group Code already exists. Please check and try again.' AS returnMessage;                
 END            
             
 ELSE IF EXISTS(SELECT AgentGroupName FROM AgentGroup WHERE UPPER(AgentGroupName) = UPPER(@AgentGroupName) AND AgentGroupID <> AgentGroupID)            
 BEGIN           
 SELECT '201' AS returnCode, 'Agent Group Name already exists. Please check and try again.'     AS returnMessage;          
 END            
             
 ELSE             
 BEGIN            
  UPDATE AgentGroup SET AgentGroupCode = UPPER(@AgentGroupCode),            
    AgentGroupName = @AgentGroupName,            
    IsActive = @IsActive,            
    Operation = 'Update',            
    OperationBy = @OperationBy,            
    OperationDate = GETDATE()            
  WHERE AgentGroupID = @AgentGroupID            
 END           
 SELECT '200' AS returnCode, 'Record updated successfully.'     AS returnMessage;          
             
END  --U          
ELSE IF @Action='S'          
BEGIN                  
 SELECT * FROM AgentGroup      
                 
END          
ELSE IF @Action='EX'
BEGIN
select AgentGroupCode,AgentGroupName,CASE WHEN IsActive='1' THEN 'True' WHEN IsActive='0' THEN 'False' END AS IsActive,Operation from AgentGroup
END
          
END 
CREATE PROCEDURE [dbo].[usp_Accounts_BankMaster]           
@BankAccountName VARCHAR(500)  =''              
 ,@BankAccountDetails VARCHAR(MAX)    =''            
 ,@IsActive BIT = 1                
 ,@OperationBy UNIQUEIDENTIFIER                
 ,@Action char(2)=''                
 ,@AccountBankMasterID INT=''   
 ,@Currency nvarchar(50)=''
 ,@LegalEntityId int=0
 ,@AccountName nvarchar(100)=''
 ,@AccountNumber nvarchar(100)=''
 ,@AccountPrefix nvarchar(50)=''
 ,@IsVirtualAccount bit=0
AS                
BEGIN       
Declare @LogID int;     
IF @Action='I'                
BEGIN                
IF EXISTS (                
  SELECT AccountBankMasterID                
  FROM AccountsBankMaster                
  WHERE UPPER(BankAccountName) = UPPER(@BankAccountName)                
  )                
BEGIN                
SELECT '201' AS returnCode, 'Bank Account Name already exists.Please check and try again.' AS returnMessage, @LogID AS ID;                   
END                
ELSE                
BEGIN                
 INSERT INTO AccountsBankMaster (                
  BankAccountName                
  ,BankAccountDetails                
  ,IsActive                
  ,Operation                
  ,OperationBy                
  ,InsertedDatetime
  ,Currency 
  ,LegalEntityId 
  ,AccountName 
  ,AccountNumber
  ,AccountPrefix
  ,IsVirtualAccount
  )                
 VALUES (                
  @BankAccountName                
  ,@BankAccountDetails                
  ,@IsActive                
  ,'Insert'                
  ,@OperationBy                
  ,GETDATE()  
  ,@Currency 
  ,@LegalEntityId 
  ,@AccountName 
  ,@AccountNumber
  ,@AccountPrefix
  ,@IsVirtualAccount
  )                
         
  SET @LogID = SCOPE_IDENTITY()    
  SELECT '200' AS returnCode, 'New record added successfully.' AS returnMessage, @LogID AS ID;                   
                
END                
                
END--S                
ELSE IF @Action='U'                
BEGIN                
 IF NOT EXISTS (                
   SELECT AccountBankMasterID                
   FROM AccountsBankMaster                
   WHERE UPPER(BankAccountName) = UPPER(@BankAccountName)                
    AND AccountBankMasterID <> @AccountBankMasterID                
   )                
 BEGIN                
  UPDATE AccountsBankMaster                
  SET BankAccountName = @BankAccountName                
   ,BankAccountDetails = @BankAccountDetails                
   ,IsActive = @IsActive                
   ,Operation = 'Update'   
   ,Currency =@Currency
   ,LegalEntityId =@LegalEntityId
   ,AccountName =@AccountName
   ,AccountNumber=@AccountNumber
   ,AccountPrefix=@AccountPrefix
   ,IsVirtualAccount=@IsVirtualAccount
   ,UpdatedBy = @OperationBy          
   ,UpdatedOn = GETDATE()          
  WHERE AccountBankMasterID = @AccountBankMasterID                
                
  SELECT '200' AS returnCode, 'Record updated successfully.' AS returnMessage, @AccountBankMasterID AS ID;                   
                
 END                
 ELSE                
 BEGIN                
 SELECT '201' AS returnCode, 'Bank Account Name already exists. Please check and try again.' AS returnMessage;                   
 END                
END                
ELSE IF @Action='S'                
BEGIN                        
	SELECT 
		 AccountBankMasterID
		,BankAccountName 
		,BankAccountDetails
		,Currency 
		,LegalEntityId 
		,(SELECT TOP 1 LegalName FROM EntityMaster where ID=LegalEntityId) as LegalName
		,AccountName 
		,AccountNumber
		,AccountPrefix
		,IsVirtualAccount
		,IsActive                      
   FROM AccountsBankMaster             
   WHERE(@AccountBankMasterID IS NULL OR @AccountBankMasterID = 0 OR AccountBankMasterID=@AccountBankMasterID)          
   ORDER BY AccountBankMasterID DESC              
          
 --IF(@IsActive=0)                                
 --BEGIN                                
 --  SELECT AccountBankMasterID, BankAccountName, BankAccountDetails, IsActive                      
 --  FROM AccountsBankMaster                      
 --  ORDER BY BankAccountName ASC                          
 --END                                
 --ELSE                                
 --BEGIN                                
 --  SELECT AccountBankMasterID, BankAccountName, BankAccountDetails, IsActive                      
 --  FROM   AccountsBankMaster                      
 --  WHERE IsActive=1                                
 --  ORDER BY BankAccountName ASC                             
 --END                                
                                 
END                 
ELSE IF @Action='EX'  
BEGIN  
 SELECT  
	BankAccountName, BankAccountDetails ,
	CASE   
        WHEN IsActive = 1 THEN 'True'  
        WHEN IsActive = 0 THEN 'False'  
    END AS IsActive 
	,Currency 
	,LegalEntityId
	,(SELECT TOP 1 LegalName FROM EntityMaster where ID=LegalEntityId) as LegalName
	,AccountName 
	,AccountNumber
	,AccountPrefix
	,IsVirtualAccount
	,IsActive    
   FROM AccountsBankMaster             
   WHERE(@AccountBankMasterID IS NULL OR @AccountBankMasterID = 0 OR AccountBankMasterID=@AccountBankMasterID)          
   ORDER BY AccountBankMasterID DESC       
END  
      --SELECT '200' AS returnCode, 'Data Retrieved' AS returnMessage;                   
END 
CREATE PROCEDURE [dbo].[usp_BankMasterDtls]                    
@AccountBankMasterID INT,      
@Currency VARCHAR(500),                  
@BankAccountDetails   VARCHAR(MAX),       
@IsTTCBank BIT =1,                
@IsActive BIT =1,                    
@OperationBy UNIQUEIDENTIFIER,       
@CompanyID int,           
@AccountName varchar(250),      
@AccountNo varchar(250),      
@IsVirtual BIT = 0,       
@AccountPrefix VARCHAR(50),         
@IsRedDot BIT = 0,      
@Action CHAR(2)=''    
,@BankID INT =''    
--@ErrMsg  VARCHAR(50) OUT                      
AS    
BEGIN    
IF @Action='I'    
BEGIN     
 IF EXISTS(SELECT BankID FROM BankMasterNew  WHERE  AccountBankMasterID =@AccountBankMasterID AND UPPER(Currency)=UPPER(@Currency) and companyid = @CompanyID)                      
  BEGIN      
  SELECT '201' AS returnCode,  'Bank Name already exists!' AS returnMessage;                     
 END                
 ELSE                    
 BEGIN                    
  INSERT INTO BankMasterNew(AccountBankMasterID,Currency,Details,isTTCBankDetails,IsActive,CreatedBy      
  ,CreatedDatetime,CompanyID, AccountName,AccountNo,IsVirtualAccount, AccountPrefix, IsRedDot)                    
  VALUES(@AccountBankMasterID,@Currency, @BankAccountDetails,@IsTTCBank,@IsActive,@OperationBy      
  ,GETDATE(),@CompanyID, @AccountName,@AccountNo,@IsVirtual, @AccountPrefix, @IsRedDot)     
    
	--SET @BankID = SCOPE_IDENTITY()
   SELECT '200' AS returnCode, 'New record added successfully' AS returnMessage , @BankID as ID;     
END      
    
END    
ELSE IF @Action='U'    
BEGIN                
                
 IF NOT EXISTS(SELECT BankID FROM BankMasterNew WHERE  AccountBankMasterID=@AccountBankMasterID AND UPPER(Currency) = UPPER(@Currency) and companyid = @CompanyID       
 AND BankID <> @BankID)                
 BEGIN                
  UPDATE BankMasterNew                 
  SET AccountBankMasterID=@AccountBankMasterID,  Details = @BankAccountDetails, Currency = @Currency, isTTCBankDetails = @IsTTCBank,      
   IsActive=@IsActive, UpdatedBy=@OperationBy, UpdatedDatetime =getdate(),      
   companyID = @CompanyID,        
   AccountName = @AccountName,      
 AccountNo = @AccountNo,      
 IsVirtualAccount = @IsVirtual ,      
  AccountPrefix = @AccountPrefix,      
   IsRedDot = @IsRedDot      
  WHERE BankID=@BankID   
     SELECT '200' AS returnCode, 'Record Updated Successfully' AS returnMessage , @BankID as ID;     
 END                
 ELSE                
 BEGIN      
   SELECT '201' AS returnCode,  'This data already exists. Please check and try again'  AS returnMessage;                     
              
 END                
END    
ELSE IF @Action='S'   
BEGIN  
SELECT   
    BankID,   
    AccountBankMasterID,   
    Currency,   
    CompanyID,   
    AccountName,   
    AccountNo,   
    AccountPrefix,   
    Details,   
    IsVirtualAccount,   
    isTTCBankDetails,   
    IsRedDot   
FROM   
    BankMasterNew WITH (NOLOCK)   
WHERE      (@AccountBankMasterID IS NULL OR @AccountBankMasterID = AccountBankMasterID) AND     (@Currency IS NULL OR @Currency = Currency) AND     (@CompanyID IS NULL OR @CompanyID = CompanyID) AND     (@AccountName IS NULL OR @AccountName = AccountName)
 AND     (@AccountNo IS NULL OR @AccountNo = AccountNo) AND     (@AccountPrefix IS NULL OR @AccountPrefix = AccountPrefix) AND     (@IsVirtual IS NULL OR @IsVirtual = IsVirtualAccount) AND     (@IsTTCBank IS NULL OR @IsTTCBank = isTTCBankDetails) AND     
(@IsRedDot IS NULL OR @IsRedDot = IsRedDot);  
  
END  
END  
  
  
  
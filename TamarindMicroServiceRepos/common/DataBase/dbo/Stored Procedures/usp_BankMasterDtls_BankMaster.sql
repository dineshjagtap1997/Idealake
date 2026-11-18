CREATE PROCEDURE [dbo].[usp_BankMasterDtls_BankMaster]                 
@AccountBankMasterID INT=''                
 ,@Currency VARCHAR(500)=''                
 --,@BankAccountDetails VARCHAR(MAX)=''             
 ,@Details varchar(MAX)=''            
 --,@IsTTCBank BIT = 1           
 ,@isTTCBankDetails BIT=1          
 ,@IsActive BIT = 1                
 ,@OperationBy UNIQUEIDENTIFIER=null                
 ,@CompanyID INT=''                
 ,@AccountName VARCHAR(250)=''                
 ,@AccountNo VARCHAR(250)=''                
-- ,@IsVirtual BIT = 0           
,@IsVirtualAccount BIT=0          
 ,@AccountPrefix VARCHAR(50)=''                
 --,@IsRedDot BIT = 0            
 ,@IsRedDotBankDetails BIT=0          
 ,@Action CHAR(2) = ''                
 ,@BankID INT = ''                
 --@ErrMsg  VARCHAR(50) OUT                                  
AS                
BEGIN                
declare @LogID int ;      
 IF @Action = 'I'                
  IF EXISTS (                
    SELECT BankID                
    FROM BankMasterNew                
    WHERE AccountBankMasterID = @AccountBankMasterID                
     AND UPPER(Currency) = UPPER(@Currency)                
     AND companyid = @CompanyID                
    )                
  BEGIN                
   SELECT '201' AS returnCode                
    ,'This data already exists. Please check and try again.' AS returnMessage                
  END                
  ELSE                
  BEGIN                
   INSERT INTO BankMasterNew (                
    AccountBankMasterID                
    ,Currency                
    ,Details                
    ,isTTCBankDetails                
    ,IsActive                
    ,CreatedBy                
    ,CreatedDatetime                
    ,CompanyID                
    ,AccountName                
    ,AccountNo                
    ,IsVirtualAccount                
    ,AccountPrefix                
    ,IsRedDot                
    )                
   VALUES (                
    @AccountBankMasterID                
    ,@Currency                
    ,@Details                
    ,@isTTCBankDetails                
    ,@IsActive                
    ,@OperationBy                
    ,GETDATE()                
    ,@CompanyID                
    ,@AccountName                
    ,@AccountNo                
    ,@IsVirtualAccount                
    ,@AccountPrefix                
    ,@IsRedDotBankDetails                
    )                
              
        
  set @LogID = SCOPE_IDENTITY()      
   SELECT '200' AS returnCode                
    ,'New record added successfully.' AS returnMessage , @LogID AS ID               
  END                
 ELSE IF @Action = 'U'                
 BEGIN                
  IF NOT EXISTS (                
    SELECT BankID                
    FROM BankMasterNew                
    WHERE AccountBankMasterID = @AccountBankMasterID                
     AND UPPER(Currency) = UPPER(@Currency)                
     AND companyid = @CompanyID                
     AND BankID <> @BankID                
    )                
  BEGIN                
   UPDATE BankMasterNew                
   SET AccountBankMasterID =ISNULL( @AccountBankMasterID,AccountBankMasterID)                
    ,Details = ISNULL(@Details,Details)                
    ,Currency = ISNULL(@Currency,Currency)                
    ,isTTCBankDetails =ISNULL( @isTTCBankDetails,isTTCBankDetails)                
    ,IsActive = ISNULL(@IsActive,IsActive)                
    ,UpdatedBy = @OperationBy                
    ,UpdatedDatetime = getdate()                
    ,companyID = isnull(@CompanyID,companyID)                
    ,AccountName =isnull( @AccountName,AccountName)                
    ,AccountNo = isnull(@AccountNo,AccountNo)                
    ,IsVirtualAccount = isnull(@IsVirtualAccount,IsVirtualAccount)                
    ,AccountPrefix = isnull(@AccountPrefix,AccountPrefix)                
    ,IsRedDot = isnull(@IsRedDotBankDetails,IsRedDot)                
   WHERE BankID = @BankID     
                
   SELECT '200' AS returnCode                
    ,'Record updated successfully.' AS returnMessage, @BankID AS ID                 
  END                
  ELSE                
  BEGIN        
   SELECT '201' AS returnCode                
    ,'This data already exists. Please check and try again.' AS returnMessage                
  END                
 END                
 ELSE IF @Action = 'S'                
 BEGIN               
  SELECT BankID                
   ,BankMasterNew.AccountBankMasterID AS 'RefID'                
   ,AccountsBankMaster.BankAccountName AS 'BankName'                
   ,Currency --AS 'Name'                
   ,BankMasterNew.Details                
   ,isTTCBankDetails                
   ,BankMasterNew.isActive AS IsActive                
   ,CreatedBy                
   ,CreatedDatetime                
   ,UpdatedDatetime                
   ,AccountsBankMaster.AccountBankMasterID                
   ,Currency.Code                
   ,dbo.udf_StripHTML(Details) AS 'BnkDetails'                
   ,C.CompanyName                
   ,BankMasterNew.CompanyID                
   ,AccountName                
   ,AccountNo                
   ,IsVirtualAccount               
   ,AccountPrefix                
   ,isRedDot AS 'IsRedDotBankDetails'                
  FROM BankMasterNew                
  LEFT JOIN AccountsBankMaster ON BankMasterNew.AccountBankMasterID = AccountsBankMaster.AccountBankMasterID                
  INNER JOIN Currency ON BankMasterNew.Currency = Currency.Code                
  LEFT JOIN CompanyMaster C ON BankMasterNew.CompanyID = C.CompanyID             
  WHERE (       @BankID IS NULL       OR @BankID = 0       OR BankID = @BankID      )              
  ORDER BY BankID DESC              
              
 END       
     
  ELSE IF @Action = 'EX'                
 BEGIN               
   SELECT                 
   AccountsBankMaster.BankAccountName AS 'BankName'                
   ,Currency --AS 'Name'                
 , CASE   
        WHEN isTTCBankDetails = 1 THEN 'Yes'  
        WHEN isTTCBankDetails = 0 THEN 'No'  
    END AS isTTCBankDetails                 
   ,CASE   
        WHEN BankMasterNew.isActive = 1 THEN 'True'  
        WHEN BankMasterNew.isActive = 0 THEN 'False'  
    END AS IsActive , CASE   
        WHEN isRedDot = 1 THEN 'Yes'  
        WHEN isRedDot = 0 THEN 'No'  
    END AS IsRedDotBankDetails                      
   ,CreatedBy                
   ,CreatedDatetime                
   ,UpdatedDatetime                
   ,Currency.Code                
   ,dbo.udf_StripHTML(Details) AS 'BnkDetails'                
   ,C.CompanyName                

  FROM BankMasterNew                
  LEFT JOIN AccountsBankMaster ON BankMasterNew.AccountBankMasterID = AccountsBankMaster.AccountBankMasterID                
  INNER JOIN Currency ON BankMasterNew.Currency = Currency.Code                
  LEFT JOIN CompanyMaster C ON BankMasterNew.CompanyID = C.CompanyID             
  WHERE (       @BankID IS NULL       OR @BankID = 0       OR BankID = @BankID      )              
  ORDER BY BankID DESC              
          
              
 END     
END
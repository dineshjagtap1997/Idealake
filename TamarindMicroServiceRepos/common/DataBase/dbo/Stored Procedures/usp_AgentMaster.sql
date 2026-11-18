ALTER PROCEDURE [dbo].[usp_AgentMaster] @AccCode VARCHAR(50) = ''                                
 ,@AgentCode VARCHAR(50) = NULL                                
 ,@AgentName VARCHAR(200) = NULL                                
 ,@CategoryID INT = NULL                                
 ,@Miscellaneous TINYINT = NULL                                
 ,@GroupID INT = NULL                                
 ,@MarketID INT = NULL                                
 ,@City_IATACode CHAR(3) = NULL                                
 ,@Website VARCHAR(200) = NULL                                
 ,@PhoneNo VARCHAR(35) = NULL                                
 ,@MobileNo VARCHAR(15) = NULL                                
 ,@FaxNo VARCHAR(35) = NULL                                
 ,@EmailID VARCHAR(200) = NULL                                
 ,@PanNo VARCHAR(50) = NULL                                
 ,@STRegNo VARCHAR(50) = NULL                                
 ,@ChequeFavouring VARCHAR(200) = NULL                                
 ,@Address VARCHAR(MAX) = NULL                                
 ,@CreateAdvanceAccount BIT = NULL                                
 ,@CreditApplicable BIT = NULL                                
 ,@CreditCurrencyCode VARCHAR(5) = NULL                                
 ,@CreditAllowance DECIMAL = NULL                                
 ,@Threshold DECIMAL = NULL                                
 ,@CreditPeriod INT = NULL                                
 ,@OutStandingAmount DECIMAL = NULL                                
 ,@UnlimitedCredit BIT = NULL                                
 ,@IsActive BIT = NULL                                
 ,@IsOtherBooking BIT = NULL                                
 ,@IsCorporate BIT = 0                                
 ,@OperationBy UNIQUEIDENTIFIER = NULL                                
 ,@IsFromB2BOrAstra TINYINT = NULL                                
 ,@BankAccountID INT = NULL                                
 ,@AgentID INT = NULL                                
 ,@RelatedEmployeeID INT = 0                                
 ,@HasBranch BIT = 0                                
 ,@StateCodeID INT = NULL                                
 ,@IsInterBranch BIT = 0                                
 ,@IsSEZ BIT = 0                                
 ,@AddressExist BIT = NULL                                
 ,@GSTRequired BIT = NULL                                
 ,@AddressCountry VARCHAR(500) = NULL                                
 ,@AddressState VARCHAR(500) = NULL                                
 ,@AddressCity VARCHAR(500) = NULL                                
 ,@isActiveSAP BIT = 0                                
 ,@TANDetails VARCHAR(500) = NULL                                
 ,@PreviousCode VARCHAR(500) = NULL                                
 ,@AgentClassification INT = NULL                                
 ,@Comments VARCHAR(500) = NULL                                
 ,@IsAgentREFPO BIT = 0                                
 ,@BusinessHeadID INT = 0                                
 ,@SalesHeadID INT = 0                                
 ,@PostalCode VARCHAR(10) = NULL                                
 ,@LegalEntity INT = 0                                
 ,@LegalName VARCHAR(80) = NULL                                
 ,@Virtualaccount BIT = 0                                
 ,@Action CHAR(5) = 'SA'                                
 ,@BranchName VARCHAR(100) = NULL                                
 ,@BankName VARCHAR(100) = NULL                                
 ,@AccountNumber VARCHAR(20) = NULL                                
 ,@IFSCCode VARCHAR(20) = NULL                                
 ,@SWIFTCode VARCHAR(20) = NULL                                
 ,@MSMEUanNumber NVARCHAR(30) = NULL                                
 ,@IATACode VARCHAR(20) = NULL                                
 ,@Contact1 VARCHAR(15) = NULL                                
 ,@Contact2 VARCHAR(15) = NULL                                
 ,@MSMEType VARCHAR(50) = NULL              
 ,@MarkUpCategory VARCHAR(50) = NULL                                
 ,@IATOCode VARCHAR(20) = NULL          
 ,@Country_IATACode VARCHAR(10) = NULL                                
 ,@CategoryCode VARCHAR(20) = NULL                                
,@CountryName VARCHAR(50) = NULL                                
 ,@CityName VARCHAR(50) = NULL                                
 ,@GSTIN VARCHAR(20) = NULL                                
 ,@Market VARCHAR(50) = NULL                                
 ,@OperationOn1 DATETIME = NULL                                
 ,@IsCorporate_Y VARCHAR(10) = NULL                                
 ,@TamSalesRep INT = NULL                                
 ,@IsBranch BIT = NULL                                
 ,@CompanyCode INT = NULL                                
 ,@BeneficiaryName VARCHAR(200) = NULL                                
 ,@PANVERIFICATION VARCHAR(100) = NULL                                
 ,@GSTVERIFICATION VARCHAR(100) = NULL                                
 ,@TANVERIFICATION VARCHAR(100) = NULL                                
 ,@GroupName VARCHAR(max) = ''                                
 ,@TamSalesName VARCHAR(max) = ''                                
 ,@IsContact1Mobile BIT = 0                                
 ,@IsContact2Mobile BIT = 0                                
 ,@IsAgent BIT = 0                                
 ,@LeadID VARCHAR(50) = NULL                   
, @TaxType varchar(50)=''                 
,@SalesTaxRegNumber NVarchar(200)='',                
@UsedInBooking BIT =1,                
@PageNumber INT = 0,                
@Row_Count INT = 10                
                
AS                                
BEGIN                                
 DECLARE @ReturnCode NVARCHAR(3)                                
  ,@ReturnMessage NVARCHAR(MAX)                                
  ,@logStatus BIT                 
  ,@TotalRecordCount INT = 0;                                
                      
 IF(ISNULL(@PageNumber,0)=0)                
  BEGIN                
   SET @PageNumber=0                
  END                
 IF @Action = 'I'                                
  AND @IsAgent = 1                                
 BEGIN                                
  IF EXISTS (                                
    SELECT 1                                
    FROM AgentMaster                                
    WHERE (LTRIM(RTRIM(UPPER(EmailID))) = LTRIM(RTRIM(UPPER(@EmailID))) and  PhoneNo = @PhoneNo)                            
   AND EmailID <>'' AND PhoneNo <> '' )                                
  BEGIN                                
   SELECT '201' AS returnCode                                
    ,'This Agent already exists. Please check and try again.' AS returnMessage;                                
  END                                
  ELSE                                
  BEGIN                                                             
   SET @AgentCode = 'DR' + RIGHT('0000000' + CAST((                                
       SELECT ISNULL(AGENTCODE, 0) + 1                                
       FROM tbl_Counter                                
       ) AS VARCHAR(8)), 8);                                
                                
   UPDATE tbl_Counter                                
   SET AGENTCODE = CAST(RIGHT(@AgentCode, 7) AS BIGINT)                                
    ,UpdationDate = GETDATE();                                
                                
   INSERT INTO AgentMaster (                                
    AccCode                                
    ,AgentCode                                
    ,AgentName                                
    ,CategoryID                                
    ,Miscellaneous                                
    ,GroupID                                
    ,MarketID                                
    ,City_IATACode                                
    ,Website                                
    ,PhoneNo                                
    ,MobileNo       
    ,FaxNo                                
    ,EmailID                                
    ,PanNo                                
    ,STRegNo                                
    ,ChequeFavouring                                
    ,[Address]       
    ,CreateAdvanceAccount                                
    ,CreditApplicable                                
    ,CreditCurrencyCode                                
    ,CreditAllowance                                
    ,Threshold                                
    ,CreditPeriod                                
   ,OutStandingAmount                                
    ,UnlimitedCredit                                
    ,IsActive                                
    ,IsOtherBooking                                
    ,Operation                                
    ,OperationBy                                
    ,OperationOn                                
    ,IsCorporate                                
    ,BankAccountID                                
    ,RelatedEmployeeID                                
    ,HasBranch                                
    ,StateCodeID                                
    ,IsInterBranch                                
    ,IsSEZ                                
    ,AddressExist                                
  ,GSTRequired                                
    ,AddressCountry                                
    ,AddressState                                
    ,AddressCity                                
    ,isActiveSAP                                
    ,TANDetails                                
    ,PreviousCode                                
    ,AgentClassification                                
    ,Comments                        
    ,IsAgentREFPO                                
    ,BusinessHeadID                                
    ,SalesHeadID                                
    ,PostalCode                                
    ,LegalEntity                                
    ,LegalName                                
    ,Virtualaccount                                
    ,BeneficiaryName                                
    ,Accountnumber                                
    ,ifsccode                                
    ,swiftcode                                
    ,MSME_UAN_Number                                
    ,IATACode                                
    ,IATOCode                                
    ,MSMEType                                
    ,BranchName                                
    ,BankName                                
    ,TamSalesrep                                
    ,GSTIN                                
    ,PANVERIFICATION                                
    ,GSTVERIFICATION                                
    ,TANVERIFICATION                                
    ,Contact1                                
    ,contact2                                
    ,IsContact1Mobile                                
    ,IsContact2Mobile                                
    ,IsAgent                                
    ,LeadID                    
 ,TaxType                
                 
    )                                
   VALUES (                                
    @AccCode                                
    ,@AgentCode                                
    ,REPLACE(REPLACE(REPLACE(ISNULL(@AgentName, ''), CHAR(13), ''), CHAR(10), ' '), '  ', ' ')                                
    ,@CategoryID                                
    ,@Miscellaneous                                
    ,@GroupID                                
    ,@MarketID                                
    ,@City_IATACode                                
  ,@Website                                
    ,@PhoneNo                                
    ,@MobileNo                                
    ,@FaxNo                                
    ,@EmailID                                
    ,@PanNo                                
    ,@STRegNo                                
    ,@ChequeFavouring                                
,REPLACE(REPLACE(REPLACE(ISNULL(@Address, ''), CHAR(13), ''), CHAR(10), ' '), '  ', ' ')                                
    ,@CreateAdvanceAccount                                
    ,@CreditApplicable                                
    ,@CreditCurrencyCode                                
    ,@CreditAllowance                                
    ,@Threshold                                
    ,@CreditPeriod                        
    ,@OutStandingAmount                                
    ,@UnlimitedCredit                                
    ,@IsActive                                
    ,@IsOtherBooking                                
    ,'Insert'                                
    ,@OperationBy                                
    ,GETDATE()                                
    ,@IsCorporate                                
    ,@BankAccountID                                
    ,ISNULL(@RelatedEmployeeID, 0)                          
    ,ISNULL(@HasBranch, 0)                                
    ,ISNULL(@StateCodeID, 0)                                
    ,@IsInterBranch                                
    ,@IsSEZ                                
    ,@AddressExist                                
    ,@GSTRequired                                
    ,@AddressCountry                                
    ,@AddressState                                
    ,@AddressCity                                
    ,@isActiveSAP                                
    ,@TANDetails                                
    ,@PreviousCode                                
    ,@AgentClassification                                
    ,@Comments                                
    ,@IsAgentREFPO                                
    ,@BusinessHeadID                                
    ,@SalesHeadID                                
    ,@PostalCode                                
    ,@LegalEntity                                
    ,@LegalName                                
    ,@Virtualaccount                                
    ,@BeneficiaryName                                
    ,@AccountNumber                                
    ,@IFSCCode                                
    ,@SWIFTCode                                
    ,@MSMEUanNumber                                
    ,@IATACode                                
    ,@IATOCode                                
    ,@MSMEType                                
    ,@BranchName                                
    ,@BankName                                
    ,@TamSalesrep                                
    ,@GSTIN                                
    ,@PANVERIFICATION                                
    ,@GSTVERIFICATION                                
    ,@TANVERIFICATION                        
    ,@Contact1                                
    ,@Contact2                                
    ,@IsContact1Mobile                                
    ,@IsContact2Mobile                                
    ,@IsAgent                                
    ,@LeadID                  
 ,@TaxType                
                 
    )                                
                                
   SELECT @AgentID = @@IDENTITY                                
                                
   SELECT '200' AS returnCode                                
    ,'New record added successfully.' AS returnMessage                                
    ,@AgentID AS ID, @AgentCode AS AgentCode;                                
  END                     
 END                                
 ELSE IF @Action = 'I'                                
  AND @IsAgent = 0                                
 BEGIN                                
   IF EXISTS (                                
    SELECT 1                                
    FROM AgentMaster                                
    WHERE (LTRIM(RTRIM(UPPER(EmailID))) = LTRIM(RTRIM(UPPER(@EmailID))) and  PhoneNo = @PhoneNo)                            
    )                                   
  BEGIN                                
   SELECT '201' AS returnCode                                
    ,'This Agent already exists. Please check and try again.' AS returnMessage;                                
  END                                
  ELSE                                
   SET @LeadID = 'AL' + RIGHT('0000000' + CAST((                                
       SELECT ISNULL(AGENTLEAD, 0) + 1                                
       FROM tbl_Counter                                
       ) AS VARCHAR(8)), 8);                                
                                
  UPDATE tbl_Counter                                
  SET AGENTLEAD = CAST(RIGHT(@LeadID, 5) AS BIGINT)                                
   ,UpdationDate = GETDATE()                                
                                
  INSERT INTO AgentMaster (                                
   AccCode                                
   ,AgentCode                                
   ,AgentName                                
   ,CategoryID                                
   ,Miscellaneous                                
   ,GroupID                                
   ,MarketID                                
   ,City_IATACode                                
   ,Website                                
   ,PhoneNo                                
,MobileNo                                
   ,FaxNo                                
   ,EmailID                                
   ,PanNo                                
   ,STRegNo                                
   ,ChequeFavouring                                
   ,[Address]                                
   ,CreateAdvanceAccount                                
   ,CreditApplicable                                
   ,CreditCurrencyCode                                
   ,CreditAllowance                                
   ,Threshold                                
   ,CreditPeriod                                
   ,OutStandingAmount                                
   ,UnlimitedCredit                                
   ,IsActive              
   ,IsOtherBooking                                
   ,Operation                                
   ,OperationBy                                
   ,OperationOn                                
   ,IsCorporate                                
   ,BankAccountID                                
   ,RelatedEmployeeID                                
   ,HasBranch                                
   ,StateCodeID                                
   ,IsInterBranch                                
,IsSEZ                                
   ,AddressExist                                
   ,GSTRequired                                
   ,AddressCountry                                
   ,AddressState                                
   ,AddressCity                                
   ,isActiveSAP                                
   ,TANDetails                                
   ,PreviousCode                                
   ,AgentClassification                                
   ,Comments                                
   ,IsAgentREFPO                                
   ,BusinessHeadID                                
   ,SalesHeadID                                
   ,PostalCode                                
   ,LegalEntity                                
   ,LegalName                                
   ,Virtualaccount                                
   ,BeneficiaryName                                
   ,Accountnumber                                
   ,ifsccode                                
   ,swiftcode                                
   ,MSME_UAN_Number                                
   ,IATACode                                
   ,IATOCode                              
   ,MSMEType                                
   ,BranchName                                
   ,BankName                                
   ,TamSalesrep                                
   ,GSTIN                                
   ,PANVERIFICATION                                
   ,GSTVERIFICATION                                
   ,TANVERIFICATION                         
   ,Contact1                                
   ,contact2                                
   ,IsContact1Mobile                                
   ,IsContact2Mobile                                
   ,IsAgent                                
   ,LeadID                  
   ,TaxType                
   )                                
  VALUES (                                
   @AccCode                                
   ,@AgentCode                                
   ,REPLACE(REPLACE(REPLACE(ISNULL(@AgentName, ''), CHAR(13), ''), CHAR(10), ' '), '  ', ' ')                                
   ,@CategoryID                                
   ,@Miscellaneous                                
 ,@GroupID                                
   ,@MarketID                                
   ,@City_IATACode                                
   ,@Website                                
   ,@PhoneNo                                
   ,@MobileNo                         
   ,@FaxNo                                
   ,@EmailID                                
   ,@PanNo                                
   ,@STRegNo                                
   ,@ChequeFavouring                                
   ,REPLACE(REPLACE(REPLACE(ISNULL(@Address, ''), CHAR(13), ''), CHAR(10), ' '), '  ', ' ')                                
   ,@CreateAdvanceAccount                                
   ,@CreditApplicable                                
   ,@CreditCurrencyCode                                
   ,@CreditAllowance                                
   ,@Threshold                                
   ,@CreditPeriod              
   ,@OutStandingAmount                                
   ,@UnlimitedCredit                                
   ,@IsActive                                
   ,@IsOtherBooking                                
   ,'Insert'                                
   ,@OperationBy                                
   ,GETDATE()                                
   ,@IsCorporate                                
   ,@BankAccountID                                
   ,ISNULL(@RelatedEmployeeID, 0)                                
   ,ISNULL(@HasBranch, 0)                                
   ,ISNULL(@StateCodeID, 0)                                
   ,@IsInterBranch                                
   ,@IsSEZ                                
   ,@AddressExist                                
   ,@GSTRequired                                
   ,@AddressCountry                                
   ,@AddressState                                
   ,@AddressCity                                
   ,@isActiveSAP                                
   ,@TANDetails                                
   ,@PreviousCode                                
   ,@AgentClassification                                
   ,@Comments                                
   ,@IsAgentREFPO                                
   ,@BusinessHeadID                                
   ,@SalesHeadID                                
   ,@PostalCode                                
   ,@LegalEntity                                
   ,@LegalName                                
   ,@Virtualaccount                                
   ,@BeneficiaryName                                
   ,@AccountNumber                                
   ,@IFSCCode                                
   ,@SWIFTCode                                
   ,@MSMEUanNumber                                
 ,@IATACode                                
   ,@IATOCode                                
   ,@MSMEType                                
   ,@BranchName                                
   ,@BankName                                
   ,@TamSalesrep                                
   ,@GSTIN                                
   ,@PANVERIFICATION                                
   ,@GSTVERIFICATION                                
   ,@TANVERIFICATION                                
   ,@Contact1                                
   ,@Contact2                                
   ,@IsContact1Mobile     
   ,@IsContact2Mobile                                
   ,@IsAgent                                
   ,@LeadID                      
   ,@TaxType                
   )                                
                                
  SELECT @AgentID = @@IDENTITY                                
                                
  SELECT '200' AS returnCode                                
   ,'New record added successfully.' AS returnMessage                                
   ,@AgentID AS ID,@AgentCode AS AgentCode;                                
 END                                
 ELSE IF @Action = 'U'                                
 BEGIN                                
 IF NOT EXISTS( SELECT 1                       
    FROM AgentMaster                                
    WHERE ( upper(AgentCode) like '%DR%') AND AGENTID = @AGENTID)                              
  BEGIN                                
   SET @AgentCode = 'DR' + RIGHT('0000000' + CAST((                                
       SELECT ISNULL(AGENTCODE, 0) + 1                                
       FROM tbl_Counter                                
       ) AS VARCHAR(8)), 8);                                
   UPDATE tbl_Counter                                
   SET AGENTCODE = CAST(RIGHT(@AgentCode, 7) AS BIGINT)                                
    ,UpdationDate = GETDATE();                                
  END                                
                                 
  BEGIN TRANSACTION                                
                                
   IF EXISTS (                                
    SELECT 1                                
    FROM AgentMaster                                
    WHERE ((LTRIM(RTRIM(UPPER(EmailID))) = LTRIM(RTRIM(UPPER(@EmailID))) and  PhoneNo = @PhoneNo)  AND AgentID <> @AgentID )                    
 GROUP BY AgentID                    
HAVING COUNT(*) > 1                    
    )                                 
  BEGIN                              
   SELECT '201' AS returnCode                                
    ,'This Agent already exists. Please check and try again.' AS returnMessage;                                
  END                                
  ELSE IF (@Miscellaneous = 1)                                
  BEGIN                                
   IF EXISTS (                                
     SELECT *                                
     FROM AgentMaster                                
     WHERE Miscellaneous = 1                                
      AND MarketID = @MarketID                                
      AND AgentID <> @AgentID                                
     )                                
   BEGIN                                
    SELECT '201' AS returnCode                                
     ,'MarketID already exists. Please check and try again.' AS returnMessage;                                
   END                                
   ELSE                                
   BEGIN                                
    SET DEADLOCK_PRIORITY NORMAL;                                
                    
    UPDATE AgentMaster                                
    SET AgentName = REPLACE(REPLACE(REPLACE(ISNULL(@AgentName, ''), CHAR(13), ''), CHAR(10), ' '), '  ', ' ')                                
     ,CategoryID = @CategoryID                                
     ,                                
     --PRCategory    =@PRCategory,                                                                             
     Miscellaneous = @Miscellaneous                                
     ,GroupID = @GroupID                                
     ,MarketID = @MarketID                                
     ,City_IATACode = @City_IATACode                                
     ,Website = @Website                                
     ,PhoneNo = @PhoneNo                                
     ,MobileNo = @MobileNo                                
     ,FaxNo = @FaxNo                                
     ,EmailID = @EmailID                                
     ,PanNo = @PanNo                                
      ,STRegNo = @STRegNo                                                                                              
     -- ,ChequeFavouring = @ChequeFavouring                                                                
     ,[Address] = REPLACE(REPLACE(REPLACE(ISNULL(RTRIM(LTRIM(@Address)), ''), CHAR(13), ''), CHAR(10), ' '), '  ', ' ')                                
     ,CreateAdvanceAccount = @CreateAdvanceAccount                                
     ,CreditApplicable = @CreditApplicable                                
     ,CreditCurrencyCode = @CreditCurrencyCode                                
     ,CreditAllowance = @CreditAllowance                                
     ,Threshold = @Threshold                                
     ,CreditPeriod = @CreditPeriod                                
     ,OutStandingAmount = @OutStandingAmount                                
     ,UnlimitedCredit = @UnlimitedCredit                                
     ,IsActive = @IsActive        
     ,IsOtherBooking = @IsOtherBooking                                
     ,IsCorporate = @IsCorporate                                
     ,Operation = 'UPDATE'                                
     ,OperationBy = @OperationBy                                
     ,OperationOn = GETDATE()                                
     ,BankAccountID = @BankAccountID                     
     ,RelatedEmployeeID = @RelatedEmployeeID                                
     ,HasBranch = @HasBranch                                
     ,StateCodeID = @StateCodeID                                
     ,IsInterBranch = @IsInterBranch                                
     ,IsSEZ = @IsSEZ                                
     ,AddressExist = @AddressExist                                
     ,GSTRequired = @GSTRequired                                
     ,AddressCountry = @AddressCountry                                
     ,AddressState = @AddressState                                
     ,AddressCity = @AddressCity                                
     ,isActiveSAP = @isActiveSAP                                
     ,TANDetails = @TANDetails         
     ,PreviousCode = @PreviousCode                                
     ,AgentClassification = @AgentClassification                              
     ,Comments = @Comments                                
     ,IsAgentREFPO = @IsAgentREFPO                                
     ,BusinessHeadID = @BusinessHeadID                                
     ,SalesHeadID = @SalesHeadID                                
     ,PostalCode = @PostalCode                                
     ,LegalEntity = @LegalEntity                                
     ,LegalName = @LegalName                                
     ,Virtualaccount = @Virtualaccount                                
     ,BeneficiaryName = @BeneficiaryName                                
     ,Accountnumber = @AccountNumber                                
     ,ifsccode = @IFSCCode                                
     ,swiftcode = @SWIFTCode                                
     ,MSME_UAN_Number = @MSMEUanNumber                                
     ,IATACode = @IATACode                                
     ,IATOCode = @IATOCode                                
     ,MSMEType = @MSMEType                                
     ,BranchName = @BranchName         
     ,TamSalesrep = @TamSalesrep                                
     ,TamSalesName = @TamSalesName                                
     ,GSTIN = @GSTIN                                
     ,BankName = @BankName                                
     ,PANVERIFICATION = @PANVERIFICATION                                
     ,GSTVERIFICATION = @GSTVERIFICATION                                
     ,TANVERIFICATION = @TANVERIFICATION                                
     ,Contact1 = @Contact1                                
     ,Contact2 = @Contact2                                
     ,IsContact1Mobile = @IsContact1Mobile   
     ,IsContact2Mobile = @IsContact2Mobile                                
     ,AgentCode = @AgentCode                
  ,TaxType = ISNULL(@TaxType,'')                
    WHERE AgentID = @AgentID                                
                  
    SELECT '200' AS returnCode                                
     ,'Record updated successfully.' AS returnMessage                                
     ,@AgentID AS ID;                                
     --EXEC usp_InsertAgentMaster_Audit @AgentID                                                                                              
     -- ,@CreditApplicable                                       
     -- ,@CreditCurrencyCode                                                                                              
     -- ,@CreditAllowance                                                                                              
     -- ,@Threshold                                                                                              
     -- ,@CreditPeriod                                                        
     -- ,@OutStandingAmount                                                            
     -- ,@UnlimitedCredit                                                                                              
     -- ,'UPDATE'                                                                                              
     -- ,@OperationBy                                                                                              
     -- ,@IsActive                                                                                              
   END                                
  END                                
  ELSE                                
  BEGIN                                
   UPDATE AgentMaster                                
   SET AgentName = REPLACE(REPLACE(REPLACE(ISNULL(@AgentName, ''), CHAR(13), ''), CHAR(10), ' '), '  ', ' ')                           
    ,CategoryID = @CategoryID                                
    ,                                
    --PRCategory    =@PRCategory,                                                                                      
    Miscellaneous = @Miscellaneous                                
    ,GroupID = @GroupID                                
    ,MarketID = @MarketID          
    ,City_IATACode = @City_IATACode                                
    ,Website = @Website                                
    ,PhoneNo = @PhoneNo                                
    ,MobileNo = @MobileNo                                
    ,FaxNo = @FaxNo                                
    ,EmailID = @EmailID                                
    ,PanNo = @PanNo                                
    ,STRegNo = @STRegNo                                                                                              
    --,ChequeFavouring = @ChequeFavouring                                                                         
    ,[Address] = REPLACE(REPLACE(REPLACE(ISNULL(RTRIM(LTRIM(@Address)), ''), CHAR(13), ''), CHAR(10), ' '), '  ', ' ')                                
    ,CreateAdvanceAccount = @CreateAdvanceAccount                                
    ,CreditApplicable = @CreditApplicable                                
    ,CreditCurrencyCode = @CreditCurrencyCode                                
    ,CreditAllowance = @CreditAllowance                                
    ,Threshold = @Threshold                                
    ,CreditPeriod = @CreditPeriod                       
    ,OutStandingAmount = @OutStandingAmount                                
    ,UnlimitedCredit = @UnlimitedCredit                                
    ,IsActive = @IsActive                                
    ,IsOtherBooking = @IsOtherBooking                                
    ,IsCorporate = @IsCorporate                                
    ,Operation = 'UPDATE'                                
    ,OperationBy = @OperationBy                                
    ,OperationOn = GETDATE()                                
    ,BankAccountID = @BankAccountID                                
    ,RelatedEmployeeID = @RelatedEmployeeID                                
    ,HasBranch = @HasBranch                                
    ,StateCodeID = @StateCodeID                                
    ,IsInterBranch = @IsInterBranch                                
    ,IsSEZ = @IsSEZ                                
    ,AddressExist = @AddressExist                                
    ,GSTRequired = @GSTRequired                                
    ,AddressCountry = @AddressCountry                                
    ,AddressState = @AddressState                                
    ,AddressCity = @AddressCity                                
    ,isActiveSAP = @isActiveSAP                                
    ,TANDetails = @TANDetails                                
    ,PreviousCode = @PreviousCode                                
    ,AgentClassification = @AgentClassification                                
    ,Comments = @Comments                                
    ,IsAgentREFPO = @IsAgentREFPO                                
    ,BusinessHeadID = @BusinessHeadID                                
    ,SalesHeadID = @SalesHeadID                                
    ,PostalCode = @PostalCode                                
    ,LegalEntity = @LegalEntity                                
   ,LegalName = @LegalName                                
    ,Virtualaccount = @Virtualaccount                                
    ,BeneficiaryName = @BeneficiaryName                                
    ,Accountnumber = @AccountNumber                                
    ,ifsccode = @IFSCCode                                
    ,swiftcode = @SWIFTCode                                
    ,MSME_UAN_Number = @MSMEUanNumber                                
    ,IATACode = @IATACode                                
    ,IATOCode = @IATACode                                
    ,MSMEType = @MSMEType                                
    ,BranchName = @BranchName                                
    ,TamSalesrep = @TamSalesrep                                
    ,TamSalesName = @TamSalesName                                
    ,GSTIN = @GSTIN                                
    ,BankName = @BankName                                
    ,PANVERIFICATION = @PANVERIFICATION                                
    ,GSTVERIFICATION = @GSTVERIFICATION                                
    ,TANVERIFICATION = @TANVERIFICATION                                
    ,Contact1 = @Contact1                                
    ,Contact2 = @Contact2                                
    ,IsContact1Mobile = @IsContact1Mobile                                
    ,IsContact2Mobile = @IsContact2Mobile                                
    ,AgentCode = @AgentCode                   
 ,TaxType = ISNULL(@TaxType,'')                
   WHERE AgentID = @AgentID                                
                                
   SELECT '200' AS returnCode                                
    ,'Record updated successfully.' AS returnMessage                                
    ,@AgentID AS ID;                                
    --EXEC usp_InsertAgentMaster_Audit @AgentID                                                 
    -- ,@CreditApplicable                                                    
    -- ,@CreditCurrencyCode                                                                                             
    -- ,@CreditAllowance                                                                                              
    -- ,@Threshold                                                                                         
    -- ,@CreditPeriod                                                                                              
    -- ,@OutStandingAmount                                                                                              
    -- ,@UnlimitedCredit             
    -- ,'UPDATE'                                                                        
    -- ,@OperationBy                                                               
    -- ,@IsActive                                                                                    
  END                                
                                
  COMMIT TRANSACTION                                
 END                                
 ELSE IF @Action = 'S'                                
 BEGIN                                
  SELECT DISTINCT TOP 500 AM.AgentID                                
   ,(                                
    SELECT TOP 1 ID                                
    FROM UploadImage                                
    WHERE ParentPageType = 7                                
     AND ParentID = AM.AgentID                                
    ) 'ImageID'                                
   ,AccCode                                
   ,AgentCode                                
   ,LEADID                                
   ,ISAGENT                                
   ,AgentName                                
   ,AM.CategoryID                                
   --,ACM.CategoryCode                                                                                              
   ,Miscellaneous                                
  ,GroupID                                
   ,AgentGroupName                                
   ,AM.MarketID                                
   ,S.Country_IATACode                                
   ,CN.Name 'CountryName'                                
   ,City_IATACode                  
   ,C.Name 'CityName'                                
   ,Website                                
   ,PhoneNo                                
   ,AM.MobileNo                                
   ,FaxNo                                
   ,EmailID                                
   ,AM.PanNo                                
   ,STRegNo AS SalesTaxRegNumber                               
   ,ChequeFavouring                                
   ,AM.Address                                
   ,CreateAdvanceAccount                                
   ,AM.CreditApplicable                 
   ,AM.CreditCurrencyCode                                
   ,AM.CreditAllowance                                
   ,AM.Threshold                                
   ,AM.CreditPeriod                                
   ,AM.OutStandingAmount                                
   ,AM.UnlimitedCredit                                
   ,AM.IsActive                                
   ,AM.Operation                                
   ,AM.OperationBy                                
   ,AM.OperationOn                                
   ,M.Name AS Market --,                                                                                                                                      
   --,(                                            
   -- SELECT CONVERT(VARCHAR(20), AA.OperationOn, 13)                                                                                              
   -- FROM AgentMaster_Audit AA                                                                       
   -- WHERE AA.AgentID = AM.AgentID                                                                                              
   --  AND AA.Operation = 'INSERT'                                                   
   -- ) AS 'OperationOn1'                                                                                       
   --,CASE                                                                                               
   -- WHEN ISNULL(AM.CreditApplicable, 0) = 1                                                                                              
   --  THEN 'Yes'                                                                      
   -- ELSE 'No'                                                                                              
   -- END AS ISCreditApplicable                                 
   --,CASE                                                                                               
   -- WHEN ISNULL(IsCorporate, 0) = 1                                                                                              
   --  THEN 'Yes'                                                         
   -- ELSE 'No'                                                          
   -- END AS IsCorporate --added by sanket @ 31/03/2015                                                                              
   ,ABM.BankAccountName                                
  -- ,EM.EmpName AS TamSalesName                                
   --,EM.EmpID AS TamSalesRep                                                                                        
   --,TS.EmpName AS   TamSalesrep                                               
   ,AM.HasBranch AS IsBranch                                
   ,AM.IsSEZ AS IsSEZ                     
   ,(                                
    SELECT TOP 1 State_Code                                
    FROM State_Code_Master                                
    WHERE ID = AM.StateCodeID                                
    ) AS StateCode                                
   ,S.Name AS StateName                                
   ,AM.AddressExist                                
   ,AM.GSTRequired                                
   ,AM.AddressCountry                                
   ,AM.AddressState             
   ,AM.AddressCity                                
   ,AM.isActiveSAP                                
   ,AM.TANDetails                                
   ,AM.PreviousCode                                
   ,AM.AgentClassification                                
   ,AM.Comments                                
   ,AM.IsAgentREFPO                                
   ,'1000' AS CompanyCode                                
   ,AM.PostalCode                                
   ,LE.LegalEntTypeID AS 'LegalEntity'                                
   ,AM.LegalName                            
   ,AM.BeneficiaryName                                
   ,BranchName                                
   ,AM.Accountnumber                                
   ,BankAccountID                                
   ,BankName                                
   ,virtualaccount                                
   ,GSTIN                 ,AM.StateCodeID                                
   ,SWIFTCode                                
   ,MSME_UAN_Number AS MSMEUanNumber                                
   ,AM.IATACode                                
   ,IATOCode                                
   ,MSMEType                                
   ,IFSCCode                                
   ,PreviousCode                                
   ,IsInterBranch                                
   ,AG.AgentGroupName                                
   ,Contact2                                
   ,Contact1                                
   ,IsContact1Mobile                                
   ,IsContact2Mobile                                
   ,AM.TamSalesrep                   
   ,TamSalesName                  
   ,TaxType                   
                   
  FROM AgentMaster AM                                
  LEFT JOIN Market M ON MarketID = ID                                
  --INNER JOIN AgentCategoryMaster ACM ON AM.CategoryID = ACM.CategoryID                                                                              
  INNER JOIN City C ON AM.City_IATACode = C.IATACode                                
  --INNER JOIN AgentProfile AP ON AP.City_ID = C.ID                                          
  INNER JOIN [State] S ON S.State_ID = C.State_IATACode                                
  INNER JOIN Country CN ON CN.IATACode = S.Country_IATACode                                
  LEFT JOIN AccountsBankMaster ABM ON ABM.AccountBankMasterID = AM.BankAccountID --added by sanket @ 31/03/2015                                                                                       
  LEFT JOIN EmployeeMaster EM ON EM.EmpID = AM.RelatedEmployeeID                                
  LEFT JOIN EmployeeMaster TS ON TS.EmpID = AM.TamSalesrep                                
  LEFT JOIN State_Code_Master SC ON SC.ID = AM.StateCodeID                                
  LEFT JOIN LegalEntityType_Master LE ON AM.LegalEntity = LE.LegalEntTypeID                                
  LEFT JOIN AgentGroup AG ON AG.AgentGroupID = AM.GroupID                      
  LEFT JOIN Booking.tbl_Booking bb on bb.AgentID=AM.AgentID     
  LEFT JOIN UploadImage UI on UI.ParentID = AM.AgentID
 -- INNER JOIN SAPCompCode SCC WITH(NOLOCK) ON  SCC.ParentID  = AM.AgentID AND TypeID=3 AND SCC.IsActive=1          
          
                  
  WHERE               
  ((@UsedInBooking=1 and bb.ID is not null) Or (@UsedInBooking=0)) and                
  (                                
    @AgentID IS NULL                                
    OR @AgentID = 0                                
   OR AM.AgentID = @AgentID                                
    )                                
   AND (                                
    @AgentName IS NULL                                
    OR @AgentName = ''                                
    OR EXISTS (                                
     SELECT 1                                
     FROM STRING_SPLIT(@AgentName, '|') s                                
     WHERE AgentName LIKE s.value + '%'                                
     )                                
    )                                
   AND (                                
    @LegalName IS NULL                                
    OR @LegalName = ''                   
    OR EXISTS (                                
     SELECT 1                                
     FROM STRING_SPLIT(@LegalName, ',') s                                
     WHERE LegalName LIKE s.value + '%'                                
     )                                
    )                                
   AND (                    
    @AgentCode IS NULL                                
    OR @AgentCode = ''                                
    OR EXISTS (                 
     SELECT 1                                
     FROM STRING_SPLIT(@AgentCode, ',') s                                
     WHERE AgentCode LIKE s.value + '%'                                
     )                                
    )                                
   AND (                                
    @Address IS NULL                                
    OR @Address = ''                                
    OR EXISTS (                                
     SELECT 1                                
     FROM STRING_SPLIT(@Address, ',') s              
     WHERE AM.Address LIKE s.value + '%'                                
     )                                
    )                                
   AND (                               
    @AddressCountry IS NULL                                
    OR @AddressCountry = ''                                
    OR EXISTS (                                
     SELECT 1                                
     FROM STRING_SPLIT(@AddressCountry, ',') s                                
     WHERE CN.Name LIKE s.value + '%'                                
     )                                
    )                                
   AND (                                
    @AddressState IS NULL                                
  OR @AddressState = ''                                
    OR EXISTS (                                
     SELECT 1                                
     FROM STRING_SPLIT(@AddressState, ',') p                                
     WHERE s.Name LIKE '%' + p.value + '%'                                
     )                                
    )                                
   AND (                                
    @AddressCity IS NULL                                
    OR @AddressCity = ''                                
    OR EXISTS (                                
     SELECT 1                                
     FROM STRING_SPLIT(@AddressCity, ',') s                                
     WHERE C.Name LIKE '%' + s.value + '%'                                
     )                                
    )                                
   --AND (@CreditApplicable IS NULL OR CreditApplicable = CASE WHEN @CreditApplicable = 1 THEN 1 ELSE 0 END)                                                                        
   AND (                                
@CreditApplicable IS NULL                                
    OR @CreditApplicable = ''                                
    OR AM.CreditApplicable = @CreditApplicable                                
    )                                
   AND (                                
    @PanNo IS NULL                                
    OR @PanNo = ''                                
    OR EXISTS (                                
     SELECT 1                                
 FROM STRING_SPLIT(@PanNo, ',') s                                
     WHERE AM.PanNo LIKE s.value + '%'                                
     )                                
    )                                
   AND (                                
    @TANDetails IS NULL                                
  OR @TANDetails = ''                                
    OR EXISTS (                                
     SELECT 1                                
     FROM STRING_SPLIT(@TANDetails, ',') s                                
     WHERE TANDetails LIKE s.value + '%'                                
     )                                
    )                                
   AND (                                
    @GroupName IS NULL                                
    OR @GroupName = ''                                
    OR EXISTS (                                
SELECT 1                                
     FROM STRING_SPLIT(@GroupName, ',') s                                
     WHERE AgentGroupName LIKE s.value + '%'                                
     )                                
    )                                
AND (                  
    @TamSalesName IS NULL                                
    OR @TamSalesName = ''                                
    OR EXISTS (                                
        SELECT 1                                
        FROM STRING_SPLIT(@TamSalesName, ',') s                                
        WHERE EM.EmpName LIKE s.value + '%'  -- Corrected line                  
    )                                
)                  
AND (                  
    @PreviousCode IS NULL                                
    OR @PreviousCode = ''                                
    OR EXISTS (                                
     SELECT 1                                
     FROM STRING_SPLIT(@PreviousCode, ',') s                                
     WHERE AM.PreviousCode LIKE s.value + '%'  -- Filter PreviousCode by prefix                  
     )                                
    )                  
  AND(@IsActive  IS NULL OR @IsActive  = 0 OR AM.IsActive=@IsActive)                                    
  --AND (@IsActive  IS NULL OR AM.IsActive  = CASE WHEN @IsActive  = 1 THEN 1 ELSE 0 END)                           
  --OR                                                                            
  --AM.IsActive = 1                    
  AND (ISNULL(@IATACode,'')='' OR AM.City_IATACode=@IATACode)                
  ORDER BY AM.AgentID DESC                                
   --  SELECT '200' as returnCode , 'Data Found.' as returnMessage, @AgentID as ID;                                                                                  
 END                                
                                                  
              
   ELSE IF @Action = 'ex'                      
   begin                      
     SELECT                 
   DISTINCT                 
   --TOP 500                       
  AM.AgentID,                                
  (                                
   SELECT TOP 1 ID                                
   FROM UploadImage          
   WHERE ParentPageType = 7                                
    AND ParentID = AM.AgentID                                
  ) 'ImageID'                        
  ,AccCode                                
    ,AgentCode                                
    ,LEADID                                
   --,ISAGENT                      
    ,                         
    CASE                       
   WHEN ISAGENT = 1 THEN 'Yes'                      
   WHEN ISAGENT = 0 THEN 'No'                      
  END AS HasAgent                      
    ,AgentName                                
  ,AM.CategoryID                                   
    --,ACM.CategoryCode                                                                                              
     ,Miscellaneous                                
  ,GroupID                              
    ,AgentGroupName                     
   -- ,MarketID                 
   ,AM.MarketID                     
    ,S.Country_IATACode                             
    ,CN.Name 'CountryName'                                
    ,City_IATACode                                
    ,C.Name 'CityName'                                
    ,Website                                
    ,PhoneNo                                
    ,AM.MobileNo                                
    ,FaxNo                                
    ,EmailID                 
    --,PanNo                  
    ,AM.PanNo                 
                                  
    --,STRegNo                
    ,STRegNo AS SalesTaxRegNumber                     
   ,ChequeFavouring                              
    ,AM.Address                                
    ,CreateAdvanceAccount                      
    , CASE            
   WHEN CreateAdvanceAccount = 1 THEN 'Yes'                      
   WHEN CreateAdvanceAccount = 0 THEN 'No'                      
  END AS IsCreateAdvanceAccount                      
  --  ,AM.CreditApplicable                          
    ,CASE                       
   WHEN AM.CreditApplicable = 1 THEN 'Yes'                      
   WHEN AM.CreditApplicable = 0 THEN 'No'                      
  END AS IsCreditApplicable                      
    ,AM.CreditCurrencyCode                                
    ,AM.CreditAllowance                                
    ,AM.Threshold                                
    ,AM.CreditPeriod                                
    ,AM.OutStandingAmount                                
    --,AM.UnlimitedCredit                            
    , CASE                       
   WHEN AM.UnlimitedCredit = 1 THEN 'Yes'                      
   WHEN AM.UnlimitedCredit = 0 THEN 'No'                      
  END AS IsUnlimitedCredit                      
    --,AM.IsActive                                
    ,CASE                       
   WHEN AM.IsActive = 1 THEN 'True'                      
   WHEN AM.IsActive = 0 THEN 'False'                      
  END AS Active                      
    --,AM.Operation                                
    --,AM.OperationBy                                
    --,AM.OperationOn                                
    ,M.Name AS Market --,                                                               
    ,ABM.BankAccountName                                
    ,EM.EmpName AS TamSalesName                                                  
    --,AM.HasBranch AS IsBranch                        
    ,CASE                       
   WHEN AM.HasBranch = 1 THEN 'Yes'                      
   WHEN AM.HasBranch = 0 THEN 'No'                      
  END AS Branch                      
    --,AM.IsSEZ AS IsSEZ                          
    ,CASE                       
   WHEN AM.IsSEZ = 1 THEN 'Yes'                      
   WHEN AM.IsSEZ = 0 THEN 'No'                      
  END AS HasSEZ                      
    ,(                                
  SELECT TOP 1 State_Code                                
  FROM State_Code_Master                                
  WHERE ID = AM.StateCodeID                                
  ) AS StateCode          
 ,S.Name AS StateName                                
    ,AM.AddressExist                                
    ,AM.GSTRequired                                
    --,AM.AddressCountry                                
    ,AM.AddressState                                
   -- ,AM.AddressCity                                
   -- ,AM.isActiveSAP                        
    ,CASE                       
   WHEN AM.isActiveSAP = 1 THEN 'Yes'                      
   WHEN AM.isActiveSAP = 0 THEN 'No'                      
  END AS HasActiveSAP                      
    ,AM.TANDetails                                
    ,AM.PreviousCode                                
    ,AM.AgentClassification                                
    ,AM.Comments                                
    --,AM.IsAgentREFPO                        
    ,CASE                       
   WHEN AM.IsAgentREFPO = 1 THEN 'Yes'                      
   WHEN AM.IsAgentREFPO = 0 THEN 'No'                      
  END AS HasIsAgentREFPO                      
   -- ,'1000' AS CompanyCode                                
    ,AM.PostalCode                                
   -- ,LE.LegalEntTypeID AS 'LegalEntity'                                
    ,AM.LegalName                                
    ,AM.BeneficiaryName                                
    ,BranchName                                
    ,AM.Accountnumber                                
   -- ,BankAccountID                                
    ,BankName                         
    --,virtualaccount                       
    ,CASE                       
   WHEN virtualaccount = 1 THEN 'Yes'                      
   WHEN virtualaccount = 0 THEN 'No'                      
  END AS IsVirtualaccount                      
    ,GSTIN                                
   -- ,AM.StateCodeID                                
    ,SWIFTCode                                
    ,MSME_UAN_Number AS MSMEUanNumber                                
    ,AM.IATACode                                
    ,IATOCode                                
    ,MSMEType                                
,IFSCCode                                
    ,PreviousCode                                
    --,IsInterBranch                       
 ,CASE                       
   WHEN IsInterBranch = 1 THEN 'Yes'                      
   WHEN IsInterBranch = 0 THEN 'No'                      
  END AS HasInterBranch                      
    ,AG.AgentGroupName                                
    ,Contact2                                
    ,Contact1                                
   -- ,IsContact1Mobile                                
    --,IsContact2Mobile                                
   -- ,TamSalesrep                                
    ,TamSalesName                     
    ,TaxType                   
  FROM AgentMaster AM   WITH(NOLOCK)                             
  LEFT JOIN Market M   WITH(NOLOCK)  ON MarketID = ID                                
  --INNER JOIN AgentCategoryMaster ACM ON AM.CategoryID = ACM.CategoryID                                                                              
  LEFT JOIN City C   WITH(NOLOCK)  ON AM.City_IATACode = C.IATACode                                
  --INNER JOIN AgentProfile AP ON AP.City_ID = C.ID                                          
  LEFT JOIN [State] S   WITH(NOLOCK)  ON S.State_ID = C.State_IATACode                                
  LEFT JOIN Country CN   WITH(NOLOCK)  ON CN.IATACode = S.Country_IATACode                                
  LEFT JOIN AccountsBankMaster ABM   WITH(NOLOCK)  ON ABM.AccountBankMasterID = AM.BankAccountID --added by sanket @ 31/03/2015                                                                                       
  LEFT JOIN EmployeeMaster EM   WITH(NOLOCK)  ON EM.EmpID = AM.RelatedEmployeeID                                
  LEFT JOIN EmployeeMaster TS   WITH(NOLOCK)  ON TS.EmpID = AM.TamSalesrep                                
  LEFT JOIN State_Code_Master SC   WITH(NOLOCK)  ON SC.ID = AM.StateCodeID     
  LEFT JOIN LegalEntityType_Master LE   WITH(NOLOCK)  ON AM.LegalEntity = LE.LegalEntTypeID                                
  LEFT JOIN AgentGroup AG   WITH(NOLOCK)  ON AG.AgentGroupID = AM.GroupID                       
   end                    
                   
 ELSE IF @Action = 'SA'                    
  BEGIN                    
   SELECT @TotalRecordCount=                
    (                
     SELECT COUNT(*) FROM                
      (                
       SELECT                 
        DISTINCT                  
        AM.AgentID                                
        ,                
        (                                
         SELECT TOP 1 ID                                
         FROM UploadImage                                
         WHERE ParentPageType = 7                                
          AND ParentID = AM.AgentID                                
        ) 'ImageID'                                
        ,AccCode                                
        ,AgentCode                                
        ,LEADID                                
        ,ISAGENT                                
        ,AgentName                                
        ,AM.CategoryID                                
        --,ACM.CategoryCode                                                                                              
        ,Miscellaneous                                
        ,GroupID                                
        --,AgentGroupName                                
        ,AM.MarketID                                
        ,S.Country_IATACode                                
        ,CN.Name 'CountryName'                                
        ,City_IATACode                                
        ,C.Name 'CityName'                                
        ,Website                                
        ,PhoneNo                                
        ,AM.MobileNo                                
        ,FaxNo                                
        ,EmailID                                
        ,AM.PanNo                                
        ,STRegNo AS SalesTaxRegNumber                               
        ,ChequeFavouring              
     ,AM.Address                                
        ,CreateAdvanceAccount                                
        ,AM.CreditApplicable                                
        ,AM.CreditCurrencyCode                                
        ,AM.CreditAllowance                                
        ,AM.Threshold                                
        ,AM.CreditPeriod                                
        ,AM.OutStandingAmount                                
        ,AM.UnlimitedCredit                                
        ,AM.IsActive                                
        ,AM.Operation                                
        ,AM.OperationBy                                
        ,AM.OperationOn                                
        ,M.Name AS Market --,                                                                                                                                      
        --,(                                                     
        -- SELECT CONVERT(VARCHAR(20), AA.OperationOn, 13)                                                                                              
        -- FROM AgentMaster_Audit AA                                                                       
        -- WHERE AA.AgentID = AM.AgentID                                                                                              
        --  AND AA.Operation = 'INSERT'                                                   
        -- ) AS 'OperationOn1'                                                                                       
        --,CASE                                                                                               
        -- WHEN ISNULL(AM.CreditApplicable, 0) = 1                   
        --  THEN 'Yes'                                                                      
        -- ELSE 'No'                                                                                              
        -- END AS ISCreditApplicable                                                                                              
        --,CASE                                                                                               
        -- WHEN ISNULL(IsCorporate, 0) = 1                                                                                       
        --  THEN 'Yes'                                                                                              
        -- ELSE 'No'                                                          
        -- END AS IsCorporate --added by sanket @ 31/03/2015                                                                              
        ,ABM.BankAccountName                                
        -- ,EM.EmpName AS TamSalesName                                
        --,EM.EmpID AS TamSalesRep                                                                                        
        --,TS.EmpName AS   TamSalesrep                                               
        ,AM.HasBranch AS IsBranch                                
        ,AM.IsSEZ AS IsSEZ                                
        ,(                                
        SELECT TOP 1 State_Code                                
        FROM State_Code_Master                                
        WHERE ID = AM.StateCodeID                                
        ) AS StateCode                                
        ,S.Name AS StateName                                
        ,AM.AddressExist                                
        ,AM.GSTRequired                                
        ,AM.AddressCountry                                
        ,AM.AddressState                                
        ,AM.AddressCity                                
        ,AM.isActiveSAP                                
        ,AM.TANDetails                                
        --,AM.PreviousCode                                
        ,AM.AgentClassification                                
        ,AM.Comments                                
      ,AM.IsAgentREFPO                                
        ,'1000' AS CompanyCode                                
        ,AM.PostalCode                                
        ,LE.LegalEntTypeID AS 'LegalEntity'                                
        ,AM.LegalName                                
        ,AM.BeneficiaryName                                
 ,BranchName                                
        ,AM.Accountnumber                                
        ,BankAccountID                                
        ,BankName                                
        ,virtualaccount                                
        ,GSTIN                 ,AM.StateCodeID                                
        ,SWIFTCode                                
        ,MSME_UAN_Number AS MSMEUanNumber                                
        ,AM.IATACode                                
        ,IATOCode                                
        ,MSMEType                                
        ,IFSCCode                                
        ,PreviousCode                                
        ,IsInterBranch                                
        ,AG.AgentGroupName                                
        ,Contact2                                
        ,Contact1                                
        ,IsContact1Mobile                                
        ,IsContact2Mobile                                
        ,AM.TamSalesrep                                
        ,TamSalesName                  
        ,TaxType                   
       FROM                 
        AgentMaster AM                                
        LEFT JOIN Market M ON MarketID = ID                                
        --INNER JOIN AgentCategoryMaster ACM ON AM.CategoryID = ACM.CategoryID                                                                              
        LEFT JOIN City C ON AM.City_IATACode = C.IATACode                                
        --INNER JOIN AgentProfile AP ON AP.City_ID = C.ID                                          
        LEFT JOIN [State] S ON S.State_ID = C.State_IATACode                                
        LEFT JOIN Country CN ON CN.IATACode = S.Country_IATACode                                
        LEFT JOIN AccountsBankMaster ABM ON ABM.AccountBankMasterID = AM.BankAccountID --added by sanket @ 31/03/2015                                                                                       
        LEFT JOIN EmployeeMaster EM ON EM.EmpID = AM.RelatedEmployeeID                                
        LEFT JOIN EmployeeMaster TS ON TS.EmpID = AM.TamSalesrep                                
        LEFT JOIN State_Code_Master SC ON SC.ID = AM.StateCodeID                                
        LEFT JOIN LegalEntityType_Master LE ON AM.LegalEntity = LE.LegalEntTypeID                                
        LEFT JOIN AgentGroup AG ON AG.AgentGroupID = AM.GroupID                      
        LEFT JOIN Booking.tbl_Booking bb on bb.AgentID=AM.AgentID                
       WHERE                
        ((@UsedInBooking=1 and bb.ID is not null) Or (@UsedInBooking=0)) and                
        (                                
        @AgentID IS NULL                                
        OR @AgentID = 0                                
        OR AM.AgentID = @AgentID                                
        )                                
 AND (                                
        @AgentName IS NULL                                
        OR @AgentName = ''                                
        OR EXISTS (                                
         SELECT 1                                
         FROM STRING_SPLIT(@AgentName, '|') s                                
         WHERE AgentName LIKE s.value + '%'                                
         )                                
        )                                
        AND (                                
        @LegalName IS NULL                                
        OR @LegalName = ''                                
        OR EXISTS (                                
         SELECT 1                                
         FROM STRING_SPLIT(@LegalName, ',') s                                
         WHERE LegalName LIKE s.value + '%'                                
         )                                
        )                                
        AND (                    
        @AgentCode IS NULL                                
        OR @AgentCode = ''                                
        OR EXISTS (                                
         SELECT 1                                
         FROM STRING_SPLIT(@AgentCode, ',') s                                
         WHERE AgentCode LIKE s.value + '%'                                
         )                                
        )                                
        AND (                                
        @Address IS NULL                                
  OR @Address = ''                                
        OR EXISTS (                                
         SELECT 1                                
     FROM STRING_SPLIT(@Address, ',') s                                
         WHERE AM.Address LIKE s.value + '%'                                
         )                                
        )                                
        AND (                               
        @AddressCountry IS NULL                                
        OR @AddressCountry = ''                                
        OR EXISTS (                                
         SELECT 1                                
         FROM STRING_SPLIT(@AddressCountry, ',') s                                
         WHERE CN.Name LIKE s.value + '%'                                
         )                                
        )                                
        AND (                                
        @AddressState IS NULL                                
        OR @AddressState = ''                                
        OR EXISTS (                                
         SELECT 1                                
         FROM STRING_SPLIT(@AddressState, ',') p                                
         WHERE s.Name LIKE '%' + p.value + '%'                                
         )                                
        )                                
        AND (                                
        @AddressCity IS NULL                                
        OR @AddressCity = ''                                
        OR EXISTS (                      
         SELECT 1                                
         FROM STRING_SPLIT(@AddressCity, ',') s                                
         WHERE C.Name LIKE '%' + s.value + '%'                                
         )                          
        )                                
        --AND (@CreditApplicable IS NULL OR CreditApplicable = CASE WHEN @CreditApplicable = 1 THEN 1 ELSE 0 END)                                                                        
        AND (                                
        @CreditApplicable IS NULL                                
        OR @CreditApplicable = ''                                
        OR AM.CreditApplicable = @CreditApplicable                                
        )                                
        AND (                                
        @PanNo IS NULL                                
        OR @PanNo = ''                                
        OR EXISTS (                                
         SELECT 1                                
         FROM STRING_SPLIT(@PanNo, ',') s                                
         WHERE AM.PanNo LIKE s.value + '%'                                
         )                                
        )                                
        AND (                                
        @TANDetails IS NULL                                
        OR @TANDetails = ''                                
        OR EXISTS (                                
         SELECT 1                                
         FROM STRING_SPLIT(@TANDetails, ',') s                                
         WHERE TANDetails LIKE s.value + '%'               
         )                                
        )                                
   AND (                                
        @GroupName IS NULL                                
        OR @GroupName = ''                                
        OR EXISTS (                                
        SELECT 1                                
         FROM STRING_SPLIT(@GroupName, ',') s                                
         WHERE AgentGroupName LIKE s.value + '%'                                
         )                                
        )                                
        AND (                  
        @TamSalesName IS NULL                                
        OR @TamSalesName = ''                                
        OR EXISTS (                                
         SELECT 1                                
         FROM STRING_SPLIT(@TamSalesName, ',') s                                
         WHERE EM.EmpName LIKE s.value + '%'  -- Corrected line                  
        )                                
        )                  
        AND (                  
        @PreviousCode IS NULL                                
        OR @PreviousCode = ''                                
        OR EXISTS (                                
         SELECT 1                                
         FROM STRING_SPLIT(@PreviousCode, ',') s            
         WHERE AM.PreviousCode LIKE s.value + '%'  -- Filter PreviousCode by prefix                  
         )                                
   )   
   
   AND  (@IsActive IS NULL OR AM.IsActive =@IsActive) 
                       
        AND (ISNULL(@IATACode,'')='' OR AM.City_IATACode=@IATACode)    
		 AND (ISNULL(@TaxType,'')='' OR AM.TaxType=@TaxType)  
                        
      )                
     as a                
    )                
                
   SELECT                 
    DISTINCT                 
    AM.AgentID                                
    ,                
    (                                
     SELECT TOP 1 ID                                
     FROM UploadImage                                
     WHERE ParentPageType = 7                                
      AND ParentID = AM.AgentID                                
    ) 'ImageID'                                
    ,AccCode                                
    ,AgentCode                                
    ,LEADID                                
    ,ISAGENT                                
    ,AgentName                                
    ,AM.CategoryID                                
    --,ACM.CategoryCode                                                                                   
    ,Miscellaneous                                
    ,GroupID                                
    --,AgentGroupName                                
    ,AM.MarketID                                
    ,S.Country_IATACode                                
    ,CN.Name 'CountryName'                                
    ,City_IATACode                                
    ,C.Name 'CityName'                                
    ,Website                                
    ,PhoneNo                                
    ,AM.MobileNo                                
    ,FaxNo                                
    ,EmailID                                
    ,AM.PanNo                                
    ,STRegNo AS SalesTaxRegNumber                               
    ,ChequeFavouring                                
    ,AM.Address                                
    ,CreateAdvanceAccount                                
    ,AM.CreditApplicable                                
    ,AM.CreditCurrencyCode                                
    ,AM.CreditAllowance                                
    ,AM.Threshold                                
    ,AM.CreditPeriod                                
    ,AM.OutStandingAmount                                
    ,AM.UnlimitedCredit                                
    ,AM.IsActive                                
    ,AM.Operation                                
    ,AM.OperationBy                                
    ,AM.OperationOn                                
    ,M.Name AS Market --,                                                                                                                                      
    --,(                                                                        
    -- SELECT CONVERT(VARCHAR(20), AA.OperationOn, 13)                                                                                              
    -- FROM AgentMaster_Audit AA                                                                       
    -- WHERE AA.AgentID = AM.AgentID                                                                                              
    --  AND AA.Operation = 'INSERT'                                                   
    -- ) AS 'OperationOn1'                                                                                       
    --,CASE                                                                                               
    -- WHEN ISNULL(AM.CreditApplicable, 0) = 1                                                                                              
    --  THEN 'Yes'                                                               
    -- ELSE 'No'                                                                                              
    -- END AS ISCreditApplicable                                                 
    --,CASE                                                                                               
    -- WHEN ISNULL(IsCorporate, 0) = 1                                                                                              
    --  THEN 'Yes'                                                                                              
    -- ELSE 'No'                                                          
    -- END AS IsCorporate --added by sanket @ 31/03/2015                                                                              
    ,ABM.BankAccountName                                
    -- ,EM.EmpName AS TamSalesName                                
    --,EM.EmpID AS TamSalesRep                                                                                        
    --,TS.EmpName AS   TamSalesrep                                               
    ,AM.HasBranch AS IsBranch                                
    ,AM.IsSEZ AS IsSEZ                                
    ,(                                
    SELECT TOP 1 State_Code                                
    FROM State_Code_Master                               
    WHERE ID = AM.StateCodeID                                
    ) AS StateCode                                
    ,S.Name AS StateName                                
    ,AM.AddressExist                                
    ,AM.GSTRequired                                
    ,AM.AddressCountry                                
    ,AM.AddressState                                
    ,AM.AddressCity                                
    ,AM.isActiveSAP                                
    ,AM.TANDetails                                
    --,AM.PreviousCode                                
    ,AM.AgentClassification                                
    ,AM.Comments                                
    ,AM.IsAgentREFPO                                
    ,'1000' AS CompanyCode                                
    ,AM.PostalCode                                
    ,LE.LegalEntTypeID AS 'LegalEntity'                                
    ,AM.LegalName                                
    ,AM.BeneficiaryName                                
    ,BranchName                                
    ,AM.Accountnumber                                
    ,BankAccountID                                
    ,BankName                                
    ,virtualaccount                       
    ,GSTIN                 ,AM.StateCodeID                                
    ,SWIFTCode                                
    ,MSME_UAN_Number AS MSMEUanNumber                    
    ,AM.IATACode                                
    ,IATOCode                                
    ,MSMEType                                
    ,IFSCCode                                
    ,PreviousCode                                
    ,IsInterBranch                                
    ,AG.AgentGroupName                                
    ,Contact2                                
    ,Contact1                                
    ,IsContact1Mobile                                
    ,IsContact2Mobile                                
    ,AM.TamSalesrep                                
    ,TamSalesName                  
    ,TaxType                 
   FROM                 
    AgentMaster AM                                
    LEFT JOIN Market M ON MarketID = ID                                
    --INNER JOIN AgentCategoryMaster ACM ON AM.CategoryID = ACM.CategoryID                                                                              
    LEFT JOIN City C ON AM.City_IATACode = C.IATACode                                
    --INNER JOIN AgentProfile AP ON AP.City_ID = C.ID                                              
 LEFT JOIN [State] S ON S.State_ID = C.State_IATACode                                
    LEFT JOIN Country CN ON CN.IATACode = S.Country_IATACode                                
    LEFT JOIN AccountsBankMaster ABM ON ABM.AccountBankMasterID = AM.BankAccountID --added by sanket @ 31/03/2015                                                                                       
    LEFT JOIN EmployeeMaster EM ON EM.EmpID = AM.RelatedEmployeeID                                
    LEFT JOIN EmployeeMaster TS ON TS.EmpID = AM.TamSalesrep                                
    LEFT JOIN State_Code_Master SC ON SC.ID = AM.StateCodeID                                
    LEFT JOIN LegalEntityType_Master LE ON AM.LegalEntity = LE.LegalEntTypeID                                
    LEFT JOIN AgentGroup AG ON AG.AgentGroupID = AM.GroupID                      
    LEFT JOIN Booking.tbl_Booking bb on bb.AgentID=AM.AgentID                
   WHERE                
    ((@UsedInBooking=1 and bb.ID is not null) Or (@UsedInBooking=0)) and                
    (                                
    @AgentID IS NULL                                
    OR @AgentID = 0                                
    OR AM.AgentID = @AgentID                                
    )                                
    AND (                                
    @AgentName IS NULL                                
    OR @AgentName = ''                                
    OR EXISTS (                                
     SELECT 1                                
     FROM STRING_SPLIT(@AgentName, '|') s                                
     WHERE AgentName LIKE s.value + '%'                                
     )                                
    )                                
    AND (                                
    @LegalName IS NULL                                
    OR @LegalName = ''                                
    OR EXISTS (                                
     SELECT 1                                
     FROM STRING_SPLIT(@LegalName, ',') s                                
     WHERE LegalName LIKE s.value + '%'                                
     )                                
    )                                
    AND (                    
    @AgentCode IS NULL                                
    OR @AgentCode = ''                                
    OR EXISTS (                                
     SELECT 1                                
     FROM STRING_SPLIT(@AgentCode, ',') s                                
     WHERE AgentCode LIKE s.value + '%'                                
     )                                
    )                                
    AND (                           
    @Address IS NULL                                
    OR @Address = ''                                
    OR EXISTS (                                
     SELECT 1                                
     FROM STRING_SPLIT(@Address, ',') s                                
     WHERE AM.Address LIKE s.value + '%'                          
     )                                
    )                                
    AND (                               
    @AddressCountry IS NULL                                
    OR @AddressCountry = ''                                
    OR EXISTS (                                
     SELECT 1                                
     FROM STRING_SPLIT(@AddressCountry, ',') s                                
     WHERE CN.Name LIKE s.value + '%'                                
     )                                
    )                                
    AND (                                
    @AddressState IS NULL                                
    OR @AddressState = ''               
    OR EXISTS (                                
     SELECT 1                                
     FROM STRING_SPLIT(@AddressState, ',') p                                
     WHERE s.Name LIKE '%' + p.value + '%'                                
     )                                
    )                                
    AND (                       
    @AddressCity IS NULL                                
    OR @AddressCity = ''                                
    OR EXISTS (                                
     SELECT 1                                
     FROM STRING_SPLIT(@AddressCity, ',') s                                
     WHERE C.Name LIKE '%' + s.value + '%'                                
     )                                
    )                                
    --AND (@CreditApplicable IS NULL OR CreditApplicable = CASE WHEN @CreditApplicable = 1 THEN 1 ELSE 0 END)                                                                        
    AND (                                
    @CreditApplicable IS NULL                                
    OR @CreditApplicable = ''                  
    OR AM.CreditApplicable = @CreditApplicable                                
    )                                
    AND (                                
    @PanNo IS NULL                                
    OR @PanNo = ''                                
    OR EXISTS (                                
     SELECT 1                                
     FROM STRING_SPLIT(@PanNo, ',') s                                
     WHERE AM.PanNo LIKE s.value + '%'                                
     )                                
    )                                
    AND (                                
    @TANDetails IS NULL                                
    OR @TANDetails = ''                                
    OR EXISTS (                                
     SELECT 1                                
     FROM STRING_SPLIT(@TANDetails, ',') s                                
     WHERE TANDetails LIKE s.value + '%'                                
     )                                
    )                                
    AND (                                
    @GroupName IS NULL                                
    OR @GroupName = ''                                
    OR EXISTS (                                
    SELECT 1                                
     FROM STRING_SPLIT(@GroupName, ',') s                                
     WHERE AgentGroupName LIKE s.value + '%'                   
     )                                
    )                                
    AND (                  
    @TamSalesName IS NULL                                
    OR @TamSalesName = ''                                
    OR EXISTS (                                
     SELECT 1                                
     FROM STRING_SPLIT(@TamSalesName, ',') s                                
     WHERE EM.EmpName LIKE s.value + '%'  -- Corrected line                  
    )                                
    )                  
    AND (                  
    @PreviousCode IS NULL                                
    OR @PreviousCode = ''                                
    OR EXISTS (                                
     SELECT 1                                
     FROM STRING_SPLIT(@PreviousCode, ',') s                                
     WHERE AM.PreviousCode LIKE s.value + '%'  -- Filter PreviousCode by prefix                  
  )                                
    )  
	
	 AND  (@IsActive IS NULL OR AM.IsActive =@IsActive) 
                       
    AND (ISNULL(@IATACode,'')='' OR AM.City_IATACode=@IATACode) 
	 AND (ISNULL(@TaxType,'')='' OR AM.TaxType=@TaxType) 

   ORDER BY AM.AgentID DESC                 
   OFFSET @PageNumber * @Row_Count ROWS                
   FETCH NEXT @Row_Count ROWS ONLY;                
                
   SELECT CAST(@TotalRecordCount AS VARCHAR(20)) AS Row_Count, '200' AS returnCode, 'Data Found' AS returnMessage;                                                               
  END       
        
  ELSE IF @Action = 'SB'                                
 BEGIN       
  SELECT AgentName, AgentID,AM.IsActive,AM.CreditApplicable  FROM AgentMaster AM      
  INNER JOIN SAPCompCode SCC WITH(NOLOCK) ON  SCC.ParentID  = AM.AgentID AND TypeID=3 AND SCC.IsActive=1        
  WHERE  (                                
    @AgentName IS NULL                                
    OR @AgentName = ''                                
    OR EXISTS (                                
     SELECT 1                                
     FROM STRING_SPLIT(@AgentName, '|') s                                
     WHERE AgentName LIKE '%' + s.value + '%'                                
     )                                
    )   AND(@IsActive  IS NULL OR @IsActive  = 0 OR AM.IsActive=@IsActive) 
	 AND (ISNULL(@IATACode,'')='' OR AM.City_IATACode=@IATACode)   
 END      

  ELSE IF @Action = 'D'                                
 BEGIN       
  SELECT 
    AM.AgentName, 
    AM.AgentID, 
    AM.IsActive 
FROM 
    AgentMaster AM
WHERE  
    AM.IsActive = 1
    AND (
        @AgentName IS NULL
        OR @AgentName = ''
        OR AM.AgentName LIKE '%' + @AgentName + '%' COLLATE SQL_Latin1_General_CP1_CI_AS
    )
ORDER BY 
    CHARINDEX(@AgentName COLLATE SQL_Latin1_General_CP1_CI_AS, AM.AgentName COLLATE SQL_Latin1_General_CP1_CI_AS),
    LTRIM(SUBSTRING(AM.AgentName, LEN(@AgentName) + 1, LEN(AM.AgentName))),
    AM.AgentName ASC,
    AM.AgentID DESC;

	 
 END  
END
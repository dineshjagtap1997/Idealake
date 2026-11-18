<<<<<<< HEAD
<<<<<<< HEAD
﻿CREATE PROCEDURE [dbo].[usp_VendorMaster] (                                                    
 @AccCode VARCHAR(50) = NULL                                                    
 ,@VendorCode VARCHAR(50) = '0'                                                    
 ,@VendorName VARCHAR(200) = NULL                                                    
 ,@AccountGroup VARCHAR(10) = NULL                                                    
 ,@CityIATACode CHAR(3) = NULL                                                    
 ,@Website VARCHAR(200) = NULL                                                    
 ,@PhoneNo VARCHAR(35) = NULL                                                    
 ,@MobileNo VARCHAR(15) = NULL                                                    
 ,@FaxNo VARCHAR(35) = NULL                                                    
 ,@EmailID VARCHAR(200) = NULL                                                    
 ,@PanNo VARCHAR(50) = NULL                                                    
 ,@STRegNo VARCHAR(50) = NULL                                                    
 ,@ChequeFavouring VARCHAR(200) = NULL                                                    
 ,@BankName VARCHAR(200) = NULL                                                    
 ,@Address VARCHAR(MAX) = NULL                                                    
 ,@AccountNo VARCHAR(100) = NULL                                                    
 ,@CreateAdvanceAccount BIT = NULL                                                    
 ,@CreditApplicable BIT = NULL                                                    
 ,@CreditPeriod INT = NULL                                                    
 ,@CreditCurrencyCode VARCHAR(5) = NULL                                                    
 ,@CreditAmount DECIMAL(18, 5) = NULL                                                    
 ,@CreditApproveBy VARCHAR(100) = NULL                                                    
 ,@IsActive BIT = NULL                                                    
 ,@OperationBy UNIQUEIDENTIFIER = NULL                                                    
 ,@CreateCommissionAccount BIT = 0                                                    
 ,@BankAccountID INT = NULL                                                    
 ,@IsXML BIT = 0                                                    
 ,@IFSCCode VARCHAR(50) = NULL                                                    
 ,@SWIFTCode VARCHAR(50) = NULL                                                    
 ,@Comment VARCHAR(100) = NULL                                                    
 ,@BranchName VARCHAR(200) = NULL                                                    
 ,                                                    
 --@ErrMsg VARCHAR(50) OUT,                                                                    
 @VendorID INT = NULL                                                    
 ,@StateCode BIGINT = NULL                                                    
 ,@StateID INT = NULL                                              
 ,@GSTRequired BIT = 0                                                    
 ,@isActiveSAP BIT = 0                                                    
 ,@TANDetails VARCHAR(500) = NULL                                                    
 ,@PreviousCode VARCHAR(500) = NULL                                                    
 ,@MSME VARCHAR(500) = NULL                                                    
 ,@Deductee VARCHAR(500) = NULL                                                    
 ,@WithHoldigTax VARCHAR(500) = NULL                                                    
 ,@XOSupplierNameLogic BIT = NULL                                                    
 ,@isActiveMSME BIT = 0                                                    
 ,@MSMEType VARCHAR(20) = NULL                                                    
 ,@MSMERegFromDt DATETIME = NULL                                                    
 ,@MSMERegToDt DATETIME = NULL       
 ,@PostalCode VARCHAR(10) = NULL                                                    
 ,@BizPartnerGrp VARCHAR(300) = NULL                                                    
 ,@LegalEntity int = 0                                        
 ,@LegalName VARCHAR(80) = NULL               
 ,@IsSEZ BIT = 0                                                    
 ,@MembershipNo VARCHAR(20) = NULL                                                 
 ,@NonGSTRegistered BIT = 0                                                    
,@isH BIT = 0                                                    
 ,@isT BIT = 0                                                    
 ,@isM BIT = 0                                                    
 ,@isSS BIT = 0                                                    
 ,@isGG BIT = 0                                                    
 ,@isMOT BIT = 0                                                    
 ,@isFS BIT = 0                                   
 ,@isChange BIT = 0                                                    
 ,@XOPrintName VARCHAR(80) = ''                             
 ,@Action CHAR(5) = ''                                                    
 ,@IATACode CHAR(3) = NULL                                                    
 ,@IATOCode CHAR(3) = NULL        ,                                          
 @PANVERIFICATION Varchar(20)= '',                                          
@TANVERIFICATION Varchar(20)= '',                                          
@GSTVERIFICATION Varchar(20)= ''   ,                                    
@VendorSAPCode VARCHAR(20) = '' ,                              
@Country VARCHAR(MAX)='',                              
@State VARCHAR(MAX)='',                              
@City  VARCHAR(MAX)=''                                   
   ,@TaxType NVARCHAR(20) = NULL                             
    ,@Tax_Reg_Number NVARCHAR(MAX) = ''                           
  ,@Contact1 varchar(50)=''                                                      
 ,@Contact2 varchar(50)=''                                                      
 ,@Contact1IsMobile bit=NULL                                                      
 ,@Contact2IsMobile bit=NULL     
,@Row_Count VARCHAR(max) = '10'          
 ,@PageNumber INT = 0   
  ,@issapcompcode BIT = NULL  
 )                                             
AS                                                    
BEGIN   
  
  DECLARE @TotalRecordCount INT          
  ,@SQL NVARCHAR(MAX);     
 IF @Action = 'I'                                                    
 BEGIN             
  
  --IF EXISTS (                                                            
  --  SELECT 1                                                            
  --  FROM VendorMaster                                                            
  --  WHERE UPPER(VendorCode) = UPPER(@VendorCode)                                                            
  --  )                                                            
  --BEGIN                                                            
  -- SELECT '201' AS returnCode                                                            
  --  ,'This data already exists. Please check and try again' AS returnMessage;                                                            
  -- RETURN;                                                    
  --END                                                            
  IF EXISTS (                                                    
    SELECT 1                                                    
    FROM VendorMaster                                                    
    WHERE LTRIM(UPPER(VendorName)) = LTRIM(UPPER(@VendorName))                                                    
    )                                                    
  BEGIN                                                    
   SELECT '201' AS returnCode                                                    
    ,'Vendor Name already exists. Please check and try again' AS returnMessage;                                                    
                                                
   RETURN;                                                    
  END                                                    
                                                    
  -- Insert Logic                                                   
  INSERT INTO VendorMaster (                                             
   AccCode                                                    
   ,VendorCode                                    
   ,VendorName                                                    
   ,AccountGroup                                                    
   ,CityIATACode                                   
   ,Website                                                    
   ,PhoneNo                                                    
   ,MobileNo                                                    
   ,FaxNo                             
   ,EmailID                                                    
   ,PanNo                                                    
   ,STRegNo                                                    
   ,ChequeFavouring                                             ,BankName                                                    
   ,[Address]                                                    
   ,AccountNo                                                    
   ,CreateAdvanceAccount                                                    
   ,CreditApplicable                                                  
   ,CreditPeriod                                                    
   ,CreditCurrencyCode                                                    
  ,CreditAmount                                                    
   ,CreditApproveBy                    
   ,IsActive                                                    
   ,Operation                                                    
   ,OperationBy                                                    
   ,OperationOn                                                    
   ,CreateCommissionAccount                                    
   ,BankAccountID                                                    
   ,IsXML                                                    
   ,IFSCCode                                                    
   ,SWIFTCode                                                    
 ,Comment                                                    
   ,BranchName                                                    
   ,StateCodeID                                                    
   ,GSTRequired                                                    
   ,isActiveSAP                                                    
   ,TANDetails                                                    
   ,PreviousCode                                                    
   ,MSME                                                    
   ,Deductee                                                    
   ,WithHoldingTax                                                    
   ,XOSupplierNameLogic                                                    
   ,isActiveMSME                                                    
   ,MSMEType                                                    
   ,MSMERegFromDt                                                    
   ,MSMERegToDt                                                    
   ,PostalCode                                                    
   ,BizPartnerGrp                                                    
   ,LegalEntity                                                    
   ,LegalName                                                    
   ,IsSEZ                                                    
   ,MembershipNo                                                    
   ,NonGSTRegistered                                                    
   ,isH                                                    
   ,isT                                                    
   ,isM                                                    
   ,isSS           
   ,isGG                                                    
   ,isMOT                                                    
   ,isFS                                                    
   ,isChange       ,XOPrintName                                                    
   ,IATACode                                                    
   ,IATOCode         ,                                        
 PANVERIFICATION,                                          
 TANVERIFICATION,                                          
 GSTVERIFICATION,                            
 TaxType                            
 ,Tax_Reg_Number                          
 ,Contact1       
 ,Contact2                                                      
 ,Contact1IsMobile                                                      
 ,Contact2IsMobile    
 ,issapcompcode
   )                                                    
  VALUES (                                                    
   @AccCode                                  
   ,@VendorCode                                                    
   ,@VendorName                                                    
   ,@AccountGroup                                                    
   ,@CityIATACode                                                    
   ,@Website                                                    
   ,@PhoneNo                                              
   ,@MobileNo                                                    
   ,@FaxNo                                                    
   ,@EmailID                                                 
   ,@PanNo                                                    
   ,@STRegNo                                                    
   ,@ChequeFavouring                                                    
   ,@BankName                                                  
   ,@Address                                                    
   ,@AccountNo                                                    
   ,@CreateAdvanceAccount                                                    
   ,@CreditApplicable                                                    
   ,@CreditPeriod                                                    
   ,@CreditCurrencyCode                                                    
,@CreditAmount                                               
   ,@CreditApproveBy                                                    
   ,@IsActive                                                    
   ,'INSERT'                                                    
   ,@OperationBy                                                    
   ,GETDATE()                                                    
   ,@CreateCommissionAccount                                         ,@BankAccountID                                                    
   ,@IsXML                                                    
   ,@IFSCCode                                                    
   ,@SWIFTCode                       ,@Comment                                                    
   ,@BranchName                                                    
   ,@StateCode                                                    
   ,@GSTRequired                                                    
   ,@isActiveSAP                                                    
   ,@TANDetails                                                    
   ,@PreviousCode                                                    
   ,@MSME                                                    
   ,@Deductee                                                    
   ,@WithHoldigTax                                                    
   ,@XOSupplierNameLogic                                                    
   ,@isActiveMSME                                      
   ,@MSMEType                                 
   ,@MSMERegFromDt                                                    
   ,@MSMERegToDt                                                    
   ,@PostalCode          
   ,@BizPartnerGrp                                                    
   ,@LegalEntity                                                    
   ,@LegalName                                                    
   ,@IsSEZ                                                    
   ,@MembershipNo                                                    
   ,@NonGSTRegistered                                                    
   ,@isH                                                    
   ,@isT                                                 
   ,@isM                                                    
   ,@isSS                                                    
   ,@isGG                                                    
   ,@isMOT                                                    
   ,@isFS                                                    
   ,@isChange                                                    
   ,@XOPrintName                                                    
   ,@IATACode                                                    
   ,@IATOCode     ,                                          
 @PANVERIFICATION,                                          
 @TANVERIFICATION,                                          
 @GSTVERIFICATION,                            
 @TaxType                            
  ,@Tax_Reg_Number                        
   ,@Contact1                                          
 ,@Contact2                                                      
 ,@Contact1IsMobile                                                      
 ,@Contact2IsMobile    
 ,@issapcompcode
   );                                                    
                                                    
  --SET @VendorID = SCOPE_IDENTITY();                                                            
  select  @VendorID = @@IDENTITY                                                    
                                 
  DECLARE @MaxNo_Str AS VARCHAR(8)                                                    
  DECLARE @SapID AS VARCHAR(10)                                                    
                                                    
  SET @MaxNo_Str = (                                                    
    SELECT SUBSTRING(MAX(VendorSAPCode), 3, LEN(MAX(VendorSAPCode)))                                                    
    FROM VendorMaster                                                    
    )                                                    
  SET @MaxNo_Str = CASE                                                     
    WHEN @MaxNo_Str IS NULL                                                    
     THEN '1'                           
    ELSE CAST(@MaxNo_Str AS INT) + 1                                                    
    END                                                    
  SET @SapID = 'CV' + REPLICATE('0', 8 - LEN(@MaxNo_Str)) + @MaxNo_Str                                                    
                                                    
  UPDATE VendorMaster                                                    
  SET VendorSAPCode = @SapID                            
  WHERE VendorID = @VendorID                                                    
                                                    
  -- EXEC usp_InsertVendorMasterAuditDetails @VendorID, @VendorName, 'INSERT', @OperationBy;                                                  
  SELECT '200' AS returnCode                                                    
   ,'New record added successfully.' AS returnMessage, @VendorID as ID;                                                    
 END                                                    
 ELSE IF @Action = 'U'                   
 BEGIN                                                    
 -- -- Update Logic                                                                    
 -- --IF EXISTS (                                                    
 -- --  SELECT 1                                                    
 -- --  FROM VendorMaster                         
 -- --  WHERE UPPER(VendorCode) = UPPER(@VendorCode)                                                    
 -- --   AND VendorID <> @VendorID                                                    
 -- --  )                                                    
 -- --BEGIN                                                    
 -- -- SELECT '201' AS returnCode                                              
 -- --  ,'This data already exists. Please check and try again' AS returnMessage;                                                    
                                                    
 --  RETURN;                                                    
 -- END                                                    
                                                    
  UPDATE VendorMaster                                                    
  SET AccCode = @AccCode                                                    
   --,VendorCode = @VendorCode                                                    
   ,VendorName = @VendorName                                        
   ,AccountGroup = @AccountGroup                
   ,CityIATACode = @CityIATACode                                                    
   ,Website = @Website                                                    
   ,PhoneNo = @PhoneNo                                                    
   ,MobileNo = @MobileNo                                                    
   ,FaxNo = @FaxNo                                                    
   ,EmailID = @EmailID                                                    
   ,PanNo = @PanNo                                                    
   ,STRegNo = @STRegNo                                              
   ,ChequeFavouring = @ChequeFavouring                                                    
   ,BankName = @BankName                                                    
   ,[Address] = @Address                                                    
   ,AccountNo = @AccountNo                                                    
   ,CreateAdvanceAccount = @CreateAdvanceAccount                                                    
   ,CreditApplicable = @CreditApplicable                                                    
   ,CreditPeriod = @CreditPeriod                   
   ,CreditCurrencyCode = @CreditCurrencyCode                                                    
   ,CreditAmount = @CreditAmount                                                    
   ,CreditApproveBy = @CreditApproveBy                                                    
   ,IsActive = @IsActive                                                    
   ,Operation = 'UPDATE'                                                    
   ,UpdatedBy = @OperationBy                                                    
   ,UpdatedOn = GETDATE()                                                    
   ,CreateCommissionAccount = @CreateCommissionAccount                                                    
 ,BankAccountID = @BankAccountID                                                    
   ,IsXML = @IsXML                                                    
   ,IFSCCode = @IFSCCode                                                    
   ,SWIFTCode = @SWIFTCode                                                    
   ,Comment = @Comment                         
   ,BranchName = @BranchName                                                    
   ,StateCodeID = @StateCode                                                    
   ,GSTRequired = @GSTRequired                                                    
   ,isActiveSAP = @isActiveSAP                                                    
   ,TANDetails = @TANDetails                                                    
   ,PreviousCode = @PreviousCode                                                    
   ,MSME = @MSME                                                    
   ,Deductee = @Deductee                                                    
   ,WithHoldingTax = @WithHoldigTax                                     
   ,XOSupplierNameLogic = @XOSupplierNameLogic                                                    
   ,isActiveMSME = @isActiveMSME                                              
   ,MSMEType = @MSMEType                                                  
   ,MSMERegFromDt = @MSMERegFromDt                                                    
   ,MSMERegToDt = @MSMERegToDt                                                   
  ,PostalCode = @PostalCode                                                    
   ,BizPartnerGrp = @BizPartnerGrp                            
     ,Tax_Reg_Number = @Tax_Reg_Number                              
   ,LegalEntity = @LegalEntity                                   
   ,LegalName = @LegalName                                                    
   ,IsSEZ = @IsSEZ                                                    
   ,MembershipNo = @MembershipNo                                                    
   ,NonGSTRegistered = @NonGSTRegistered                                                    
   ,isH = @isH                                                    
   ,isT = @isT                                                    
   ,isM = @isM                                                    
   ,isSS = @isSS                                               
   ,isGG = @isGG                                                    
   ,isMOT = @isMOT                                                    
   ,isFS = @isFS                                                    
   ,isChange = @isChange                                                    
   ,XOPrintName = @XOPrintName,                                           
 PANVERIFICATION = @PANVERIFICATION,                                          
 TANVERIFICATION = @TANVERIFICATION,                                          
 GSTVERIFICATION = @GSTVERIFICATION                            
 ,TaxType = @TaxType                           
 ,Contact1 = @Contact1                        
 ,Contact2 = @Contact2                                                      
 ,Contact1IsMobile = @Contact1IsMobile                                   
 ,Contact2IsMobile = @Contact2IsMobile   
 ,issapcompcode = @issapcompcode
 ,IATACode = ISNULL(@IATACode,IATACode)          
 ,IATOCode = ISNULL(@IATOCode,IATOCode)          
  WHERE VendorID = @VendorID;     
                                                    
  --EXEC usp_InsertVendorMasterAuditDetails @VendorID, @VendorName, 'UPDATE', @OperationBy;                                                                    
  SELECT '200' AS returnCode                                                    
   ,'Record updated successfully.' AS returnMessage , @VendorID as ID ;                                                   
 END   
-- else if @Action ='S'  
-- SELECT   
--    Vm.VendorID,  
--    Vm.AccCode,  
--    Vm.VendorCode,  
--    Vm.VendorName,  
--    Vm.AccountGroup,  
--    Vm.CityIATACode,  
--    Vm.Website,  
--    Vm.PhoneNo,  
--    Vm.MobileNo,  
--    Vm.FaxNo,  
--    Vm.EmailID,  
--    Vm.PanNo,  
--    Vm.STRegNo,  
--    Vm.ChequeFavouring,  
--    Vm.BankName,  
--    Vm.[Address],  
--    Vm.AccountNo,  
--    Vm.CreateAdvanceAccount,  
--    Vm.CreditApplicable,  
--    Vm.CreditPeriod,  
--    Vm.CreditCurrencyCode,  
--    Vm.CreditAmount,  
--    Vm.CreditApproveBy,  
--    Vm.IsActive,  
--    Vm.OperationBy,  
--    Ct.Name AS CityName,  
--    St.StateCodeID AS [StateCode],  
--    St.Name AS StateName,  
--    Cn.IATACode AS Country,  
--    Cn.Name AS CountryName,  
--    Vm.Comment,  
--    Vm.IFSCCode,  
--    Vm.VendorSAPCode,  
--    Vm.GSTRequired,  
--    Vm.isActiveSAP,  
--    Vm.TANDetails,  
--    Vm.PreviousCode,  
--    Vm.MSME,  
--    Vm.MSMEType,  
--    Vm.Deductee,  
--    Vm.WithHoldigTax,  
--    Vm.XOSupplierNameLogic,  
--    Vm.VendorSAPCode AS 'SAPCode',  
--    Vm.PostalCode,  
--    HG.IATACode AS BizPartnerGrp,  
--    HG.Name AS BizPartnerGrpName,  
--    LE.LegalEntTypeID AS LegalEntity,  
--    Vm.LegalName,  
--    Vm.MembershipNo,  
--    CreateCommissionAccount,  
--    St.State_ID AS StateId,  
--    Vm.PANVERIFICATION,  
--    Vm.TANVERIFICATION,  
--    Vm.GSTVERIFICATION,  
--    Vm.TaxType,  
--    Vm.Contact1,  
--    Vm.Contact2,  
--    Vm.Contact1IsMobile,  
--    Vm.Contact2IsMobile,  
--    Vm.IATACode,  
--    Vm.IATOCode,  
--    Vm.IsT,  
--    Vm.isFS,  
--    Vm.isGG,  
--    Vm.isChange,  
--    Vm.isH,  
--    Vm.isM,  
--    Vm.isMOT,  
--    Vm.isSEZ,  
--    Vm.isSS,  
--    Vm.BranchName,  
--    Vm.SWIFTCode,  
--    Vm.NonGSTRegistered,  
  
--    -- Total count for pagination  
--    COUNT(*) OVER() AS TotalCount  
  
--FROM VendorMaster Vm  
--LEFT JOIN City Ct WITH (NOLOCK) ON Vm.CityIATACode = Ct.IATACode  
--LEFT JOIN [State] St WITH (NOLOCK) ON St.State_ID = Ct.State_IATACode  
--LEFT JOIN Country Cn WITH (NOLOCK) ON Cn.IATACode = St.Country_IATACode  
--LEFT JOIN State_Code_Master SC WITH (NOLOCK) ON SC.ID = Vm.StateCodeID  
--LEFT JOIN LegalEntityType_Master LE ON Vm.LegalEntity = LE.LegalEntTypeID  
--LEFT JOIN HotelGroups HG ON Vm.BizPartnerGrp = HG.IATACode  
  
--WHERE  
--    -- your filtering logic...  
--    (@VendorID IS NULL OR @VendorID = 0 OR Vm.VendorID = @VendorID)  
--    AND (@VendorName IS NULL OR @VendorName = '' OR EXISTS (  
--        SELECT 1 FROM STRING_SPLIT(@VendorName, '|') s  
--        WHERE s.value <> '' AND Vm.VendorName LIKE s.value + '%'  
--    ))  
--    -- ... continue all your filters ...  
  
--ORDER BY Vm.VendorID  -- or any consistent sortable column  
--OFFSET (@PageNumber - 1) * @PageSize ROWS  
--FETCH NEXT @PageSize ROWS ONLY  
  
-- ELSE IF @Action = 'EX'                                                    
-- BEGIN                                                    
--  SELECT   
--  --Vm.VendorID                                                    
--   Vm.AccCode                                                    
--   ,Vm.VendorCode                                                    
--   ,Vm.VendorName                                                    
--   ,Vm.AccountGroup                                                    
--   ,Vm.CityIATACode                                                    
--   ,Vm.Website                                                    
--   ,Vm.PhoneNo                                                    
--   ,Vm.MobileNo                                                    
--   ,Vm.FaxNo              
--   ,Vm.EmailID                                                    
--   ,Vm.PanNo                                                    
--   ,Vm.STRegNo                                                    
--   ,Vm.ChequeFavouring                                                    
--  -- ,Vm.BankAccountID AS BankName ,            
--   ,Vm.BankName            
--   ,Vm.[Address]                                                    
--   ,Vm.AccountNo                                               
--   ,  
--   CASE   
-- WHEN Vm.CreateAdvanceAccount = 1 THEN 'Yes'  
-- When Vm.CreateAdvanceAccount  = 0 THEN 'No'  
-- END AS CreateAdvanceAccount    
--   ,  
--    CASE   
-- WHEN Vm.CreditApplicable = 1 THEN 'Yes'  
-- When Vm.CreditApplicable  = 0 THEN 'No'  
-- END AS CreditApplicable    
--   ,Vm.CreditPeriod                                                    
--   ,Vm.CreditCurrencyCode                                                    
--   ,Vm.CreditAmount                                                    
--   ,Vm.CreditApproveBy                                             
--   , --Vm.IsActive        
--    CASE   
-- WHEN Vm.IsActive = 1 THEN 'True'  
-- When Vm.IsActive  = 0 THEN 'False'  
-- END AS IsActive    
--   --,Vm.OperationBy                                                    
--   ,Ct.Name AS CityName                                                    
--   ,St.StateCodeID AS [StateCode]                                                     ,St.Name AS StateName                                                    
--   ,Cn.IATACode AS Country                                                    
--   ,Cn.Name AS CountryName                                                                                                                          
--   ,Vm.Website                                                    
--   ,Vm.Comment                
--   ,Vm.IFSCCode                                                    
--   ,Vm.VendorSAPCode                                                    
--   ,--Vm.GSTRequired    
--    CASE   
-- WHEN Vm.GSTRequired   = 1 THEN 'Yes'  
-- When Vm.GSTRequired    = 0 THEN 'No'  
-- END AS GSTRequired      
--   ,--Vm.isActiveSAP     
--    CASE   
-- WHEN Vm.isActiveSAP   = 1 THEN 'Yes'  
-- When Vm.isActiveSAP    = 0 THEN 'No'  
-- END AS isActiveSAP   
--   ,Vm.TANDetails                                                    
--   ,Vm.PreviousCode                                                    
--   ,Vm.MSME                    
--   ,Vm.MSMEType          
--   ,Vm.Deductee                                                    
--   ,Vm.WithHoldigTax                                                    
--   ,--Vm.XOSupplierNameLogic  
--    CASE   
-- WHEN Vm.XOSupplierNameLogic   = 1 THEN 'Yes'  
-- When Vm.XOSupplierNameLogic    = 0 THEN 'No'  
-- END AS XOSupplierNameLogic   
--   ,Vm.VendorSAPCode AS 'SAPCode'                                                     
--   ,Vm.PostalCode                                                    
--   ,HG.IATACode AS BizPartnerGrp      
       
--   ,HG.Name  AS BizPartnerGrpName                                                                
--  -- ,LE.LegalEntTypeID   AS LegalEntity                                                     
--   ,Vm.LegalName                                                   
--   --,LegalEntity                                                  
--   ,MembershipNo                                                   
--   -- ,LE.LegalEntTypeID                                       
-- ,--CreateCommissionAccount   
--  CASE   
-- WHEN CreateCommissionAccount   = 1 THEN 'Yes'  
-- When CreateCommissionAccount    = 0 THEN 'No'  
-- END AS CreateCommissionAccount ,                                            
---- St.State_ID AS StateId,                                            
-- vm.PANVERIFICATION,                                          
-- vm.TANVERIFICATION,                         
-- vm.GSTVERIFICATION,                            
-- VM.TaxType,                           
--  Contact1,                            
--        Contact2,                            
--        --Contact1IsMobile,                            
--        --Contact2IsMobile                       
--  -- ,PreviousCode                                                      
--   VM.IATACode                                                            
--  ,VM.IATOCode              
--  , --Vm.IsT   
--   CASE   
-- WHEN Vm.IsT   = 1 THEN 'Yes'  
-- When Vm.IsT    = 0 THEN 'No'  
-- END AS IsT   
--  ,--Vm.isFS  
--  CASE   
-- WHEN Vm.isFS   = 1 THEN 'Yes'  
-- When Vm.isFS    = 0 THEN 'No'  
-- END AS isFS ,            
--  --Vm.isGG   
--  CASE   
-- WHEN Vm.isGG   = 1 THEN 'Yes'  
-- When Vm.isGG    = 0 THEN 'No'  
-- END AS isGG   
--  ,--Vm.isChange    
--  CASE   
-- WHEN Vm.isChange   = 1 THEN 'Yes'  
-- When Vm.isChange    = 0 THEN 'No'  
-- END AS isChange   
--  ,--Vm.isH            
--  CASE   
-- WHEN Vm.isH   = 1 THEN 'Yes'  
-- When Vm.isH    = 0 THEN 'No'  
-- END AS isH   
--   ,--Vm.isM   
--   CASE   
-- WHEN Vm.isM   = 1 THEN 'Yes'  
-- When Vm.isM    = 0 THEN 'No'  
-- END AS isM   
-- ,--Vm.isMOT     
-- CASE   
-- WHEN Vm.isMOT   = 1 THEN 'Yes'  
-- When Vm.isMOT    = 0 THEN 'No'  
-- END AS isMOT   
--    ,--Vm.isSEZ    
-- CASE   
-- WHEN Vm.isSEZ   = 1 THEN 'Yes'  
-- When Vm.isSEZ    = 0 THEN 'No'  
-- END AS isSEZ   
--  ,--Vm.isSS  
--  CASE   
-- WHEN Vm.isSS   = 1 THEN 'Yes'  
-- When Vm.isSS    = 0 THEN 'No'  
-- END AS isSS ,            
--  Vm.BranchName,            
--  Vm.SWIFTCode ,        
--  --NonGSTRegistered   
--CASE   
-- WHEN NonGSTRegistered   = 1 THEN 'Yes'  
-- When NonGSTRegistered    = 0 THEN 'No'  
-- END AS NonGSTRegistered   
--  FROM VendorMaster Vm                                                    
--  LEFT JOIN City Ct WITH (NOLOCK) ON Vm.CityIATACode = Ct.IATACode                                                    
--  LEFT JOIN [State] St WITH (NOLOCK) ON St.State_ID = Ct.State_IATACode                                                    
--  LEFT JOIN Country Cn WITH (NOLOCK) ON Cn.IATACode = St.Country_IATACode                                                    
--  LEFT JOIN State_Code_Master SC WITH (NOLOCK) ON SC.ID = Vm.StateCodeID                                                    
--  LEFT JOIN LegalEntityType_Master LE ON Vm.LegalEntity = LE.LegalEntTypeID                                                    
--  LEFT JOIN HotelGroups HG ON Vm.BizPartnerGrp = HG.IATACode                                                    
--  WHERE (@VendorID IS NULL OR @VendorID = 0 OR Vm.VendorID = @VendorID)                                  
--AND (@VendorName IS NULL OR @VendorName = '' OR EXISTS (                                  
--      SELECT 1 FROM STRING_SPLIT(@VendorName, '|') s                                   
--      WHERE s.value <> ''                                   
--        AND Vm.VendorName LIKE  s.value + '%'                                  
--    ))                              
--AND (@VendorCode IS NULL OR @VendorCode = '' OR EXISTS (                                  
--      SELECT 1 FROM STRING_SPLIT(@VendorCode, ',') s                                   
--     WHERE s.value <> ''                                   
--        AND Vm.VendorCode LIKE  s.value + '%'                                  
--    ))                                                    
--AND (@CityIATACode IS NULL OR @CityIATACode = '' OR EXISTS (                                  
--      SELECT 1 FROM STRING_SPLIT(@CityIATACode, ',') s                                   
--      WHERE s.value <> ''                                   
--        AND Vm.CityIATACode LIKE '%' + s.value + '%'                                  
--    ))                                                    
--AND (@StateCode IS NULL OR @StateCode = 0 OR Vm.StateCodeID = @StateCode)                                                    
                               
                                
--AND (@LegalName IS NULL OR @LegalName = '' OR EXISTS (                                  
--      SELECT 1 FROM STRING_SPLIT(@LegalName, ',') s                                   
--      WHERE s.value <> ''                                   
--        AND Vm.LegalName LIKE s.value + '%'                                  
--    ))                                      
--AND (@BizPartnerGrp IS NULL OR @BizPartnerGrp = '' OR EXISTS (                                  
--      SELECT 1 FROM STRING_SPLIT(@BizPartnerGrp, ',') s                                   
--      WHERE s.value <> ''                                   
--        AND Vm.BizPartnerGrp LIKE  s.value + '%'                                  
--))                                      
--AND (@Address IS NULL OR @Address = '' OR EXISTS (                                  
--      SELECT 1 FROM STRING_SPLIT(@Address, ',') s                                   
--      WHERE s.value <> ''                                   
--        AND Vm.Address LIKE s.value + '%'                                  
--    ))                                     
----AND (@CreditApplicable IS NULL OR CreditApplicable = @CreditApplicable)                                  
----  AND (@CreditApplicable IS NULL OR Vm.CreditApplicable = @CreditApplicable)                                
                                
--AND (@PanNo IS NULL OR @PanNo = '' OR EXISTS (                                  
--      SELECT 1 FROM STRING_SPLIT(@PanNo, ',') s                                   
--      WHERE s.value <> ''                                   
--        AND Vm.PanNo LIKE  s.value + '%'                                  
--    ))                                      
--AND (@TANDetails IS NULL OR @TANDetails = '' OR EXISTS (                                  
--      SELECT 1 FROM STRING_SPLIT(@TANDetails, ',') s                                   
--      WHERE s.value <> ''                                   
--        AND Vm.TANDetails LIKE  s.value + '%'                                  
--    ))                             
-- AND  (@Country IS NULL OR @Country = '' OR EXISTS (                                  
--      SELECT 1 FROM STRING_SPLIT(@Country, ',') s                                   
--      WHERE s.value <> ''                                   
--        AND Cn.Name LIKE '%' + s.value + '%'                                  
--    ))                                
-- AND  (@State IS NULL OR @State = '' OR EXISTS (                                  
--      SELECT 1 FROM STRING_SPLIT(@State, ',') s                              
--      WHERE s.value <> ''                                   
--        AND St.Name LIKE '%' + s.value + '%'                                  
--    ))                                 
-- AND  (@City IS NULL OR @City = '' OR EXISTS (                                  
--      SELECT 1 FROM STRING_SPLIT(@City, ',') s                                   
--      WHERE s.value <> ''                 
--        AND Ct.Name LIKE '%' + s.value + '%'                                  
--    ))                                
--  AND (@Tax_Reg_Number IS NULL OR @Tax_Reg_Number = '' OR EXISTS (                                
--      SELECT 1 FROM STRING_SPLIT(@Tax_Reg_Number, ',') s                                 
--      WHERE s.value <> ''                                 
--        AND @Tax_Reg_Number LIKE  s.value + '%'                                
--    ))                                
-- AND (@TaxType IS NULL OR @TaxType = '' OR EXISTS (                                
--      SELECT 1 FROM STRING_SPLIT(@TaxType, ',') s                                 
--      WHERE s.value <> ''                                 
--        AND TaxType   LIKE '%' + s.value + '%'                                
--    ))                                
                                    
                    
-- order by 1 DESC                                                    
--   --SELECT '200' AS returnCode, 'Data Retrieved' AS returnMessage;                                                   
-- END                       
-- ELSE IF @Action = 'FS' ---- SAPCODE DROPDOWN FILTER                                    
-- BEGIN                                    
-- SELECT VendorSAPCode, VENDORID FROM VendorMaster                                    
-- WHERE (@VendorSAPCode = 0 OR @VendorSAPCode IS NULL OR VendorSAPCode LIKE '%' + @VendorSAPCode + '%')                                    
-- END                                    
                                    
-- ELSE IF @Action = 'FN' ---- VENDORNAME DROPDOWN FILTER                                    
-- BEGIN                                    
-- SELECT VendorName, VENDORID FROM VendorMaster                                    
-- WHERE (@VendorName = '' OR @VendorName IS NULL OR VendorName LIKE '%' + @VendorName + '%')                                    
--END                                    
                                     
-- ELSE IF @Action = 'FA' ---- ADDRESS DROPDOWN FILTER                                    
-- BEGIN                                    
-- SELECT Address, VENDORID FROM VendorMaster                                    
-- WHERE (@Address = '' OR @Address IS NULL OR Address LIKE '%' + @Address + '%')                                    
-- END                                    
                                    
-- ELSE IF @Action = 'FI' ---- ISACTIVE DROPDOWN FILTER                                    
-- BEGIN                                    
-- SELECT IsActive, VENDORID FROM VendorMaster                                    
-- WHERE (@IsActive IS NULL OR IsActive = @IsActive )                                    
-- END      
IF @PageNumber < 0   
BEGIN  
    SET @PageNumber = 0  
END  
  
IF @Row_Count <= 0   
BEGIN  
    SET @Row_Count = 10 -- Default page size  
END  
--ELSE IF @Action = 'S'  
--BEGIN  
--   IF OBJECT_ID('TEMPDB..#TempReport') IS NOT NULL  
--    DROP TABLE #TempReport;  
  
--SELECT *  
--INTO #TempReport  
--FROM (  
--    SELECT   
--        Vm.VendorID,  
--        Vm.AccCode,  
--        Vm.VendorCode,  
--        Vm.VendorName,  
--        Vm.AccountGroup,  
--        Vm.CityIATACode,  
--        Vm.Website,  
--        Vm.PhoneNo,  
--        Vm.MobileNo,  
--        Vm.FaxNo,  
--        Vm.EmailID,  
--        Vm.PanNo,  
--        Vm.STRegNo,  
--        Vm.ChequeFavouring,  
--        Vm.BankName,  
--        Vm.[Address],  
--        Vm.AccountNo,  
--        Vm.CreateAdvanceAccount,  
--        Vm.CreditApplicable,  
--        Vm.CreditPeriod,  
--        Vm.CreditCurrencyCode,  
--        Vm.CreditAmount,  
--        Vm.CreditApproveBy,  
--        Vm.IsActive,  
--        Vm.OperationBy,  
--        Ct.Name AS CityName,  
--        St.StateCodeID AS [StateCode],  
--        St.Name AS StateName,  
--        Cn.IATACode AS Country,  
--        Cn.Name AS CountryName,  
--        Vm.Comment,  
--        Vm.IFSCCode,  
--        Vm.VendorSAPCode,  
--        Vm.GSTRequired,  
--        Vm.isActiveSAP,  
--        Vm.TANDetails,  
--        Vm.PreviousCode,  
--        Vm.MSME,  
--        Vm.MSMEType,  
--        Vm.Deductee,  
--        Vm.WithHoldigTax,  
--        Vm.XOSupplierNameLogic,  
--        Vm.VendorSAPCode AS SAPCode,  
--        Vm.PostalCode,  
--        HG.IATACode AS BizPartnerGrp,  
--        HG.Name AS BizPartnerGrpName,  
--        LE.LegalEntTypeID AS LegalEntity,  
--        Vm.LegalName,  
--        Vm.MembershipNo,  
--        CreateCommissionAccount,  
--        St.State_ID AS StateId,  
--        Vm.PANVERIFICATION,  
--        Vm.TANVERIFICATION,  
--        Vm.GSTVERIFICATION,  
--        Vm.TaxType,  
--        Vm.Contact1,  
--        Vm.Contact2,  
--        Vm.Contact1IsMobile,  
--        Vm.Contact2IsMobile,  
--        Vm.IATACode,  
--        Vm.IATOCode,  
--        Vm.IsT,  
--        Vm.isFS,  
--        Vm.isGG,  
--        Vm.isChange,  
--        Vm.isH,  
--        Vm.isM,  
--        Vm.isMOT,  
--        Vm.isSEZ,  
--        Vm.isSS,  
--        Vm.BranchName,  
--        Vm.SWIFTCode,  
--        Vm.NonGSTRegistered  
--    FROM VendorMaster Vm  
--    LEFT JOIN City Ct WITH (NOLOCK) ON Vm.CityIATACode = Ct.IATACode  
--    LEFT JOIN [State] St WITH (NOLOCK) ON St.State_ID = Ct.State_IATACode  
--    LEFT JOIN Country Cn WITH (NOLOCK) ON Cn.IATACode = St.Country_IATACode  
--    LEFT JOIN State_Code_Master SC WITH (NOLOCK) ON SC.ID = Vm.StateCodeID  
--    LEFT JOIN LegalEntityType_Master LE ON Vm.LegalEntity = LE.LegalEntTypeID  
--    LEFT JOIN HotelGroups HG ON Vm.BizPartnerGrp = HG.IATACode  
--    WHERE  
--        (@VendorID IS NULL OR @VendorID = 0 OR Vm.VendorID = @VendorID)  
--        AND (@VendorName IS NULL OR @VendorName = '' OR EXISTS (  
--            SELECT 1 FROM STRING_SPLIT(@VendorName, '|') s  
--            WHERE s.value <> '' AND Vm.VendorName LIKE '%'+ s.value + '%'  
--        ))  
--  AND (@VendorCode IS NULL OR @VendorCode = '' OR EXISTS (  
--  SELECT 1 FROM STRING_SPLIT(@VendorCode, ',') s  
--   WHERE s.value <> '' AND Vm.VendorCode LIKE '%'+ s.value + '%'  
--     ))  
--        AND (@CityIATACode IS NULL OR @CityIATACode = '' OR EXISTS (  
--            SELECT 1 FROM STRING_SPLIT(@CityIATACode, ',') s  
--            WHERE s.value <> '' AND Vm.CityIATACode LIKE '%' + s.value + '%'  
--        ))  
--        AND (@StateCode IS NULL OR @StateCode = 0 OR Vm.StateCodeID = @StateCode)  
--        AND (@LegalName IS NULL OR @LegalName = '' OR EXISTS (  
--            SELECT 1 FROM STRING_SPLIT(@LegalName, ',') s  
--            WHERE s.value <> '' AND Vm.LegalName LIKE '%'+ s.value + '%'  
--        ))  
--        AND (@BizPartnerGrp IS NULL OR @BizPartnerGrp = '' OR EXISTS (  
--            SELECT 1 FROM STRING_SPLIT(@BizPartnerGrp, ',') s  
--            WHERE s.value <> '' AND Vm.BizPartnerGrp LIKE '%'+s.value + '%'  
--        ))  
--        AND (@Address IS NULL OR @Address = '' OR EXISTS (  
--            SELECT 1 FROM STRING_SPLIT(@Address, ',') s  
--            WHERE s.value <> '' AND Vm.Address LIKE'%'+ s.value + '%'  
--        ))  
--     AND (@PanNo IS NULL OR @PanNo = '' OR EXISTS (  
--            SELECT 1 FROM STRING_SPLIT(@PanNo, ',') s  
--            WHERE s.value <> '' AND Vm.PanNo LIKE'%'+ s.value + '%'  
--        ))  
--        AND (@TANDetails IS NULL OR @TANDetails = '' OR EXISTS (  
--            SELECT 1 FROM STRING_SPLIT(@TANDetails, ',') s  
--            WHERE s.value <> '' AND Vm.TANDetails LIKE '%'+s.value + '%'  
--        ))  
--        AND (@Country IS NULL OR @Country = '' OR EXISTS (  
--            SELECT 1 FROM STRING_SPLIT(@Country, ',') s  
--            WHERE s.value <> '' AND Cn.Name LIKE '%' + s.value + '%'  
--        ))  
--        AND (@State IS NULL OR @State = '' OR EXISTS (  
--            SELECT 1 FROM STRING_SPLIT(@State, ',') s  
--            WHERE s.value <> '' AND St.Name LIKE '%' + s.value + '%'  
--        ))  
--        AND (@City IS NULL OR @City = '' OR EXISTS (  
--            SELECT 1 FROM STRING_SPLIT(@City, ',') s  
--            WHERE s.value <> '' AND Ct.Name LIKE '%' + s.value + '%'  
--        ))  
--        AND (@Tax_Reg_Number IS NULL OR @Tax_Reg_Number = '' OR EXISTS (  
--            SELECT 1 FROM STRING_SPLIT(@Tax_Reg_Number, ',') s  
--            WHERE s.value <> '' AND @Tax_Reg_Number LIKE s.value + '%'  
--        ))  
--        AND (@TaxType IS NULL OR @TaxType = '' OR EXISTS (  
--            SELECT 1 FROM STRING_SPLIT(@TaxType, ',') s  
--            WHERE s.value <> '' AND Vm.TaxType LIKE '%' + s.value + '%'  
--        ))  
--  AND (@VendorSAPCode IS NULL OR @VendorSAPCode = '' OR EXISTS (  
--            SELECT 1 FROM STRING_SPLIT(@VendorSAPCode, ',') s  
--            WHERE s.value <> '' AND Vm.VendorSAPCode= @VendorSAPCode  
--        ))  
--) AS RowConstrainedResult  
--ORDER BY VendorID DESC  
  
  
-- SELECT @TotalRecordCount = count(*) FROM #TempReport                                                                    
--    IF @Row_Count = ''                                                                    
--     OR @Row_Count = - 1                                                                    
--    BEGIN                                                                    
--     SET @Row_Count = @TotalRecordCount                                                                    
--    END                                                                    
--    SELECT @SQL = 'select * from #TempReport                                                                                                                                   
--      ORDER BY VendorID DESC                                                                                                                                
--      OFFSET ' + CAST((@PageNumber * @Row_Count) AS VARCHAR(20)) + ' ROWS                                                                        
--      FETCH NEXT ' + CAST(@Row_Count AS VARCHAR(20)) + ' ROWS ONLY'                                                        
--    EXEC sys.sp_executesql @SQL                                         
--  --  -- select * from #TempReport                                        
--  select  CAST(@TotalRecordCount AS VARCHAR(20))  as Row_Count , '200' AS returnCode                                                                        
--      ,'Data Found' AS returnMessage                       
--  SELECT '200' AS returnCode          
--   ,'Data Found' AS returnMessage    

--   --  Add this for dropdown
--SELECT DISTINCT LE.LegalEntTypeID AS LegalEntityID, LE.LegalEntityType AS LegalEntityName
--FROM LegalEntityType_Master LE
--WHERE LE.IsActive = 1 -- optional filter
--ORDER BY LE.LegalEntityType ASC; 
--  end
--  ELSE IF @Action = 'USAP'
--BEGIN
--    update VendorMaster
--	set VendorCode = @VendorCode
--	where VendorID = @VendorID
--	  SELECT '200' AS returnCode            
--    ,'updated successfully.' AS returnMessage            
--    ,@VendorID AS ID    
--END
--ELSE IF @Action = 'USAP'  
--    BEGIN
--        -- New SAP Comp Code validation
--        IF @issapcompcode IS NULL OR @issapcompcode = 0
--        BEGIN
--            SELECT '202' AS returnCode,
--                   'SAP Comp code is mandatory to update Hotel Code.' AS returnMessage
--            RETURN
--        END

--        UPDATE VendorMaster  
--        SET VendorCode = @VendorCode,
--            issapcompcode = @issapcompcode  -- Ensure SAP flag is updated
--        WHERE VendorID = @VendorID  
--  set @VendorCode = (select VendorCode FROM VendorMaster Where VendorID = @VendorID)
--   SELECT '200' AS returnCode              
--    ,'updated successfully.' AS returnMessage              
--    ,@VendorID AS ID  
--end

ELSE IF @Action = 'USAP'  
BEGIN
    -- Optional: If VendorCode should be auto-generated when not supplied
    IF (@VendorCode IS NULL OR @VendorCode = '')
    BEGIN
     -- Proceed with update
    UPDATE VendorMaster  
    SET VendorCode = @VendorCode,
        issapcompcode = ISNULL(@issapcompcode, 0),
        Operation = 'UPDATE',
        UpdatedBy = @OperationBy,
        UpdatedOn = GETDATE()
    WHERE VendorID = @VendorID  
    
    -- Return success
    SELECT '200' AS returnCode,
           'Vendor code updated successfully.' AS returnMessage,
           @VendorID AS ID
END


    -- Always allow VendorCode update
    UPDATE VendorMaster  
    SET VendorCode = @VendorCode,
        issapcompcode = ISNULL(@issapcompcode, 0),
        Operation = 'UPDATE',
        UpdatedBy = @OperationBy,
        UpdatedOn = GETDATE()
    WHERE VendorID = @VendorID  
    
    -- Return success
    SELECT '200' AS returnCode,
           'Vendor code updated successfully.' AS returnMessage,
           @VendorID AS ID
END

------latest insterted / updated record should show on top
ELSE IF @Action = 'S'
BEGIN
    IF OBJECT_ID('TEMPDB..#TempReport') IS NOT NULL  
    DROP TABLE #TempReport; 

    SELECT * 
    INTO #TempReport
    FROM (
        SELECT 
             Vm.VendorID,  
        Vm.AccCode,  
        Vm.VendorCode,  
        Vm.VendorName,  
        Vm.AccountGroup,  
        Vm.CityIATACode,  
        Vm.Website,  
        Vm.PhoneNo,  
        Vm.MobileNo,  
        Vm.FaxNo,  
        Vm.EmailID,  
        Vm.PanNo,  
        Vm.STRegNo,  
        Vm.ChequeFavouring,  
        Vm.BankName,  
        Vm.[Address],  
        Vm.AccountNo,  
        Vm.CreateAdvanceAccount,  
        Vm.CreditApplicable,  
        Vm.CreditPeriod,  
        Vm.CreditCurrencyCode,  
        Vm.CreditAmount,  
        Vm.CreditApproveBy,  
        Vm.IsActive,  
        Vm.OperationBy,  
        Ct.Name AS CityName,  
        St.StateCodeID AS [StateCode],  
        St.Name AS StateName,  
        Cn.IATACode AS Country,  
        Cn.Name AS CountryName,  
        Vm.Comment,  
        Vm.IFSCCode,  
        Vm.VendorSAPCode,  
        Vm.GSTRequired,  
        Vm.isActiveSAP,  
        Vm.TANDetails,  
        Vm.PreviousCode,  
        Vm.MSME,  
        Vm.MSMEType,  
        Vm.Deductee,  
        Vm.WithHoldigTax,  
        Vm.XOSupplierNameLogic,  
        Vm.VendorSAPCode AS SAPCode,  
        Vm.PostalCode,  
        HG.IATACode AS BizPartnerGrp,  
        HG.Name AS BizPartnerGrpName,  
        LE.LegalEntTypeID AS LegalEntity,  
        Vm.LegalName,  
        Vm.MembershipNo,  
        CreateCommissionAccount,  
        St.State_ID AS StateId,  
        Vm.PANVERIFICATION,  
        Vm.TANVERIFICATION,  
        Vm.GSTVERIFICATION,  
        Vm.TaxType,  
        Vm.Contact1,  
        Vm.Contact2,  
        Vm.Contact1IsMobile,  
        Vm.Contact2IsMobile,  
        Vm.IATACode,  
        Vm.IATOCode,  
        Vm.IsT,  
        Vm.isFS,  
        Vm.isGG,  
        Vm.isChange,  
        Vm.isH,  
        Vm.isM,  
        Vm.isMOT,  
        Vm.isSEZ,  
        Vm.isSS,  
        Vm.BranchName,  
        Vm.SWIFTCode,  
        Vm.NonGSTRegistered  
    FROM VendorMaster Vm  
    LEFT JOIN City Ct WITH (NOLOCK) ON Vm.CityIATACode = Ct.IATACode  
    LEFT JOIN [State] St WITH (NOLOCK) ON St.State_ID = Ct.State_IATACode  
    LEFT JOIN Country Cn WITH (NOLOCK) ON Cn.IATACode = St.Country_IATACode  
    LEFT JOIN State_Code_Master SC WITH (NOLOCK) ON SC.ID = Vm.StateCodeID  
    LEFT JOIN LegalEntityType_Master LE ON Vm.LegalEntity = LE.LegalEntTypeID  
    LEFT JOIN HotelGroups HG ON Vm.BizPartnerGrp = HG.IATACode  
    WHERE  
        (@VendorID IS NULL OR @VendorID = 0 OR Vm.VendorID = @VendorID)  
        AND (@VendorName IS NULL OR @VendorName = '' OR EXISTS (  
            SELECT 1 FROM STRING_SPLIT(@VendorName, '|') s  
            WHERE s.value <> '' AND Vm.VendorName LIKE '%'+ s.value + '%'  
        ))  
  AND (@VendorCode IS NULL OR @VendorCode = '' OR EXISTS (  
  SELECT 1 FROM STRING_SPLIT(@VendorCode, ',') s  
   WHERE s.value <> '' AND Vm.VendorCode LIKE '%'+ s.value + '%'  
     ))  
        AND (@CityIATACode IS NULL OR @CityIATACode = '' OR EXISTS (  
            SELECT 1 FROM STRING_SPLIT(@CityIATACode, ',') s  
            WHERE s.value <> '' AND Vm.CityIATACode LIKE '%' + s.value + '%'  
        ))  
        AND (@StateCode IS NULL OR @StateCode = 0 OR Vm.StateCodeID = @StateCode)  
        AND (@LegalName IS NULL OR @LegalName = '' OR EXISTS (  
            SELECT 1 FROM STRING_SPLIT(@LegalName, ',') s  
            WHERE s.value <> '' AND Vm.LegalName LIKE '%'+ s.value + '%'  
        ))  
        AND (@BizPartnerGrp IS NULL OR @BizPartnerGrp = '' OR EXISTS (  
            SELECT 1 FROM STRING_SPLIT(@BizPartnerGrp, ',') s  
            WHERE s.value <> '' AND Vm.BizPartnerGrp LIKE '%'+s.value + '%'  
        ))  
        AND (@Address IS NULL OR @Address = '' OR EXISTS (  
            SELECT 1 FROM STRING_SPLIT(@Address, ',') s  
            WHERE s.value <> '' AND Vm.Address LIKE'%'+ s.value + '%'  
        ))  
     AND (@PanNo IS NULL OR @PanNo = '' OR EXISTS (  
            SELECT 1 FROM STRING_SPLIT(@PanNo, ',') s  
            WHERE s.value <> '' AND Vm.PanNo LIKE'%'+ s.value + '%'  
        ))  
        AND (@TANDetails IS NULL OR @TANDetails = '' OR EXISTS (  
            SELECT 1 FROM STRING_SPLIT(@TANDetails, ',') s  
            WHERE s.value <> '' AND Vm.TANDetails LIKE '%'+s.value + '%'  
        ))  
        AND (@Country IS NULL OR @Country = '' OR EXISTS (  
            SELECT 1 FROM STRING_SPLIT(@Country, ',') s  
            WHERE s.value <> '' AND Cn.Name LIKE '%' + s.value + '%'  
        ))  
        AND (@State IS NULL OR @State = '' OR EXISTS (  
            SELECT 1 FROM STRING_SPLIT(@State, ',') s  
            WHERE s.value <> '' AND St.Name LIKE '%' + s.value + '%'  
        ))  
        AND (@City IS NULL OR @City = '' OR EXISTS (  
            SELECT 1 FROM STRING_SPLIT(@City, ',') s  
            WHERE s.value <> '' AND Ct.Name LIKE '%' + s.value + '%'  
        ))  
        AND (@Tax_Reg_Number IS NULL OR @Tax_Reg_Number = '' OR EXISTS (  
            SELECT 1 FROM STRING_SPLIT(@Tax_Reg_Number, ',') s  
            WHERE s.value <> '' AND @Tax_Reg_Number LIKE s.value + '%'  
        ))  
        AND (@TaxType IS NULL OR @TaxType = '' OR EXISTS (  
            SELECT 1 FROM STRING_SPLIT(@TaxType, ',') s  
            WHERE s.value <> '' AND Vm.TaxType LIKE '%' + s.value + '%'  
        ))  
  AND (@VendorSAPCode IS NULL OR @VendorSAPCode = '' OR EXISTS (  
            SELECT 1 FROM STRING_SPLIT(@VendorSAPCode, ',') s  
            WHERE s.value <> '' AND Vm.VendorSAPCode= @VendorSAPCode  
        ))  
) AS RowConstrainedResult  
ORDER BY VendorID DESC  
  
  
 SELECT @TotalRecordCount = count(*) FROM #TempReport                                                                    
    IF @Row_Count = ''                                                                    
     OR @Row_Count = - 1                                                                    
    BEGIN                                                                    
     SET @Row_Count = @TotalRecordCount                                                                    
    END                                                                    
    SELECT @SQL = 'select * from #TempReport                                                                                                                                   
      ORDER BY VendorID DESC                                                                                                                                
      OFFSET ' + CAST((@PageNumber * @Row_Count) AS VARCHAR(20)) + ' ROWS                                                                        
      FETCH NEXT ' + CAST(@Row_Count AS VARCHAR(20)) + ' ROWS ONLY'                                                        
    EXEC sys.sp_executesql @SQL                                         
  --  -- select * from #TempReport                                        
  select  CAST(@TotalRecordCount AS VARCHAR(20))  as Row_Count , '200' AS returnCode                                                                        
      ,'Data Found' AS returnMessage                       
  SELECT '200' AS returnCode          
   ,'Data Found' AS returnMessage    

   --  Add this for dropdown
SELECT DISTINCT LE.LegalEntTypeID AS LegalEntityID, LE.LegalEntityType AS LegalEntityName
FROM LegalEntityType_Master LE
WHERE LE.IsActive = 1 -- optional filter
ORDER BY LE.LegalEntityType ASC; 
  end

ELSE IF @Action = 'F'  
BEGIN  
    SELECT   
        Vm.VendorID,  
        Vm.AccCode,  
        Vm.VendorCode,  
        Vm.VendorName,  
        Vm.AccountGroup,  
        Vm.CityIATACode,  
        Vm.Website,  
        Vm.PhoneNo,  
        Vm.MobileNo,  
        Vm.FaxNo,  
        Vm.EmailID,  
        Vm.PanNo,  
        Vm.STRegNo,  
        Vm.ChequeFavouring,  
        Vm.BankName,  
        Vm.[Address],  
        Vm.AccountNo,  
        Vm.CreateAdvanceAccount,  
        Vm.CreditApplicable,  
        Vm.CreditPeriod,  
        Vm.CreditCurrencyCode,  
        Vm.CreditAmount,  
        Vm.CreditApproveBy,  
        Vm.IsActive,  
        Vm.OperationBy,  
        Ct.Name AS CityName,  
        St.StateCodeID AS [StateCode],          St.Name AS StateName,  
        Cn.IATACode AS Country,  
        Cn.Name AS CountryName,  
        Vm.Comment,  
        Vm.IFSCCode,  
        Vm.VendorSAPCode,  
        Vm.GSTRequired,  
        Vm.isActiveSAP,  
        Vm.TANDetails,  
        Vm.PreviousCode,  
        Vm.MSME,  
        Vm.MSMEType,  
        Vm.Deductee,  
        Vm.WithHoldigTax,  
        Vm.XOSupplierNameLogic,  
        Vm.VendorSAPCode AS 'SAPCode',  
        Vm.PostalCode,  
        HG.IATACode AS BizPartnerGrp,  
        HG.Name AS BizPartnerGrpName,  
        LE.LegalEntTypeID AS LegalEntity,  
        Vm.LegalName,  
        Vm.MembershipNo,  
        CreateCommissionAccount,  
        St.State_ID AS StateId,  
        Vm.PANVERIFICATION,  
        Vm.TANVERIFICATION,  
        Vm.GSTVERIFICATION,  
        Vm.TaxType,  
        Vm.Contact1,  
        Vm.Contact2,  
        Vm.Contact1IsMobile,  
        Vm.Contact2IsMobile,  
        Vm.IATACode,  
        Vm.IATOCode,  
        Vm.IsT,  
        Vm.isFS,  
        Vm.isGG,  
        Vm.isChange,  
        Vm.isH,  
        Vm.isM,  
        Vm.isMOT,  
        Vm.isSEZ,  
        Vm.isSS,  
        Vm.BranchName,  
        Vm.SWIFTCode,  
        Vm.NonGSTRegistered  
    FROM VendorMaster Vm  
    LEFT JOIN City Ct WITH (NOLOCK) ON Vm.CityIATACode = Ct.IATACode  
    LEFT JOIN [State] St WITH (NOLOCK) ON St.State_ID = Ct.State_IATACode  
    LEFT JOIN Country Cn WITH (NOLOCK) ON Cn.IATACode = St.Country_IATACode  
    LEFT JOIN State_Code_Master SC WITH (NOLOCK) ON SC.ID = Vm.StateCodeID  
    LEFT JOIN LegalEntityType_Master LE ON Vm.LegalEntity = LE.LegalEntTypeID  
    LEFT JOIN HotelGroups HG ON Vm.BizPartnerGrp = HG.IATACode  
    WHERE  
        (@VendorID IS NULL OR @VendorID = 0 OR Vm.VendorID = @VendorID)  
        AND (@VendorName IS NULL OR @VendorName = '' OR EXISTS (  
            SELECT 1 FROM STRING_SPLIT(@VendorName, '|') s  
            WHERE s.value <> '' AND Vm.VendorName LIKE'%'+ s.value + '%'  
        ))  
        AND (@VendorCode IS NULL OR @VendorCode = '' OR EXISTS (  
            SELECT 1 FROM STRING_SPLIT(@VendorCode, ',') s  
            WHERE s.value <> '' AND Vm.VendorCode LIKE'%'+ s.value + '%'  
        ))  
  AND (@VendorSAPCode IS NULL OR @VendorSAPCode = '' OR EXISTS (  
            SELECT 1 FROM STRING_SPLIT(@VendorSAPCode, ',') s  
            WHERE s.value <> '' AND Vm.VendorSAPCode LIKE '%' +s.value + '%'  
        ))  
        AND (@CityIATACode IS NULL OR @CityIATACode = '' OR EXISTS (  
            SELECT 1 FROM STRING_SPLIT(@CityIATACode, ',') s  
            WHERE s.value <> '' AND Vm.CityIATACode LIKE '%' + s.value + '%'  
        ))  
        AND (@StateCode IS NULL OR @StateCode = 0 OR Vm.StateCodeID = @StateCode)  
        AND (@LegalName IS NULL OR @LegalName = '' OR EXISTS (  
            SELECT 1 FROM STRING_SPLIT(@LegalName, ',') s  
            WHERE s.value <> '' AND Vm.LegalName LIKE '%'+s.value + '%'  
        ))  
        AND (@BizPartnerGrp IS NULL OR @BizPartnerGrp = '' OR EXISTS (  
            SELECT 1 FROM STRING_SPLIT(@BizPartnerGrp, ',') s  
            WHERE s.value <> '' AND Vm.BizPartnerGrp  LIKE'%'+ s.value + '%'  
        ))  
        AND (@Address IS NULL OR @Address = '' OR EXISTS (  
            SELECT 1 FROM STRING_SPLIT(@Address, ',') s  
            WHERE s.value <> '' AND Vm.Address LIKE '%'+s.value + '%'  
        ))  
        AND (@PanNo IS NULL OR @PanNo = '' OR EXISTS (  
            SELECT 1 FROM STRING_SPLIT(@PanNo, ',') s  
            WHERE s.value <> '' AND Vm.PanNo LIKE'%'+ s.value + '%'  
        ))  
        AND (@TANDetails IS NULL OR @TANDetails = '' OR EXISTS (  
            SELECT 1 FROM STRING_SPLIT(@TANDetails, ',') s  
            WHERE s.value <> '' AND Vm.TANDetails LIKE '%'+ s.value + '%'  
        ))  
        AND (@Country IS NULL OR @Country = '' OR EXISTS (  
            SELECT 1 FROM STRING_SPLIT(@Country, ',') s  
            WHERE s.value <> '' AND Cn.Name LIKE '%' + s.value + '%'  
        ))  
        AND (@State IS NULL OR @State = '' OR EXISTS (  
            SELECT 1 FROM STRING_SPLIT(@State, ',') s  
            WHERE s.value <> '' AND St.Name LIKE '%' + s.value + '%'  
        ))  
        AND (@City IS NULL OR @City = '' OR EXISTS (  
            SELECT 1 FROM STRING_SPLIT(@City, ',') s  
            WHERE s.value <> '' AND Ct.Name LIKE '%' + s.value + '%'  
        ))  
        AND (@Tax_Reg_Number IS NULL OR @Tax_Reg_Number = '' OR EXISTS (  
            SELECT 1 FROM STRING_SPLIT(@Tax_Reg_Number, ',') s  
            WHERE s.value <> '' AND @Tax_Reg_Number LIKE'%'+ s.value + '%'  
        ))  
        AND (@TaxType IS NULL OR @TaxType = '' OR EXISTS (  
            SELECT 1 FROM STRING_SPLIT(@TaxType, ',') s  
            WHERE s.value <> '' AND TaxType LIKE '%' + s.value + '%'  
        ))  
    ORDER BY Vm.VendorID;  
END  
  
END 
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
﻿  
CREATE PROCEDURE [dbo].[usp_VendorMaster] (                                                      
 @AccCode VARCHAR(50) = NULL                                                      
 ,@VendorCode VARCHAR(50) = '0'                                                      
 ,@VendorName VARCHAR(200) = NULL                                                      
 ,@AccountGroup VARCHAR(10) = NULL                                                      
 ,@CityIATACode CHAR(3) = NULL                                                      
 ,@Website VARCHAR(200) = NULL                                                      
 ,@PhoneNo VARCHAR(35) = NULL                                                      
 ,@MobileNo VARCHAR(15) = NULL                                                      
 ,@FaxNo VARCHAR(35) = NULL                                                      
 ,@EmailID VARCHAR(200) = NULL                                                      
 ,@PanNo VARCHAR(50) = NULL                                                      
 ,@STRegNo VARCHAR(50) = NULL                                                      
 ,@ChequeFavouring VARCHAR(200) = NULL                                                      
 ,@BankName VARCHAR(200) = NULL                                                      
 ,@Address VARCHAR(MAX) = NULL                                                      
 ,@AccountNo VARCHAR(100) = NULL                                                      
 ,@CreateAdvanceAccount BIT = NULL                                                      
 ,@CreditApplicable BIT = NULL                                                      
 ,@CreditPeriod INT = NULL                                                      
 ,@CreditCurrencyCode VARCHAR(5) = NULL                                                      
 ,@CreditAmount DECIMAL(18, 5) = NULL                                                      
 ,@CreditApproveBy VARCHAR(100) = NULL                                                      
 ,@IsActive BIT = NULL                                                      
 ,@OperationBy UNIQUEIDENTIFIER = NULL                                                      
 ,@CreateCommissionAccount BIT = 0                                                      
 ,@BankAccountID INT = NULL                                                      
 ,@IsXML BIT = 0                                                      
 ,@IFSCCode VARCHAR(50) = NULL                                                      
 ,@SWIFTCode VARCHAR(50) = NULL                                                      
 ,@Comment VARCHAR(100) = NULL                                                      
 ,@BranchName VARCHAR(200) = NULL                                                      
 ,                                                      
 --@ErrMsg VARCHAR(50) OUT,                                                                      
 @VendorID INT = NULL                                                      
 ,@StateCode BIGINT = NULL                                                      
 ,@StateID INT = NULL                                                
 ,@GSTRequired BIT = 0                                                      
 ,@isActiveSAP BIT = 0                                                      
 ,@TANDetails VARCHAR(500) = NULL                                                      
 ,@PreviousCode VARCHAR(500) = NULL                                                      
 ,@MSME VARCHAR(500) = NULL                                                      
 ,@Deductee VARCHAR(500) = NULL                                                      
 ,@WithHoldigTax VARCHAR(500) = NULL                                                      
 ,@XOSupplierNameLogic BIT = NULL                                                      
 ,@isActiveMSME BIT = 0                                                      
 ,@MSMEType VARCHAR(20) = NULL                                                      
 ,@MSMERegFromDt DATETIME = NULL                       
 ,@MSMERegToDt DATETIME = NULL         
 ,@PostalCode VARCHAR(10) = NULL                                                      
 ,@BizPartnerGrp VARCHAR(300) = NULL                                                      
 ,@LegalEntity int = 0        
 ,@LegalEntTypeID int=0  
 ,@LegalName VARCHAR(80) = NULL                 
 ,@IsSEZ BIT = 0                                                      
 ,@MembershipNo VARCHAR(20) = NULL                                                   
 ,@NonGSTRegistered BIT = 0                                                      
,@isH BIT = 0                                                      
 ,@isT BIT = 0                                                      
 ,@isM BIT = 0                                                      
 ,@isSS BIT = 0                                                      
 ,@isGG BIT = 0                                                      
 ,@isMOT BIT = 0                                                      
 ,@isFS BIT = 0                                     
 ,@isChange BIT = 0                                                      
 ,@XOPrintName VARCHAR(80) = ''                               
 ,@Action CHAR(5) = ''                                                      
 ,@IATACode CHAR(3) = NULL                                                      
 ,@IATOCode CHAR(3) = NULL        ,                                            
 @PANVERIFICATION Varchar(20)= '',                                            
@TANVERIFICATION Varchar(20)= '',                                            
@GSTVERIFICATION Varchar(20)= ''   ,                                      
@VendorSAPCode VARCHAR(20) = '' ,                                
@Country VARCHAR(MAX)='',                                
@State VARCHAR(MAX)='',                                
@City  VARCHAR(MAX)=''                                     
   ,@TaxType NVARCHAR(20) = NULL                               
    ,@Tax_Reg_Number NVARCHAR(MAX) = ''                             
  ,@Contact1 varchar(50)=''                                                        
 ,@Contact2 varchar(50)=''                                                        
 ,@Contact1IsMobile bit=NULL                                                        
 ,@Contact2IsMobile bit=NULL       
,@Row_Count VARCHAR(max) = '10'            
 ,@PageNumber INT = 0     
  ,@issapcompcode BIT = NULL    
 )                                               
AS                                                      
BEGIN     
    
  DECLARE @TotalRecordCount INT            
  ,@SQL NVARCHAR(MAX);       
 IF @Action = 'I'                                                      
 BEGIN               
    
  --IF EXISTS (                                                              
  --  SELECT 1                                                              
  --  FROM VendorMaster                                                              
  --  WHERE UPPER(VendorCode) = UPPER(@VendorCode)                                                              
  --  )                                                              
  --BEGIN                                                              
  -- SELECT '201' AS returnCode                                                              
  --  ,'This data already exists. Please check and try again' AS returnMessage;                                                              
  -- RETURN;                                                      
  --END                                                              
  IF EXISTS (                                                      
    SELECT 1                                                      
    FROM VendorMaster                                                      
    WHERE LTRIM(UPPER(VendorName)) = LTRIM(UPPER(@VendorName))                                                      
    )                                                      
  BEGIN                                                      
   SELECT '201' AS returnCode                                                      
    ,'Vendor Name already exists. Please check and try again' AS returnMessage;                                                      
                                                  
   RETURN;                                                      
  END                                                      
                                                      
  -- Insert Logic                                                     
  INSERT INTO VendorMaster (                                               
   AccCode                                                      
   ,VendorCode                                      
   ,VendorName                                                      
   ,AccountGroup                                                      
   ,CityIATACode                                     
   ,Website                                                      
   ,PhoneNo                                                      
   ,MobileNo                                                      
   ,FaxNo                               
   ,EmailID                                                      
   ,PanNo                                                      
   ,STRegNo                                                      
   ,ChequeFavouring                                          
   ,BankName                                                      
   ,[Address]                                                      
   ,AccountNo                                                      
   ,CreateAdvanceAccount                                                      
   ,CreditApplicable                                                    
   ,CreditPeriod                                                      
   ,CreditCurrencyCode                                                      
  ,CreditAmount                                                      
   ,CreditApproveBy                      
   ,IsActive                                                      
   ,Operation                                                      
   ,OperationBy                                                      
   ,OperationOn                                                      
   ,CreateCommissionAccount                                      
   ,BankAccountID                                                      
   ,IsXML                                                      
   ,IFSCCode                                                      
   ,SWIFTCode                                                      
	,Comment                                                      
   ,BranchName                                                      
   ,StateCodeID                                                      
   ,GSTRequired                                                      
   ,isActiveSAP                                                      
   ,TANDetails                                                      
   ,PreviousCode                                                      
   ,MSME                                                      
   ,Deductee                                                      
   ,WithHoldingTax                                                      
   ,XOSupplierNameLogic                                                      
   ,isActiveMSME                                                      
   ,MSMEType                                                      
   ,MSMERegFromDt                                                      
   ,MSMERegToDt                                                      
   ,PostalCode                                                      
   ,BizPartnerGrp                                                      
   ,LegalEntity                                                      
   ,LegalName                                                      
   ,IsSEZ                                                      
   ,MembershipNo            
   ,NonGSTRegistered                                                      
   ,isH                                                      
   ,isT                                                      
   ,isM                                                      
   ,isSS             
   ,isGG                                                      
   ,isMOT                                                      
   ,isFS                                                      
   ,isChange       ,XOPrintName                                                      
   ,IATACode                                                      
   ,IATOCode         ,                                          
 PANVERIFICATION,                                            
 TANVERIFICATION,                                            
 GSTVERIFICATION,                              
 TaxType                              
 ,Tax_Reg_Number                            
 ,Contact1         
 ,Contact2                                                        
 ,Contact1IsMobile                                                        
 ,Contact2IsMobile      
 ,issapcompcode  
   )                                                      
  VALUES (                                                      
   @AccCode                                    
   ,@VendorCode                                                      
   ,@VendorName                                                      
   ,@AccountGroup                                                      
   ,@CityIATACode                                                      
   ,@Website                                                      
   ,@PhoneNo                                                
   ,@MobileNo                                                      
   ,@FaxNo                                                      
   ,@EmailID                                                   
   ,@PanNo                                                      
   ,@STRegNo                                                      
   ,@ChequeFavouring                                                      
   ,@BankName                                                    
   ,@Address                                                      
   ,@AccountNo                                                      
   ,@CreateAdvanceAccount                                                      
   ,@CreditApplicable                                                      
   ,@CreditPeriod                                                      
   ,@CreditCurrencyCode                                                      
,@CreditAmount                                                 
   ,@CreditApproveBy                                                      
   ,@IsActive                                                      
   ,'INSERT'                                                      
   ,@OperationBy                                                      
   ,GETDATE()                                                      
   ,@CreateCommissionAccount                                         ,@BankAccountID                                                      
   ,@IsXML                                                      
   ,@IFSCCode                                                      
   ,@SWIFTCode                       ,@Comment                                                      
   ,@BranchName                                                      
   ,@StateCode                                                      
   ,@GSTRequired                                                      
   ,@isActiveSAP                                                      
   ,@TANDetails                                                      
   ,@PreviousCode                                                      
   ,@MSME                                                      
   ,@Deductee                                                      
   ,@WithHoldigTax            
   ,@XOSupplierNameLogic                                                      
   ,@isActiveMSME                                        
   ,@MSMEType                                   
   ,@MSMERegFromDt                                                      
   ,@MSMERegToDt                                                      
   ,@PostalCode            
   ,@BizPartnerGrp                                                      
   --,@LegalEntity              
   ,@LegalEntTypeID  
   ,@LegalName                                                      
   ,@IsSEZ                                                      
   ,@MembershipNo                                                      
   ,@NonGSTRegistered                                                      
   ,@isH                                                      
   ,@isT                                                   
   ,@isM                                                      
   ,@isSS                                                      
   ,@isGG                                                      
   ,@isMOT                                                      
   ,@isFS                                                      
   ,@isChange                                                      
   ,@XOPrintName                                                      
   ,@IATACode                                                      
   ,@IATOCode     ,                                            
 @PANVERIFICATION,                                            
 @TANVERIFICATION,                                            
 @GSTVERIFICATION,                              
 @TaxType                              
  ,@Tax_Reg_Number                          
   ,@Contact1                                            
 ,@Contact2                                                        
 ,@Contact1IsMobile                                                        
 ,@Contact2IsMobile      
 ,@issapcompcode  
   );                                                      
                                                      
  --SET @VendorID = SCOPE_IDENTITY();                                                              
  select  @VendorID = @@IDENTITY                                                      
                                   

                                                      
  -- EXEC usp_InsertVendorMasterAuditDetails @VendorID, @VendorName, 'INSERT', @OperationBy;                                                    
  SELECT '200' AS returnCode                                                      
   ,'New record added successfully.' AS returnMessage, @VendorID as ID;       
 END                                                      
 ELSE IF @Action = 'U'                     
 BEGIN                                                      
 -- -- Update Logic                                                                      
 -- --IF EXISTS (                                                      
 -- --  SELECT 1                                                      
 -- --  FROM VendorMaster                           
 -- --  WHERE UPPER(VendorCode) = UPPER(@VendorCode)                                                      
 -- --   AND VendorID <> @VendorID                                                      
 -- --  )                                                      
 -- --BEGIN                                                      
 -- -- SELECT '201' AS returnCode                                                
 -- --  ,'This data already exists. Please check and try again' AS returnMessage;                                                      
                                                      
 --  RETURN;                                                      
 -- END                                                      
                                                      
  UPDATE VendorMaster                                                      
  SET AccCode = @AccCode                                                      
   --,VendorCode = @VendorCode                                                      
   ,VendorName = @VendorName                                          
   ,AccountGroup = @AccountGroup                  
   ,CityIATACode = @CityIATACode                                                      
   ,Website = @Website                                                      
   ,PhoneNo = @PhoneNo                                                      
   ,MobileNo = @MobileNo                                                      
   ,FaxNo = @FaxNo                                                      
   ,EmailID = @EmailID                                                      
   ,PanNo = @PanNo                                                      
   ,STRegNo = @STRegNo                                                
   ,ChequeFavouring = @ChequeFavouring                                                      
   ,BankName = @BankName                                                      
   ,[Address] = @Address                                                      
   ,AccountNo = @AccountNo                                                      
   ,CreateAdvanceAccount = @CreateAdvanceAccount                                                      
   ,CreditApplicable = @CreditApplicable                                                      
   ,CreditPeriod = @CreditPeriod                     
   ,CreditCurrencyCode = @CreditCurrencyCode                                                      
   ,CreditAmount = @CreditAmount                                                      
   ,CreditApproveBy = @CreditApproveBy                                                      
   ,IsActive = @IsActive                                                      
   ,Operation = 'UPDATE'                                                      
   ,UpdatedBy = @OperationBy                                                      
   ,UpdatedOn = GETDATE()                                                      
   ,CreateCommissionAccount = @CreateCommissionAccount                                                      
 ,BankAccountID = @BankAccountID                                                      
   ,IsXML = @IsXML                                                      
   ,IFSCCode = @IFSCCode                                                      
   ,SWIFTCode = @SWIFTCode                                                      
   ,Comment = @Comment                           
   ,BranchName = @BranchName                                                      
   ,StateCodeID = @StateCode                                                      
   ,GSTRequired = @GSTRequired                                                      
   ,isActiveSAP = @isActiveSAP                                                      
   ,TANDetails = @TANDetails                                                      
   ,PreviousCode = @PreviousCode                                                      
   ,MSME = @MSME                                                      
   ,Deductee = @Deductee                                                      
   ,WithHoldingTax = @WithHoldigTax                                       
   ,XOSupplierNameLogic = @XOSupplierNameLogic                                                      
   ,isActiveMSME = @isActiveMSME                                                
   ,MSMEType = @MSMEType                                                    
   ,MSMERegFromDt = @MSMERegFromDt                                                      
   ,MSMERegToDt = @MSMERegToDt                                                     
  ,PostalCode = @PostalCode                                                      
   ,BizPartnerGrp = @BizPartnerGrp                              
     ,Tax_Reg_Number = @Tax_Reg_Number                                
   --,LegalEntity = @LegalEntity    
   ,LegalEntity=@LegalEntTypeID  
   ,LegalName = @LegalName                                                      
   ,IsSEZ = @IsSEZ                                                      
   ,MembershipNo = @MembershipNo                                                      
   ,NonGSTRegistered = @NonGSTRegistered                                                      
   ,isH = @isH                                                      
   ,isT = @isT                                                      
   ,isM = @isM                                                      
   ,isSS = @isSS                                                 
   ,isGG = @isGG                                                      
   ,isMOT = @isMOT                                                      
   ,isFS = @isFS                                                      
   ,isChange = @isChange                                                      
   ,XOPrintName = @XOPrintName,                                             
 PANVERIFICATION = @PANVERIFICATION,                                            
 TANVERIFICATION = @TANVERIFICATION,                                            
 GSTVERIFICATION = @GSTVERIFICATION                              
 ,TaxType = @TaxType                             
 ,Contact1 = @Contact1                          
 ,Contact2 = @Contact2                                                        
 ,Contact1IsMobile = @Contact1IsMobile                                     
 ,Contact2IsMobile = @Contact2IsMobile     
 ,issapcompcode = @issapcompcode  
 ,IATACode = ISNULL(@IATACode,IATACode)            
 ,IATOCode = ISNULL(@IATOCode,IATOCode)            
  WHERE VendorID = @VendorID;       
                                                      
  --EXEC usp_InsertVendorMasterAuditDetails @VendorID, @VendorName, 'UPDATE', @OperationBy;                                                                      
  SELECT '200' AS returnCode                                                      
   ,'Record updated successfully.' AS returnMessage , @VendorID as ID ;                                                     
 END     
-- else if @Action ='S'    
-- SELECT     
--    Vm.VendorID,    
--    Vm.AccCode,    
--    Vm.VendorCode,    
--    Vm.VendorName,    
--    Vm.AccountGroup,    
--    Vm.CityIATACode,    
--    Vm.Website,    
--    Vm.PhoneNo,    
--    Vm.MobileNo,    
--    Vm.FaxNo,    
--    Vm.EmailID,    
--    Vm.PanNo,    
--    Vm.STRegNo,    
--    Vm.ChequeFavouring,    
--    Vm.BankName,    
--    Vm.[Address],    
--    Vm.AccountNo,    
--    Vm.CreateAdvanceAccount,    
--    Vm.CreditApplicable,    
--    Vm.CreditPeriod,    
--    Vm.CreditCurrencyCode,    
--    Vm.CreditAmount,    
--    Vm.CreditApproveBy,    
--    Vm.IsActive,    
--    Vm.OperationBy,    
--    Ct.Name AS CityName,    
--    St.StateCodeID AS [StateCode],    
--    St.Name AS StateName,    
--    Cn.IATACode AS Country,    
--    Cn.Name AS CountryName,    
--    Vm.Comment,    
--    Vm.IFSCCode,    
--    Vm.VendorSAPCode,    
--    Vm.GSTRequired,    
--    Vm.isActiveSAP,    
--    Vm.TANDetails,    
--    Vm.PreviousCode,    
--    Vm.MSME,    
--    Vm.MSMEType,    
--    Vm.Deductee,    
--    Vm.WithHoldigTax,    
--    Vm.XOSupplierNameLogic,    
--    Vm.VendorSAPCode AS 'SAPCode',    
--    Vm.PostalCode,    
--    HG.IATACode AS BizPartnerGrp,    
--    HG.Name AS BizPartnerGrpName,    
--    LE.LegalEntTypeID AS LegalEntity,    
--    Vm.LegalName,    
--    Vm.MembershipNo,    
--    CreateCommissionAccount,    
--    St.State_ID AS StateId,    
--    Vm.PANVERIFICATION,    
--    Vm.TANVERIFICATION,    
--    Vm.GSTVERIFICATION,    
--    Vm.TaxType,    
--    Vm.Contact1,    
--    Vm.Contact2,    
--    Vm.Contact1IsMobile,    
--    Vm.Contact2IsMobile,    
--    Vm.IATACode,    
--    Vm.IATOCode,    
--    Vm.IsT,    
--    Vm.isFS,    
--    Vm.isGG,    
--    Vm.isChange,    
--    Vm.isH,    
--    Vm.isM,    
--    Vm.isMOT,    
--    Vm.isSEZ,    
--    Vm.isSS,    
--    Vm.BranchName,    
--    Vm.SWIFTCode,    
--    Vm.NonGSTRegistered,    
    
--    -- Total count for pagination    
--    COUNT(*) OVER() AS TotalCount    
    
--FROM VendorMaster Vm    
--LEFT JOIN City Ct WITH (NOLOCK) ON Vm.CityIATACode = Ct.IATACode    
--LEFT JOIN [State] St WITH (NOLOCK) ON St.State_ID = Ct.State_IATACode    
--LEFT JOIN Country Cn WITH (NOLOCK) ON Cn.IATACode = St.Country_IATACode    
--LEFT JOIN State_Code_Master SC WITH (NOLOCK) ON SC.ID = Vm.StateCodeID    
--LEFT JOIN LegalEntityType_Master LE ON Vm.LegalEntity = LE.LegalEntTypeID    
--LEFT JOIN HotelGroups HG ON Vm.BizPartnerGrp = HG.IATACode    
    
--WHERE    
--    -- your filtering logic...    
--    (@VendorID IS NULL OR @VendorID = 0 OR Vm.VendorID = @VendorID)    
--    AND (@VendorName IS NULL OR @VendorName = '' OR EXISTS (    
--        SELECT 1 FROM STRING_SPLIT(@VendorName, '|') s    
--        WHERE s.value <> '' AND Vm.VendorName LIKE s.value + '%'    
--    ))    
--    -- ... continue all your filters ...    
    
--ORDER BY Vm.VendorID  -- or any consistent sortable column    
--OFFSET (@PageNumber - 1) * @PageSize ROWS    
--FETCH NEXT @PageSize ROWS ONLY    
    
-- ELSE IF @Action = 'EX'                                                      
-- BEGIN                                                      
--  SELECT     
--  --Vm.VendorID                                                      
--   Vm.AccCode                                                      
--   ,Vm.VendorCode                                                      
--   ,Vm.VendorName                                                      
--   ,Vm.AccountGroup                                                      
--   ,Vm.CityIATACode                                                      
--   ,Vm.Website                                                      
--   ,Vm.PhoneNo                                                      
--   ,Vm.MobileNo                                                      
--   ,Vm.FaxNo                
--   ,Vm.EmailID                                                      
--   ,Vm.PanNo                                                      
--   ,Vm.STRegNo                                                      
--   ,Vm.ChequeFavouring                                                      
--  -- ,Vm.BankAccountID AS BankName ,              
--   ,Vm.BankName              
--   ,Vm.[Address]                                                      
--   ,Vm.AccountNo                                                 
--   ,    
--   CASE     
-- WHEN Vm.CreateAdvanceAccount = 1 THEN 'Yes'    
-- When Vm.CreateAdvanceAccount  = 0 THEN 'No'    
-- END AS CreateAdvanceAccount      
--   ,    
--    CASE     
-- WHEN Vm.CreditApplicable = 1 THEN 'Yes'    
-- When Vm.CreditApplicable  = 0 THEN 'No'    
-- END AS CreditApplicable      
--   ,Vm.CreditPeriod                                                      
--   ,Vm.CreditCurrencyCode                                                      
--   ,Vm.CreditAmount                                                      
--   ,Vm.CreditApproveBy                                               
--   , --Vm.IsActive          
--    CASE     
-- WHEN Vm.IsActive = 1 THEN 'True'    
-- When Vm.IsActive  = 0 THEN 'False'    
-- END AS IsActive      
--   --,Vm.OperationBy                                                      
--   ,Ct.Name AS CityName                                                      
--   ,St.StateCodeID AS [StateCode]                                                     ,St.Name AS StateName                                                      
--   ,Cn.IATACode AS Country                                                      
--   ,Cn.Name AS CountryName                                                                                                                            
--   ,Vm.Website                                                      
--   ,Vm.Comment                  
--   ,Vm.IFSCCode                                                      
--   ,Vm.VendorSAPCode                                                      
--   ,--Vm.GSTRequired      
--    CASE     
-- WHEN Vm.GSTRequired   = 1 THEN 'Yes'    
-- When Vm.GSTRequired    = 0 THEN 'No'    
-- END AS GSTRequired        
--   ,--Vm.isActiveSAP       
--    CASE     
-- WHEN Vm.isActiveSAP   = 1 THEN 'Yes'    
-- When Vm.isActiveSAP    = 0 THEN 'No'    
-- END AS isActiveSAP     
--   ,Vm.TANDetails                                                      
--   ,Vm.PreviousCode                                                      
--   ,Vm.MSME                      
--   ,Vm.MSMEType            
--   ,Vm.Deductee                                                      
--   ,Vm.WithHoldigTax                                                      
--   ,--Vm.XOSupplierNameLogic    
--    CASE     
-- WHEN Vm.XOSupplierNameLogic   = 1 THEN 'Yes'    
-- When Vm.XOSupplierNameLogic    = 0 THEN 'No'    
-- END AS XOSupplierNameLogic     
--   ,Vm.VendorSAPCode AS 'SAPCode'                                                       
--   ,Vm.PostalCode                                                      
--   ,HG.IATACode AS BizPartnerGrp        
         
--   ,HG.Name  AS BizPartnerGrpName                                                                  
--  -- ,LE.LegalEntTypeID   AS LegalEntity                                                       
--   ,Vm.LegalName                                                     
--   --,LegalEntity                                                    
--   ,MembershipNo                                                     
--   -- ,LE.LegalEntTypeID                                         
-- ,--CreateCommissionAccount     
--  CASE     
-- WHEN CreateCommissionAccount   = 1 THEN 'Yes'    
-- When CreateCommissionAccount    = 0 THEN 'No'    
-- END AS CreateCommissionAccount ,                                              
---- St.State_ID AS StateId,                                              
-- vm.PANVERIFICATION,                                            
-- vm.TANVERIFICATION,                           
-- vm.GSTVERIFICATION,                              
-- VM.TaxType,                             
--  Contact1,                              
--        Contact2,                              
--        --Contact1IsMobile,                              
--        --Contact2IsMobile                         
--  -- ,PreviousCode                                                        
--   VM.IATACode                                                              
--  ,VM.IATOCode                
--  , --Vm.IsT     
--   CASE     
-- WHEN Vm.IsT   = 1 THEN 'Yes'    
-- When Vm.IsT    = 0 THEN 'No'    
-- END AS IsT     
--  ,--Vm.isFS    
--  CASE     
-- WHEN Vm.isFS   = 1 THEN 'Yes'    
-- When Vm.isFS    = 0 THEN 'No'    
-- END AS isFS ,              
--  --Vm.isGG     
--  CASE     
-- WHEN Vm.isGG   = 1 THEN 'Yes'    
-- When Vm.isGG    = 0 THEN 'No'    
-- END AS isGG     
--  ,--Vm.isChange      
--  CASE     
-- WHEN Vm.isChange   = 1 THEN 'Yes'    
-- When Vm.isChange    = 0 THEN 'No'    
-- END AS isChange     
--  ,--Vm.isH              
--  CASE     
-- WHEN Vm.isH   = 1 THEN 'Yes'    
-- When Vm.isH    = 0 THEN 'No'    
-- END AS isH     
--   ,--Vm.isM     
--   CASE     
-- WHEN Vm.isM   = 1 THEN 'Yes'    
-- When Vm.isM    = 0 THEN 'No'    
-- END AS isM     
-- ,--Vm.isMOT       
-- CASE     
-- WHEN Vm.isMOT   = 1 THEN 'Yes'    
-- When Vm.isMOT    = 0 THEN 'No'    
-- END AS isMOT     
--    ,--Vm.isSEZ      
-- CASE     
-- WHEN Vm.isSEZ   = 1 THEN 'Yes'    
-- When Vm.isSEZ    = 0 THEN 'No'    
-- END AS isSEZ     
--  ,--Vm.isSS    
--  CASE     
-- WHEN Vm.isSS   = 1 THEN 'Yes'    
-- When Vm.isSS    = 0 THEN 'No'    
-- END AS isSS ,              
--  Vm.BranchName,              
--  Vm.SWIFTCode ,          
--  --NonGSTRegistered     
--CASE     
-- WHEN NonGSTRegistered   = 1 THEN 'Yes'    
-- When NonGSTRegistered    = 0 THEN 'No'    
-- END AS NonGSTRegistered     
--  FROM VendorMaster Vm                                                      
--  LEFT JOIN City Ct WITH (NOLOCK) ON Vm.CityIATACode = Ct.IATACode                                                      
--  LEFT JOIN [State] St WITH (NOLOCK) ON St.State_ID = Ct.State_IATACode                                                      
--  LEFT JOIN Country Cn WITH (NOLOCK) ON Cn.IATACode = St.Country_IATACode                                                      
--  LEFT JOIN State_Code_Master SC WITH (NOLOCK) ON SC.ID = Vm.StateCodeID                                                      
--  LEFT JOIN LegalEntityType_Master LE ON Vm.LegalEntity = LE.LegalEntTypeID                                                      
--  LEFT JOIN HotelGroups HG ON Vm.BizPartnerGrp = HG.IATACode                                                      
--  WHERE (@VendorID IS NULL OR @VendorID = 0 OR Vm.VendorID = @VendorID)                                    
--AND (@VendorName IS NULL OR @VendorName = '' OR EXISTS (                                    
--      SELECT 1 FROM STRING_SPLIT(@VendorName, '|') s                                     
--      WHERE s.value <> ''                                     
--        AND Vm.VendorName LIKE  s.value + '%'                                    
--    ))                                
--AND (@VendorCode IS NULL OR @VendorCode = '' OR EXISTS (                                    
--      SELECT 1 FROM STRING_SPLIT(@VendorCode, ',') s                                     
--     WHERE s.value <> ''                                     
--        AND Vm.VendorCode LIKE  s.value + '%'                                    
--    ))                                                      
--AND (@CityIATACode IS NULL OR @CityIATACode = '' OR EXISTS (                                    
--      SELECT 1 FROM STRING_SPLIT(@CityIATACode, ',') s                                     
--      WHERE s.value <> ''                                     
--        AND Vm.CityIATACode LIKE '%' + s.value + '%'                                    
--    ))                                                      
--AND (@StateCode IS NULL OR @StateCode = 0 OR Vm.StateCodeID = @StateCode)                                                      
                                 
                                  
--AND (@LegalName IS NULL OR @LegalName = '' OR EXISTS (                                    
--      SELECT 1 FROM STRING_SPLIT(@LegalName, ',') s                                     
--      WHERE s.value <> ''                                     
--        AND Vm.LegalName LIKE s.value + '%'                                    
--    ))                                        
--AND (@BizPartnerGrp IS NULL OR @BizPartnerGrp = '' OR EXISTS (                                    
--      SELECT 1 FROM STRING_SPLIT(@BizPartnerGrp, ',') s                                     
--      WHERE s.value <> ''                
--        AND Vm.BizPartnerGrp LIKE  s.value + '%'                                    
--))                                        
--AND (@Address IS NULL OR @Address = '' OR EXISTS (                                    
--      SELECT 1 FROM STRING_SPLIT(@Address, ',') s                                     
--      WHERE s.value <> ''                                     
--        AND Vm.Address LIKE s.value + '%'                                    
--    ))                                       
----AND (@CreditApplicable IS NULL OR CreditApplicable = @CreditApplicable)                                    
----  AND (@CreditApplicable IS NULL OR Vm.CreditApplicable = @CreditApplicable)                                  
                                  
--AND (@PanNo IS NULL OR @PanNo = '' OR EXISTS (                                    
--      SELECT 1 FROM STRING_SPLIT(@PanNo, ',') s                                     
--      WHERE s.value <> ''                                     
--        AND Vm.PanNo LIKE  s.value + '%'                                    
--    ))                                        
--AND (@TANDetails IS NULL OR @TANDetails = '' OR EXISTS (                                    
--      SELECT 1 FROM STRING_SPLIT(@TANDetails, ',') s                                     
--      WHERE s.value <> ''                                     
--        AND Vm.TANDetails LIKE  s.value + '%'                                    
--    ))                               
-- AND  (@Country IS NULL OR @Country = '' OR EXISTS (                                    
--      SELECT 1 FROM STRING_SPLIT(@Country, ',') s                                     
--      WHERE s.value <> ''                                     
--        AND Cn.Name LIKE '%' + s.value + '%'                                    
--    ))                                  
-- AND  (@State IS NULL OR @State = '' OR EXISTS (                                    
--      SELECT 1 FROM STRING_SPLIT(@State, ',') s                                
--      WHERE s.value <> ''                                     
--        AND St.Name LIKE '%' + s.value + '%'                                    
--    ))                                   
-- AND  (@City IS NULL OR @City = '' OR EXISTS (                                    
--      SELECT 1 FROM STRING_SPLIT(@City, ',') s                                     
--      WHERE s.value <> ''                   
--        AND Ct.Name LIKE '%' + s.value + '%'                                    
--    ))                                  
--  AND (@Tax_Reg_Number IS NULL OR @Tax_Reg_Number = '' OR EXISTS (                                  
--      SELECT 1 FROM STRING_SPLIT(@Tax_Reg_Number, ',') s                                   
--      WHERE s.value <> ''                                   
--        AND @Tax_Reg_Number LIKE  s.value + '%'                                  
--    ))                                  
-- AND (@TaxType IS NULL OR @TaxType = '' OR EXISTS (                                  
--      SELECT 1 FROM STRING_SPLIT(@TaxType, ',') s                                   
--      WHERE s.value <> ''                                   
--        AND TaxType   LIKE '%' + s.value + '%'                                  
--    ))                                  
                                      
                      
-- order by 1 DESC                                                      
--   --SELECT '200' AS returnCode, 'Data Retrieved' AS returnMessage;                                                     
-- END                         
-- ELSE IF @Action = 'FS' ---- SAPCODE DROPDOWN FILTER                                      
-- BEGIN                                      
-- SELECT VendorSAPCode, VENDORID FROM VendorMaster                                      
-- WHERE (@VendorSAPCode = 0 OR @VendorSAPCode IS NULL OR VendorSAPCode LIKE '%' + @VendorSAPCode + '%')                                      
-- END                                                                            
-- ELSE IF @Action = 'FN' ---- VENDORNAME DROPDOWN FILTER                                      
-- BEGIN                                      
-- SELECT VendorName, VENDORID FROM VendorMaster                                      
-- WHERE (@VendorName = '' OR @VendorName IS NULL OR VendorName LIKE '%' + @VendorName + '%')                                      
--END                                      
                                       
-- ELSE IF @Action = 'FA' ---- ADDRESS DROPDOWN FILTER                                      
-- BEGIN                                      
-- SELECT Address, VENDORID FROM VendorMaster                                      
-- WHERE (@Address = '' OR @Address IS NULL OR Address LIKE '%' + @Address + '%')                                      
-- END                                      
                                      
-- ELSE IF @Action = 'FI' ---- ISACTIVE DROPDOWN FILTER                                      
-- BEGIN                                      
-- SELECT IsActive, VENDORID FROM VendorMaster                                      
-- WHERE (@IsActive IS NULL OR IsActive = @IsActive )                                      
-- END        
IF @PageNumber < 0     
BEGIN    
    SET @PageNumber = 0    
END    
    
IF @Row_Count <= 0     
BEGIN    
    SET @Row_Count = 10 -- Default page size    
END    
  
  
ELSE IF @Action = 'USAP'    
BEGIN  
  DECLARE @MaxNo_Str AS VARCHAR(8)                                                      
  DECLARE @SapID AS VARCHAR(10)                                                      
                                                      
  SET @MaxNo_Str = (                                                      
    SELECT SUBSTRING(MAX(VendorSAPCode), 3, LEN(MAX(VendorSAPCode)))                                                      
    FROM VendorMaster                                                      
    )                                                      
  SET @MaxNo_Str = CASE                                                       
    WHEN @MaxNo_Str IS NULL                                                      
     THEN '1'                             
    ELSE CAST(@MaxNo_Str AS INT) + 1                                                      
    END                                                      
  SET @SapID = 'CV' + REPLICATE('0', 8 - LEN(@MaxNo_Str)) + @MaxNo_Str                                                      
                                                      
  UPDATE VendorMaster                                                      
  SET VendorSAPCode = @SapID                              
  WHERE VendorID = @VendorID                                                      



    -- Optional: If VendorCode should be auto-generated when not supplied  
    IF (@VendorCode IS NULL OR @VendorCode = '')  
    BEGIN  
     -- Proceed with update  
    UPDATE VendorMaster    
    SET VendorCode = @VendorCode,  
        issapcompcode = ISNULL(@issapcompcode, 0),  
        Operation = 'UPDATE',  
        UpdatedBy = @OperationBy,  
        UpdatedOn = GETDATE()  
    WHERE VendorID = @VendorID    
      
    -- Return success  
    SELECT '200' AS returnCode,  
           'Vendor code updated successfully.' AS returnMessage,  
           @VendorID AS ID  
END  
  
  
    -- Always allow VendorCode update  
    UPDATE VendorMaster    
    SET VendorCode = @VendorCode,  
        issapcompcode = ISNULL(@issapcompcode, 0),  
        Operation = 'UPDATE',  
        UpdatedBy = @OperationBy,  
        UpdatedOn = GETDATE()  
    WHERE VendorID = @VendorID    
      
    -- Return success  
    SELECT '200' AS returnCode,  
           'Vendor code updated successfully.' AS returnMessage,  
           @VendorID AS ID  
END  
  
------latest insterted / updated record should show on top  
ELSE IF @Action = 'S'  
BEGIN  
    IF OBJECT_ID('TEMPDB..#TempReport') IS NOT NULL    
    DROP TABLE #TempReport;   
  
    SELECT *   
    INTO #TempReport  
    FROM (  
        SELECT   
             Vm.VendorID,    
        Vm.AccCode,    
        Vm.VendorCode,    
        Vm.VendorName,    
        Vm.AccountGroup,    
        Vm.CityIATACode,    
        Vm.Website,    
        Vm.PhoneNo,    
        Vm.MobileNo,    
        Vm.FaxNo,    
        Vm.EmailID,    
        Vm.PanNo,    
        Vm.STRegNo,    
        Vm.ChequeFavouring,    
        Vm.BankName,    
        Vm.[Address],    
        Vm.AccountNo,    
        Vm.CreateAdvanceAccount,    
        Vm.CreditApplicable,    
        Vm.CreditPeriod,    
        Vm.CreditCurrencyCode,    
        Vm.CreditAmount,    
        Vm.CreditApproveBy,    
        Vm.IsActive,    
        Vm.OperationBy,    
        Ct.Name AS CityName,    
        St.StateCodeID AS [StateCode],    
        St.Name AS StateName,    
        Cn.IATACode AS Country,    
        Cn.Name AS CountryName,    
        Vm.Comment,    
        Vm.IFSCCode,    
        Vm.VendorSAPCode,    
        Vm.GSTRequired,    
        Vm.isActiveSAP,    
        Vm.TANDetails,    
        Vm.PreviousCode,    
        Vm.MSME,    
        Vm.MSMEType,    
        Vm.Deductee,    
        Vm.WithHoldigTax,    
        Vm.XOSupplierNameLogic,    
        Vm.VendorSAPCode AS SAPCode,    
        Vm.PostalCode,    
        HG.IATACode AS BizPartnerGrp,    
        HG.Name AS BizPartnerGrpName,    
  LE.LegalEntTypeID AS LegalEntity,    
  LE.LegalEntTypeID AS LegalEntTypeID,  
        Vm.LegalName,    
        Vm.MembershipNo,    
        CreateCommissionAccount,    
        St.State_ID AS StateId,    
        Vm.PANVERIFICATION,    
        Vm.TANVERIFICATION,    
        Vm.GSTVERIFICATION,    
        Vm.TaxType,    
        Vm.Contact1,    
        Vm.Contact2,    
        Vm.Contact1IsMobile,    
        Vm.Contact2IsMobile,    
        Vm.IATACode,    
        Vm.IATOCode,    
        Vm.IsT,    
        Vm.isFS,    
        Vm.isGG,    
        Vm.isChange,    
        Vm.isH,    
        Vm.isM,    
        Vm.isMOT,    
        Vm.isSEZ,    
        Vm.isSS,    
        Vm.BranchName,    
        Vm.SWIFTCode,    
        Vm.NonGSTRegistered ,  
  VM.OperationOn
    FROM VendorMaster Vm    
    LEFT JOIN City Ct WITH (NOLOCK) ON Vm.CityIATACode = Ct.IATACode    
    LEFT JOIN [State] St WITH (NOLOCK) ON St.State_ID = Ct.State_IATACode    
    LEFT JOIN Country Cn WITH (NOLOCK) ON Cn.IATACode = St.Country_IATACode    
    LEFT JOIN State_Code_Master SC WITH (NOLOCK) ON SC.ID = Vm.StateCodeID    
    LEFT JOIN LegalEntityType_Master LE ON Vm.LegalEntity = LE.LegalEntTypeID    
    LEFT JOIN HotelGroups HG ON Vm.BizPartnerGrp = HG.IATACode    
    WHERE    
       (@IsActive IS NULL OR Vm.IsActive = @IsActive) AND (@CreditApplicable IS NULL OR Vm.CreditApplicable = @CreditApplicable)  AND  (@VendorID IS NULL OR @VendorID = 0 OR Vm.VendorID = @VendorID)    
        AND (@VendorName IS NULL OR @VendorName = '' OR EXISTS (    
            SELECT 1 FROM STRING_SPLIT(@VendorName, '|') s    
            WHERE s.value <> '' AND Vm.VendorName LIKE '%'+ s.value + '%'    
        ))    
  AND (@VendorCode IS NULL OR @VendorCode = '' OR EXISTS (    
  SELECT 1 FROM STRING_SPLIT(@VendorCode, ',') s    
   WHERE s.value <> '' AND Vm.VendorCode LIKE '%'+ s.value + '%'    
     ))    
        AND (@CityIATACode IS NULL OR @CityIATACode = '' OR EXISTS (    
            SELECT 1 FROM STRING_SPLIT(@CityIATACode, ',') s    
            WHERE s.value <> '' AND Vm.CityIATACode LIKE '%' + s.value + '%'    
        ))    
        AND (@StateCode IS NULL OR @StateCode = 0 OR Vm.StateCodeID = @StateCode)    
        AND (@LegalName IS NULL OR @LegalName = '' OR EXISTS (    
            SELECT 1 FROM STRING_SPLIT(@LegalName, ',') s    
            WHERE s.value <> '' AND Vm.LegalName LIKE '%'+ s.value + '%'    
        ))    
        AND (@BizPartnerGrp IS NULL OR @BizPartnerGrp = '' OR EXISTS (    
            SELECT 1 FROM STRING_SPLIT(@BizPartnerGrp, ',') s    
            WHERE s.value <> '' AND Vm.BizPartnerGrp LIKE '%'+s.value + '%'    
        ))    
        AND (@Address IS NULL OR @Address = '' OR EXISTS (    
            SELECT 1 FROM STRING_SPLIT(@Address, ',') s    
            WHERE s.value <> '' AND Vm.Address LIKE'%'+ s.value + '%'    
        ))    
     AND (@PanNo IS NULL OR @PanNo = '' OR EXISTS (    
            SELECT 1 FROM STRING_SPLIT(@PanNo, ',') s    
            WHERE s.value <> '' AND Vm.PanNo LIKE'%'+ s.value + '%'    
        ))    
        AND (@TANDetails IS NULL OR @TANDetails = '' OR EXISTS (    
            SELECT 1 FROM STRING_SPLIT(@TANDetails, ',') s    
            WHERE s.value <> '' AND Vm.TANDetails LIKE '%'+s.value + '%'    
        ))    
        AND (@Country IS NULL OR @Country = '' OR EXISTS (    
            SELECT 1 FROM STRING_SPLIT(@Country, ',') s    
            WHERE s.value <> '' AND Cn.Name LIKE '%' + s.value + '%'    
        ))    
        AND (@State IS NULL OR @State = '' OR EXISTS (    
            SELECT 1 FROM STRING_SPLIT(@State, ',') s    
            WHERE s.value <> '' AND St.Name LIKE '%' + s.value + '%'    
        ))    
        AND (@City IS NULL OR @City = '' OR EXISTS (    
            SELECT 1 FROM STRING_SPLIT(@City, ',') s    
            WHERE s.value <> '' AND Ct.Name LIKE '%' + s.value + '%'    
        ))    
        AND (@Tax_Reg_Number IS NULL OR @Tax_Reg_Number = '' OR EXISTS (    
            SELECT 1 FROM STRING_SPLIT(@Tax_Reg_Number, ',') s    
            WHERE s.value <> '' AND @Tax_Reg_Number LIKE s.value + '%'    
        ))    
        AND (@TaxType IS NULL OR @TaxType = '' OR EXISTS (    
            SELECT 1 FROM STRING_SPLIT(@TaxType, ',') s    
            WHERE s.value <> '' AND Vm.TaxType LIKE '%' + s.value + '%'    
        ))    
  AND (@VendorSAPCode IS NULL OR @VendorSAPCode = '' OR EXISTS (    
            SELECT 1 FROM STRING_SPLIT(@VendorSAPCode, ',') s    
            WHERE s.value <> '' AND Vm.VendorSAPCode= @VendorSAPCode    
        ))    
) AS RowConstrainedResult    
ORDER BY OperationOn DESC    
    
    
 SELECT @TotalRecordCount = count(*) FROM #TempReport                                                                      
    IF @Row_Count = ''                                                                      
     OR @Row_Count = - 1                                                                      
    BEGIN                                                                      
     SET @Row_Count = @TotalRecordCount                                                                      
    END                                                                      
    SELECT @SQL = 'select * from #TempReport                                                                                                                                     
      ORDER BY VendorID DESC                                                                                                                                  
      OFFSET ' + CAST((@PageNumber * @Row_Count) AS VARCHAR(20)) + ' ROWS                                                                          
      FETCH NEXT ' + CAST(@Row_Count AS VARCHAR(20)) + ' ROWS ONLY'                                                          
    EXEC sys.sp_executesql @SQL                                           
  --  -- select * from #TempReport                                          
  select  CAST(@TotalRecordCount AS VARCHAR(20))  as Row_Count , '200' AS returnCode                                                                          
      ,'Data Found' AS returnMessage                         
  SELECT '200' AS returnCode            
   ,'Data Found' AS returnMessage      
  
   --  Add this for dropdown  
SELECT DISTINCT LE.LegalEntTypeID AS LegalEntityID, LE.LegalEntityType AS LegalEntityName  
FROM LegalEntityType_Master LE  
WHERE LE.IsActive = 1 -- optional filter  
ORDER BY LE.LegalEntityType ASC;   
  end  
  
ELSE IF @Action = 'F'    
BEGIN    
    SELECT     
        Vm.VendorID,    
        Vm.AccCode,    
        Vm.VendorCode,    
        Vm.VendorName,    
        Vm.AccountGroup,    
        Vm.CityIATACode,    
        Vm.Website,    
        Vm.PhoneNo,    
        Vm.MobileNo,    
        Vm.FaxNo,    
        Vm.EmailID,    
        Vm.PanNo,    
        Vm.STRegNo,    
        Vm.ChequeFavouring,    
        Vm.BankName,    
        Vm.[Address],    
        Vm.AccountNo,    
        Vm.CreateAdvanceAccount,    
        Vm.CreditApplicable,    
        Vm.CreditPeriod,    
        Vm.CreditCurrencyCode,    
        Vm.CreditAmount,    
        Vm.CreditApproveBy,    
        Vm.IsActive,    
        Vm.OperationBy,    
        Ct.Name AS CityName,    
        St.StateCodeID AS [StateCode],          St.Name AS StateName,    
        Cn.IATACode AS Country,    
        Cn.Name AS CountryName,    
        Vm.Comment,    
        Vm.IFSCCode,    
        Vm.VendorSAPCode,    
        Vm.GSTRequired,    
        Vm.isActiveSAP,    
        Vm.TANDetails,    
        Vm.PreviousCode,    
        Vm.MSME,    
        Vm.MSMEType,    
        Vm.Deductee,    
        Vm.WithHoldigTax,    
        Vm.XOSupplierNameLogic,    
        Vm.VendorSAPCode AS 'SAPCode',    
        Vm.PostalCode,    
        HG.IATACode AS BizPartnerGrp,    
        HG.Name AS BizPartnerGrpName,    
        LE.LegalEntTypeID AS LegalEntity,    
  LE.LegalEntTypeID AS LegalEntTypeID,  
        Vm.LegalName,    
        Vm.MembershipNo,    
        CreateCommissionAccount,    
        St.State_ID AS StateId,    
        Vm.PANVERIFICATION,    
        Vm.TANVERIFICATION,    
        Vm.GSTVERIFICATION,    
        Vm.TaxType,    
        Vm.Contact1,    
        Vm.Contact2,    
        Vm.Contact1IsMobile,    
        Vm.Contact2IsMobile,    
        Vm.IATACode,    
        Vm.IATOCode,    
        Vm.IsT,    
        Vm.isFS,    
        Vm.isGG,    
        Vm.isChange,    
        Vm.isH,    
        Vm.isM,    
        Vm.isMOT,    
        Vm.isSEZ,    
        Vm.isSS,    
        Vm.BranchName,    
        Vm.SWIFTCode,    
        Vm.NonGSTRegistered,  
  Vm.IsActive,  
  Vm.CreditApplicable  
    FROM VendorMaster Vm    
    LEFT JOIN City Ct WITH (NOLOCK) ON Vm.CityIATACode = Ct.IATACode    
    LEFT JOIN [State] St WITH (NOLOCK) ON St.State_ID = Ct.State_IATACode    
    LEFT JOIN Country Cn WITH (NOLOCK) ON Cn.IATACode = St.Country_IATACode    
    LEFT JOIN State_Code_Master SC WITH (NOLOCK) ON SC.ID = Vm.StateCodeID    
    LEFT JOIN LegalEntityType_Master LE ON Vm.LegalEntity = LE.LegalEntTypeID    
    LEFT JOIN HotelGroups HG ON Vm.BizPartnerGrp = HG.IATACode    
    --WHERE    
    --    (@VendorID IS NULL OR @VendorID = 0 OR Vm.VendorID = @VendorID)    
  --      AND (@VendorName IS NULL OR @VendorName = '' OR EXISTS (    
  --          SELECT 1 FROM STRING_SPLIT(@VendorName, '|') s    
  --          WHERE s.value <> '' AND Vm.VendorName LIKE'%'+ s.value + '%'    
  --      ))    
  --      AND (@VendorCode IS NULL OR @VendorCode = '' OR EXISTS (    
  --          SELECT 1 FROM STRING_SPLIT(@VendorCode, ',') s    
  --          WHERE s.value <> '' AND Vm.VendorCode LIKE'%'+ s.value + '%'    
  --      ))    
  --AND (@VendorSAPCode IS NULL OR @VendorSAPCode = '' OR EXISTS (    
  --          SELECT 1 FROM STRING_SPLIT(@VendorSAPCode, ',') s    
  --          WHERE s.value <> '' AND Vm.VendorSAPCode LIKE '%' +s.value + '%'    
  --      ))    
  --      AND (@CityIATACode IS NULL OR @CityIATACode = '' OR EXISTS (    
  --          SELECT 1 FROM STRING_SPLIT(@CityIATACode, ',') s    
  --          WHERE s.value <> '' AND Vm.CityIATACode LIKE '%' + s.value + '%'    
  --      ))    
  --      AND (@StateCode IS NULL OR @StateCode = 0 OR Vm.StateCodeID = @StateCode)    
  --      AND (@LegalName IS NULL OR @LegalName = '' OR EXISTS (    
  --          SELECT 1 FROM STRING_SPLIT(@LegalName, ',') s    
  --          WHERE s.value <> '' AND Vm.LegalName LIKE '%'+s.value + '%'    
  --      ))    
  --      AND (@BizPartnerGrp IS NULL OR @BizPartnerGrp = '' OR EXISTS (    
  --          SELECT 1 FROM STRING_SPLIT(@BizPartnerGrp, ',') s    
  --          WHERE s.value <> '' AND Vm.BizPartnerGrp  LIKE'%'+ s.value + '%'    
  --      ))    
  --      AND (@Address IS NULL OR @Address = '' OR EXISTS (    
  --          SELECT 1 FROM STRING_SPLIT(@Address, ',') s    
  --          WHERE s.value <> '' AND Vm.Address LIKE '%'+s.value + '%'    
  --      ))    
  --      AND (@PanNo IS NULL OR @PanNo = '' OR EXISTS (    
  --          SELECT 1 FROM STRING_SPLIT(@PanNo, ',') s    
  --          WHERE s.value <> '' AND Vm.PanNo LIKE'%'+ s.value + '%'    
  --      ))    
  --      AND (@TANDetails IS NULL OR @TANDetails = '' OR EXISTS (    
  --          SELECT 1 FROM STRING_SPLIT(@TANDetails, ',') s    
  --          WHERE s.value <> '' AND Vm.TANDetails LIKE '%'+ s.value + '%'    
  --      ))    
  --      AND (@Country IS NULL OR @Country = '' OR EXISTS (    
  --          SELECT 1 FROM STRING_SPLIT(@Country, ',') s    
  --          WHERE s.value <> '' AND Cn.Name LIKE '%' + s.value + '%'    
  --      ))    
  --      AND (@State IS NULL OR @State = '' OR EXISTS (    
  --          SELECT 1 FROM STRING_SPLIT(@State, ',') s    
  --          WHERE s.value <> '' AND St.Name LIKE '%' + s.value + '%'    
  --      ))    
  --      AND (@City IS NULL OR @City = '' OR EXISTS (    
  --          SELECT 1 FROM STRING_SPLIT(@City, ',') s    
  --          WHERE s.value <> '' AND Ct.Name LIKE '%' + s.value + '%'    
  --      ))    
  --      AND (@Tax_Reg_Number IS NULL OR @Tax_Reg_Number = '' OR EXISTS (    
  --          SELECT 1 FROM STRING_SPLIT(@Tax_Reg_Number, ',') s    
  --          WHERE s.value <> '' AND @Tax_Reg_Number LIKE'%'+ s.value + '%'    
  --      ))    
  --      AND (@TaxType IS NULL OR @TaxType = '' OR EXISTS (    
  --          SELECT 1 FROM STRING_SPLIT(@TaxType, ',') s    
  --          WHERE s.value <> '' AND TaxType LIKE '%' + s.value + '%'    
  --      ))    
  --AND (@CreditApplicable IS NULL OR @CreditApplicable = '' OR EXISTS (    
  --          SELECT 1 FROM STRING_SPLIT(@CreditApplicable, ',') s    
  --          WHERE s.value <> '' AND @CreditApplicable LIKE '%' + s.value + '%'    
  --      ))    
  --AND (@IsActive IS NULL OR @IsActive = '' OR EXISTS (    
  --          SELECT 1 FROM STRING_SPLIT(@IsActive, ',') s    
  --          WHERE s.value <> '' AND @IsActive LIKE '%' + s.value + '%'    
  --      ))    
  AND (@CreditApplicable IS NULL OR Vm.CreditApplicable = @CreditApplicable)  
AND (@IsActive IS NULL OR Vm.IsActive = @IsActive)  
  
-- Complete corrected WHERE clause for Action = 'F':  
WHERE    
    (@VendorID IS NULL OR @VendorID = 0 OR Vm.VendorID = @VendorID)    
    AND (@VendorName IS NULL OR @VendorName = '' OR EXISTS (    
        SELECT 1 FROM STRING_SPLIT(@VendorName, '|') s    
        WHERE s.value <> '' AND Vm.VendorName LIKE'%'+ s.value + '%'    
    ))    
    AND (@VendorCode IS NULL OR @VendorCode = '' OR EXISTS (    
        SELECT 1 FROM STRING_SPLIT(@VendorCode, ',') s    
        WHERE s.value <> '' AND Vm.VendorCode LIKE'%'+ s.value + '%'    
    ))    
    AND (@VendorSAPCode IS NULL OR @VendorSAPCode = '' OR EXISTS (    
        SELECT 1 FROM STRING_SPLIT(@VendorSAPCode, ',') s    
        WHERE s.value <> '' AND Vm.VendorSAPCode LIKE '%' +s.value + '%'    
    ))    
    AND (@CityIATACode IS NULL OR @CityIATACode = '' OR EXISTS (    
        SELECT 1 FROM STRING_SPLIT(@CityIATACode, ',') s    
        WHERE s.value <> '' AND Vm.CityIATACode LIKE '%' + s.value + '%'    
    ))    
    AND (@StateCode IS NULL OR @StateCode = 0 OR Vm.StateCodeID = @StateCode)    
    AND (@LegalName IS NULL OR @LegalName = '' OR EXISTS (    
        SELECT 1 FROM STRING_SPLIT(@LegalName, ',') s    
        WHERE s.value <> '' AND Vm.LegalName LIKE '%'+s.value + '%'    
    ))    
    AND (@BizPartnerGrp IS NULL OR @BizPartnerGrp = '' OR EXISTS (    
        SELECT 1 FROM STRING_SPLIT(@BizPartnerGrp, ',') s    
        WHERE s.value <> '' AND Vm.BizPartnerGrp  LIKE'%'+ s.value + '%'    
    ))    
    AND (@Address IS NULL OR @Address = '' OR EXISTS (    
        SELECT 1 FROM STRING_SPLIT(@Address, ',') s    
        WHERE s.value <> '' AND Vm.Address LIKE '%'+s.value + '%'    
    ))    
    AND (@PanNo IS NULL OR @PanNo = '' OR EXISTS (    
        SELECT 1 FROM STRING_SPLIT(@PanNo, ',') s    
        WHERE s.value <> '' AND Vm.PanNo LIKE'%'+ s.value + '%'    
    ))    
    AND (@TANDetails IS NULL OR @TANDetails = '' OR EXISTS (    
        SELECT 1 FROM STRING_SPLIT(@TANDetails, ',') s    
        WHERE s.value <> '' AND Vm.TANDetails LIKE '%'+ s.value + '%'    
    ))    
    AND (@Country IS NULL OR @Country = '' OR EXISTS (    
        SELECT 1 FROM STRING_SPLIT(@Country, ',') s    
        WHERE s.value <> '' AND Cn.Name LIKE '%' + s.value + '%'    
    ))    
    AND (@State IS NULL OR @State = '' OR EXISTS (    
        SELECT 1 FROM STRING_SPLIT(@State, ',') s    
        WHERE s.value <> '' AND St.Name LIKE '%' + s.value + '%'    
    ))    
    AND (@City IS NULL OR @City = '' OR EXISTS (    
        SELECT 1 FROM STRING_SPLIT(@City, ',') s    
        WHERE s.value <> '' AND Ct.Name LIKE '%' + s.value + '%'    
    ))    
    AND (@Tax_Reg_Number IS NULL OR @Tax_Reg_Number = '' OR EXISTS (    
        SELECT 1 FROM STRING_SPLIT(@Tax_Reg_Number, ',') s    
        WHERE s.value <> '' AND @Tax_Reg_Number LIKE'%'+ s.value + '%'    
    ))    
    AND (@TaxType IS NULL OR @TaxType = '' OR EXISTS (    
        SELECT 1 FROM STRING_SPLIT(@TaxType, ',') s    
        WHERE s.value <> '' AND TaxType LIKE '%' + s.value + '%'    
    ))    
    -- FIXED: Corrected filtering for Credit Applicable and Active  
    AND (@CreditApplicable IS NULL OR Vm.CreditApplicable = @CreditApplicable)  
    AND (@IsActive IS NULL OR Vm.IsActive = @IsActive)  
    ORDER BY Vm.VendorID;    
END    
    
<<<<<<< HEAD
END   
>>>>>>> dev
=======
END   
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

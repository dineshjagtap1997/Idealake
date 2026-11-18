ALTER PROCEDURE [dbo].[usp_Hotel_Master]        
(        
@HotelID INT = NULL                  
 ,@AccCode VARCHAR(50) = NULL                  
 ,@HotelCode VARCHAR(50) = NULL                  
 ,@HotelName VARCHAR(200) = NULL                  
 ,@HotelRatingID INT = NULL                  
 ,@HotelChainID INT = NULL                  
 ,@ChainIATACode CHAR(3) = NULL                  
 ,@ReuseAllocation BIT = NULL                  
 ,@CityIATACode CHAR(3) = NULL                  
 ,@Website VARCHAR(200) = NULL                  
 ,@ZoneID INT = NULL                  
 ,@PhoneNo VARCHAR(35) = NULL                  
 ,@MobileNo VARCHAR(15) = NULL                  
 ,@FaxNo VARCHAR(35) = NULL                  
 ,@EmailID VARCHAR(200) = NULL                  
 ,@PanNo VARCHAR(50) = NULL                  
 ,@STRegNo VARCHAR(50) = NULL                  
 ,@ChequeFavouring VARCHAR(200) = NULL                  
 ,@BankName VARCHAR(200) = NULL                  
 ,@Address VARCHAR(max) = NULL                  
 ,@AccountNo VARCHAR(100) = NULL                  
 ,@CreateAdvanceAccount BIT = NULL                  
 ,@CreditApplicable BIT = NULL                  
 ,@CreditPeriod INT = NULL                  
 ,@CreditCurrencyCode VARCHAR(5) = NULL                  
 ,@CreditAmount DECIMAL(18, 5) = NULL                  
 ,@CreditApproveBy VARCHAR(100) = NULL                  
 ,@InfantFromAge INT = NULL                  
 ,@InfantToAge INT = NULL                  
 ,@ChildFromAge INT = NULL                  
 ,@ChildToAge INT = NULL                  
 ,@AdultFromAge INT = NULL                  
 ,@AdultToAge INT = NULL                  
 ,@IsActive BIT = NULL                  
 ,@OperationBy UNIQUEIDENTIFIER = NULL                  
 ,@Latitude VARCHAR(max) = NULL                  
 ,@Longitude VARCHAR(max) = NULL                  
 ,@CreateCommissionAccount BIT = 0                  
 ,@BankAccountID INT = NULL                  
 ,@HotelTypeID INT = NULL                  
 ,@BranchName VARCHAR(200) = NULL                  
 ,@IFSCCode VARCHAR(50) = NULL                  
 ,-- below added by sanket @ 05/11/2014                                                  
 @SWIFTCode VARCHAR(50) = NULL                  
 ,@Comment VARCHAR(100) = NULL                  
 ,@ErrMsg VARCHAR(50) = NULL                  
 ,@StateCode BIGINT = NULL                  
 ,@SupplierID VARCHAR(5) = NULL                  
 ,@CompanyID INT = NULL                  
 ,@GSTNID VARCHAR(20) = NULL                  
 ,@LegalName VARCHAR(200) = NULL                  
 ,@BTCBranchPosting INT = 0                  
 ,--dhvani @11212019                                                                                                          
 @GSTRequired BIT = NULL                  
 ,@isActiveSAP BIT = NULL                  
 ,@TANDetails VARCHAR(500) = NULL                  
 ,@PreviousCode VARCHAR(500) = NULL                  
 ,@MSME VARCHAR(500) = NULL                  
 ,@Deductee VARCHAR(500) = NULL                  
 ,@WithHoldigTax VARCHAR(500) = NULL                  
 ,@RoomCount VARCHAR(10) = NULL                  
 ,@isActiveMSME BIT = 0                  
 ,@MSMEType VARCHAR(20) = NULL                  
 ,@MSMERegFromDt DATETIME = NULL                  
 ,@MSMERegToDt DATETIME = NULL                  
 ,@PostalCode VARCHAR(10) = NULL                  
 ,@LegalEntity INT = NULL                  
 ,@IsSEZ BIT = 0                  
 ,@MembershipNo VARCHAR(30) = NULL                  
 ,@NonGSTRegistered BIT = 0                  
 ,@PayMode BIT = 0                  
 ,@Action CHAR(5) = ''                  
 ,@Page INT = 1                  
 ,@Country VARCHAR(500) = ''                  
 ,@State VARCHAR(500) = NULL                  
 ,@City VARCHAR(500) = ''                  
 ,@Beneficiary_Name VARCHAR(max) = ''                  
 ,@Tax_Reg_Number NVARCHAR(MAX) = ''                  
 ,@EmailGeneral NVARCHAR(MAX) = ''                  
 ,@EmailFinance NVARCHAR(MAX) = ''                  
 ,@Country_IATACode CHAR(10) = ''                  
 ,@Contact1 VARCHAR(50) = ''                  
 ,@Contact2 VARCHAR(50) = ''                  
 ,@Contact1IsMobile BIT = NULL                  
 ,@Contact2IsMobile BIT = NULL                  
 ,@Row_Count VARCHAR(max) = '10'                  
 ,@PageNumber INT = 0                  
 ,@HotelGroupID INT = 0                  
 ,@TaxType VARCHAR(20) = ''            
 ,@IsSapCompCode BIT = NULL,
@HotelSAPCode varchar(500) = NULL
 )            
AS                  
BEGIN                  
 DECLARE @TotalRecordCount INT                  
  ,@SQL NVARCHAR(MAX);        
      
    
  --Declare @HotelSAPCode varchar(20)    
                  
 -- SET @Page = @Page + 1                                                            
 IF @Action = 'I'                  
 BEGIN                  
  IF EXISTS (                  
    SELECT StateCodeID                  
    FROM HotelMaster                  
    WHERE LTRIM(UPPER(HotelName)) = LTRIM(UPPER(@HotelName))                  
    )                  
  BEGIN                  
   SELECT '201' AS returnCode                  
    ,'Hotel name already exists. Please check and try again.' AS returnMessage                  
             
   SET @HotelID = 0                  
  END                  
  ELSE                  
  BEGIN                  
   SET @GSTNID = (                  
     SELECT CSTNO                  
     FROM CompanyMaster                  
     WHERE CompanyID = @CompanyID                  
     )                  
                  
   INSERT INTO HotelMaster (                  
    AccCode                  
    ,HotelCode                  
    ,HotelName                  
    ,HotelRatingID                  
    ,ChainIATACode                  
    ,ReuseAllocation                  
    ,CityIATACode                  
    ,Website                  
    ,ZoneID                  
    ,PhoneNo                  
    ,MobileNo                  
    ,FaxNo                  
,EmailID                  
    ,PanNo                  
    ,STRegNo                  
    ,ChequeFavouring                  
    ,BankName                  
    ,Address                  
    ,AccountNo                  
    ,CreateAdvanceAccount                  
    ,CreditApplicable                  
    ,CreditPeriod                  
    ,CreditCurrencyCode                  
    ,CreditAmount                  
    ,CreditApproveBy                  
    ,InfantFromAge                  
    ,InfantToAge                  
    ,ChildFromAge                  
    ,ChildToAge                  
    ,AdultFromAge                  
    ,AdultToAge                  
    ,IsActive                  
    ,Operation                  
    ,OperationBy                  
    ,OperationOn                  
    ,Latitude                  
    ,Longitude                  
    ,CreateCommissionAccount                  
    ,BankAccountID                  
    ,HotelTypeID                  
    ,BranchName                  
    ,IFSCCode                  
    ,SWIFTCode                  
    ,Comment                  
    ,StateCodeID                  
    ,SupplierID                  
    ,CompanyID                  
    ,GSTNID                  
    ,LegalName                  
    ,BTCBranchPosting                  
    ,GSTRequired                  
    ,isActiveSAP                  
    ,TANDetails                  
    ,PreviousCode                  
    ,MSME                  
    ,Deductee                  
    ,WithHoldigTax                  
    ,RoomCount                  
    ,isActiveMSME                  
    ,MSMEType                  
    ,MSMERegFromDt                  
    ,MSMERegToDt                  
    ,PostalCode                  
    ,LegalEntity                  
    ,isSEZ                  
    ,MembershipNo                  
    ,NonGSTRegistered                  
    ,PayMode                  
    ,Beneficiary_Name                  
    ,Tax_Reg_Number                  
    ,EmailGeneral                  
    ,EmailFinance                  
    ,Country_IATACode                  
    ,Contact1                  
    ,Contact2                  
    ,Contact1IsMobile                  
    ,Contact2IsMobile                  
    ,ChainIATACodeHG                  
    ,TaxType          
 ,IsSapCompCode        
    ) --added @ 05/11/2014  -- LegalName by jyoti                                                                                                        
   VALUES (                  
    @AccCode                  
    ,@HotelCode                  
    ,RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(ISNULL(@HotelName, ''), CHAR(13), ''), CHAR(10), ' '), '  ', ' ')))                  
    ,@HotelRatingID                  
    ,@ChainIATACode                  
    ,@ReuseAllocation                  
    ,@CityIATACode                  
    ,@Website                  
    ,@ZoneID                  
    ,@PhoneNo                  
    ,@MobileNo                  
    ,@FaxNo                  
    ,@EmailID                  
    ,@PanNo                  
    ,@STRegNo           
    ,@ChequeFavouring                  
    ,@BankName                  
    ,REPLACE(REPLACE(REPLACE(ISNULL(@Address, ''), CHAR(13), ''), CHAR(10), ' '), '  ', ' ')                  
    ,@AccountNo                  
    ,@CreateAdvanceAccount                  
    ,@CreditApplicable                  
    ,@CreditPeriod                  
    ,@CreditCurrencyCode                  
    ,@CreditAmount                  
    ,@CreditApproveBy                  
    ,@InfantFromAge                  
    ,@InfantToAge                  
    ,@ChildFromAge                  
    ,@ChildToAge                  
    ,@AdultFromAge                  
    ,@AdultToAge                  
    ,@IsActive                  
    ,'INSERT'                  
    ,@OperationBy                  
    ,GETDATE()                  
    ,@Latitude                  
    ,@Longitude                  
    ,@CreateCommissionAccount                  
    ,@BankAccountID                  
    ,@HotelTypeID                  
    ,@BranchName                  
    ,@IFSCCode                  
    ,@SWIFTCode                  
 ,@Comment --added @ 05/11/2014                                                                                                       
    ,@StateCode                  
    ,@SupplierID                  
    ,@CompanyID                  
    ,@GSTNID                  
    ,@LegalName                  
    ,@BTCBranchPosting                  
    ,@GSTRequired                  
    ,@isActiveSAP                  
    ,@TANDetails                  
    ,@PreviousCode                  
    ,@MSME                  
    ,@Deductee                  
    ,@WithHoldigTax                  
    ,@RoomCount                  
    ,@isActiveMSME             
    ,@MSMEType                  
    ,@MSMERegFromDt                  
    ,@MSMERegToDt                  
    ,@PostalCode                  
    ,@LegalEntity                  
    ,@IsSEZ                  
    ,@MembershipNo                  
    ,@NonGSTRegistered                  
    ,@PayMode                  
    ,@Beneficiary_Name                  
    ,@Tax_Reg_Number                  
    ,@EmailGeneral                  
    ,@EmailFinance                  
    ,@Country_IATACode                  
    ,@Contact1                  
    ,@Contact2                  
    ,@Contact1IsMobile                  
    ,@Contact2IsMobile                  
    ,@HotelChainID                  
    ,@TaxType           
 ,@IsSapCompCode        
    )                  
                  
   SET @HotelID = @@IDENTITY          
       
    
     
           SELECT '200' AS returnCode                  
    ,'New record added successfully.' AS returnMessage                  
    ,@HotelID AS ID , @HotelCode AS EmpCode     
                  
    
    
    
    --EXEC usp_Insert_HotelMaster_Audit @HotelID                                                                
    -- ,@HotelName                                                                                                
    -- ,@CreditApplicable                                                                                                
    -- ,@CreditPeriod                                                                                                
    -- ,@CreditCurrencyCode                                                     
    -- ,@CreditAmount                                     
    -- ,@CreditApproveBy           -- ,'INSERT'                                                                                                
    -- ,@OperationBy                                                                                      
  END                  
 END -- I         
--ELSE IF @Action = 'USAP'      
--BEGIN      
-- --IF @issapcompcode = 1       
--    update HotelMaster      
-- set HotelCode = @HotelCode      
-- where HotelID = @HotelID      
-- set @HotelCode = (select HotelCode FROM HotelMaster Where HotelID = @HotelID)    
--   SELECT '200' AS returnCode                  
--    ,'updated successfully.' AS returnMessage                  
--    ,@HotelID AS ID, @HotelCode AS EmpCode             
--END      
ELSE IF @Action = 'USAP'      
    BEGIN   
   
  DECLARE @MaxNo_Str AS VARCHAR(8)                  
   DECLARE @SapID AS VARCHAR(10)                  
                  
   SET @MaxNo_Str = (                  
     SELECT SUBSTRING(MAX(HotelSAPCode), 3, LEN(MAX(HotelSAPCode)))                  
     FROM HotelMaster                  
     )                  
   SET @MaxNo_Str = CASE                   
     WHEN @MaxNo_Str IS NULL                  
      THEN '1'                  
     ELSE CAST(@MaxNo_Str AS INT) + 1                  
     END                  
   SET @SapID = 'CH' + REPLICATE('0', 8 - LEN(@MaxNo_Str)) + @MaxNo_Str                  
                  
   UPDATE HotelMaster                  
   SET HotelSAPCode = @SapID                  
   WHERE HotelID = @HotelID         
       
    
    
      set @HotelCode = (select HotelCode FROM HotelMaster Where HotelID = @HotelID)    
    set @HotelSAPCode = (select HotelSAPCode FROM HotelMaster Where HotelID = @HotelID)    
    --  SELECT '200' AS returnCode                  
    --,'New record added successfully.' AS returnMessage                  
    --,@HotelID AS ID , @HotelCode AS EmpCode, @HotelSAPCode AS HotelSAPCode         
        -- New SAP Comp Code validation    
        IF @IsSapCompCode IS NULL OR @IsSapCompCode = 0    
        BEGIN    
            SELECT '202' AS returnCode,    
                   'SAP Comp code is mandatory to update Hotel Code.' AS returnMessage    
            RETURN    
        END    
    
        UPDATE HotelMaster      
        SET HotelCode = @HotelCode,    
            IsSapCompCode = @IsSapCompCode  -- Ensure SAP flag is updated    
        WHERE HotelID = @HotelID      
  set @HotelCode = (select HotelCode FROM HotelMaster Where HotelID = @HotelID)    
      set @HotelSAPCode = (select HotelSAPCode FROM HotelMaster Where HotelID = @HotelID)    
    
   SELECT '200' AS returnCode                  
    ,'updated successfully.' AS returnMessage                  
    ,@HotelID AS ID, @HotelCode AS EmpCode,  @HotelSAPCode AS HotelSAPCode             
end    
 ELSE IF @Action = 'U'                  
 BEGIN                  
  IF EXISTS (                  
    SELECT HotelName                  
    FROM HotelMaster                  
    WHERE RTRIM(LTRIM(UPPER(HotelName))) = RTRIM(LTRIM(UPPER(REPLACE(REPLACE(REPLACE(ISNULL(@HotelName, ''), CHAR(13), ''), CHAR(10), ' '), '  ', ' '))))                  
     AND HotelID <> @HotelID                  
    )                  
  BEGIN                  
   SELECT '201' AS returnCode                  
    ,'Hotel name already exists. Please check and try again.' AS returnMessage                  
  END                  
  ELSE                  
  BEGIN             
   UPDATE HotelMaster                  
   SET AccCode = @AccCode                  
    ,HotelCode = @HotelCode                  
    ,HotelName = RTRIM(LTRIM(@HotelName))                  
    ,HotelRatingID = @HotelRatingID                  
    ,ChainIATACode = @ChainIATACode                  
    ,ReuseAllocation = @ReuseAllocation                  
    ,CityIATACode = @CityIATACode                  
    ,Website = @Website                  
    ,ZoneID = @ZoneID                  
    ,PhoneNo = @PhoneNo                  
    ,MobileNo = @MobileNo                  
    ,FaxNo = @FaxNo                  
    ,EmailID = @EmailID                  
    ,PanNo = @PanNo                  
    ,STRegNo = @STRegNo                  
    ,ChequeFavouring = @ChequeFavouring                  
    ,BankName = @BankName           
    ,[Address] = REPLACE(REPLACE(REPLACE(ISNULL(@Address, ''), CHAR(13), ''), CHAR(10), ' '), '  ', ' ')                  
    ,AccountNo = @AccountNo                  
    ,CreateAdvanceAccount = @CreateAdvanceAccount                  
    ,CreditApplicable = @CreditApplicable                  
    ,CreditPeriod = @CreditPeriod                  
    ,CreditCurrencyCode = @CreditCurrencyCode                  
    ,CreditAmount = @CreditAmount                  
    ,CreditApproveBy = @CreditApproveBy                  
    ,InfantFromAge = @InfantFromAge                  
    ,InfantToAge = @InfantToAge                  
    ,ChildFromAge = @ChildFromAge                  
    ,ChildToAge = @ChildToAge                  
    ,AdultFromAge = @AdultFromAge                  
    ,AdultToAge = @AdultToAge                  
    ,IsActive = @IsActive                  
    ,Operation = 'UPDATE'                  
    ,UpdatedBy = @OperationBy                  
    ,UpdatedOn = GETDATE()                  
    ,Latitude = @Latitude                  
    ,Longitude = @Longitude                  
    ,CreateCommissionAccount = @CreateCommissionAccount                  
    ,BankAccountID = @BankAccountID                  
    ,HotelTypeID = @HotelTypeID                  
    ,BranchName = @BranchName                  
    ,IFSCCode = @IFSCCode                  
    ,SWIFTCode = @SWIFTCode                  
    ,Comment = @Comment                  
    ,StateCodeID = @StateCode                  
    ,CompanyID = @CompanyID                  
    ,GSTNID = (                  
     SELECT CSTNO                  
     FROM CompanyMaster                  
     WHERE CompanyID = @CompanyID                  
     )                  
    ,LegalName = @LegalName                  
    ,-- jyoti                                                                                                              
    BTCBranchPosting = @BTCBranchPosting                  
    ,GSTRequired = @GSTRequired                  
    ,isActiveSAP = @isActiveSAP                  
    ,TANDetails = @TANDetails                  
    ,PreviousCode = @PreviousCode                  
    ,MSME = @MSME                  
    ,Deductee = @Deductee                  
    ,WithHoldigTax = @WithHoldigTax                  
    ,RoomCount = @RoomCount                  
    ,isActiveMSME = @isActiveMSME                  
    ,MSMEType = @MSMEType                  
    ,MSMERegFromDt = @MSMERegFromDt                  
    ,MSMERegToDt = @MSMERegToDt                  
    ,PostalCode = @PostalCode                  
    ,LegalEntity = @LegalEntity                  
    ,IsSEZ = @IsSEZ                  
    ,MembershipNo = @MembershipNo                  
    ,NonGSTRegistered = @NonGSTRegistered                  
    ,PayMode = @PayMode                  
    ,Beneficiary_Name = @Beneficiary_Name                  
    ,Tax_Reg_Number = @Tax_Reg_Number                  
    ,EmailGeneral = @EmailGeneral                  
    ,EmailFinance = @EmailFinance                  
    ,Country_IATACode = @Country_IATACode                  
    ,Contact1 = @Contact1                  
    ,Contact2 = @Contact2                  
    ,Contact1IsMobile = @Contact1IsMobile                  
    ,Contact2IsMobile = @Contact2IsMobile                  
    ,ChainIATACodeHG = @HotelChainID                  
    ,TaxType = @TaxType             
 ,IsSapCompCode = @IsSapCompCode        
 ---  VendorCode = CASE WHEN @issapcompcode = 1 THEN @VendorCode ELSE VendorCode END,      
   WHERE HotelID = @HotelID                  
                  
   --EXEC usp_Insert_HotelMaster_Audit @HotelID                                                                                                
   -- ,@HotelName                                                       -- ,@CreditApplicable                                                                               
   -- ,@CreditPeriod                                                                       
   -- ,@CreditCurrencyCode                                                                                                
   -- ,@CreditAmount                                                                                                
   -- ,@CreditApproveBy                                                                                                
   -- ,'UPDATE'                                                                                                
   -- ,@OperationBy                    
      set @HotelCode = (select HotelCode FROM HotelMaster Where HotelID = @HotelID)    
    set @HotelSAPCode = (select HotelSAPCode FROM HotelMaster Where HotelID = @HotelID)     
    
   SELECT '200' AS returnCode                  
    ,'Record updated successfully.' AS returnMessage                  
    ,@HotelID AS ID  ,  @HotelCode AS EmpCode ,  @HotelSAPCode AS HotelSAPCode                     
  END                  
 END --U                                                                        
   -- ... [Previous Code] ...                                            
 ELSE IF @Action = 'S'                  
 BEGIN                  
  -- IF @HotelID = 0                                                        
  --Begin                                                         
  --select * from HotelMaster --where HotelID=@HotelID                                                        
  --end                                                        
  IF OBJECT_ID('TEMPDB..#TempReport') IS NOT NULL                                                                            
    DROP TABLE #TempReport                                                          
  SELECT *                  
   INTO #TempReport                                    
  FROM (                  
   SELECT TOP 20000 ROW_NUMBER() OVER (                  
     ORDER BY Hm.HotelID DESC                  
     ) AS RowNum                  
    ,Hm.HotelID                  
    ,Hm.ChainIATACodeHG       
    ,Hm.HotelCode                  
    ,Hm.HotelName                  
    ,Hm.CityIATACode                  
    ,Hr.Code AS HotelRatingCode                  
    ,Hg.Name AS HotelGroupName                  
     ,LEFT(Hg.Name, 3) AS HotelGroupCode        
  ,LEFT(Hg.Name, 3) AS ChainIATACode       
    ,Ct.Name AS City                  
    ,Hm.StateCodeID AS StateCode                  
    ,Cn.IATACode AS Country                  
    ,Cn.Name AS CountryName                  
    ,Hm.Address                  
    ,Hm.IsActive                  
    ,ImageExists = CASE                   
     WHEN EXISTS (                  
       SELECT ID                  
       FROM UploadImage                  
       WHERE ParentPageType = 6                  
        AND ParentID = Hm.HotelID                  
       )                  
      THEN 'Yes'                  
     ELSE 'No'                  
     END                  
    ,ContentExists = CASE                   
     WHEN EXISTS (                  
       SELECT TOP 1 HotelID                  
       FROM HotelHeaderDetails                  
       WHERE HotelID = Hm.HotelID                  
       )                  
      THEN 'Yes'              
     ELSE 'No'                  
     END                  
    ,Hm.Latitude                  
    ,Hm.Longitude                  
    ,Hm.OperationOn AS OperationOn1                  
    ,ABM.BankAccountName                  
    ,Hm.PanNo                  
    ,Hm.STRegNo                  
    ,Hm.ChequeFavouring                  
    ,Hm.BankName     
 ,Hm.BankAccountID  
    ,AccountNo                  
    ,BranchName                  
    ,IFSCCode                  
    ,SWIFTCode                  
    ,CreditApplicable                  
    ,CreateAdvanceAccount                  
    ,CreateCommissionAccount                  
    ,CreditPeriod                  
    ,Cu.Code AS Currency                  
    ,Hm.CreditAmount                  
    ,Hm.CreditApproveBy                  
    ,Hm.PhoneNo                  
    ,Hm.EmailID                  
    ,St.Name AS StateName                  
    ,Hm.Comment                  
    ,Hm.Website                  
    ,CM.CompanyName                  
    ,Hm.LegalName                  
    ,(                  
     SELECT TOP 1 CompanyID                  
     FROM CompanyMaster                  
     WHERE CompanyID = HM.BTCBranchPosting                  
     ) AS BTCBranchPosting                  
    ,Hm.HotelSAPCode                  
    ,Hm.GSTRequired                  
    ,Hm.isActiveSAP                  
    ,Hm.TANDetails                  
    ,Hm.PreviousCode                  
  ,Hm.MSME                  
    ,Hm.Deductee                  
    ,Hm.WithHoldigTax                  
 ,Hm.RoomCount                  
    ,Hm.HotelSAPCode AS 'SAPCode'                  
    ,LE.LegalEntTypeID AS 'LegalEntity'                  
    ,HotelRatingID                  
    ,HotelTypeID                  
    ,MSMEType                  
    ,MembershipNo                  
    ,MobileNo                  
    ,HM.PostalCode                  
    ,EmailGeneral                  
    ,Hm.InfantFromAge                  
    ,Hm.InfantToAge                  
    ,Hm.ChildFromAge                  
    ,Hm.ChildToAge                  
    ,Hm.AdultFromAge                  
    ,Hm.AdultToAge                  
    ,Hm.EmailFinance                  
    ,Hm.CreditCurrencyCode                  
    ,Hm.Beneficiary_Name                  
    ,Ct.State_IATACode                  
    ,Hm.FaxNo                  
    ,Hm.ZoneID                  
    ,Contact1                  
    ,Contact2                  
    ,Contact1IsMobile                  
    ,Contact2IsMobile                  
    ,ChainIATACodeHG AS HotelGroupID                  
    ,ChainIATACodeHG AS HotelChainID                  
    ,HM.TaxType                  
    ,Hm.Tax_Reg_Number      
 ,IsSEZ    
    ,CT.IATACode   
 ,Hm.NonGSTRegistered  
   FROM HotelMaster Hm            
 --INNER JOIN HotelGroups Hg WITH (NOLOCK) ON Hm.ChainIATACodeHG = Hg.HotelGroupID                 
  LEFT JOIN HotelGroups Hg WITH (NOLOCK) ON Hm.ChainIATACodeHG = Hg.HotelGroupID    
   LEFT JOIN City Ct WITH (NOLOCK) ON Hm.CityIATACode = Ct.IATACode                  
   LEFT JOIN STATE St                  
   WITH (NOLOCK) ON St.State_ID = Ct.State_IATACode                  
   LEFT JOIN Country Cn WITH (NOLOCK) ON Cn.IATACode = St.Country_IATACode                  
   LEFT JOIN HotelRating Hr WITH (NOLOCK) ON Hm.HotelRatingID = Hr.ID                  
   LEFT JOIN AccountsBankMaster ABM WITH (NOLOCK) ON ABM.AccountBankMasterID = Hm.BankAccountID                  
   LEFT JOIN Currency Cu WITH (NOLOCK) ON Cu.Code = Hm.CreditCurrencyCode                  
   LEFT JOIN State_Code_Master SC WITH (NOLOCK) ON SC.ID = Hm.StateCodeID                  
   LEFT JOIN CompanyMaster CM WITH (NOLOCK) ON Hm.CompanyID = CM.CompanyID                  
   LEFT JOIN LegalEntityType_Master LE ON Hm.LegalEntity = LE.LegalEntTypeID                  
   ORDER BY Hm.HotelID DESC                  
   ) AS RowConstrainedResult                  
  WHERE (                  
    @HotelID IS NULL                  
    OR @HotelID = 0                  
    OR RowConstrainedResult.HotelID = @HotelID                  
    )                  
   AND (                  
    @CityIATACode IS NULL                  
    OR @CityIATACode = ''                  
    OR RowConstrainedResult.IATACode LIKE '%' + @CityIATACode + '%'                  
    )                  
   AND (                  
    @Country IS NULL                  
    OR @Country = ''           
    OR EXISTS (                  
     SELECT 1                  
     FROM STRING_SPLIT(@Country, ',') s                  
     WHERE s.value <> ''                  
      AND CountryName LIKE '%' + s.value + '%'                  
     )                  
    )                  
   AND (                  
    @State IS NULL                  
    OR @State = ''                  
    OR EXISTS (                  
     SELECT 1                  
     FROM STRING_SPLIT(@State, ',') s                  
     WHERE s.value <> ''                  
      AND StateName LIKE '%' + s.value + '%'                  
     )                  
    )                  
   AND (                  
    @City IS NULL                  
    OR @City = ''                  
    OR EXISTS (                  
     SELECT 1                  
     FROM STRING_SPLIT(@City, ',') s                  
     WHERE s.value <> ''                  
      AND RowConstrainedResult.City LIKE '%' + s.value + '%'                  
     )                  
    )                  
      AND (  -- New chain code filter                  
                @ChainIATACode IS NULL                   
                OR @ChainIATACode = ''                  
                OR HotelGroupCode LIKE @ChainIATACode + '%'               
            )                  
   AND (                  
    @Address IS NULL                  
    OR @Address = ''                  
    OR EXISTS (                  
     SELECT 1                  
     FROM STRING_SPLIT(@Address, '|') s        
     WHERE s.value <> ''                  
      AND Address LIKE '%' + s.value + '%'                  
     )                  
    )                  
   AND (                  
    @HotelSAPCode IS NULL                  
    OR @HotelSAPCode = ''                  
    OR EXISTS (                  
     SELECT 1                  
     FROM STRING_SPLIT(@HotelSAPCode, ',') s                  
     WHERE s.value <> ''                  
      AND HotelSAPCode LIKE s.value + '%'                  
     )                  
    )                  
   AND (                  
    @LegalName IS NULL                  
    OR @LegalName = ''                  
    OR EXISTS (                  
     SELECT 1                  
     FROM STRING_SPLIT(@LegalName, ',') s                  
     WHERE s.value <> ''                  
      AND LegalName LIKE s.value + '%'                  
     )                  
    )       
   AND (                  
    @HotelName IS NULL                  
    OR @HotelName = ''                  
    OR EXISTS (                  
     SELECT 1                  
     FROM STRING_SPLIT(@HotelName, '|') s                  
     WHERE s.value <> ''                  
      AND HotelName LIKE s.value + '%'                  
     )                  
    )                  
   --AND (@CreditApplicable IS NULL OR CreditApplicable = CASE WHEN @CreditApplicable = 1 THEN 1 ELSE 0 END)                                     
   AND (                  
    @CreditApplicable IS NULL                  
    OR @CreditApplicable = 1                  
    AND CreditApplicable = 1                  
OR @CreditApplicable = 0                  
    )                  
   AND (                  
    @PanNo IS NULL                  
    OR @PanNo = ''                  
    OR EXISTS (                  
     SELECT 1                  
     FROM STRING_SPLIT(@PanNo, ',') s                  
     WHERE s.value <> ''                  
      AND PanNo LIKE s.value + '%'                  
     )                  
    )                  
   AND (                  
    @TANDetails IS NULL                  
    OR @TANDetails = ''                  
    OR EXISTS (                  
     SELECT 1                  
     FROM STRING_SPLIT(@TANDetails, ',') s                  
     WHERE s.value <> ''                  
      AND TANDetails LIKE s.value + '%'                  
     )                  
    ) 
	
	 AND  (@IsActive IS NULL OR IsActive =@IsActive) 
   --and (@IsActive IS NULL  OR @IsActive = 1 AND IsActive = 1 OR @IsActive = 0)        
   --AND (@IsActive  IS NULL OR IsActive  = CASE WHEN @IsActive  = 1 THEN 1 ELSE 0 END)                                              
   -- Add the new filter conditions for Tax_Reg_Number and TaxType                                  
   AND (                  
    @Tax_Reg_Number IS NULL                  
    OR @Tax_Reg_Number = ''                  
    OR EXISTS (                  
     SELECT 1                  
     FROM STRING_SPLIT(@Tax_Reg_Number, ',') s                  
     WHERE s.value <> ''               
      AND Tax_Reg_Number LIKE s.value + '%'                  
     )                  
    )                  
   AND (                  
    @TaxType IS NULL                  
    OR @TaxType = ''                  
    OR EXISTS (                  
     SELECT 1                  
     FROM STRING_SPLIT(@TaxType, ',') s                  
     WHERE s.value <> ''                  
      AND TaxType LIKE '%' + s.value + '%'                  
     )               
    )                  
                  
     SELECT @TotalRecordCount = count(*) FROM #TempReport                                                                            
    IF @Row_Count = ''                                                                            
     OR @Row_Count = - 1                                                                            
    BEGIN                                                                            
     SET @Row_Count = @TotalRecordCount                                                                            
    END                                                                            
    SELECT @SQL = 'select * from #TempReport                                                                                                                        
      ORDER BY HotelID DESC                                                                                                                                        
      OFFSET ' + CAST((@PageNumber * @Row_Count) AS VARCHAR(20)) + ' ROWS                                                                                
      FETCH NEXT ' + CAST(@Row_Count AS VARCHAR(20)) + ' ROWS ONLY'                                                                
    EXEC sys.sp_executesql @SQL                                                 
  --  -- select * from #TempReport                                                
  select  CAST(@TotalRecordCount AS VARCHAR(20))  as Row_Count , '200' AS returnCode                                                                                
      ,'Data Found' AS returnMessage                               
  SELECT '200' AS returnCode                  
   ,'Data Found' AS returnMessage                  
 END                  
                  
 ELSE IF @Action = 'EX'                  
 BEGIN                  
                   
  SELECT *                  
  FROM (                  
   SELECT TOP 100000                   
    --,Hm.HotelID                  
    --Hm.ChainIATACodeHG                  
    Hm.HotelCode                  
    ,Hm.HotelName                  
    ,Hm.CityIATACode                  
    ,Hr.Code AS HotelRatingCode                  
    --,Hg.Name AS HotelGroupName                  
    ,LEFT(Hg.Name, 3) AS HotelGroupCode                  
    ,Ct.Name AS City                  
    --,Hm.StateCodeID AS StateCode                  
    --,Cn.IATACode AS Country                  
    ,Cn.Name AS CountryName                  
    ,Hm.Address                  
    ,CASE                   
     WHEN Hm.IsActive = 1 THEN 'Yes'                   
     WHEN Hm.IsActive = 0 THEN 'No'                  
     END AS IsActive                  
    ,ImageExists = CASE                   
     WHEN EXISTS (                  
       SELECT ID                  
       FROM UploadImage                  
       WHERE ParentPageType = 6                  
        AND ParentID = Hm.HotelID                  
       )                  
      THEN 'Yes'            
     ELSE 'No'                  
     END                  
    ,ContentExists = CASE                   
     WHEN EXISTS (                  
       SELECT TOP 1 HotelID                  
       FROM HotelHeaderDetails                  
       WHERE HotelID = Hm.HotelID                  
       )                  
      THEN 'Yes'                  
     ELSE 'No'                  
     END                  
    ,Hm.Latitude                  
    ,Hm.Longitude                  
    ,Hm.OperationOn AS OperationOn1                  
    ,ABM.BankAccountName                  
    ,Hm.PanNo                  
    ,Hm.STRegNo                  
    ,Hm.ChequeFavouring                  
    ,Hm.BankName                  
    ,AccountNo                  
    ,BranchName                  
    ,IFSCCode                  
    ,SWIFTCode                  
    ,CreditApplicable                  
    ,CreateAdvanceAccount                  
    ,CreateCommissionAccount                  
    ,CreditPeriod                  
    ,Cu.Code AS Currency                  
    ,Hm.CreditAmount                  
    ,Hm.CreditApproveBy                  
    ,Hm.PhoneNo                  
    ,Hm.EmailID                  
    ,St.Name AS StateName                  
    ,Hm.Comment                  
    ,Hm.Website                  
    ,CM.CompanyName                  
    ,Hm.LegalName                  
    ,(                  
     SELECT TOP 1 CompanyID                  
     FROM CompanyMaster                  
     WHERE CompanyID = HM.BTCBranchPosting                  
     ) AS BTCBranchPosting                  
    ,Hm.HotelSAPCode                  
    ,Hm.GSTRequired                  
    ,CASE                  
     WHEN Hm.isActiveSAP = 1 THEN 'Yes'                  
     WHEN Hm.isActiveSAP = 0 THEN 'No'                  
     END AS IsActiveSAP                  
    ,Hm.TANDetails                  
    ,Hm.PreviousCode                  
    ,Hm.MSME                  
    ,Hm.Deductee                  
    ,Hm.WithHoldigTax                  
    ,Hm.RoomCount                  
    ,Hm.HotelSAPCode AS 'SAPCode'                  
    --,LE.LegalEntTypeID AS 'LegalEntity'                  
    --,HotelRatingID                  
    --,HotelTypeID                  
    ,MSMEType                  
    ,MembershipNo                  
    ,MobileNo                  
    ,HM.PostalCode                  
    ,EmailGeneral                  
    ,Hm.InfantFromAge                  
    ,Hm.InfantToAge                  
    ,Hm.ChildFromAge                  
    ,Hm.ChildToAge                  
    ,Hm.AdultFromAge                  
    ,Hm.AdultToAge                  
    ,Hm.EmailFinance                  
    ,Hm.CreditCurrencyCode                  
    ,Hm.Beneficiary_Name                  
    --,Ct.State_IATACode                  
    ,Hm.FaxNo                  
    --,Hm.ZoneID                  
    ,Contact1                  
    ,Contact2                  
    --,Contact1IsMobile                  
    --,Contact2IsMobile                  
    --,ChainIATACodeHG AS HotelGroupID                  
    --,ChainIATACodeHG AS HotelChainID                  
    ,HM.TaxType                  
    ,Hm.Tax_Reg_Number                  
    ,CT.IATACode                  
   FROM HotelMaster Hm                  
   INNER JOIN HotelGroups Hg WITH (NOLOCK) ON Hm.ChainIATACodeHG = Hg.HotelGroupID                  
   INNER JOIN City Ct WITH (NOLOCK) ON Hm.CityIATACode = Ct.IATACode                  
   INNER JOIN STATE St                  
   WITH (NOLOCK) ON St.State_ID = Ct.State_IATACode                  
   INNER JOIN Country Cn WITH (NOLOCK) ON Cn.IATACode = St.Country_IATACode                  
   INNER JOIN HotelRating Hr WITH (NOLOCK) ON Hm.HotelRatingID = Hr.ID                  
   LEFT JOIN AccountsBankMaster ABM WITH (NOLOCK) ON ABM.AccountBankMasterID = Hm.BankAccountID                  
   LEFT JOIN Currency Cu WITH (NOLOCK) ON Cu.Code = Hm.CreditCurrencyCode                  
   LEFT JOIN State_Code_Master SC WITH (NOLOCK) ON SC.ID = Hm.StateCodeID            
   LEFT JOIN CompanyMaster CM WITH (NOLOCK) ON Hm.CompanyID = CM.CompanyID                  
   LEFT JOIN LegalEntityType_Master LE ON Hm.LegalEntity = LE.LegalEntTypeID                  
   ORDER BY Hm.HotelID DESC                  
   ) AS RowConstrainedResult                  
  WHERE (                  
  --  @HotelID IS NULL                  
  --  OR @HotelID = 0                  
  --  OR RowConstrainedResult.HotelID = @HotelID                  
  --  )                  
   --AND                   
   (                  
    @CityIATACode IS NULL                  
    OR @CityIATACode = ''                  
    OR RowConstrainedResult.IATACode LIKE '%' + @CityIATACode + '%'                  
    )                  
   AND (                  
    @Country IS NULL                  
    OR @Country = ''                  
    OR EXISTS (                  
     SELECT 1                  
    FROM STRING_SPLIT(@Country, ',') s                  
     WHERE s.value <> ''                  
      AND CountryName LIKE '%' + s.value + '%'                  
     )                  
    )                  
   AND (                  
    @State IS NULL                  
    OR @State = ''                  
    OR EXISTS (                  
 SELECT 1                  
     FROM STRING_SPLIT(@State, ',') s                  
     WHERE s.value <> ''                  
      AND StateName LIKE '%' + s.value + '%'                  
     )                  
    )                  
   AND (                  
    @City IS NULL                  
    OR @City = ''                  
    OR EXISTS (                  
     SELECT 1                  
     FROM STRING_SPLIT(@City, ',') s                  
     WHERE s.value <> ''                  
      AND RowConstrainedResult.City LIKE '%' + s.value + '%'                  
     )                  
    )                  
   AND (                  
    @Address IS NULL                  
    OR @Address = ''                  
    OR EXISTS (                  
     SELECT 1                  
     FROM STRING_SPLIT(@Address, '|') s                  
     WHERE s.value <> ''                  
      AND Address LIKE '%' + s.value + '%'                  
     )                  
    )                  
   AND (                  
    @HotelCode IS NULL                  
    OR @HotelCode = ''                  
    OR EXISTS (                  
     SELECT 1                  
     FROM STRING_SPLIT(@HotelCode, ',') s                  
     WHERE s.value <> ''                  
      AND HotelCode LIKE s.value + '%'                  
     )                  
    )                  
   AND (                  
 @LegalName IS NULL                  
    OR @LegalName = ''                  
    OR EXISTS (                  
     SELECT 1                  
     FROM STRING_SPLIT(@LegalName, ',') s                  
     WHERE s.value <> ''                  
      AND LegalName LIKE s.value + '%'                  
     )                  
    )                  
   AND (                  
    @HotelName IS NULL                  
    OR @HotelName = ''                  
    OR EXISTS (                  
     SELECT 1                  
     FROM STRING_SPLIT(@HotelName, '|') s                  
     WHERE s.value <> ''                  
      AND HotelName LIKE s.value + '%'                  
     )                  
    )                                 
   AND (                  
    @CreditApplicable IS NULL                  
    OR @CreditApplicable = 1                  
    AND CreditApplicable = 1                  
    OR @CreditApplicable = 0                  
    )                  
   AND (                  
    @PanNo IS NULL                  
    OR @PanNo = ''                  
    OR EXISTS (                  
     SELECT 1                  
     FROM STRING_SPLIT(@PanNo, ',') s                  
     WHERE s.value <> ''                  
      AND PanNo LIKE s.value + '%'                  
     )                  
    )                  
   AND (                  
    @TANDetails IS NULL              
    OR @TANDetails = ''                  
    OR EXISTS (                  
     SELECT 1                  
     FROM STRING_SPLIT(@TANDetails, ',') s                  
     WHERE s.value <> ''                  
      AND TANDetails LIKE s.value + '%'                  
     )                  
    )                                
   AND (                  
    @Tax_Reg_Number IS NULL                  
    OR @Tax_Reg_Number = ''                  
    OR EXISTS (                  
     SELECT 1                  
     FROM STRING_SPLIT(@Tax_Reg_Number, ',') s                  
     WHERE s.value <> ''                  
      AND Tax_Reg_Number LIKE s.value + '%'                  
     )                  
    )                  
      AND (  -- New chain code filter                  
                @ChainIATACode IS NULL                   
                OR @ChainIATACode = ''                  
                OR HotelGroupCode LIKE @ChainIATACode + '%'                  
            )                  
   AND (                  
    @TaxType IS NULL                  
    OR @TaxType = ''                  
    OR EXISTS (                  
     SELECT 1                  
     FROM STRING_SPLIT(@TaxType, ',') s                  
     WHERE s.value <> ''                  
      AND TaxType LIKE '%' + s.value + '%'                  
     )                  
    )                  
  )                  
 END                 
ELSE IF @Action = 'F'              
begin              
SELECT               
    Hm.HotelID,              
    Hm.ChainIATACodeHG,              
    Hm.HotelCode,              
    Hm.HotelName,              
    Hm.CityIATACode,              
    Hr.Code AS HotelRatingCode,              
  Hg.Name AS HotelGroupName,              
    Ct.Name AS City,              
    Hm.StateCodeID AS StateCode,              
    Cn.IATACode AS Country,              
    Cn.Name AS CountryName,              
    Hm.Address,              
    Hm.IsActive,              
    ImageExists = CASE               
        WHEN EXISTS (              
            SELECT ID              
            FROM UploadImage              
            WHERE ParentPageType = 6 AND ParentID = Hm.HotelID              
        ) THEN 'Yes'              
        ELSE 'No'              
    END,       
    ContentExists = CASE               
        WHEN EXISTS (              
            SELECT TOP 1 HotelID              
            FROM HotelHeaderDetails              
            WHERE HotelID = Hm.HotelID              
        ) THEN 'Yes'              
        ELSE 'No'              
    END,              
    Hm.Latitude,              
    Hm.Longitude,              
    Hm.OperationOn AS OperationOn1,              
    ABM.BankAccountName,              
    Hm.PanNo,              
    Hm.STRegNo,              
    Hm.ChequeFavouring,              
    Hm.BankName,              
    AccountNo,              
    BranchName,              
    IFSCCode,              
    SWIFTCode,              
    CreditApplicable,              
    CreateAdvanceAccount,              
    CreateCommissionAccount,              
    CreditPeriod,              
    Cu.Code AS Currency,              
    Hm.CreditAmount,              
    Hm.CreditApproveBy,              
    Hm.PhoneNo,              
    Hm.EmailID,              
    St.Name AS StateName,              
    Hm.Comment,              
    Hm.Website,              
    CM.CompanyName,              
    Hm.LegalName,              
    (              
        SELECT TOP 1 CompanyID              
        FROM CompanyMaster              
        WHERE CompanyID = HM.BTCBranchPosting              
    ) AS BTCBranchPosting,              
    Hm.HotelSAPCode,              
    Hm.GSTRequired,              
    Hm.isActiveSAP,              
    Hm.TANDetails,              
    Hm.PreviousCode,              
    Hm.MSME,              
    Hm.Deductee,              
    Hm.WithHoldigTax,              
    Hm.RoomCount,              
    Hm.HotelSAPCode AS SAPCode,              
    LE.LegalEntTypeID AS LegalEntity,              
    HotelRatingID,              
    HotelTypeID,              
    MSMEType,              
    MembershipNo,              
    MobileNo,              
    HM.PostalCode,              
    EmailGeneral,              
    Hm.InfantFromAge,              
    Hm.InfantToAge,              
    Hm.ChildFromAge,              
    Hm.ChildToAge,              
    Hm.AdultFromAge,              
    Hm.AdultToAge,              
    Hm.EmailFinance,              
    Hm.CreditCurrencyCode,              
    Hm.Beneficiary_Name,              
    Ct.State_IATACode,              
    Hm.FaxNo,              
    Hm.ZoneID,              
    Contact1,              
    Contact2,              
    Contact1IsMobile,             
    Contact2IsMobile,              
    ChainIATACodeHG AS HotelGroupID,              
    ChainIATACodeHG AS HotelChainID,              
    HM.TaxType,              
    Hm.Tax_Reg_Number,              
    CT.IATACode              
FROM HotelMaster Hm              
Left JOIN HotelGroups Hg WITH (NOLOCK) ON Hm.ChainIATACodeHG = Hg.HotelGroupID              
INNER JOIN City Ct WITH (NOLOCK) ON Hm.CityIATACode = Ct.IATACode              
INNER JOIN STATE St WITH (NOLOCK) ON St.State_ID = Ct.State_IATACode              
INNER JOIN Country Cn WITH (NOLOCK) ON Cn.IATACode = St.Country_IATACode              
INNER JOIN HotelRating Hr WITH (NOLOCK) ON Hm.HotelRatingID = Hr.ID              
LEFT JOIN AccountsBankMaster ABM WITH (NOLOCK) ON ABM.AccountBankMasterID = Hm.BankAccountID              
LEFT JOIN Currency Cu WITH (NOLOCK) ON Cu.Code = Hm.CreditCurrencyCode              
LEFT JOIN State_Code_Master SC WITH (NOLOCK) ON SC.ID = Hm.StateCodeID              
LEFT JOIN CompanyMaster CM WITH (NOLOCK) ON Hm.CompanyID = CM.CompanyID              
LEFT JOIN LegalEntityType_Master LE ON Hm.LegalEntity = LE.LegalEntTypeID              
WHERE               
    (@HotelID IS NULL OR @HotelID = 0 OR Hm.HotelID = @HotelID)              
    AND (@CityIATACode IS NULL OR @CityIATACode = '' OR Hm.CityIATACode LIKE '%' + @CityIATACode + '%')              
    AND (              
        @Country IS NULL OR @Country = '' OR EXISTS (              
            SELECT 1 FROM STRING_SPLIT(@Country, ',') s              
            WHERE s.value <> '' AND Cn.Name LIKE '%' + s.value + '%'              
        )              
    )              
    AND (              
        @State IS NULL OR @State = '' OR EXISTS (              
            SELECT 1 FROM STRING_SPLIT(@State, ',') s              
            WHERE s.value <> '' AND St.Name LIKE '%' + s.value + '%'              
        )              
    )              
    AND (              
        @City IS NULL OR @City = '' OR EXISTS (              
            SELECT 1 FROM STRING_SPLIT(@City, ',') s              
            WHERE s.value <> '' AND Ct.Name LIKE '%' + s.value + '%'              
        )              
    )              
    AND (              
        @Address IS NULL OR @Address = '' OR EXISTS (              
            SELECT 1 FROM STRING_SPLIT(@Address, '|') s              
            WHERE s.value <> '' AND Hm.Address LIKE '%' + s.value + '%'              
        )              
    )              
    AND (              
        @HotelCode IS NULL OR @HotelCode = '' OR EXISTS (              
            SELECT 1 FROM STRING_SPLIT(@HotelCode, ',') s              
            WHERE s.value <> '' AND Hm.HotelCode LIKE s.value + '%'              
        )              
    )              
    AND (              
        @LegalName IS NULL OR @LegalName = '' OR EXISTS (              
            SELECT 1 FROM STRING_SPLIT(@LegalName, ',') s              
            WHERE s.value <> '' AND Hm.LegalName LIKE s.value + '%'              
        )              
    )              
    AND (    
  @HotelName IS NULL    
    OR @HotelName = ''    
    OR NOT EXISTS (    
        SELECT 1    
        FROM STRING_SPLIT(@HotelName, ' ') s    
        WHERE s.value <> ''    
        AND HotelName NOT LIKE '%' + s.value + '%'   
    )    
        --@HotelName IS NULL OR @HotelName = '' OR EXISTS (              
        --    SELECT 1 FROM STRING_SPLIT(@HotelName, '|') s              
        --    WHERE s.value <> '' AND Hm.HotelName LIKE s.value + '%'              
        --)              
    )              
    AND (              
        @CreditApplicable IS NULL              
        OR (@CreditApplicable = 1 AND CreditApplicable = 1)              
        OR @CreditApplicable = 0              
    )              
    AND (              
        @PanNo IS NULL OR @PanNo = '' OR EXISTS (              
            SELECT 1 FROM STRING_SPLIT(@PanNo, ',') s              
            WHERE s.value <> '' AND Hm.PanNo LIKE s.value + '%'              
        )              
    )              
    AND (              
        @TANDetails IS NULL OR @TANDetails = '' OR EXISTS (              
            SELECT 1 FROM STRING_SPLIT(@TANDetails, ',') s              
            WHERE s.value <> '' AND Hm.TANDetails LIKE s.value + '%'              
        )              
    )              
    AND (              
        @Tax_Reg_Number IS NULL OR @Tax_Reg_Number = '' OR EXISTS (              
            SELECT 1 FROM STRING_SPLIT(@Tax_Reg_Number, ',') s              
            WHERE s.value <> '' AND Hm.Tax_Reg_Number LIKE s.value + '%'              
        )              
    )              
    AND (              
        @TaxType IS NULL OR @TaxType = '' OR EXISTS (              
            SELECT 1 FROM STRING_SPLIT(@TaxType, ',') s              
            WHERE s.value <> '' AND HM.TaxType LIKE '%' + s.value + '%'              
        )              
    )              
 AND Hm.IsActive = 1  -- Add this line to filter active hotels        
    ORDER BY Hm.HotelID DESC              
            
    SELECT CAST(0 AS VARCHAR(20)) AS Row_Count, '200' AS returnCode, 'Data Found' AS returnMessage              
--ORDER BY Hm.HotelID DESC              
              
 select  CAST(0 AS VARCHAR(20))  as Row_Count , '200' AS returnCode                                                                                
      ,'Data Found' AS returnMessage                               
  SELECT '200' AS returnCode                  
   ,'Data Found' AS returnMessage                
              
end              
end 
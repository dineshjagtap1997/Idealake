<<<<<<< HEAD
<<<<<<< HEAD
﻿CREATE PROCEDURE [dbo].[usp_CompanyMaster] (                                                
 @CompanyName VARCHAR(200) = ''                                                
 ,@HeadOffice BIT = ''                                                
 ,@PrintHeadOffAddress BIT = ''                                                
 ,@Address VARCHAR(MAX) = ''                                                
 ,@CityIATACode CHAR(3) = null                                                
 ,@Phone VARCHAR(15) = ''                                                
 ,@Fax VARCHAR(15) = ''                                                
 ,@Website VARCHAR(200) = ''                                                
 ,@Email VARCHAR(200) = ''                                                
 ,@PanNo VARCHAR(200) = ''                                                
 ,@LSTNo VARCHAR(200) = ''                                                
 ,@CSTNo VARCHAR(200) = ''                                                
 ,@VATNo VARCHAR(200) = ''                                                
 ,@STNo VARCHAR(200) = ''                                                
 ,@IsActive BIT = null                                                
 ,@OperationBy UNIQUEIDENTIFIER = null                                                
 ,@StateCode BIGINT = ''                                                
 ,@SAP_StateCode VARCHAR(500) = ''                                                
 ,@SAP_CompanyCode VARCHAR(4) = ''                                                
 ,@PostalCode VARCHAR(20) = ''                                                
 ,@SAP_BusinessPlaceCode VARCHAR(4) = ''                                                
 ,@CIN VARCHAR(25) = ''                                                
 ,@MSME_RegNo VARCHAR(25) = ''                                                
 ,@RegAddress VARCHAR(200) = ''                                                
 ,@BranchAddress VARCHAR(200) = ''                                                
 ,@compcode NVARCHAR(5) = ''                                                
 ,@CurrencyComp_id NVARCHAR(10) = ''                                                
 ,@NotesForInvoice NVARCHAR(200) = ''                                                
 ,@LegalName NVARCHAR(150) = ''                                                
 ,@EmailIDForXO NVARCHAR(50) = ''                                                
 ,@TwoDigitStateCode NVARCHAR(20) = ''                                                
 ,@Action CHAR(2) = ''                                                
 ,@CompanyID INT = NULL                                                
 --,@Active INT = NULL                                                
 ,@PageNumber BIGINT = NULL                                                
 ,@PageSize INT = NULL                                                
 ,@TEntity_ID INT ='',                                        
 @Country Varchar(20) = ''                                        
 ,@salesTaxRegNumber Varchar(20) = ''                                        
 ,@tanNumber Varchar(20) = ''                               
 ,@StateID INT =''  ,                            
 @PANVERIFICATION Varchar(20)= '',                            
@TANVERIFICATION Varchar(20)= '',                            
@GSTVERIFICATION Varchar(20)= '' ,            
@TaxType varchar(50)=''          
 )                                                
AS                                                
BEGIN                  
  DECLARE @LogID int;                 
 -- Insert Action                                                    
 IF @Action = 'I'                                                
 BEGIN                                                
  IF EXISTS (                                                
    SELECT CompanyID                                                
    FROM CompanyMaster                                                
    WHERE UPPER(CompanyName) = UPPER(@CompanyName)               
    )                                                
  BEGIN       
   SELECT '201' AS returnCode, 'Company name already exists. Please check and try again.' AS returnMessage;                                          
  END                                                
  ELSE                   
  BEGIN                                                
   DECLARE @MaxID INT = (                                                
     SELECT ISNULL(MAX(OldID), 0) + 1                                                
     FROM CompanyMaster                     
     );                                                
                                                
   INSERT INTO CompanyMaster (                           
    CompanyName                                                
    ,HeadOffice                                                
    ,PrintHeadOffAddress                                               
    ,Address                                                
    ,CityIATACode                                                
    ,Phone                                              
    ,Fax                                                
    ,Website                                                
    ,Email                                  ,PanNo                                                
    ,LSTNo                                                
    ,CSTNo                                                
    ,VATNo                                ,STNo                                                
    ,IsActive                                                
    ,Operation                                                
    ,OperationBy                                                
    ,OperationOn                                                
    ,OldID                                                
    ,StateCodeID                                                
    ,SAP_StateCode                                                
    ,SAP_CompanyCode                                                
    ,PostalCode                                                
    ,SAP_BusinessPlaceCode                                                
    ,CIN                                                
    ,MsmeNo                                                
 ,RegAddress                                                
    ,BranchAddress                                                
    ,compcode                                                
    ,CurrencyComp_id                                                
    ,NotesForInvoice                                                
    ,LegalName                                                
    ,EmailIDForXO                                                
    ,TwoDigitStateCode                                      
 ,TEntity_ID                                        
 ,tanNumber                                        
 ,Country                                        
 ,salesTaxRegNumber                                
 ,StateID  ,                            
 PANVERIFICATION,                            
 TANVERIFICATION,                            
 GSTVERIFICATION    ,            
 TaxType            
    )                                                
   VALUES (                                                
    @CompanyName                                                
    ,@HeadOffice                                              
    ,@PrintHeadOffAddress                                                
    ,@Address                                                
    ,@CityIATACode                                                
    ,@Phone                                                
    ,@Fax                                                
    ,@Website                                                
    ,@Email                                                
    ,@PanNo                                                
    ,@LSTNo                                                
    ,@CSTNo                                   
    ,@VATNo                                                
    ,@STNo                                                
    ,@IsActive                                                
    ,'Insert'                                                
    ,@OperationBy                                      
    ,GETDATE()                                                
    ,@MaxID                                                
    ,@StateCode                                     
    ,@SAP_StateCode                                                
    ,@SAP_CompanyCode                                                
    ,@PostalCode                                                
    ,@SAP_BusinessPlaceCode                                                
    ,@CIN                                                
    ,@MSME_RegNo                                                
    ,@RegAddress                                                
    ,@BranchAddress                                                
,@compcode                                                
    ,@CurrencyComp_id                                                
    ,@NotesForInvoice                                                
    ,@LegalName                                                
    ,@EmailIDForXO                                   
    ,@TwoDigitStateCode                                              
 ,@TEntity_ID                                            
 ,@tanNumber                                        
 ,@Country                                        
 ,@salesTaxRegNumber                               
 ,@StateID  ,                            
 @PANVERIFICATION,                            
 @TANVERIFICATION,                            
 @GSTVERIFICATION,            
 @TaxType            
    );                                                
                   
   SET @LogID = @@IDENTITY                
   SELECT '200' AS returnCode, 'New record added successfully.' AS returnMessage , @LogID AS ID;                                                
  END                                                
 END                                                
   -- Update Action                                                    
 ELSE IF @Action = 'U'                                                
 BEGIN                                                
  IF NOT EXISTS (                                                
    SELECT CompanyID                                  
    FROM CompanyMaster                                                
    WHERE UPPER(CompanyName) = UPPER(@CompanyName)                                                
     AND CompanyID <> @CompanyID                                                
    )                                                
  BEGIN                                                
   UPDATE CompanyMaster                               
   SET CompanyName = @CompanyName                                                
    ,HeadOffice = @HeadOffice                                                
    ,PrintHeadOffAddress = @PrintHeadOffAddress                                                
    ,Address = @Address                                                
    ,CityIATACode = @CityIATACode                                                
    ,Phone = @Phone                                                
    ,Fax = @Fax                                               
    ,Website = @Website                                                
    ,Email = @Email                                                
    ,PanNo = @PanNo                                                
    ,LSTNo = @LSTNo                                                
    ,CSTNo = @CSTNo                                                
    ,VATNo = @VATNo                                                
    ,STNo = @STNo                                                
    ,IsActive = @IsActive                                                
    ,Operation = 'Update'                                            
    ,UpdatedBy = @OperationBy                                                
    ,UpdatedOn = GETDATE()                                                
    ,StateCodeID = @StateCode                                                
    ,SAP_StateCode = @SAP_StateCode              
    ,SAP_CompanyCode = @SAP_CompanyCode                                                
    ,PostalCode = @PostalCode                                                
    ,SAP_BusinessPlaceCode = @SAP_BusinessPlaceCode                                                
    ,CIN = @CIN                                                
    ,MsmeNo = @MSME_RegNo                            
    ,RegAddress = @RegAddress                                                
    ,BranchAddress = @BranchAddress                                                
    ,compcode = @compcode                                     
    ,CurrencyComp_id = @CurrencyComp_id                                                
    ,NotesForInvoice = @NotesForInvoice                               
    ,LegalName = @LegalName                                                
    ,EmailIDForXO = @EmailIDForXO                                                
    ,TwoDigitStateCode = @TwoDigitStateCode                                              
     ,tanNumber = @tanNumber                                         
 ,Country = @Country                                        
 ,salesTaxRegNumber  = @salesTaxRegNumber                               
 ,StateID = @StateID,                             
 PANVERIFICATION = @PANVERIFICATION,                            
 TANVERIFICATION = @TANVERIFICATION,                            
 GSTVERIFICATION = @GSTVERIFICATION                      
 ,TEntity_ID =@TEntity_ID              
 ,TaxType = @TaxType            
   WHERE CompanyID = @CompanyID;                                                
            
   SELECT '200' AS returnCode, 'Record updated successfully.' AS returnMessage, @CompanyID as ID ;                                      
  END                                                
  ELSE                                                
  BEGIN                                                
   SELECT '201' AS returnCode, 'Company name already exists. Please check and try again.' AS returnMessage;                                                
  END                        
 END                                                
   -- Select Action (Fetch Data)                                                    
 ELSE IF @Action = 'S'                                                
 BEGIN                                                
                                                
    SELECT DISTINCT cm.CompanyID                                                
    ,cm.CompanyName                                               
    ,HeadOffice                                                
    ,PrintHeadOffAddress                                     
    ,cm.Address                                               
    ,Cm.CityIATACode                                                
    ,Phone                                                
    ,Fax                                                
    ,Website                                                
    ,Email                                                
    ,PanNo                                                
    ,LSTNo                                                
    ,CSTNo                                                
    ,VATNo                                         
    ,STNo                                                
    ,Cm.IsActive                                                
    ,Cm.OperationBy                                                
    ,Ct.Name AS City                                                
    ,St.Name AS [State]                                                
    ,Cn.Name AS Country_Name --, '200' as returnCode,'DATA FETCHED' AS returnMessage                     
 , Cm.tanNumber as TanNumber                                        
 , Cm.Country                            
 , Cm.salesTaxRegNumber                                    
 ,cm.BranchAddress                                  
 ,CIN                                  
 ,CSTNo                                  
 ,CompCode                                  
 ,CurrencyComp_id                                  
 ,EmailIDForXO                             
 ,LSTNo                                  
 ,LegalName                                  
 ,MsmeNo as MSME_RegNo                                  
 ,NotesForInvoice                                  
 ,Cm.PostalCode                                  
 ,RegAddress                                  
 ,SAP_BusinessPlaceCode                                  
 ,SAP_CompanyCode                                  
 ,SAP_StateCode                                  
 ,TwoDigitStateCode              
 ,CM.StateCodeID  AS StateCode                                  
 ,Cn.IATACode AS Country                                 
 ,Country_IATACode                               
 ,StateID ,                            
 cm.PANVERIFICATION,                            
 cm.TANVERIFICATION,                            
 cm.GSTVERIFICATION ,                           
  Ct.Name as CityName ,            
  TaxType ,TEntity_ID          
                                  
 --,Ct.IATACode as CityIATACode                                  
   FROM CompanyMaster Cm                                      
   LEFT JOIN City Ct ON Cm.CityIATACode = Ct.IATACode                                                
   LEFT JOIN [State] St ON St.State_ID = Ct.State_IATACode                                                
   LEFT JOIN Country Cn ON Cn.IATACode = St.Country_IATACode                           
  -- left join EmployeeMaster em on EM.CompanyID = Cm.CompanyID          
   WHERE 
  (@CompanyID IS NULL OR @CompanyID = 0 OR Cm.CompanyID = @CompanyID)
  AND (
    @OperationBy IS NULL OR EXISTS (
      SELECT 1 FROM EmployeeMaster em WHERE em.CompanyID = Cm.CompanyID AND em.UserID = @OperationBy
    )
  )
ORDER BY Cm.CompanyName ASC                                         
    ---- added for pagination                                                    
    --OFFSET @PageNumber * @PageSize ROWS                                                    
    --FETCH NEXT @PageSize ROWS ONLY;                                                    
    ----select                                      
                          
  END          
        
 ELSE IF @Action = 'EX'                                                
 BEGIN                                                
                                                
   SELECT CompanyName                                                
    ,       
 CASE       
  WHEN HeadOffice = 1 THEN 'Yes'      
  WHEN HeadOffice = 0 THEN 'No'      
  End as HeadOffice      
    ,       
 CASE       
  WHEN PrintHeadOffAddress = 1 THEN 'Yes'      
  WHEN PrintHeadOffAddress = 0 THEN 'No'      
  End as PrintHeadOffAddress      
    ,cm.Address                                               
    ,Cm.CityIATACode                                                
    ,Phone                                                
    ,Fax                                                
    ,Website                                                
    ,Email                                                
    ,PanNo                                                
    ,LSTNo                                                
    ,CSTNo                                                
    ,VATNo                                         
    ,STNo                                                
    ,CASE       
  WHEN Cm.IsActive = 1 THEN 'True'      
  WHEN Cm.IsActive = 0 THEN 'False'      
  END AS IsActive      
    ,Ct.Name AS City                                                
    ,St.Name AS [State]                                                
    ,Cn.Name AS Country_Name --, '200' as returnCode,'DATA FETCHED' AS returnMessage                                                    
 , Cm.tanNumber as TanNumber                                        
 , Cm.Country                            
 , Cm.salesTaxRegNumber                                    
 ,cm.BranchAddress                                  
 ,CIN                                  
 ,CSTNo                                  
 ,CompCode                                  
 --,CurrencyComp_id                                  
 ,EmailIDForXO                                  
 ,LSTNo                                  
 ,LegalName                                  
 ,MsmeNo as MSME_RegNo                                  
 ,NotesForInvoice                                  
 ,Cm.PostalCode                                  
 ,RegAddress                                  
 ,SAP_BusinessPlaceCode                                  
 ,SAP_CompanyCode                                  
 ,SAP_StateCode                                  
 --,TwoDigitStateCode                                  
 --,CM.StateCodeID  AS StateCode                                  
 ,Cn.IATACode AS Country                                 
 ,Country_IATACode                               
 --,StateID                             
 ,cm.PANVERIFICATION,                            
 cm.TANVERIFICATION,                            
 cm.GSTVERIFICATION ,                           
  Ct.Name as CityName ,            
  TaxType  ,    
  TEntity_ID         
                                  
 --,Ct.IATACode as CityIATACode                                  
   FROM CompanyMaster Cm                                      
   LEFT JOIN City Ct ON Cm.CityIATACode = Ct.IATACode                                                
   LEFT JOIN [State] St ON St.State_ID = Ct.State_IATACode                                                
   LEFT JOIN Country Cn ON Cn.IATACode = St.Country_IATACode                           
 --  left join EmployeeMaster em on EM.CompanyID = Cm.CompanyID          
   where (       @CompanyID IS NULL       OR @CompanyID = 0       OR Cm.CompanyID  = @CompanyID     )            
  -- and (@OperationBy is null or em.userid = @OperationBy)          
   ORDER BY Cm.CompanyID  DESC                                              
                                   
                          
  END        
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
﻿      
--DECLARE @CompanyName VARCHAR(200) = '';      
--DECLARE @HeadOffice BIT = 0;      
--DECLARE @PrintHeadOffAddress BIT = 0;      
--DECLARE @Address VARCHAR(MAX) = '';      
--DECLARE @CityIATACode CHAR(3) = '';      
--DECLARE @Phone VARCHAR(15) = '';      
--DECLARE @Fax VARCHAR(15) = '';      
--DECLARE @Website VARCHAR(200) = '';      
--DECLARE @Email VARCHAR(200) = '';      
--DECLARE @PanNo VARCHAR(200) = '';      
--DECLARE @LSTNo VARCHAR(200) = '';      
--DECLARE @CSTNo VARCHAR(200) = '';      
--DECLARE @VATNo VARCHAR(200) = '';      
--DECLARE @STNo VARCHAR(200) = '';      
--DECLARE @IsActive BIT = 0;      
--DECLARE @OperationBy UNIQUEIDENTIFIER = 'feeceb69-c92c-41a9-98de-fa86fcc009e9';      
--DECLARE @StateCode BIGINT = 0;      
--DECLARE @SAP_StateCode VARCHAR(500) = '';      
--DECLARE @SAP_CompanyCode VARCHAR(4) = '';      
--DECLARE @PostalCode VARCHAR(20) = '';      
--DECLARE @SAP_BusinessPlaceCode VARCHAR(4) = NULL;      
--DECLARE @CIN VARCHAR(25) = NULL;      
--DECLARE @MSME_RegNo VARCHAR(25) = NULL;      
--DECLARE @RegAddress VARCHAR(200) = NULL;      
--DECLARE @BranchAddress VARCHAR(200) = NULL;      
--DECLARE @compcode NVARCHAR(5) = NULL;      
--DECLARE @CurrencyComp_id NVARCHAR(10) = NULL;      
--DECLARE @NotesForInvoice NVARCHAR(200) = NULL;      
--DECLARE @LegalName NVARCHAR(150) = NULL;      
--DECLARE @EmailIDForXO NVARCHAR(50) = NULL;      
--DECLARE @TwoDigitStateCode NVARCHAR(20) = NULL;      
--DECLARE @Action CHAR(2) = 'EX';      
--DECLARE @CompanyID INT = 0;      
--DECLARE @PageSize INT = NULL;      
--DECLARE @TEntity_ID INT = NULL;      
--DECLARE @Country VARCHAR(20) = '';      
--DECLARE @salesTaxRegNumber VARCHAR(20) = '';      
--DECLARE @tanNumber VARCHAR(20) = '';      
--DECLARE @StateID INT = 0;      
--DECLARE @PANVERIFICATION VARCHAR(20) = '';      
--DECLARE @TANVERIFICATION VARCHAR(20) = '';      
--DECLARE @GSTVERIFICATION VARCHAR(20) = '';      
--DECLARE @TaxType VARCHAR(50) = '';      
--DECLARE @Row_Count VARCHAR(MAX) = '10';      
--DECLARE @PageNumber INT = 0;      
      
CREATE PROCEDURE [dbo].[usp_CompanyMaster] (                                                      
 @CompanyName VARCHAR(200) = ''                                                      
 ,@HeadOffice BIT = ''                                                      
 ,@PrintHeadOffAddress BIT = ''                                                      
 ,@Address VARCHAR(MAX) = ''                                                      
 ,@CityIATACode CHAR(3) = null                                                      
 ,@Phone VARCHAR(15) = ''                                                      
 ,@Fax VARCHAR(15) = ''                                                      
 ,@Website VARCHAR(200) = ''                                                      
 ,@Email VARCHAR(200) = ''                                                      
 ,@PanNo VARCHAR(200) = ''                                                      
 ,@LSTNo VARCHAR(200) = ''                                                      
 ,@CSTNo VARCHAR(200) = ''                                                      
 ,@VATNo VARCHAR(200) = ''                                                      
 ,@STNo VARCHAR(200) = ''                                                      
 ,@IsActive BIT = null                                                      
 ,@OperationBy UNIQUEIDENTIFIER = null                                                      
 ,@StateCode BIGINT = ''                                                      
 ,@SAP_StateCode VARCHAR(500) = ''                                                      
 ,@SAP_CompanyCode VARCHAR(4) = ''                                                      
 ,@PostalCode VARCHAR(20) = ''                                                      
 ,@SAP_BusinessPlaceCode VARCHAR(4) = ''                                                      
 ,@CIN VARCHAR(25) = ''                                                      
 ,@MSME_RegNo VARCHAR(25) = ''                           
 ,@RegAddress VARCHAR(200) = ''                                                      
 ,@BranchAddress VARCHAR(200) = ''                                                      
 ,@compcode NVARCHAR(5) = ''                                                      
 ,@CurrencyComp_id NVARCHAR(10) = ''                                                      
 ,@NotesForInvoice NVARCHAR(200) = ''                                                      
 ,@LegalName NVARCHAR(150) = ''                                                      
 ,@EmailIDForXO NVARCHAR(50) = ''                                                      
 ,@TwoDigitStateCode NVARCHAR(20) = ''                                                      
 ,@Action CHAR(2) = ''                                                      
 ,@CompanyID INT = NULL                                                      
 ,@Active INT = NULL                                                      
                                                       
 ,@PageSize INT = NULL                                                      
 ,@TEntity_ID INT ='',                                              
 @Country Varchar(20) = ''                                              
 ,@salesTaxRegNumber Varchar(20) = ''                                              
 ,@tanNumber Varchar(20) = ''                                     
 ,@StateID INT =''  ,                                  
 @PANVERIFICATION Varchar(20)= '',                                  
@TANVERIFICATION Varchar(20)= '',                                  
@GSTVERIFICATION Varchar(20)= '' ,                  
@TaxType varchar(50)='',      
@Row_Count VARCHAR(max) = '10' ,                   
 @PageNumber INT = 0      
      
 )                                                      
AS                                                      
BEGIN        
DECLARE @TotalRecordCount INT                    
  ,@SQL NVARCHAR(MAX);       
            
  DECLARE @LogID int;                       
 -- Insert Action                                                          
 IF @Action = 'I'                                                      
 BEGIN                                                      
  IF EXISTS (                                                      
    SELECT CompanyID                                                      
    FROM CompanyMaster                                                      
    WHERE UPPER(CompanyName) = UPPER(@CompanyName)                     
    )                                                      
  BEGIN             
   SELECT '201' AS returnCode, 'Company name already exists. Please check and try again.' AS returnMessage;                                                
  END                                                      
  ELSE                         
  BEGIN                                                      
   DECLARE @MaxID INT = (                                                      
     SELECT ISNULL(MAX(OldID), 0) + 1                                                      
     FROM CompanyMaster                           
     );                                                      
                                                      
   INSERT INTO CompanyMaster (                                 
    CompanyName                                                      
    ,HeadOffice                                                      
    ,PrintHeadOffAddress                                                     
    ,Address                                                      
    ,CityIATACode                                                      
    ,Phone                                                    
    ,Fax                                                      
    ,Website                                                      
    ,Email                                  ,PanNo                                                      
    ,LSTNo                                                      
    ,CSTNo                                       
    ,VATNo                                ,STNo                                                      
    ,IsActive                                                      
    ,Operation     
    ,OperationBy                                                      
    ,OperationOn                                                      
    ,OldID                                                      
    ,StateCodeID                                                      
    ,SAP_StateCode                                                      
    ,SAP_CompanyCode                                                      
    ,PostalCode                                                      
    ,SAP_BusinessPlaceCode                                                      
    ,CIN                                                      
    ,MsmeNo                                                      
 ,RegAddress                                                      
    ,BranchAddress                                                      
    ,compcode                                                      
    ,CurrencyComp_id                                                      
    ,NotesForInvoice                                                      
    ,LegalName                                                      
    ,EmailIDForXO                                                      
    ,TwoDigitStateCode                                            
 ,TEntity_ID                                              
 ,tanNumber                                              
 ,Country                                              
 ,salesTaxRegNumber                                      
 ,StateID  ,                                  
 PANVERIFICATION,                                  
 TANVERIFICATION,                                  
 GSTVERIFICATION    ,                  
 TaxType                  
    )                                                      
   VALUES (                                                      
    @CompanyName                                                      
    ,@HeadOffice                                                    
    ,@PrintHeadOffAddress                                                      
    ,@Address                                                      
    ,@CityIATACode                                                      
    ,@Phone                                                      
    ,@Fax                                                      
    ,@Website                                                      
    ,@Email                                                      
    ,@PanNo                                                      
    ,@LSTNo                                                      
    ,@CSTNo                                         
    ,@VATNo                                                      
    ,@STNo                                                      
    ,@IsActive                                                      
    ,'Insert'                                                      
    ,@OperationBy                                            
    ,GETDATE()                                                      
    ,@MaxID                                                      
    ,@StateCode                                           
    ,@SAP_StateCode                                                      
    ,@SAP_CompanyCode                                                      
    ,@PostalCode                                                      
    ,@SAP_BusinessPlaceCode                                                      
    ,@CIN                                                      
    ,@MSME_RegNo                                                      
    ,@RegAddress                                                      
    ,@BranchAddress                                                      
,@compcode                                                      
,@CurrencyComp_id                                                      
    ,@NotesForInvoice                                                      
    ,@LegalName                                                      
    ,@EmailIDForXO                                         
    ,@TwoDigitStateCode                                                    
 ,@TEntity_ID                                                  
 ,@tanNumber                                              
 ,@Country                                              
 ,@salesTaxRegNumber                                     
 ,@StateID  ,                                  
 @PANVERIFICATION,                                  
 @TANVERIFICATION,                                  
 @GSTVERIFICATION,                  
 @TaxType                  
    );                                                      
                         
   SET @LogID = @@IDENTITY                      
   SELECT '200' AS returnCode, 'New record added successfully.' AS returnMessage , @LogID AS ID;                                                      
  END                                                      
 END                                                      
   -- Update Action                                                          
 ELSE IF @Action = 'U'                                                      
 BEGIN                                                      
  IF NOT EXISTS (                                                      
    SELECT CompanyID                                        
    FROM CompanyMaster                                                      
    WHERE UPPER(CompanyName) = UPPER(@CompanyName)                                                      
     AND CompanyID <> @CompanyID                                                      
    )                                                      
  BEGIN                                                      
   UPDATE CompanyMaster                                     
   SET CompanyName = @CompanyName                                                      
    ,HeadOffice = @HeadOffice                                                      
    ,PrintHeadOffAddress = @PrintHeadOffAddress                                                      
    ,Address = @Address                                                      
    ,CityIATACode = @CityIATACode                                                      
    ,Phone = @Phone                                                      
    ,Fax = @Fax                                                     
    ,Website = @Website                                                      
    ,Email = @Email                                                      
    ,PanNo = @PanNo                                                      
    ,LSTNo = @LSTNo                                                      
    ,CSTNo = @CSTNo                                                      
    ,VATNo = @VATNo                                                      
    ,STNo = @STNo                                                      
    ,IsActive = @IsActive                                                      
    ,Operation = 'Update'                                                  
    ,UpdatedBy = @OperationBy                                                      
    ,UpdatedOn = GETDATE()                                                      
    ,StateCodeID = @StateCode                                                      
    ,SAP_StateCode = @SAP_StateCode                    
    ,SAP_CompanyCode = @SAP_CompanyCode                                                      
    ,PostalCode = @PostalCode                                                      
    ,SAP_BusinessPlaceCode = @SAP_BusinessPlaceCode                                                      
    ,CIN = @CIN                                                      
    ,MsmeNo = @MSME_RegNo                                  
    ,RegAddress = @RegAddress                        
    ,BranchAddress = @BranchAddress                                                      
    ,compcode = @compcode                                           
    ,CurrencyComp_id = @CurrencyComp_id                                                      
    ,NotesForInvoice = @NotesForInvoice                                     
    ,LegalName = @LegalName                                                      
    ,EmailIDForXO = @EmailIDForXO                                                      
    ,TwoDigitStateCode = @TwoDigitStateCode                                                    
     ,tanNumber = @tanNumber                                               
 ,Country = @Country                                              
 ,salesTaxRegNumber  = @salesTaxRegNumber                                     
 ,StateID = @StateID,                                   
 PANVERIFICATION = @PANVERIFICATION,                                  
 TANVERIFICATION = @TANVERIFICATION,                         
 GSTVERIFICATION = @GSTVERIFICATION                            
 ,TEntity_ID =@TEntity_ID                    
 ,TaxType = @TaxType                  
   WHERE CompanyID = @CompanyID;                                                      
                  
   SELECT '200' AS returnCode, 'Record updated successfully.' AS returnMessage, @CompanyID as ID ;                                            
  END                                                      
  ELSE                                                      
  BEGIN                                                      
   SELECT '201' AS returnCode, 'Company name already exists. Please check and try again.' AS returnMessage;                                                      
  END                              
 END                                                      
   -- Select Action (Fetch Data)                                                          
 ELSE IF @Action = 'S'                                                      
 BEGIN                                                      
                                                      
    SELECT DISTINCT cm.CompanyID                                                      
    ,cm.CompanyName                                                     
    ,HeadOffice                                                      
    ,PrintHeadOffAddress                                           
    ,cm.Address                                                     
    ,Cm.CityIATACode                                                      
    ,Phone                                                      
    ,Fax                                                      
    ,Website                                                      
    ,Email                                                      
    ,PanNo                                                      
    ,LSTNo                                                      
    ,CSTNo                                                      
    ,VATNo                                               
    ,STNo                                                      
    ,Cm.IsActive                                                      
    ,Cm.OperationBy                                                      
    ,Ct.Name AS City                                                      
    ,St.Name AS [State]                                                      
    ,Cn.Name AS Country_Name --, '200' as returnCode,'DATA FETCHED' AS returnMessage                           
 , Cm.tanNumber as TanNumber                                              
 , Cm.Country                                  
 , Cm.salesTaxRegNumber                                          
 ,cm.BranchAddress                                        
 ,CIN                                        
 ,CSTNo                                        
 ,CompCode                                        
 ,CurrencyComp_id                                        
 ,EmailIDForXO                          
 ,LSTNo                                        
 ,LegalName                                        
 ,MsmeNo as MSME_RegNo                                        
 ,NotesForInvoice                                        
 ,Cm.PostalCode                                        
 ,RegAddress                                        
 ,SAP_BusinessPlaceCode                                        
 ,SAP_CompanyCode                                        
 ,SAP_StateCode                                        
 ,TwoDigitStateCode                    
 ,CM.StateCodeID  AS StateCode                                        
 ,Cn.IATACode AS Country                                       
 ,Country_IATACode                                     
 ,StateID ,                                  
 cm.PANVERIFICATION,                                  
 cm.TANVERIFICATION,                                  
 cm.GSTVERIFICATION ,                                 
  Ct.Name as CityName ,                  
  TaxType ,TEntity_ID                
                                        
 --,Ct.IATACode as CityIATACode                                        
   FROM CompanyMaster Cm                                            
   LEFT JOIN City Ct ON Cm.CityIATACode = Ct.IATACode                                                      
   LEFT JOIN [State] St ON St.State_ID = Ct.State_IATACode                                                      
   LEFT JOIN Country Cn ON Cn.IATACode = St.Country_IATACode                                 
  -- left join EmployeeMaster em on EM.CompanyID = Cm.CompanyID                
   WHERE       
  (@CompanyID IS NULL OR @CompanyID = 0 OR Cm.CompanyID = @CompanyID)      
  AND (@CityIATACode IS NULL OR @CityIATACode = '' OR Cm.CityIATACode = @CityIATACode)  
   AND (@IsActive IS NULL OR Cm.IsActive =@IsActive) 
 -- AND (@CompanyName IS NUll OR @CompanyName='' OR CM.CompanyName= @CompanyName)    
  --AND (      
  --  @OperationBy IS NULL OR EXISTS (      
  --    SELECT 1 FROM EmployeeMaster em WHERE em.CompanyID = Cm.CompanyID AND em.userid = @OperationBy)      
  --  )      
        
ORDER BY Cm.CompanyName ASC                                               
    ---- added for pagination                                                          
    --OFFSET @PageNumber * @PageSize ROWS                                                          
    --FETCH NEXT @PageSize ROWS ONLY;                                                          
    ----select                                            
                                
  END                
      
  ELSE IF @Action = 'F'                                                      
 BEGIN                                                      
                                                      
    SELECT DISTINCT cm.CompanyID                                                      
    ,cm.CompanyName                                                     
    ,HeadOffice                                                      
    ,PrintHeadOffAddress                                           
    ,cm.Address                                                     
    ,Cm.CityIATACode                                                      
    ,Phone                                                      
    ,Fax                                                      
    ,Website                                                      
    ,Email                                                      
    ,PanNo                                                      
    ,LSTNo                                                      
    ,CSTNo                                                      
    ,VATNo                                               
    ,STNo                                                      
    ,Cm.IsActive                                                      
    ,Cm.OperationBy                                                      
    ,Ct.Name AS City                                                      
    ,St.Name AS [State]                      
    ,Cn.Name AS Country_Name --, '200' as returnCode,'DATA FETCHED' AS returnMessage                           
 , Cm.tanNumber as TanNumber                                              
 , Cm.Country                                  
 , Cm.salesTaxRegNumber                                          
 ,cm.BranchAddress                                        
 ,CIN                                        
 ,CSTNo                                        
 ,CompCode                                        
 ,CurrencyComp_id                                        
 ,EmailIDForXO                                   
 ,LSTNo                                        
 ,LegalName                                        
,MsmeNo as MSME_RegNo                                        
 ,NotesForInvoice                                        
 ,Cm.PostalCode                                        
 ,RegAddress                                        
 ,SAP_BusinessPlaceCode                                        
 ,SAP_CompanyCode                                        
 ,SAP_StateCode                                        
 ,TwoDigitStateCode                    
 ,CM.StateCodeID  AS StateCode                                        
 ,Cn.IATACode AS Country                                       
 ,Country_IATACode                                     
 ,StateID ,                                  
 cm.PANVERIFICATION,                                  
 cm.TANVERIFICATION,                                  
 cm.GSTVERIFICATION ,                                 
  Ct.Name as CityName ,                  
  TaxType ,TEntity_ID                
                                        
 --,Ct.IATACode as CityIATACode                      
   FROM CompanyMaster Cm                                            
   LEFT JOIN City Ct ON Cm.CityIATACode = Ct.IATACode                                                      
   LEFT JOIN [State] St ON St.State_ID = Ct.State_IATACode                                                      
   LEFT JOIN Country Cn ON Cn.IATACode = St.Country_IATACode                                 
  -- left join EmployeeMaster em on EM.CompanyID = Cm.CompanyID                
   WHERE       
  (@CompanyID IS NULL OR @CompanyID = 0 OR Cm.CompanyID = @CompanyID)      
  AND (      
    @OperationBy IS NULL OR  EXISTS (      
      SELECT 1 FROM EmployeeMaster em WHERE  Cm.CompanyID in (SELECT value FROM STRING_SPLIT(em.CompanyID, ','))  AND em.userid = @OperationBy)      
    )      
        
ORDER BY Cm.CompanyName ASC                                               
    ---- added for pagination                                                          
    --OFFSET @PageNumber * @PageSize ROWS                                                          
    --FETCH NEXT @PageSize ROWS ONLY;                                                          
    ----select                                            
                                
  END                
     ELSE IF @Action = 'SA'                                                      
 BEGIN          
       
      
    -- Drop temp table if it exists      
    IF OBJECT_ID('tempdb..#TempCompany') IS NOT NULL      
        DROP TABLE #TempCompany      
      
    -- Insert paginated data into a temp table using ROW_NUMBER()      
    SELECT *      
    INTO #TempCompany      
    FROM (      
        SELECT       
            ROW_NUMBER() OVER (ORDER BY cm.CompanyID DESC) AS RowNum,      
            cm.CompanyID,      
            cm.CompanyName,      
            HeadOffice,      
            PrintHeadOffAddress,      
            cm.Address,      
            Cm.CityIATACode,      
            Phone,      
            Fax,      
            Website,      
            Email,      
            PanNo,      
                 
                  
            VATNo,      
            STNo,      
            Cm.IsActive,      
            Cm.OperationBy,      
            Ct.Name AS City,      
            St.Name AS [State],      
            Cn.Name AS Country_Name,      
            Cm.tanNumber AS TanNumber,      
            --Cm.Country,      
            Cm.salesTaxRegNumber,      
            cm.BranchAddress,      
            CIN,      
            CSTNo,      
            CompCode,      
            CurrencyComp_id,      
            EmailIDForXO,      
            LSTNo,      
            LegalName,      
            MsmeNo AS MSME_RegNo,      
            NotesForInvoice,      
            Cm.PostalCode,      
            RegAddress,      
            SAP_BusinessPlaceCode,      
            SAP_CompanyCode,      
            SAP_StateCode,      
            TwoDigitStateCode,      
            CM.StateCodeID AS StateCode,      
            Cn.IATACode AS Country,      
            Country_IATACode,      
            StateID,      
            cm.PANVERIFICATION,      
            cm.TANVERIFICATION,      
            cm.GSTVERIFICATION,      
            Ct.Name AS CityName,      
            TaxType,      
            TEntity_ID      
        FROM CompanyMaster Cm      
        LEFT JOIN City Ct ON Cm.CityIATACode = Ct.IATACode      
        LEFT JOIN [State] St ON St.State_ID = Ct.State_IATACode      
        LEFT JOIN Country Cn ON Cn.IATACode = St.Country_IATACode      
    ) AS RowConstrainedResult      
      
    -- Get total record count      
    SELECT @TotalRecordCount = COUNT(*) FROM #TempCompany      
      
    -- Handle default row count      
    IF @Row_Count = '' OR @Row_Count = -1      
    BEGIN      
        SET @Row_Count = @TotalRecordCount      
    END      
      
    -- Fetch paginated result using OFFSET      
          
    SET @SQL = '      
        SELECT * FROM #TempCompany      
        ORDER BY RowNum      
        OFFSET ' + CAST(@PageNumber * @Row_Count AS VARCHAR(20)) + ' ROWS      
        FETCH NEXT ' + CAST(@Row_Count AS VARCHAR(20)) + ' ROWS ONLY'      
      
    EXEC sp_executesql @SQL      
      
    -- Return metadata      
    SELECT CAST(@TotalRecordCount AS VARCHAR(20)) AS Row_Count,      
           '200' AS returnCode,      
           'Data Found' AS returnMessage      
      
      
                                                      
                                
  END          

       
 ELSE IF @Action = 'EX'                                                      
BEGIN                                                      
    SELECT       
        cm.CompanyID,      
        cm.CompanyName,      
        cm.BranchAddress,      
        Cn.Name AS Country_Name,      
        St.Name AS StateName,      
        Ct.Name AS CityName,      
        SCM.State_Code AS StateCodeName, -- Assuming this should be the state name      
        cm.TwoDigitStateCode,      
        cm.PostalCode,      
        cm.Phone,      
        cm.Fax,      
        cm.Email,      
        cm.Website,      
        cm.SAP_BusinessPlaceCode,      
        cm.CompCode,      
        cm.SAP_CompanyCode,      
        cm.LegalName,      
        -- Assuming CurrencyName should come from a Currency table or use existing field      
        Curr.CurrencyCode AS CurrencyName, -- You may need to join with Currency table      
        cm.NotesForInvoice,      
        cm.EmailIDForXO,      
  CASE      
   WHEN isnull(cm.TaxType,'')='' THEN '-'      
   WHEN isnull(cm.TaxType,'0')='0' THEN '-'      
   WHEN isnull(cm.TaxType,'')='1' THEN 'GST'      
   WHEN isnull(cm.TaxType,'')='2' THEN 'VAT'      
  END      
        as TaxType,      
        cm.tanNumber AS [TaxRegistrationNumberTRN],      
        CASE             
            WHEN cm.IsActive = 1 THEN 'True'            
            WHEN cm.IsActive = 0 THEN 'False'            
        END AS RecordIsActive      
    FROM CompanyMaster cm          
    LEFT JOIN City Ct ON cm.CityIATACode = Ct.IATACode                                                      
    LEFT JOIN [State] St ON St.State_ID = Ct.State_IATACode                                                      
    LEFT JOIN Country Cn ON Cn.IATACode = St.Country_IATACode         
 LEFT JOIN CurrencyMaster Curr ON cm.CurrencyComp_id=Curr.id      
 LEFT JOIN State_Code_Master SCM ON ST.StateCodeID=SCM.ID      
    WHERE (@CompanyID IS NULL OR @CompanyID = 0 OR cm.CompanyID = @CompanyID)                  
    ORDER BY cm.CompanyID DESC                                                    
END      
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
  END 
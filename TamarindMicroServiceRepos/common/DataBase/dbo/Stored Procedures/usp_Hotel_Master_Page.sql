CREATE PROCEDURE [dbo].[usp_Hotel_Master_Page] (                    
 @HotelID INT = NULL                    
 ,@AccCode VARCHAR(50) = NULL                    
 ,@HotelCode VARCHAR(50) = NULL                    
 ,@HotelName VARCHAR(200) = NULL    
  ,@HotelChainID int = NULL
 ,@HotelRatingID INT = NULL                    
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
 ,@StateCode VARCHAR(500) = NULL                    
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
 ,@LegalEntity VARCHAR(30) = NULL                    
 ,@IsSEZ BIT = 0                    
 ,@MembershipNo VARCHAR(30) = NULL                    
 ,@NonGSTRegistered BIT = 0                    
 ,@PayMode BIT = 0                    
 ,@Action CHAR(2) = ''                    
 ,@Page INT = 1                    
 ,@Country VARCHAR(500) = ''                    
 ,@State VARCHAR(500) = ''                    
 ,@City VARCHAR(500) = ''                    
 ,@Beneficiary_Name VARCHAR(max) = ''                    
 ,@Tax_Reg_Number NVARCHAR(MAX) = ''                    
 ,@EmailGeneral NVARCHAR(MAX) = ''                    
 ,@EmailFinance NVARCHAR(MAX) = ''      
 ,@Country_IATACode CHAR(10) = ''    
 ,@Contact1 varchar(50)=''  
 ,@Contact2 varchar(50)=''  
 ,@Contact1IsMobile bit=NULL  
 ,@Contact2IsMobile bit=NULL 
 ,@Row_Count VARCHAR(max) = '100'                  
   , @PageNumber INT = 0 
 )                    
AS                    
BEGIN  
 DECLARE 
		  @TotalRecordCount INT  ,
		   @SQL NVARCHAR(MAX) ;
 --IF @Action = 'S'                    
 --BEGIN  
 
 --IF OBJECT_ID('TEMPDB..#TempReport') IS NOT NULL                  
 --  DROP TABLE #TempReport

 -- SELECT *   INTO #TempReport            
 -- FROM (                    
 --  SELECT DISTINCT TOP 100000 ROW_NUMBER() OVER (                    
 --    ORDER BY Hm.OperationOn DESC                    
 --    ) AS RowNum                    
 --   ,Hm.HotelID                    
 --   ,Hm.HotelCode                    
 --   ,Hm.HotelName                    
 --   ,Hm.CityIATACode                    
 --   ,Hr.Code AS HotelRatingCode                    
 --   ,Hg.Name AS HotelGroupName                    
 --   ,Ct.Name AS City                    
 --   --,St.Name AS STATE             
 --,HM.StateCodeID AS StateCode            
 --   ,Cn.IATACode AS Country            
 --,Cn.Name AS CountryName           
 --   ,Hm.Address --AS HotelAddress                    
 --   ,Hm.IsActive                    
 --   ,ImageExists = CASE                     
 --    WHEN EXISTS (                    
 --      SELECT ID                    
 --      FROM UploadImage                    
 --      WHERE ParentPageType = 6                    
 --       AND ParentID = Hm.HotelID                    
 --      )                    
 --     THEN 'Yes'                    
 --    ELSE 'No'                    
 --    END                    
 --   ,ContentExists = CASE                     
 --    WHEN EXISTS (                    
 --      SELECT TOP 1 HotelID                    
 --      FROM HotelHeaderDetails                    
 --      WHERE HotelID = Hm.HotelID                    
 --      )                    
 --     THEN 'Yes'                    
 --    ELSE 'No'                    
 --    END                    
 --   -- ,(SELECT CONVERT(VARCHAR(20),HMA.OperationOn,13) FROM HotelMaster_Audit HMA WHERE HMA.HotelID=Hm.HotelID AND  HMA.Operation='Insert') AS 'OperationOn'                                                        
 --   ,Hm.Latitude                    
 --   ,Hm.Longitude                    
 --   ,Hm.OperationOn AS OperationOn1                    
 --   ,ABM.BankAccountName                
 --   ,Hm.PanNo                    
 --   ,Hm.STRegNo                    
 --   ,Hm.ChequeFavouring                    
 --   ,Hm.BankName                    
 --   ,AccountNo                    
 --   ,BranchName                    
 --   ,IFSCCode                    
 --   ,SWIFTCode                    
 --   ,CreditApplicable                    
 --   ,CreateAdvanceAccount                    
 --   ,CreateCommissionAccount                    
 --   ,CreditPeriod                    
 --   ,Cu.Code AS Currency                    
 --   ,Hm.CreditAmount                    
 --   ,Hm.CreditApproveBy                    
 --   ,Hm.PhoneNo                    
 --   ,Hm.EmailID                    
 --   ,St.Name AS StateName                    
 --   --,(                    
 --   -- SELECT TOP 1 State_Code                    
 --   -- FROM State_Code_Master                    
 --   -- WHERE ID = Hm.StateCodeID                    
 --   -- ) AS StateCode                
 --   ,Hm.Comment                    
 --   ,Hm.Website                    
 --   ,CM.CompanyName                    
 --   ,Hm.LegalName                    
 --   ,(                    
 --    SELECT TOP 1 CompanyID                    
 --    FROM CompanyMaster                    
 --    WHERE CompanyID = HM.BTCBranchPosting                   
 --    ) AS BTCBranchPosting -- Added by dhvani@0203020202 to export to excel                                          
 --   --,(                                    
 --   -- SELECT TOP 1 CompanyName                                    
 --   -- FROM CompanyMaster                                    
 --   -- WHERE CompanyID = HM.BTCBranchPosting                                    
 --   -- ) AS BTCBranchPosting                                  
 --   ,Hm.HotelSAPCode                    
 --   ,Hm.GSTRequired                    
 --   ,Hm.isActiveSAP                    
 --   ,Hm.TANDetails                    
 --   ,Hm.PreviousCode                    
 --   ,Hm.MSME                    
 --   ,Hm.Deductee                    
 --   ,Hm.WithHoldigTax                    
 --   ,Hm.RoomCount                    
 --   ,Hm.HotelSAPCode AS 'SAPCode'                    
 --   ,LE.LegalEntTypeID AS 'LegalEntity' --, Hm.LegalName              
 --,HotelRatingID            
 --,HotelTypeID            
 --,ChainIATACode            
 --,MSMEType            
 --,MembershipNo            
 --,MobileNo            
 --,HM.PostalCode            
 --,EmailGeneral,        
 --Hm.InfantFromAge,        
 --Hm.InfantToAge,        
 --Hm.ChildFromAge,        
 --Hm.ChildToAge,        
 --Hm.AdultFromAge,        
 --Hm.AdultToAge,        
 --Hm.EmailFinance,        
 --Hm.CreditCurrencyCode,        
 --Hm.Beneficiary_Name,        
 --Ct.State_IATACode,        
 --Hm.FaxNo,    
 --Hm.ZoneID   
 --,Contact1  
 --,Contact2  
 --,Contact1IsMobile  
 --,Contact2IsMobile  
 -- ,HotelChainID 

 --  FROM HotelMaster Hm                    
 --  INNER JOIN HotelGroups Hg WITH (NOLOCK) ON Hm.ChainIATACode = Hg.IATACode                    
 --  INNER JOIN City Ct WITH (NOLOCK) ON Hm.CityIATACode = Ct.IATACode                    
 --  INNER JOIN STATE St                    
 --  WITH (NOLOCK) ON St.State_ID = Ct.State_IATACode                    
 --  INNER JOIN Country Cn WITH (NOLOCK) ON Cn.IATACode = St.Country_IATACode                    
 --  INNER JOIN HotelRating Hr WITH (NOLOCK) ON Hm.HotelRatingID = Hr.ID                    
 --  LEFT JOIN AccountsBankMaster ABM WITH (NOLOCK) ON ABM.AccountBankMasterID = Hm.BankAccountID --added by sanket @ 12/11/2014                                                      
 --  LEFT JOIN Currency Cu WITH (NOLOCK) ON Cu.Code = Hm.CreditCurrencyCode --added by sanket @ 12/11/2014                                                               
 --  LEFT JOIN State_Code_Master SC WITH (NOLOCK) ON SC.ID = Hm.StateCodeID                    
 --  LEFT JOIN CompanyMaster CM WITH (NOLOCK) ON Hm.CompanyID = CM.CompanyID                    
 --  LEFT JOIN LegalEntityType_Master LE ON Hm.LegalEntity = LE.LegalEntTypeID                    
 --  ORDER BY Hm.HotelID DESC                    
 --  ) AS RowConstrainedResult          
 --  WHERE (       @HotelID IS NULL       OR @HotelID = 0       OR HotelID = @HotelID       )                    
 --  and (CityIATACode = @CityIATACode OR @CityIATACode IS NULL  OR  @CityIATACode = '')   
   

 --  SELECT @TotalRecordCount = count(*)                  
 -- FROM #TempReport                  
                  
 -- IF @Row_Count = ''                  
 --  OR @Row_Count = - 1                  
 -- BEGIN                  
 --  SET @Row_Count = @TotalRecordCount                  
 -- END                  
     
 -- SELECT @SQL = 'select * from #TempReport                                                                                                                          
 --   ORDER BY HotelID ASC                                                                              
 --   OFFSET ' + CAST((@PageNumber * @Row_Count) AS VARCHAR(20)) + ' ROWS                      
 --   FETCH NEXT ' + CAST(@Row_Count AS VARCHAR(20)) + ' ROWS ONLY'                  
                  
 -- EXEC sys.sp_executesql @SQL

	--			 select  CAST(@TotalRecordCount AS VARCHAR(20))  as Row_Count 
                                   
 --END                    
IF @Action = 'S'                      
 BEGIN                      
  SELECT *                 
  FROM (                      
   SELECT DISTINCT TOP 100000 ROW_NUMBER() OVER (                      
     ORDER BY Hm.OperationOn DESC                      
     ) AS RowNum                      
    ,Hm.HotelID                      
    ,Hm.HotelCode                      
    ,Hm.HotelName                      
    ,Hm.CityIATACode                      
    ,Hr.Code AS HotelRatingCode                      
    ,Hg.Name AS HotelGroupName                      
    ,Ct.Name AS City                      
    --,St.Name AS STATE               
 ,HM.StateCodeID AS StateCode              
    ,Cn.IATACode AS Country              
 ,Cn.Name AS CountryName             
    ,Hm.Address --AS HotelAddress                      
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
    -- ,(SELECT CONVERT(VARCHAR(20),HMA.OperationOn,13) FROM HotelMaster_Audit HMA WHERE HMA.HotelID=Hm.HotelID AND  HMA.Operation='Insert') AS 'OperationOn'                                                          
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
    --,(                      
    -- SELECT TOP 1 State_Code                      
    -- FROM State_Code_Master                      
    -- WHERE ID = Hm.StateCodeID                      
    -- ) AS StateCode                  
    ,Hm.Comment                      
    ,Hm.Website                      
    ,CM.CompanyName                      
    ,Hm.LegalName                      
    ,(                      
     SELECT TOP 1 CompanyID                      
     FROM CompanyMaster                      
     WHERE CompanyID = HM.BTCBranchPosting                     
     ) AS BTCBranchPosting -- Added by dhvani@0203020202 to export to excel                                            
    --,(                                      
    -- SELECT TOP 1 CompanyName                                      
    -- FROM CompanyMaster                                      
    -- WHERE CompanyID = HM.BTCBranchPosting                                      
    -- ) AS BTCBranchPosting                                    
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
    ,LE.LegalEntTypeID AS 'LegalEntity' --, Hm.LegalName                
 ,HotelRatingID              
 ,HotelTypeID              
 --,ChainIATACode              
 ,MSMEType              
 ,MembershipNo              
 ,MobileNo              
 ,HM.PostalCode              
 ,EmailGeneral,          
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
 Hm.ZoneID     
 ,Contact1    
 ,Contact2    
 ,Contact1IsMobile    
 ,Contact2IsMobile
 ,ChainIATACodeHG AS HotelGroupID
  ,ChainIATACodeHG AS HotelChainID
 
-- ,HM.IsActive
   FROM HotelMaster Hm                      
   INNER JOIN HotelGroups Hg WITH (NOLOCK) ON Hm.ChainIATACodeHG = Hg.HotelGroupID                      
   INNER JOIN City Ct WITH (NOLOCK) ON Hm.CityIATACode = Ct.IATACode                      
   INNER JOIN STATE St     
   WITH (NOLOCK) ON St.State_ID = Ct.State_IATACode                      
   INNER JOIN Country Cn WITH (NOLOCK) ON Cn.IATACode = St.Country_IATACode                      
   INNER JOIN HotelRating Hr WITH (NOLOCK) ON Hm.HotelRatingID = Hr.ID                      
   LEFT JOIN AccountsBankMaster ABM WITH (NOLOCK) ON ABM.AccountBankMasterID = Hm.BankAccountID --added by sanket @ 12/11/2014                                                        
   LEFT JOIN Currency Cu WITH (NOLOCK) ON Cu.Code = Hm.CreditCurrencyCode --added by sanket @ 12/11/2014                                                                 
   LEFT JOIN State_Code_Master SC WITH (NOLOCK) ON SC.ID = Hm.StateCodeID                      
   LEFT JOIN CompanyMaster CM WITH (NOLOCK) ON Hm.CompanyID = CM.CompanyID                      
   LEFT JOIN LegalEntityType_Master LE ON Hm.LegalEntity = LE.LegalEntTypeID                      
   ORDER BY Hm.HotelID DESC                      
   ) AS RowConstrainedResult              
   WHERE (       @HotelID IS NULL       OR @HotelID = 0       OR HotelID = @HotelID       )                      
   and (CityIATACode = @CityIATACode OR @CityIATACode IS NULL  OR  @CityIATACode = '')                      
    --AND                        
    -- LegalName LIKE CASE                                       
    --   WHEN ISNULL(@LegalName, '') <> ''                                      
    --    THEN '%' + @LegalName + '%'                                      
    --   ELSE LegalName                                      
     --  END                      
    --AND                                    
   --  RowConstrainedResult.HotelAddress LIKE CASE                                       
   --    WHEN ISNULL(@Address, '') <> ''                                      
   --     THEN '%' + @Address + '%'                                      
   --    ELSE RowConstrainedResult.HotelAddress                                      
   --    END  AND                                    
   --   Country LIKE CASE                                       
   --    WHEN ISNULL(@Country, '') <> ''                                      
   --     THEN '%' + @Country + '%'                                      
   --    ELSE Country                                  
   --    END  AND                                   
   --   State LIKE CASE                                       
   --    WHEN ISNULL(@State, '') <> ''                                      
   --     THEN '%' + @State + '%'                                      
   --    ELSE State                             
   --    END   AND                                    
   --   City LIKE CASE                                       
   --    WHEN ISNULL(@City, '') <> ''                                      
   --     THEN '%' + @City + '%'                                      
   --    ELSE City                                      
   --    END                                      
   --  AND                                    
   --   CreditApplicable LIKE CASE                                       
   --    WHEN ISNULL(@CreditApplicable, '') <> ''                                      
   --     THEN  @CreditApplicable                                       
   --    ELSE CreditApplicable                                      
   --    END                                     
   -- AND                                    
   --   RowConstrainedResult.PanNo LIKE CASE                                       
   --    WHEN ISNULL(@PanNo, '') <> ''                                      
   --     THEN   '%' + @PanNo + '%'                                       
   --    ELSE RowConstrainedResult.PanNo                                
   --    END                                  --AND                                    
   --   RowConstrainedResult.CityIATACode LIKE CASE                                       
   --    WHEN ISNULL(@CityIATACode, '') <> ''                                      
   --     THEN '%' + @CityIATACode + '%'                  
   --    ELSE RowConstrainedResult.CityIATACode                                  
   --    END                        
   -- AND                                    
   -- RowNum >= @Page                                      
   --  AND RowNum <= (@Page + 9)                                      
   --ORDER BY RowNum                                      
   --SELECT '' AS returnCode                                      
   --  ,'' AS returnMessage                                      
 END                      
END


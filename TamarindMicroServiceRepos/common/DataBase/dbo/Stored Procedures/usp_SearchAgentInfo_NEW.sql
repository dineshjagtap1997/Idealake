<<<<<<< HEAD
<<<<<<< HEAD
﻿CREATE PROCEDURE [dbo].[usp_SearchAgentInfo_NEW]                                        
(    
  
--exec [usp_SearchAgentInfo_NEW] null,null,0,'IN',null,null,0  
 @AgentID INT = null,                                        
 @City_IATACode VARCHAR(10) = null,                    
 @StateCode INT  = null,                    
 @CountryCode VARCHAR(10)= null,                     
 @SelectedData VARCHAR(20)= null,                     
 @SelectedValue VARCHAR(10)= null,                    
 @EmpID int = null,                    
 @Page int  = null                   
 --@CategoryID INT,                                        
 --@GroupID INT,         --commented by dhvani 207192022                              
 --@GroupID Varchar(20),   --added by dhvani 207192022                    
 --@LoginID INT,                                    
 --@OnlineAccess VARCHAR(50),                                    
 --@OutstandingAmount NUMERIC(10,2),  --commented by dhvani 207192022                                             
 --@OutstandingAmount VARCHAR(10) ,   --added by dhvani 207192022                    
 --@OutstandingAmountValue VARCHAR(10) ,                    
                    
)                                       
AS                                        
BEGIN              
--SELECT '200' AS returnCode, 'Data Retrieved' as returnMessage              
-- srart added by dhvani 207192022                    
if @AgentID = ''  set @AgentID = null                    
if @City_IATACode = '' set @City_IATACode = null                    
--if @StateCode = '' set @StateCode = null    
SET @StateCode = NULLIF(NULLIF(@StateCode, ''), 0)  
if @CountryCode = '' set @CountryCode = null                    
if @SelectedData  = '' set @SelectedData = null                    
if @SelectedValue = '' set @SelectedValue = null                    
--if @EmpID = '' set @EmpID = NULL    
SET @EmpID = NULLIF(NULLIF(@EmpID, ''), 0)  
  
-- end added by dhvani 207192022                     
                    
IF(@SelectedValue IS NULL)                        
 BEGIN    
   
  
   --select * from  dbo.fnGetSearchAgentInfoNew(@AgentID,@City_IATACode,@StateCode, @CountryCode, @SelectedData, @SelectedValue, @EmpID) AS A                         
  select * from  dbo.fnGetSearchAgentInfoNew(@AgentID,@City_IATACode,@StateCode, @CountryCode, @EmpID) AS A     
    --select * from  dbo.fnGetSearchAgentInfoNew(null,null,null, 'IN', null) AS A     
 END                      
                           
 ELSE                    
                    
 BEGIN                    
 IF(@SelectedValue = 'GST')                        
 BEGIN                    
 select * from  dbo.fnGetSearchAgentInfoNew(@AgentID,@City_IATACode,@StateCode, @CountryCode,  @EmpID) AS A                            
 WHERE a.GST = @SelectedData                     
 END                    
 ELSE IF(@SelectedValue = 'PAN')                        
 BEGIN                    
 select * from  dbo.fnGetSearchAgentInfoNew(@AgentID,@City_IATACode,@StateCode, @CountryCode,  @EmpID) AS A                           
 WHERE PanNo = @SelectedData                    
 END                    
                      
 ELSE IF(@SelectedValue = 'TAN')                        
 BEGIN                    
 select * from  dbo.fnGetSearchAgentInfoNew(@AgentID,@City_IATACode,@StateCode, @CountryCode,  @EmpID) AS A                           
 WHERE  A.TANNo = @SelectedData                    
 END                    
 ELSE                    
 BEGIN                    
 --select * from  dbo.fnGetSearchAgentInfoNew(@AgentID,@City_IATACode,@StateCode, @CountryCode, @EmpID) AS A                           
 --print  'Normal'                    
 -- SET @Page = @Page + 1                     
 -- declare @Size int  = 15                    
                     
 SELECT * FROM (SELECT DISTINCT TOP 100000 ROW_NUMBER() OVER(ORDER BY AM.AgentName asc) AS RowNum, AM.AgentID,AM.AgentCode,AM.AgentName,AM.CategoryID,AM.GroupID,AM.MarketID,AM.City_IATACode,AM.Website,AM.PhoneNo,   
 AM.MobileNo,AM.EmailID,AM.PanNo,AM.ChequeFavouring,AM.[Address],AM.CreditApplicable,AM.CreditCurrencyCode, AM.IsActive,                                
 AM.CreditAllowance,AM.Threshold,AM.CreditPeriod,AM.OutStandingAmount, AM.TamSalesName,am.GSTIN,AM.contact1,                             
 S.Name AS StateName,   CASE WHEN EXISTS(SELECT AgentLoginID from AgentLogin Where AgentID= AM.AgentID) THEN 1                                
 ELSE 0 END AS [OnlineExists],                         
 --(SELECT top 1 UserID from AgentLogin Where AgentID= AM.AgentID)AS [UserID],                                    
 --CASE WHEN ISNULL(UserID,'')<>'' THEN  [UserID] ELSE 'No Login' END AS UserID,                    
 ACM.CategoryCode,                                
 'City :'+ISNULL(C.Name,'') +'<br/>'+                                              
 --'Market :'+M.Name+'<br/><br/>'+                                              
 'Address :'+ISNULL(AM.[Address],'') AS [AddressInfo],                                
 'Phone :'+ISNULL(REPLACE(AM.PhoneNo,'~','-'),'') +'<br/>'+                                            
 'Mobile :'+ISNULL(REPLACE(AM.MobileNo,'~','-'),'')+'<br/>'+                                            
 'Fax :'+ISNULL(REPLACE(AM.FaxNo,'~','-'),'') AS Contact,                                
 ISNULL(Curr.Symbol,'')  + ' ' + CONVERT(VARCHAR(20),                        
 CONVERT(NUMERIC(18,2),AM.OutStandingAmount)) AS OutStandingAmountWithCurr,                        
                     
 'Allowance :'+ISNULL(CR.Symbol,'')  + ' ' +ISNULL(CONVERT(VARCHAR(20),CONVERT(NUMERIC(18,2),AM.CreditAllowance)),'0.00')+'<br/>'+                                            
 --'Threshold :'+ISNULL(CR.Symbol,'')  + ' ' +ISNULL(CONVERT(VARCHAR(20),CONVERT(NUMERIC(18,2),AM.Threshold)),'0.00')+'<br/>'+                                            
 'On Credit :'+ CASE WHEN CreditApplicable=0 then 'No' else 'Yes' end                                            
 AS CreditInfo,                    
 AM.TANDetails AS TANNo,                    
 AM.STRegNo AS GST,                    
 EMP.EmpName AS TAMSales,                     
 AM.OperationOn                    
                     
 from AgentMaster AM                           
 LEFT JOIN Currency CR ON  CR.Code=AM.CreditCurrencyCode                      
 LEFT JOIN EmployeeMaster EMP ON AM.RelatedEmployeeID = EMP.EmpID                      
                          
 LEFT JOIN City C ON AM.AddressCity=C.IATACode                                              
 LEFT JOIN [State] S ON S.State_ID= AM.AddressState                                       
 LEFT JOIN Country CN ON CN.IATACode=AM.AddressCountry                                          
 left JOIN AgentCategoryMaster ACM ON  ACM.CategoryID=AM.CategoryID                                         
 LEFT JOIN Currency Curr ON  Curr.Code = AM.CreditCurrencyCode                         
                      
  WHERE       
        (@AgentID IS NULL OR AM.AgentID = @AgentID)      
        AND (@City_IATACode IS NULL OR @City_IATACode = '' or AM.AddressCity = @City_IATACode)      
        AND (@StateCode IS NULL OR AM.AddressState = @StateCode)      
        AND (@CountryCode IS NULL OR AM.AddressCountry = @CountryCode)      
        AND (@EmpID IS NULL OR @EmpID = 0 or @EmpID = AM.TamSalesrep)    
 ORDER BY AM.AgentName ASC)                    
   AS RowConstrainedResult                    
   --WHERE   RowNum >= @Page                     
   --AND RowNum < (@Page + 15)                    
   --ORDER BY RowNum                      
 END                    
   END                                      
END                     
--select tandetails, STRegNo,PanNo, * from agentmaster where tandetails != ''                    
--select * from agentmaster where panno='AABCK7777J' 
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
﻿CREATE PROCEDURE [dbo].[usp_SearchAgentInfo_NEW] (  
 --exec [usp_SearchAgentInfo_NEW] null,null,0,'IN',null,null,0      
 @AgentID INT = NULL  
 ,@City_IATACode VARCHAR(10) = NULL  
 ,@StateCode INT = NULL  
 ,@CountryCode VARCHAR(10) = NULL  
 ,@SelectedData VARCHAR(20) = NULL  
 ,@SelectedValue VARCHAR(10) = NULL  
 ,@EmpID INT = NULL  
 ,@Page INT = NULL  
 --@CategoryID INT,                                            
 --@GroupID INT,         --commented by dhvani 207192022                                  
 --@GroupID Varchar(20),   --added by dhvani 207192022                        
 --@LoginID INT,                                        
 --@OnlineAccess VARCHAR(50),                                        
 --@OutstandingAmount NUMERIC(10,2),  --commented by dhvani 207192022                                                 
 --@OutstandingAmount VARCHAR(10) ,   --added by dhvani 207192022                        
 --@OutstandingAmountValue VARCHAR(10) ,                        
 )  
AS  
BEGIN  
 --SELECT '200' AS returnCode, 'Data Retrieved' as returnMessage                  
 -- srart added by dhvani 207192022                        
 IF @AgentID = ''  
  SET @AgentID = NULL  
  
 IF @City_IATACode = ''  
  SET @City_IATACode = NULL  
 --if @StateCode = '' set @StateCode = null        
 SET @StateCode = NULLIF(NULLIF(@StateCode, ''), 0)  
  
 IF @CountryCode = ''  
  SET @CountryCode = NULL  
  
 IF @SelectedData = ''  
  SET @SelectedData = NULL  
  
 IF @SelectedValue = ''  
  SET @SelectedValue = NULL  
 --if @EmpID = '' set @EmpID = NULL        
 SET @EmpID = NULLIF(NULLIF(@EmpID, ''), 0)  

 -- end added by dhvani 207192022                         
 IF (@SelectedValue IS NULL)  
 BEGIN  
  --select * from  dbo.fnGetSearchAgentInfoNew(@AgentID,@City_IATACode,@StateCode, @CountryCode, @SelectedData, @SelectedValue, @EmpID) AS A                             
  SELECT *  
  FROM dbo.fnGetSearchAgentInfoNew(@AgentID, @City_IATACode, @StateCode, @CountryCode, @EmpID) AS A  
   --select * from  dbo.fnGetSearchAgentInfoNew(null,null,null, 'IN', null) AS A         
 END  
 ELSE  
 BEGIN  
  IF (@SelectedValue = 'GST')  
  BEGIN  
   SELECT *  
   FROM dbo.fnGetSearchAgentInfoNew(@AgentID, @City_IATACode, @StateCode, @CountryCode, @EmpID) AS A  
   --WHERE a.GST = @SelectedData  
   WHERE a.SalesTaxRegNumber = @SelectedData  
  END  
  ELSE IF (@SelectedValue = 'PAN')  
  BEGIN  
   SELECT *  
   FROM dbo.fnGetSearchAgentInfoNew(@AgentID, @City_IATACode, @StateCode, @CountryCode, @EmpID) AS A  
   WHERE PanNo = @SelectedData  
  END  
  ELSE IF (@SelectedValue = 'TAN')  
  BEGIN  
   SELECT *  
   FROM dbo.fnGetSearchAgentInfoNew(@AgentID, @City_IATACode, @StateCode, @CountryCode, @EmpID) AS A  
   WHERE A.TANNo = @SelectedData  
  END  
  ELSE  
  BEGIN  
   --select * from  dbo.fnGetSearchAgentInfoNew(@AgentID,@City_IATACode,@StateCode, @CountryCode, @EmpID) AS A                               
   --print  'Normal'                        
   -- SET @Page = @Page + 1                         
   -- declare @Size int  = 15 
  
   SELECT *  
   FROM (  
    SELECT DISTINCT TOP 100000 ROW_NUMBER() OVER (  
      ORDER BY AM.AgentName ASC  
      ) AS RowNum  
     ,AM.AgentID  
	 ,AM.STRegNo AS SalesTaxRegNumber
     ,AM.AgentCode  
     ,AM.AgentName  
     ,AM.CategoryID  
     ,AM.GroupID  
     ,AM.MarketID  
     ,AM.City_IATACode  
     ,AM.Website  
     ,AM.PhoneNo  
     ,AM.MobileNo  
     ,AM.EmailID  
     ,AM.PanNo  
     ,AM.ChequeFavouring  
     ,AM.[Address]  
     ,AM.CreditApplicable  
     ,AM.CreditCurrencyCode  
     ,AM.IsActive  
     ,AM.CreditAllowance  
     ,AM.Threshold  
     ,AM.CreditPeriod  
     ,AM.OutStandingAmount  
     ,AM.TamSalesName  
     ,am.GSTIN 
	 
     ,AM.contact1  
     ,S.Name AS StateName  
     ,CASE   
      WHEN EXISTS (  
        SELECT AgentLoginID  
        FROM AgentLogin  
        WHERE AgentID = AM.AgentID  
        )  
       THEN 1  
      ELSE 0  
      END AS [OnlineExists]  
     ,  
     --(SELECT top 1 UserID from AgentLogin Where AgentID= AM.AgentID)AS [UserID],                                        
     --CASE WHEN ISNULL(UserID,'')<>'' THEN  [UserID] ELSE 'No Login' END AS UserID,                        
     ACM.CategoryCode  
     ,'City :' + ISNULL(C.Name, '') + '<br/>' +  
     --'Market :'+M.Name+'<br/><br/>'+                                                  
     'Address :' + ISNULL(AM.[Address], '') AS [AddressInfo]  
     ,'Phone :' + ISNULL(REPLACE(AM.PhoneNo, '~', '-'), '') + '<br/>' + 'Mobile :' + ISNULL(REPLACE(AM.MobileNo, '~', '-'), '') + '<br/>' + 'Fax :' + ISNULL(REPLACE(AM.FaxNo, '~', '-'), '') AS Contact  
     ,ISNULL(Curr.Symbol, '') + ' ' + CONVERT(VARCHAR(20), CONVERT(NUMERIC(18, 2), AM.OutStandingAmount)) AS OutStandingAmountWithCurr  
     ,'Allowance :' + ISNULL(CR.Symbol, '') + ' ' + ISNULL(CONVERT(VARCHAR(20), CONVERT(NUMERIC(18, 2), AM.CreditAllowance)), '0.00') + '<br/>' +  
     --'Threshold :'+ISNULL(CR.Symbol,'')  + ' ' +ISNULL(CONVERT(VARCHAR(20),CONVERT(NUMERIC(18,2),AM.Threshold)),'0.00')+'<br/>'+                                                
     'On Credit :' + CASE   
      WHEN CreditApplicable = 0  
       THEN 'No'  
      ELSE 'Yes'  
      END AS CreditInfo  
     ,AM.TANDetails AS TANNo  
     ,AM.STRegNo AS GST  
     ,EMP.EmpName AS TAMSales  
     ,AM.OperationOn  
       
    FROM AgentMaster AM  
    LEFT JOIN Currency CR ON CR.Code = AM.CreditCurrencyCode  
    LEFT JOIN EmployeeMaster EMP ON AM.RelatedEmployeeID = EMP.EmpID  
    LEFT JOIN City C ON AM.AddressCity = C.IATACode  
    LEFT JOIN [State] S ON S.State_ID = AM.AddressState  
    LEFT JOIN Country CN ON CN.IATACode = AM.AddressCountry  
    LEFT JOIN AgentCategoryMaster ACM ON ACM.CategoryID = AM.CategoryID  
    LEFT JOIN Currency Curr ON Curr.Code = AM.CreditCurrencyCode  
    WHERE (  
      @AgentID IS NULL  
      OR AM.AgentID = @AgentID  
      )  
     AND (  
      @City_IATACode IS NULL  
      OR @City_IATACode = ''  
      OR AM.AddressCity = @City_IATACode  
      )  
     AND (  
      @StateCode IS NULL  
      OR AM.AddressState = @StateCode  
      )  
     AND (  
      @CountryCode IS NULL  
      OR AM.AddressCountry = @CountryCode  
      )  
     AND (  
      @EmpID IS NULL  
      OR @EmpID = 0  
      OR @EmpID = AM.TamSalesrep  
      )  
    ORDER BY AM.AgentName ASC  
    ) AS RowConstrainedResult  
    --WHERE   RowNum >= @Page                         
    --AND RowNum < (@Page + 15)                        
    --ORDER BY RowNum                          
  END  
 END  
END  
 --select tandetails, STRegNo,PanNo, * from agentmaster where tandetails != ''                        
<<<<<<< HEAD
 --select * from agentmaster where panno='AABCK7777J' 
>>>>>>> dev
=======
 --select * from agentmaster where panno='AABCK7777J' 
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

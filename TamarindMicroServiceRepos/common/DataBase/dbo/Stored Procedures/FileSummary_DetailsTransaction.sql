CREATE PROCEDURE [dbo].[FileSummary_DetailsTransaction]  
(  
 @dtFromdate datetime,                                             
 @dtTodate datetime ,  
 @reportType nvarchar(20),    
 @YearCode INT,  
 @OperationBy UNIQUEIDENTIFIER  
)  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
 --create Table #tempFileSummary  
 --(  
 -- ID INT IDENTITY(1,1),   
 -- FileCode Varchar(50),  
 -- QtnDate Varchar(50),  
 -- FHEName Varchar(50),  
 -- TamSalesName Varchar(50),  
 -- AgentName Varchar(50),  
 -- FileMonth_Year Varchar(50),  
 -- TourStartDate Varchar(50),  
 -- SalesValue Varchar(100),  
 -- QuotationID Varchar(30),  
 -- XO_ID Varchar(50),  
 -- XOValue Varchar(50)  
   
 --)  
   
   DECLARE @Compid int     
   DECLARE @EmpID int     
   DECLARE @QuotationDate Varchar(50)   
   Declare @TravelDateFrom  Varchar(50)    
  
  IF OBJECT_ID(N'tempdb..#TempCreditNote') IS NOT NULL  
  DROP TABLE #TempCreditNote  
  else  
  create Table #TempCreditNote  
  (  
  ID INT IDENTITY(1,1),   
  FileCode Varchar(50),  
  CreditNote decimal(18,2)  
  )   
  
  if(@reportType = 'QT')  
  BEGIN   
    
  print 'Report Type Quotation'      
                            
  --  SELECT @Compid=CompanyID from yearmaster where yearID= @YearCode   
      
  --  SELECT Q.FileCode , Convert(Varchar, Q.QuotationDate, 106) AS QuotationDate ,   U.UserName AS 'FHEName', E.EmpName  as 'TamSalesName' ,   
  -- -- SUBSTRING(REPLACE(CONVERT(Varchar(11), Convert(Date,SUBSTRING(Q.FileCode,4,4)+'01'),106),' ', '-'),4,8) as FileMonth_Year ,  
  --    A.AgentName AS 'AgentName',   
  -- Convert(Varchar, Q.TravelDateFrom, 106) as 'TourStartDate',SAP.RefNo  AS 'Sales Doc Number',   
  --  A.AgentCode as 'SAPBizCode',   
  --  '' as Comm,  
  -- Cast(ISNULL (I.AmtInINR , 0) - (IsNull(I.TaxAmount, 0) * Isnull(I.Invoice_Exchg_Rate, 1)) + (IsNull(I.TCSValue, 0) * Isnull(I.Invoice_Exchg_Rate, 1)) as DECIMAL(18,2)) as 'SalesValue' ,  
  -- CAST(ISNULL(NULL,0) AS DECIMAL(18,2))  as 'ProformaValue' ,  
  --  Q.QuotationID , '' AS XO_ID, CAST(ISNULL(NULL,0) AS DECIMAL(18,2))  AS  XO_Amt  FROM Invoice_New  I   
  -- INNER JOIN Quotation Q ON I.Qut_ID  = Q.QuotationID  AND I.File_ID = Q.FileCode AND I.YearCode = Q.YearID   
  -- Left jOIN AgentMaster A ON Q.AgentID = A.AgentID   
  -- LEFT JOIN aspnet_Users U ON Q.OperationBy = U.UserId   
  -- LEFT JOIN EmployeeMaster E ON E.EmpID = Q.RelatedEmployeeID    
  -- INNER JOIN SAP_ASTRA_SALES SAP ON SAP.FileCode = Q.FileCode  AND SAP.RefNo = I.Invoice_ID    
      
  --  -- where  Q.FileCode ='IND240300013'    
  --  WHERE     
  --    @Compid = (case when i.IsBTCComm = 1 then i.Original_CompID else i.compcode end ) and                     
  -- I.Type_Of_Doc = 'Invoice'    
  ---- AND Q.FileCode ='IND240300013'                                  
  -- And isnull(i.isvoid,0)=0                                     
  -- --and I.File_id='IND240300013'                                  
  -- --and i.Qut_id=@QtnID                              
  -- and I.Invoice_Type <> 'Proforma'   
  -- and convert(varchar(12),I.Invoice_Date,112) <= convert(varchar(12),GETDATE(),112)     
  -- AND Q.QuotationDate  between @dtFromdate   and  @dtTodate AND Q.YearID  = @YearCode   
  ---- ORDER BY  Q.FileCode   
     
  --      UNION   
      
  --  ---- XO   
  --  SELECT AFC.FileCode  AS FileCode , Convert(Varchar, QUT.QuotationDate, 106)  AS QuotationDate ,   U.UserName AS 'FHEName', E.EmpName as 'TamSalesName' ,   
  -- --  SUBSTRING(REPLACE(CONVERT(Varchar(11), Convert(Date,SUBSTRING(QUT.FileCode,4,4)+'01'),106),' ', '-'),4,8) as FileMonth_Year ,   
  --   XO.XO_Customer_Name AS 'AgentName',   
  --  Convert(Varchar, QUT.TravelDateFrom, 106)  as 'TourStartDate', ''  AS 'Sales Doc Number',  
  --  '' as 'SAPBizCode',    
  --   '' as Comm,  
  --  CAST(ISNULL(NULL,0) AS DECIMAL(18,2))  as 'SalesValue' ,  
  --  CAST(ISNULL(NULL,0) AS DECIMAL(18,2))  as 'ProformaValue' ,  
  --   CAST (XO.Qut_ID AS VARCHAR(20))   AS QuotationID, XO_ID, CAST(XO.XO_Amt AS DECIMAL(18,2)) AS 'XO_Amt'  FROM XO                               
  --  INNER JOIN Astralive..FileCode AFC ON XO.File_ID = CONVERT(VARCHAR,AFC.FileCodeID)   
  --  LEFT JOIN Quotation QUT ON XO.Qut_ID = QUT.QuotationID   
  --  LEFT JOIN aspnet_Users U ON XO.InsertedBy  = U.UserId       
  --  LEFT JOIN EmployeeMaster E ON E.EmpID = QUT.RelatedEmployeeID           
  -- ---- WHERE  Convert(Varchar, QUT.QuotationDate, 104)  = '16.08.2023' AND XO.YearCode = 213   
  --  WHERE QUT.QuotationDate  between @dtFromdate   and  @dtTodate  AND QUT.YearID  = @YearCode AND ISNULL(XO.Undo,0) <> 1                
  --  AND ISNULL(XO.IsDirectPayment,0)<>1    
      
      
  --UNION   
    
  -- SELECT Q.FileCode , Convert(Varchar, Q.QuotationDate, 106) AS QuotationDate ,   U.UserName AS 'FHEName', E.EmpName  as 'TamSalesName' ,  
  --   -- SUBSTRING(REPLACE(CONVERT(Varchar(11), Convert(Date,SUBSTRING(Q.FileCode,4,4)+'01'),106),' ', '-'),4,8) as FileMonth_Year,  
  --     A.AgentName AS 'AgentName',   
  -- Convert(Varchar, Q.TravelDateFrom, 106) as 'TourStartDate', SAP.RefNo  AS 'Sales Doc Number',  
  --  '' as 'SAPBizCode',    
  --  '' as Comm,  
  --  -Cast(SAP.TaxableSaleLC + SAP.NonTaxableSaleLC  as DECIMAL(18,2)) as 'SalesValue' ,  
  --   CAST(ISNULL(NULL,0) AS DECIMAL(18,2))  as 'ProformaValue' ,  
  --   Q.QuotationID , '' AS XO_ID, CAST(ISNULL(NULL,0) AS DECIMAL(18,2))  AS  XO_Amt   
  -- FROM  Quotation Q    
  -- Left jOIN AgentMaster A ON Q.AgentID = A.AgentID   
  --    INNER JOIN SAP_ASTRA_SALES SAP ON SAP.FileCode = Q.FileCode   
  -- LEFT JOIN aspnet_Users U ON Q.OperationBy = U.UserId   
  -- LEFT JOIN EmployeeMaster E ON E.EmpID = Q.RelatedEmployeeID    
    
  --  --where  Q.FileCode ='IND240300013'    
  --  WHERE                  
  -- SAP.[RefNo] LIKE 'CN%' AND SAP.DocType = 'DG' AND ISNULL(SAP.IsReversed,0) != '1' AND Q.ParenQuotationID = 0   
  ---- and convert(varchar(12),I.Invoice_Date,112) <= convert(varchar(12),GETDATE(),112)     
  -- and  Q.QuotationDate  between @dtFromdate   and  @dtTodate  AND Q.YearID  = @YearCode   
  --  ORDER BY  Q.FileCode    
  END    
  if(@reportType = 'TR')  
  BEGIN     
  print 'Report Type TravelStartDate'     
                             
     SELECT @EmpID = EmpID FROM EmployeeMaster WHERE EmployeeMaster.UserID = @OperationBy   
   SELECT @Compid=CompanyID from yearmaster where yearID=@YearCode  
      
   SELECT Q.FileCode , Replace(Convert(Varchar, Q.QuotationDate, 106), ' ','-') AS QuotationDate ,   U.UserName AS 'FHEName', ISNULL(E.EmpName, 'Not Defined')  as 'TamSalesName' ,  
    --SUBSTRING(REPLACE(CONVERT(Varchar(11), Convert(Date,SUBSTRING(Q.FileCode,4,4)+'01'),106),' ', '-'),4,8) as FileMonth_Year,  
        A.AgentName AS 'AgentName',   
   substring(replace(Convert(Varchar, Q.TravelDateFrom, 106), ' ','-'),4,11) as 'TourStartDate', I.Invoice_ID  AS 'Sales Doc Number',  
   I.Agent_ID as 'SAPBizCode',  
   Case when I.Agent_ID LIKE 'CH%' THEN 1 when I.Agent_ID LIKE 'CV%' THEN 1 ELSE 0 END  'Comm',    
     Cast(ISNULL (I.AmtInINR , 0) - (IsNull(I.TaxAmount, 0) * Isnull(I.Invoice_Exchg_Rate, 1)) + (IsNull(I.TCSValue, 0) * Isnull(I.Invoice_Exchg_Rate, 1)) as DECIMAL(18,2)) as 'SalesValue' ,  
   CAST(ISNULL(NULL,0) AS DECIMAL(18,2))  as 'ProformaValue' ,    
   Q.QuotationID , '' AS XO_ID, CAST(ISNULL(NULL,0) AS DECIMAL(18,2)) AS  XO_Amt FROM Invoice_New  I   
   INNER JOIN Quotation Q ON I.Qut_ID  = Q.QuotationID  AND I.File_ID = Q.FileCode AND I.YearCode = Q.YearID   
   --Left jOIN AgentMaster A ON Q.AgentID = A.AgentID    
   Left JOIN AgentMaster A ON  A.AgentID = CASE WHEN  Q.ParenQuotationID != '0' THEN (SELECT TOP 1 Q2.AgentID FROM Quotation Q2 WHERE Q2.QuotationID = Q.ParenQuotationID  AND I.File_ID = Q.FileCode AND I.YearCode = Q.YearID )  ELSE Q.AgentID END   
   LEFT JOIN aspnet_Users U ON Q.OperationBy = U.UserId   
   LEFT JOIN EmployeeMaster E ON E.EmpID = Q.RelatedEmployeeID    
   --INNER JOIN SAP_ASTRA_SALES SAP ON SAP.FileCode = Q.FileCode  AND SAP.RefNo = I.Invoice_ID    
      
    WHERE     
      @Compid = (case when i.IsBTCComm = 1 then i.Original_CompID else i.compcode end ) and                     
   I.Type_Of_Doc = 'Invoice'    
  -- AND Q.FileCode ='IND240300013'                                  
   And isnull(i.isvoid,0)=0                                                              
   and I.Invoice_Type <> 'Proforma'   
   and convert(varchar(12),I.Invoice_Date,112) <= convert(varchar(12),GETDATE(),112)     
   AND Q.QuotationDate  between @dtFromdate   and  @dtTodate   AND Q.YearID  = @YearCode   
   AND U.UserId = @OperationBy  
  -- ORDER BY  Q.FileCode   
    
        UNION           
  
           SELECT Q.FileCode , REPLACE(Convert(Varchar, Q.QuotationDate, 106), ' ','-') AS QuotationDate ,   U.UserName AS 'FHEName', ISNULL(E.EmpName, 'Not Defined')  as 'TamSalesName' ,  
    --SUBSTRING(REPLACE(CONVERT(Varchar(11), Convert(Date,SUBSTRING(Q.FileCode,4,4)+'01'),106),' ', '-'),4,8) as FileMonth_Year,  
        A.AgentName AS 'AgentName',   
   substring(REPLACE(Convert(Varchar, Q.TravelDateFrom, 106), ' ','-'),4,11) as 'TourStartDate', I.Invoice_ID  AS 'Sales Doc Number',  
   I.Agent_ID as 'SAPBizCode',   
   Case when I.Agent_ID LIKE 'CH%' THEN 1 when I.Agent_ID LIKE 'CV%' THEN 1 ELSE 0 END  'Comm',      
   CAST(ISNULL(NULL,0) AS DECIMAL(18,2))  as 'SalesValue' ,  
   Cast(ISNULL (I.AmtInINR , 0) - (IsNull(I.TaxAmount, 0) * Isnull(I.Invoice_Exchg_Rate, 1)) + (IsNull(I.TCSValue, 0) * Isnull(I.Invoice_Exchg_Rate, 1)) as DECIMAL(18,2)) as 'ProformaValue' ,  
   Q.QuotationID , '' AS XO_ID, CAST(ISNULL(NULL,0) AS DECIMAL(18,2)) AS  XO_Amt FROM Invoice_New  I   
   INNER JOIN Quotation Q ON I.Qut_ID  = Q.QuotationID  AND I.File_ID = Q.FileCode AND I.YearCode = Q.YearID   
   --Left jOIN AgentMaster A ON Q.AgentID = A.AgentID    
   Left JOIN AgentMaster A ON  A.AgentID = CASE WHEN  Q.ParenQuotationID != '0' THEN (SELECT TOP 1 Q2.AgentID FROM Quotation Q2 WHERE Q2.QuotationID = Q.ParenQuotationID  AND I.File_ID = Q.FileCode AND I.YearCode = Q.YearID )  ELSE Q.AgentID END   
   LEFT JOIN aspnet_Users U ON Q.OperationBy = U.UserId   
   LEFT JOIN EmployeeMaster E ON E.EmpID = Q.RelatedEmployeeID    
   --INNER JOIN SAP_ASTRA_SALES SAP ON SAP.FileCode = Q.FileCode  AND SAP.RefNo = I.Invoice_ID    
      
    WHERE     
      @Compid = (case when i.IsBTCComm = 1 then i.Original_CompID else i.compcode end ) and                     
   I.Type_Of_Doc = 'Invoice'                                  
   And isnull(i.isvoid,0)=0      
   And isnull(i.ConvertedInvNo,'')= ''                                                             
   and I.Invoice_Type = 'Proforma'   
   and I.Invoice_ID  like 'PF%'  
   and convert(varchar(12),I.Invoice_Date,112) <= convert(varchar(12),GETDATE(),112)     
   AND Q.QuotationDate  between @dtFromdate   and  @dtTodate   AND Q.YearID  = @YearCode   
   AND U.UserId = @OperationBy  
  -- AND Q.FileCode ='IND240300013'    
  -- ORDER BY  Q.FileCode   
    
  UNION       
      
    SELECT Q.FileCode  AS FileCode , REPLACE(Convert(Varchar, QUT.QuotationDate, 106), ' ','-')  AS QuotationDate ,   U.UserName AS 'FHEName', ISNULL(E.EmpName, 'Not Defined')  as 'TamSalesName' ,  
     --SUBSTRING(REPLACE(CONVERT(Varchar(11), Convert(Date,SUBSTRING(QUT.FileCode,4,4)+'01'),106),' ', '-'),4,8) as FileMonth_Year ,  
      A.AgentName AS 'AgentName',   
     substring(REPLACE(Convert(Varchar, QUT.TravelDateFrom, 106), ' ','-'),4,11)  as 'TourStartDate', INV1.Invoice_ID   AS 'Sales Doc Number',  
      SAPCode  as 'SAPBizCode',  
   Case when SAPCode LIKE 'CH%' THEN 1 when SAPCode LIKE 'CV%' THEN 1 ELSE 0 END  'Comm',    
      Cast(ISNULL (INV1.AmtInINR , 0) - (IsNull(INV1.TaxAmount, 0) * Cast (Isnull(INV1.Invoice_Exchg_Rate, 1) as decimal(18,5))) + (IsNull(INV1.TCSValue, 0) * CAST(Isnull(INV1.Invoice_Exchg_Rate, 1) as decimal(18,5)) ) as DECIMAL(18,2)) as 'SalesValue' ,
    
     CAST(ISNULL(NULL,0) AS DECIMAL(18,2))  as 'ProformaValue' ,  
     CAST (XO.Qut_ID AS VARCHAR(20))   AS QuotationID, XO.XO_ID, CAST(XO.XO_Amt AS DECIMAL(18,2)) AS 'XO_Amt' FROM XO                               
    INNER JOIN Quotation Q ON XO.File_ID = CONVERT(VARCHAR,Q.FileCode)   
    LEFT JOIN Quotation QUT ON XO.Qut_ID = QUT.QuotationID   
    LEFT JOIN  XOInvoiceMapping XOM ON XO.Qut_ID = XOM.Qut_ID AND XO.XO_ID = XOM.XO_ID    
    LEFT JOIN Invoice_New INV1 ON   XOM.Invoice_ID = INV1.Invoice_ID AND XOM.Qut_ID = INV1.Qut_ID AND XOM.XO_ID = XO.XO_ID  AND INV1.CreatedBy = @OperationBy AND  XO.SAPCode = INV1.Agent_ID AND (INV1.IsBTCComm = 1 OR INV1.IsDirectPayment = 1)  
    --LEFT JOIN Invoice_New INV ON  XO.Qut_ID = INV.Qut_ID AND INV.CreatedBy = @OperationBy AND  XO.SAPCode = INV.Agent_ID AND (INV.IsBTCComm = 1 OR INV.IsDirectPayment = 1)   
    LEFT JOIN aspnet_Users U ON QUT.OperationBy  = U.UserId      
    LEFT JOIN EmployeeMaster E ON E.EmpID = QUT.RelatedEmployeeID              
    --Left JOIN AgentMaster A ON QUT.AgentID = A.AgentID     
    Left jOIN AgentMaster A ON  A.AgentID = CASE WHEN  QUT.ParenQuotationID != '0' THEN (SELECT TOP 1 Q2.AgentID FROM Quotation Q2 WHERE Q2.QuotationID = QUT.ParenQuotationID  AND INV1.File_ID = QUT.FileCode AND INV1.YearCode = QUT.YearID )  ELSE QUT.AgentID END   
    WHERE QUT.QuotationDate  between @dtFromdate   and  @dtTodate  AND QUT.YearID  = @YearCode AND ISNULL(XO.Undo,0) <> 1                
    AND ISNULL(XO.IsDirectPayment,0)<>1    
    AND U.UserId = @OperationBy      
      
   UNION   
     
    SELECT Q.FileCode , REPLACE(Convert(Varchar, Q.QuotationDate, 106), ' ','-') AS QuotationDate ,   U.UserName AS 'FHEName', ISNULL(E.EmpName, 'Not Defined')  as 'TamSalesName' ,  
     -- SUBSTRING(REPLACE(CONVERT(Varchar(11), Convert(Date,SUBSTRING(Q.FileCode,4,4)+'01'),106),' ', '-'),4,8) as FileMonth_Year,  
       A.AgentName AS 'AgentName',   
   substring(REPLACE(Convert(Varchar, Q.TravelDateFrom, 106), ' ','-'),4,11) as 'TourStartDate',SAP.RefNo  AS 'Sales Doc Number',   
    SAP.VendorID as 'SAPBizCode',   
   Case when SAP.VendorID LIKE 'CH%' THEN 1 when SAP.VendorID LIKE 'CV%' THEN 1 ELSE 0 END  'Comm',    
    -Cast(SAP.TaxableSaleLC + SAP.NonTaxableSaleLC  as DECIMAL(18,2)) as 'SalesValue' ,  
    CAST(ISNULL(NULL,0) AS DECIMAL(18,2))  as 'ProformaValue' ,  
    Q.QuotationID , '' AS XO_ID, CAST(ISNULL(NULL,0) AS DECIMAL(18,2))  AS  XO_Amt   
    FROM Quotation Q   
   --Left JOIN AgentMaster A ON Q.AgentID = A.AgentID   
   Left jOIN AgentMaster A ON  A.AgentID = CASE WHEN  Q.ParenQuotationID != '0' THEN (SELECT TOP 1 Q2.AgentID FROM Quotation Q2 WHERE Q2.QuotationID = Q.ParenQuotationID )  ELSE Q.AgentID END   
      INNER JOIN SAP_ASTRA_SALES SAP ON SAP.FileCode = Q.FileCode   
   LEFT JOIN aspnet_Users U ON Q.OperationBy = U.UserId   
   LEFT JOIN EmployeeMaster E ON E.EmpID = Q.RelatedEmployeeID    
    
    --where  Q.FileCode ='IND240300013'    
    WHERE                  
   SAP.[RefNo] LIKE 'CN%' AND SAP.DocType = 'DG' AND ISNULL(SAP.IsReversed,0) != '1' AND Q.ParenQuotationID = 0   
   --and I.Invoice_Total = SAP.TotalSaleLC   
  -- and convert(varchar(12),I.Invoice_Date,112) <= convert(varchar(12),GETDATE(),112)     
   and  Q.QuotationDate  between @dtFromdate   and  @dtTodate  AND Q.YearID  = @YearCode   
   AND U.UserId = @OperationBy   
   ORDER BY  Q.FileCode    
     
 END    
     
  IF OBJECT_ID(N'tempdb..#TempTargetAMT') IS NOT NULL  
  DROP TABLE #TempTargetAMT  
  else  
  Create Table #TempTargetAMT  
  (  
   EmpID INT,  
   YearID INT,  
   TYPE VARCHAR(50),  
   Month Varchar(100),  
   SalesAmount decimal(18,2)  
  )  
  insert into #TempTargetAMT   
  SELECT   
   EmpID,  
   YearID,  
   TYPE,  
   Month,  
   SalesAmount  
  FROM   
   EmployeeTargetNew    
  UNPIVOT  
  (  
   SalesAmount FOR Month IN (Apr_Topline , May_Topline , Jun_Topline , Jul_Topline , Aug_Topline , Sep_Topline , Oct_Topline , Nov_Topline , Dec_Topline , Jan_Topline , Feb_Topline , Mar_Topline  
    ,Apr_GOP , May_GOP  , Jun_GOP , Jul_GOP , Aug_GOP , Sep_GOP , Oct_GOP , Nov_GOP , Dec_GOP , Jan_GOP , Feb_GOP , Mar_GOP)  
  ) AS Unpvt  where EmpID = @EmpID;  
  
  
  --SELECT * FROM #TempTargetAMT  
    
  
  
-- Step 1: Create the temporary table  
CREATE TABLE #FinancialYearData (  
    MonthStartDate VARCHAR(20),  
    EmpID INT,  
    YearID INT,  
    OpsToplineTarget  DECIMAL(18, 2),  
    OpsGOPTarget DECIMAL(18, 2),  
    SalesToplineTarget DECIMAL (18,2),  
    SalesGOPTarget DECIMAL (18,2)  
);  
  
-- Step 2 & 3: Insert data into the temporary table  
DECLARE @YearStart INT = (select YEAR(@dtFromdate));  -- Adjust this based on your financial year start  
DECLARE @YearEnd INT = (select  YEAR(@dtToDate));    -- Adjust this based on your financial year end  
  
DECLARE @MonthStart DATE = DATEFROMPARTS(@YearStart, 4, 1);  
DECLARE @MonthEnd DATE = DATEFROMPARTS(@YearEnd, 3, 31);  
  
WHILE @MonthStart <= @MonthEnd  
BEGIN  
    INSERT INTO #FinancialYearData (MonthStartDate,EmpID, YearID, OpsToplineTarget, OpsGOPTarget, SalesToplineTarget,  SalesGOPTarget)  
    VALUES (SUBSTRING(replace(convert(NVARCHAR, @MonthStart, 106), ' ', '-'),4,13),@EmpID,@YearCode, NULL, NULL,  NULL, NULL);  
  
    SET @MonthStart = DATEADD(MONTH, 1, @MonthStart);  
END  
  
  
   
  
UPDATE t1  
  SET t1.OpsToplineTarget = t2.SalesAmount  
  FROM #FinancialYearData AS t1  
  INNER JOIN #TempTargetAMT AS t2  
  ON t1.EmpID = t2.EmpID AND t1.YearID  = t2.YearID AND SUBSTRING(t2.Month,5,3) = 'Top' and SUBSTRING(t2.Month,1,3) = SUBSTRING(t1.MonthStartDate,1,3)  
  WHERE t2.TYPE = 'Operations';  
    
  UPDATE t1  
  SET t1.OpsGOPTarget = t2.SalesAmount  
  FROM #FinancialYearData AS t1  
  INNER JOIN #TempTargetAMT AS t2  
  ON t1.EmpID = t2.EmpID AND t1.YearID  = t2.YearID AND SUBSTRING(t2.Month,5,3) = 'GOP' and SUBSTRING(t2.Month,1,3) = SUBSTRING(t1.MonthStartDate,1,3)  
  WHERE t2.TYPE = 'Operations';  
  
SELECT * FROM  #FinancialYearData   
  
  
DROP TABLE #FinancialYearData;  
DROP TABLE #TempTargetAMT;  
     
     
END  
  
  
  
  
  
  
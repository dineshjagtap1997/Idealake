    
CREATE PROCEDURE [dbo].[usp_InsertUpdateSAPJobsTime]    
(    
@JobName varchar(50),    
@Taskflag varchar(50),    
@DataToSplit varchar(Max),    
@CreatedBy int    =1     
--@ErrMsg nvarchar(100) OUT      
)    
AS    
BEGIN    
    
  declare @ErrMsg varchar(100)  
                 
    if(@JobName = 'Invoice')    
    begin    
        print 'Invoice'    
        if(@Taskflag = 'I')    
        begin    
            IF EXISTS (
                SELECT 1 FROM Invoice_New
                WHERE Invoice_ID IN (select items from [SplitCommaToTable](@DataToSplit, ','))
            )
            BEGIN
                Update Invoice_New 
                set CreatedDateTime = DATEADD(MI, +2, GETDATE())  
                where Invoice_ID IN (select items from [SplitCommaToTable](@DataToSplit, ','))
                
                SET @ErrMsg = ''
                SELECT '200' AS returnCode, 'Data Inserted Successfully!' AS returnMessage, @@IDENTITY as ID;
            END
            ELSE
            BEGIN
                SET @ErrMsg = 'No matching Invoice_ID found in Invoice_New.'
                SELECT '404' AS returnCode, @ErrMsg AS returnMessage, NULL as ID;
            END
        end    
    end    

    if(@JobName = 'XO')    
    begin    
        print 'XO'    
        if(@Taskflag = 'I')    
        begin    
            IF EXISTS (
                SELECT 1 FROM XO
                WHERE XO_ID IN (select items from [SplitCommaToTable](@DataToSplit, ','))
            )
            BEGIN
                Update XO 
                set XO.InsertedDate = DATEADD(MI, +2, GETDATE())  
                where XO.XO_ID IN (select items from [SplitCommaToTable](@DataToSplit, ','))
                
                SET @ErrMsg = ''
                SELECT '200' AS returnCode, 'Data Inserted Successfully!' AS returnMessage, @@IDENTITY as ID;
            END
            ELSE
            BEGIN
                SET @ErrMsg = 'No matching XO_ID found in XO.'
                SELECT '404' AS returnCode, @ErrMsg AS returnMessage, NULL as ID;
            END
        end    
        if(@Taskflag = 'U')    
        begin    
            IF EXISTS (
                SELECT 1 FROM XO
                WHERE XO_ID IN (select items from [SplitCommaToTable](@DataToSplit, ','))
            )
            BEGIN
                Update XO 
                set XO.UpdatedDate = DATEADD(MI, +2, GETDATE())  
                where XO.XO_ID IN (select items from [SplitCommaToTable](@DataToSplit, ','))
                
                SET @ErrMsg = ''
                SELECT '200' AS returnCode, 'Data Updated Successfully!' AS returnMessage, @@IDENTITY as ID;
            END
            ELSE
            BEGIN
                SET @ErrMsg = 'No matching XO_ID found in XO.'
                SELECT '404' AS returnCode, @ErrMsg AS returnMessage, NULL as ID;
            END
        end    
    end    

    if(@JobName = 'FileCode')    
    begin    
        print 'FileCode'    
        if(@Taskflag = 'I')    
        begin    
            IF EXISTS (
                SELECT 1 FROM Quotation
                WHERE FileCode IN (select items from [SplitCommaToTable](@DataToSplit, ','))
            )
            BEGIN
                Update Quotation 
                set FCOperationOn = DATEADD(MI, +2, GETDATE()),    
                    FCStatus = 'INSERT'      
                where FileCode IN (select items from [SplitCommaToTable](@DataToSplit, ','))
                
                SET @ErrMsg = ''
                SELECT '200' AS returnCode, 'Data Inserted Successfully!' AS returnMessage, @@IDENTITY as ID;
            END
            ELSE
            BEGIN
                SET @ErrMsg = 'No matching FileCode found in Quotation.'
                SELECT '404' AS returnCode, @ErrMsg AS returnMessage, NULL as ID;
            END
        end    
        if(@Taskflag = 'U')    
        begin    
            IF EXISTS (
                SELECT 1 FROM Quotation
                WHERE FileCode IN (select items from [SplitCommaToTable](@DataToSplit, ','))
            )
            BEGIN
                Update Quotation 
                set FCOperationOn = DATEADD(MI, +2, GETDATE())     
                -- FCStatus = 'UPDATE'        
                where FileCode IN (select items from [SplitCommaToTable](@DataToSplit, ','))
                
                SET @ErrMsg = ''
                SELECT '200' AS returnCode, 'Data Updated Successfully!' AS returnMessage, @@IDENTITY as ID;
            END
            ELSE
            BEGIN
                SET @ErrMsg = 'No matching FileCode found in Quotation.'
                SELECT '404' AS returnCode, @ErrMsg AS returnMessage, NULL as ID;
            END
        end    
    end    

    if(@JobName = 'AgentMaster')    
    begin    
        print 'AgentMaster'    
        if(@Taskflag = 'I')    
        begin    
            IF EXISTS (
                SELECT 1 FROM AgentMaster
                WHERE AgentCode IN (SELECT items FROM [SplitCommaToTable](@DataToSplit, ','))
            )
            BEGIN
                UPDATE AgentMaster
                SET OperationOn = DATEADD(MI, +2, GETDATE()),     
                    Operation = 'INSERT'       
                WHERE AgentCode IN (SELECT items FROM [SplitCommaToTable](@DataToSplit, ','));
                
                SET @ErrMsg = ''
                SELECT '200' AS returnCode, 'Data Updated Successfully!' AS returnMessage, @@IDENTITY AS ID;
            END
            ELSE
            BEGIN
                SET @ErrMsg = 'No matching AgentCode found in AgentMaster.'
                SELECT '404' AS returnCode, @ErrMsg AS returnMessage, NULL AS ID;
            END
        end    
        if(@Taskflag = 'U')    
        begin    
            IF EXISTS (
                SELECT 1 FROM AgentMaster
                WHERE AgentCode IN (select items from [SplitCommaToTable](@DataToSplit, ','))
            )
            BEGIN
                Update AgentMaster 
                set OperationOn = DATEADD(MI, +2, GETDATE()),    
                    Operation = 'UPDATE'     
                where AgentCode IN (select items from [SplitCommaToTable](@DataToSplit, ','))
                
                SET @ErrMsg = ''
                SELECT '200' AS returnCode, 'Data Updated Successfully!' AS returnMessage, @@IDENTITY as ID;
            END
            ELSE
            BEGIN
                SET @ErrMsg = 'No matching AgentCode found in AgentMaster.'
                SELECT '404' AS returnCode, @ErrMsg AS returnMessage, NULL as ID;
            END
        end   
    end    

    if(@JobName = 'HotelMaster')    
    begin    
        print 'HotelMaster'    
        if(@Taskflag = 'I')    
        begin    
            IF EXISTS (
                SELECT 1 FROM HotelMaster
                WHERE HotelSAPCode IN (select items from [SplitCommaToTable](@DataToSplit, ','))
            )
            BEGIN
                Update HotelMaster 
                set OperationOn = DATEADD(MI, +2, GETDATE()),     
                    Operation = 'INSERT'      
                where HotelSAPCode IN (select items from [SplitCommaToTable](@DataToSplit, ','))
                
                SET @ErrMsg = ''
                SELECT '200' AS returnCode, 'Data Inserted Successfully!' AS returnMessage, @@IDENTITY as ID;
            END
            ELSE
            BEGIN
                SET @ErrMsg = 'No matching HotelSAPCode found in HotelMaster.'
                SELECT '404' AS returnCode, @ErrMsg AS returnMessage, NULL as ID;
            END
        end    
        if(@Taskflag = 'U')    
        begin    
            IF EXISTS (
                SELECT 1 FROM HotelMaster
                WHERE HotelSAPCode IN (select items from [SplitCommaToTable](@DataToSplit, ','))
            )
            BEGIN
                Update HotelMaster 
                set OperationOn = DATEADD(MI, +2, GETDATE()),     
                    Operation = 'UPDATE'      
                WHERE HotelSAPCode IN (select items from [SplitCommaToTable](@DataToSplit, ','))
                
                SET @ErrMsg = ''
                SELECT '200' AS returnCode, 'Data Updated Successfully!' AS returnMessage, @@IDENTITY as ID;
            END
            ELSE
            BEGIN
                SET @ErrMsg = 'No matching HotelSAPCode found in HotelMaster.'
                SELECT '404' AS returnCode, @ErrMsg AS returnMessage, NULL as ID;
            END
        end    
    end    

    if(@JobName = 'VendorMaster')    
    begin    
        print 'VendorMaster'    
        if(@Taskflag = 'I')    
        begin    
            IF EXISTS (
                SELECT 1 FROM VendorMaster
                WHERE VendorSAPCode IN (select items from [SplitCommaToTable](@DataToSplit, ','))
            )
            BEGIN
                Update VendorMaster 
                set OperationOn = DATEADD(MI, +2, GETDATE()),     
                    Operation = 'INSERT'     
                where VendorSAPCode IN (select items from [SplitCommaToTable](@DataToSplit, ','))
                
                SET @ErrMsg = ''
                SELECT '200' AS returnCode, 'Data Inserted Successfully!' AS returnMessage, @@IDENTITY as ID;
            END
            ELSE
            BEGIN
                SET @ErrMsg = 'No matching VendorSAPCode found in VendorMaster.'
                SELECT '404' AS returnCode, @ErrMsg AS returnMessage, NULL as ID;
            END
        end    
        if(@Taskflag = 'U')    
        begin    
            IF EXISTS (
                SELECT 1 FROM VendorMaster
                WHERE VendorSAPCode IN (select items from [SplitCommaToTable](@DataToSplit, ','))
            )
            BEGIN
                Update VendorMaster 
                set OperationOn = DATEADD(MI, +2, GETDATE()),     
                    Operation = 'UPDATE'      
                WHERE VendorSAPCode IN (select items from [SplitCommaToTable](@DataToSplit, ','))
                
                SET @ErrMsg = ''
                SELECT '200' AS returnCode, 'Data Updated Successfully!' AS returnMessage, @@IDENTITY as ID;
            END
            ELSE
            BEGIN
                SET @ErrMsg = 'No matching VendorSAPCode found in VendorMaster.'
                SELECT '404' AS returnCode, @ErrMsg AS returnMessage, NULL as ID;
            END
        end    
    end  
  if(@JobName = 'XOArr_Dept')    
  begin      
    
 if(@Taskflag = 'U')    
 begin    
          
    IF OBJECT_ID('tempdb..#TBLXOData') IS NOT NULL    
     DROP TABLE #TBLXOData    
    
    CREATE TABLE #TBLXOData    
    (    
    ID INT IDENTITY(1,1),    
    XO_ID VARCHAR(50),    
    Qut_ID INT,    
    Arr_Date DATETIME,    
    Dep_Date DATETIME,    
    VendorID VARCHAR(50)    
    )    
    
    
    INSERT INTO #TBLXOData     
    
    
    SELECT XOA.*                                       
    FROM                       
    (                              
     SELECT distinct XOID as 'XO_ID',Q.QuotationID AS 'Qut_ID',                            
     CASE         
      WHEN XOI.ArrivalDate IS NOT NULL THEN XOI.ArrivalDate                  
     ELSE         
      CASE WHEN XOMap.ServiceTypeID=1 THEN         
      (Select MIN(QA1.ItineraryDate) from Quotation_Accomodation QA1                  
      INNER JOIN QuotationXOMap QXM1 ON QXM1.QuotationItemID = QA1.AccomodationID                   
      AND QA1.ServiceTypeID=1 AND QXM1.XOID =XOMap.XOID)                  
      WHEN XOMap.ServiceTypeID=2 THEN         
      (Select MIN(QT1.ItineraryDate) from Quotation_Transport QT1                  
      INNER JOIN QuotationXOMap QXM1 ON QXM1.QuotationItemID = QT1.QuotationTransportID                  
      AND QT1.ServiceTypeID=2 AND QXM1.XOID =XOMap.XOID)                  
      WHEN XOMap.ServiceTypeID=3 THEN         
      (Select MIN(QM1.ItineraryDate) from Quotation_Monument QM1                  
      INNER JOIN QuotationXOMap QXM1 ON QXM1.QuotationItemID = QM1.QuotationMonumentID                  
      AND QM1.ServiceTypeID=3 AND QXM1.XOID =XOMap.XOID)                    
      WHEN XOMap.ServiceTypeID=4 THEN         
      (Select MIN(QS1.ItineraryDate) from Quotation_Special QS1                  
      INNER JOIN QuotationXOMap QXM1 ON QXM1.QuotationItemID = QS1.QuotationSpecialID                  
      AND QS1.ServiceTypeID=4 AND QXM1.XOID =XOMap.XOID)                    
      WHEN XOMap.ServiceTypeID=5 THEN         
      (Select MIN(QG1.ItineraryDate) from Quotation_Guide QG1                  
      INNER JOIN QuotationXOMap QXM1 ON QXM1.QuotationItemID = QG1.QuotationGuideID                  
      AND QG1.ServiceTypeID=5 AND QXM1.XOID =XOMap.XOID)                      
      WHEN XOMap.ServiceTypeID=6 THEN                    
      (Select MIN(QMO1.ItineraryDate) from Quotation_MOT QMO1                  
      INNER JOIN QuotationXOMap QXM1 ON QXM1.QuotationItemID = QMO1.QuotationMOTID                   
      AND QMO1.ServiceTypeID=6 AND QXM1.XOID =XOMap.XOID)                  
      END                   
      END AS 'ArrivalDate',        
                        
       CASE WHEN  XOI.DepartureDate IS NOT NULL THEN XOI.DepartureDate                  
     ELSE CASE WHEN XOMap.ServiceTypeID=1                   
     THEN (Select CASE WHEN MAX(QA1.ItineraryDate) IS NOT NULL                  
       THEN DATEADD(DD,1,MAX(QA1.ItineraryDate)) ELSE NULL END                  
       from Quotation_Accomodation QA1                  
       INNER JOIN QuotationXOMap QXM1 ON QXM1.QuotationItemID = QA1.AccomodationID                   
       AND QA1.ServiceTypeID=1 AND QXM1.XOID =XOMap.XOID)                  
     WHEN XOMap.ServiceTypeID=2                   
     THEN (Select MAX(QT1.ItineraryDate) from Quotation_Transport QT1                  
       INNER JOIN QuotationXOMap QXM1 ON QXM1.QuotationItemID = QT1.QuotationTransportID                  
       AND QT1.ServiceTypeID=2 AND QXM1.XOID =XOMap.XOID)                  
     WHEN XOMap.ServiceTypeID=3                   
     THEN (Select MAX(QM1.ItineraryDate) from Quotation_Monument QM1                  
       INNER JOIN QuotationXOMap QXM1 ON QXM1.QuotationItemID = QM1.QuotationMonumentID                  
       AND QM1.ServiceTypeID=3 AND QXM1.XOID =XOMap.XOID)                    
     WHEN XOMap.ServiceTypeID=4                   
     THEN (Select MAX(QS1.ItineraryDate) from Quotation_Special QS1                  
       INNER JOIN QuotationXOMap QXM1 ON QXM1.QuotationItemID = QS1.QuotationSpecialID                  
       AND QS1.ServiceTypeID=4 AND QXM1.XOID =XOMap.XOID)                    
     WHEN XOMap.ServiceTypeID=5                   
     THEN (Select MAX(QG1.ItineraryDate) from Quotation_Guide QG1                  
       INNER JOIN QuotationXOMap QXM1 ON QXM1.QuotationItemID = QG1.QuotationGuideID                  
       AND QG1.ServiceTypeID=5 AND QXM1.XOID =XOMap.XOID)                      
     WHEN XOMap.ServiceTypeID=6       THEN                    
      (Select MAX(QMO1.ItineraryDate) from Quotation_MOT QMO1                  
       INNER JOIN QuotationXOMap QXM1 ON QXM1.QuotationItemID = QMO1.QuotationMOTID                   
       AND QMO1.ServiceTypeID=6 AND QXM1.XOID =XOMap.XOID)                  
      END                   
      END AS DepartureDate,                                  
    CASE WHEN XOMap.ServiceTypeID=1 THEN QA.HotelID                          
     WHEN XOMap.ServiceTypeID=2 THEN QT.VendorHotelID                          
     WHEN XOMap.ServiceTypeID=3 THEN QM.VendorID                          
     WHEN XOMap.ServiceTypeID=4 THEN QS.VendorHotelID                          
     WHEN XOMap.ServiceTypeID=5 THEN QG.VendorID                          
     WHEN XOMap.ServiceTypeID=6 THEN QMT.VendorID         
    END AS VendorID               
             
    FROM QuotationXOMap XOMap                              
    INNER Join Quotation Q ON Q.QuotationID = XOMap.QuotationID                               
    Left join XO_Instructions XOI ON XOI.Qut_ID = XOMap.QuotationID  AND XOID= XO_ID                              
    LEFT JOIN Quotation_Accomodation QA ON QA.QuotationID = XOMap.QuotationID AND QA.AccomodationID = XOMap.QuotationItemID                          
        AND QA.ServiceTypeID = XOMap.ServiceTypeID                          
    LEFT JOIN Quotation_Transport QT ON QT.QuotationID = XOMap.QuotationID AND QT.QuotationTransportID = XOMap.QuotationItemID                          
     AND QT.ServiceTypeID = XOMap.ServiceTypeID                          
    LEFT JOIN Quotation_Monument QM ON QM.QuotationID = XOMap.QuotationID AND QM.QuotationMonumentID = XOMap.QuotationItemID                          
     AND QM.ServiceTypeID = XOMap.ServiceTypeID                          
    LEFT JOIN Quotation_Special QS ON QS.QuotationID = XOMap.QuotationID AND QS.QuotationSpecialID = XOMap.QuotationItemID                          
     AND QS.ServiceTypeID = XOMap.ServiceTypeID                          
    LEFT JOIN Quotation_Guide QG ON QG.QuotationID = XOMap.QuotationID AND QG.QuotationGuideID = XOMap.QuotationItemID                          
     AND QG.ServiceTypeID = XOMap.ServiceTypeID                          
    LEFT JOIN Quotation_MOT QMT ON QMT.QuotationID = XOMap.QuotationID AND QMT.QuotationMOTID = XOMap.QuotationItemID         
     AND QMT.ServiceTypeID = XOMap.ServiceTypeID           
     ---sanket below 2 lines          
     --LEFT JOIN HotelRateDetails HRD ON HRD.HotelRateDetailID=QA.[NewHotelRateDetailsID]            
     --LEFT JOIN HotelRateMaster HRM ON HRM.HotelRateID=HRD.HotelRateID           
     LEFT JOIN SpecialServiceRateDetails SSRD ON SSRD.SpecialServiceRateDetailsID=QS.RateDetailsID                     
     LEFT JOIN SpecialServiceRateMaster SSRM ON SSRM.SpecialServiceRateID=SSRD.SpecialServiceRateID     
     LEFT JOIN XO ON XO.XO_ID = XOMap.XOID        
      WHERE XOMap.QuotationID IN (SELECT XO.Qut_ID FROM XO  where XO_ID in (    
          
       select items from [SplitCommaToTable](@DataToSplit,',')    
                      
    )))XOA                      
    LEFT JOIN VendorMaster VM ON VM.VendorID = XOA.VendorID                          
    LEFT JOIN HotelMaster HM ON HM.HotelID= XOA.VendorID                      
    order by XOA.XO_ID ASC     
    
    
    
    UPDATE    
     XOMain     
    SET    
     XOMain.XO_Arr = XOTemp.Arr_Date, XOMain.XO_Dep = XOTemp.Dep_Date     
    FROM    
     XO XOMain    
    INNER JOIN    
     #TBLXOData XOTemp     
    ON     
     XOMain.XO_ID = XOTemp.XO_ID     
            
             
       SET  @ErrMsg = ''     
      
      
    
       SELECT '200' AS returnCode, 'Data Updated Successfully!' AS returnMessage, @@IDENTITY as ID;    
              
 end    
  end    
    
    
     
  if(@JobName = 'XORepost')  
  begin     
    
    if(@Taskflag = 'S')    
 begin    
       
  SELECT DISTINCT '1000' as 'CompanyCode', LTRIM(RTRIM(XO_ID)) as 'XO Number', Q.FileCode as 'File Code',     
  REPLACE(REPLACE(REPLACE(XO_Customer_Name, CHAR(13), ''), CHAR(10), ''),CHAR(9), '') as 'Passenger Name', Convert(Varchar, XO_Date, 104) as 'XO Creation Date', SUBSTRING(Curr_ID,1,3) as 'XO Currency ID',XO_AMT as 'XO Amt',     
  XO.CompName AS Location, Q.BussinessModuleID as 'Business Mdule ID',SAPCode AS  'Vendor Code', XoType as 'XO Type', CN.PurchaseRate_FTI AS 'XO Exchange Rate',     
  --Convert(Varchar, Q.TravelDateFrom , 104)  as 'Check in Date',    
  CASE WHEN XO.XoType = 'A' THEN Convert(Varchar, XO_Date, 104) ELSE Convert(Varchar, Q.TravelDateFrom , 104) END  as 'Check in Date',    
  '' as undo, '' as undodate,   isnull(IsBTCComm, 0) as 'isbtccomm' , AM.AgentCode AS 'Agent ID', YearCode as 'yearcode',    
  CAST(XO.XO_Amt AS varchar(100)) as 'Base Amt',    
   --CASE WHEN XO.XoType = 'A' THEN CAST('' AS varchar(100)) ELSE  CAST(XO.XO_Amt AS varchar(100))  END  as 'Base Amt',     
   --CASE WHEN XO.XoType = 'H' THEN '9' ELSE '2.5' END  as 'Tax Rate',     
    
    
   CASE  WHEN VM.StateCodeID = 1  THEN ''     
    WHEN HM.StateCodeID = 1  THEN ''     
    WHEN Q.Origin = '2' THEN ''    
    WHEN XO.XoType = 'A' THEN ''    
    WHEN CM.StateCodeID = VM.StateCodeID AND XO.XoType = 'H' THEN '9'     
    WHEN CM.StateCodeID = VM.StateCodeID AND XO.XoType = 'T' THEN '2.5'     
    WHEN CM.StateCodeID = VM.StateCodeID AND XO.XoType = 'G' THEN ''     
    WHEN CM.StateCodeID = VM.StateCodeID AND XO.XoType = 'M' THEN ''     
    WHEN CM.StateCodeID = VM.StateCodeID AND XO.XoType = 'S' THEN '9'     
   -- WHEN CM.StateCodeID = VM.StateCodeID AND XO.XoType = 'A' THEN '2.5'     
    
    WHEN CM.StateCodeID = HM.StateCodeID AND XO.XoType = 'H' THEN '9'     
    WHEN CM.StateCodeID = HM.StateCodeID AND XO.XoType = 'T' THEN '2.5'     
    WHEN CM.StateCodeID = HM.StateCodeID AND XO.XoType = 'G' THEN ''     
    WHEN CM.StateCodeID = HM.StateCodeID AND XO.XoType = 'M' THEN ''     
    WHEN CM.StateCodeID = HM.StateCodeID AND XO.XoType = 'S' THEN '9'     
   -- WHEN CM.StateCodeID = HM.StateCodeID AND XO.XoType = 'A' THEN '2.5'     
    
    WHEN CM.StateCodeID != ISNULL(VM.StateCodeID,0) AND XO.XoType = 'H' THEN '18'     
    WHEN CM.StateCodeID != ISNULL(VM.StateCodeID,0) AND XO.XoType = 'T' THEN '5'     
    WHEN CM.StateCodeID != ISNULL(VM.StateCodeID,0) AND XO.XoType = 'G' THEN ''     
    WHEN CM.StateCodeID != ISNULL(VM.StateCodeID,0) AND XO.XoType = 'M' THEN ''     
    WHEN CM.StateCodeID != ISNULL(VM.StateCodeID,0) AND XO.XoType = 'S' THEN '18'     
   -- WHEN CM.StateCodeID != ISNULL(VM.StateCodeID,0) AND XO.XoType = 'A' THEN '5'     
    
    WHEN CM.StateCodeID != ISNULL(HM.StateCodeID,0) AND XO.XoType = 'H' THEN '18'     
    WHEN CM.StateCodeID != ISNULL(HM.StateCodeID,0) AND XO.XoType = 'T' THEN '5'     
    WHEN CM.StateCodeID != ISNULL(HM.StateCodeID,0) AND XO.XoType = 'G' THEN ''     
    WHEN CM.StateCodeID != ISNULL(HM.StateCodeID,0) AND XO.XoType = 'M' THEN ''     
    WHEN CM.StateCodeID != ISNULL(HM.StateCodeID,0) AND XO.XoType = 'S' THEN '9'     
   -- WHEN CM.StateCodeID != ISNULL(HM.StateCodeID,0) AND XO.XoType = 'A' THEN '5'     
    
    
    END  AS 'Tax Rate',     
    
   CM.SAP_BusinessPlaceCode ,    
    '' as 'TDS Rate', '' as 'TDS Base', '' as 'HSN/ SAC'    
   FROM XO inner join Quotation Q ON     
  XO.Qut_ID = Q.QuotationID     
  inner join CompanyMaster CM ON XO.CompName= CM.CityIATACode AND CM.IsActive =1      
  inner join AgentMaster AM ON Q.AgentID = AM.AgentID    
  INNER join CurrencyConversion_N CN ON SUBSTRING(Curr_ID,1,3) = CN.FromCurrency     
  AND  CAST(Q.OperationOn AS DATE)    
  BETWEEN CN.FromDate AND CN.ToDate AND CN.CCParentID != 0 AND CN.IsActive =1     
   LEFT JOIN VendorMaster VM ON convert(VARCHAR(20),VM.VendorSAPCode)= XO.SAPCode     
   LEFT JOIN HotelMaster HM ON convert(VARCHAR(20),HM.HotelSAPCode)= XO.SAPCode     
   WHERE     
   ------------ CAST (XO.XO_Date AS date) = CAST(@runtime AS DATE)     
    --XO.InsertedDate >= @runtime  AND     
    (XO.IsDirectPayment is Null   or XO.IsDirectPayment = 0)        
    and XO.XO_ID IN (  select items from [SplitCommaToTable](@DataToSplit,','))    
    
  
  end  
    --   
    
  end  
    
    
END 
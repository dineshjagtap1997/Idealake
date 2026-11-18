                                                                                                 
  --Exec MIS_AgentRoomNight '2012-04-01', '2012-10-01', '', ''                                                                                                          
--drop proc MIS_AgentRoomNight                                                                                                          
--Updated on 8 July Sagar for Company Name and Username                                                        
CREATE PROC [dbo].[MIS_AgentRoomNight_New]                                                                                                          
(                                                                                                          
 @Fromdate DATETIME,                                                                                                          
 @Todate DATETIME,                                                                                                          
 @CompanyID INT=null,                                                                                                          
 @MarketIds nvarchar(4000)=null                                                                                                          
 -- @DateType varchar(100)                                                                                                          
)                                                                                                          
AS                                                                                                           
 --DECLARE @DateType varchar(15)                                                                                                          
 --SET @DateType = 'Date'                                                                                                          
                                                                                                          
 /*                                                                                                          
 CREATE TABLE #TempDay (DateType VARCHAR(10))                                                                                                          
 INSERT INTO #TempDay EXEC dbo.[usp_TIS_SplitString] @DateType,','                                                                                                          
 */                                                                                                          
                                                                                                          
 CREATE TABLE #TempCompany (Company_Id INT)                                                                                                          
 INSERT INTO #TempCompany EXEC dbo.[usp_TIS_SplitString] @CompanyID,','                                                                                                          
                                                                                                          
 CREATE TABLE #TempMarket (Market_Id nvarchar(50))                                                                                                          
 INSERT INTO #TempMarket EXEC dbo.[usp_TIS_SplitString] @MarketIds,','                                                                                                          
                                                                                                          
 CREATE Table #AgentRoomNight                                                                                                          
 (                                                                                                          
 [Date] DATETIME,                                                                                                          
 [Agent Market]  VARCHAR(200),                        
 [Agent Country]  VARCHAR(200),          
 [Agent City]  VARCHAR(200),                    [Agent Name]  VARCHAR(200),                   
 [Hotel City]  VARCHAR(200),                                                                         
 [Hotel Group]  VARCHAR(200),                                                      
 [Hotel Name]  VARCHAR(200),                          
 [InfoForOps] VARCHAR(MAX),                                                               
 [XORemark] VARCHAR(MAX),                                                                                              
 [XOID] VARCHAR(200),                                       
 [Room Category]  VARCHAR(200),                                                                  
 [Day] VARCHAR(10),                                                                             
 RoomNight1 INT,                                                                 
 [Origin] VARCHAR(25),                                               
 HotelRating VARCHAR(25),  --sanket                                           
 CustomerName VARCHAR(200),   --sanket                                                                                    
 ChkInDate VARCHAR(25),                                                                                  
 --ChkOutDate VARCHAR(25),                                                                        
 --ConfirmationNumber  VARCHAR(25),                                                 
 AmtInINR1  decimal(18,2),                                                                                  
 Preferred   VARCHAR(25),                                                                   
 QuotationID INT, --sanket                                                                                  
 CompanyName VARCHAR(200),--Sagar                                                        
 UserName VARCHAR(100),--Sagar,                                                
 IsCorporate VARCHAR(10),                                                
 BusinessType VARCHAR(10),                                                
 IsDirectPayment VARCHAR(10),                                          
 YearCode INT,                                      
 cnt INT,                                    
 FileCode varchar(20),                              
 BookingType VARCHAR(50),   --added by sanket @ 19/03/2015                                                         
 IsChannellBooking bit,      --added by sanket @ 19/03/2015                         
 ChannellBookingID INT,  --added by sanket @ 19/03/2015                         
 VendorName Varchar(200) --added by sanket @ 19/03/2015                         
 )                                                                                                          
                                                                                                      
 --INSERT INTO #AgentRoomNight                                                                         
 Select A.*,AA.MinDate AS ChkInDate,AA.MaxDate AS ChkOutDate                                                              
                                                                       
 ,XOI.Confirmed_By AS ConfirmationNumber                                        
 ,--(A.RoomNight1* (select count(QXMP.QuotationXOMapID) from QuotationXOMap QXMP where QXMP.XOID=A.XOID and QXMP.XOYearCode=A.YearCode))                                             
   A.RoomNight1 AS RoomNight                                        
    --,cast((AmtInINR1/(select count(QXMP.QuotationXOMapID) from QuotationXOMap QXMP where QXMP.XOID=A.XOID and QXMP.XOYearCode=A.YearCode)) AS DECIMAL(18,2)) AS AmtInINR                                        
    --,cast((AmtInINR1/case when cnt=0 then 1 else cnt end ) AS DECIMAL(18,2)) AS AmtInINR                                        
    --,AmtInINR1 AS AmtInINR     
 from (              
                                
 SELECT    -- distinct            
 CAST('01' + '-' + Left(datename(Month, QA.ItineraryDate),3) + '-' + right(YEAR(QA.ItineraryDate),2) AS Datetime) As [Date],                                     
 M.Name As [Agent Market],                                            
 ACO.Name As [Agent Country],             
 ACT.Name As [Agent City],                                                           
 A.AgentName as [Agent Name],                                                                                                          
 HCT.Name as [Hotel City],                                                                                                           
 HC.Name As [Hotel Group],                                                                            
 NH.HotelName As [Hotel Name],                                                                                                          
  ISNULL(HRC.InfoForOps,'') as [InfoForOps] ,                                                                                                        
  -- '' as [InfoForOps] ,                                                                                                        
  ISNULL(HRC.InfoForXO,'') as [XORemark],                                                                                                         
  ISNULL(QXM.XOID,'') as [XOID],                                        
 --HRCat.Name As [Room Category],                                                                                                          
  case when HRCat.Name is not null then HRCat.Name else QA.RoomCategoryName end As [Room Category],                  
 Left(datename(weekday, QA.ItineraryDate),3) AS [Day],        ---comment by snaket @ 11/09/2013 for not to show day wise --open            
                                                
-- cast (0 AS Varchar(10)) AS  [Day],   --added by snaket @ 11/09/2013 for not to show day wise                                        --close                                  
cast( (IsNull(QA.SingleRoomQty,0) + IsNull(QA.DoubleRoomQty,0) + IsNull(QA.TwinSharingQty,0)) AS INT) AS RoomNight1,                                                                                          
 CAST( CASE WHEN Q.Origin IN (2,3,4) THEN 'Online' ELSE 'Offline'  END as varchar(100)) AS Origin                                                                                   
 --below column added by sanket @ 21/05/2013                                       
 ,HR.Code AS HotelRating                                                                                  
 ,Q.CustomerName                                                                      
 --,CONVERT(varchar(12),Q.TravelDateFrom,106) AS ChkInDate                                                                        
 --,CONVERT(varchar(12),Q.TravelDateTo,106) AS ChkOutDate                                                          
 --,'' AS ConfirmationNumber                                                                                  
 --, convert(varchar,XOI.Confirmed_By) AS ConfirmationNumber                                                                                 
 --,ISNULL(X.AmtInINR,2) --AS XoValue--,'' AS Preferred                                                   
 ---comment by snaket @ 11/09/2013 for not to show day wise   below                                                
 --,(Tamarind_V_1.dbo.fn_CalculateROE_XO((QA.AccomodationSubTotal + QA.MealsSubTotal),Q.QuotationDate,Q.CostingCurrencyCode))   as    AmtInINR                                              
 --, cast (X.AmtInINR as decimal(18,2)) AS   AmtInINR1 --added    by snaket @ 11/09/2013 for not to show day wise                                                                 
 --,   cast (111 as numeric(18,2))                                                                                   
 ,case when  (select COUNT(HF.HotelID) from HotelPreferred HF where HF.HotelID=NH.HotelID)>=1 then 'YES' else'NO' end AS Preferred                                                                               
 ,Q.QuotationID,                                                        
 CM.CompanyName AS CompanyName    
 --,AU.UserName AS UserName   --Added By Sagar                                                   
 ,case when A.IsCorporate=1 then 'YES' else 'NO' end AS IsCorporate                                             
 ,BM.BusinessModuleName AS BusinessType                                                
 --,case when  ISNULL(XIM.XO_ID,'')<>'' then 'Yes' else 'No' end AS IsDirectPayment  --Added By Sagar @ 27/08/2013                 
-- ,X.YearCode                                          
 --,ISNULL((select count(QXMP.QuotationXOMapID) from QuotationXOMap QXMP where QXMP.XOID=X.XO_ID and QXMP.XOYearCode=X.YearCode),0) AS cnt                                          
 ,cast(0 as INT) AS cnt,Q.FileCode                                      
 ,CASE WHEN ISNULL(BookingType,0)=1 THEN 'Hotel / Transport'                                
  WHEN ISNULL(BookingType,0)=2 THEN 'Itinerary'                                
  ELSE '' END BookingType                              
 ,QA.IsChannellBooking ,QA.ChannellBookingID                        
 ,ISNULL(VM.VendorName,'Tamarind') AS VendorName           
-- ,ISNULL(Vms.VendorName,'Tamarind') AS XoVendorName  -- by dhvani 204222021 for vendore name from xo table        
 From Quotation Q WITH(NOLOCK)                                                                                                          
 LEFT Join AgentMaster A WITH(NOLOCK) On A.AgentID = Q.AgentID                                                                                                          
 LEFT Join Market M WITH(NOLOCK) On M.ID = A.MarketID                                                                                                          
 LEFT Join City ACT WITH(NOLOCK) On ACT.IATACode = A.City_IATACode                                                                                                      
 LEFT Join State AST WITH(NOLOCK) On AST.State_ID = ACT.State_IATACode                                                                          
 LEFT Join Country ACO WITH(NOLOCK)  On ACO.IATACode = AST.Country_IATACode                                                                                                          
 LEFT Join CompanyMaster CM WITH(NOLOCK) On CM.CompanyID = Q.CompanyID                                                                                                      
 LEFT Join Quotation_Accomodation QA WITH(NOLOCK) ON QA.QuotationID = Q.QuotationID                                                                      
 left join QuotationXOMap QXM WITH(NOLOCK) ON QXM.QuotationID = Q.QuotationID AND QXM.QuotationItemID = QA.AccomodationID AND QXM.ServiceTypeID=1                                                                                                   
      
       
 LEFT Join HotelRateDetails HRCD WITH(NOLOCK) ON HRCD.HotelRateDetailsID = QA.RateDetailsID                                                                                                      
 LEFT Join HotelRateMasterBackup HRC WITH(NOLOCK) ON HRC.HotelRateID = HRCD.HotelRateID                                                                               
 LEFT Join HotelMaster NH WITH(NOLOCK) ON NH.HotelID = HRC.HotelID                                                                                                      
 LEFT Join City HCT WITH(NOLOCK) On HCT.IATACode = NH.CityIATACode                                                                                                      
 LEFT Join HotelGroups HC WITH(NOLOCK) ON HC.IATACode = NH.ChainIATACode                                                                                                         
 LEFT Join RoomCategory HRCat WITH(NOLOCK) ON HRCat.ID =HRCD.RoomCategoryID             
 LEFT JOIN HotelRating HR WITH(NOLOCK) ON HR.ID=NH.HotelRatingID --added by sanket @ 21/05/2013                                                       
 --inner join XO X WITH(NOLOCK) ON --X.Qut_ID=QXM.QuotationID and                 
 --X.XO_ID=QXM.XOID                                                         
 --left join  VendorMaster Vms ON x.VendorCode = Vms.VendorCode  -- by dhvani 204222021        
 --INNER JOIN aspnet_Users AU ON AU.UserId=Q.OperationBy    --Added By Sagar                                                    
 LEFT join BusinessMaster BM  ON BM.BussinessModuleID=Q.BussinessModuleID   --added by sanket @ 27/08/2013                                                
 --LEFT join XOInvoiceMapping XIM ON XIM.XO_ID=X.XO_ID  and XIM.Qut_ID=X.Qut_ID --added by sanket @ 27/08/2013                            
 left join  VendorMaster VM ON VM.VendorID=QA.ChannellBookingID --added by sanket @ 06/11/2015                                                               
 --inner join XO_Instructions XOI ON X.XO_ID=XOI.XO_ID  and XOI.Qut_ID=X.Qut_ID                                            
                                                                                                     
                                                                                                         
where  convert(varchar,QA.ItineraryDate,112) >= convert(varchar,@Fromdate,112) and convert(varchar,QA.ItineraryDate,112) <= convert(varchar,@Todate,112)                                                                                                      
  
    
     
--and Left(datename(weekday, HQ.DateOfStay),3) IN (SELECT * FROM #TempDay) --= @DateType                                                                                                          
and IsNull(QXM.XOID, '') <> ''                                                          
and (Q.CompanyID In (Case @CompanyID When '' Then Q.CompanyID When 0 Then Q.CompanyID When NULL Then Q.CompanyID End) Or                                                                                                           
Q.CompanyID In (Select Company_Id From #TempCompany))               
and (A.MarketID In (Case @MarketIds When '' Then A.MarketID End) Or                                                                                                           
UPPER(M.ABRV) In (Select UPPER(Market_Id) From #TempMarket))                                                                                
                                                                                          
 --where  HQ.DateOfStay >= @Fromdate and HQ.DateOfStay <= @Todate                                                                                                           
 --  --and Left(datename(weekday, HQ.DateOfStay),3) IN (SELECT * FROM #TempDay) --= @DateType                                                                                                          
 --  and IsNull(HQ.XO_ID, '') <> ''                                                                                                          
--  and (Q.Company_Id In (Case @CompanyID When '' Then Q.Company_Id When 0 Then Q.Company_Id End) Or                                                                                             
 --   Q.Company_Id In (Select Company_Id From #TempCompany))                                                                                                          
 --  and (A.Market_id In (Case @MarketIds When '' Then A.Market_id End) Or                                                                                                           
 --   A.Market_id In (Select Market_Id From #TempMarket))                                                                                                          
                                                                                                          
                                                                                                          
 --ORDER BY YEAR(HQ.DateOfStay), MONTH(HQ.DateOfStay)                                                                                                          
 --order by HQ.DateOfStay,HCT.City_name,A.Agent_Name,NH.Hotels_name                     
  )A                                             
                                                                    
                                                              
 ----SELECT  A.*,AA.MinDate AS ChkInDate,AA.MaxDate AS ChkOutDate                                                              
                                                                       
 ----,XOI.Confirmed_By AS ConfirmationNumber                                        
 ----,--(A.RoomNight1* (select count(QXMP.QuotationXOMapID) from QuotationXOMap QXMP where QXMP.XOID=A.XOID and QXMP.XOYearCode=A.YearCode))                                             
 ----  A.RoomNight1 AS RoomNight                                        
 ----   --,cast((AmtInINR1/(select count(QXMP.QuotationXOMapID) from QuotationXOMap QXMP where QXMP.XOID=A.XOID and QXMP.XOYearCode=A.YearCode)) AS DECIMAL(18,2)) AS AmtInINR                                        
 ----   --,cast((AmtInINR1/case when cnt=0 then 1 else cnt end ) AS DECIMAL(18,2)) AS AmtInINR                                        
 ----   ,AmtInINR1 AS AmtInINR                                      
 ----    FROM #AgentRoomNight  A                                                               
                                                       
 LEFT join XO_Instructions XOI ON A.XOID=XOI.XO_ID  and XOI.Qut_ID=A.QuotationID --sanket                                                                              
                                                                      
  inner join (                                                                 
                                                                   
 select CONVERT(varchar(12),min(CAST( QA.ItineraryDate as datetime)),106) AS MinDate,CONVERT(varchar(12),max(CAST( QA.ItineraryDate as datetime))+1,106) AS MaxDate,XOM.XOID from Quotation_Accomodation QA                                         
       
       
          
            
              
                
                  
                    
                      
                        
                          
                            
                              
INNER JOIN QuotationXOMap XOM ON QA.AccomodationID=XOM.QuotationItemID and XOM.ServiceTypeID=1                                                    
where QA.ItineraryDate between @Fromdate and @Todate                                                              
group by XOM.XOID ) AA ON AA.XOID=A.XOID                                                              
                                                              
                                                              
Order By [DATE]                                                               
                                                                                                  
                                                                                                          
 --Drop Table #TempDay                                                                                                          
 Drop Table #TempCompany                                                                                                          
 Drop Table #TempMarket                                                                                                      
 DROP TABLE #AgentRoomNight                                                                                                          
                                                                                                          
                                                                                             
                               
                                                                                                          
--and Left(datename(weekday, DateOfStay),3) IN (CASE @DateType WHEN 'ALL' THEN Left(datename(weekday, DateOfStay),3) ELSE (SELECT * FROM #TempDay) END) --= @DateType                                         
                                    --exec MIS_AgentRoomNight @FromDate = '04/01/2013',@ToDate = '08/30/2013',@CompanyID = '9',@MarketIds = ''
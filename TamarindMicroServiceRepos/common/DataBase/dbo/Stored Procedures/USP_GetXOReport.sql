CREATE PROC [dbo].[USP_GetXOReport]                                             
@XOID VARCHAR(50) 
,@YearCode varchar(10) 
,@Action char(2)='s'                                                                                                             
AS                                                                                                          
BEGIN                                                  
               if @Action = 's'                         
DECLARE @Origin int                                            
DECLARE @QutID int                                            
SELECT @Origin=Origin,@QutID=QuotationID FROM Quotation WHERE QuotationID =(SELECT QUT_ID FROM XO WHERE XO_ID=@XOID AND XO.YearCode = @YearCode)         
    
DECLARE @VendorFlag varchar(5)        
set @VendorFlag = (select XO.HotelVendorFlag  FROM XO Where  XO.XO_ID=@XOID AND XO.YearCode  = @YearCode)     

DECLARE @CompId varchar(5)
set @CompId = (SELECT CompanyID FROM YearMaster WHERE YearMaster.YearID = @YearCode)

DECLARE @SAPCompCode varchar(10)
set  @SAPCompCode = (select SAP_CompanyCode from CompanyMaster CM WHERE CM.CompanyID = @CompId)   

DECLARE @REDDOT varchar(10)
IF(@SAPCompCode = 'RDIN')
BEGIN 
SET @REDDOT = 'RDIN' 
END
                                  

Print 'A'  
print 'A- dATA FIRST ROW '                                                                                                  
SELECT DISTINCT QXM.XOID,CM.CompanyName,CM.Address,CM.CityIATACode,
CASE WHEN @SAPCompCode = @REDDOT  THEN CM.Website ELSE CM.Website END AS 'Website',
CASE WHEN @SAPCompCode = @REDDOT  THEN CM.Email ELSE CM.Email END AS 'Email',    
CM.LegalName as 'HeadCompanyName', 
--CASE WHEN @SAPCompCode = @REDDOT  THEN CM.LegalName ELSE CASE WHEN CM.CompanyName =CM1.CompanyName THEN CM1.CompanyName ELSE CM1.CompanyName END END AS HeadCompanyName,                                                                            
CASE WHEN CM.Phone ='' then '' ELSE 'Tel: '+CAST(convert(varchar(5), CR.ISDCode)+'-'+convert(varchar,C.STDCode)+'-'+convert(varchar(25), CM.Phone) AS VARCHAR) END Phone,                                                                        
CASE WHEN CM.Fax='' THEN '' ELSE 'Fax: '+CAST(convert(varchar(5),CR.ISDCode)+'-'+convert(varchar,C.STDCode)+'-'+convert(varchar(25),CM.Fax)AS VARCHAR) END Fax,                                                                                  
CASE WHEN @SAPCompCode = @REDDOT  THEN CM.Address ELSE CASE WHEN CM.Address=CM1.Address THEN '' ELSE CM1.Address END END HeadAddress,                                                                        
CASE WHEN CM1.Phone ='' then '' ELSE 'Tel: '+CAST(convert(varchar(5),CR.ISDCode)+'-'+convert(varchar(5),C1.STDCode)+'-'+convert(varchar(25),CM1.Phone) AS VARCHAR) END HeadPhone,                                                                        
CASE WHEN CM1.Fax='' THEN '' ELSE 'Fax: '+CAST(convert(varchar(5),CR.ISDCode)+'-'+convert(varchar(5),C1.STDCode)+'-'+convert(varchar(25),CM1.Fax)AS VARCHAR) END HeadFax                                                                                  
--CM1.CompanyName AS HeadCompanyName                                                                                       
,CM1.CityIATACode AS HeadCityIATACode,                                                                   
CASE WHEN @SAPCompCode = @REDDOT  THEN 'Website: '+ CM.Website ELSE 'Website: '+ CM1.Website END HeadWebsite, 
CASE WHEN @SAPCompCode = @REDDOT  THEN  'Email: '+ CM.Email  ELSE                                                                   
CASE WHEN ISNULL(CM1.Email,'')='' THEN '' ELSE 'Email: '+ CM1.Email END END  HeadEmail, UI.Image AS AgentLogo, BM.IsTTCLogo,Q.QuotationNo,Q.FileCode, QXM.XOYearCode AS 'YearCode', -- added by dhvani @02192020 for TTC logo                                          
--CAST('' AS Image) AS logo  
--,CM.CSTNo as 'GSTNID'   
CASE WHEN @SAPCompCode = @REDDOT  THEN CM.EmailIDForXO ELSE 'bills@tamarindglobal.com' END InvoiceEmail , 
CASE WHEN @SAPCompCode = @REDDOT  THEN CM.CIN ELSE 'U63040MH2006PTC164045.'END CorporateIdentityNumber,
'AC' AS XOFlag,
@SAPCompCode AS CompFlag         
                     
FROM QuotationXOMap QXM                                                                                             
INNER JOIN Quotation Q ON Q.QuotationID = QXM.QuotationID   
Inner join BusinessMaster BM on Q.BussinessModuleID = BM.BussinessModuleID     -- added by dhvani @02192020 for TTC logo                                    
INNER JOIN CompanyMaster CM ON CM.CompanyID = Q.CompanyID                                                           
INNER JOIN CompanyMaster CM1 ON CM1.CompanyID = CM1.CompanyID AND CM1.HeadOffice=1                                    
LEFT JOIN UploadImage UI ON UI.ParentID=Q.AgentID AND ParentPageType=7                             
LEFT JOIN City C ON C.IATACode=CM.CityIATACode                                                          
LEFT JOIN State S ON S.State_ID=C.State_IATACode                                                                        
LEFT JOIN Country CR ON CR.IATACode=S.Country_IATACode                                                            
LEFT JOIN City C1 ON C1.IATACode=CM1.CityIATACode                                                                      
WHERE QXM.XOID = @XOID  AND Q.YearID = @YearCode                                     
                                                   
IF(@Origin  not in ('2','3'))                                                         
BEGIN         
    
IF(@VendorFlag = 'V')        
BEGIN        
 
--print   'Vendor1'   
    
select AA.XOID,AA.FileCode,AA.NoOfPax,AA.Confirmed_By,AA.CustomerName,AA.RoomCategory,AA.XO_Date,AA.ItineraryDate                        
,AA.CheckOut,AA.XO_Instruction,AA.XO_Line_Desc,AA.InfoForXO,AA.BookingReferenceNumber,AA.SupplierReference                  
,MealPlanCode                  
              
,AA.HotelName                        
,AA.ArrivalDate,AA.FromCity,AA.ArrivalBy,AA.DepartureDate,AA.ToCity,AA.DeptBy                        
,AA.FromTime,AA.ToTime,AA.UserName,AA.Address,AA.EmailID,AA.FaxNo,AA.PhoneNo,AA.ServiceDate,AA.HotelRateID                        
,SUM(AA.SingleRoomQty)  AS    SingleRoomQty                                  
,SUM(AA.DoubleRoomQty)  AS    DoubleRoomQty                                        
,SUM(AA.TwinSharingQty)  AS    TwinSharingQty                                        
,SUM(AA.ExtraAdults)    AS    ExtraAdults                                      
,SUM(AA.ExtraChild) AS    ExtraChild             
,AA.GSTNID             
,AA.GSTAddress,AA.HotelVendorFlag      
,AA.IsAgentCredit      
,AA.IsHotelCredit           
,AA.CompanyName 
,AA.MembershipNo
,AA.MobileNo                                                       
from (                                                                                              
SELECT CONVERT(varchar,X.XO_Date,106) AS XO_Date,QXM.XOID,B.FileCode,XI.NoOfPax,XI.Confirmed_By,                                                                 
'' AS CustomerName,CONVERT(VARCHAR,QA.ItineraryDate,106) AS ItineraryDate,convert(varchar,'',106) AS CheckOut ,                                    
                                                       
CASE WHEN (ISNULL(QA.IsChannellBooking,0)=0 AND ISNULL(QA.ChannellBookingID,0)<>0 ) THEN QA.RoomCategoryName ELSE RC.Name END AS  RoomCategory, --added by sanket @ 23/06/2015                                
QA.SingleRoomQty,QA.DoubleRoomQty,QA.TwinSharingQty,                                                                  
XI.XO_Instruction,XI.XO_Line_Desc,'' as InfoForXO, QA.ExtraAdults,QA.ExtraChild ,                                              
'' AS BookingReferenceNumber ,'' AS SupplierReference,             
 

CASE WHEN ISNULL(HM.GSTNID,'')='' THEN  (SELECT top 1 CompanyMaster.CSTNo  from CompanyMaster left join YearMaster on CompanyMaster.CompanyID = YearMaster.CompanyID   
left join QuotationXOMap on YearMaster.YearID = QuotationXOMap.XOYearCode where QuotationXOMap.XOID = @XOID ) ELSE HM.GSTNID END GSTNID ,   
CASE WHEN ISNULL(CM.Address,'')='' THEN  (SELECT top 1 CompanyMaster.Address  from CompanyMaster left join YearMaster on CompanyMaster.CompanyID = YearMaster.CompanyID   
left join QuotationXOMap on YearMaster.YearID = QuotationXOMap.XOYearCode where QuotationXOMap.XOID = @XOID ) ELSE CM.Address END GSTAddress ,    

X.HotelVendorFlag,Q.QuotationID ,                       
CASE WHEN ISNULL(MealPlanName,'')=''  then    ----------                                         
CASE WHEN MP.Code='JP' OR MP.Code='JP1' OR MP.Code='JP2' THEN MP.Description ELSE                                                              
CASE WHEN QA.LunchIncluded=0 AND QA.DinnerIncluded=0 AND QA.BreakfastIncluded=0 THEN 'Room Only' ELSE                                                            
CASE WHEN QA.BreakfastIncluded=1 THEN 'Bfst' ELSE '' END+                                              
CASE WHEN QA.BreakfastIncluded=1 AND QA.LunchIncluded=1  THEN '+' ELSE ''END+                                              
CASE WHEN QA.LunchIncluded=1 THEN 'Lun' ELSE '' END+                                                                                  
CASE WHEN (QA.LunchIncluded=1  OR QA.DinnerIncluded=1) AND QA.BreakfastIncluded=1 THEN '+' ELSE '' END+                                                                                
CASE WHEN QA.DinnerIncluded=1 THEN 'Din' ELSE '' END END END                  
ELSE MealPlanName END ----                  
AS MealPlanCode                    
                
,QA.MealPlanName AS   MealPlanCode1                  
                                                                                                
,HM.HotelName,                                        
CASE WHEN XI.ArrivalDate IS NOT NULL THEN CONVERT(varchar,XI.ArrivalDate,106) ELSE 'TBA' END AS ArrivalDate,                                                                                      
XI.FromCity,XI.ArrivalBy,                                              
CASE WHEN XI.DepartureDate IS NOT NULL THEN CONVERT(VARCHAR,XI.DepartureDate,106) ELSE 'TBA' END AS DepartureDate ,                                                       
XI.ToCity,XI.DeptBy,XI.FromTime,XI.ToTime,'' AS UserName,                                                        
HM.Address,HM.EmailID,                                                                      
CASE WHEN ISNULL(HM.FaxNo,'')='' THEN '' ELSE CONVERT(VARCHAR(10),CR.ISDCode)+' '+HM.FaxNo END FaxNo,                                                                      
CASE WHEN ISNULL(HM.PhoneNo,'')='' THEN '' ELSE CONVERT(VARCHAR(10),CR.ISDCode)+' '+HM.PhoneNo END PhoneNo                                                                      
,QA.ItineraryDate AS ServiceDate,HRM.HotelRateID        
,CASE WHEN ISNULL(Am.CreditApplicable,0)=1 THEN 'Yes' ELSE 'No'END   AS IsAgentCredit      
,CASE WHEN ISNULL(HM.CreditApplicable,0)=1 THEN 'Yes' ELSE 'No'END AS IsHotelCredit           
,CM.CompanyName 
,HM.MembershipNo    --HM.MembershipNo 
,'' AS MobileNo                                              
FROM QuotationXOMap QXM                                                                                                                 
INNER JOIN Quotation.QuotationMaster Q ON Q.QuotationID = QXM.QuotationID                                         
INNER JOIN Quotation_Accomodation QA ON QA.AccomodationID= QXM.QuotationItemID AND QA.QuotationID = QXM.QuotationID                                                                                                                
INNER JOIN [RateCards].HotelRateDetails HRD ON HRD.HotelRateDetailID= QA.NewHotelRateDetailsID                                                            
INNER JOIN [RateCards].HotelRateMaster HRM ON HRM.HotelRateID= HRD.HotelRateID             
LEFT JOIN RoomCategory RC ON RC.ID=QA.RoomCategoryID         --LEFT by sanket @ 10/10/2014 for dotw                                                    
LEFT JOIN MealPlan MP ON MP.ID = HRD.MealPlanID              --LEFT by sanket @ 10/10/2014 for dotw                                       
INNER JOIN XO X ON X.XO_ID = QXM.XOID AND Q.QuotationID = X.Qut_ID                                                            
LEFT JOIN XO_Instructions XI ON XI.XO_ID = QXM.XOID AND XI.Qut_ID = QXM.QuotationID                                                            
LEFT JOIN HotelMaster HM ON HM.HotelID= QA.HotelID    
left join Booking.tbl_Booking B ON B.QUOTATIONID=Q.QuotationID 
LEFT JOIN AgentMaster AM ON AM.AgentID=B.AgentID
 --added by sanket @ 28/08/2014         
LEFT JOIN City C ON C.IATACode=QA.CityCode                                                            
LEFT JOIN State S ON S.State_ID=C.State_IATACode                                                            
LEFT JOIN Country CR ON CR.IATACode=S.Country_IATACode              
LEFT JOIN CompanyMaster CM ON CM.CompanyID = HM.CompanyID                                                           
WHERE QXM.XOID =@XOID AND Q.YearID = @YearCode  --QXM.XOID = 'H16000032'                                                  
)AA                                        
group by AA.XOID,AA.FileCode,AA.NoOfPax,AA.Confirmed_By,AA.CustomerName,AA.RoomCategory,AA.XO_Date,AA.ItineraryDate                        
,AA.CheckOut,AA.XO_Instruction,AA.XO_Line_Desc,AA.InfoForXO,AA.BookingReferenceNumber,AA.SupplierReference,AA.MealPlanCode,AA.HotelName                        
,AA.ArrivalDate,AA.FromCity,AA.ArrivalBy,AA.DepartureDate,AA.ToCity,AA.DeptBy                        
,AA.FromTime,AA.ToTime,AA.UserName,AA.Address,AA.EmailID,AA.FaxNo,AA.PhoneNo,AA.ServiceDate,AA.HotelRateID,AA.GSTNID, AA.GSTAddress,AA.HotelVendorFlag,AA.QuotationID      
,AA.IsAgentCredit      
,AA.IsHotelCredit           
,AA.CompanyName , AA.MembershipNo, AA.MobileNo                                                    
ORDER BY --SeqNumber,                        
ServiceDate     
    
END        
ELSE        
BEGIN           
   
print   'H'     
PRINT 'TEST PRINT REDDOT'   
print   @VendorFlag         
                           
select AA.XOID,AA.FileCode,AA.NoOfPax,AA.Confirmed_By,AA.CustomerName,AA.RoomCategory,AA.XO_Date,AA.ItineraryDate                        
,AA.CheckOut,AA.XO_Instruction,AA.XO_Line_Desc,AA.InfoForXO,AA.BookingReferenceNumber,AA.SupplierReference                  
,MealPlanCode                  
              
,AA.HotelName                        
,AA.ArrivalDate,AA.FromCity,AA.ArrivalBy,AA.DepartureDate,AA.ToCity,AA.DeptBy                        
,AA.FromTime,AA.ToTime,AA.UserName,AA.Address,AA.EmailID,AA.FaxNo,AA.PhoneNo,AA.ServiceDate,AA.HotelRateID                        
,SUM(AA.SingleRoomQty)  AS    SingleRoomQty                                  
,SUM(AA.DoubleRoomQty)  AS    DoubleRoomQty                                        
,SUM(AA.TwinSharingQty)  AS    TwinSharingQty                                        
,SUM(AA.ExtraAdults)    AS    ExtraAdults                                      
,SUM(AA.ExtraChild) AS    ExtraChild             
,AA.GSTNID             
,AA.GSTAddress,AA.HotelVendorFlag      
,AA.IsAgentCredit      
,AA.IsHotelCredit           
,AA.CompanyName 
,AA.MembershipNo
,AA.MobileNo                                                       
from (                                                                                              
SELECT CONVERT(varchar,X.XO_Date,106) AS XO_Date,QXM.XOID,B.FileCode,XI.NoOfPax,XI.Confirmed_By,                                                                 
'' AS CustomerName,CONVERT(VARCHAR,QA.ItineraryDate,106) AS ItineraryDate,convert(varchar,'',106) AS CheckOut ,                                    
                                                       
CASE WHEN (ISNULL(QA.IsChannellBooking,0)=0 AND ISNULL(QA.ChannellBookingID,0)<>0 ) THEN QA.RoomCategoryName ELSE RC.Name END AS  RoomCategory, --added by sanket @ 23/06/2015                                
QA.SingleRoomQty,QA.DoubleRoomQty,QA.TwinSharingQty,                                                                  
XI.XO_Instruction,XI.XO_Line_Desc,'' as InfoForXO, QA.ExtraAdults,QA.ExtraChild ,                                              
'' AS BookingReferenceNumber ,'' AS SupplierReference,             
 

CASE WHEN ISNULL(HM.GSTNID,'')='' THEN  (SELECT top 1 CompanyMaster.CSTNo  from CompanyMaster left join YearMaster on CompanyMaster.CompanyID = YearMaster.CompanyID   
left join QuotationXOMap on YearMaster.YearID = QuotationXOMap.XOYearCode where QuotationXOMap.XOID = @XOID ) ELSE HM.GSTNID END GSTNID ,   
CASE WHEN ISNULL(CM.Address,'')='' THEN  (SELECT top 1 CompanyMaster.Address  from CompanyMaster left join YearMaster on CompanyMaster.CompanyID = YearMaster.CompanyID   
left join QuotationXOMap on YearMaster.YearID = QuotationXOMap.XOYearCode where QuotationXOMap.XOID = @XOID ) ELSE CM.Address END GSTAddress ,    

X.HotelVendorFlag,Q.QuotationID ,                       
CASE WHEN ISNULL(MealPlanName,'')=''  then    ----------                                         
CASE WHEN MP.Code='JP' OR MP.Code='JP1' OR MP.Code='JP2' THEN MP.Description ELSE                                                              
CASE WHEN QA.LunchIncluded=0 AND QA.DinnerIncluded=0 AND QA.BreakfastIncluded=0 THEN 'Room Only' ELSE                                                            
CASE WHEN QA.BreakfastIncluded=1 THEN 'Bfst' ELSE '' END+                                              
CASE WHEN QA.BreakfastIncluded=1 AND QA.LunchIncluded=1  THEN '+' ELSE ''END+                                              
CASE WHEN QA.LunchIncluded=1 THEN 'Lun' ELSE '' END+                                                                                  
CASE WHEN (QA.LunchIncluded=1  OR QA.DinnerIncluded=1) AND QA.BreakfastIncluded=1 THEN '+' ELSE '' END+                                                                                
CASE WHEN QA.DinnerIncluded=1 THEN 'Din' ELSE '' END END END                  
ELSE MealPlanName END ----                  
AS MealPlanCode                    
                
,QA.MealPlanName AS   MealPlanCode1                  
                                                                                                
,HM.HotelName,                                        
CASE WHEN XI.ArrivalDate IS NOT NULL THEN CONVERT(varchar,XI.ArrivalDate,106) ELSE 'TBA' END AS ArrivalDate,                                                                                      
XI.FromCity,XI.ArrivalBy,                                              
CASE WHEN XI.DepartureDate IS NOT NULL THEN CONVERT(VARCHAR,XI.DepartureDate,106) ELSE 'TBA' END AS DepartureDate ,                                                       
XI.ToCity,XI.DeptBy,XI.FromTime,XI.ToTime,'' AS UserName,                                                        
HM.Address,HM.EmailID,                                                                      
CASE WHEN ISNULL(HM.FaxNo,'')='' THEN '' ELSE CONVERT(VARCHAR(10),CR.ISDCode)+' '+HM.FaxNo END FaxNo,                                                                      
CASE WHEN ISNULL(HM.PhoneNo,'')='' THEN '' ELSE CONVERT(VARCHAR(10),CR.ISDCode)+' '+HM.PhoneNo END PhoneNo                                                                      
,QA.ItineraryDate AS ServiceDate,HRM.HotelRateID        
,CASE WHEN ISNULL(Am.CreditApplicable,0)=1 THEN 'Yes' ELSE 'No'END   AS IsAgentCredit      
,CASE WHEN ISNULL(HM.CreditApplicable,0)=1 THEN 'Yes' ELSE 'No'END AS IsHotelCredit           
,CM.CompanyName 
,HM.MembershipNo    --HM.MembershipNo 
,'' AS MobileNo                                              
FROM QuotationXOMap QXM                                                                                                                 
INNER JOIN Quotation.QuotationMaster Q ON Q.QuotationID = QXM.QuotationID                                         
INNER JOIN Quotation_Accomodation QA ON QA.AccomodationID= QXM.QuotationItemID AND QA.QuotationID = QXM.QuotationID                                                                                                                
INNER JOIN [RateCards].HotelRateDetails HRD ON HRD.HotelRateDetailID= QA.NewHotelRateDetailsID                                                            
INNER JOIN [RateCards].HotelRateMaster HRM ON HRM.HotelRateID= HRD.HotelRateID             
LEFT JOIN RoomCategory RC ON RC.ID=QA.RoomCategoryID         --LEFT by sanket @ 10/10/2014 for dotw                                                    
LEFT JOIN MealPlan MP ON MP.ID = HRD.MealPlanID              --LEFT by sanket @ 10/10/2014 for dotw                                       
INNER JOIN XO X ON X.XO_ID = QXM.XOID AND Q.QuotationID = X.Qut_ID                                                            
LEFT JOIN XO_Instructions XI ON XI.XO_ID = QXM.XOID AND XI.Qut_ID = QXM.QuotationID                                                            
LEFT JOIN HotelMaster HM ON HM.HotelID= QA.HotelID    
left join Booking.tbl_Booking B ON B.QUOTATIONID=Q.QuotationID 
LEFT JOIN AgentMaster AM ON AM.AgentID=B.AgentID
 --added by sanket @ 28/08/2014         
LEFT JOIN City C ON C.IATACode=QA.CityCode                                                            
LEFT JOIN State S ON S.State_ID=C.State_IATACode                                                            
LEFT JOIN Country CR ON CR.IATACode=S.Country_IATACode              
LEFT JOIN CompanyMaster CM ON CM.CompanyID = HM.CompanyID                                                           
WHERE QXM.XOID =@XOID AND Q.YearID = @YearCode  --QXM.XOID = 'H16000032'                                                  
)AA                                        
group by AA.XOID,AA.FileCode,AA.NoOfPax,AA.Confirmed_By,AA.CustomerName,AA.RoomCategory,AA.XO_Date,AA.ItineraryDate                        
,AA.CheckOut,AA.XO_Instruction,AA.XO_Line_Desc,AA.InfoForXO,AA.BookingReferenceNumber,AA.SupplierReference,AA.MealPlanCode,AA.HotelName                        
,AA.ArrivalDate,AA.FromCity,AA.ArrivalBy,AA.DepartureDate,AA.ToCity,AA.DeptBy                        
,AA.FromTime,AA.ToTime,AA.UserName,AA.Address,AA.EmailID,AA.FaxNo,AA.PhoneNo,AA.ServiceDate,AA.HotelRateID,AA.GSTNID, AA.GSTAddress,AA.HotelVendorFlag,AA.QuotationID      
,AA.IsAgentCredit      
,AA.IsHotelCredit           
,AA.CompanyName , AA.MembershipNo, AA.MobileNo                                                    
                                      
ORDER BY ServiceDate            
    
END                              
--ORDER BY ServiceDate,RoomCategory,MealPlanCode                                                        
END                                            
ELSE                                            
BEGIN                                            
Print 'DOTW'                                                          
if(@VendorFlag = 'V')         
BEGIN        
    
print @VendorFlag         
    
select AA.XOID,AA.FileCode,AA.NoOfPax,AA.Confirmed_By,AA.CustomerName,AA.RoomCategory,AA.XO_Date,AA.ItineraryDate                        
,AA.CheckOut,AA.XO_Instruction,AA.XO_Line_Desc,AA.InfoForXO,AA.BookingReferenceNumber,AA.SupplierReference                  
,MealPlanCode                  
              
,AA.HotelName                        
,AA.ArrivalDate,AA.FromCity,AA.ArrivalBy,AA.DepartureDate,AA.ToCity,AA.DeptBy                        
,AA.FromTime,AA.ToTime,AA.UserName,AA.Address,AA.EmailID,AA.FaxNo,AA.PhoneNo,AA.ServiceDate,AA.HotelRateID                        
,SUM(AA.SingleRoomQty)  AS    SingleRoomQty                                  
,SUM(AA.DoubleRoomQty)  AS    DoubleRoomQty                                        
,SUM(AA.TwinSharingQty)  AS    TwinSharingQty                                        
,SUM(AA.ExtraAdults)    AS    ExtraAdults                                      
,SUM(AA.ExtraChild) AS    ExtraChild             
,AA.GSTNID             
,AA.GSTAddress,AA.HotelVendorFlag      
,AA.IsAgentCredit      
,AA.IsHotelCredit           
,AA.CompanyName 
,AA.MembershipNo
,AA.MobileNo                                                       
from (                                                                                              
SELECT CONVERT(varchar,X.XO_Date,106) AS XO_Date,QXM.XOID,B.FileCode,XI.NoOfPax,XI.Confirmed_By,                                                                 
'' AS CustomerName,CONVERT(VARCHAR,QA.ItineraryDate,106) AS ItineraryDate,convert(varchar,'',106) AS CheckOut ,                                    
                                                       
CASE WHEN (ISNULL(QA.IsChannellBooking,0)=0 AND ISNULL(QA.ChannellBookingID,0)<>0 ) THEN QA.RoomCategoryName ELSE RC.Name END AS  RoomCategory, --added by sanket @ 23/06/2015                                
QA.SingleRoomQty,QA.DoubleRoomQty,QA.TwinSharingQty,                                                                  
XI.XO_Instruction,XI.XO_Line_Desc,'' as InfoForXO, QA.ExtraAdults,QA.ExtraChild ,                                              
'' AS BookingReferenceNumber ,'' AS SupplierReference,             
 

CASE WHEN ISNULL(HM.GSTNID,'')='' THEN  (SELECT top 1 CompanyMaster.CSTNo  from CompanyMaster left join YearMaster on CompanyMaster.CompanyID = YearMaster.CompanyID   
left join QuotationXOMap on YearMaster.YearID = QuotationXOMap.XOYearCode where QuotationXOMap.XOID = @XOID ) ELSE HM.GSTNID END GSTNID ,   
CASE WHEN ISNULL(CM.Address,'')='' THEN  (SELECT top 1 CompanyMaster.Address  from CompanyMaster left join YearMaster on CompanyMaster.CompanyID = YearMaster.CompanyID   
left join QuotationXOMap on YearMaster.YearID = QuotationXOMap.XOYearCode where QuotationXOMap.XOID = @XOID ) ELSE CM.Address END GSTAddress ,    

X.HotelVendorFlag,Q.QuotationID ,                       
CASE WHEN ISNULL(MealPlanName,'')=''  then    ----------                                         
CASE WHEN MP.Code='JP' OR MP.Code='JP1' OR MP.Code='JP2' THEN MP.Description ELSE                                                              
CASE WHEN QA.LunchIncluded=0 AND QA.DinnerIncluded=0 AND QA.BreakfastIncluded=0 THEN 'Room Only' ELSE                                                            
CASE WHEN QA.BreakfastIncluded=1 THEN 'Bfst' ELSE '' END+                                              
CASE WHEN QA.BreakfastIncluded=1 AND QA.LunchIncluded=1  THEN '+' ELSE ''END+                                              
CASE WHEN QA.LunchIncluded=1 THEN 'Lun' ELSE '' END+                                                                                  
CASE WHEN (QA.LunchIncluded=1  OR QA.DinnerIncluded=1) AND QA.BreakfastIncluded=1 THEN '+' ELSE '' END+                                                                                
CASE WHEN QA.DinnerIncluded=1 THEN 'Din' ELSE '' END END END                  
ELSE MealPlanName END ----                  
AS MealPlanCode                    
                
,QA.MealPlanName AS   MealPlanCode1                  
                                                                                                
,HM.HotelName,                                        
CASE WHEN XI.ArrivalDate IS NOT NULL THEN CONVERT(varchar,XI.ArrivalDate,106) ELSE 'TBA' END AS ArrivalDate,                                                                                      
XI.FromCity,XI.ArrivalBy,                                              
CASE WHEN XI.DepartureDate IS NOT NULL THEN CONVERT(VARCHAR,XI.DepartureDate,106) ELSE 'TBA' END AS DepartureDate ,                                                       
XI.ToCity,XI.DeptBy,XI.FromTime,XI.ToTime,'' AS UserName,                                                        
HM.Address,HM.EmailID,                                                                      
CASE WHEN ISNULL(HM.FaxNo,'')='' THEN '' ELSE CONVERT(VARCHAR(10),CR.ISDCode)+' '+HM.FaxNo END FaxNo,                                                                      
CASE WHEN ISNULL(HM.PhoneNo,'')='' THEN '' ELSE CONVERT(VARCHAR(10),CR.ISDCode)+' '+HM.PhoneNo END PhoneNo                                                                      
,QA.ItineraryDate AS ServiceDate,HRM.HotelRateID        
,CASE WHEN ISNULL(Am.CreditApplicable,0)=1 THEN 'Yes' ELSE 'No'END   AS IsAgentCredit      
,CASE WHEN ISNULL(HM.CreditApplicable,0)=1 THEN 'Yes' ELSE 'No'END AS IsHotelCredit           
,CM.CompanyName 
,HM.MembershipNo    --HM.MembershipNo 
,'' AS MobileNo                                              
FROM QuotationXOMap QXM                                                                                                                 
INNER JOIN Quotation.QuotationMaster Q ON Q.QuotationID = QXM.QuotationID                                         
INNER JOIN Quotation_Accomodation QA ON QA.AccomodationID= QXM.QuotationItemID AND QA.QuotationID = QXM.QuotationID                                                                                                                
INNER JOIN [RateCards].HotelRateDetails HRD ON HRD.HotelRateDetailID= QA.NewHotelRateDetailsID                                                            
INNER JOIN [RateCards].HotelRateMaster HRM ON HRM.HotelRateID= HRD.HotelRateID             
LEFT JOIN RoomCategory RC ON RC.ID=QA.RoomCategoryID         --LEFT by sanket @ 10/10/2014 for dotw                                                    
LEFT JOIN MealPlan MP ON MP.ID = HRD.MealPlanID              --LEFT by sanket @ 10/10/2014 for dotw                                       
INNER JOIN XO X ON X.XO_ID = QXM.XOID AND Q.QuotationID = X.Qut_ID                                                            
LEFT JOIN XO_Instructions XI ON XI.XO_ID = QXM.XOID AND XI.Qut_ID = QXM.QuotationID                                                            
LEFT JOIN HotelMaster HM ON HM.HotelID= QA.HotelID    
left join Booking.tbl_Booking B ON B.QUOTATIONID=Q.QuotationID 
LEFT JOIN AgentMaster AM ON AM.AgentID=B.AgentID
 --added by sanket @ 28/08/2014         
LEFT JOIN City C ON C.IATACode=QA.CityCode                                                            
LEFT JOIN State S ON S.State_ID=C.State_IATACode                                                            
LEFT JOIN Country CR ON CR.IATACode=S.Country_IATACode              
LEFT JOIN CompanyMaster CM ON CM.CompanyID = HM.CompanyID                                                           
WHERE QXM.XOID =@XOID AND Q.YearID = @YearCode  --QXM.XOID = 'H16000032'                                                  
)AA                                        
group by AA.XOID,AA.FileCode,AA.NoOfPax,AA.Confirmed_By,AA.CustomerName,AA.RoomCategory,AA.XO_Date,AA.ItineraryDate                        
,AA.CheckOut,AA.XO_Instruction,AA.XO_Line_Desc,AA.InfoForXO,AA.BookingReferenceNumber,AA.SupplierReference,AA.MealPlanCode,AA.HotelName                        
,AA.ArrivalDate,AA.FromCity,AA.ArrivalBy,AA.DepartureDate,AA.ToCity,AA.DeptBy                        
,AA.FromTime,AA.ToTime,AA.UserName,AA.Address,AA.EmailID,AA.FaxNo,AA.PhoneNo,AA.ServiceDate,AA.HotelRateID,AA.GSTNID, AA.GSTAddress,AA.HotelVendorFlag,AA.QuotationID      
,AA.IsAgentCredit      
,AA.IsHotelCredit           
,AA.CompanyName , AA.MembershipNo, AA.MobileNo                                                    
ORDER BY --SeqNumber,                        
ServiceDate                                       
    
    
END        
ELSE        
BEGIN               
    
    
select AA.XOID,AA.FileCode,AA.NoOfPax,AA.Confirmed_By,AA.CustomerName,AA.RoomCategory,AA.XO_Date,AA.ItineraryDate                        
,AA.CheckOut,AA.XO_Instruction,AA.XO_Line_Desc,AA.InfoForXO,AA.BookingReferenceNumber,AA.SupplierReference                  
,MealPlanCode                  
              
,AA.HotelName                        
,AA.ArrivalDate,AA.FromCity,AA.ArrivalBy,AA.DepartureDate,AA.ToCity,AA.DeptBy                        
,AA.FromTime,AA.ToTime,AA.UserName,AA.Address,AA.EmailID,AA.FaxNo,AA.PhoneNo,AA.ServiceDate,AA.HotelRateID                        
,SUM(AA.SingleRoomQty)  AS    SingleRoomQty                                  
,SUM(AA.DoubleRoomQty)  AS    DoubleRoomQty                                        
,SUM(AA.TwinSharingQty)  AS    TwinSharingQty                                        
,SUM(AA.ExtraAdults)    AS    ExtraAdults                                      
,SUM(AA.ExtraChild) AS    ExtraChild             
,AA.GSTNID             
,AA.GSTAddress,AA.HotelVendorFlag      
,AA.IsAgentCredit      
,AA.IsHotelCredit           
,AA.CompanyName 
,AA.MembershipNo
,AA.MobileNo                                                       
from (                                                                                              
SELECT CONVERT(varchar,X.XO_Date,106) AS XO_Date,QXM.XOID,B.FileCode,XI.NoOfPax,XI.Confirmed_By,                                                                 
'' AS CustomerName,CONVERT(VARCHAR,QA.ItineraryDate,106) AS ItineraryDate,convert(varchar,'',106) AS CheckOut ,                                    
                                                       
CASE WHEN (ISNULL(QA.IsChannellBooking,0)=0 AND ISNULL(QA.ChannellBookingID,0)<>0 ) THEN QA.RoomCategoryName ELSE RC.Name END AS  RoomCategory, --added by sanket @ 23/06/2015                                
QA.SingleRoomQty,QA.DoubleRoomQty,QA.TwinSharingQty,                                                                  
XI.XO_Instruction,XI.XO_Line_Desc,'' as InfoForXO, QA.ExtraAdults,QA.ExtraChild ,                                              
'' AS BookingReferenceNumber ,'' AS SupplierReference,             
 

CASE WHEN ISNULL(HM.GSTNID,'')='' THEN  (SELECT top 1 CompanyMaster.CSTNo  from CompanyMaster left join YearMaster on CompanyMaster.CompanyID = YearMaster.CompanyID   
left join QuotationXOMap on YearMaster.YearID = QuotationXOMap.XOYearCode where QuotationXOMap.XOID = @XOID ) ELSE HM.GSTNID END GSTNID ,   
CASE WHEN ISNULL(CM.Address,'')='' THEN  (SELECT top 1 CompanyMaster.Address  from CompanyMaster left join YearMaster on CompanyMaster.CompanyID = YearMaster.CompanyID   
left join QuotationXOMap on YearMaster.YearID = QuotationXOMap.XOYearCode where QuotationXOMap.XOID = @XOID ) ELSE CM.Address END GSTAddress ,    

X.HotelVendorFlag,Q.QuotationID ,                       
CASE WHEN ISNULL(MealPlanName,'')=''  then    ----------                                         
CASE WHEN MP.Code='JP' OR MP.Code='JP1' OR MP.Code='JP2' THEN MP.Description ELSE                                                              
CASE WHEN QA.LunchIncluded=0 AND QA.DinnerIncluded=0 AND QA.BreakfastIncluded=0 THEN 'Room Only' ELSE                                                            
CASE WHEN QA.BreakfastIncluded=1 THEN 'Bfst' ELSE '' END+                                              
CASE WHEN QA.BreakfastIncluded=1 AND QA.LunchIncluded=1  THEN '+' ELSE ''END+                                              
CASE WHEN QA.LunchIncluded=1 THEN 'Lun' ELSE '' END+                                                                                  
CASE WHEN (QA.LunchIncluded=1  OR QA.DinnerIncluded=1) AND QA.BreakfastIncluded=1 THEN '+' ELSE '' END+                                                                                
CASE WHEN QA.DinnerIncluded=1 THEN 'Din' ELSE '' END END END                  
ELSE MealPlanName END ----                  
AS MealPlanCode                    
                
,QA.MealPlanName AS   MealPlanCode1                  
                                                                                                
,HM.HotelName,                                        
CASE WHEN XI.ArrivalDate IS NOT NULL THEN CONVERT(varchar,XI.ArrivalDate,106) ELSE 'TBA' END AS ArrivalDate,                                                                                      
XI.FromCity,XI.ArrivalBy,                                              
CASE WHEN XI.DepartureDate IS NOT NULL THEN CONVERT(VARCHAR,XI.DepartureDate,106) ELSE 'TBA' END AS DepartureDate ,                                                       
XI.ToCity,XI.DeptBy,XI.FromTime,XI.ToTime,'' AS UserName,                                                        
HM.Address,HM.EmailID,                                                                      
CASE WHEN ISNULL(HM.FaxNo,'')='' THEN '' ELSE CONVERT(VARCHAR(10),CR.ISDCode)+' '+HM.FaxNo END FaxNo,                                                                      
CASE WHEN ISNULL(HM.PhoneNo,'')='' THEN '' ELSE CONVERT(VARCHAR(10),CR.ISDCode)+' '+HM.PhoneNo END PhoneNo                                                                      
,QA.ItineraryDate AS ServiceDate,HRM.HotelRateID        
,CASE WHEN ISNULL(Am.CreditApplicable,0)=1 THEN 'Yes' ELSE 'No'END   AS IsAgentCredit      
,CASE WHEN ISNULL(HM.CreditApplicable,0)=1 THEN 'Yes' ELSE 'No'END AS IsHotelCredit           
,CM.CompanyName 
,HM.MembershipNo    --HM.MembershipNo 
,'' AS MobileNo                                              
FROM QuotationXOMap QXM                                                                                                                 
INNER JOIN Quotation.QuotationMaster Q ON Q.QuotationID = QXM.QuotationID                                         
INNER JOIN Quotation_Accomodation QA ON QA.AccomodationID= QXM.QuotationItemID AND QA.QuotationID = QXM.QuotationID                                                                                                                
INNER JOIN [RateCards].HotelRateDetails HRD ON HRD.HotelRateDetailID= QA.NewHotelRateDetailsID                                                            
INNER JOIN [RateCards].HotelRateMaster HRM ON HRM.HotelRateID= HRD.HotelRateID             
LEFT JOIN RoomCategory RC ON RC.ID=QA.RoomCategoryID         --LEFT by sanket @ 10/10/2014 for dotw                                                    
LEFT JOIN MealPlan MP ON MP.ID = HRD.MealPlanID              --LEFT by sanket @ 10/10/2014 for dotw                                       
INNER JOIN XO X ON X.XO_ID = QXM.XOID AND Q.QuotationID = X.Qut_ID                                                            
LEFT JOIN XO_Instructions XI ON XI.XO_ID = QXM.XOID AND XI.Qut_ID = QXM.QuotationID                                                            
LEFT JOIN HotelMaster HM ON HM.HotelID= QA.HotelID    
left join Booking.tbl_Booking B ON B.QUOTATIONID=Q.QuotationID 
LEFT JOIN AgentMaster AM ON AM.AgentID=B.AgentID
 --added by sanket @ 28/08/2014         
LEFT JOIN City C ON C.IATACode=QA.CityCode                                                            
LEFT JOIN State S ON S.State_ID=C.State_IATACode                                                            
LEFT JOIN Country CR ON CR.IATACode=S.Country_IATACode              
LEFT JOIN CompanyMaster CM ON CM.CompanyID = HM.CompanyID                                                           
WHERE QXM.XOID =@XOID AND Q.YearID = @YearCode  --QXM.XOID = 'H16000032'                                                  
)AA                                        
group by AA.XOID,AA.FileCode,AA.NoOfPax,AA.Confirmed_By,AA.CustomerName,AA.RoomCategory,AA.XO_Date,AA.ItineraryDate                        
,AA.CheckOut,AA.XO_Instruction,AA.XO_Line_Desc,AA.InfoForXO,AA.BookingReferenceNumber,AA.SupplierReference,AA.MealPlanCode,AA.HotelName                        
,AA.ArrivalDate,AA.FromCity,AA.ArrivalBy,AA.DepartureDate,AA.ToCity,AA.DeptBy                        
,AA.FromTime,AA.ToTime,AA.UserName,AA.Address,AA.EmailID,AA.FaxNo,AA.PhoneNo,AA.ServiceDate,AA.HotelRateID,AA.GSTNID, AA.GSTAddress,AA.HotelVendorFlag,AA.QuotationID      
,AA.IsAgentCredit      
,AA.IsHotelCredit           
,AA.CompanyName , AA.MembershipNo, AA.MobileNo                                                    
ORDER BY --SeqNumber,                        
ServiceDate                            
END                                          
END                                            
END 
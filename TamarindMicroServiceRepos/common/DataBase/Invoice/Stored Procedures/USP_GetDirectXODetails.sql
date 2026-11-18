CREATE PROCEDURE [Invoice].[USP_GetDirectXODetails] --'S13000003',35--'H13023420'                                
@XOID varchar(20)=null,            
@YearID INT =null             
                         
AS                                
            
BEGIN         
 

                         
 -- SET NOCOUNT ON added to prevent extra result sets from                                
 -- interfering with SELECT statements.                                
 SET NOCOUNT ON;                                
 SELECT Q.QuotationID,            
 --Q.QuotationItemID,            
 XO.XO_ID,            
   
 HRMB.CurrencyID AS 'CostingCurrencyCode',            
 HM.AccCode,            
 HM.HotelName,            
 HM.HotelCode,
 hm.HotelSAPCode,            
 --case WHEN QS.IsVendorHotel=1 THEN VM.VendorSAPCode ELSE HM.HotelSAPCode end AS 'HotelSAPCode',            
 Q.CreatedDate AS  QuotationDate,            
 HRMB.CheckIn AS  TravelDateFrom,            
 HRMB.CheckIn AS TravelDateTo,                              
 B.FileCode,            
 B.CreatedBy AS OperationBy,            
 Q.YearID,            
 Q.CompanyID,            
 XOI.Confirmed_By,                          
 --ISNULL(HRD.SGLCommission,0) AS SGLCommission,            
 --ISNULL(HRD.DBLCommission,0) AS DBLCommission,            
 --HRM.IsDirectPayment,            
 --Q.CustomerName,  --added by afreen                        
 --QA.ItineraryDate                      
 --,HRM.IsBTCComm      
 --,ISNULL(HRD.BTCSComm,0) AS BTCSGLCommission,   --Jyoti @05Feb2019   
 --ISNULL(HRD.BTCDComm,0) AS BTCDBLCommission,     --Jyoti @05Feb2019    
  CM.CityIATACode  
 ,'' AS VendorID 
 ,'' AS VendorAccCode
 ,'' AS VendorName
 ,'' AS VendorCode 
 ,'' AS VendorSAPCode 
 ,CM.SAP_CompanyCode
 ,CM.CompCode  AS '3DigitCode'  
 ,CM.CompanyID AS 'SAPCompID'    
 FROM XO     

 
LEFT JOIN [Booking].tbl_Booking B ON  B.QuotationID = XO.Qut_ID  
LEFT JOIN Quotation.QuotationMaster Q ON Q.QuotationID = B.QuotationID  
LEFT JOIN [Booking].DayWiseBooking  DWB ON DWB.BookingID = B.BookingID 
LEFT JOIN Booking.HotelRateCardMasterBooking  HRMB ON DWB.BookingID = HRMB.BookingID 
LEFT JOIN Booking.HotelRateCommissionDetailsBooking  HRCB ON DWB.BookingID = HRCB.BookingID 
LEFT JOIN Booking.HotelRateMealPlanMasterBooking  HRPB ON DWB.BookingID = HRPB.BookingID 
LEFT JOIN  RateCommissionMaster RCM ON HRCB.RateCommisionID = RCM.CommMasterID 
LEFT JOIN RoomCategory RC ON RC.ID=HRMB.RoomCategoryID                                                         
LEFT JOIN MealPlan MP ON MP.ID = HRPB.MealTypeID                      
 LEFT JOIN dbo.HotelMaster HM ON HRMB.HotelID=HM.HotelID       
 --LEFT outer JOIN dbo.VendorMaster vm ON HRM.VendorID=vm.VendorID                       
LEFT OUTER JOIN XO_Instructions XOI ON XOI.XO_ID=XO.XO_ID       
LEFT JOIN CompanyMaster CM ON Q.CompanyID = CM.CompanyID                          
 WHERE XO.XO_ID=@XOID             
 ---AND QXOM.ServiceTypeID=1               
 AND Q.YearID=@YearID           
     
	 
--UNION                               
-- SELECT QXOM.QuotationID,            
-- QXOM.QuotationItemID,            
-- QXOM.XOID,            
-- QS.QuotationSpecialID AS 'AccomodationID',            
-- QS.CityCode,                         
-- QS.ServiceTypeID,            
-- SS.Name as 'ServiceName',            
-- QS.VendorHotelID AS 'HotelID',            
-- cast(0 AS INT) AS 'RoomCategoryID',                              
-- QS.NoOfConsolidatedUnit AS 'SingleRoomQty',            
-- QS.ConsolidatedUnitCost AS 'SingleRoomCost',            
-- cast(0 AS INT) AS 'DoubleRoomQty',            
-- cast(0 AS DECIMAL) AS 'DoubeRoomCost',            
-- cast(0 AS INT) AS 'TwinSharingQty',            
-- cast(0 AS DECIMAL) AS 'TwinSharingCost',            
-- cast(0 AS INT) AS 'ExtraAdults',            
-- cast(0 AS DECIMAL) AS 'ExtraAdultCost',            
-- cast(0 AS INT) AS 'ExtraChild',            
-- cast(0 AS DECIMAL) AS 'ExtraChildCost',            
-- cast(0 AS BIT) AS 'BreakfastIncluded',                                
--cast(0 AS DECIMAL) AS 'BreakfastCost',            
-- cast(0 AS BIT) AS 'LunchIncluded',            
-- cast(0 AS DECIMAL) AS 'LunchCost',            
-- cast(0 AS BIT) AS 'DinnerIncluded',              
-- cast(0 AS DECIMAL) AS 'DinnerCost',            
-- QS.SpecialSubTotal AS 'AccomodationSubTotal',            
-- cast(0 AS DECIMAL) AS 'MealsSubTotal',            
-- QS.Remarks,            
-- cast(0 AS INT) AS 'RoomAllocationID',            
-- cast(0 AS INT) AS 'NoofAllocation',            
-- QS.OldID,            
-- --Q.CostingCurrencyCode,         
-- SSRM.CurrencyID AS 'CostingCurrencyCode',           
-- case WHEN QS.IsVendorHotel=1 THEN VM.AccCode ELSE HM.AccCode END AS 'AccCode',            
-- case WHEN QS.IsVendorHotel=1 THEN VM.VendorName ELSE HM.HotelName end AS 'HotelName',            
-- case WHEN QS.IsVendorHotel=1 THEN VM.VendorCode ELSE HM.HotelCode end AS 'HotelCode',            
-- case WHEN QS.IsVendorHotel=1 THEN VM.VendorSAPCode ELSE HM.HotelSAPCode end AS 'HotelSAPCode',            
-- Q.QuotationDate,            
-- Q.TravelDateFrom,            
-- Q.TravelDateTo,                            
-- Q.FileCode,            
-- Q.OperationBy,            
-- Q.YearID,            
-- Q.CompanyID,            
-- XOI.Confirmed_By,                          
-- ISNULL(SSRD.ConsolidatedCommission,0) AS SGLCommission,            
-- cast(0 AS DECIMAL) AS 'DBLCommission',            
-- SSRM.IsDirectPayment,            
-- Q.CustomerName,  --added by afreen                        
-- QS.ItineraryDate,         
--  0,0,0    --Jyoti @05Feb2019      
-- ,CM.CityIATACode  
-- ,'' as VendorID      
-- ,'' as VendorAccCode
-- ,'' as VendorName
-- ,'' as VendorCode 
-- ,'' as VendorSAPCode     
--  ,CM.SAP_CompanyCode
-- ,CM.CompCode  AS '3DigitCode'  
--  ,CM.CompanyID AS 'SAPCompID'  
-- FROM dbo.QuotationXOMap QXOM                                
-- JOIN dbo.Quotation_Special QS ON QXOM.QuotationItemID=QuotationSpecialID             
-- JOIN dbo.Quotation Q ON QS.QuotationID=Q.QuotationID                                
-- left JOIN dbo.VendorMaster VM ON QS.VendorHotelID=VM.VendorID  and QS.IsVendorHotel=1 --and QXOM.ServiceTypeID=4      
--left  JOIN dbo.HotelMaster HM ON  QS.VendorHotelID=HM.HotelID and QS.IsVendorHotel=2 --and QXOM.ServiceTypeID=1              
-- JOIN SpecialServices SS ON QS.SpecialServiceID=SS.ID                           
-- JOIN SpecialServiceRateDetails SSRD ON QS.RateDetailsID=SSRD.SpecialServiceRateDetailsID                         
-- JOIN SpecialServiceRateMaster SSRM ON SSRD.SpecialServiceRateID=SSRM.SpecialServiceRateID                
-- LEFT OUTER JOIN XO_Instructions XOI ON XOI.XO_ID=QXOM.XOID       
-- LEFT JOIN CompanyMaster CM ON Q.CompanyID = CM.CompanyID                           
-- WHERE XOID=@XOID              
-- AND QXOM.ServiceTypeID=4 --4 for Quotation Special            
-- AND Q.YearID=CASE WHEN @YearID  IS NOT NULL THEN @YearID ELSE Q.YearID END           
            
--order by ItineraryDate             
                          
END
CREATE procedure [dbo].[USP_GetCPPReportData_ACCOM_NEW]                                
 @dtFromdate datetime ,                                
 @dtTodate datetime ,                                
 @reportType nvarchar(20),                        
 @YearCode INT = 0          
                   
as                                
begin                                
 if(@reportType = 'SSDR')                                
 begin                           
      select   replace(convert(varchar(11),Itinerarydate,106),' ','-')  as SplServiceDate         
      ,C.name as SvcCityName        
      ,SS.Name as SplSvcName        
      , case when qs.isvendorhotel = 1 then 'V' else 'H' end as SupplierType        
      ,case when Qs.isvendorhotel = 1 then VM.Vendorname else HM.Hotelname end as SupplierName,        
      NoofAdult,NoOfChild,NoOfConsolidatedUnit as NoOfConUnit,        
      Currencyid as RateCardCurr,SSC.Adult as RCAdultAmt,SSC.Child as RCChildAmt,        
      SSC.Consolidated as RCUnitAmt         
      ,QXM.XOID as XoNumber , X.amtininr as XoAmtInINR ,Q.Filecode --,U.UserName as FHE   
      ,N.Headerinfo_Nationality as Guests_Nationality    
      from Quotation_Special QS WITH (NOLOCK)       
      left join specialservices SS WITH (NOLOCK) on QS.specialserviceid = ss.ID        
      left join vendormaster VM WITH (NOLOCK)on QS.VendorHotelID = VM.Vendorid        
      left join Hotelmaster HM WITH (NOLOCK)on QS.VendorHotelID = HM.Hotelid        
      left join specialserviceratedetails SSC WITH (NOLOCK) on QS.Ratedetailsid = SSC.specialserviceratedetailsid        
      left join specialserviceratemaster SSCM WITH (NOLOCK) on SSC.specialservicerateid = SSCM.specialservicerateid        
      left join quotation Q WITH (NOLOCK) on Q.quotationid = QS.quotationid        
       LEFT JOIN QuotationXOMap QXM WITH (NOLOCK) ON QXM.QuotationID = QS.QuotationID AND QXM.QuotationItemID = QS.QuotationSpecialID                       
           AND QXM.ServiceTypeID = QS.ServiceTypeID         
      LEFT JOIN XO X WITH (NOLOCK) ON Q.QuotationID =QXM.QuotationID AND (undo=0 or undo is null) and QXM.xoid = x.xo_id           
      left join city C WITH (NOLOCK) on qs.citycode = c.IATACode        
     -- left Join aspnet_Users U WITH (NOLOCK) ON Q.OperationBy = U.UserId     
      LEFT JOIN Nationality N ON Q.Guests_Nationality   =N.Nationality    
      where Itinerarydate between @dtFromdate and  @dtTodate      
      order by Itinerarydate desc               
         
 end        
    if(@reportType = 'MSRD')                                
 begin         
 --DECLARE @dtFromdate datetime                                 
 --DECLARE @dtTodate datetime      
 --set @dtFromdate = '2017-11-16'    
 --set @dtTodate = '2017-11-30'                      
        
 SELECT  MRM.MonumentCardNo AS 'CardNo', MRD.MonumentRateDetailsID AS 'RateDetailsID', MRM.Heading AS 'ContractHeading',            
 C.Name as 'City', MS.Name AS 'MonumentService',      
 CASE WHEN MRM.RateCardMode=1 THEN 'Contract'                          
 WHEN MRM.RateCardMode=2 THEN 'Adhoc'          
 WHEN MRM.RateCardMode=3 THEN 'Negotiated' END AS 'RateMode', VM.VendorName as 'Vendor', N.Nationality AS 'Nationality',     
 replace(convert(varchar(11),MRD.RateValidFrom,106),' ','-') AS 'ValidFrom', REPLACE(CONVERT(varchar(11),MRD.RateValidTo,106),' ','-') AS 'ValidTo',    
 MRM.CurrencyID AS 'Curr', MRD.AdultRate AS 'AdultRate', MRD.ChildRate As 'ChildRate', MRD.MISSequenceNo AS 'MIS',     
 CASE WHEN MRM.IsActive=1 THEN 'YES' ELSE 'NO'  END AS 'Active', MRM.InfoForXO AS 'XoRemark', MRM.InfoForOps AS 'InfoForOps', MRM.OperationOn as 'OperationOn'    
    
           
 FROM MonumentRateMaster MRM            
  LEFT JOIN City C ON MRM.CityIATACode=C.IATACode                           
  LEFT JOIN VendorMaster VM ON MRM.VendorID=VM.VendorID                    
  LEFT JOIN Currency CR ON MRM.CurrencyID=CR.Code          
  LEFT JOIN MonumentService  MS ON  MS.ID=MRM.MonumentID       
  FULL JOIN MonumentRateDetails MRD ON MRM.MonumentRateID=MRD.MonumentRateID    
  LEFT JOIN Nationality N ON MRD.NationalityID=N.ID    
    
  Where MRM.RateCardMode=1 and CAST(MRD.RateValidFrom AS date) >=  cast(@dtFromdate as Date)    
  and CAST(MRD.RateValidTo AS date) <=  cast(@dtTodate as Date)     
  --ORDER BY MRM.OperationOn DESC    
 UNION    
    
 SELECT  MRM.MonumentCardNo AS 'CardNo', MRD.MonumentRateDetailsID AS 'RateDetailsID', MRM.Heading AS 'ContractHeading',            
 C.Name as 'City', MS.Name AS 'MonumentService',      
 CASE WHEN MRM.RateCardMode=1 THEN 'Contract'                          
 WHEN MRM.RateCardMode=2 THEN 'Adhoc'          
 WHEN MRM.RateCardMode=3 THEN 'Negotiated' END AS 'RateMode', VM.VendorName as 'Vendor', N.Nationality AS 'Nationality',     
 replace(convert(varchar(11),MRD.RateValidFrom,106),' ','-') AS 'ValidFrom', REPLACE(CONVERT(varchar(11),MRD.RateValidTo,106),' ','-') AS 'ValidTo',    
 MRM.CurrencyID AS 'Curr', MRD.AdultRate AS 'AdultRate', MRD.ChildRate As 'ChildRate', MRD.MISSequenceNo AS 'MIS',     
 CASE WHEN MRM.IsActive=1 THEN 'YES' ELSE 'NO'  END AS 'Active', MRM.InfoForXO AS 'XoRemark', MRM.InfoForOps AS 'InfoForOps', MRM.OperationOn as 'OperationOn'    
    
           
 FROM MonumentRateMaster MRM            
  LEFT JOIN City C ON MRM.CityIATACode=C.IATACode                           
  LEFT JOIN VendorMaster VM ON MRM.VendorID=VM.VendorID                    
  LEFT JOIN Currency CR ON MRM.CurrencyID=CR.Code              
  LEFT JOIN MonumentService  MS ON  MS.ID=MRM.MonumentID       
  FULL JOIN MonumentRateDetails MRD ON MRM.MonumentRateID=MRD.MonumentRateID    
  LEFT JOIN Nationality N ON MRD.NationalityID=N.ID    
    
  WHERE MRM.RateCardMode=1 and  CAST(@dtFromdate as Date) between CAST(MRD.RateValidFrom AS date) AND CAST(MRD.RateValidTo AS date)    
  and     
  cast(@dtTodate as Date) between CAST(MRD.RateValidFrom AS date) AND CAST(MRD.RateValidTo AS date)    
  ORDER BY MRM.OperationOn DESC    
      
    
 end    
    
  if(@reportType = 'SSRD')                                
  begin                           
    
--DECLARE @dtFromdate datetime                                 
--DECLARE @dtTodate datetime      
-- set @dtFromdate = '2017-11-16'    
-- set @dtTodate = '2017-11-30'    
    
SELECT  SSRM.SpecialCardNo AS 'CardNo', SSRD.SpecialServiceRateDetailsID AS 'RateDetailsID',     
SSRM.Heading AS 'ContractHeading', C.Name AS 'City',     
S.Name AS 'SpecialService', CASE WHEN SSRM.RateCardMode=1 THEN 'Contract'           
WHEN SSRM.RateCardMode=2 Then 'Adhoc' WHEN SSRM.RateCardMode=3 Then 'Negotiated' END AS 'RateMode',     
CASE WHEN IsVendorHotel=1 THEN VM.VendorName ELSE HM.HotelName END AS 'Vendor',     
N.Nationality AS 'Nationality', SSRD.PaxFrom AS 'FromPax', SSRD.PaxTo AS 'ToPax',     
replace(convert(varchar(11), SSRD.RateValidFrom,106),' ','-') AS 'ValidFrom',    
replace(convert(varchar(11),SSRD.RateValidTo,106),' ','-') AS 'ValidTo',     
SSRM.CurrencyID AS 'Curr', SSRD.Adult AS 'AdultRate', SSRD.Child AS 'ChildRate', SSRD.Consolidated AS 'UnitRate',     
SSRD.MisSequenceNo AS 'MIS', CASE WHEN SSRM.IsActive=1 THEN 'YES' ELSE 'NO'  END AS 'Active',     
SSRM.InfoForXo As 'XoRemark',SSRM.InfoForOps AS 'InfoForOps', SSRM.OperationOn as 'OperationOn'    
    
FROM SpecialServiceRateMaster SSRM    
INNER JOIN City C    
ON SSRM.CityIATACode=C.IATACode          
INNER JOIN SpecialServices S    
ON SSRM.SpecialServiceID=S.ID    
LEFT JOIN SpecialServiceRateDetails SSRD    
ON SSRM.SpecialServiceRateID=SSRD.SpecialServiceRateID    
LEFT JOIN Nationality N     
ON SSRD.NationalityID=N.ID    
FULL JOIN VendorMaster VM     
ON VM.vendorID=SSRM.VendorHotelID AND IsVendorHotel=1        
LEFT JOIN HotelMaster HM ON HM.HotelId=SSRM.VendorHotelID AND IsVendorHotel=2      
                
WHERE SSRM.RateCardMode=1 and CAST(SSRD.RateValidFrom AS date) >=  cast(@dtFromdate as Date)    
and CAST(SSRD.RateValidTo AS date) <=  cast(@dtTodate as Date)     
--ORDER BY SSRM.OperationOn DESC    
    
union    
    
SELECT  SSRM.SpecialCardNo AS 'CardNo', SSRD.SpecialServiceRateDetailsID AS 'RateDetailsID',     
SSRM.Heading AS 'ContractHeading', C.Name AS 'City',     
S.Name AS 'SpecialService', CASE WHEN SSRM.RateCardMode=1 THEN 'Contract'           
WHEN SSRM.RateCardMode=2 Then 'Adhoc' WHEN SSRM.RateCardMode=3 Then 'Negotiated' END AS 'RateMode',     
CASE WHEN IsVendorHotel=1 THEN VM.VendorName ELSE HM.HotelName END AS 'Vendor',     
N.Nationality AS 'Nationality', SSRD.PaxFrom AS 'FromPax', SSRD.PaxTo AS 'ToPax',     
replace(convert(varchar(11), SSRD.RateValidFrom,106),' ','-') AS 'ValidFrom',    
replace(convert(varchar(11),SSRD.RateValidTo,106),' ','-') AS 'ValidTo',     
SSRM.CurrencyID AS 'Curr', SSRD.Adult AS 'AdultRate', SSRD.Child AS 'ChildRate', SSRD.Consolidated AS 'UnitRate',     
SSRD.MisSequenceNo AS 'MIS', CASE WHEN SSRM.IsActive=1 THEN 'YES' ELSE 'NO'  END AS 'Active',     
SSRM.InfoForXo As 'XoRemark',SSRM.InfoForOps AS 'InfoForOps', SSRM.OperationOn as 'OperationOn'    
    
FROM SpecialServiceRateMaster SSRM    
INNER JOIN City C    
ON SSRM.CityIATACode=C.IATACode          
INNER JOIN SpecialServices S    
ON SSRM.SpecialServiceID=S.ID    
LEFT JOIN SpecialServiceRateDetails SSRD    
ON SSRM.SpecialServiceRateID=SSRD.SpecialServiceRateID    
LEFT JOIN Nationality N     
ON SSRD.NationalityID=N.ID    
FULL JOIN VendorMaster VM     
ON VM.vendorID=SSRM.VendorHotelID AND IsVendorHotel=1        
LEFT JOIN HotelMaster HM ON HM.HotelId=SSRM.VendorHotelID AND IsVendorHotel=2      
    
 WHERE SSRM.RateCardMode=1 and  CAST(@dtFromdate as Date) between CAST(SSRD.RateValidFrom AS date) AND CAST(SSRD.RateValidTo AS date)    
 and     
 cast(@dtTodate as Date) between CAST(SSRD.RateValidFrom AS date) AND CAST(SSRD.RateValidTo AS date)    
 ORDER BY SSRM.OperationOn DESC    
      
 end       
  if(@reportType = 'GSRD')                                
 begin         
 --DECLARE @dtFromdate datetime                                 
 --DECLARE @dtTodate datetime      
 --set @dtFromdate = '2017-11-16'    
 --set @dtTodate = '2017-11-30'    
                       
      SELECT GRM.GuideCardNo AS 'CardNo', GRD.GuideRateDetailsID AS 'RateDetailsID', GRM.Heading AS 'ContractHeading',  C.Name AS 'City',     
 G.Name AS 'GuideService', CASE WHEN GRM.RateCardMode=1 THEN 'Contract'     
 WHEN GRM.RateCardMode=2 Then 'Adhoc' WHEN GRM.RateCardMode=3 Then 'Negotiated' END  AS 'RateMode',L.Language AS 'Language',    VM.VendorName AS 'Vendor',     
GRD.PaxFrom AS 'FromPax',GRD.PaxTo AS 'ToPax', replace(convert(varchar(11),GRD.RateValidFrom,106),' ','-') AS 'ValidFrom',         
replace(convert(varchar(11),GRD.RateValidTo,106),' ','-') AS 'ValidTo', GRM.CurrencyID AS 'Curr', GRD.Amount AS 'Rate',     
GRD.MISSequenceNo AS 'MIS', CASE WHEN GRM.IsActive=1 THEN 'YES' ELSE 'NO'  END AS 'Active', GRM.InfoForXo AS 'XoRemark',     
GRM.InfoForOps AS 'InfoForOps', GRM.OperationOn as 'OperationOn'    
    
   FROM GuideRateMaster GRM    
   INNER JOIN City C    
   ON GRM.CityIATACode=C.IATACode    
   LEFT JOIN GuideRateDetails GRD    
   ON GRM.GuideRateID=GRD.GuideRateID    
   LEFT JOIN GuideServices G    
   ON GRM.GuideCode=G.Code    
   LEFT JOIN VendorMaster VM    
   ON GRM.VendorID=VM.VendorID    
   LEFT JOIN Language L    
   ON GRM.LanguageID=L.ID    
    
 WHERE GRM.RateCardMode=1 and CAST(GRD.RateValidFrom AS date) >=  cast(@dtFromdate as Date)    
 and CAST(GRD.RateValidTo AS date) <=  cast(@dtTodate as Date)     
 --ORDER BY GRM.OperationOn DESC    
    
 union    
     
 SELECT GRM.GuideCardNo AS 'CardNo', GRD.GuideRateDetailsID AS 'RateDetailsID', GRM.Heading AS 'ContractHeading',  C.Name AS 'City',     
 G.Name AS 'GuideService', CASE WHEN GRM.RateCardMode=1 THEN 'Contract'     
 WHEN GRM.RateCardMode=2 Then 'Adhoc' WHEN GRM.RateCardMode=3 Then 'Negotiated' END  AS 'RateMode',L.Language AS 'Language',    VM.VendorName AS 'Vendor',     
GRD.PaxFrom AS 'FromPax',GRD.PaxTo AS 'ToPax', replace(convert(varchar(11),GRD.RateValidFrom,106),' ','-') AS 'ValidFrom',         
replace(convert(varchar(11),GRD.RateValidTo,106),' ','-') AS 'ValidTo', GRM.CurrencyID AS 'Curr', GRD.Amount AS 'Rate',     
GRD.MISSequenceNo AS 'MIS', CASE WHEN GRM.IsActive=1 THEN 'YES' ELSE 'NO'  END AS 'Active', GRM.InfoForXo AS 'XoRemark',   GRM.InfoForOps AS 'InfoForOps', GRM.OperationOn as 'OperationOn'    
    
   FROM GuideRateMaster GRM    
   INNER JOIN City C    
   ON GRM.CityIATACode=C.IATACode    
   LEFT JOIN GuideRateDetails GRD    
   ON GRM.GuideRateID=GRD.GuideRateID    
   LEFT JOIN GuideServices G    
   ON GRM.GuideCode=G.Code    
   LEFT JOIN VendorMaster VM    
   ON GRM.VendorID=VM.VendorID    
   LEFT JOIN Language L    
   ON GRM.LanguageID=L.ID    
    
 WHERE GRM.RateCardMode=1 and  CAST(@dtFromdate as Date) between CAST(GRD.RateValidFrom AS date) AND CAST(GRD.RateValidTo AS date)    
  and     
  cast(@dtTodate as Date) between CAST(GRD.RateValidFrom AS date) AND CAST(GRD.RateValidTo AS date)    
  ORDER BY GRM.OperationOn DESC    
     
 end    
     
     
 if(@reportType='ADR')    
 begin    
      
  SELECT QA.AccomodationID AS 'AccomodationID', QA.QuotationID AS 'QuotationID', replace(convert(varchar(11),QA.ItineraryDate,106),' ','-') AS 'Date',     
 QA.RateDetailsID AS 'RateDetailsID', CN.Name AS 'Country', CT.Name AS 'CityName', HG.Name AS 'GroupName', HM.HotelName AS 'HotelName',     
 RC.Name AS 'RoomCategoryName', HRM.CurrencyID AS 'RateCardCurr', QA.SingleRoomQty AS 'SingleRoomQty', QA.SingleRoomCost AS 'SingleRoomCost', QA.DoubleRoomQty AS 'DoubleRoomQty', QA.DoubeRoomCost AS 'DoubeRoomCost',     
 QA.TwinSharingQty AS 'TwinSharingQty',  QA.TwinSharingCost AS 'TwinSharingCost', QA.ExtraAdults AS 'ExtraAdults', QA.ExtraAdultCost AS 'ExtraAdultCost', QA.ExtraChild AS 'ExtraChild', QA.ExtraChildCost AS 'ExtraChildCost',      
 QA.BreakfastIncluded AS 'BreakfastIncluded', QA.BreakfastCost AS 'BreakfastCost', QA.LunchIncluded AS 'LunchIncluded', QA.LunchCost AS 'LunchCost', QA.DinnerIncluded AS 'DinnerIncluded',  QA.DinnerCost AS 'DinnerCost',     
 QXM.XOID AS 'XO ID', Q.FileCode AS 'FileCode' --U.UserName AS 'FHE'    
   ,N.Headerinfo_Nationality as Guests_Nationality     
  FROM Quotation_accomodation QA     
  LEFT JOIN HotelMaster HM ON QA.HotelID=HM.HotelID    
  LEFT JOIN CITY CT ON QA.CityCode=CT.IATACode    
  LEFT JOIN HotelGroups HG ON HM.ChainIATACode=HG.IATACode    
  LEFT JOIN RoomCategory RC ON QA.RoomCategoryID=RC.ID    
  LEFT JOIN Quotation Q ON QA.QuotationID=Q.QuotationID     
  LEFT JOIN QuotationXOMap QXM ON QXM.QuotationID = QA.QuotationID AND QXM.QuotationItemID = QA.AccomodationID                       
           AND QXM.ServiceTypeID = QA.ServiceTypeID       
 -- LEFT JOIN aspnet_Users U ON Q.OperationBy = U.UserId      
  LEFT JOIN HotelRateDetails HRD on QA.RateDetailsID = HRD.HotelRateDetailsID        
  LEFT JOIN HotelRateMaster HRM on HRD.HotelRateID = HRM.HotelRateID     
  LEFT JOIN State S ON CT.State_IATACode=S.State_ID    
  LEFT JOIN Country CN  ON S.Country_IATACode=CN.IATACode    
   LEFT JOIN Nationality N ON Q.Guests_Nationality   =N.Nationality    
  WHERE CAST(QA.ItineraryDate AS date) >=  cast( @dtFromdate as Date)    
 and CAST(QA.ItineraryDate AS date) <=  cast(@dtTodate as Date) and QXM.XOID is not null    
 ORDER BY QA.ItineraryDate     
    
     
  --WHERE QA.Itinerarydate between @dtFromdate and  @dtTodate and QXM.XOID is not null    
  --order by QA.itinerarydate DESC     
       
    
 end    
end




    
CREATE PROCEDURE [dbo].[usp_SearchHotelRate] --1,0,'1','2',NULL,null,null,NULL,null,null,NULL,NULL,null,null,NULL,null,null,null,null,NULL,NULL                                                                          
(                                                                                            
@FIT     int   = Null,                                                                                          
@GIT     int   = Null,                                                                                          
@Contract    int   = NULL,                                                                                          
@Adhoc     int   = NULL,                                                                                            
@Negotiated    int   = Null,                                                                                            
@ALL_B2B    int   = null,                                                                                            
@Nett_Markedup    int   = null,                                                                                            
@Vendor     int   = Null ,                                                                                          
@City     varchar(5) ,                                                                                          
@Hotel     int   = Null,                                                                                          
@RatingFrom    int   = Null,                                                                                          
@RatingTo    int   = Null,                                                                                          
@MIS     int   = Null,                                                                                          
@Currency    varchar(5) = Null,                                                                                          
@Market     int   = Null,                                                                                          
@AgentCity  varchar(5) = Null,                                                                                          
@AgentCategory   int   = Null,                                                                                          
@AgentName    varchar(200)= Null,                              
@ValidFrom     Datetime = null,                                                                         
@ValidTo     Datetime = null,                                       
@AgentID  INT=NULL,                                                                          
@CategoryID  INT=NULL,                                  
@IsDirectPayment Bit=0, --Added By Sagar                                                                              
@ISHotelPreferred BIT=0                          
)                                                                                            
AS                                  
BEGIN                                                                                            
                                                              
DECLARE @RatingFromMIS INT=NULL                                                                        
DECLARE @RatingToMIS INT=NULL                                                                                           
SET @RatingFromMIS=(Select MISSequence FROM  HotelRating Where ID=@RatingFrom)                                                                                              
SET @RatingToMIS=(Select MISSequence FROM  HotelRating Where ID=@RatingTo)                                                                                             
                                                                                          
IF(@ALL_B2B=1)--For All Rates                                                                                          
 BEGIN                                                                                          
   if(@Nett_Markedup=1)--For Net Rates                                                     
   BEGIN                           
  SELECT * FROM (                          
                             
    SELECT F.HotelID,F.HotelRateID,F.City,HotelName,InfoForOps,MP.Code [MealPlan],TP.taxValue [Tax_Per],                                                         
    CASE F.DaysText WHEN '1234567' THEN 'ALL' ELSE  F.DaysText                                                     
    END as [DaysText] ,                                                                                   
    ValidFrom,ValidTo,--F.DaysText,                                                             
    FIT,GIT,F.FIT_GIT,ShowOnline, (CAST(F.MinNights AS VARCHAR(5))+ ' - ' + CAST(F.MaxNights AS VARCHAR(5))) AS MinMax, --Added By Sagar 08 July                                                   
    --sanket                                                  
    --dbo.fnSearchCalculateROE(SGL,@ValidFrom,@Currency,CurrencyID) AS S_SGL,      
        
    CASE when (F.BTCSComm != null or F.BTCSComm != '0.00') OR (F.SGLCommission != null or F.SGLCommission != '0.00') then     
    CASE                                                     
    WHEN CAST(CAST(dbo.fnSearchCalculateROE(F.SGLNett,@ValidFrom,@Currency,CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20))='-101' THEN 'NA'           
    ELSE CAST(CAST(dbo.fnSearchCalculateROE(F.SGLNett,@ValidFrom,@Currency,CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20))          
    END     
    else      
    CASE                                                     
    WHEN CAST(CAST(dbo.fnSearchCalculateROE(SGL,@ValidFrom,@Currency,CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20))='-101' THEN 'NA'           
    ELSE CAST(CAST(dbo.fnSearchCalculateROE(SGL,@ValidFrom,@Currency,CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20))          
    END    
    end  as 'SGL',     
    CASE when (F.BTCDComm != null or F.BTCDComm != '0.00') OR (F.DBLCommission != null or F.DBLCommission != '0.00') then     
    CASE                                                     
    WHEN CAST(CAST(dbo.fnSearchCalculateROE(F.DBLNett,@ValidFrom,@Currency,CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20))='-101' THEN 'NA'           
    ELSE CAST(CAST(dbo.fnSearchCalculateROE(F.DBLNett,@ValidFrom,@Currency,CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20))          
    END     
    else      
    CASE                                                     
    WHEN CAST(CAST(dbo.fnSearchCalculateROE(DBL,@ValidFrom,@Currency,CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20))='-101' THEN 'NA'           
    ELSE CAST(CAST(dbo.fnSearchCalculateROE(DBL,@ValidFrom,@Currency,CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20))          
    END    
    end  as 'DBL',     
                                                        
    ----CASE                                                     
    ----WHEN CAST(CAST(dbo.fnSearchCalculateROE(SGL,@ValidFrom,@Currency,CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20))='-101' THEN 'NA'           
    ----ELSE CAST(CAST(dbo.fnSearchCalculateROE(SGL,@ValidFrom,@Currency,CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20))          
    ----END AS SGL,          
              
    ----CASE                                                     
    ----WHEN CAST(CAST(dbo.fnSearchCalculateROE(DBL,@ValidFrom,@Currency,CurrencyID)AS NUMERIC(18,0)) AS VARCHAR(20))='-101' THEN 'NA'           
    ----ELSE CAST(CAST(dbo.fnSearchCalculateROE(DBL,@ValidFrom,@Currency,CurrencyID)AS NUMERIC(18,0)) AS VARCHAR(20))           
    ----END AS DBL,                                                             
    --ExtraBedAdult,ExtraBedChild,           
    CASE                                                     
    WHEN CAST(CAST(dbo.fnSearchCalculateROE(F.Breakfast,@ValidFrom,@Currency,CurrencyID)AS NUMERIC(18,0)) AS VARCHAR(20)) ='-101' THEN 'NA'          
    WHEN CAST(CAST(dbo.fnSearchCalculateROE(F.Breakfast,@ValidFrom,@Currency,CurrencyID)AS NUMERIC(18,0)) AS VARCHAR(20)) ='-1' THEN 'INCL'          
    WHEN CAST(CAST(dbo.fnSearchCalculateROE(F.Breakfast,@ValidFrom,@Currency,CurrencyID)AS NUMERIC(18,0)) AS VARCHAR(20)) ='' THEN '-'          
    ELSE          
    CAST(CAST(dbo.fnSearchCalculateROE(F.Breakfast,@ValidFrom,@Currency,CurrencyID)AS NUMERIC(18,0)) AS VARCHAR(20))          
    END AS Breakfast,            
            
    CASE           
    WHEN CAST(CAST(dbo.fnSearchCalculateROE(F.Lunch,@ValidFrom,@Currency,CurrencyID)AS NUMERIC(18,0)) AS VARCHAR(20))='-101' THEN 'NA'           
    WHEN CAST(CAST(dbo.fnSearchCalculateROE(F.Lunch,@ValidFrom,@Currency,CurrencyID)AS NUMERIC(18,0)) AS VARCHAR(20))='-1' THEN 'INCL'           
    WHEN CAST(CAST(dbo.fnSearchCalculateROE(F.Lunch,@ValidFrom,@Currency,CurrencyID)AS NUMERIC(18,0)) AS VARCHAR(20))='' THEN '-'           
    ELSE CAST(CAST(dbo.fnSearchCalculateROE(F.Lunch,@ValidFrom,@Currency,CurrencyID)AS NUMERIC(18,0)) AS VARCHAR(20))          
    END AS Lunch,          
                                                                       
    CASE                                                                
    WHEN CAST(CAST(dbo.fnSearchCalculateROE(F.Dinner,@ValidFrom,@Currency,CurrencyID)AS NUMERIC(18,0)) AS VARCHAR  (20))='-101' THEN 'NA'           
    WHEN CAST(CAST(dbo.fnSearchCalculateROE(F.Dinner,@ValidFrom,@Currency,CurrencyID)AS NUMERIC(18,0)) AS VARCHAR  (20))='-1' THEN 'INCL'           
    WHEN CAST(CAST(dbo.fnSearchCalculateROE(F.Dinner,@ValidFrom,@Currency,CurrencyID)AS NUMERIC(18,0)) AS VARCHAR  (20))='' THEN '-'           
    ELSE CAST(CAST(dbo.fnSearchCalculateROE(F.Dinner,@ValidFrom,@Currency,CurrencyID)AS NUMERIC(18,0)) AS VARCHAR  (20))          
    END AS Dinner,          
                                                                          
    CASE                                                                
    WHEN CAST(CAST(dbo.fnSearchCalculateROE(F.AdultExtra,@ValidFrom,@Currency,CurrencyID)AS NUMERIC(18,0)) AS   VARCHAR(20)) ='-101' THEN 'NA'           
    WHEN CAST(CAST(dbo.fnSearchCalculateROE(F.AdultExtra,@ValidFrom,@Currency,CurrencyID)AS NUMERIC(18,0)) AS   VARCHAR(20)) ='-1' THEN 'NA'          
     WHEN CAST(CAST(dbo.fnSearchCalculateROE(F.AdultExtra,@ValidFrom,@Currency,CurrencyID)AS NUMERIC(18,0)) AS   VARCHAR(20)) ='' THEN '-'          
    ELSE CAST(CAST(dbo.fnSearchCalculateROE(F.AdultExtra,@ValidFrom,@Currency,CurrencyID)AS NUMERIC(18,0)) AS   VARCHAR(20))          
    END AS AdultExtra,            
              
                                                                          
    CASE                                                                
    WHEN CAST(CAST(dbo.fnSearchCalculateROE(F.ChildExtra,@ValidFrom,@Currency,CurrencyID)AS NUMERIC(18,0)) AS   VARCHAR(20))  ='-101' THEN 'NA'           
    WHEN CAST(CAST(dbo.fnSearchCalculateROE(F.ChildExtra,@ValidFrom,@Currency,CurrencyID)AS NUMERIC(18,0)) AS   VARCHAR(20))  ='-1' THEN 'NA'           
    WHEN CAST(CAST(dbo.fnSearchCalculateROE(F.ChildExtra,@ValidFrom,@Currency,CurrencyID)AS NUMERIC(18,0)) AS   VARCHAR(20))  ='' THEN '-'           
    ELSE CAST(CAST(dbo.fnSearchCalculateROE(F.ChildExtra,@ValidFrom,@Currency,CurrencyID)AS NUMERIC(18,0)) AS   VARCHAR(20))          
    END AS ChildExtra,           
              
                                                                         
    XORemarks,F.HotelRateDetailsID,F.Rating,F.TransferCode [Transfer],F.RoomCategory,                                                                                         
    dbo.fnGetRateType(F.HotelRateID) [Rate Sheet],                                                                                          
    @AgentCategory [CategoryID],@Currency [Currency],CardNo,f.MISSequenceNo,                    
    F.RateCardMode,                                                  
  case when (select COUNT(HA.AnnouncementID) from HotelAnnouncement HA where HA.HotelID=F.HotelID AND AnnouncementDetails<>'')>=1  then 'true' else 'false' end AS ISHotelAnnouncement,                              
  --(select AnnouncementDetails from HotelAnnouncement HA where HA.HotelID=F.HotelID) AS AnnouncementDetails              
--above commemted by sanket and below added by sanket              
   (SELECT  SUBSTRING((SELECT distinct '|  ' + AnnouncementDetails FROM HotelAnnouncement HA where HA.HotelID=F.HotelID and ISNULL(HA.AnnouncementDetails,'')<>''  AND CONVERT(VARCHAR(12),HA.ValidTo,112)>=CONVERT(VARCHAR(12),GETDATE(),112)                 
 
    
     
     FOR XML PATH('')), 2,10000) )  AS AnnouncementDetails                
              
                
  ,                                               
  case when (select COUNT(HP.HotelID) from HotelPreferred HP where HP.HotelID=F.HotelID)>=1 then 'true' else 'false' end AS ISHotelPreferred,                                                
  CASE WHEN isnull(ValueAddOn,'') <> '' THEN ValueAddOn ELSE '-1' END AS ValueAddOn   ,F.RoomCategoryID ,F.HRating,                                  
  F.IsDirectPayment,F.SGLCommission, F.DBLCommission ,F.IsSplit,                          
  HoteRatingSequence, RateDetailSequence, F.HotelRateID AS HotelRateID1                    
  ,F.IsEOB,F.IsPayStay   --added by sanket @ 22/07/2014            
  ,F.TaxPerc                     
  ,case when F.IsEOB=1 then 'Early Bird Offer'                   
     when F.IsPayStay=1 then 'Pay Stay'                   
     else ''                        
     END AS OfferText     
   ,F.BTCSComm,F.BTCDComm,F.SGLNett,F.DBLNett     
    , Case when F.BTCSComm = null or F.BTCSComm ='0.00' then '' else  F.BTCSCommTIP end  as BTCSCommTIP    
    , case when F.BTCDComm = null or F.BTCDComm = '0.00' then '' else  F.BTCDCommTIP end  as BTCDCommTIP     
    , case when (F.BTCDComm = null or F.BTCDComm = '0.00' AND F.BTCSComm = null or F.BTCSComm ='0.00') then '' else  CONVERT(Varchar(50), F.BTCSCommTIP) + ' , ' + CONVERT(Varchar(50), F.BTCDCommTIP) end  as BTCTIP      
    ,F.isBTCComm     
                                   
   FROM                                                            
   dbo.fnGetHotelRateData(@FIT,@GIT,@Contract,@Adhoc,@Negotiated,@City,@Hotel,@Vendor,@ValidFrom,@ValidTo,                                                
   @MIS,@RatingFromMIS,@RatingToMIS,@IsDirectPayment)                                                                                           
   AS F                                                                                 
   LEFT JOIN MealPlan MP ON MP.ID = F.MealPlanID          
   LEFT JOIN Tax_Percentage TP ON TP.taxID=F.TaxPerc                                                                  
   WHERE (@Market IS NULL                                                                                    
   OR F.HotelRateID IN (SELECT HotelRateID FROM HotelRateAgentMarketMap WHERE MarketID = @Market))                          
                             
  ) A                           
  WHERE ISHotelPreferred = CASE WHEN @ISHotelPreferred = 1 THEN 'true' ELSE ISHotelPreferred END                          
  ORDER BY A.HoteRatingSequence DESC,HotelName ASC,A.RateDetailSequence,ValidFrom ASC, A.HotelRateID                           
                                                                       
                                                                                
 END                                                                                          
                                                                        
  ELSE --For Markup Rates                                                                                          
   BEGIN                             
   SELECT * FROM (                          
   SELECT F.HotelID,F.HotelRateID,F.City,HotelName,InfoForOps,                                                                      
     MP.Code [MealPlan],TP.taxValue [Tax_Per] ,CASE F.DaysText WHEN '1234567' THEN 'ALL' ELSE F.DaysText  END as [DaysText] ,                                         
     ValidFrom,ValidTo,--F.DaysText,                                            (CAST(F.MinNights AS VARCHAR(5))+ ' - ' + CAST(F.MaxNights AS VARCHAR(5))) AS MinMax, --Added By Sagar 08 July                                                                 
  
     FIT,GIT,F.FIT_GIT,ShowOnline,--ExtraBedAdult,ExtraBedChild,       
     CAST(CAST(dbo.fnSearchCalculateROE(F.Breakfast,@ValidFrom,@Currency,CurrencyID)AS NUMERIC(18,0)) AS    VARCHAR(20)) Breakfast,                                                                      
     CAST(CAST(dbo.fnSearchCalculateROE(F.Lunch,@ValidFrom,@Currency,CurrencyID)AS NUMERIC(18,0)) AS VARCHAR   (20)) Lunch,                                                                      
     CAST(CAST(dbo.fnSearchCalculateROE(F.Dinner,@ValidFrom,@Currency,CurrencyID)AS NUMERIC(18,0)) AS VARCHAR  (20)) Dinner,                                                                      
     XORemarks,F.HotelRateDetailsID,F.Rating,F.TransferCode [Transfer],F.RoomCategory,                                                                      
     CAST(CAST(dbo.fnSearchCalculateROE(F.AdultExtra,@ValidFrom,@Currency,CurrencyID)AS NUMERIC(18,0)) AS   VARCHAR(20)) AdultExtra,                                                                      
     CAST(CAST(dbo.fnSearchCalculateROE(F.ChildExtra,@ValidFrom,@Currency,CurrencyID)AS NUMERIC(18,0)) AS   VARCHAR(20)) ChildExtra,                                                                      
     dbo.fnGetRateType(F.HotelRateID) [Rate Sheet],     
         
    CASE when F.BTCSComm != null or F.BTCSComm != '0.00' then F.SGLNett         
    else F.SGL         
    end  as 'SGL',    
    CASE when F.BTCDComm != null or F.BTCDComm != '0.00' then F.DBLNett         
    else F.DBL         
    end  as 'DBL',                                                                      
    -- F.SGL,F.DBL,                                                                 
     CAST(dbo.fnGetMarkupForHotel(F.HotelRateDetailsID,ACM.CategoryID,F.[SGL],ValidFrom,ValidTo,1,@ValidFrom,  @Currency,CurrencyID)AS NUMERIC(18,0)) as [MarkUp Single] ,                                                                      
     CAST(dbo.fnGetMarkupForHotel(F.HotelRateDetailsID,ACM.CategoryID,F.[DBL],ValidFrom,ValidTo,2,@ValidFrom,  @Currency,CurrencyID)AS NUMERIC(18,0)) as [MarkUp Double] ,                                                                      
     ACM.CategoryCode,@AgentCategory [CategoryID],@Currency [Currency],CardNo,f.MISSequenceNo,                                                              
     F.RateCardMode ,                                                           
     case when (select COUNT(HA.AnnouncementID) from HotelAnnouncement HA where HA.HotelID=F.HotelID AND AnnouncementDetails<>'')>=1 then 'true' else 'false' end AS ISHotelAnnouncement,                                                      
     --(select AnnouncementDetails from HotelAnnouncement HA where HA.HotelID=F.HotelID) AS AnnouncementDetails,                                                            
     (SELECT  SUBSTRING((SELECT distinct '|  ' + AnnouncementDetails FROM HotelAnnouncement HA where HA.HotelID=F.HotelID and ISNULL(HA.AnnouncementDetails,'')<>'' AND CONVERT(VARCHAR(12),HA.ValidTo,112)>=CONVERT(VARCHAR(12),GETDATE(),112)                
 
     
      
       
     FOR XML PATH('')), 2,10000) )  AS AnnouncementDetails,                
              
                   
                   
   case when (select COUNT(HP.HotelID) from HotelPreferred HP where HP.HotelID=F.HotelID)>=1 then 'true' else 'false' end AS ISHotelPreferred,                                                
   CASE WHEN isnull(ValueAddOn,'') <> '' THEN ValueAddOn ELSE '-1' END AS ValueAddOn ,                                  
     F.IsDirectPayment, F.SGLCommission, F.DBLCommission, HoteRatingSequence, RateDetailSequence, F.HotelRateID AS HotelRateID1                      
     ,F.IsEOB,F.IsPayStay   --added by sanket @ 22/07/2014          
     ,F.TaxPerc                 
     ,case when F.IsEOB=1 then 'Early Bird Offer'                   
     when F.IsEOB=2 then 'Pay Stay'                   
     else ''                        
     END AS OfferText       
     ,F.BTCSComm,F.BTCDComm,F.SGLNett,F.DBLNett,     
      Case when F.BTCSComm = null or F.BTCSComm ='0.00' then '' else  F.BTCSCommTIP end  as BTCSCommTIP    
    , case when F.BTCDComm = null or F.BTCDComm = '0.00' then '' else  F.BTCDCommTIP end  as BTCDCommTIP        
     , case when (F.BTCDComm = null or F.BTCDComm = '0.00' AND F.BTCSComm = null or F.BTCSComm ='0.00') then '' else  CONVERT(Varchar(50), F.BTCSCommTIP) + ' , ' + CONVERT(Varchar(50), F.BTCDCommTIP) end  as BTCTIP      
     ,F.isBTCComm     
     FROM                                                                      
     dbo.fnGetHotelRateData(@FIT,@GIT,@Contract,@Adhoc,@Negotiated,@City,@Hotel,@Vendor,@ValidFrom,@ValidTo,                                                             
     @MIS,@RatingFromMIS,@RatingToMIS,@IsDirectPayment)                                                                      
     AS F                                                                      
     LEFT JOIN MealPlan MP ON MP.ID = F.MealPlanID           
     LEFT JOIN Tax_Percentage TP ON TP.taxID=F.TaxPerc                                                                   
     LEFT JOIN HotelOccupancyMarkupOverride OM ON OM.HotelRateDetailsID=F.HotelRateDetailsID AND OM.   AgentCategoryID=@CategoryID                                                                      
     LEFT JOIN AgentCategoryMaster ACM ON (ACM.CategoryID= CASE WHEN @AgentID IS NOT NULL THEN        
     (Select CategoryID from AgentMaster where AgentID=@AgentID)                                                                      
     WHEN @AgentCategory IS NOT NULL THEN @AgentCategory END                                                                      
     )                                                                      
     WHERE (@Market IS NULL                                                                      
     OR F.HotelRateID IN (SELECT HotelRateID FROM HotelRateAgentMarketMap WHERE MarketID = @Market))                                                        
    AND (ISNULL(ACM.CategoryID,'') = CASE WHEN @AgentID IS NOT NULL THEN (SELECT CategoryID FROM AgentMaster  WHERE AgentID=@AgentID)                                                                      
     WHEN @AgentCategory IS NOT NULL THEN @AgentCategory                                                                      
     ELSE ISNULL(ACM.CategoryID,'') END)                                                                      
   ) A                           
    WHERE ISHotelPreferred = CASE WHEN @ISHotelPreferred = 1 THEN 'true' ELSE ISHotelPreferred END                                   
    ORDER BY HoteRatingSequence DESC,HotelName ASC,RateDetailSequence,ValidFrom ASC                                                                                              
 END                                                                                          
END                                                                                          
ELSE --For B2B Rates                                                                                          
 BEGIN    
 --SELECT '200' as returnCode, 'data retrived' as returnMessage    
 if(@Nett_Markedup=1)--For Net Rates                                                                                          
    BEGIN                             
    SELECT * FROM (                                     
    SELECT F.HotelID,F.HotelRateID,F.City,HotelName,InfoForOps,                                                                     
    MP.Code [MealPlan],TP.taxValue [Tax_Per],CASE F.DaysText WHEN '1234567' THEN 'ALL' ELSE F.DaysText END as [DaysText] ,                                                                      
    ValidFrom,ValidTo,--F.DaysText,                                    
    (CAST(F.MinNights AS VARCHAR(5))+ ' - ' + CAST(F.MaxNights AS VARCHAR(5))) AS MinMax, --Added By Sagar 08 July                                                                      
    FIT,GIT,F.FIT_GIT,ShowOnline,     
    CASE when F.BTCSComm != null or F.BTCSComm != '0.00' then CAST(CAST(dbo.fnSearchCalculateROE(F.SGLNett,@ValidFrom,@Currency,CurrencyID)AS NUMERIC(18,0)) AS VARCHAR(20))          
    else  CAST(CAST(dbo.fnSearchCalculateROE(SGL,@ValidFrom,@Currency,CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20))         
    end  as 'SGL',    
    CASE when F.BTCDComm != null or F.BTCDComm != '0.00' then CAST(CAST(dbo.fnSearchCalculateROE(F.DBLNett,@ValidFrom,@Currency,CurrencyID)AS NUMERIC(18,0)) AS VARCHAR(20))          
    else CAST(CAST(dbo.fnSearchCalculateROE(DBL,@ValidFrom,@Currency,CurrencyID)AS NUMERIC(18,0)) AS VARCHAR(20))         
    end  as 'DBL',     
                                                                         
    --CAST(CAST(dbo.fnSearchCalculateROE(SGL,@ValidFrom,@Currency,CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20)) SGL,                                                       
    --CAST(CAST(dbo.fnSearchCalculateROE(DBL,@ValidFrom,@Currency,CurrencyID)AS NUMERIC(18,0)) AS VARCHAR(20)) DBL,--ExtraBedAdult,  ExtraBedChild,                                                                      
    CAST(CAST(dbo.fnSearchCalculateROE(F.Breakfast,@ValidFrom,@Currency,CurrencyID)AS NUMERIC(18,0)) AS    VARCHAR(20)) Breakfast,                                                                      
    CAST(CAST(dbo.fnSearchCalculateROE(F.Lunch,@ValidFrom,@Currency,CurrencyID)AS NUMERIC(18,0)) AS VARCHAR   (20)) Lunch,                                                                      
    CAST(CAST(dbo.fnSearchCalculateROE(F.Dinner,@ValidFrom,@Currency,CurrencyID)AS NUMERIC(18,0)) AS VARCHAR  (20)) Dinner,                                                                      
    XORemarks,F.HotelRateDetailsID,F.Rating,F.TransferCode [Transfer],F.RoomCategory,                                                                      
    CAST(CAST(dbo.fnSearchCalculateROE(F.AdultExtra,@ValidFrom,@Currency,CurrencyID)AS NUMERIC(18,0)) AS   VARCHAR(20)) AdultExtra,                                                                      
    CAST(CAST(dbo.fnSearchCalculateROE(F.ChildExtra,@ValidFrom,@Currency,CurrencyID)AS NUMERIC(18,0)) AS   VARCHAR(20)) ChildExtra,                                                   
    dbo.fnGetRateType(F.HotelRateID) [Rate Sheet],                                                                      
    @AgentCategory [CategoryID],                                                                      
   dbo.fnSearchCalculateROE(SGL,@ValidFrom,@Currency,CurrencyID) AS SGLROE                                                                      
    ,dbo.fnSearchCalculateROE(DBL,@ValidFrom,@Currency,CurrencyID) AS DBLROE ,                                                                      
    @Currency [Currency],CardNo,f.MISSequenceNo,                    
     F.RateCardMode ,                                                         
    case when (select COUNT(HA.AnnouncementID) from HotelAnnouncement HA where HA.HotelID=F.HotelID AND AnnouncementDetails<>'')>=1 then 'true' else 'false' end AS ISHotelAnnouncement,                                                            
    --(select AnnouncementDetails from HotelAnnouncement HA where HA.HotelID=F.HotelID) AS AnnouncementDetails,                                                      
    (SELECT  SUBSTRING((SELECT distinct '|  ' + AnnouncementDetails FROM HotelAnnouncement HA where HA.HotelID=F.HotelID and ISNULL(HA.AnnouncementDetails,'')<>'' AND CONVERT(VARCHAR(12),HA.ValidTo,112)>=CONVERT(VARCHAR(12),GETDATE(),112)                 
  
   
      
       
     FOR XML PATH('')), 2,10000) )  AS AnnouncementDetails,              
  case when (select COUNT(HP.HotelID) from HotelPreferred HP where HP.HotelID=F.HotelID)>=1 then 'true' else 'false' end AS ISHotelPreferred,                  
  CASE WHEN isnull(ValueAddOn,'') <> '' THEN ValueAddOn ELSE '-1' END AS ValueAddOn,                                  
  F.IsDirectPayment, F.SGLCommission, F.DBLCommission, HoteRatingSequence, RateDetailSequence, F.HotelRateID AS HotelRateID1                    
  ,F.IsEOB,F.IsPayStay   --added by sanket @ 22/07/2014          
  ,F.TaxPerc                
  ,case when F.IsEOB=1 then 'Early Bird Offer'                   
     when F.IsEOB=2 then 'Pay Stay'                   
     else ''                        
     END AS OfferText       
    ,F.BTCSComm,F.BTCDComm,F.SGLNett,F.DBLNett     
    , Case when F.BTCSComm = null or F.BTCSComm ='0.00' then '' else  F.BTCSCommTIP end  as BTCSCommTIP    
    , case when F.BTCDComm = null or F.BTCDComm = '0.00' then '' else  F.BTCDCommTIP end  as BTCDCommTIP     
    , case when (F.BTCDComm = null or F.BTCDComm = '0.00' AND F.BTCSComm = null or F.BTCSComm ='0.00') then '' else  CONVERT(Varchar(50), F.BTCSCommTIP) + ' , ' + CONVERT(Varchar(50), F.BTCDCommTIP) end  as BTCTIP      
    ,F.isBTCComm     
    FROM                                                                      
    dbo.fnGetHotelRateData(@FIT,@GIT,@Contract,@Adhoc,@Negotiated,@City,@Hotel,@Vendor,@ValidFrom,@ValidTo,                                                  
    @MIS,@RatingFromMIS,@RatingToMIS,@IsDirectPayment)                                                                      
    AS F                                                                      
    LEFT JOIN MealPlan MP ON MP.ID = F.MealPlanID            
    LEFT JOIN Tax_Percentage TP on TP.taxID=F.TaxPerc                                                                  
    WHERE F.ShowOnline=1                                                                      
    AND (@Market IS NULL                                                                      
    OR F.HotelRateID IN (SELECT HotelRateID FROM HotelRateAgentMarketMap WHERE MarketID = @Market))                                                       
    ) A                           
      WHERE ISHotelPreferred = CASE WHEN @ISHotelPreferred = 1 THEN 'true' ELSE ISHotelPreferred END                                                           
      ORDER BY HoteRatingSequence DESC,HotelName ASC,RateDetailSequence,ValidFrom ASC                                                    
  END                                                                                          
  ELSE --For Marup Rates                                                                                          
    BEGIN                              
    SELECT * FROM                           
    (                                                                                      
  SELECT F.HotelID,F.HotelRateID,F.City,HotelName,InfoForOps,                                                                      
  MP.Code [MealPlan],TP.taxValue [Tax_Per], CASE F.DaysText WHEN '1234567' THEN 'ALL' ELSE F.DaysText  END as [DaysText] ,                                      
  ValidFrom,ValidTo,--F.DaysText,                                      
 (CAST(F.MinNights AS VARCHAR(5))+ ' - ' + CAST(F.MaxNights AS VARCHAR(5))) AS MinMax, --Added By Sagar 08 July                                                                    
  FIT,GIT,F.FIT_GIT,ShowOnline,--ExtraBedAdult,ExtraBedChild,                                                      
  CAST(CAST(dbo.fnSearchCalculateROE(F.Breakfast,@ValidFrom,@Currency,CurrencyID)AS NUMERIC(18,0)) AS    VARCHAR(20)) Breakfast,                                               
  CAST(CAST(dbo.fnSearchCalculateROE(F.Lunch,@ValidFrom,@Currency,CurrencyID)AS NUMERIC(18,0)) AS VARCHAR   (20)) Lunch,                                                                      
  CAST(CAST(dbo.fnSearchCalculateROE(F.Dinner,@ValidFrom,@Currency,CurrencyID)AS NUMERIC(18,0)) AS VARCHAR  (20)) Dinner,                                                                      
  XORemarks,F.HotelRateDetailsID,F.Rating,F.TransferCode [Transfer],F.RoomCategory,                                                                      
  CAST(CAST(dbo.fnSearchCalculateROE(F.AdultExtra,@ValidFrom,@Currency,CurrencyID)AS NUMERIC(18,0)) AS   VARCHAR(20)) AdultExtra,                                                                      
  CAST(CAST(dbo.fnSearchCalculateROE(F.ChildExtra,@ValidFrom,@Currency,CurrencyID)AS NUMERIC(18,0)) AS   VARCHAR(20)) ChildExtra,                                                                      
  dbo.fnGetRateType(F.HotelRateID) [Rate Sheet],      
   CASE when F.BTCSComm != null or F.BTCSComm != '0.00' then F.SGLNett         
    else F.SGL         
    end  as 'SGL',    
    CASE when F.BTCDComm != null or F.BTCDComm != '0.00' then F.DBLNett         
    else F.DBL         
    end  as 'DBL',                                                                     
  --F.SGL,F.DBL,                                                                      
  CAST(dbo.fnGetMarkupForHotel(F.HotelRateDetailsID,ACM.CategoryID,F.[SGL],ValidFrom,ValidTo,1,@ValidFrom,  @Currency,CurrencyID) AS NUMERIC(18,0)) as [MarkUp Single],                                                                      
  CAST(dbo.fnGetMarkupForHotel(F.HotelRateDetailsID,ACM.CategoryID,F.[DBL],ValidFrom,ValidTo,2,@ValidFrom,  @Currency,CurrencyID)AS NUMERIC(18,0)) as [MarkUp Double],                                                                      
  ACM.CategoryCode ,@AgentCategory [CategoryID] ,                                                                      
  @Currency [Currency],CardNo,f.MISSequenceNo,                                                              
  F.RateCardMode ,                                                      
  case when (select COUNT(HA.AnnouncementID) from HotelAnnouncement HA where HA.HotelID=F.HotelID AND AnnouncementDetails<>'')>=1 then 'true' else 'false' end AS ISHotelAnnouncement,                                                            
  --(select AnnouncementDetails from HotelAnnouncement HA where HA.HotelID=F.HotelID) AS AnnouncementDetails,                                                      
  (SELECT  SUBSTRING((SELECT distinct '|  ' + AnnouncementDetails FROM HotelAnnouncement HA where HA.HotelID=F.HotelID and ISNULL(HA.AnnouncementDetails,'')<>'' AND CONVERT(VARCHAR(12),HA.ValidTo,112)>=CONVERT(VARCHAR(12),GETDATE(),112)                  
   
   
     
     FOR XML PATH('')), 2,10000) )  AS AnnouncementDetails,              
                
   case when (select COUNT(HP.HotelID) from HotelPreferred HP where HP.HotelID=F.HotelID)>=1 then 'true' else 'false' end AS ISHotelPreferred,                                                
   CASE WHEN isnull(ValueAddOn,'') <> '' THEN ValueAddOn ELSE '-1' END AS ValueAddOn,                                  
   F.IsDirectPayment, F.SGLCommission, F.DBLCommission, RateDetailSequence, HoteRatingSequence , F.HotelRateID AS HotelRateID1                      
   ,F.IsEOB,F.IsPayStay   --added by sanket @ 22/07/2014           
   ,F.TaxPerc               
   ,case when F.IsEOB=1 then 'Early Bird Offer'                   
     when F.IsEOB=2 then 'Pay Stay'                   
     else ''                        
     END AS OfferText    
    ,F.BTCSComm,F.BTCDComm,F.SGLNett,F.DBLNett     
    , Case when F.BTCSComm = null or F.BTCSComm ='0.00' then '' else  F.BTCSCommTIP end  as BTCSCommTIP    
    , case when F.BTCDComm = null or F.BTCDComm = '0.00' then '' else  F.BTCDCommTIP end  as BTCDCommTIP     
    , case when (F.BTCDComm = null or F.BTCDComm = '0.00' AND F.BTCSComm = null or F.BTCSComm ='0.00') then '' else  Convert(Varchar(50), F.BTCSCommTIP) + ' ,  ' + Convert(Varchar(50),F.BTCDCommTIP) end  as BTCTIP        
    ,isBTCComm     
  FROM                                                                      
  dbo.fnGetHotelRateData(@FIT,@GIT,@Contract,@Adhoc,@Negotiated,@City,@Hotel,@Vendor,@ValidFrom,@ValidTo,                                                                      
  @MIS,@RatingFromMIS,@RatingToMIS,@IsDirectPayment)                                                                      
  AS F                                                     
  LEFT JOIN MealPlan MP ON MP.ID = F.MealPlanID         
  LEFT JOIN Tax_Percentage TP on TP.taxID=F.TaxPerc                                                                     
  LEFT JOIN HotelOccupancyMarkupOverride OM ON OM.HotelRateDetailsID=F.HotelRateDetailsID AND OM.     AgentCategoryID=@CategoryID                                                                      
  LEFT JOIN AgentCategoryMaster ACM ON (ACM.CategoryID= CASE WHEN @AgentID IS NOT NULL THEN                 
  (Select CategoryID from AgentMaster where AgentID=@AgentID)                                                                      
  ELSE                                                                      
  @AgentCategory                                                                      
  END)                                                            
  WHERE ShowOnline=1                                                                      
  AND (@Market IS NULL                                                                      
  OR F.HotelRateID IN (SELECT HotelRateID FROM HotelRateAgentMarketMap WHERE MarketID = @Market))                                                                      
  AND (ISNULL(ACM.CategoryID,'') = CASE WHEN @AgentID IS NOT NULL THEN (SELECT CategoryID FROM AgentMaster  WHERE AgentID=@AgentID)                                     
  WHEN @AgentCategory IS NOT NULL THEN @AgentCategory                              
  ELSE ISNULL(ACM.CategoryID,'') END)                                                                   
  ) A                           
  WHERE ISHotelPreferred = CASE WHEN @ISHotelPreferred = 1 THEN 'true' ELSE ISHotelPreferred END                          
  ORDER BY HoteRatingSequence DESC,HotelName ASC,RateDetailSequence,ValidFrom ASC  ,A.HotelRateID          
      
         
    
  END                                                                                  
 END                                                                                          
END 
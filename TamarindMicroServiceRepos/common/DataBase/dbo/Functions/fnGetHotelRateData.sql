--=======================================================                     
-- Modified By:  Sagar Pawar                                                                                                   
-- Modified date: 08 July 2013                                                                             
-- Description: Added Min Max Fields                      
-- Modified By:  Sagar Pawar                                                                                                   
-- Modified date: 17 July 2013                                                                             
-- Description: Added  IsDirect Payment                       
-- Updated By Sagar for SGLCommission and DBlCommission                                  
--=======================================================                     
--select * from dbo.fnGetHotelRateData(1,0,'1','2',null,'BOM',NULL,NULL,'2013-09-14 00:00:00','2013-09-15 00:00:00',2,NULL,NULL,0)              
CREATE FUNCTION [dbo].[fnGetHotelRateData](@FIT INT,@GIT INT,@Contract INT,@Adhoc INT,@Negotiated INT,@City VARCHAR(5),@Hotel INT,@VendorID INT,@ValidFrom DATETIME,@ValidTo DATETIME,@MIS INT,@RatingFromMIS INT,@RatingToMIS INT,@IsDirectPayment BIT)       
  
        
      
        
          
            
              
RETURNS TABLE                                                                            
AS                                                                            
RETURN                                                                            
(                                                                            
    SELECT HM.HotelID,HRM.HotelRateID,HM.CityIATACode,HM.HotelName,HRM.InfoForOps,HRD.TransferID As [Transfer],HRD.MealPlanID,                                                                         
    HRD.RateValidFrom AS ValidFrom,HRD.RateValidTo AS ValidTo,HRD.Days AS [Days],HRD.FIT,HRD.GIT,                                                                  
    CASE HRD.FIT WHEN 1 THEN 'FIT' ELSE '' END +' '+  CASE HRD.GIT WHEN 1 THEN 'GIT' ELSE '' END AS FIT_GIT,                                                                  
    HRD.ShowOnline,HRD.TaxPerc,                                                                            
    SGL,DBL,                 
    --HRD.AdultExtra As ExtraBedAdult,HRD.ChildExtra AS ExtraBedChild,                                                                      
    HRD.Breakfast AS [Breakfast],HRD.Lunch AS [Lunch],HRD.Dinner AS [Dinner],                                                                            
    HRM.InfoForXO AS XORemarks,HRD.HotelRateDetailsID,HR.Code [Rating],TM.TransferCode,CT.Name [City],RC.Name [RoomCategory],                                                                          
    HRD.AdultExtra AS [AdultExtra],HRD.ChildExtra AS [ChildExtra], HRD.MinNights, HRD.MaxNights, --Min Max is Added by Sagar                                                                        
    CASE WHEN SUBSTRING([Days],1,1)=1 THEN '1' ELSE '-' END+                                                                          
    CASE WHEN SUBSTRING([Days],2,1)=1 THEN '2' ELSE '-' END+                                                                          
    CASE WHEN SUBSTRING([Days],3,1)=1 THEN '3' ELSE '-' END+                                                                          
    CASE WHEN SUBSTRING([Days],4,1)=1 THEN '4' ELSE '-' END+                                                                           
    CASE WHEN SUBSTRING([Days],5,1)=1 THEN '5' ELSE '-' END+                                                                           
    CASE WHEN SUBSTRING([Days],6,1)=1 THEN '6' ELSE '-' END+                                                                           
    CASE WHEN SUBSTRING([Days],7,1)=1 THEN '7' ELSE '-' END AS DaysText,                                                                        
    HRM.CurrencyID,HRM.CardNo,HRD.MISSequenceNo                         
    ,HR.MisSequence AS HoteRatingSequence,HRD.MisSequenceNo AS RateDetailSequence,                                          
    HRM.RateCardMode,HRM.ValueAddOn ,HRD.RoomCategoryID   ,HR.Ratings As HRating, HRM.IsDirectPayment, SGLCommission, DBLCommission,               
    BTCSComm,BTCDComm,SGLNett,DBLNett, 'BTCSComm : '+ Convert(Varchar(50),BTCSComm) AS BTCSCommTIP,   
    'BTCDComm : '+ Convert(Varchar(50),BTCDComm)  AS BTCDCommTIP,             
    CASE WHEN ((CONVERT(VARCHAR,@ValidFrom,112) BETWEEN CONVERT(VARCHAR,HRD.RateValidFrom,112) AND CONVERT(VARCHAR,HRD.RateValidTo,112))            
    AND (CONVERT(VARCHAR,@ValidTo,112) BETWEEN CONVERT(VARCHAR,HRD.RateValidFrom,112) AND CONVERT(VARCHAR,HRD.RateValidTo,112))) THEN 0 ELSE 1 END             
    AS IsSplit        
    ,IsEOB,IsPayStay,HRM.isBTCComm   --added by sanket @ 22/07/2014       
        
  FROM HotelRateMaster HRM                                                                              
  INNER JOIN HotelRateDetails HRD ON HRD.HotelRateID = HRM.HotelRateID                                                                              
  INNER JOIN HotelMaster HM ON HM.HotelID = HRM.HotelID                                           
  INNER JOIN HotelRating HR ON HR.ID = HM.HotelRatingID                                                                            
  LEFT JOIN TransferMaster TM On TM.TransferID=HRD.TransferID                                                                          
  LEFT JOIN City CT On CT.IATACode=HM.CityIATACode                                                                          
  LEFT JOIN RoomCategory RC On RC.ID=HRD.RoomCategoryID                                                                          
  INNER JOIN HotelRoomCategory HRC ON  HRC.HotelID=HM.HotelID AND HRC.RoomCategoryID =HRD.RoomCategoryID AND HRC.IsActive=1                                              
  WHERE                                       
  HRM.IsActive=1 AND HRD.IsActive=1  AND HM.IsActive=1 --added by sanket @ 10/03/1014                                                                   
  AND HM.CityIATACode = @City                                                   
  AND HRM.HotelID =CASE WHEN @Hotel IS NOT NULL THEN @Hotel ELSE HRM.HotelID END                                                          
  AND HRM.RateCardMode IN (@Contract,@Adhoc,@Negotiated)                                                                             
  AND (HRD.FIT=CASE WHEN @FIT IS NOT NULL THEN @FIT ELSE HRD.FIT END                                                                              
  OR HRD.GIT=CASE WHEN @GIT IS NOT NULL THEN @GIT ELSE HRD.GIT END)                                                                  
  AND ISNULL(VendorID,'') = CASE WHEN @VendorID IS NOT NULL THEN @VendorID ELSE ISNULL(VendorID,'') END                                                   
  AND ((CONVERT(VARCHAR,@ValidFrom,112) BETWEEN CONVERT(VARCHAR,HRD.RateValidFrom,112) AND CONVERT(VARCHAR,HRD.RateValidTo,112))                                                                               
  OR (CONVERT(VARCHAR,@ValidTo,112) BETWEEN CONVERT(VARCHAR,HRD.RateValidFrom,112) AND CONVERT(VARCHAR,HRD.RateValidTo,112))                                                        
  OR (CONVERT(VARCHAR,HRD.RateValidFrom,112) BETWEEN CONVERT(VARCHAR,@ValidFrom,112) AND CONVERT(VARCHAR,@ValidTo,112))                                                                               
  OR (CONVERT(VARCHAR,HRD.RateValidTo,112) BETWEEN CONVERT(VARCHAR,@ValidFrom,112) AND CONVERT(VARCHAR,@ValidTo,112)))                                                       
                                              
  AND ISNULL(MISSequenceNo,'') <= CASE WHEN @MIS IS NOT NULL THEN @MIS ELSE ISNULL(MISSequenceNo,'') END                                                                      
  AND HR.MISSequence >= CASE WHEN @RatingFromMIS IS NOT NULL THEN @RatingFromMIS ELSE HR.MISSequence END                                                               
  AND HR.MISSequence <= CASE WHEN @RatingToMIS IS NOT NULL THEN @RatingToMIS ELSE HR.MISSequence END                                                                    
  AND ISNULL(HRM.IsDirectPayment,0)=CASE WHEN @IsDirectPayment IS NOT NULL THEN @IsDirectPayment ELSE ISNULL(HRM.IsDirectPayment,0) END      --Added By Sagar                      
          
                                                                      
)   
  
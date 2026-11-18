CREATE PROCEDURE [dbo].[usp_HotelRateCard_Master]  
    @Action CHAR='S',  
    @RateValidFrom DATETIME = NULL,  
    @RateValidTo DATETIME = NULL,  
    @IsActive BIT = NULL  
AS  
BEGIN  
    SET NOCOUNT ON;  
  
    IF @Action = 'S'  
    BEGIN  
        SELECT   
            HM.HotelName,  
            HRM.Heading,  
            HRM.InfoForOperation,  
            HRM.CityID,  
   HRM.CardNumber AS CardNumber,  
            RVM.RateValidFrom,  
            RVM.RateValidTo,  
            HRD.IsActive , 
   --C.IATACode AS IATACode,  
   C.Name as Name  
  FROM HotelMaster HM  
        INNER JOIN [RateCards].[HotelRateMaster] HRM ON HM.HotelID = HRM.HotelID  
        INNER JOIN [RateCards].[HotelRateDetails] HRD ON HRD.HotelRateID = HRM.HotelRateID  
        INNER JOIN [RateCards].[RateValidityMaster] RVM ON RVM.HotelRateDetailID = HRD.HotelRateDetailID  
  INNER JOIN City C ON C.IATACode = HRM.CityID  
  WHERE   
    (  
        (@RATEVALIDFROM IS NULL OR CONVERT(DATE, RVM.RateValidFrom) >= CONVERT(DATE, @RATEVALIDFROM))  
        AND (@RATEVALIDTO IS NULL OR CONVERT(DATE, RVM.RateValidTo) <= CONVERT(DATE, @RATEVALIDTO))  
    )  
    AND (@ISACTIVE IS NULL OR HRD.ISACTIVE = @ISACTIVE);  
  
 select '200' AS returnCode ,'Data Found' AS returnMessage     
    END  
END  
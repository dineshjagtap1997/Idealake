  
  
      
      
CREATE FUNCTION fnGetHotelOfferRateType(@OfferRateID INT)          
RETURNS VARCHAR(MAX)          
AS          
BEGIN          
DECLARE @str VARCHAR(MAX)          
SET @str=''          
SELECT @str = @str + Rate_Type_Name + ','         
FROM HotelOfferRateType HORT        
INNER JOIN Rate_Type RT ON RT.Rate_Type_ID = HORT.RateTypeID      
WHERE HORT.HotelOfferID=@OfferRateID          
Return @str          
END 
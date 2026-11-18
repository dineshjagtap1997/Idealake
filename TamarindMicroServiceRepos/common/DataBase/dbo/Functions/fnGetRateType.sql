    
CREATE FUNCTION [dbo].[fnGetRateType](@HotelRateID INT)            
RETURNS VARCHAR(MAX)            
AS            
BEGIN            
DECLARE @str VARCHAR(MAX)            
SET @str=''            
SELECT @str = @str + Rate_Type_Code + ', '           
FROM HotelRateType HRT          
INNER JOIN Rate_Type RT ON RT.Rate_Type_ID = HRT.RateTypeID          
WHERE HRT.HotelRateID=@HotelRateID     ORDER BY  Rate_Type_Code              
Return @str            
END 
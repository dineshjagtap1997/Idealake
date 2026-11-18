  
      
      
      
--=======================================================                                                                                
-- Author  : SAnket                                                                                
-- Created On : 10 Jan 2012                                                                           
-- Description : Gets Transport Zone details by @TransportRateID                                                         
--======================================================= TransportRateDetails       
      
CREATE FUNCTION [dbo].[fnGetZoneForTransport](@TransportRateID INT)          
RETURNS VARCHAR(MAX)          
AS          
BEGIN          
DECLARE @str VARCHAR(MAX)          
SET @str=''          
SELECT @str = @str + ZoneName + ',' FROM TransportRateZoneDetails TRZD      
INNER JOIN ZoneMaster ZM ON TRZD.ZoneID=ZM.ZoneID      
WHERE TRZD.TransportRateID=@TransportRateID        
Return @str          
END 
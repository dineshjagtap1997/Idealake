    
    
    
-- =============================================        
-- Author:  Santosh Yadav        
-- Create date: 30th June 2011        
-- Description: Get the Hotel Room Cancellation Data on HotelRateID       
-- Modified By:  Sagar Pawar                                                                                       
-- Modified date: 17 July 2013                                                                 
-- Description: Get the Hotel Room Cancellation Data on HotelRateID        
-- ============================================        
CREATE PROCEDURE [dbo].[usp_GetHotelRoomCancellationData]        
(        
@HotelRateID INT        
)        
AS        
BEGIN        
        
SELECT CONVERT(VARCHAR,ValidFrom,103)ValidFrom,CONVERT(VARCHAR,ValidTo,103)ValidTo,        
TSStart,TSEnd,AgentStart,AgentEnd,ChargePercent,ChargeNight,BookedNight,IsActive      
,BookedMinNights,BookedMaxNights          
FROM HotelRoomCancellation        
WHERE HotelRateID=@HotelRateID or @HotelRateID = 0 or @HotelRateID is null
        
END 
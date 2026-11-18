create PROCEDURE [dbo].[usp_GetHotelFacilityInfoOnHotelID] --25      
(      
@HotelID int      
)      
AS      
BEGIN      
SELECT HFS.HotelID,HFS.FacilityInfoID,  
FI.InformationName,FI.ImageName,FI.Image  
from HotelFactSheetInformation HFS  
INNER JOIN FacilityInformationMaster FI on FI.FacilityInfoID=HFS.FacilityInfoID  
where HotelID=@HotelID   
end
      
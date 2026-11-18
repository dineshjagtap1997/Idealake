-- =============================================          
-- Author:  Shweta          
-- Create date: 1 July 2011        
-- Description: Retrieves           
-- =============================================    
CREATE PROCEDURE [dbo].[USP_GetRoomCategoryByHotelID]    
(
@HotelId int
)    
AS    
BEGIN
SELECT  HotelRoomCategoryID, HotelID,RoomCategoryID,RM.Name AS RoomCategory, NoOfRooms,MaxAdult,ExtraBedMattress,
  CASE WHEN HRM.ExtraBedMattress=0 THEN 'Not Defined'   
   WHEN HRM.ExtraBedMattress=1 THEN 'NA'
   WHEN HRM.ExtraBedMattress=2 THEN 'Bed'
   WHEN HRM.ExtraBedMattress=3 THEN 'Mattress'END AS ExtraBedMattressText,              
  IsInterconnecting,                            
  CASE WHEN HRM.IsInterconnecting=0 THEN 'Not Defined'
   WHEN HRM.IsInterconnecting=1 THEN 'No'
   WHEN HRM.IsInterconnecting=2 THEN 'Yes'
   WHEN HRM.IsInterconnecting=3 THEN 'TBA'END AS IsInterconnecting,
  NoOfInterconnectingRoom,HRM.IsActive
FROM HotelRoomCategory HRM
INNER JOIN RoomCategory RM ON RM.ID= HRM.RoomCategoryID
WHERE HotelID=@HotelID    or @HotelID = 0 or @HotelID is null
END 
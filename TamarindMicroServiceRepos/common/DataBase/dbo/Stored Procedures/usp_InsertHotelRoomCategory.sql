                              
CREATE PROCEDURE [dbo].[usp_InsertHotelRoomCategory] (                          
 @HotelRoomCategoryID INT  =NULL                     
 ,@HotelID INT = NULL                     
 ,@RoomCategoryID INT  =NULL                        
 ,@NoOfRooms INT =   NULL                      
 ,@MaxAdult INT  =NULL                        
 ,@ExtraBedMattress INT    =NULL                      
 ,@IsInterconnecting bit =NULL                         
 ,@NoOfInterconnectingRoom SMALLINT  =NULL                        
 ,@IsActive BIT  =NULL                        
 ,@NoOfBedrooms INT = NULL --added by sanket @ 07/03/2014                            
 ,@Action CHAR(2)=''      
 ,@OperationBy UNIQUEIDENTIFIER = NULL                    
    
 )                          
AS                         
BEGIN         
    
declare @LogID int;      
if @Action='U'                        
BEGIN                          
 IF EXISTS (                          
   SELECT HotelRoomCategoryID                          
   FROM HotelRoomCategory                          
   WHERE HotelRoomCategoryID = @HotelRoomCategoryID                          
   )                          
 BEGIN                          
  UPDATE HotelRoomCategory                          
  SET HotelID = @HotelID                          
   ,RoomCategoryID = @RoomCategoryID                          
   ,NoOfRooms = @NoOfRooms                          
   ,MaxAdult = @MaxAdult                          
   ,ExtraBedMattress = @ExtraBedMattress                          
   ,IsInterconnecting = @IsInterconnecting                          
   ,NoOfInterconnectingRoom = @NoOfInterconnectingRoom                          
   ,IsActive = @IsActive                          
   ,NoOfBedrooms = @NoOfBedrooms                          
  WHERE HotelRoomCategoryID = @HotelRoomCategoryID                         
  SELECT '200' AS returnCode, 'Record updated successfully.' AS returnMessage, @HotelRoomCategoryID AS ID ;                                
 END                          
 END                        
 ELSE IF @Action='I'                         
 BEGIN                          
  INSERT INTO HotelRoomCategory (                          
   HotelID                          
   ,RoomCategoryID                          
   ,NoOfRooms                          
   ,MaxAdult                          
   ,ExtraBedMattress                          
   ,IsInterconnecting                          
   ,NoOfInterconnectingRoom                          
   ,IsActive                          
   ,NoOfBedrooms                          
   )                          
  VALUES (                          
   @HotelID                          
   ,@RoomCategoryID                          
   ,@NoOfRooms                          
   ,@MaxAdult                          
   ,@ExtraBedMattress                          
   ,@IsInterconnecting                          
   ,@NoOfInterconnectingRoom                          
   ,@IsActive                          
   ,@NoOfBedrooms                          
   )           
       
   set @LogID = SCOPE_IDENTITY()    
    SELECT '200' AS returnCode, 'New record added successfully.' AS returnMessage, @LogID as ID;                                
                        
 END                          
 --ELSE IF @Action='E'                          
 ELSE IF @Action='S'                          
                        
 BEGIN                            
SELECT HotelRoomCategoryID,HotelID,RoomCategoryID,RM.Name AS RoomCategory, NoOfRooms,MaxAdult,ExtraBedMattress, NoOfBedrooms ,                                                  
  CASE WHEN HRM.ExtraBedMattress=0 THEN 'Not Defined'                                              
   WHEN HRM.ExtraBedMattress=1 THEN 'NA'                                                    
   WHEN HRM.ExtraBedMattress=2 THEN 'Bed'                                                    
   WHEN HRM.ExtraBedMattress=3 THEN 'Mattress'END AS ExtraBedMattressText,          
  IsInterconnecting,                                                    
  CASE WHEN HRM.IsInterconnecting=0 THEN 'Not Defined'                    
   WHEN HRM.IsInterconnecting=1 THEN 'No'                                                    
   WHEN HRM.IsInterconnecting=2 THEN 'Yes'                                                    
   WHEN HRM.IsInterconnecting=3 THEN 'TBA'END AS IsInterconnectingName, --IsInterconnecting                        
  NoOfInterconnectingRoom,HRM.IsActive                                                          
FROM HotelRoomCategory HRM                                                   
INNER JOIN RoomCategory RM ON RM.ID= HRM.RoomCategoryID                                                       
WHERE (       @HotelRoomCategoryID IS NULL             OR  HotelRoomCategoryID= @HotelRoomCategoryID  OR @HotelRoomCategoryID  = 0         )      
 AND (       @HotelID IS NULL     OR @HotelID  = 0      OR  HotelID= @HotelID         )     
order by HotelRoomCategoryID desc          
END                            
                  
  ELSE IF @Action='EX'                          
                        
 BEGIN                            
SELECT RM.Name AS RoomCategory, NoOfRooms,MaxAdult,ExtraBedMattress, NoOfBedrooms ,                                                  
  CASE WHEN HRM.ExtraBedMattress=0 THEN 'Not Defined'                                              
   WHEN HRM.ExtraBedMattress=1 THEN 'NA'                                                    
   WHEN HRM.ExtraBedMattress=2 THEN 'Bed'                                                    
   WHEN HRM.ExtraBedMattress=3 THEN 'Mattress'END AS ExtraBedMattressText,          
  IsInterconnecting,                                                    
  CASE WHEN HRM.IsInterconnecting=0 THEN 'Not Defined'                    
   WHEN HRM.IsInterconnecting=1 THEN 'No'                                                    
   WHEN HRM.IsInterconnecting=2 THEN 'Yes'                                                    
   WHEN HRM.IsInterconnecting=3 THEN 'TBA'END AS IsInterconnectingName, --IsInterconnecting                        
  NoOfInterconnectingRoom,
  CASE
		WHEN HRM.IsActive = 1 THEN 'Yes'
		WHEN HRM.IsActive = 0 THEN 'No'
		END AS IsActive
FROM HotelRoomCategory HRM                                                   
INNER JOIN RoomCategory RM ON RM.ID = HRM.RoomCategoryID                                                       
WHERE (       @HotelRoomCategoryID IS NULL             OR  HotelRoomCategoryID= @HotelRoomCategoryID  OR @HotelRoomCategoryID  = 0         )      
 AND (       @HotelID IS NULL     OR @HotelID  = 0      OR  HotelID= @HotelID         )     
order by HotelRoomCategoryID desc          
END                         
END
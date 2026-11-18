  
CREATE PROCEDURE [dbo].[usp_InsertItineraryHotelDetails]  
 (  
     @ItineraryID int,  
           @City varchar(250),  
           @HotelName varchar(250),  
           @Nights int,  
           @RoomCategory varchar(200),  
           @MealPlan varchar(200),  
           @CheckInDate datetime,  
           @CheckOutDate datetime,  
           @Status bit,  
           @OperationBy uniqueidentifier,  
     @NewHotelName varchar(2000),  
     @NewRoomCategory varchar(2000),  
     @ErrMsg varchar(50) output  
       
)  
AS  
BEGIN  
INSERT INTO [dbo].[ItineraryHotelDetails]  
           ([ItineraryID]  
           ,[City]  
           ,[HotelID]  
           ,[Nights]  
           ,[RoomCategoryID]  
           ,[MealPlanID]  
           ,[CheckInDate]  
           ,[CheckOutDate]  
           ,[Status]  
           ,[Operation]  
           ,[OperationBy]  
           ,[OperationOn]  
     ,[ItineraryHotelName]  
     ,[ItineraryRoomCategory])  
     VALUES  
             
     (@ItineraryID,  
           @City,   
           @HotelName,  
           @Nights,  
           @RoomCategory,  
           @MealPlan,   
           @CheckInDate,   
           @CheckOutDate,   
           @Status,   
           'Insert',   
           @OperationBy,   
           getdate(),  
     @NewHotelName,  
     @NewRoomCategory  
     )   
  
     set @ErrMsg =  ''   ---(SELECT @@IDENTITY)  
  
END  
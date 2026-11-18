  
-- =============================================                      
   
-- Description: Inserts into ItineraryCreator Table                      
-- =============================================             
CREATE PROCEDURE [dbo].[USP_InsertItineraryCreator]          
@ItineraryID INT OUT,          
@EnquiryID VARCHAR(50),  
@FileCode VARCHAR(30),  
@TourDate DATETIME,  
@IsActive BIT,  
@OperationBy UNIQUEIDENTIFIER,  
@Country varchar(4),  
@Err VARCHAR(100) OUT          
AS          
BEGIN          
  
--IF EXISTS (SELECT ItineraryDescID FROM ItineraryDescription WHERE UPPER(Header)=UPPER(@Header))          
--BEGIN          
-- SET @Err='Itinerary Header is already exists.'          
-- SET @ItineraryDescID=0          
--END          
--ELSE          
--BEGIN        
   
 BEGIN    
   INSERT INTO ItineraryCreator           
   (EnquiryID, FileCode,TourDate, IsActive, Operation, OperationBy, OperationOn, COUNTRY )  
   VALUES (@EnquiryID,@FileCode, @TourDate  ,@IsActive,'INSERT',@OperationBy,GETDATE(), @Country)          
   SET @Err=''          
   SET @ItineraryID=@@IDENTITY      
  END  
--ELSE  
--BEGIN    
--   INSERT INTO ItineraryCreator           
--   (EnquiryID, FileCode, COUNTRY, TourDate, IsActive, Operation, OperationBy, OperationOn)  
--   VALUES (@EnquiryID,@FileCode,@Country,@TourDate,@IsActive,'INSERT',@OperationBy,GETDATE())          
--   SET @Err=''          
--   SET @ItineraryID=@@IDENTITY      
--  END  
--END          
END  
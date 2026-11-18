
-- =============================================        
-- Author:  Shubham Kamble      
-- Create date: 12th Nov 2024        
-- Description: Insert into AstraLive..CustomCaption  
-- =============================================     
  
CREATE PROCEDURE [dbo].[usp_InsertCustomCaption]  
(  
 @EntityName varchar(50),  
 @FieldName varchar(50),  
 @CaptCode varchar(50),  
 @MISSequenceNo INT,  
 @MaxID INT OUT,  
 @Image INT=0,  
 @ImageName varchar(50)=NULL   
   
)  
AS  
BEGIN  
  
 --INSERT INTO AstraLive..CustomCaptions(EntityName,FieldName,CaptCode,CaptValue,Sequence,[Image],image_name)  
 --VALUES(@EntityName,@FieldName,@CaptCode,@CaptCode,@MISSequenceNo,@Image,@ImageName)  
 SET @MaxID=@@IDENTITY  
END

--=============================================        
-- Author:  Shubham Kamble      
-- Create date: 12 Nov 2024        
-- Description: Update table AstraLive..CustomCaption  
-- =============================================     
  
CREATE PROCEDURE [dbo].[usp_UpdateCustomCaption]  
(  
 @CaptCode varchar(50),  
 @MISSequenceNo INT,  
 @CaptID INT,  
 @Image INT=0,  
 @ImageName varchar(50)=NULL   
   
)  
AS  
BEGIN  
   
 UPDATE AstraLive..CustomCaptions SET  
  CaptCode=@CaptCode,  
  CaptValue=@CaptCode,  
  Sequence=@MISSequenceNo,  
  [Image]=@Image,  
  image_name=@ImageName  
 WHERE  CaptID=@CaptID  
    
END
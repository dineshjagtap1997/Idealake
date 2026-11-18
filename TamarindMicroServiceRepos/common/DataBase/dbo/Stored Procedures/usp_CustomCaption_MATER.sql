
CREATE PROCEDURE [dbo].[usp_CustomCaption_MATER]    
(   
@CaptID INT =NULL,
 @EntityName varchar(50)='',    
 @FieldName varchar(50)='',    
 @CaptCode varchar(50)='',    
 @MISSequenceNo INT=null,    
 @MaxID INT OUT,    
 @Image INT=0,    
 @ImageName varchar(50)=NULL, 
    @Action char(2)='' 
)    
AS    
BEGIN    
    DECLARE @ReturnCode NVARCHAR(3), @ReturnMessage NVARCHAR(MAX);        
      IF @Action ='I'
	  BEGIN
		 INSERT INTO AstraLive..CustomCaptions(EntityName,FieldName,CaptCode,CaptValue,Sequence,[Image],image_name)    
		 VALUES(@EntityName,@FieldName,@CaptCode,@CaptCode,@MISSequenceNo,@Image,@ImageName)    
		 SET @MaxID=@@IDENTITY  
		END
		ELSE  IF @Action ='U'
	  BEGIN
		 UPDATE AstraLive..CustomCaptions SET  
  CaptCode=@CaptCode,  
  CaptValue=@CaptCode,  
  Sequence=@MISSequenceNo,  
  [Image]=@Image,  
  image_name=@ImageName  
 WHERE  CaptID=@CaptID  
		END
END


    
--=======================================================                      
-- Author  : Sanket                      
-- Created On : 1th Feb 2012                     
-- Description : Insert into uploaded Image               
--=======================================================     
    
Create PROCEDURE [dbo].[usp_InsertUploadPictures]          
@ParentID  INT,          
@ParentPageType INT,          
@ImageName  VARCHAR(200),          
@Image   VARBINARY(max),      
@ID INT OUT        
        
AS          
BEGIN          
 INSERT INTO UploadImage          
     (ParentID,ParentPageType,ImageName,[Image])          
  VALUES  (@ParentID, @ParentPageType, @ImageName, @Image)         
  set  @ID=@@IDENTITY    
END 
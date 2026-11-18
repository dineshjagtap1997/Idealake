CREATE PROCEDURE [dbo].[usp_GetImages]      
@ParentPageType  INT = 0,      
@ParentID  INT= 0,      
@ImageName NVARCHAR(255) = '',      
@Image NVARCHAR(MAX) = '',      
@Action CHAR(2)=''      
AS      
BEGIN      
DECLARE @Identity int;    
IF @Action='I'    
   BEGIN     
    
        IF EXISTS (    
            SELECT 1 FROM UploadImage     
            WHERE ParentPageType = @ParentPageType AND ParentID = @ParentID    
        )    
        BEGIN    
            --SELECT '400' AS returnCode, 'Image already exists for company' AS returnMessage;    
    UPDATE UploadImage    
    
     SET ImageName = @ImageName, Image = @Image    
    
    WHERE ParentPageType = @ParentPageType AND ParentID = @ParentID;    
  SELECT '200'  AS  returnCode ,'Logo Updated Successfully.' AS returnMessage ;     
        END    
        ELSE    
        BEGIN    
            -- Insert new record into UploadImage table    
            INSERT INTO UploadImage (ParentPageType, ParentID, ImageName, Image)    
            VALUES (@ParentPageType, @ParentID, @ImageName, @Image);    
                
            SELECT '200' AS returnCode, 'Logo Uploaded Successfully.' AS returnMessage;    
        END    
END    
    
ELSE IF @Action='U'    
    
BEGIN    
    
    -- Update existing image record in UploadImage table    
    
    UPDATE UploadImage    
    
    SET ImageName = @ImageName, Image = @Image    
    
    WHERE ParentPageType = @ParentPageType AND ParentID = @ParentID;    
     
    -- Return the updated records    
    
    --SELECT ID, ParentID, ParentPageType, ImageName, CAST(NULL AS VARBINARY) AS [Image]    
    
    --FROM UploadImage    
    
    --WHERE ParentPageType = @ParentPageType AND ParentID = @ParentID;    
    
  SELECT '200'  AS  returnCode ,'Logo Updated Successfully.' AS returnMessage ;     
    
END    
    
--ELSE IF @Action='S'    
    
--BEGIN      
    
--SELECT ID,ParentID,ParentPageType,ImageName,CAST(NULL AS VARBINARY) AS [Image]    
--FROM UploadImage      
    
--WHERE ParentPageType=@ParentPageType And ParentID=@ParentID    
--   WHERE  ParentPageType = 1 AND (@ParentID  IS NULL OR @ParentID  = 0 OR ParentID  = @ParentID )     
-- SELECT '200'  AS  returnCode ,'Data Retrieved Successfully' AS returnMessage ;     
    
--END    
    
    
--filter logic    
ELSE IF @Action='S'    
BEGIN      
    SELECT     
        ID,    
        ParentID,    
        ParentPageType,    
        ImageName,    
         Image    
    FROM UploadImage      
    WHERE     
        (ParentPageType = @ParentPageType or @ParentPageType is null or @ParentPageType = 0)  
        AND (    
            @ParentID IS NULL     
            OR @ParentID = 0     
            OR ParentID = @ParentID    
        )    
    SELECT '200' AS returnCode, 'Data Retrieved Successfully' AS returnMessage;     
END    
    
END    
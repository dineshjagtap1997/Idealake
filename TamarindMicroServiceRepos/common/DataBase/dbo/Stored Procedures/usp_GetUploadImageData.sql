create PROCEDURE [dbo].[usp_GetUploadImageData]
 (
 @ParentID int,
 @ParentPageType int
 )
 AS
 BEGIN
 SELECT ID,ParentID,ParentPageType,ImageName,[Image]
 FROM UploadImage 
 WHERE ParentID=@ParentID AND ParentPageType=@ParentPageType
 
 END

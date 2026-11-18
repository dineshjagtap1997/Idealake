      
--=====================================================          
--Author  :Pooja          
--Modify Date :29 April 2011          
--Reason  :Added a column inthe select clause          
--=====================================================          
Create PROCEDURE [dbo].[usp_GetGuideServices]          
@Active bit          
AS          
BEGIN          
 if(@Active=1)          
 BEGIN          
  SELECT Code, Name,ShortDescription,DetailedDescription,IsActive,IsPreferred,          
  ImageExists=CASE WHEN EXISTS (select ID from UploadImage Where ParentPageType=1 and ParentID=Code) THEN 1          
      ELSE 0 END           
  FROM GuideServices           
  WHERE IsActive=1         
  ORDER BY  Name           
          
            
  SELECT Top 1 ID,ParentID,ParentPageType,ImageName,[Image]            
  FROM UploadImage          
            
 END          
 ELSE          
 BEGIN          
  SELECT Code, Name,ShortDescription,DetailedDescription,IsActive,IsPreferred,           
  ImageExists=CASE WHEN EXISTS (select ID from UploadImage Where ParentPageType=1 and ParentID=Code) THEN 1          
      ELSE 0 END           
  FROM GuideServices         
  ORDER BY  Name         
            
  SELECT Top 1 ID,ParentID,ParentPageType,ImageName,[Image]            
  FROM UploadImage          
 END          
END 
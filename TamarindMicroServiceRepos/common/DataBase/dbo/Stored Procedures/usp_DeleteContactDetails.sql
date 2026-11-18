CREATE PROCEDURE [dbo].[usp_DeleteContactDetails]  
(  
@ContactDetailsID int  
)  
AS  
BEGIN  
  
DELETE FROM ContactDetails WHERE ContactDetailsID=@ContactDetailsID  
  
END  
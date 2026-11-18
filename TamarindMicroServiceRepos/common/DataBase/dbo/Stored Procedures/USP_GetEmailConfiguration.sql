  
-- =============================================                      
-- Author:  Shweta                      
-- Create date: 6 July 2011                    
-- Description: Get Email Configuration                       
-- =============================================                
CREATE PROCEDURE [dbo].[USP_GetEmailConfiguration]                
AS                
BEGIN                
SELECT EmailTemplateID,FromEmailAddress,ToEmailAddress,[Subject],EmailBody,Operation,OperationBy,                
OperationOn,EmailCategory,              
CASE WHEN EmailCategory=1 THEN 'New User Creation'              
WHEN EmailCategory=2 THEN 'Change Password'              
WHEN EmailCategory =3 THEN 'New Agent Registration Request'              
WHEN EmailCategory=4 THEN 'Login IDs for Agent'              
WHEN EmailCategory=5 THEN 'Send Request for Contacts Edit'              
WHEN EmailCategory=6 THEN 'Send Request for Monuments'             
WHEN EmailCategory=7 THEN 'Missing ROE'              
WHEN EmailCategory=8 THEN 'Email For Agent Approval'        
WHEN EmailCategory=9 THEN 'Outstanding Email'     
WHEN EmailCategory=10 THEN 'File Unlock Request'  
WHEN EmailCategory=11 THEN 'XO Unlock Request'      
 END AS 'EmailCategoryText'              
,E.DocumentID,UD.DocumentName  , E.CCEmailAddress             
from Email_Configuration  E      
LEFT JOIN UploadDocuments UD ON UD.DocumentID=E.DocumentID               
END 
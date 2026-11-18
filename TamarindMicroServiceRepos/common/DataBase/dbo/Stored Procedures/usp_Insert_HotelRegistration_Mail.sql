CREATE PROCEDURE [dbo].[usp_Insert_HotelRegistration_Mail]            
(           
 @FromEmail varchar(255),  
 @ToEmail varchar(255),  
 @CCEmail varchar(255),  
 @EmailSubject varchar(500),  
 @EmailBody varchar(8000),  
 @OperationBy uniqueidentifier,  
 @id INT OUTPUT  
)            
            
as            
            
Begin             
Insert into HotelRegistration_Mail         
( FromEmail, ToEmail, CcEmail, EmailSubject, EmailBody, CreatedDate, Createdby) values( @FromEmail, @ToEmail, @CCEmail, @EmailSubject, @EmailBody, getdate(), @OperationBy)     

Select '200' as returnCode, 'New Record Added Successfully' as returnMessage
End 
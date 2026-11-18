      
CREATE PROCEDURE [dbo].[usp_Insert_VendorRegistration_Mail]          
(        	
	@FromEmail varchar(255),
	@ToEmail varchar(255),
	@CCEmail varchar(255),
	@EmailSubject varchar(500),
	@EmailBody varchar(8000),
	@ReasonForAddingVendor varchar(500),
	@VendorService varchar(500),
	@AccountGroupCode varchar(50),
	@AccountGroupName varchar(200),
	@OperationBy uniqueidentifier,
	@id INT OUTPUT
)          
          
as          
          
Begin           
Insert into VendorRegistration_Mail       
(          
		fromEmail, toEmail, ccEmail, emailSubject, emailBody, 
		ReasonForAddingVendor,VendorService,AccountGroupCode,AccountGroupName,
createdDate, createdby
) values( @FromEmail, @ToEmail, @CCEmail, @EmailSubject, @EmailBody,
		  @ReasonForAddingVendor,@VendorService,@AccountGroupCode,@AccountGroupName,
 getdate(), @OperationBy)   

		Select '200' as returnCode, 'New Record Added Successfully' as returnMessage


End 


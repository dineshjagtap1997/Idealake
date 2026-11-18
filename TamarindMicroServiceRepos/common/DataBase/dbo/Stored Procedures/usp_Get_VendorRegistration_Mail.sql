CREATE PROCEDURE [dbo].[usp_Get_VendorRegistration_Mail]          
(          
	@VendorRegID int=0,
	@Action char(1)=''

)         
as        
Begin   
	IF(@Action='S')
		BEGIN
			select 
				VendorRegID,
				VendorRegID as RequestID,
				fromEmail as EmailFrom,
				isnull(toEmail ,'')
				+
				ISNULL(
					';' + CAST((SELECT TOP 1 CCEmailAddress 
								FROM Email_Configuration 
								WHERE EmailCategory = 4) AS VARCHAR(500)), 
					''
				) 
				as EmailTo,
				emailSubject as Subject,
				emailBody , 
				ccEmail 
				AS EmailCC,
				createdDate,
				createdby as OperationBy,
				IsMailSent,
				emailSubject as Subject,
				createdByName,
				VendorService,
				AccountGroupCode,
				AccountGroupName,
				ReasonForAddingVendor
			from 
				VendorRegistration_Mail 
			where VendorRegID = @VendorRegID
		END

End
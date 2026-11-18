CREATE PROCEDURE [dbo].[usp_Get_HotelRegistration_Mail]          
(          
	@CustRegID int=0,
	@Action char(1)=''

)         
as        
Begin   
	IF(@Action='S')
		BEGIN
			select 
				HotelRegID,
				HotelRegID as RequestID,
				fromEmail as EmailFrom,
				isnull(toEmail,'') 
				+
				ISNULL(
					';' + CAST((SELECT TOP 1 CCEmailAddress 
								FROM Email_Configuration 
								WHERE EmailCategory = 3) AS VARCHAR(500)), 
					''
				) 
				as EmailTo,
				ccEmail 
				AS EmailCC,
				createdDate,
				createdby as OperationBy,
				IsMailSent,
				subject as Subject,
				createdByName,
				createdby as OperationBy
			from 
				HotelRegistration_Mail 
			where HotelRegID = @CustRegID
		END

End
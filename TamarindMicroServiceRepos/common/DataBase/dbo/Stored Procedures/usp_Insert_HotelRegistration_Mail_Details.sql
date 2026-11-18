CREATE PROCEDURE [dbo].[usp_Insert_HotelRegistration_Mail_Details]          
(        
	@Action char(1)='',
	@RequestID	int=0	,
	@HotelName	nvarchar	(	510)='',
	@LegalName	nvarchar	(	510)='',
	@HotelRatingID	int	=0,
	@HotelTypeID	int	=0,
	@LegalEntTypeID	int	=0,
	@HotelGroupIATACode	char	(	4)='',
	@CustomHotelGroup	nvarchar	(	600)='',
	@HotelPostalAddress	nvarchar	(	4000)='',
	@Country	nvarchar	(	510)='',
	@State	nvarchar	(	510)='',
	@CustomState	nvarchar	(	510)='',
	@City	nvarchar	(	510)='',
	@CustomCity	nvarchar	(	510)='',
	@PostalCode	nvarchar	(	20)='',
	@ISDCode	int=0,
	@STDCode	nvarchar	(	14)='',
	@ContactNumber	nvarchar	(	40)='',
	@Website	nvarchar	(	500)='',
	@EmailID	nvarchar	(	500)='',
	@NoOfHotelRooms	int=0	,
	@RoomCategoryNames	nvarchar	(	1000)='',
	@PAN	nvarchar	(	30)='',
	@GST	nvarchar	(	36)='',
	@TAN	nvarchar	(	30)='',
	@MSMEType	nvarchar	(	20)='',
	@MSME_No	nvarchar	(	60)='',
	@UDYAMNo	nvarchar	(	40)='',
	@AccountName	nvarchar	(	500)='',
	@AccountNumber	nvarchar	(	500)='',
	@BankName	nvarchar	(	500)='',
	@IFSC	nvarchar	(	500)='',
	@BankBranch	nvarchar	(	1000)='',
	@CancelBankChequeFileName	nvarchar	(	510)='',
	@GSTFileName	nvarchar	(	510)='',
	@PANFileName	nvarchar	(	510)='',
	@TANFileName	nvarchar	(	510)='',
	@MSMEFileName	nvarchar	(	510)='',
	@VATFileName	nvarchar	(	510)='',
	@VAT	nvarchar	(	50)='',
	@SEZ_Unit	bit	=0,
	@createdby	nvarchar	(	510)='',
	--@ManagementDeptDetailJSON NVARCHAR(MAX)='', 
	--@FinanceDeptDetailJSON NVARCHAR(MAX)='',
	@RegistrationDeptDetailJSON nvarchar(MAX)='', 
	@id INT OUTPUT
)          
as          
Begin   
	--IF(@Action='I')
		BEGIN
			--DECLARE @strBankName nvarchar(500)='';
			--SET @strBankName=(SELECT TOP 1 BankName FROM BankMaster WHERE BankID=@BankName)

			Insert into HotelRegistration_Mail_Details
			(          
				RequestID,
				HotelName,
				LegalName,
				HotelRatingID,
				HotelTypeID,
				--LegalEntTypeID,
				HotelGroupIATACode,
				CustomHotelGroup,
				HotelPostalAddress,
				Country,
				State,
				CustomState,
				City,
				CustomCity,
				PostalCode,
				ISDCode,
				STDCode,
				ContactNumber,
				Website,
				EmailID,
				NoOfHotelRooms,
				RoomCategoryNames,
				PAN,
				GST,
				TAN,
				MSMEType,
				MSME_No,
				UDYAMNo,
				AccountName,
				AccountNumber,
				BankName,
				IFSC,
				BankBranch,
				CancelBankChequeFileName,
				GSTFileName,
				PANFileName,
				TANFileName,
				MSMEFileName,
				VATFileName,
				VAT,
				SEZ_Unit,
				createdDate,
				createdby
			)
			VALUES
			(
				@RequestID,
				@HotelName,
				@LegalName,
				@HotelRatingID,
				@HotelTypeID,
				--LegalEntTypeID,
				@HotelGroupIATACode,
				@CustomHotelGroup,
				@HotelPostalAddress,
				@Country,
				@State,
				@CustomState,
				@City,
				@CustomCity,
				@PostalCode,
				@ISDCode,
				@STDCode,
				@ContactNumber,
				@Website,
				@EmailID,
				@NoOfHotelRooms,
				@RoomCategoryNames,
				@PAN,
				@GST,
				@TAN,
				@MSMEType,
				@MSME_No,
				@UDYAMNo,
				@AccountName,
				@AccountNumber,
				@BankName,
				@IFSC,
				@BankBranch,
				@CancelBankChequeFileName,
				@GSTFileName,
				@PANFileName,
				@TANFileName,
				@MSMEFileName,
				@VATFileName,
				@VAT,
				@SEZ_Unit,
				GETDATE(),
				@createdby
			)

			set @id = scope_identity()

			Update HotelRegistration_Mail set IsMailSent=1 WHERE HotelRegID=@RequestID

			--DELETE FROM RegistrationDept_Mail_Details WHERE RequestID=@RequestId AND RegType='Hotel'

			DECLARE @RegType nvarchar(500),
					@RegRequestID int,
					@DeptName nvarchar(200),
					@Name nvarchar(200),
					@Designation	nvarchar(200),
					@MCountryCode nvarchar(10),
					@MobileNumber nvarchar(20),
					@RegEmailID	nvarchar(400),
					@createdDate	datetime,
					@operationBy	uniqueidentifier

			If Isnull(@RegistrationDeptDetailJSON, '') <> '' 			
				BEGIN
					DECLARE RegistrationDeptDetail_Cursor CURSOR FOR
						SELECT 
							RegType,
							RequestID,
							DeptName,
							Name,
							Designation,
							MCountryCode,
							MobileNumber,
							EmailID,
							createdDate,
							operationBy
						FROM OPENJSON(@RegistrationDeptDetailJSON)
						WITH (
							RegType	nvarchar(500),
							RequestID int,
							DeptName nvarchar(200),
							Name nvarchar(200),
							Designation	nvarchar(200),
							MCountryCode nvarchar(10),
							MobileNumber nvarchar(20),
							EmailID	nvarchar(400),
							createdDate	datetime,
							operationBy	uniqueidentifier
						);

						Print 'Json1';

						OPEN RegistrationDeptDetail_Cursor;
						FETCH NEXT FROM RegistrationDeptDetail_Cursor INTO 
						@RegType,@RegRequestID,@DeptName,@Name,@Designation,@MCountryCode,@MobileNumber,@RegEmailID,@createdDate,@operationBy;

						WHILE @@FETCH_STATUS = 0
						BEGIN
							INSERT INTO RegistrationDept_Mail_Details
							(
								RegType,
								RequestID,
								DeptName,
								Name,
								Designation,
								MCountryCode,
								MobileNumber,
								EmailID,
								createdDate,
								operationBy
							)
							VALUES
							(
								@RegType,@RegRequestID,@DeptName,@Name,@Designation,@MCountryCode,@MobileNumber,@RegEmailID,@createdDate,@operationBy
							)
							FETCH NEXT FROM RegistrationDeptDetail_Cursor INTO 
							@RegType,@RegRequestID,@DeptName,@Name,@Designation,@MCountryCode,@MobileNumber,@RegEmailID,@createdDate,@operationBy;
						END

						CLOSE RegistrationDeptDetail_Cursor;
						DEALLOCATE RegistrationDeptDetail_Cursor;
				END;

			SELECT
				HotelRegDetID,
				RequestID,
				HotelName,
				LegalName,
				HotelRatingID,
				HotelTypeID,
				--LegalEntTypeID,
				HotelGroupIATACode,
				CustomHotelGroup,
				HotelPostalAddress,
				Country,
				State,
				CustomState,
				City,
				CustomCity,
				PostalCode,
				ISDCode,
				STDCode,
				ContactNumber,
				Website,
				EmailID,
				NoOfHotelRooms,
				RoomCategoryNames,
				PAN,
				GST,
				TAN,
				MSMEType,
				MSME_No,
				UDYAMNo,
				AccountName,
				AccountNumber,
				BankName,
				IFSC,
				BankBranch,
				CancelBankChequeFileName,
				GSTFileName,
				PANFileName,
				TANFileName,
				MSMEFileName,
				VATFileName,
				VAT,
				SEZ_Unit,
				createdDate,
				createdby,
				(SELECT TOP 1 CODE FROM HotelRating WHERE ID=HRMD.HotelRatingID) as HotelRating,
				(SELECT TOP 1 TypeValue FROM HotelTypeMaster WHERE HotelTypeID=HRMD.HotelTypeID) as HotelType,
				(SELECT TOP 1 Name FROM HotelGroups WHERE IATACode=HRMD.HotelGroupIATACode) as HotelGroup,
				(
					SELECT
						RegDeptID,
						RegType,
						RequestID,
						DeptName,
						Name,
						Designation,
						MCountryCode,
						MobileNumber,
						EmailID,
						createdDate,
						operationBy
					FROM
						RegistrationDept_Mail_Details
					WHERE
						RequestID=@RequestId
						AND RegType='Hotel'
						AND DeptName='Management'
					FOR JSON PATH
				)
				AS ManagementDeptDetailJSON,
				(
					SELECT
						RegDeptID,
						RegType,
						RequestID,
						DeptName,
						Name,
						Designation,
						MCountryCode,
						MobileNumber,
						EmailID,
						createdDate,
						operationBy
					FROM
						RegistrationDept_Mail_Details
					WHERE
						RequestID=@RequestId
						AND RegType='Hotel'
						AND DeptName='Finance'
					FOR JSON PATH
				)
				AS FinanceDeptDetailJSON
			FROM
				HotelRegistration_Mail_Details HRMD
			WHERE 
				HotelRegDetID=@id
		END
End
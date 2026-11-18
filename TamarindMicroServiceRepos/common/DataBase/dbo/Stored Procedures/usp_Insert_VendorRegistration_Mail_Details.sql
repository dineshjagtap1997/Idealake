CREATE PROCEDURE [dbo].[usp_Insert_VendorRegistration_Mail_Details]          
(        
	@Action char(1)='',
	@RequestID	int=0	,
	@VendorName	nvarchar	(	510)='',
	@LegalName	nvarchar	(	510)='',
	@VendorPostalAddress	nvarchar	(	4000)='',

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
	@VendorService varchar(500)='',
	@AccountGroupName varchar(200)='',
	@ReasonForAddingVendor varchar(500)='',

	@createdby	nvarchar	(	510)='',
	--@ManagementDeptDetailJSON NVARCHAR(MAX)='', 
	--@FinanceDeptDetailJSON NVARCHAR(MAX)='',
	@RegistrationDeptDetailJSON nvarchar(MAX)='', 
	@id INT=0 OUTPUT
)          
as          
Begin   
	--IF(@Action='I')
		BEGIN
			--DECLARE @strBankName nvarchar(500)='';
			--SET @strBankName=(SELECT TOP 1 BankName FROM BankMaster WHERE BankID=@BankName)

			Insert into VendorRegistration_Mail_Details
			(          
				RequestID,
				VendorName,
				LegalName,
				--LegalEntTypeID,
				VendorPostalAddress,
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
				VendorService,
				AccountGroupName,
				ReasonForAddingVendor,
				createdDate,
				createdby
			)
			VALUES
			(
				@RequestID,
				@VendorName,
				@LegalName,
				--LegalEntTypeID,
				@VendorPostalAddress,
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
				@VendorService,
				@AccountGroupName,
				@ReasonForAddingVendor,
				GETDATE(),
				@createdby
			)

			set @id = scope_identity()

			Update VendorRegistration_Mail set IsMailSent=1 WHERE VendorRegID=@RequestID

			--DELETE FROM RegistrationDept_Mail_Details WHERE RequestID=@RequestId AND RegType='Vendor'

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
				VendorRegDetID,
				RequestID,
				VendorName,
				LegalName,
				--LegalEntTypeID,
				VendorPostalAddress,
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
				VendorService,
				AccountGroupName,
				ReasonForAddingVendor,
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
						AND RegType='Vendor'
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
						AND RegType='Vendor'
						AND DeptName='Finance'
					FOR JSON PATH
				)
				AS FinanceDeptDetailJSON
			FROM
				VendorRegistration_Mail_Details HRMD
			WHERE 
				VendorRegDetID=@id
		END
End

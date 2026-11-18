CREATE PROCEDURE [dbo].[usp_Insert_CustRegistration_Mail_Details]          
(        
	@Action char(1)='',
	@RequestID int=0,
	@TradeName nvarchar(255)='',
	@LegalName nvarchar(255)='',
	@BillingAddress nvarchar(max)='',
	@Country nvarchar(255)='',
	@State nvarchar(255)='',
	@CustomState nvarchar(255)='',
	@City nvarchar(255)='',
	@CustomCity nvarchar(255)='',
	@PostalCode nvarchar(20)='',
	@PAN nvarchar(15)='',
	@GST nvarchar(15)='',
	@TAN nvarchar(15)='',
	@SEZ_Unit bit=0,
	@AccountName nvarchar(250)='',
	@AccountNumber nvarchar(250)='',
	@BankName nvarchar(250)='',
	@IFSC nvarchar(250)='',
	@ContactNumber nvarchar(20)='',
	@EmailID nvarchar(250)='',
	@GSTFileName nvarchar(255)='',
	@PANFileName nvarchar(255)='',
	@TANFileName nvarchar(255)='',
	@VAT nvarchar(20)='',
	@VATFileName nvarchar(255)='',
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

			Insert into CustRegistration_Mail_Details
			(          
				RequestID, TradeName, LegalName, BillingAddress, Country, State, CustomState, City, CustomCity, PostalCode, PAN,
				GST, TAN, SEZ_Unit, AccountName, AccountNumber, BankName, IFSC, ContactNumber, EmailID, agentClassification,
				marketAssigned, tamSalesRep, creditApplicable, creditAllowance,creditCurrency,createdby,
				GSTFileName,PANFileName,TANFileName, createdDate,
				VAT, VATFileName
			)
			SELECT
			   @RequestID, @TradeName,@LegalName, @BillingAddress, @Country, @State,
			   @CustomState,@City,@CustomCity,@PostalCode, @PAN,@GST,@TAN,@SEZ_Unit,
			   @AccountName,@AccountNumber,@BankName,@IFSC,@ContactNumber,@EmailID,
			   isnull(CAST(agentClassification AS nvarchar(50)), ''),
			   isnull(CAST(marketAssigned AS nvarchar(50)), ''),
			   isnull(CAST(tamSalesRep AS nvarchar(50)), ''),
			   isnull(CAST(IsCreditApplicable AS nvarchar(5)), ''),
			   isnull(CAST(creditAllowance AS nvarchar(50)), ''),
			   isnull(CAST(creditCurrency AS nvarchar(50)), ''),
			   isnull(CAST(createdByName AS nvarchar(100)), ''),
			   @GSTFileName,@PANFileName,@TANFileName,getdate(), @VAT,@VATFileName
			FROM 
				CustomerRegistration_Mail
			WHERE 
				CustRegID=@RequestID

			set @id = scope_identity()

			Update CustomerRegistration_Mail set IsMailSent=1 WHERE CustRegID=@RequestID

			--DELETE FROM RegistrationDept_Mail_Details WHERE RequestID=@RequestId AND RegType='Customer'

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
				RequestID, TradeName, LegalName, BillingAddress, Country, State, CustomState, City, CustomCity, PostalCode, PAN,
				GST, TAN, SEZ_Unit, AccountName, AccountNumber, BankName, IFSC, ContactNumber, EmailID, agentClassification,
				marketAssigned, tamSalesRep, creditApplicable, creditAllowance,creditCurrency,GSTFileName,PANFileName,TANFileName, createdDate,
				VAT, VATFileName,
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
						AND RegType='Customer'
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
						AND RegType='Customer'
						AND DeptName='Finance'
					FOR JSON PATH
				)
				AS FinanceDeptDetailJSON,
				'200' as returnCode 
			FROM
				CustRegistration_Mail_Details
			WHERE 
				CustRegDetID=@id
		END
End

CREATE PROCEDURE [dbo].[usp_ContactDetails_tab_VendorMaster] (
	@ParentID INT = '',
	@TypeID TINYINT = '',
	@IsPrimaryContact BIT = '',
	@SalutationID INT = '',
	@FirstName VARCHAR(50) = '',
	@LastName VARCHAR(50) = '',
	@DesignationOrDepartment VARCHAR(100) = '',
	@EmailID VARCHAR(200) = '',
	@OfficeNo VARCHAR(20) = '',
	@MobileNo VARCHAR(20) = '',
	@FaxNo VARCHAR(20) = '',
	@DateofBirth DATETIME = '',
	@CityIATACode VARCHAR(13) = NULL,
	@InsertedDate DATETIME = '',
	@IsActive TINYINT = '',
	@IsAccStatement BIT = '',
	@IsCC BIT = 0,
	@IsForContracting BIT = 0,
	@IsBills BIT = 0,
	@CreatedBy UNIQUEIDENTIFIER = NULL,
	@Action CHAR(2) = '',
	@ContactDetailsID INT = ''
)
AS
BEGIN
	-- Check if record exists based on ParentID, FirstName, LastName, and MobileNo
	IF @Action = 'I'
	BEGIN
		IF EXISTS (
			SELECT 1
			FROM ContactDetails
			WHERE ParentID = @ParentID
			AND FirstName = @FirstName
			AND LastName = @LastName
			AND MobileNo = @MobileNo
		)
		BEGIN
			-- If the record exists, return a message indicating duplication
			SELECT '400' AS returnCode, 'Duplicate record found' as returnMessage;
		END
		ELSE
		BEGIN
			-- If no duplicate, insert the new record
			INSERT INTO ContactDetails (
				ParentID, TypeID, IsPrimaryContact, SalutationID, FirstName, LastName,
				DesignationOrDepartment, EmailID, OfficeNo, MobileNo, FaxNo, DateofBirth,
				CityIATACode, IsActive, IsAccStatement, IsCC, IsForContracting, InsertedDate,
				IsBills, CreatedBy
			)
			VALUES (
				@ParentID, @TypeID, @IsPrimaryContact, @SalutationID, @FirstName, @LastName,
				@DesignationOrDepartment, @EmailID, @OfficeNo, @MobileNo, @FaxNo, @DateofBirth,
				@CityIATACode, @IsActive, @IsAccStatement, @IsCC, @IsForContracting, GETDATE(),
				@IsBills, @CreatedBy
			)

			SELECT '200' AS returnCode, 'Data Inserted' as returnMessage;
		END
	END
	ELSE IF @Action = 'U'
	BEGIN
		-- Check if the record exists based on ContactDetailsID and the criteria
		IF EXISTS (
			SELECT ContactDetailsID
			FROM ContactDetails
			WHERE ContactDetailsID = @ContactDetailsID
		)
		BEGIN
			-- Update the record if it exists
			UPDATE ContactDetails
			SET TypeID = @TypeID,
				IsPrimaryContact = @IsPrimaryContact,
				SalutationID = @SalutationID,
				FirstName = @FirstName,
				LastName = @LastName,
				DesignationOrDepartment = @DesignationOrDepartment,
				EmailID = @EmailID,
				OfficeNo = @OfficeNo,
				MobileNo = @MobileNo,
				FaxNo = @FaxNo,
				DateofBirth = @DateofBirth,
				CityIATACode = @CityIATACode,
				IsActive = @IsActive,
				IsAccStatement = @IsAccStatement,
				IsCC = @IsCC,
				IsForContracting = @IsForContracting,
				UpdatedOn = GETDATE(),
				IsBills = @IsBills,
				UpdatedBy = @CreatedBy
			WHERE ContactDetailsID = @ContactDetailsID

			SELECT '200' AS returnCode, 'Data Updated' as returnMessage;
		END
		ELSE
		BEGIN
			-- If the record doesn't exist, check if it exists based on ParentID, FirstName, LastName, and MobileNo
			IF EXISTS (
				SELECT 1
				FROM ContactDetails
				WHERE ParentID = @ParentID
				AND FirstName = @FirstName
				AND LastName = @LastName
				AND MobileNo = @MobileNo
			)
			BEGIN
				SELECT '400' AS returnCode, 'Duplicate record found' as returnMessage;
			END
			ELSE
			BEGIN
				-- If no duplicate, insert a new record
				INSERT INTO ContactDetails (
					ParentID, TypeID, IsPrimaryContact, SalutationID, FirstName, LastName,
					DesignationOrDepartment, EmailID, OfficeNo, MobileNo, FaxNo, DateofBirth,
					CityIATACode, IsActive, IsAccStatement, IsCC, IsForContracting, InsertedDate,
					IsBills, CreatedBy
				)
				VALUES (
					@ParentID, @TypeID, @IsPrimaryContact, @SalutationID, @FirstName, @LastName,
					@DesignationOrDepartment, @EmailID, @OfficeNo, @MobileNo, @FaxNo, @DateofBirth,
					@CityIATACode, @IsActive, @IsAccStatement, @IsCC, @IsForContracting, GETDATE(),
					@IsBills, @CreatedBy
				)

				SELECT '200' AS returnCode, 'Data Updated' as returnMessage;
			END
		END
	END
	ELSE IF @Action = 'S'
	BEGIN
		-- Select records based on the conditions
		SELECT 
			ContactDetailsID,
			ParentID,
			TypeID,
			IsPrimaryContact,
			SalutationID,
			FirstName,
			LastName,
			DesignationOrDepartment,
			EmailID,
			OfficeNo,
			MobileNo,
			FaxNo,
			DateofBirth,
			CityIATACode,
			IsActive,
			IsAccStatement,
			IsCC,
			IsForContracting,
			IsBills,
			InsertedDate,
			CreatedBy
		FROM ContactDetails WITH (NOLOCK)
		WHERE (@ParentID IS NULL OR ParentID = @ParentID)
			AND (@TypeID IS NULL OR TypeID = @TypeID)
			AND (@FirstName IS NULL OR FirstName LIKE '%' + @FirstName + '%')
			AND (@LastName IS NULL OR LastName LIKE '%' + @LastName + '%')
			AND (@DesignationOrDepartment IS NULL OR DesignationOrDepartment LIKE '%' + @DesignationOrDepartment + '%')
			AND (@EmailID IS NULL OR EmailID = @EmailID)
			AND (@OfficeNo IS NULL OR OfficeNo = @OfficeNo)
			AND (@MobileNo IS NULL OR MobileNo = @MobileNo)
			AND (@FaxNo IS NULL OR FaxNo = @FaxNo)
			AND (@DateofBirth IS NULL OR DateofBirth = @DateofBirth)
			AND (@CityIATACode IS NULL OR CityIATACode = @CityIATACode)
			AND (@IsActive IS NULL OR IsActive = @IsActive)
			AND (@IsAccStatement IS NULL OR IsAccStatement = @IsAccStatement)
			AND (@IsCC IS NULL OR IsCC = @IsCC)
	END
END

CREATE PROCEDURE [dbo].[ManageContact]
(
    @Action CHAR(2),
    @ContactID INT = NULL,
    @IsPrimaryContact VARCHAR(3) = NULL,
    @PrimaryContactID INT = NULL,
    @Reference TEXT = NULL,
    @RelationToPrimaryContact VARCHAR(15) = NULL,
    @Gender CHAR(1) = NULL,
    @Name VARCHAR(255) = NULL,
    @Surname VARCHAR(255) = NULL,
    @Email VARCHAR(255) = NULL,
    @AlternateEmail VARCHAR(255) = NULL,
    @Mobile VARCHAR(20) = NULL,
    @AlternateMobile VARCHAR(20) = NULL,
    @Address TEXT = NULL,
    @AddressCountry VARCHAR(100) = NULL,
    @AddressState VARCHAR(100) = NULL,
    @StateCode VARCHAR(10) = NULL,
    @AddressCity VARCHAR(100) = NULL,
    @PostalCode VARCHAR(20) = NULL,
    @Nationality VARCHAR(100) = NULL,
    @DateOfBirth DATE = NULL,
    @PassportNo VARCHAR(100) = NULL,
    @PassportDateOfIssue DATE = NULL,
    @PassportPlaceOfIssue VARCHAR(100) = NULL,
    @PassportDateOfExpiry DATE = NULL,
    @PAN VARCHAR(20) = NULL,
    @MealPreference VARCHAR(10) = NULL,
    @Allergies TEXT = NULL,
    @Promotions BIT = 1,
    @SpecialRequirements TEXT = NULL,
    @SeniorCitizen CHAR(1) = NULL,
    @Tags VARCHAR(10) = NULL,
    @CustCategory VARCHAR(20) = NULL,
    @Organization VARCHAR(255) = NULL,
    @Designation VARCHAR(255) = NULL,
    @FlightClassPreference VARCHAR(20) = NULL,
    @IsCustomer BIT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ReturnCode NVARCHAR(3),
            @ReturnMessage NVARCHAR(MAX);

    BEGIN TRY
        --IF @Action = 'I' 
        --BEGIN
        --    -- Check if record already exists
        --    IF EXISTS (SELECT 1 FROM Contacts WHERE Email = @Email AND Mobile = @Mobile)
        --    BEGIN
        --        SELECT '201' AS ReturnCode, 'This data already exists. Please check and try again' AS ReturnMessage;
        --        RETURN;
        --    END

        --    -- Insert Operation
        --    INSERT INTO Contacts (
        --        IsPrimaryContact, PrimaryContactID, Reference, RelationToPrimaryContact, Gender, Name, Surname,
        --        Email, AlternateEmail, Mobile, AlternateMobile, Address, AddressCountry, AddressState, StateCode,
        --        AddressCity, PostalCode, Nationality, DateOfBirth, PassportNo, PassportDateOfIssue, PassportPlaceOfIssue,
        --        PassportDateOfExpiry, PAN, MealPreference, Allergies, Promotions, SpecialRequirements, SeniorCitizen,
        --        Tags, CustCategory, Organization, Designation, FlightClassPreference, IsCustomer
        --    ) VALUES (
        --        @IsPrimaryContact, @PrimaryContactID, @Reference, @RelationToPrimaryContact, @Gender, @Name,
        --        @Surname, @Email, @AlternateEmail, @Mobile, @AlternateMobile, @Address, @AddressCountry,
        --        @AddressState, @StateCode, @AddressCity, @PostalCode, @Nationality, @DateOfBirth, @PassportNo,
        --        @PassportDateOfIssue, @PassportPlaceOfIssue, @PassportDateOfExpiry, @PAN, @MealPreference,
        --        @Allergies, COALESCE(@Promotions, 1), @SpecialRequirements, @SeniorCitizen, @Tags,
        --        @CustCategory, @Organization, @Designation, @FlightClassPreference, @IsCustomer
        --    );
		IF @Action = 'I' 
BEGIN
    -- Check if record already exists
    IF EXISTS (SELECT 1 FROM Contacts WHERE Email = @Email AND Mobile = @Mobile)
    BEGIN
        SELECT '201' AS ReturnCode, 'This data already exists. Please check and try again' AS ReturnMessage;
        RETURN;
    END
 
    -- Conditional Insert based on @IsCustomer
    IF @IsCustomer = 0
    BEGIN
        INSERT INTO Contacts (Name, AddressCity, Email, Mobile)
        VALUES (@Name, @AddressCity, @Email, @Mobile);
    END
    ELSE
    BEGIN
        INSERT INTO Contacts (
            IsPrimaryContact, PrimaryContactID, Reference, RelationToPrimaryContact, Gender, Name, Surname,
            Email, AlternateEmail, Mobile, AlternateMobile, Address, AddressCountry, AddressState, StateCode,
            AddressCity, PostalCode, Nationality, DateOfBirth, PassportNo, PassportDateOfIssue, PassportPlaceOfIssue,
            PassportDateOfExpiry, PAN, MealPreference, Allergies, Promotions, SpecialRequirements, SeniorCitizen,
            Tags, CustCategory, Organization, Designation, FlightClassPreference, IsCustomer
        ) VALUES (
            @IsPrimaryContact, @PrimaryContactID, @Reference, @RelationToPrimaryContact, @Gender, @Name,
            @Surname, @Email, @AlternateEmail, @Mobile, @AlternateMobile, @Address, @AddressCountry,
            @AddressState, @StateCode, @AddressCity, @PostalCode, @Nationality, @DateOfBirth, @PassportNo,
            @PassportDateOfIssue, @PassportPlaceOfIssue, @PassportDateOfExpiry, @PAN, @MealPreference,
            @Allergies, COALESCE(@Promotions, 1), @SpecialRequirements, @SeniorCitizen, @Tags,
            @CustCategory, @Organization, @Designation, @FlightClassPreference, @IsCustomer
        );
    END


            SELECT '200' AS ReturnCode, 'New record added successfully' AS ReturnMessage;
        END
        ELSE IF @Action = 'S'
        BEGIN
            -- Select Operation
            SELECT * FROM Contacts WHERE ContactID = @ContactID;
            SELECT '200' AS ReturnCode, 'Data retrieved successfully' AS ReturnMessage;
        END
        ELSE IF @Action = 'U'
        BEGIN
            -- Update Operation
            UPDATE Contacts
            SET IsPrimaryContact = @IsPrimaryContact,
                PrimaryContactID = @PrimaryContactID,
                Reference = @Reference,
                RelationToPrimaryContact = @RelationToPrimaryContact,
                Gender = @Gender,
                Name = @Name,
                Surname = @Surname,
                Email = @Email,
                AlternateEmail = @AlternateEmail,
                Mobile = @Mobile,
                AlternateMobile = @AlternateMobile,
                Address = @Address,
                AddressCountry = @AddressCountry,
                AddressState = @AddressState,
                StateCode = @StateCode,
                AddressCity = @AddressCity,
                PostalCode = @PostalCode,
                Nationality = @Nationality,
                DateOfBirth = @DateOfBirth,
                PassportNo = @PassportNo,
                PassportDateOfIssue = @PassportDateOfIssue,
                PassportPlaceOfIssue = @PassportPlaceOfIssue,
                PassportDateOfExpiry = @PassportDateOfExpiry,
                PAN = @PAN,
                MealPreference = @MealPreference,
                Allergies = @Allergies,
                Promotions = @Promotions,
                SpecialRequirements = @SpecialRequirements,
                SeniorCitizen = @SeniorCitizen,
                Tags = @Tags,
                CustCategory = @CustCategory,
                Organization = @Organization,
                Designation = @Designation,
                FlightClassPreference = @FlightClassPreference,
                IsCustomer = @IsCustomer
            WHERE ContactID = @ContactID;

            SELECT '200' AS ReturnCode, 'Record updated successfully' AS ReturnMessage;
        END
        ELSE
        BEGIN
            THROW 50000, 'Invalid Action. Use I for Insert, S for Select, U for Update', 1;
        END
    END TRY
    BEGIN CATCH
        SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;

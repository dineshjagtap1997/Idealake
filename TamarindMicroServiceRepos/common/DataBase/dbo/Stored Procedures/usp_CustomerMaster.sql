CREATE PROCEDURE [dbo].[usp_CustomerMaster]    
(    
    @Action CHAR(2),    
    @LeadID NVARCHAR(50) = NULL,    
    @CustomerCode NVARCHAR(50) = NULL,    
    @Refererralname TEXT = NULL,    
    @Gender CHAR(1) = NULL,    
    @FirstName VARCHAR(255) = NULL,    
    @LastName VARCHAR(255) = NULL,    
    @Fullname VARCHAR(255) = NULL,    
    @Email VARCHAR(255) = NULL,    
    @SalesRep INT = NULL,    
    @Mobile VARCHAR(20) = NULL,    
    @Address TEXT = NULL,    
    @Country VARCHAR(100) = NULL,    
    @StateID INT = NULL,    
    @StateCode VARCHAR(10) = NULL,    
    @CityID INT = NULL,    
    @PostalCode VARCHAR(20) = NULL,    
    @NationalityID INT = NULL,    
    @DateOfBirth DATE = NULL,    
    @PassportNo VARCHAR(100) = NULL,    
    @PassportDateOfIssue DATE = NULL,    
    @PassportPlaceOfIssue VARCHAR(100) = NULL,    
    @PassportDateOfExpiry DATE = NULL,    
    @PAN VARCHAR(20) = NULL,    
    @PANName VARCHAR(255) = NULL,    
    @TAN VARCHAR(20) = NULL,    
    @MealPlanID INT = NULL,    
    @Allergies TEXT = NULL,    
    @SpecialRequirements TEXT = NULL,    
    @SeniorCitizen CHAR(1) = NULL,    
    @Organization VARCHAR(255) = NULL,    
    @Designation VARCHAR(255) = NULL,    
    @FlightClassPreference VARCHAR(20) = NULL,    
    @IsCustomer BIT = NULL,    
    @CurrentAge INT = NULL,    
    @CustomerType VARCHAR(255) = NULL,    
    @SAPCompCode VARCHAR(255) = NULL,    
    @CID INT = NULL,    
    @OperationBy UNIQUEIDENTIFIER = NULL,    
<<<<<<< HEAD
<<<<<<< HEAD
  @CountryName VARCHAR(255) = NULL  
  --@PageNumber BIGINT=NULL,  
 -- @PageSize INT=NULL  
    
=======
    @CountryName VARCHAR(255) = NULL  
>>>>>>> dev
=======
    @CountryName VARCHAR(255) = NULL  
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
)    
AS    
BEGIN    
    SET NOCOUNT ON;    
    
    DECLARE @ReturnCode NVARCHAR(3),    
            @ReturnMessage NVARCHAR(MAX);    
    
    IF @Action = 'I'    
    BEGIN    
        IF EXISTS (SELECT 1 FROM customer WHERE Email = @Email AND Mobile = @Mobile)    
        BEGIN    
            SELECT '201' AS returnCode, 'This Customer already exists. Please check and try again.' AS returnMessage;    
            RETURN;    
        END    
    
        IF @IsCustomer = 1    
        BEGIN    
<<<<<<< HEAD
<<<<<<< HEAD
            SET @CustomerCode = 'DC' + RIGHT('0000000' + CAST((SELECT ISNULL(CustID, 0) + 1 FROM tbl_Counter) AS VARCHAR(10)), 25);    
=======
            SET @CustomerCode = 'DC' + RIGHT('00000000' + CAST((SELECT ISNULL(CustID, 0) + 1 FROM tbl_Counter) AS VARCHAR(10)), 8);    
>>>>>>> dev
=======
            SET @CustomerCode = 'DC' + RIGHT('00000000' + CAST((SELECT ISNULL(CustID, 0) + 1 FROM tbl_Counter) AS VARCHAR(10)), 8);    
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
            UPDATE tbl_Counter SET CustID = CAST(RIGHT(@CustomerCode, 5) AS BIGINT), UpdationDate = GETDATE();    
    
            INSERT INTO customer (    
                Refererralname, Gender, FirstName, LastName, Fullname, Email, SalesRep, Mobile, Address, Country,    
                StateID, StateCode, CityID, PostalCode, NationalityID, DateOfBirth, PassportNo, PassportDateOfIssue,    
                PassportPlaceOfIssue, PassportDateOfExpiry, PAN, PANname, TAN, MealPlanID, Allergies,    
                SpecialRequirements, SeniorCitizen, Organization, Designation, FlightClassPreference, IsCustomer,    
                CurrentAge, CustomerType, SAPCompCode, CustomerCode, CreatedBy, CreatedOn    
            )    
            VALUES (    
                @Refererralname, @Gender, @FirstName, @LastName, @Fullname, @Email, @SalesRep, @Mobile, @Address, @Country,    
                @StateID, @StateCode, @CityID, @PostalCode, @NationalityID, @DateOfBirth, @PassportNo, @PassportDateOfIssue,    
                @PassportPlaceOfIssue, @PassportDateOfExpiry, @PAN, @PANname, @TAN, @MealPlanID, @Allergies,    
                @SpecialRequirements, @SeniorCitizen, @Organization, @Designation, @FlightClassPreference, @IsCustomer,    
                @CurrentAge, @CustomerType, @SAPCompCode, @CustomerCode, @OperationBy, GETDATE()    
            );    
        END    
        ELSE    
        BEGIN    
<<<<<<< HEAD
<<<<<<< HEAD
            SET @LeadID = 'CL' + RIGHT('0000000' + CAST((SELECT ISNULL(LeadID, 0) + 1 FROM tbl_Counter) AS VARCHAR(10)), 25);    
=======
            SET @LeadID = 'CL' + RIGHT('00000000' + CAST((SELECT ISNULL(LeadID, 0) + 1 FROM tbl_Counter) AS VARCHAR(10)), 8); 
>>>>>>> dev
=======
            SET @LeadID = 'CL' + RIGHT('00000000' + CAST((SELECT ISNULL(LeadID, 0) + 1 FROM tbl_Counter) AS VARCHAR(10)), 8); 
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
            UPDATE tbl_Counter SET LeadID = CAST(RIGHT(@LeadID, 5) AS BIGINT), UpdationDate = GETDATE();    
    
            INSERT INTO customer (Fullname, Email, Mobile, IsCustomer, LeadID, CityID)    
            VALUES (@Fullname, @Email, @Mobile, @IsCustomer, @LeadID, @CityID);    
<<<<<<< HEAD
<<<<<<< HEAD
   END    
    
        SELECT '200' AS returnCode, 'New record added successfully.' AS returnMessage, SCOPE_IDENTITY() AS ID;    
=======
        END    
    
        SELECT '200' AS returnCode, 'New record added successfully.' AS returnMessage, SCOPE_IDENTITY() AS ID,@CustomerCode as CustomerCode;    
>>>>>>> dev
=======
        END    
    
        SELECT '200' AS returnCode, 'New record added successfully.' AS returnMessage, SCOPE_IDENTITY() AS ID,@CustomerCode as CustomerCode;    
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    END    
    
    ELSE IF @Action = 'U'    
    BEGIN    
        IF NOT EXISTS (SELECT 1 FROM customer WHERE UPPER(CustomerCode) LIKE '%DC%' AND CID = @CID)    
        BEGIN    
<<<<<<< HEAD
<<<<<<< HEAD
            SET @CustomerCode = 'DC' + RIGHT('0000000' + CAST((SELECT ISNULL(CustID, 0) + 1 FROM tbl_Counter) AS VARCHAR(10)), 25);    
=======
            SET @CustomerCode = 'DC' + RIGHT('00000000' + CAST((SELECT ISNULL(CustID, 0) + 1 FROM tbl_Counter) AS VARCHAR(10)), 8);    
>>>>>>> dev
=======
            SET @CustomerCode = 'DC' + RIGHT('00000000' + CAST((SELECT ISNULL(CustID, 0) + 1 FROM tbl_Counter) AS VARCHAR(10)), 8);    
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
            UPDATE tbl_Counter SET CustID = CAST(RIGHT(@CustomerCode, 5) AS BIGINT), UpdationDate = GETDATE();    
        END    
    
        UPDATE customer    
        SET Refererralname = @Refererralname,    
            Gender = @Gender,    
            FirstName = @FirstName,    
            LastName = @LastName,    
            Fullname = @Fullname,    
            Email = @Email,    
            SalesRep = @SalesRep,    
            Mobile = @Mobile,    
            Address = @Address,    
            Country = @Country,    
            StateID = @StateID,    
            StateCode = @StateCode,    
            CityID = @CityID,    
            PostalCode = @PostalCode,    
            NationalityID = @NationalityID,    
            DateOfBirth = @DateOfBirth,    
            PassportNo = @PassportNo,    
            PassportDateOfIssue = @PassportDateOfIssue,    
            PassportPlaceOfIssue = @PassportPlaceOfIssue,    
            PassportDateOfExpiry = @PassportDateOfExpiry,    
            PAN = @PAN,    
            PANname = @PANname,    
            TAN = @TAN,    
            MealPlanID = @MealPlanID,    
            Allergies = @Allergies,    
            SpecialRequirements = @SpecialRequirements,    
            SeniorCitizen = @SeniorCitizen,    
            Organization = @Organization,    
            Designation = @Designation,    
            FlightClassPreference = @FlightClassPreference,    
            IsCustomer = @IsCustomer,    
            CurrentAge = @CurrentAge,    
            CustomerType = @CustomerType,    
            SAPCompCode = @SAPCompCode,    
            CustomerCode = @CustomerCode,    
<<<<<<< HEAD
<<<<<<< HEAD
             
=======
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
            modifiedBy = @OperationBy,    
            ModifiedOn = GETDATE()    
        WHERE CID = @CID;    
    
<<<<<<< HEAD
<<<<<<< HEAD
        SELECT '200' AS returnCode, 'Record updated successfully.' AS returnMessage, @CID AS ID;    
=======
        SELECT '200' AS returnCode, 'Record updated successfully.' AS returnMessage, @CID AS ID,@CustomerCode as CustomerCode;    
>>>>>>> dev
=======
        SELECT '200' AS returnCode, 'Record updated successfully.' AS returnMessage, @CID AS ID,@CustomerCode as CustomerCode;    
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    END    
    
    ELSE IF @Action = 'S'    
    BEGIN    
<<<<<<< HEAD
<<<<<<< HEAD
        SELECT *, C.Name AS CityName    
  , CO.Name as CountryName    
        FROM customer CM    
        INNER JOIN City C ON C.ID = CM.CityID    
        LEFT JOIN Country CO ON  CO.IATACode = CM.Country    
        WHERE (@CID IS NULL OR @CID = 0 OR CID = @CID)    
		AND CM.Fullname like '%'+ @Fullname +'%'
		
        ORDER BY 1 DESC  
   --OFFSET (@PageNumber - 1) * @PageSize ROWS     FETCH NEXT @PageSize ROWS ONLY;  
    END    
    
    ELSE IF @Action = 'EX'    
    BEGIN    
        SELECT CustomerCode, Refererralname, Gender, FirstName, LastName, Fullname, Email, SalesRep, Mobile, Address,    
               CM.PostalCode, DateOfBirth, PassportNo, PassportDateOfIssue, PassportPlaceOfIssue, PassportDateOfExpiry,    
               PAN, PANname, TAN, Allergies, SpecialRequirements, SeniorCitizen, Organization, Designation,    
               FlightClassPreference,    
               CASE WHEN IsCustomer = 1 THEN 'Yes' WHEN IsCustomer = 0 THEN 'No' END AS IsCustomer,    
               CurrentAge, CustomerType, SAPCompCode, CO.Name as CountryName, LeadID, C.Name AS CityName    
        FROM customer CM    
        INNER JOIN City C ON C.ID = CM.CityID    
        LEFT JOIN Country CO ON CO.Name = CM.Country    
        WHERE (@CID IS NULL OR @CID = 0 OR CID = @CID)    
        ORDER BY 1 DESC;    
    END    
END 
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
        SELECT 
            CM.CID,
            CM.CustomerCode,
            CM.Refererralname,
            CM.Gender,
            CM.FirstName,
            CM.LastName,
            CM.Fullname,
            CM.Email,
            CM.SalesRep,
            CM.Mobile,
            CM.Address,
            CO.Name AS CountryName,
            S.Name AS StateName,
            C.Name AS CityName,
            CM.StateCode,
            CM.PostalCode,
            N.Nationality AS NationalityName,
            CM.DateOfBirth,
            CM.PassportNo,
            CM.PassportDateOfIssue,
            CM.PassportPlaceOfIssue,
            CM.PassportDateOfExpiry,
            CM.PAN,
            CM.PANname,
            CM.TAN,
            MP.Description AS MealPlanName,
            CM.Allergies,
            CM.SpecialRequirements,
            CM.SeniorCitizen,
            CM.Organization,
            CM.Designation,
            CM.FlightClassPreference,
            CM.IsCustomer,
            CM.CurrentAge,
            CM.CustomerType,
            CM.SAPCompCode,
            CM.LeadID,
            CM.CreatedBy,
            CM.CreatedOn,
            CM.modifiedBy,
            CM.ModifiedOn,
			ISNULL(S.State_ID,0) as State_ID,
			isnull(C.IATACode,'') as CityIATACode,
			isnull(CO.IATACode,'') as CountryIATACode,
			isnull(CM.NationalityID,0) as NationalityID,
			isnull(MP.ID,0) as MealPlanId,
			ISNULL(C.ID,0) AS CityID,
			ISNULL(S.StateCodeID,0) AS StateCodeID
        FROM customer CM    
        LEFT JOIN City C ON C.ID = CM.CityID    
        LEFT JOIN Country CO ON CO.IATACode = CM.Country OR CO.Name = CM.Country    
        LEFT JOIN State S ON S.State_ID = CM.StateID    
        LEFT JOIN Nationality N ON N.ID = CM.NationalityID    
        LEFT JOIN MealPlan MP ON MP.ID = CM.MealPlanID    
        WHERE (@CID IS NULL OR @CID = 0 OR CM.CID = @CID)    
            AND (@Fullname IS NULL OR CM.Fullname LIKE '%' + @Fullname + '%')
        ORDER BY CM.CID DESC    
    END    
    
ELSE IF @Action = 'EX'
BEGIN
    SELECT 
        CO.Name AS CountryName,
        CM.LeadID,
        CM.CustomerCode, 
        CM.Fullname, 
        CM.Gender, 
        CM.Email, 
        CM.Mobile, 
        CM.SalesRep AS SaleRep, -- Single source of truth
        CM.Address,
        S.Name AS StateName,
        C.Name AS CityName,
        CM.StateCode,
        CM.PostalCode, 
        N.Nationality AS NationalityName,
        CM.DateOfBirth, 
        CM.CurrentAge,
        CM.PassportNo,
        CM.FirstName,
        CM.LastName,
        CM.PassportDateOfIssue, 
        CM.PassportPlaceOfIssue, 
        CM.PassportDateOfExpiry,    
        CM.PAN, 
        CM.PANname, 
        CM.TAN, 
        MP.Description AS MealPlanName,
        CM.Allergies, 
        CM.SpecialRequirements, 
        CM.SeniorCitizen, 
        CM.Organization, 
        CM.Designation,    
        CM.FlightClassPreference,
        CM.Refererralname,
        CM.CustomerType,
        '' AS PassportDoc,
        '' AS PANDoc, 
        '' AS TANDoc,
        CM.SAPCompCode,
        @Action AS Action,
CASE WHEN CM.IsCustomer = 1 THEN 'Yes' ELSE 'No' END AS IsCustomerText    FROM customer CM    
    LEFT JOIN City C ON C.ID = CM.CityID    
    LEFT JOIN Country CO ON CO.Name = CM.Country OR CO.IATACode = CM.Country    
    LEFT JOIN State S ON S.StateCodeID = CM.StateID    
    LEFT JOIN Nationality N ON N.ID = CM.NationalityID    
    LEFT JOIN MealPlan MP ON MP.ID = CM.MealPlanID    
    WHERE (@CID IS NULL OR @CID = 0 OR CM.CID = @CID)    
    ORDER BY CM.CID DESC;    
END
END
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

create PROCEDURE [dbo].[usp_Employee_Master_bkp]                                        
(                                        
    @EmpID INT OUT,                                        
    @EmpCode VARCHAR(20) = null,                                 
    @UserID uniqueidentifier = NULL,                                        
    @RoleId INT = 0,                             
    @SalutationID INT = 0,                                     
    @Gender VARCHAR(10) = null,                                  
    @EmpName VARCHAR(200) = null,                                    
    @Address VARCHAR(MAX) = null,                                  
    @CityIATACode CHAR(3) = null,                                 
    @ResPhoneNo VARCHAR(15) = null,                                 
    @MobileNo VARCHAR(15) = null,                              
    @PersonalEmail VARCHAR(200) = null,                                   
    @CompanyID INT = 0,                                  
    @DateOfBirth DATETIME = null,                                      
    @DateOfJoining DATETIME = null,                                     
    @DateOfRetirement DATETIME = null,                                      
    @DesignationID INT = 0,                                   
    @DepartmentID NVARCHAR(500) = 0,                                         
    @ReportHeadID INT = 0,                                          
    @OffEmail VARCHAR(200) = null,                                     
    @OffPhone VARCHAR(15) = null,                                            
    @Pan VARCHAR(50) = null,                                          
    @IsActive BIT = 0,                                     
    @OperationBy uniqueidentifier = NULL,                                        
    @LevelID INT = NULL,                                        
    @IsSales BIT = 0,                                        
    @Action char(2) = '',                                     
    @IsRemembered BIT = 0,                                  
    @Level1UID INT = NULL,                                  
    @Level2UID INT = NULL,                                  
    @Level3UID INT = NULL,                                  
    @CreditNoteApp INT = NULL,                                  
    @AdvancesApp INT = NULL,                                  
    @UserName varchar(500) = NULL,                                  
    @Password varchar(max) = NULL,                              
    @MarketIDs VARCHAR(MAX) = null,                              
    @BusinessTypeIDs VARCHAR(MAX) = null,                              
    @CompanyIDs VARCHAR(MAX) = null,                              
    @YearID int = null,                              
    @ViewRights bit = 0,                              
    @AsPerAdminRules bit = 0                                 
)                                        
AS                                        
BEGIN                        
    DECLARE @MaxID INT; 
    SET @MaxID = (SELECT ISNULL(MAX(EmpID), 0) + 1 FROM EmployeeMaster);                      
    if @Action='I'                                        
    BEGIN                               
        IF EXISTS (SELECT EmpID FROM EmployeeMaster WHERE UPPER(EmpName) = UPPER(@EmpName))                            
        BEGIN                                        
            SELECT '201' AS returnCode, 'Employee name already exists. Please check and try again.' AS returnMessage;                                         
            SET @EmpID = 0;                                        
        END                       
        ELSE                                        
        BEGIN                                        
            DECLARE @NextEmpNumber INT;                      
            SELECT @NextEmpNumber = ISNULL(MAX(CAST(RIGHT(EmpCode, 6) AS INT)), 0) + 1            
            FROM EmployeeMaster            
            WHERE EmpCode LIKE 'EMP%' AND ISNUMERIC(RIGHT(EmpCode, 6)) = 1;            
            SET @EmpCode = 'EMP' + RIGHT('0000000' + CAST(@NextEmpNumber AS VARCHAR(7)), 7);                      
            INSERT INTO EmployeeMaster (                                        
                EmpCode, UserID, RoleId, SalutationID, Gender, EmpName, [Address],                       
                CityIATACode, ResPhoneNo, MobileNo, PersonalEmail, CompanyID, DateOfBirth,                                     
                DateOfJoining, DateOfRetirement, DesignationID, DepartmentID, ReportHeadID,                                        
                OffEmail, OffPhone, Pan, IsActive, Operation, OperationBy, OperationOn,                                        
                OldID, LevelID, IsSales, IsRemembered, Level1UID, Level2UID, Level3UID,                                  
                CreditNoteApp, AdvancesApp, UserName, Password                                  
            )                                        
            VALUES (                                        
                @EmpCode, COALESCE(@UserID,NEWID()), @RoleId, @SalutationID, @Gender, @EmpName, @Address,                                        
                @CityIATACode, @ResPhoneNo, @MobileNo, @PersonalEmail, @CompanyID, @DateOfBirth,                                        
                @DateOfJoining, @DateOfRetirement, @DesignationID, @DepartmentID, @ReportHeadID,                                        
                @OffEmail, @OffPhone, @Pan, @IsActive, 'Insert', @OperationBy, GETDATE(),                                        
                @MaxID, ISNULL(@LevelID, 0), @IsSales, @IsRemembered, @Level1UID,                                  
                @Level2UID, @Level3UID, @CreditNoteApp, @AdvancesApp, @UserName, @Password                                  
            );                                        
            SET @EmpID = @@IDENTITY;                                        
            if (@EmpID is not null or @EmpID != 0)                              
            begin                              
                exec usp_InsertEmployeeMarketMap  @EmpID = @EmpID, @MarketIDs = @MarketIDs;                               
                exec usp_InsertEmployeeBusinessType @EmpID = @EmpID, @BusinessTypeIDs = @BusinessTypeIDs;                              
                exec USP_INSERTEmployeeCompanyYearMap  @EmpID = @EmpID, @CompanyIDs = @CompanyIDs, @YearID = @YearID, @ViewRights = @ViewRights, @AsPerAdminRules = @AsPerAdminRules;                              
            end                              
            SELECT '200' AS returnCode, 'New record added successfully.' AS returnMessage, @EmpID AS id;                                         
        END                                        
    END            
    ELSE IF @Action='U'                                        
    BEGIN                       
        BEGIN TRY            
            UPDATE EmployeeMaster                                        
            SET EmpCode = @EmpCode, RoleId = @RoleId, SalutationID = @SalutationID, Gender = @Gender,                                        
                EmpName = @EmpName, [Address] = @Address, CityIATACode = @CityIATACode, ResPhoneNo = @ResPhoneNo,                                        
                MobileNo = @MobileNo, PersonalEmail = @PersonalEmail, CompanyID = @CompanyID, DateOfBirth = @DateOfBirth,                                        
                DateOfJoining = @DateOfJoining, DateOfRetirement = @DateOfRetirement, DesignationID = @DesignationID,                                        
                DepartmentID = @DepartmentID, ReportHeadID = @ReportHeadID, OffEmail = @OffEmail, OffPhone = @OffPhone,                                        
                Pan = @Pan, IsActive = @IsActive, Operation = 'Update', UpdatedOn = GETDATE(),                                      
                LevelID = ISNULL(@LevelID, 0), IsSales = @IsSales, IsRemembered = @IsRemembered,                                    
                Level1UID = @Level1UID, Level2UID = @Level2UID, Level3UID = @Level3UID,                                  
                AdvancesApp = @AdvancesApp, UserName = @UserName, CreditNoteApp = @CreditNoteApp, Password = @Password                                  
            WHERE EmpID = @EmpID;                                        
            UPDATE tbl_Counter            
            SET EmpCode = @EmpCode, UpdationDate = GETDATE();            
            EXEC usp_InsertEmployeeMarketMap @EmpID = @EmpID, @MarketIDs = @MarketIDs;                             
            EXEC usp_InsertEmployeeBusinessType @EmpID = @EmpID, @BusinessTypeIDs = @BusinessTypeIDs;                             
            EXEC USP_INSERTEmployeeCompanyYearMap @EmpID = @EmpID, @CompanyIDs = @CompanyIDs, @YearID = @YearID, @ViewRights = @ViewRights, @AsPerAdminRules = @AsPerAdminRules;                              
            SELECT '200' AS returnCode, 'Record updated successfully.' AS returnMessage, @EmpID AS ID;                                         
        END TRY            
        BEGIN CATCH            
            SELECT ERROR_NUMBER() AS returnCode, ERROR_MESSAGE() AS returnMessage;            
        END CATCH            
    END
ELSE IF @Action='S'                                        
BEGIN       
    WITH SplitDept AS (      
        SELECT e.EmpID, TRY_CAST(value AS INT) AS DepartmentID      
        FROM EmployeeMaster e      
        CROSS APPLY STRING_SPLIT(e.DepartmentID, ',')      
    )      
    , DepartmentAgg AS (      
        SELECT sd.EmpID, STRING_AGG(d.Dept_Name, ', ') AS DeptNames      
        FROM SplitDept sd      
        JOIN Department d ON d.ID = sd.DepartmentID      
        GROUP BY sd.EmpID      
    )      
    SELECT                             
        EM.EmpID, UserID, RoleId, EmpCode, Em.SalutationID, Gender,                   
        EmpName, Em.[Address] AS [Address], -- Fixed: Qualified with Em                       
        Em.CityIATACode, ResPhoneNo, MobileNo, PersonalEmail,                               
        isnull(Em.CompanyID,0) as CompanyID, Em.DesignationID,                               
        isnull(Em.ReportHeadID,0) as ReportHeadID, OffEmail, OffPhone, Pan,                               
        Em.IsActive, isnull(Em.IsSales,0) as IsSales, Em.OperationBy,                               
        Ct.Name AS City, St.Name AS [State], Cn.Name AS Country, desg.Desg_Name,                              
        ISNULL(DeptAgg.DeptNames, '') AS Dept_Name, isnull(Level1UID,0) as Level1UID,                            
        isnull(Level2UID,0) as Level2UID, isnull(Level3UID,0) as Level3UID,                              
        isnull(AdvancesApp,0) as 'AdvancesApp', UserName, em.Password,                              
        isnull(em.CreditNoteApp, 0) as 'CreditNoteApp',                              
        (SELECT STRING_AGG(CAST(BusinessTypeID AS VARCHAR), ',')                             
         FROM (SELECT DISTINCT BusinessTypeID FROM EmployeeBusinessTypeMap WHERE EmpID = em.EmpID) AS t) AS BusinessTypeIDs,                              
        (SELECT STRING_AGG(CAST(CompanyID AS VARCHAR), ',')                             
         FROM (SELECT DISTINCT CompanyID FROM EmployeeCompanyYearMap WHERE EmpID = em.EmpID) AS t) AS CompanyIDs,                              
        (SELECT STRING_AGG(CAST(MarketID AS VARCHAR), ',')                             
         FROM (SELECT DISTINCT MarketID FROM EmployeeMarketMap WHERE EmpID = em.EmpID) AS t) AS MarketIDs                              
    FROM EmployeeMaster Em       
    LEFT JOIN DepartmentAgg DeptAgg ON Em.EmpID = DeptAgg.EmpID      
    LEFT JOIN City Ct ON Em.CityIATACode = Ct.IATACode                              
    LEFT JOIN [State] St ON St.State_ID = Ct.State_IATACode                              
    LEFT JOIN Country Cn ON Cn.IATACode = St.Country_IATACode                              
    LEFT JOIN Designation Desg ON Desg.ID = Em.DesignationID   
    GROUP BY em.EmpID, UserID, RoleId, EmpCode, Em.SalutationID, Gender, EmpName, Em.[Address],             
             Em.CityIATACode, ResPhoneNo, MobileNo, PersonalEmail, Em.CompanyID, Em.DateOfBirth,                               
             DateOfJoining, DateOfRetirement, Em.DesignationID, Em.DepartmentID, Em.ReportHeadID,                               
             OffEmail, OffPhone, Pan, Em.IsActive, Em.IsSales, Em.OperationBy, Ct.Name, St.Name,                              
             Cn.Name, desg.Desg_Name, DeptAgg.DeptNames, Level1UID, Level2UID, Level3UID, AdvancesApp,                              
             UserName, em.Password, em.CreditNoteApp                              
    ORDER BY em.EmpID DESC;    
END                                        
ELSE IF @Action='EX'                                        
BEGIN                                        
    SELECT EmpCode, Gender, EmpName, Em.[Address] AS [Address], -- Fixed: Qualified with Em                       
           Em.CityIATACode, ResPhoneNo, MobileNo, PersonalEmail, OffEmail, OffPhone, Pan,                       
           CASE WHEN Em.IsActive = 1 THEN 'True' ELSE 'False' END AS IsActive,                              
           CASE WHEN IsSales = 1 THEN 'Yes' ELSE 'No' END AS IsSales,                              
           Ct.Name AS City, St.Name AS [State], Cn.Name AS Country, desg.Desg_Name, dept.Dept_Name,                              
           isnull(Level1UID,0) as Level1UID, isnull(Level2UID,0) as Level2UID,                              
           isnull(Level3UID,0) as Level3UID, UserName, em.Password                              
    FROM EmployeeMaster Em                              
    LEFT JOIN City Ct ON Em.CityIATACode = Ct.IATACode                              
    LEFT JOIN [State] St ON St.State_ID = Ct.State_IATACode                              
    LEFT JOIN Country Cn ON Cn.IATACode = St.Country_IATACode                              
    LEFT JOIN Designation Desg ON Desg.ID = Em.DesignationID                              
    LEFT JOIN Department Dept ON dept.ID = Em.DepartmentID                              
    WHERE (@EmpID = 0 OR @EmpID IS NULL OR @EmpID = em.EmpID)                  
      AND (@IsSales = 0 or @IsSales is null or @IsSales = em.IsSales)                  
    ORDER BY em.EmpID DESC;                                         
END                                             
END

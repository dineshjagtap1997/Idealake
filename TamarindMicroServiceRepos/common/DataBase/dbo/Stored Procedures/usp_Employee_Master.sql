CREATE PROCEDURE [dbo].[usp_Employee_Master]                                              
 (                                              
 @EmpID INT OUT                                              
 ,@EmpCode VARCHAR(20)       = null                                       
 ,@UserID uniqueidentifier= NULL                                              
 ,@RoleId INT           = 0                                   
 ,@SalutationID INT   = 0                                           
 ,-- 1                                                        
 @Gender VARCHAR(10)         = null                                        
 ,-- 0                                                         
 @EmpName VARCHAR(200)       = null                                          
 ,--  Mr HR                                                        
 @Address VARCHAR(MAX)         = null                                        
 ,-- 503 HOD                                                         
 @CityIATACode CHAR(3)          = null                                       
 ,--  BOM                                                           
 @ResPhoneNo VARCHAR(15)          = null                                       
 ,@MobileNo VARCHAR(15)             = null                                    
 ,-- 987654321                                                        
 @PersonalEmail VARCHAR(200)        = null                                         
<<<<<<< HEAD
<<<<<<< HEAD
 ,@CompanyID INT      = 0                                        
=======
 ,@CompanyID VARCHAR(MAX) = null                                       
>>>>>>> dev
=======
 ,@CompanyID VARCHAR(MAX) = null                                       
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
 ,--   1                                                        
 @DateOfBirth DATETIME     = null                                            
 ,@DateOfJoining DATETIME      = null                                           
 ,--   10/4/2011 12:00:00 AM                                                        
 @DateOfRetirement DATETIME     = null                                            
 ,@DesignationID INT     =0                                         
 ,--   3                                                        
<<<<<<< HEAD
<<<<<<< HEAD
 @DepartmentID NVARCHAR(500)    =0                                               
=======
 @DepartmentID NVARCHAR(500)    =null                                              
>>>>>>> dev
=======
 @DepartmentID NVARCHAR(500)    =null                                              
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
 ,--  1                                                        
 @ReportHeadID INT   =0                                                
 ,--   1                                                        
 @OffEmail VARCHAR(200)   = null                                           
 ,@OffPhone VARCHAR(15)  = null                                                  
 ,@Pan VARCHAR(50)    = null                                                
 ,@IsActive BIT   = 0                                           
 ,@OperationBy uniqueidentifier= NULL                                              
 ,-- f4a64e32-8b30-45ef-94c2-dc6286373d75                                                         
 @LevelID INT = NULL                                              
 ,--   1                                                        
 @IsSales BIT = 0                                              
 --,@ErrMsg VARCHAR(50) OUT                                              
 ,@Action char(2)=''                                           
 ,@IsRemembered BIT =0                                        
 ,@Level1UID INT = NULL                                        
 ,@Level2UID INT = NULL                                        
 ,@Level3UID INT = NULL                                        
 ,@CreditNoteApp INT = NULL                                        
   ,@AdvancesApp INT = NULL                                        
   ,@UserName varchar(500) = NULL                                        
   ,@Password varchar(max) =NULL,                                    
       @MarketIDs VARCHAR(MAX) = null,                                    
     @BusinessTypeIDs VARCHAR(MAX) = null,                                    
  @CompanyIDs VARCHAR(MAX) = null,                                    
  @YearID int = null,                                    
  @ViewRights bit = 0,                                    
  @AsPerAdminRules bit = 0         
  --@PageNumber BIGINT=NULL,          
 -- @PageSize INT=NULL          
 )                                              
AS                                         
BEGIN                              
DECLARE @MaxID INT; SET @MaxID = (SELECT ISNULL(MAX(EmpID), 0) + 1 FROM EmployeeMaster);                            
if @Action='I'                                              
BEGIN                                     
 IF EXISTS (                                              
   SELECT EmpID            
   FROM EmployeeMaster                                              
   WHERE UPPER(EmpName) = UPPER(@EmpName)                                              
   )                                  
 BEGIN                                              
 SELECT '201' AS returnCode, 'Employee name already exists. Please check and try again.'   AS returnMessage;                                               
  SET @EmpID = 0                                              
<<<<<<< HEAD
<<<<<<< HEAD
 END                             
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
 END 
 ELSE IF EXISTS (                                                  
   SELECT EmpID                
   FROM EmployeeMaster                                                  
   WHERE UPPER(EmpCode) = UPPER(@EmpCode)                                                  
   )                                      
 BEGIN                                                  
 SELECT '201' AS returnCode, 'Employee Code already exists. Please check and try again.'   AS returnMessage;                                                   
  SET @EmpID = 0                                                  
 END 
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
 ELSE                                              
 BEGIN                                              
  DECLARE @NextEmpNumber INT;                            
                            
-- Get the last numeric part and increment it                            
--SELECT @NextEmpNumber = ISNULL(MAX(CAST(SUBSTRING(EmpCode, 4, LEN(EmpCode)) AS INT)), 0) + 1                            
--FROM EmployeeMaster                            
--WHERE EmpCode LIKE 'EMP%';                            
                            
-- generating empcode                            
--SELECT @NextEmpNumber = ISNULL(MAX(CAST(RIGHT(EmpCode, 6) AS INT)), 0) + 1                            
--FROM EmployeeMaster                            
--WHERE EmpCode LIKE 'EMP%';                         
                  
                  
<<<<<<< HEAD
<<<<<<< HEAD
--(error resolved by sarthak regarding creating employee)                  
SELECT @NextEmpNumber = ISNULL(MAX(CAST(RIGHT(EmpCode, 6) AS INT)), 0) + 1                  
FROM EmployeeMaster                  
WHERE EmpCode LIKE 'EMP%' AND ISNUMERIC(RIGHT(EmpCode, 6)) = 1;                  
                  
                            
-- Format the new EmpCode with 7 digits                            
SET @EmpCode = 'EMP' + RIGHT('0000000' + CAST(@NextEmpNumber AS VARCHAR(7)), 7);                            
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
--(error resolved by sarthak regarding creating employee)  -- as discussed with clint (22-07-2025)                
--SELECT @NextEmpNumber = ISNULL(MAX(CAST(RIGHT(EmpCode, 6) AS INT)), 0) + 1                  
--FROM EmployeeMaster                  
--WHERE EmpCode LIKE 'EMP%' AND ISNUMERIC(RIGHT(EmpCode, 6)) = 1;                  
                  
                            
---- Format the new EmpCode with 7 digits                            
--SET @EmpCode = 'EMP' + RIGHT('0000000' + CAST(@NextEmpNumber AS VARCHAR(7)), 7);                            
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
                            
  INSERT INTO EmployeeMaster (                                              
   EmpCode                                              
   ,UserID                                             
   ,RoleId                                            
   ,SalutationID                                              
   ,Gender                                              
   ,EmpName                                              
   ,[Address]                             
   ,CityIATACode                                              
   ,ResPhoneNo                                              
   ,MobileNo                                              
   ,PersonalEmail                                              
   ,CompanyID                                              
   ,DateOfBirth                                           
   ,DateOfJoining                                              
   ,DateOfRetirement                                              
   ,DesignationID                                              
   ,DepartmentID                                              
   ,ReportHeadID                                              
   ,OffEmail                                              
   ,OffPhone                                              
   ,Pan                                    
   ,IsActive                                              
   ,Operation                                              
   ,OperationBy                                              
   ,OperationOn                                              
   ,OldID                                              
   ,LevelID                                              
   ,IsSales                               
   ,IsRemembered                                          
   ,Level1UID                                        
 ,Level2UID                                        
   ,Level3UID                                        
   ,CreditNoteApp                                        
   ,AdvancesApp                                        
   ,UserName                                        
   ,Password                                        
   )                                              
  VALUES (                             
   @EmpCode                                              
<<<<<<< HEAD
<<<<<<< HEAD
   ,COALESCE(@UserID,NEWID())                                              
=======
   ,COALESCE(@UserID,'5AE2DAE4-5778-4E3D-ADBA-DB1C69FEBF0B')                                              
>>>>>>> dev
=======
   ,COALESCE(@UserID,'5AE2DAE4-5778-4E3D-ADBA-DB1C69FEBF0B')                                              
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
   ,@RoleId                                            
   ,@SalutationID                                              
   ,@Gender                                         
   ,@EmpName                                              
   ,@Address                                              
   ,@CityIATACode                                              
   ,@ResPhoneNo                                              
   ,@MobileNo                                              
   ,@PersonalEmail                                              
<<<<<<< HEAD
<<<<<<< HEAD
   ,@CompanyID                                              
=======
   ,@CompanyIDs                                              
>>>>>>> dev
=======
   ,@CompanyIDs                                              
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
   ,@DateOfBirth                                              
   ,@DateOfJoining                                              
   ,@DateOfRetirement                  
   ,@DesignationID                                              
   ,@DepartmentID                                              
   ,@ReportHeadID                                              
   ,@OffEmail                                              
   ,@OffPhone                                              
   ,@Pan                                              
,@IsActive                                              
   ,'Insert'                                              
   ,@OperationBy                                              
   ,GETDATE()                                              
   ,@MaxID                                              
   ,ISNULL(@LevelID, 0)                                              
   ,@IsSales                                        
   ,@IsRemembered                                          
,@Level1UID                                        
   ,@Level2UID                                        
   ,@Level3UID                                        
   ,@CreditNoteApp                                        
   ,@AdvancesApp                                        
   ,@UserName                                        
   ,@Password                                        
  )                                              
                                              
  SET @EmpID = @@IDENTITY                                              
                                         
  if (@EmpID is not null or @EmpID != 0)                                    
  begin                                    
  exec usp_InsertEmployeeMarketMap  @EmpID = @EmpID,    @MarketIDs = @MarketIDs                                     
  exec usp_InsertEmployeeBusinessType @EmpID = @EmpID, @BusinessTypeIDs = @BusinessTypeIDs                                    
                                        
  end                                    
  SELECT '200' AS returnCode, 'New record added successfully.'   AS returnMessage, @EmpID AS id , @EmpCode as EmpCode;                                               
 END                                              
END                  
ELSE IF @Action='U'                                              
BEGIN                             
    BEGIN TRY                  
        -- Update EmployeeMaster (including CreditNoteApp)                  
        UPDATE EmployeeMaster                                              
        SET                   
            EmpCode = @EmpCode,                                              
            RoleId = @RoleId,                                            
          SalutationID = @SalutationID,                                              
            Gender = @Gender,                                              
            EmpName = @EmpName,                                              
            [Address] = @Address,                                              
            CityIATACode = @CityIATACode,             
            ResPhoneNo = @ResPhoneNo,                                              
            MobileNo = @MobileNo,                                              
            PersonalEmail = @PersonalEmail,                                              
<<<<<<< HEAD
<<<<<<< HEAD
            CompanyID = @CompanyID,                                              
=======
            CompanyID = @CompanyIDs,                                              
>>>>>>> dev
=======
            CompanyID = @CompanyIDs,                                              
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
            DateOfBirth = @DateOfBirth,                                              
            DateOfJoining = @DateOfJoining,                                              
            DateOfRetirement = @DateOfRetirement,                                              
            DesignationID = @DesignationID,                                              
            DepartmentID = @DepartmentID,                                              
            ReportHeadID = @ReportHeadID,                                              
            OffEmail = @OffEmail,                                   
            OffPhone = @OffPhone,                                              
            Pan = @Pan,                                    
            IsActive = @IsActive,                                              
            Operation = 'Update',                                              
            UpdatedOn = GETDATE(),                                            
            LevelID = ISNULL(@LevelID, 0),                                              
            IsSales = @IsSales,                                              
            IsRemembered = @IsRemembered,                                          
            Level1UID = @Level1UID,                                        
            Level2UID = @Level2UID,                                        
            Level3UID = @Level3UID,                                        
            AdvancesApp = @AdvancesApp,                                        
            UserName = @UserName,                    
            CreditNoteApp = @CreditNoteApp,  -- Ensure this line is present                  
   Password = @Password                                        
        WHERE EmpID = @EmpID;                                              
                                       
        -- Fixed: Update tbl_Counter column (replace "EmpCodeColumn" with actual column name)                  
        --UPDATE tbl_Counter                               
        --SET EmpCode = RIGHT(@EmpCode, 5),  -- Fix column name here                  
        --    UpdationDate = GETDATE();                       
  UPDATE tbl_Counter                  
SET EmpCode = @EmpCode,                  
    UpdationDate = GETDATE();                  
                  
                              
        -- Update mappings                  
        EXEC usp_InsertEmployeeMarketMap @EmpID = @EmpID, @MarketIDs = @MarketIDs;                                   
        EXEC usp_InsertEmployeeBusinessType @EmpID = @EmpID, @BusinessTypeIDs = @BusinessTypeIDs;                                   
                  
        SELECT '200' AS returnCode, 'Record updated successfully.' AS returnMessage, @EmpID AS ID,  @EmpCode as EmpCode;                                               
    END TRY                  
    BEGIN CATCH                  
        -- Return error details                  
        SELECT                   
            ERROR_NUMBER() AS returnCode,                   
            ERROR_MESSAGE() AS returnMessage;                  
    END CATCH                  
                  
-- --END                                              
END--U                                             
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
<<<<<<< HEAD
<<<<<<< HEAD
        isnull(Em.CompanyID,0) as CompanyID, Em.DesignationID,                                     
=======
        isnull(Em.CompanyID,0) as CompanyIDs, Em.DesignationID,                                     
>>>>>>> dev
=======
        isnull(Em.CompanyID,0) as CompanyIDs, Em.DesignationID,                                     
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
        isnull(Em.ReportHeadID,0) as ReportHeadID, OffEmail, OffPhone, Pan,                                     
        Em.IsActive, isnull(Em.IsSales,0) as IsSales, Em.OperationBy, 
		EM.DepartmentID,
        Ct.Name AS City, St.Name AS [State], Cn.Name AS Country, desg.Desg_Name,                                    
        ISNULL(DeptAgg.DeptNames, '') AS Dept_Name, isnull(Level1UID,0) as Level1UID,                                  
        isnull(Level2UID,0) as Level2UID, isnull(Level3UID,0) as Level3UID,                                    
        isnull(AdvancesApp,0) as 'AdvancesApp', UserName, em.Password,                                    
<<<<<<< HEAD
<<<<<<< HEAD
        isnull(em.CreditNoteApp, 0) as 'CreditNoteApp',                                    
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
        isnull(em.CreditNoteApp, 0) as 'CreditNoteApp',
		 -- EmpName for AdvancesApp reference (mapping to another EmpID)
        (SELECT COALESCE(EmpName, '') 
         FROM EmployeeMaster 
         WHERE EmpID = Em.AdvancesApp AND Em.AdvancesApp > 0) AS AdvancesAppName,

        -- EmpName for CreditNoteApp reference (mapping to another EmpID)
        (SELECT COALESCE(EmpName, '') 
         FROM EmployeeMaster 
         WHERE EmpID = Em.CreditNoteApp AND Em.CreditNoteApp > 0) AS CreditNoteAppName,
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
        (SELECT STRING_AGG(CAST(BusinessTypeID AS VARCHAR), ',')                                   
         FROM (SELECT DISTINCT BusinessTypeID FROM EmployeeBusinessTypeMap WHERE EmpID = em.EmpID) AS t) AS BusinessTypeIDs,                                    
        --(SELECT STRING_AGG(CAST(CompanyID AS VARCHAR), ',')                                   
        -- FROM (SELECT DISTINCT CompanyID FROM EmployeeCompanyYearMap WHERE EmpID = em.EmpID) AS t) AS CompanyIDs,                                    
        (SELECT STRING_AGG(CAST(MarketID AS VARCHAR), ',')                                   
         FROM (SELECT DISTINCT MarketID FROM EmployeeMarketMap WHERE EmpID = em.EmpID) AS t) AS MarketIDs                                    
    FROM EmployeeMaster Em             
    LEFT JOIN DepartmentAgg DeptAgg ON Em.EmpID = DeptAgg.EmpID            
    LEFT JOIN City Ct ON Em.CityIATACode = Ct.IATACode                                    
    LEFT JOIN [State] St ON St.State_ID = Ct.State_IATACode                                    
    LEFT JOIN Country Cn ON Cn.IATACode = St.Country_IATACode                                    
    LEFT JOIN Designation Desg ON Desg.ID = Em.DesignationID    
 WHERE   
 (@EmpID=0 OR @EmpID=NULL OR Em.EmpID=@EmpID)  
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
 SELECT                                     
 --Em.EmpCode                   
   -- UserID,                                     
   -- RoleId,                                     
    EmpCode,                       
    Gender,                                     
    EmpName,                                     
    [Address],                                     
    Em.CityIATACode,                                     
    ResPhoneNo,                                     
    MobileNo,                                     
    PersonalEmail,                       
    --Em.CompanyID,                                     
    --COALESCE(Em.DateOfBirth, '1990-01-01') as DateOfBirth,                  
    --COALESCE(Em.DateOfJoining, '1990-01-01')  as DateOfJoining,                                     
       --COALESCE(Em.DateOfRetirement, '1990-01-01')  as DateOfRetirement,                                       
   -- Em.DesignationID,                                    
   -- Em.DepartmentID,                                     
    --isnull(Em.ReportHeadID,0) as ReportHeadID,                                     
    OffEmail,                                     
    OffPhone,                                     
    Pan,                             
 CASE                       
  WHEN Em.IsActive = 1 THEN 'True'                      
  WHEN Em.IsActive = 0 THEN 'False'                      
  END AS IsActive,                                    
             
 CASE                       
  WHEN IsSales = 1 THEN 'Yes'                      
  WHEN IsSales = 0 THEN 'No'                      
  END AS IsSales,                                    
    --Em.OperationBy,                                     
    Ct.Name AS City,                                     
    St.Name AS [State],                                     
    Cn.Name AS Country,                                     
    desg.Desg_Name,                                     
    dept.Dept_Name,                                    
    isnull(Level1UID,0) as Level1UID,                                  
    isnull(Level2UID,0) as Level2UID,                                    
    isnull(Level3UID,0) as Level3UID,                                    
    --isnull(AdvancesApp,0) as 'AdvancesApp',                                    
    UserName,                                    
    em.Password                                    
    --,isnull(em.CreditNoteApp, 0) as 'CreditNoteApp'                                    
                                  
    -- Using a subquery to remove duplicates before aggregating                                  
    --,(SELECT STRING_AGG(CAST(BusinessTypeID AS VARCHAR), ',')                                   
    -- FROM (SELECT DISTINCT BusinessTypeID FROM EmployeeBusinessTypeMap WHERE EmpID = em.EmpID) AS t) AS BusinessTypeIDs,                      
    --(SELECT STRING_AGG(CAST(CompanyID AS VARCHAR), ',')                                   
    -- FROM (SELECT DISTINCT CompanyID FROM EmployeeCompanyYearMap WHERE EmpID = em.EmpID) AS t) AS CompanyIDs,                                    
                                  
    --(SELECT STRING_AGG(CAST(MarketID AS VARCHAR), ',')                                   
    -- FROM (SELECT DISTINCT MarketID FROM EmployeeMarketMap WHERE EmpID = em.EmpID) AS t) AS MarketIDs                                    
                                  
FROM EmployeeMaster Em                                    
LEFT JOIN City Ct ON Em.CityIATACode = Ct.IATACode                                    
LEFT JOIN [State] St ON St.State_ID = Ct.State_IATACode                                    
LEFT JOIN Country Cn ON Cn.IATACode = St.Country_IATACode                                    
LEFT JOIN Designation Desg ON Desg.ID = Em.DesignationID                                    
LEFT JOIN Department Dept ON dept.ID = Em.DepartmentID                                    
WHERE (@EmpID = 0 OR @EmpID IS NULL OR @EmpID = em.EmpID)                        
and (@IsSales = 0 or @IsSales is null or @IsSales = em.IsSales)                        GROUP BY                                    
    em.EmpID, UserID, RoleId, EmpCode, Em.SalutationID, Gender, EmpName, [Address],                                     
    Em.CityIATACode, ResPhoneNo, MobileNo, PersonalEmail, Em.CompanyID, Em.DateOfBirth,                                     
    DateOfJoining, DateOfRetirement, Em.DesignationID, Em.DepartmentID, Em.ReportHeadID,                                     
    OffEmail, OffPhone, Pan, Em.IsActive, Em.IsSales, Em.OperationBy, Ct.Name, St.Name,                             
    Cn.Name, desg.Desg_Name, dept.Dept_Name, Level1UID, Level2UID, Level3UID, AdvancesApp,                                    
    UserName, em.Password, em.CreditNoteApp        
ORDER BY em.EmpID DESC;                                  
                                  
                                  
                                               
END                                                   
<<<<<<< HEAD
<<<<<<< HEAD
END
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
END



<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

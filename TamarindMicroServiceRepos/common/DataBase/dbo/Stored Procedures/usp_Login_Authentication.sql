
CREATE PROCEDURE [dbo].[usp_Login_Authentication] @UserId VARCHAR(500) = 'Null'
	,@Password NVARCHAR(MAX) = NULL
	,@LoginCount VARCHAR(MAX) = NULL
	,@LoginAttempts VARCHAR(MAX) = NULL
	,@UserName VARCHAR(500) = NULL
	,@IsRemembered BIT = 0
	,@CompanyID INT = NULL
	,@BusinessTypeIDs INT = NULL
	,@DepartmentID NVARCHAR = NULL
	,@DepartmentName VARCHAR(max) = NULL
	,@BusinessTypeName VARCHAR(MAX) = NULL
AS
BEGIN
	DECLARE @attempts INT
		,@ReturnCode NVARCHAR(3)
		,@ReturnMessage NVARCHAR(MAX)
		,@IsLockedOut BIT
<<<<<<< HEAD
<<<<<<< HEAD
		,@IsActive BIT;
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
		,@IsActive BIT; 





<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

	IF EXISTS (
			SELECT 1
			FROM EmployeeMaster
			WHERE UserName COLLATE SQL_Latin1_General_CP1_CS_AS = @UserName COLLATE SQL_Latin1_General_CP1_CS_AS
			)
	BEGIN
		SELECT @IsLockedOut = IsLockedOut
			,@IsActive = IsActive
			,@attempts = FailedPasswordAttemptCount
		FROM EmployeeMaster
<<<<<<< HEAD
<<<<<<< HEAD
		WHERE UserName COLLATE SQL_Latin1_General_CP1_CS_AS = @UserName COLLATE SQL_Latin1_General_CP1_CS_AS;
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
		WHERE UserName COLLATE SQL_Latin1_General_CP1_CS_AS = @UserName COLLATE SQL_Latin1_General_CP1_CS_AS;  



<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

		-- Corrected logic: Check for locked account first  
		IF @IsLockedOut = 1
		BEGIN
			SET @ReturnCode = '203';
			SET @ReturnMessage = 'You have reached the maximum of 3 attempts. Your account is locked. Please contact the admin to unlock it.';
		END
		ELSE IF @IsActive = 0
		BEGIN
			SET @ReturnCode = '204';
			SET @ReturnMessage = 'Unauthorised User';
		END
		ELSE IF EXISTS (
				SELECT 1
				FROM EmployeeMaster
				WHERE UserName COLLATE SQL_Latin1_General_CP1_CS_AS = @UserName COLLATE SQL_Latin1_General_CP1_CS_AS
					AND Password COLLATE SQL_Latin1_General_CP1_CS_AS = @Password COLLATE SQL_Latin1_General_CP1_CS_AS
					AND IsActive = 1
				)
		BEGIN
			PRINT 1

			UPDATE EmployeeMaster
			SET FailedPasswordAttemptCount = 0
				,IsLockedOut = 0
				,IsRemembered = @IsRemembered
			WHERE UserName COLLATE SQL_Latin1_General_CP1_CS_AS = @UserName COLLATE SQL_Latin1_General_CP1_CS_AS;

			SET @ReturnCode = '200';
			SET @ReturnMessage = 'Login successfully';
		END
		ELSE
		BEGIN
			SET @attempts = @attempts + 1;

			IF @attempts >= 3
			BEGIN
				UPDATE EmployeeMaster
				SET FailedPasswordAttemptCount = @attempts
					,IsLockedOut = 1
				WHERE UserName COLLATE SQL_Latin1_General_CP1_CS_AS = @UserName COLLATE SQL_Latin1_General_CP1_CS_AS;

				SET @ReturnCode = '203';
				SET @ReturnMessage = 'You have reached the maximum of 3 attempts. Your account is locked. Please contact the admin to unlock it.';
			END
			ELSE
			BEGIN
				UPDATE EmployeeMaster
				SET FailedPasswordAttemptCount = @attempts
				WHERE UserName COLLATE SQL_Latin1_General_CP1_CS_AS = @UserName COLLATE SQL_Latin1_General_CP1_CS_AS;

				SET @ReturnCode = '201';
				SET @ReturnMessage = 'Incorrect password. Please try again.';
			END
		END
	END
	ELSE
	BEGIN
		SET @ReturnCode = '202';
		SET @ReturnMessage = 'User does not exist.';
	END

<<<<<<< HEAD
<<<<<<< HEAD
=======

	print '@ReturnCode'
	print @ReturnCode
>>>>>>> dev
=======

	print '@ReturnCode'
	print @ReturnCode
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
	IF (@ReturnCode = '200')
	BEGIN
		-- Temp table for Employee Business Types
		SELECT ebm.EmpID
			,STRING_AGG(CAST(ebm.BusinessTypeID AS VARCHAR(MAX)), ',') AS BusinessTypeIDs
			,STRING_AGG(bm.BusinessModuleName, ',') AS BusinessTypeNames
		INTO #EmpBizType
		FROM EmployeeBusinessTypeMap ebm
		INNER JOIN BusinessMaster bm ON ebm.BusinessTypeID = bm.BussinessModuleID
		GROUP BY ebm.EmpID;

		-- Temp table for Employee Departments
		SELECT e.EmpID
			,STRING_AGG(d.Dept_Name, ',') AS DepartmentNames
		INTO #EmpDepartments
		FROM EmployeeMaster e
		CROSS APPLY STRING_SPLIT(e.DepartmentID, ',') AS splitDept
<<<<<<< HEAD
<<<<<<< HEAD
		INNER JOIN Department d ON TRY_CAST(splitDept.value AS INT) = d.ID
		WHERE e.IsActive = 1
		GROUP BY e.EmpID;

=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
		INNER JOIN Department d ON CAST(splitDept.value AS INT) = d.ID
		WHERE e.IsActive = 1
		GROUP BY e.EmpID;


		--WITH CompanyIDSplit AS (
		--	SELECT 
		--		cm.*, 
		--		CAST(value AS INT) AS SplitCompanyID
		--	FROM CompanyMaster cm
		--	CROSS APPLY STRING_SPLIT(CAST(cm.CompanyID AS VARCHAR), ',')
		--) 



		WITH EmployeeCompanySplit AS (
			SELECT e.EmpID,
				   CAST(split.value AS INT) AS SplitCompanyID
			FROM EmployeeMaster e
			CROSS APPLY STRING_SPLIT(e.CompanyID, ',') AS split
		)

	
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
		-- Final Select using temp tables
		SELECT e.EmpID
			,e.CompanyID
			,e.DepartmentID
			,ed.DepartmentNames AS DepartmentName
			,ebm.BusinessTypeIDs
			,ebm.BusinessTypeNames AS BusinessTypeName
			,e.EmpCode
			,e.EmpName
			,e.UserName
			,e.RoleId
			,r.RoleName
			,enq.BizVertical
			,enq.TamSales
			,enq.Department
			,rp.RolePermissionID
			,rp.ModuleID
			,m.ModuleName
			,rp.CanView
			,rp.CanEdit
			,rp.CanAdd
			,rp.CanExport
			,rp.CanDelete
			,rp.CanPrint
			,rp.CanReassignTo
			,rp.CanUndoXO
			,rp.CanViewAllFiles
			,rp.CanViewAllFilesReadOnly
			,m.ParentMenuId
			,m.LEVEL
			,m.Type
			,@ReturnCode AS ReturnCode
			,@ReturnMessage AS ReturnMessage
			,e.IsRemembered AS RememberMe
			,e.UserID
			,m.Link
<<<<<<< HEAD
<<<<<<< HEAD
			,CCM.CurrencyCode AS CurrencyName
			,CCM.id as CurrencyId
		FROM EmployeeMaster e
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
			,cast(CCM.CurrencyCode as nvarchar)AS CurrencyName
			,CCM.id as CurrencyId
			,
				(
					SELECT 
						STRING_AGG(CAST(MarketID AS VARCHAR), ',')                                   
					FROM 
					 (SELECT DISTINCT MarketID FROM EmployeeMarketMap WHERE EmpID = e.EmpID) 
					AS t
				) AS MarketIDs  
			,
				(
					SELECT STRING_AGG(mk.Name, ',')
					FROM (
						SELECT DISTINCT MarketID 
						FROM EmployeeMarketMap 
						WHERE EmpID = e.EmpID
					) em
					INNER JOIN Market mk ON mk.ID = em.MarketID
				) AS MarketNames,
			ISNULL(e.offemail,'') AS empOffEmail,
			CASE
        WHEN e.AdvancesApp IS NULL OR e.AdvancesApp = 0 THEN ''
        ELSE (SELECT ISNULL(approver.offemail, '') 
              FROM EmployeeMaster approver
              WHERE approver.EmpID = e.AdvancesApp)
    END AS ApproverEmail
		FROM EmployeeMaster e
		LEFT JOIN EmployeeCompanySplit ecs ON e.EmpID = ecs.EmpID
		LEFT JOIN CompanyMaster CM ON ecs.SplitCompanyID = CM.CompanyID 
		LEFT JOIN CurrencyMaster CCM ON CCM.id = CM.CurrencyComp_id
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
		LEFT JOIN #EmpBizType ebm ON e.EmpID = ebm.EmpID
		LEFT JOIN #EmpDepartments ed ON e.EmpID = ed.EmpID
		LEFT JOIN tbl_Enquiry enq ON e.UserID = enq.CreatedBy
			AND enq.IsDefault = 1
		LEFT JOIN Roles r ON e.RoleId = r.RoleId
		LEFT JOIN RolePermissions rp ON e.RoleId = rp.RoleId
		LEFT JOIN Modules m ON rp.ModuleID = m.ModuleID
<<<<<<< HEAD
<<<<<<< HEAD
		LEFT JOIN CompanyMaster CM ON E.CompanyID = CM.CompanyID
		LEFT JOIN CurrencyMaster CCM ON CCM.id = CM.CurrencyComp_id
=======

>>>>>>> dev
=======

>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
		WHERE e.IsActive = 1
			AND e.UserName COLLATE SQL_Latin1_General_CP1_CS_AS = @UserName COLLATE SQL_Latin1_General_CP1_CS_AS
			AND (
				@CompanyID IS NULL
				OR e.CompanyID = @CompanyID
				)
		ORDER BY m.ModuleName;

		-- Drop temp tables
		DROP TABLE #EmpBizType;

		DROP TABLE #EmpDepartments;
	END
	ELSE
	BEGIN
		SELECT 0 AS EmpID
			,'' AS EmpCode
			,'' AS EmpName
			,'' AS UserName
			,0 AS RoleId
			,'' AS RoleName
			,0 AS RolePermissionID
			,0 AS ModuleID
			,'' AS ModuleName
			,0 AS CanView
			,0 AS CanEdit
			,0 AS CanAdd
			,0 AS CanExport
			,0 AS CanDelete
			,@ReturnCode AS ReturnCode
			,@ReturnMessage AS ReturnMessage;
	END
END
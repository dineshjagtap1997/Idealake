<<<<<<< HEAD
<<<<<<< HEAD
﻿CREATE PROCEDURE [dbo].[usp_File2FileMapping]  
    @CompanyID INT = NULL,  
    @YearID1 INT = NULL,  
    @YearCode1 VARCHAR(20) = NULL,  
    @FileCode1 VARCHAR(30) = NULL,  
    @YearID2 INT = NULL,  
    @YearCode2 VARCHAR(20) = NULL,  
    @FileCode2 VARCHAR(30) = NULL,  
    @IsActive BIT = NULL,  
    @OperationBy UNIQUEIDENTIFIER = NULL,  
    @ID INT = NULL,  
    @Action CHAR(2) = ''  
AS  
BEGIN  
    SET NOCOUNT ON;  
    DECLARE @LogID INT;  
    IF @Action = 'I'  
    BEGIN  
        -- Validation: same Year + FileCode  
        IF @YearID1 = @YearID2 AND @FileCode1 = @FileCode2  
        BEGIN  
            SELECT '201' AS returnCode, 'FileCode1 and FileCode2 cannot be same!' AS returnMessage;  
		   RETURN;  
        END  
        IF EXISTS (  
            SELECT 1 FROM File2FileMapping  
            WHERE CompanyID = @CompanyID  
            AND YearID1 = @YearID1 AND YearCode1 = @YearCode1 AND FileCode1 = @FileCode1  
            AND YearID2 = @YearID2 AND YearCode2 = @YearCode2 AND FileCode2 = @FileCode2  
        )  
        BEGIN  
            SELECT '201' AS returnCode, 'This data already exists. Please check and try again' AS returnMessage, @LogID AS ID;  
            RETURN;  
        END  
        IF EXISTS (SELECT 1 FROM Quotation WHERE CompanyID = @CompanyID AND YearID = @YearID1 AND FileCode = @FileCode1)  
        BEGIN  
            IF EXISTS (SELECT 1 FROM Quotation WHERE CompanyID = @CompanyID AND YearID = @YearID2 AND FileCode = @FileCode2)  
            BEGIN  
                INSERT INTO File2FileMapping (  
                    CompanyID, YearID1, YearCode1, FileCode1, YearID2, YearCode2, FileCode2,  
                    IsActive, Operation, OperationBy, OperationOn  
                )  
                VALUES (  
                    @CompanyID, @YearID1, @YearCode1, @FileCode1, @YearID2, @YearCode2, @FileCode2,  
                    @IsActive, 'INSERT', @OperationBy, GETDATE()  
                );  
                SET @ID = SCOPE_IDENTITY();  
                SELECT '200' AS returnCode, 'New record added successfully' AS returnMessage, @ID AS ID;  
            END  
            ELSE  
            BEGIN  
                SELECT '201' AS returnCode, 'FileCode2 does not Exist!' AS returnMessage;  
                RETURN;  
            END  
        END  
        ELSE  
        BEGIN  
            SELECT '201' AS returnCode, 'FileCode1 does not Exist!' AS returnMessage;  
            RETURN;  
        END  
    END
    -- Handling Update action
    ELSE IF @Action = 'U'  
    BEGIN  
        -- Validation: same Year + FileCode  
        IF @YearID1 = @YearID2 AND @FileCode1 = @FileCode2  
        BEGIN  
            SELECT '201' AS returnCode, 'FileCode1 and FileCode2 cannot be same!' AS returnMessage;  
            RETURN;  
        END  
        -- Ensure the record exists with the provided @ID  
        IF NOT EXISTS (SELECT 1 FROM File2FileMapping WHERE ID = @ID)
        BEGIN
            SELECT '201' AS returnCode, 'No record found with the specified ID.' AS returnMessage;  
            RETURN;
        END
        -- Debugging: Verify the parameters before update
        --SELECT @ID AS DebugID, @CompanyID AS DebugCompanyID, @YearID1 AS DebugYearID1, @FileCode1 AS DebugFileCode1, @YearID2 AS DebugYearID2, @FileCode2 AS DebugFileCode2;
        -- Perform the update
        UPDATE File2FileMapping  
        SET CompanyID = @CompanyID,   
            YearID1 = @YearID1,   
            YearCode1 = @YearCode1,   
            FileCode1 = @FileCode1,  
            YearID2 = @YearID2,   
            YearCode2 = @YearCode2,   
            FileCode2 = @FileCode2,   
            IsActive = @IsActive,  
            Operation = 'UPDATE',   
            UpdatedBy = @OperationBy,   
            UpdatedOn = GETDATE()  
        WHERE ID = @ID;  
        -- Check if update was successful
        IF @@ROWCOUNT = 0  
        BEGIN  
            SELECT '201' AS returnCode, 'No record updated. Please check the ID and try again.' AS returnMessage;  
            RETURN;  
        END  
        SELECT '200' AS returnCode, 'Record updated successfully.' AS returnMessage, @ID AS ID;  
    END
    -- Reporting Section (S action)
    ELSE IF @Action = 'S'  
    BEGIN   
        SELECT FM.ID, FM.CompanyID, CM.CompanyName, FM.YearCode1, FM.FileCode1, FM.YearCode2, FM.FileCode2, FM.Operation, 
            FORMAT(FM.OperationOn, 'dd MMMM yyyy hh:mm:ss tt') AS 'OperationOn', 
            e.UserName, FM.IsActive  
        FROM File2FileMapping FM  
        INNER JOIN EmployeeMaster e ON FM.OperationBy = e.UserID     
        LEFT JOIN CompanyMaster CM ON FM.CompanyID = CM.CompanyID    
        ORDER BY ID DESC;  
    END
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
﻿--WARNING! ERRORS ENCOUNTERED DURING SQL PARSING!
CREATE PROCEDURE [dbo].[usp_File2FileMapping] @CompanyID INT = NULL
	,@YearID1 INT = NULL
	,@YearCode1 VARCHAR(20) = NULL
	,@FileCode1 VARCHAR(30) = NULL
	,@YearID2 INT = NULL
	,@YearCode2 VARCHAR(20) = NULL
	,@FileCode2 VARCHAR(30) = NULL
	,@IsActive BIT = NULL
	,@OperationBy UNIQUEIDENTIFIER = NULL
	,@ID INT = NULL
	,@Action CHAR(2) = ''
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @LogID INT;

	IF @Action = 'I'
	BEGIN -- Validation: same Year + FileCode

		IF @YearID1 = @YearID2
			AND @FileCode1 = @FileCode2
		BEGIN
			SELECT '201' AS returnCode
				,'FileCode1 and FileCode2 cannot be same!' AS returnMessage;

			RETURN;
		END

		IF EXISTS(SELECT 1 FROM File2FileMapping WHERE CompanyID = @CompanyID
				AND YearID1 = @YearID1
				AND YearCode1 = @YearCode1
				AND FileCode1 = @FileCode1
				AND YearID2 = @YearID2
				AND YearCode2 = @YearCode2
				AND FileCode2 = @FileCode2)
		BEGIN
			SELECT '201' AS returnCode
				,'This data already exists. Please check and try again' AS returnMessage
				,@LogID AS ID;

			RETURN;
		END

		IF EXISTS (
				SELECT 1
				FROM QuotatiON
				WHERE CompanyID = @CompanyID
					AND YearID = @YearID1
					AND FileCode = @FileCode1
				)
		BEGIN
			IF EXISTS (
					SELECT 1
					FROM Quotation
					WHERE CompanyID = @CompanyID
						AND YearID = @YearID2
						AND FileCode = @FileCode2
					)
			BEGIN
				INSERT INTO File2FileMapping (
					CompanyID
					,YearID1
					,YearCode1
					,FileCode1
					,YearID2
					,YearCode2
					,FileCode2
					,IsActive
					,Operation
					,OperationBy
					,OperationOn
					)
				VALUES (
					@CompanyID
					,@YearID1
					,@YearCode1
					,@FileCode1
					,@YearID2
					,@YearCode2
					,@FileCode2
					,@IsActive
					,'INSERT'
					,@OperationBy
					,GETDATE()
					);

				SET @ID = SCOPE_IDENTITY();

				SELECT '
200' AS returnCode
					,'New record added successfully' AS returnMessage
					,@ID AS ID;
			END
			ELSE
			BEGIN
				SELECT '201' AS returnCode
					,'FileCode2 does not Exist!' AS returnMessage;

				RETURN;
			END
		END
		ELSE
		BEGIN
			SELECT '201' AS returnCode
				,'FileCode1 does not Exist!' AS returnMessage;

			RETURN;
		END
	END -- Handling Update action     ELSE IF @Action = 'U'  

	BEGIN -- Validation: same Year + FileCode          
	IF @YearID1 = @YearID2 AND @FileCode1 = @FileCode2          
	BEGIN               
	SELECT '201' AS returnCode, 'FileCode1 and FileCode2 cannot be same!' AS returnMessage;               
	RETURN;
	END -- Ensure the record exists with the provided @ID           
	IF NOT EXISTS (SELECT 1 FROM File2FileMapping WHERE ID = @ID)         
	BEGIN             
	SELECT '201' AS returnCode, 'No record found with the specified ID.' AS returnMessage;

	RETURN;
	END -- Debugging: Verify the parameters before update         --
	SELECT @ID AS DebugID, @CompanyID AS DebugCompanyID,
	@YearID1 AS DebugYearID1,
	@FileCode1 AS DebugFileCode1, 
	@YearID2 AS DebugYearID2, 
	@FileCode2 
	AS
DebugFileCode2;-- Perform the update         
UPDATE File2FileMapping          
SET CompanyID = @CompanyID,                
YearID1 = @YearID1,                
YearCode1 = @YearCode1,                
FileCode1 = @FileCode1,               
YearID2 = @YearID2
	,YearCode2 = @YearCode2
	,FileCode2 = @FileCode2
	,IsActive = @IsActive
	,Operation = 'UPDATE'
	,UpdatedBy = @OperationBy
	,UpdatedOn = GETDATE()
WHERE ID = @ID;--Check if update was successful         
IF @@ROWCOUNT = 0           
BEGIN              
SELECT '201' AS returnCode, 'No record updated. Please check the ID and try again.' AS returnMessage;               
RETURN;           
END       

SELECT '200' AS returnCode
	,'Record updated successfully.' AS returnMessage
	,@ID AS ID;
	END 
	-- Reporting Section (S action)     
--	ELSE IF @Action = 'S'      
--	BEGIN            
--	SELECT FM.ID, FM.CompanyID, CM.CompanyName, FM.YearCode1, 
--	FM.FileCode1
--	,FM.YearCode2
--	,FM.FileCode2
--	,FM.Operation
--	,FORMAT(FM.OperationOn, 'dd MMMM yyyy hh:mm:ss tt') AS 'OperationOn'
--	,e.UserName
--	,FM.IsActive
--FROM File2FileMapping FM
--INNER JOIN EmployeeMaster e ON FM.OperationBy = e.UserID
--LEFT JOIN CompanyMaster CM ON FM.CompanyID = CM.CompanyID
--ORDER BY ID DESC;

--END 
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
END
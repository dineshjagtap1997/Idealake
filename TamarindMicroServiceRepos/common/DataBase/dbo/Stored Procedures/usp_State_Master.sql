CREATE PROCEDURE [dbo].[usp_State_Master]                               
@Country_IATACode CHAR(4) = NULL,                                              
@Name VARCHAR(50) = '',                                              
@IsActive BIT = 1,                                              
@OperationBy UNIQUEIDENTIFIER = NULL,                                              
@StateCode VARCHAR(MAX) = '',                                              
@Compcode NVARCHAR(200) = '',                                              
@Action CHAR(2) = '',                                              
@State_ID INT = NULL                                              
AS                                              
BEGIN                                              
    DECLARE @ReturnCode NVARCHAR(3),                                              
            @ReturnMessage NVARCHAR(MAX);                                              
<<<<<<< HEAD
<<<<<<< HEAD
    Declare @LogID int;                        
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    Declare @LogID int; 
	    -- Extract first integer value from @Compcode string (e.g., "60,74,64" → 60)
    --DECLARE @BranchCodeInt INT = NULL;
    --IF @Compcode <> ''
    --BEGIN
    --    SET @BranchCodeInt = TRY_CAST(LEFT(@Compcode, CHARINDEX(',', @Compcode + ',') - 1) AS INT);
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    IF @Action = 'I'                                              
    BEGIN                                              
        IF EXISTS (SELECT TOP 1 1 FROM STATE WHERE UPPER(Name) = UPPER(@Name))                             
        BEGIN                                              
            SET @ReturnCode = '201';                                              
            SET @ReturnMessage = 'State already exists. Please check and try again.';                                              
            SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;                                END                                              
        ELSE                                              
        BEGIN                                              
            DECLARE @MaxID INT = (SELECT MAX(OldID) FROM STATE) + 1;                                              
            INSERT INTO STATE (                                              
                Country_IATACode, Name, StateCode, IsActive, Operation, OperationBy, OperationOn, OldID, StateCodeID, BranchCode                                              
            )                                              
            VALUES (                                              
                @Country_IATACode, @Name, @StateCode, @IsActive, 'Insert', @OperationBy, GETDATE(), @MaxID, @StateCode, @Compcode                                              
            );                                    
   SET @LogID = SCOPE_IDENTITY()                        
            SET @ReturnCode = '200';                                              
            SET @ReturnMessage = 'New record added successfully';                                              
            SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @LogID AS ID;                                              
        END                                              
    END                                              
<<<<<<< HEAD
<<<<<<< HEAD
    ELSE IF @Action = 'U'                                              
    BEGIN                                              
        UPDATE STATE                                              
        SET Country_IATACode = @Country_IATACode,                                              
            Name = @Name,                                              
            StateCode = @StateCode,                                              
            StateCodeID = @StateCode,                                              
            BranchCode = @Compcode,                                              
            IsActive = @IsActive,                                              
            Operation = 'Update',                                              
            UpdatedBy = @OperationBy,                                              
            UpdatedOn = GETDATE()                                              
        WHERE State_ID = @State_ID;                                              
                            
        SET @ReturnCode = '200';                                              
        SET @ReturnMessage = 'Record updated successfully.';                                              
        SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage,  @State_ID AS ID;                               
    END                                              
    ELSE IF @Action = 'S'                                       
    BEGIN                                              
        SELECT State_ID,                                              
               S.Name,                                              
               S.StateCode,                                              
               Country_IATACode,                                              
               C.Name AS CountryName,                                
               BranchCode,                                              
               S.IsActive,                                              
               SCM.State_Code AS State_Code_CM                
      ,                  
      CM.CompanyName,          
   CM.CompanyID ,        
      CM.CompanyID AS Compcode         
        
        FROM STATE S                                              
        INNER JOIN Country C ON S.Country_IATACode = C.IATACode                                              
        INNER JOIN State_Code_Master SCM ON SCM.ID = S.StateCodeID                    
  LEFT JOIN CompanyMaster CM ON CM.CompanyID = S.BranchCode                  
                  
        WHERE                         
            (@Country_IATACode IS NULL OR @Country_IATACode = '' OR Country_IATACode = @Country_IATACode)                        
            AND (@State_ID IS NULL OR @State_ID = 0 OR State_ID = @State_ID)                            
  AND (@Name IS NULL OR @Name = '' OR  S.Name LIKE '%' + @Name + '%')                          
        ORDER BY State_ID DESC;                                              
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    --ELSE IF @Action = 'U'                                              
    --BEGIN                                              
    --    UPDATE STATE                                              
    --    SET Country_IATACode = @Country_IATACode,                                              
    --        Name = @Name,                                              
    --        StateCode = @StateCode,                                              
    --        StateCodeID = @StateCode,                                              
    --        BranchCode = @Compcode,                                              
    --        IsActive = @IsActive,                                              
    --        Operation = 'Update',                                              
    --        UpdatedBy = @OperationBy,                                              
    --        UpdatedOn = GETDATE()                                              
    --    WHERE State_ID = @State_ID;                                              
                            
    --    SET @ReturnCode = '200';                                              
    --    SET @ReturnMessage = 'Record updated successfully.';                                              
    --    SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage,  @State_ID AS ID;                               
    --END 
	IF @Action = 'U'
BEGIN
	IF(ISNULL(@Compcode,'0')<>'0' AND ISNULL(@Compcode,'')<>'') 
		BEGIN
			-- Validate all company ids exist
			IF EXISTS (
				SELECT value 
				FROM STRING_SPLIT(@Compcode, ',')
				WHERE TRY_CAST(value AS INT) IS NULL
				   OR value NOT IN (SELECT CAST(CompanyID AS NVARCHAR) FROM CompanyMaster)
			)
			BEGIN
				SET @ReturnCode = '400';
				SET @ReturnMessage = 'Invalid company ID(s) in @Compcode';
				SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;
				RETURN;
			END
		END

    -- Proceed with update since all company IDs are valid
    UPDATE STATE
    SET Country_IATACode = @Country_IATACode,
        Name = @Name,
        StateCode = @StateCode,
        StateCodeID = @StateCode,
        BranchCode = @Compcode,
        IsActive = @IsActive,
        Operation = 'Update',
        UpdatedBy = @OperationBy,
        UpdatedOn = GETDATE()
    WHERE State_ID = @State_ID;

    SET @ReturnCode = '200';
    SET @ReturnMessage = 'Record updated successfully.';
    SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @State_ID AS ID;
END


    ELSE IF @Action = 'S'                                       
    BEGIN                                              
     -- Convert BranchCode nvarchar to table of INT and JOIN with CompanyMaster
SELECT 
	DISTINCT
	S.State_ID,
       S.Name,
       S.StateCode,
       S.Country_IATACode,
       C.Name AS CountryName,
       S.BranchCode,
       S.IsActive,
       SCM.State_Code AS State_Code_CM,
       --CM.CompanyName,
       STUFF((
		SELECT ',' + CO.CompanyName
		FROM 
			CompanyMaster CO
		WHERE
			CO.CompanyID IN (Select item from dbo.splitstring(S.BranchCode,','))
		FOR XML PATH('')
		), 1, 1, '')
		as CompanyName,
		--CM.CompanyID,
		--CM.CompanyID AS Compcode
		STUFF((
		SELECT ',' + CONVERT(varchar,CO.CompanyID)
		FROM 
			CompanyMaster CO
		WHERE
			CO.CompanyID IN (Select item from dbo.splitstring(S.BranchCode,','))
		FOR XML PATH('')
		), 1, 1, '')
		AS Compcode
FROM STATE S
INNER JOIN Country C ON S.Country_IATACode = C.IATACode
INNER JOIN State_Code_Master SCM ON SCM.ID = S.StateCodeID
OUTER APPLY (
    SELECT value AS CompanyID
    FROM STRING_SPLIT(S.BranchCode, ',')
) BC
--LEFT JOIN CompanyMaster CM ON CM.CompanyID = TRY_CAST(BC.CompanyID AS INT)
WHERE 
    (@Country_IATACode IS NULL OR @Country_IATACode = '' OR S.Country_IATACode = @Country_IATACode)
    AND (@State_ID IS NULL OR @State_ID = 0 OR S.State_ID = @State_ID)
    AND (@Name IS NULL OR @Name = '' OR S.Name LIKE '%' + @Name + '%')
ORDER BY S.State_ID DESC;
  
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    END                     
    ELSE IF @Action = 'F'                          
    BEGIN                          
        SELECT Name, State_ID FROM STATE                          
        WHERE (@Name IS NULL OR @Name = '' OR Name LIKE '%' + @Name + '%')                          
                        
    END      
   ELSE IF @Action = 'EX'                                       
    BEGIN                                              
    SELECT                                             
               S.Name,                                              
               C.Name AS CountryName,                                
             CASE     
        WHEN S.IsActive = 1 THEN 'True'    
        WHEN S.IsActive = 0 THEN 'False'    
    END AS IsActive,                                                   
               SCM.State_Code AS State_Code_CM,                
      CM.CompanyName          
        FROM STATE S                                              
        INNER JOIN Country C ON S.Country_IATACode = C.IATACode                                              
        INNER JOIN State_Code_Master SCM ON SCM.ID = S.StateCodeID                    
  LEFT JOIN CompanyMaster CM ON CM.CompanyID = S.BranchCode                  
                  
        WHERE                         
            (@Country_IATACode IS NULL OR @Country_IATACode = '' OR Country_IATACode = @Country_IATACode)                        
            AND (@State_ID IS NULL OR @State_ID = 0 OR State_ID = @State_ID)                            
  AND (@Name IS NULL OR @Name = '' OR  S.Name LIKE '%' + @Name + '%')                          
        ORDER BY State_ID DESC;            
                  
                                                 
    END         
<<<<<<< HEAD
<<<<<<< HEAD
END 
=======
END
--END
>>>>>>> dev
=======
END
--END
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

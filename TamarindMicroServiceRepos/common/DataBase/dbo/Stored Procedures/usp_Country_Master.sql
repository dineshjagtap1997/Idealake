CREATE PROCEDURE [dbo].[usp_Country_Master] 
 @IATACode CHAR(4) = '',                                             
 @Name VARCHAR(50) = '',                                             
 @Nationality INT = '',                                             
 @ISDCode INT = '',                                             
 @IsActive BIT = 1,                                             
 @OperationBy UNIQUEIDENTIFIER = NULL,                                             
 @PostalCode VARCHAR(10) = '',                                             
 @Action CHAR(2) = '',                                            
 @NationalityName VARCHAR(100) = ''                                            
AS                                              
BEGIN                                              
 DECLARE @ReturnCode NVARCHAR(3),                                              
         @ReturnMessage NVARCHAR(MAX),                     
         @LogID INT;                                              

 IF @Action = 'I'                                              
 BEGIN                                              
     IF EXISTS (SELECT IATACode FROM Country WHERE UPPER(IATACode) = UPPER(@IATACode))                                              
     BEGIN                                              
         SELECT '201' AS returnCode, 'IATA Code already exists. Please check and try again.' AS returnMessage, @IATACode AS IATACode;                                            
     END                                              
     ELSE IF EXISTS (SELECT Name FROM Country WHERE UPPER(Name) = UPPER(@Name))                                              
     BEGIN                                              
         SELECT '201' AS returnCode, 'Country Name already exists. Please check and try again.' AS returnMessage;                                              
     END                                              
     ELSE                                              
     BEGIN                                              
         INSERT INTO Country (                                              
<<<<<<< HEAD
<<<<<<< HEAD
             IATACode, Name, Nationality, ISDCode, IsActive, Operation, OperationBy, OperationDate, OldID, PostalCode                                              
         )                                              
         VALUES (                                              
             UPPER(@IATACode), @Name, @Nationality, @ISDCode, @IsActive, 'Insert', @OperationBy, GETDATE(), UPPER(@IATACode), @PostalCode                                             
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
             IATACode, Name, Nationality, ISDCode, IsActive, Operation, OperationBy, OperationDate, OldID, PostalCode,UpdatedBy        ,UpdatedOn                                      
         )                                              
         VALUES (                                              
             UPPER(@IATACode), @Name, @Nationality, @ISDCode, @IsActive, 'Insert', @OperationBy, GETDATE(), UPPER(@IATACode), @PostalCode    , @OperationBy, GETDATE()                                         
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
         );                                              
         SET @LogID = SCOPE_IDENTITY();                                              
         SELECT '200' AS returnCode, 'New record added successfully.' AS returnMessage, @LogID AS ID;                                              
     END                                              
 END                                              

 ELSE IF @Action = 'U'                                              
 BEGIN                                              
     IF NOT EXISTS (SELECT TOP 1 1 FROM Country WHERE IATACode = @IATACode)                                              
     BEGIN                                              
         SELECT '201' AS returnCode, 'Record Not Found.' AS returnMessage;                                              
     END                                              
     ELSE                                              
     BEGIN                                              
         UPDATE Country                                              
         SET Name = ISNULL(@Name, Name),                                              
             Nationality = ISNULL(@Nationality, Nationality),                                              
             ISDCode = ISNULL(@ISDCode, ISDCode),                                              
             IsActive = ISNULL(@IsActive, IsActive),                                              
             Operation = 'Update',                                              
             UpdatedBy = ISNULL(@OperationBy, OperationBy),                                              
             UpdatedOn = GETDATE(),                                              
             PostalCode = ISNULL(@PostalCode, PostalCode)                                              
         WHERE IATACode = @IATACode;                                              

         SET @LogID = (SELECT ID FROM Country WHERE IATACode = @IATACode);                                              
         SELECT '200' AS returnCode, 'Record updated successfully.' AS returnMessage, @LogID AS ID;                                              
     END                                              
 END                                              

 ELSE IF @Action = 'S'                                              
 BEGIN                                              
     SELECT 
         C.IATACode AS Country_IATACode,                                             
         C.Name AS CountryName,                                             
         C.Name,                                             
         C.Nationality,                                             
         C.ISDCode,                                             
         C.IsActive,                                             
         N.Nationality AS NationalityName,                                             
         C.PostalCode,                                             
         C.IATACode,                                             
         C.ID                                              
     FROM Country C                                              
     INNER JOIN Nationality N ON N.ID = C.Nationality                                              
     WHERE 
         (@IATACode IS NULL OR @IATACode = '' OR C.IATACode = @IATACode) AND
         C.Name LIKE CASE WHEN ISNULL(@Name, '') <> '' THEN '%' + @Name + '%' ELSE C.Name END AND
<<<<<<< HEAD
<<<<<<< HEAD
         C.IATACode LIKE CASE WHEN ISNULL(@IATACode, '') <> '' THEN '%' + @IATACode + '%' ELSE C.IATACode END AND
         N.Nationality LIKE CASE WHEN ISNULL(@NationalityName, '') <> '' THEN '%' + @NationalityName + '%' ELSE N.Nationality END AND
         C.ISDCode LIKE CASE WHEN ISNULL(@ISDCode, '') <> '' THEN @ISDCode ELSE C.ISDCode END AND
         (@Name IS NULL OR @Name = '' OR C.Name LIKE '%' + @Name + '%')                                              
     ORDER BY C.OperationDate DESC, C.ID DESC;                                              
 END                                              

 ELSE IF @Action = 'F'                                              
 BEGIN                                              
     SELECT Name, ID FROM Country                                              
     WHERE (@Name IS NULL OR @Name = '' OR Name LIKE '%' + @Name + '%')                                              
     ORDER BY OperationDate DESC, ID DESC; -- Applied ordering here as well (if you want it sorted latest first)                                              
 END                                              
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    -- sarthak  --  C.IATACode LIKE CASE WHEN ISNULL(@IATACode, '') <> '' THEN '%' + @IATACode + '%' ELSE C.IATACode END AND
	(UPPER(C.IATACode) LIKE '%' + UPPER(@IATACode) + '%' OR @IATACode = '')and

         N.Nationality LIKE CASE WHEN ISNULL(@NationalityName, '') <> '' THEN '%' + @NationalityName + '%' ELSE N.Nationality END AND
         C.ISDCode LIKE CASE WHEN ISNULL(@ISDCode, '') <> '' THEN @ISDCode ELSE C.ISDCode END AND
         (@Name IS NULL OR @Name = '' OR C.Name LIKE '%' + @Name + '%')                                              
     --ORDER BY C.OperationDate DESC, C.ID DESC;        
	 ORDER BY C.UpdatedOn DESC;        
 END                                              

 --ELSE IF @Action = 'F'                                              
 --BEGIN                                              
 --    SELECT Name, ID FROM Country                                              
 --    WHERE (@Name IS NULL OR @Name = '' OR Name LIKE '%' + @Name + '%')                                              
 --    ORDER BY OperationDate DESC, ID DESC; -- Applied ordering here as well (if you want it sorted latest first)                                              
 --END                                              
ELSE IF @Action = 'F'                                              
BEGIN                                              
    ---- Debug: Check what's actually in the table
    --SELECT 'Debug: All IATA Codes' AS Info, IATACode 
    --FROM Country 
    --ORDER BY IATACode;
    
    ---- Return distinct IATA codes
    --SELECT DISTINCT IATACode 
    --FROM Country 
    --ORDER BY IATACode;    
	
	 SELECT Name, ID FROM Country                                              
     WHERE (@Name IS NULL OR @Name = '' OR Name LIKE '%' + @Name + '%')                                              
    
END
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

 ELSE IF @Action = 'EX'                                              
 BEGIN                                              
     SELECT 
         C.IATACode AS Country_IATACode,                                             
         C.Name AS CountryName,                                             
         C.Name,                                             
         CASE WHEN C.IsActive = 1 THEN 'True' WHEN C.IsActive = 0 THEN 'False' END AS IsActive,                                             
         N.Nationality AS NationalityName,                                             
         C.PostalCode,                                             
         C.ISDCode,                                             
         C.IATACode                                              
     FROM Country C                                              
     INNER JOIN Nationality N ON N.ID = C.Nationality                                              
     WHERE 
         (@IATACode IS NULL OR @IATACode = '' OR C.IATACode = @IATACode) AND
         C.Name LIKE CASE WHEN ISNULL(@Name, '') <> '' THEN '%' + @Name + '%' ELSE C.Name END AND
         C.IATACode LIKE CASE WHEN ISNULL(@IATACode, '') <> '' THEN '%' + @IATACode + '%' ELSE C.IATACode END AND
         N.Nationality LIKE CASE WHEN ISNULL(@NationalityName, '') <> '' THEN '%' + @NationalityName + '%' ELSE N.Nationality END AND
         C.ISDCode LIKE CASE WHEN ISNULL(@ISDCode, '') <> '' THEN @ISDCode ELSE C.ISDCode END AND
         (@Name IS NULL OR @Name = '' OR C.Name LIKE '%' + @Name + '%')                                              
     ORDER BY C.OperationDate DESC, C.ID DESC;                                              
 END                                              
<<<<<<< HEAD
<<<<<<< HEAD
END
=======
END
>>>>>>> dev
=======
END
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

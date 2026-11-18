CREATE PROCEDURE [dbo].[usp_TCSRateMaster]
    @ACCode NVARCHAR(50) = NULL,
    @Description NVARCHAR(50) = NULL,
    @ValidFrom DateTime = NULL,
    @ValidTo DateTime = NULL,
    @TCSRate DECIMAL(4, 2) = NULL,
    @IsActive BIT = 1,
    @OperationBy UNIQUEIDENTIFIER = NULL,
    @SAPCode NVARCHAR(6) = NULL,
    @Action CHAR(2) = '',
    @TCSID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Handle NULL or empty date strings
    IF @ValidFrom IS NOT NULL AND TRIM(CAST(@ValidFrom AS NVARCHAR(50))) != '' AND TRIM(CAST(@ValidFrom AS NVARCHAR(50))) != 'NULL'
    BEGIN
        BEGIN TRY
            SET @ValidFrom = CAST(@ValidFrom AS DATETIME)
        END TRY
        BEGIN CATCH
            SET @ValidFrom = NULL
        END CATCH
    END
    ELSE
    BEGIN
        SET @ValidFrom = NULL
    END
                        
    IF @ValidTo IS NOT NULL AND TRIM(CAST(@ValidTo AS NVARCHAR(50))) != '' AND TRIM(CAST(@ValidTo AS NVARCHAR(50))) != 'NULL'
    BEGIN
        BEGIN TRY
            SET @ValidTo = CAST(@ValidTo AS DATETIME)
        END TRY
        BEGIN CATCH
            SET @ValidTo = NULL
        END CATCH
    END
    ELSE
    BEGIN
        SET @ValidTo = NULL
    END

    IF @Action = 'I'                              
    BEGIN                     
        -- Auto-generate ACCode in format AC001, AC002 etc.
        DECLARE @maxCode INT

        SELECT @maxCode = MAX(CAST(SUBSTRING(ACCode, 3, LEN(ACCode)) AS INT))
        FROM TCSRateMaster
        WHERE ISNUMERIC(SUBSTRING(ACCode, 3, LEN(ACCode))) = 1

        SET @maxCode = ISNULL(@maxCode, 0) + 1
        SET @ACCode = 'AC' + RIGHT('000' + CAST(@maxCode AS VARCHAR), 3)

        DECLARE @new_identity INT                 
                  
        -- Check for overlapping dates only for the same rate value
        IF EXISTS (
            SELECT 1
            FROM TCSRateMaster
            WHERE TCSRate = @TCSRate
            AND (
                (@ValidFrom BETWEEN ValidFrom AND ValidTo)
                OR (@ValidTo BETWEEN ValidFrom AND ValidTo)
                OR (ValidFrom BETWEEN @ValidFrom AND @ValidTo)
                OR (ValidTo BETWEEN @ValidFrom AND @ValidTo)
            )
        )                   
        BEGIN                              
            SELECT '201' AS returnCode, 'A rate with the same value already exists for this validity period. Please check and try again.' AS returnMessage;                              
        END                              
        ELSE                              
        BEGIN                 
            INSERT INTO TCSRateMaster (
                ACCode,
                Description,
                ValidFrom,
                ValidTo,
                TCSRate,
                IsActive,
                Operation,
                CreatedBy,
                CreatedDate,
                SAPCode
            )                              
            VALUES (
                @ACCode,
<<<<<<< HEAD
<<<<<<< HEAD
                @Description,
=======
                Isnull(@Description,''),
>>>>>>> dev
=======
                Isnull(@Description,''),
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
                @ValidFrom,
                @ValidTo,
                @TCSRate,
                @IsActive,
                'Insert',
                @OperationBy,
                GETDATE(),
                @SAPCode
            )                              
            SELECT @new_identity = SCOPE_IDENTITY()                              
            SELECT '200' AS returnCode, 'New record added successfully.' AS returnMessage, @new_identity AS ID;       
        END                              
    END                 
    ELSE IF @Action = 'U'                              
    BEGIN            
        -- For updates, check for overlapping dates only for the same rate value, excluding current record
        IF EXISTS (
            SELECT 1
            FROM TCSRateMaster
            WHERE TCSID <> @TCSID
            AND TCSRate = @TCSRate
            AND (
                (@ValidFrom BETWEEN ValidFrom AND ValidTo)
                OR (@ValidTo BETWEEN ValidFrom AND ValidTo)
                OR (ValidFrom BETWEEN @ValidFrom AND @ValidTo)
                OR (ValidTo BETWEEN @ValidFrom AND @ValidTo)
            )
        )                   
        BEGIN                              
            SELECT '201' AS returnCode, 'A rate with the same value already exists for this validity period. Please check and try again.' AS returnMessage;                              
        END
        ELSE            
        BEGIN
            UPDATE TCSRateMaster                              
            SET                              
<<<<<<< HEAD
<<<<<<< HEAD
                Description = @Description,                              
=======
                Description = Isnull(@Description,''),                              
>>>>>>> dev
=======
                Description = Isnull(@Description,''),                              
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
                ValidFrom = @ValidFrom,                            
                ValidTo = @ValidTo,                             
                TCSRate = @TCSRate,                              
                IsActive = @IsActive,                              
                Operation = 'Update',                              
                Updatedby = @OperationBy,                              
                UpdatedDate = GETDATE(),                              
                SAPCode = @SAPCode                              
            WHERE TCSID = @TCSID                              
            SELECT '200' AS returnCode, 'Record updated successfully.' AS returnMessage, @TCSID AS ID;                       
        END            
    END                              
                        
    ELSE IF @Action = 'S'                              
    BEGIN                                 
        SELECT 
            TCSID, 
            ACCode, 
            Description, 
            FORMAT(ValidFrom, 'MM-dd-yyyy') AS ValidFrom,                         
            FORMAT(ValidTo, 'MM-dd-yyyy') AS ValidTo, 
            TCSRate, 
            IsActive, 
            SAPCode                            
        FROM TCSRateMaster C    
        WHERE (@TCSID IS NULL OR @TCSID = 0 OR TCSID = @TCSID)                             
        ORDER BY C.TCSID DESC                                              
    END       
	
    ELSE IF @Action = 'EX'                              
    BEGIN                                 
        SELECT  
<<<<<<< HEAD
<<<<<<< HEAD
=======
			TCSID,
>>>>>>> dev
=======
			TCSID,
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
            Description, 
            FORMAT(ValidFrom, 'MM-dd-yyyy') AS ValidFrom,                         
            FORMAT(ValidTo, 'MM-dd-yyyy') AS ValidTo, 
            TCSRate, 
            IsActive, 
            SAPCode                            
        FROM TCSRateMaster C    
        WHERE (@TCSID IS NULL OR @TCSID = 0 OR TCSID = @TCSID)                             
        ORDER BY C.TCSID DESC                                              
    END     
END
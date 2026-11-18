CREATE PROCEDURE [dbo].[usp_StateCode_Master]           
 @StateCode VARCHAR(50)='',            
 @IsActive BIT = NULL,           
 @OperationBy UNIQUEIDENTIFIER = NULL,          
 @IsUnionTerritory BIT = 0,            
 @IsOtherTerritory BIT = 0,            
 @TwoDigitCode NVARCHAR(2) = '00',            
 @Action CHAR(2),            
 @Active BIT = NULL,            
 @ID INT = NULL            
AS            
BEGIN            
    SET NOCOUNT ON;          
 Declare @LogID int;     
          
    BEGIN TRY          
        IF @Action = 'I'            
        BEGIN            
            IF EXISTS (SELECT 1 FROM State_Code_Master WHERE State_Code = @StateCode)            
            BEGIN            
                SELECT '201' AS returnCode, 'State Code already exists. Please check and try again.' AS returnMessage;            
            END            
            ELSE IF EXISTS (SELECT 1 FROM State_Code_Master WHERE [2DigitCode] = @TwoDigitCode AND IsActive = 1)            
            BEGIN            
                SELECT '201' AS returnCode, '2 Digit Code already exists. Please check and try again.' AS returnMessage;            
            END            
            ELSE            
            BEGIN            
                INSERT INTO State_Code_Master (State_Code, IsActive, Operation, OperationBy, OperationOn, IsUnionTerritory, IsOtherTerritory, [2DigitCode])            
                VALUES (@StateCode, @IsActive, 'Insert', @OperationBy, GETDATE(), @IsUnionTerritory, @IsOtherTerritory, @TwoDigitCode);            
        
    set @LogID = SCOPE_IDENTITY()    
                SELECT '200' AS returnCode, 'New record added successfully.' AS returnMessage, @LogID as ID;            
            END            
        END            
        ELSE IF @Action = 'U'            
        BEGIN            
            IF NOT EXISTS (SELECT 1 FROM State_Code_Master WHERE [2DigitCode] = @TwoDigitCode AND IsActive = 1 AND ID != @ID)            
            BEGIN            
                IF NOT EXISTS (SELECT 1 FROM State_Code_Master WHERE State_Code = @StateCode AND ID != @ID)            
                BEGIN            
                    UPDATE State_Code_Master            
                    SET State_Code = @StateCode, IsActive = @IsActive, Operation = 'Update', UpdatedBy = @OperationBy, UpdatedOn = GETDATE(),           
                        IsUnionTerritory = @IsUnionTerritory, IsOtherTerritory = @IsOtherTerritory, [2DigitCode] = @TwoDigitCode            
                    WHERE ID = @ID;            
          
                    SELECT '200' AS returnCode, 'Record updated successfully.' AS returnMessage, @ID as ID;            
                END            
                ELSE            
                BEGIN            
                    SELECT '201' AS returnCode, 'State Code already exists. Please check and try again' AS returnMessage;            
                END            
            END            
            ELSE            
            BEGIN            
                SELECT '201' AS returnCode, 'State Code already exists. Please check and try again' AS returnMessage;            
            END            
        END            
        ELSE IF @Action = 'S'            
        BEGIN            
            SELECT ID, State_Code AS StateCode, IsActive, ISNULL(IsUnionTerritory, 0) AS IsUnionTerritory, ISNULL(IsOtherTerritory, 0) AS IsOtherTerritory, [2DigitCode] AS TwoDigitCode            
            FROM State_Code_Master            
            WHERE  (@ID IS NULL OR @ID = 0 OR ID = @ID)            
            ORDER BY OperationOn DESC;         
           
        END            

		ELSE IF @Action = 'EX'            
        BEGIN            
<<<<<<< HEAD
<<<<<<< HEAD
            SELECT State_Code AS StateCode, IsActive, ISNULL(IsUnionTerritory, 0) AS IsUnionTerritory, ISNULL(IsOtherTerritory, 0) AS IsOtherTerritory, [2DigitCode] AS TwoDigitCode            
=======
            SELECT ID,State_Code AS StateCode, IsActive, ISNULL(IsUnionTerritory, 0) AS IsUnionTerritory, ISNULL(IsOtherTerritory, 0) AS IsOtherTerritory, [2DigitCode] AS TwoDigitCode            
>>>>>>> dev
=======
            SELECT ID,State_Code AS StateCode, IsActive, ISNULL(IsUnionTerritory, 0) AS IsUnionTerritory, ISNULL(IsOtherTerritory, 0) AS IsOtherTerritory, [2DigitCode] AS TwoDigitCode            
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
            FROM State_Code_Master            
            WHERE  (@ID IS NULL OR @ID = 0 OR ID = @ID)            
            ORDER BY OperationOn DESC;         
           
        END            
    END TRY            
    BEGIN CATCH            
        SELECT ERROR_NUMBER() AS ErrorCode, ERROR_MESSAGE() AS ErrorMessage;            
    END CATCH            
END 
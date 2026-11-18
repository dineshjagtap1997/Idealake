CREATE PROCEDURE [dbo].[usp_UpdateOtherTaxes_M]
(
    @Other_Tax_Id INT = NULL,
    @Name VARCHAR(500) = NULL,
    @OperationBy UNIQUEIDENTIFIER = NULL,
    @IsActive BIT = 0,
    @Action CHAR(2) = ''
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Normalize input
    SET @Name = LTRIM(RTRIM(UPPER(@Name)));

    IF @Action = 'I'
    BEGIN
        -- Check for duplicate name
        IF EXISTS (
            SELECT 1 FROM Other_Taxes
            WHERE UPPER(LTRIM(RTRIM(Name))) = @Name
        )
        BEGIN
            SELECT '201' AS returnCode, 'This tax name already exists. Please check and try again.' AS returnMessage;
            RETURN;
        END

        BEGIN TRY
            INSERT INTO Other_Taxes (
                Name,
                IsActive,
                Operation,
                OperationOn,
                OperationBy
            )
            VALUES (
                @Name,
                @IsActive,
                'Insert',
                GETDATE(),
                @OperationBy
            );

            SET @Other_Tax_Id = SCOPE_IDENTITY();

            SELECT '200' AS returnCode, 'New Record Inserted Successfully.' AS returnMessage, @Other_Tax_Id AS ID;
        END TRY
        BEGIN CATCH
            SELECT '500' AS returnCode, ERROR_MESSAGE() AS returnMessage;
        END CATCH
    END

    ELSE IF @Action = 'U'
    BEGIN
        IF EXISTS (
            SELECT 1 FROM Other_Taxes
            WHERE Other_Tax_Id = @Other_Tax_Id
        )
        BEGIN
            -- Check if updated name conflicts with another record
            IF EXISTS (
                SELECT 1 FROM Other_Taxes
                WHERE UPPER(LTRIM(RTRIM(Name))) = @Name AND Other_Tax_Id <> @Other_Tax_Id
            )
            BEGIN
                SELECT '201' AS returnCode, 'This tax name already exists. Please check and try again.' AS returnMessage;
                RETURN;
            END

            UPDATE Other_Taxes
            SET Name = @Name,
                IsActive = @IsActive,
                Operation = 'Update',
                OperationOn = GETDATE(),
                OperationBy = @OperationBy
            WHERE Other_Tax_Id = @Other_Tax_Id;

            SELECT '200' AS returnCode, 'Record Updated Successfully.' AS returnMessage, @Other_Tax_Id AS ID;
        END
    END

    ELSE IF @Action = 'S'
    BEGIN
        SELECT Other_Tax_Id, Name, IsActive, Operation, OperationOn, OperationBy
        FROM Other_Taxes
        WHERE (@Other_Tax_Id IS NULL OR @Other_Tax_Id = 0 OR Other_Tax_Id = @Other_Tax_Id)
        ORDER BY OperationOn DESC;

        SELECT '' AS returnCode, '' AS returnMessage;
    END

    ELSE IF @Action = 'EX'
    BEGIN
        SELECT 
<<<<<<< HEAD
<<<<<<< HEAD
=======
			Other_Tax_Id,
>>>>>>> dev
=======
			Other_Tax_Id,
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
            Name,
            CASE WHEN IsActive = 1 THEN 'True' ELSE 'False' END AS IsActive
        FROM Other_Taxes
        WHERE (@Other_Tax_Id IS NULL OR @Other_Tax_Id = 0 OR Other_Tax_Id = @Other_Tax_Id)
        ORDER BY OperationOn DESC;

        SELECT '' AS returnCode, '' AS returnMessage;
    END
    ELSE
    BEGIN
        SELECT '400' AS returnCode, 'Invalid action specified.' AS returnMessage;
    END
END

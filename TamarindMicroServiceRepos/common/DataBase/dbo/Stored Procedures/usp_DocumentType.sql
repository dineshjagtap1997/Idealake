<<<<<<< HEAD
<<<<<<< HEAD
﻿CREATE PROCEDURE [dbo].[usp_DocumentType]
    @Action CHAR(1),  
    @DocumentTypeId INT = NULL,
    @DocumentType VARCHAR(255) = NULL,
    @IsActive BIT = NULL,
    @CreatedBy INT = NULL
   
AS
BEGIN
    BEGIN TRANSACTION;
    DECLARE @ReturnCode NVARCHAR(3), @ReturnMessage NVARCHAR(MAX);
    BEGIN TRY
        IF @Action = 'I' 
        BEGIN
            INSERT INTO [dbo].[DocumentType] ([DocumentType], [IsActive], [CreatedBy], [CreatedOn])
            VALUES (@DocumentType, @IsActive, @CreatedBy, GETDATE());
            COMMIT TRANSACTION;
            SET @ReturnCode = '200';
            SET @ReturnMessage = 'Document Type Inserted Successfully';
        END
        ELSE IF @Action = 'U' 
        BEGIN
            UPDATE [dbo].[DocumentType]
            SET [DocumentType] = @DocumentType, [IsActive] = @IsActive, [UpdatedBy] = @CreatedBy, [UpdatedOn] = GETDATE()
            WHERE [DocumentTypeId] = @DocumentTypeId;
            COMMIT TRANSACTION;
            SET @ReturnCode = '200';
            SET @ReturnMessage = 'Document Type Updated Successfully';
        END
        
        ELSE IF @Action = 'S' 
        BEGIN
            SELECT * FROM [dbo].[DocumentType] WHERE (@DocumentTypeId IS NULL OR [DocumentTypeId] = @DocumentTypeId) and isactive=1 ;
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
﻿
CREATE PROCEDURE [dbo].[usp_DocumentType]
    @Action CHAR(2),  
    @DocumentTypeId INT = NULL,
    @DocumentType VARCHAR(255) = NULL,
    @IsActive BIT = NULL,
    @OperationBy UNIQUEIDENTIFIER = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ReturnCode NVARCHAR(3), @ReturnMessage NVARCHAR(MAX),@NewDocumentTypeId INT;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF @Action = 'I'
        BEGIN
            IF EXISTS (
                SELECT 1
                FROM [dbo].[DocumentType]
                WHERE LTRIM(RTRIM(DocumentType)) COLLATE SQL_Latin1_General_CP1_CI_AS =
                      LTRIM(RTRIM(@DocumentType)) COLLATE SQL_Latin1_General_CP1_CI_AS
            )
            BEGIN
                ROLLBACK TRANSACTION;
                SET @ReturnCode = '409';
                SET @ReturnMessage = 'Duplicate Document Type. Please enter a unique value.';
            END
            ELSE
            BEGIN
                INSERT INTO [dbo].[DocumentType] (DocumentType, IsActive, CreatedBy, CreatedOn)
                VALUES (LTRIM(RTRIM(@DocumentType)), @IsActive, @OperationBy, GETDATE());
				SET @NewDocumentTypeId = SCOPE_IDENTITY();

                COMMIT TRANSACTION;
                SET @ReturnCode = '200';
                SET @ReturnMessage = 'Document Type Inserted Successfully';
            END
        END
        ELSE IF @Action = 'U'
        BEGIN
            IF EXISTS (
                SELECT 1
                FROM [dbo].[DocumentType]
                WHERE LTRIM(RTRIM(DocumentType)) COLLATE SQL_Latin1_General_CP1_CI_AS =
                      LTRIM(RTRIM(@DocumentType)) COLLATE SQL_Latin1_General_CP1_CI_AS
                  AND DocumentTypeId <> @DocumentTypeId
            )
            BEGIN
                ROLLBACK TRANSACTION;
                SET @ReturnCode = '409';
                SET @ReturnMessage = 'Duplicate Document Type. Please enter a unique value.';
            END
            ELSE
            BEGIN
                UPDATE [dbo].[DocumentType]
                SET DocumentType = LTRIM(RTRIM(@DocumentType)),
                    IsActive = @IsActive,
                    UpdatedBy = @OperationBy,
                    UpdatedOn = GETDATE()
					
                WHERE DocumentTypeId = @DocumentTypeId;

				SET @NewDocumentTypeId = @DocumentTypeId;
                COMMIT TRANSACTION;
                SET @ReturnCode = '200';
                SET @ReturnMessage = 'Document Type Updated Successfully';
            END
        END
        ELSE IF @Action IN ('S', 'EX')
        BEGIN
            SELECT * 
            FROM [dbo].[DocumentType]
            WHERE (@DocumentTypeId IS NULL OR DocumentTypeId = @DocumentTypeId) order by 1 desc;
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
            COMMIT TRANSACTION;
            SET @ReturnCode = '200';
            SET @ReturnMessage = 'Document Type Retrieved Successfully';
        END
<<<<<<< HEAD
<<<<<<< HEAD
        ELSE 
        BEGIN
            ROLLBACK TRANSACTION;
            SET @ReturnCode = '500';
            SET @ReturnMessage = 'Invalid Action Flag. Allowed values are "I", "U", "D", and "S".';
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
        ELSE
        BEGIN
            ROLLBACK TRANSACTION;
            SET @ReturnCode = '500';
            SET @ReturnMessage = 'Invalid Action Flag. Allowed values are "I", "U", "S", "EX".';
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
        END
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SET @ReturnCode = '500';
        SET @ReturnMessage = ERROR_MESSAGE();
    END CATCH
<<<<<<< HEAD
<<<<<<< HEAD
    SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;
=======

    SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage,
	@NewDocumentTypeId AS ID;
>>>>>>> dev
=======

    SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage,
	@NewDocumentTypeId AS ID;
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
END

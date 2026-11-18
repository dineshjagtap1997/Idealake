CREATE PROCEDURE [dbo].[usp_DocumentType_Eliza] @Action CHAR(1)
	,@DocumentTypeId INT = NULL
	,@DocumentType VARCHAR(255) = NULL
	,@IsActive BIT = NULL
	,@CreatedBy INT = NULL
AS
BEGIN
	BEGIN TRANSACTION;

	DECLARE @ReturnCode NVARCHAR(3)
		,@ReturnMessage NVARCHAR(MAX);

	BEGIN TRY
		IF @Action = 'I'
		BEGIN
			INSERT INTO [dbo].[DocumentType] (
				[DocumentType]
				,[IsActive]
				,[CreatedBy]
				,[CreatedOn]
				)
			VALUES (
				@DocumentType
				,@IsActive
				,@CreatedBy
				,GETDATE()
				);

			COMMIT TRANSACTION;

			SET @ReturnCode = '200';
			SET @ReturnMessage = 'Document Type Inserted Successfully';
		END
		ELSE IF @Action = 'U'
		BEGIN
			UPDATE [dbo].[DocumentType]
			SET [DocumentType] = @DocumentType
				,[IsActive] = @IsActive
				,[UpdatedBy] = @CreatedBy
				,[UpdatedOn] = GETDATE()
			WHERE [DocumentTypeId] = @DocumentTypeId;

			COMMIT TRANSACTION;

			SET @ReturnCode = '200';
			SET @ReturnMessage = 'Document Type Updated Successfully';
		END
		ELSE IF @Action = 'S'
		BEGIN
			SELECT *
			FROM [dbo].[DocumentType]
			WHERE (
					@DocumentTypeId IS NULL
					OR [DocumentTypeId] = @DocumentTypeId
					) --and isactive = 1;

			COMMIT TRANSACTION;

			SET @ReturnCode = '200';
			SET @ReturnMessage = 'Document Type Retrieved Successfully';
		END
		ELSE
		BEGIN
			ROLLBACK TRANSACTION;

			SET @ReturnCode = '500
';
			SET @ReturnMessage = 'Invalid Action Flag. Allowed values are "I", "U", "D", and "S".';
		END
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION;

		SET @ReturnCode = '500';
		SET @ReturnMessage = ERROR_MESSAGE();
	END CATCH

	SELECT @ReturnCode AS returnCode
		,@ReturnMessage AS returnMessage;
END
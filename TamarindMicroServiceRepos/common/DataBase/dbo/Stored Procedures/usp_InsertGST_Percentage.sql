CREATE PROCEDURE [dbo].[usp_InsertGST_Percentage] @GSTPercentage DECIMAL(10, 2)
	,@IsActive BIT
	,@OperationBy UNIQUEIDENTIFIER
	,@Action CHAR(2) = ''
	,@GSTID INT = ''
AS
BEGIN
	IF @Action = 'I'
	BEGIN
		DECLARE @new_identity INT

		IF EXISTS (
				SELECT GSTPercentage
				FROM GST_Percentage
				WHERE GSTPercentage = @GSTPercentage
				)
		BEGIN
			SELECT '201' AS returnCode
				,'GST percentage already exists. Please check and try again.' AS returnMessage
				,@new_identity AS ID;
		END
		ELSE
		BEGIN
			INSERT INTO GST_Percentage (
				GSTPercentage
				,IsActive
				,Operation
				,CreatedBy
				,CreatedDate
				,Updatedby
				,UpdatedOn
				)
			VALUES (
				@GSTPercentage
				,@IsActive
				,'Insert'
				,@OperationBy
				,GETDATE()
				,@OperationBy
				,GETDATE()
				)

			SELECT @new_identity = SCOPE_IDENTITY()

			--EXEC  usp_InsertGST_Percentage_Audit   @new_identity,@GSTPercentage,@IsActive,'Insert', @OperationBy          
			SELECT '200' AS returnCode
				,'New record added successfully' AS returnMessage
				,@new_identity AS ID;
		END
	END
	ELSE IF @Action = 'U'
	BEGIN
		UPDATE GST_Percentage
		SET GSTPercentage = @GSTPercentage
			,IsActive = @IsActive
			,Operation = 'Update'
			,UpdatedBy = @OperationBy
			,UpdatedOn = GETDATE()
		WHERE GSTID = @GSTID

		--EXEC usp_InsertGST_Percentage_Audit @GSTID,@GSTPercentage,@IsActive,'Update', @OperationBy        
		SELECT '200' AS returnCode
			,'Record updated successfully.' AS returnMessage
			,@GSTID AS ID;
	END
	ELSE IF @Action = 'S'
	BEGIN
		SELECT *
		FROM GST_Percentage C
		ORDER BY C.GSTID DESC
	END

	ELSE IF @Action = 'EX'
	BEGIN
		SELECT GSTPercentage, 
		CASE
			WHEN IsActive = 1 THEN 'True'
			WHEN IsActive= 0 THEN 'False'
			END AS IsActive
		FROM GST_Percentage C
		ORDER BY C.GSTID DESC
	END
END
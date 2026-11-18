CREATE PROCEDURE [dbo].[usp_WithholdingTax_Master] @Tax_Code CHAR(4)
	,@Description VARCHAR(50)
	,@IsActive BIT
	,@OperationBy UNIQUEIDENTIFIER
	,@Action CHAR(2) = ''
	,@Tax_ID BIGINT = ''
	--,@Active BIT=''      
	--,@ErrMsg VARCHAR(50) OUT      
AS
BEGIN
	DECLARE @LogID INT;

	IF @Action = 'I'
	BEGIN
		IF EXISTS (
				SELECT Tax_Code
				FROM Withholding_Tax_Master
				WHERE UPPER(Tax_Code) = UPPER(@Tax_Code)
				)
		BEGIN
			SELECT '201' AS returnCode
				,'Tax Code already exists. Please check and try again.' AS returnMessage
				,@LogID AS ID;
		END
		ELSE
		BEGIN
			INSERT INTO Withholding_Tax_Master (
				Tax_Code
				,Description
				,IsActive
				,Operation
				,CreatedBy
				,CreatedDate
				,Updatedby
				,UpdatedOn
				)
			VALUES (
				UPPER(@Tax_Code)
				,@Description
				,@IsActive
				,'Insert'
				,@OperationBy
				,GETDATE()
				,@OperationBy
				,GETDATE()
				)

			--EXEC usp_InsertWithholdingTax_Audit @Tax_Code      
			-- ,@Description      
			-- ,@IsActive      
			-- ,'Insert'      
			-- ,@OperationBy      
			SET @LogID = SCOPE_IDENTITY()

			SELECT '200' AS returnCode
				,'New record added successfully.' AS returnMessage
				,@LogID AS ID;
		END
	END
	ELSE IF @Action = 'U'
	BEGIN
		UPDATE Withholding_Tax_Master
		SET Description = @Description
			,IsActive = @IsActive
			,Operation = 'Update'
			,UpdatedBy = @OperationBy
			,UpdatedOn = GETDATE()
		WHERE Tax_ID = @Tax_ID

		--EXEC usp_InsertWithholdingTax_Audit @Tax_Code      
		-- ,@Description      
		-- ,@IsActive      
		-- ,'Update'      
		-- ,@OperationBy      
		SELECT '200' AS returnCode
			,'Record updated successfully.' AS returnMessage
			,@LogID AS ID;
	END
	ELSE IF @Action = 'S'
	BEGIN
		SELECT *
		FROM Withholding_Tax_Master C
		ORDER BY C.Tax_ID DESC
	END

	ELSE IF @Action = 'EX'
	BEGIN
		SELECT Tax_Code,
		Description,
		CASE
			WHEN IsActive = 1 THEN 'True'
			WHEN IsActive = 0 THEN 'False'
			END AS IsActive
		FROM Withholding_Tax_Master C
		ORDER BY C.Tax_ID DESC
	END
END
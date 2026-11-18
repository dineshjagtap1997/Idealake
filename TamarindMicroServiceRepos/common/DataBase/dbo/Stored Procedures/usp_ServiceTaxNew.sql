ALTER PROCEDURE [dbo].[usp_ServiceTaxNew] (
	@Action CHAR(2)
	,@Tax_Perc DECIMAL(5, 2) = 0
	,-- 'S' for Select, 'I' for Insert, 'U' for Update                              
	@Tax_ID INT = NULL
	,-- Required for Update only                              
	@Tax_Desc VARCHAR(500) = NULL
	,@GSTID INT = NULL
	,@Tax_From_Date DATETIME = NULL
	,@Tax_To_Date DATETIME = NULL
	,@IsActive BIT = NULL
	,@OperationBy UNIQUEIDENTIFIER = NULL
	,@GSTType VARCHAR(500) = NULL
	,@SAPCode VARCHAR(5) = NULL
	,@IsCommercial BIT = 0
	,@PageNumber BIGINT = NULL
	,@PageSize INT = NULL
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @LogID INT;
	DECLARE @ReturnCode NVARCHAR(3)
		,@ReturnMessage NVARCHAR(MAX);

	-- Select Operation (S)                              
	IF (@Action = 'S')
	BEGIN
		--select  '200' AS ReturnCode,'Service Tax record Inserted Successfully.' AS ReturnMessage                              
		SELECT DISTINCT ST.Tax_ID
			,ST.Tax_Desc
			-- , ST.Tax_Perc     
			--, ISNULL(ST.Tax_Perc, 0) AS Tax_Perc    
			,ISNULL(GSTPER.GSTPercentage, 0) AS Tax_Perc
			,ST.GSTID
			,ST.Tax_From_Date
			,ST.Tax_To_Date
			,ST.IsActive
			,ST.GSTType
			,GST.GSTTypeName
			,N3.GSTTypeName AS State_Code3
			,GSTPER.GSTPercentage
			--,CAST(CAST(ISNULL(ST.Tax_Perc, 0) AS FLOAT) AS VARCHAR) AS 'GSTPercentageText'
			,CAST(CAST(ISNULL(GSTPER.GSTPercentage, 0) AS FLOAT) AS VARCHAR) AS 'GSTPercentageText'
			,ST.SAPCode
			,ST.IsCommercial
		FROM ServiceTaxNew ST
		LEFT JOIN GSTTypeMaster N3 ON N3.GSTID = ST.GSTType
		LEFT JOIN GST_Percentage GSTPER ON GSTPER.GSTID = ST.GSTID
		LEFT JOIN GSTTypeMaster GST ON GST.GSTID = ST.GSTID
		WHERE (
				@Tax_ID IS NULL
				OR @Tax_ID = 0
				OR ST.Tax_ID = @Tax_ID
				)
			-- AND ST.IsActive = 1
		ORDER BY Tax_ID DESC
	END
			-- EX Operation(EX)          
	ELSE IF (@Action = 'EX')
	BEGIN
		SELECT 
			ST.Tax_ID,
		ST.Tax_Desc
			,ST.Tax_Perc
			,ST.Tax_From_Date
			,ST.Tax_To_Date
			,ST.IsActive
			,GST.GSTTypeName
			,ST.SAPCode
			,ST.IsCommercial
		FROM ServiceTaxNew ST
		LEFT JOIN GSTTypeMaster N3 ON N3.GSTID = ST.GSTType
		LEFT JOIN GST_Percentage GSTPER ON GSTPER.GSTID = ST.GSTID
		LEFT JOIN GSTTypeMaster GST ON GST.GSTID = ST.GSTID
		WHERE (
				@Tax_ID IS NULL
				OR @Tax_ID = 0
				OR ST.Tax_ID = @Tax_ID
				)
		ORDER BY Tax_ID DESC
	END
			-- Insert Operation (I)                              
	ELSE IF (@Action = 'I')
	BEGIN
		IF EXISTS (
				SELECT TOP 1 1
				FROM ServiceTaxNew
				WHERE GSTType = @GSTType
					AND Tax_Perc = @Tax_Perc -- Added Tax_Perc check    
					AND (
						Tax_From_Date = CAST(@Tax_From_Date AS DATETIME)
						OR Tax_To_Date = CAST(@Tax_To_Date AS DATETIME)
						OR CAST(@Tax_From_Date AS DATETIME) BETWEEN Tax_From_Date
							AND Tax_To_Date
						OR CAST(@Tax_To_Date AS DATETIME) BETWEEN Tax_From_Date
							AND Tax_To_Date
						)
					AND IsActive = 1
				)
		BEGIN
			SET @ReturnCode = '201';
			SET @ReturnMessage = 'Service Tax record already exists for similar data. Please check and try again.';

			SELECT @ReturnCode AS ReturnCode
				,@ReturnMessage AS ReturnMessage
				,@LogID AS ID;
		END
		ELSE
		BEGIN
			INSERT INTO ServiceTaxNew (
				Tax_Desc
				,Tax_Perc
				,GSTID
				,IsActive
				,Tax_From_Date
				,Tax_To_Date
				,Operation
				,OperationBy
				,OperationOn
				,GSTType
				,SAPCode
				,IsCommercial
				)
			VALUES (
				@Tax_Desc
				,@Tax_Perc
				,@GSTID
				,@IsActive
				,CAST(@Tax_From_Date AS DATETIME)
				,CAST(@Tax_To_Date AS DATETIME)
				,'Insert'
				,@OperationBy
				,GETDATE()
				,@GSTType
				,@SAPCode
				,@IsCommercial
				);

			SET @LogID = SCOPE_IDENTITY();
			SET @ReturnCode = '200';
			SET @ReturnMessage = 'New record added successfully.';

			SELECT @ReturnCode AS ReturnCode
				,@ReturnMessage AS ReturnMessage
				,@LogID AS ID;
		END
	END
			-- Update Operation (U)                              
			--ELSE IF (@Action = 'U')                              
			--BEGIN                              
			-- IF EXISTS (                              
			--   SELECT TOP 1 1                              
			--   FROM ServiceTaxNew                              
			--   WHERE GSTType = @GSTType                              
			--    AND Tax_Perc = @Tax_Perc  -- Added Tax_Perc check    
			--    AND (                              
			--     Tax_From_Date = @Tax_From_Date                       
			--     OR Tax_To_Date = @Tax_To_Date                              
			--     OR @Tax_From_Date BETWEEN Tax_From_Date AND Tax_To_Date                              
			--     OR @Tax_To_Date BETWEEN Tax_From_Date AND Tax_To_Date                              
			--    )                              
			--    AND Tax_ID != @Tax_ID                              
			--    AND IsActive = 1                     
			--   )                              
			-- BEGIN                              
			--  SET @ReturnCode = '201';                              
			--  SET @ReturnMessage = 'Service Tax record already exists for similar data. Please check and try again.';                             
			--  SELECT @ReturnCode AS ReturnCode, @ReturnMessage AS ReturnMessage, @Tax_ID AS ID;                              
			-- END                              
			-- ELSE                              
			-- BEGIN                              
			--  UPDATE ServiceTaxNew                              
			--  SET Tax_Desc = @Tax_Desc         
			--  ,Tax_Perc = ISNULL(@Tax_Perc, 0)                  
			--   ,GSTID = @GSTID                              
			--   ,IsActive = @IsActive                              
			--   ,Tax_From_Date = @Tax_From_Date                               
			--   ,Tax_To_Date = @Tax_To_Date                              
			--   ,Operation = 'Update'                              
			--   ,UpdatedBy = @OperationBy                              
			--   ,UpdatedOn = GETDATE()                              
			-- ,GSTType = @GSTType                              
			--   ,SAPCode = @SAPCode                              
			--   ,IsCommercial = @IsCommercial                              
			--  WHERE Tax_ID = @Tax_ID;                              
			--  SET @ReturnCode = '200';                              
			--  SET @ReturnMessage = 'Record updated successfully.';                              
			--  SELECT @ReturnCode AS ReturnCode, @ReturnMessage AS ReturnMessage, @Tax_ID AS ID;                              
			-- END                              
			--END                              
			--  -- Invalid ActionFlag                              
			--ELSE                              
			--BEGIN                              
			-- SET @ReturnCode = '200';                              
			-- SET @ReturnMessage = 'Invalid Action Flag.';                              
			--END    
	ELSE IF (@Action = 'U')
	BEGIN
		IF EXISTS (
				SELECT *
				FROM ServiceTaxNew
				WHERE GSTType = @GSTType
					AND Tax_Perc = @Tax_Perc
					AND (
						Tax_From_Date = @Tax_From_Date
						OR Tax_To_Date = @Tax_To_Date
						OR @Tax_From_Date BETWEEN Tax_From_Date
							AND Tax_To_Date
						OR @Tax_To_Date BETWEEN Tax_From_Date
							AND Tax_To_Date
						)
					AND Tax_ID != @Tax_ID -- This line is CRUCIAL                              
					AND IsActive = 1
				)
		BEGIN
			SET @ReturnCode = '201';
			SET @ReturnMessage = 'Service Tax record already exists for similar data. Please check and try again.';

			SELECT @ReturnCode AS ReturnCode
				,@ReturnMessage AS ReturnMessage
				,@Tax_ID AS ID;
		END
		ELSE
		BEGIN
			UPDATE ServiceTaxNew
			SET Tax_Desc = @Tax_Desc
				,Tax_Perc = ISNULL(@Tax_Perc, 0)
				,GSTID = @GSTID
				,IsActive = @IsActive
				,Tax_From_Date = @Tax_From_Date
				,Tax_To_Date = @Tax_To_Date
				,Operation = 'Update'
				,UpdatedBy = @OperationBy
				,UpdatedOn = GETDATE()
				,GSTType = @GSTType
				,SAPCode = @SAPCode
				,IsCommercial = @IsCommercial
			WHERE Tax_ID = @Tax_ID;

			SET @ReturnCode = '200';
			SET @ReturnMessage = 'Record updated successfully.';

			SELECT @ReturnCode AS ReturnCode
				,@ReturnMessage AS ReturnMessage
				,@Tax_ID AS ID;
		END
	END
END
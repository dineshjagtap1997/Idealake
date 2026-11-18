
CREATE PROCEDURE [dbo].[USP_InsertAgentExcelData] @AgentMaster AgentMasterType READONLY
	,-- Table parameter for AgentMaster
	@AgentContact AgentContactType READONLY
	,-- Table parameter for AgentContact
	--@AgentSapComp AgentSapCompCode READONLY,  -- Table parameter for AgentContact 
	@AccCode VARCHAR(50) = ''
	,@CategoryID INT = ''
	,@Miscellaneous INT = ''
	,@City_IATACode CHAR(3) = ''
	,@Website VARCHAR(200) = ''
	,@MobileNo VARCHAR(15) = ''
	,@FaxNo VARCHAR(35) = ''
	,@EmailID VARCHAR(200) = ''
	,@PanNo VARCHAR(50) = ''
	,@STRegNo VARCHAR(50) = ''
	,@ChequeFavouring VARCHAR(200) = ''
	,@CreateAdvanceAccount BIT = 0
	,@IsActive BIT = 1
	,@IsCorporate BIT = 0
	,@TypeID INT = ''
	,@IsPrimaryContact BIT = 0
AS
BEGIN
	IF NOT EXISTS (
			SELECT 1
			FROM @AgentMaster
			)
	BEGIN
		SELECT '400' AS returnCode
			,'Agent Primary Detail is Empty' AS returnMessage;

		RETURN;
	END

	IF EXISTS (
			SELECT 1
			FROM @AgentMaster am
			GROUP BY am.AgentName
			HAVING COUNT(*) > 1
			)
	BEGIN
		-- Return message for duplicate AgentName
		SELECT '400' AS returnCode
			,'Duplicate AgentName found. Please ensure AgentName is unique.' AS returnMessage;

		RETURN;
	END

	-- Start a transaction for atomicity
	BEGIN TRANSACTION;

	BEGIN TRY
		-- Declare variables
		DECLARE @AgentID INT;

		-- Temporary table to hold filtered (non-duplicate) agents
		CREATE TABLE #FilteredAgentMaster (
			[AgentName] [varchar](200) NULL
			,[AgentGroup] [varchar](50) NULL
			,[LegalEntity] [nvarchar](50) NULL
			,[Market] [varchar](50) NULL
			,[LegalName] [varchar](80) NULL
			,[Address] [varchar](max) NULL
			,[MarketCountry] [varchar](50) NULL
			,[State] [varchar](50) NULL
			,[City] [varchar](50) NULL
			,[StateCode] [varchar](500) NULL
			,[Phone] [varchar](45) NULL
			);

		-- Remove duplicate AgentName entries
		INSERT INTO #FilteredAgentMaster (
			AgentName
			,[AgentGroup]
			,LegalEntity
			,[Market]
			,LegalName
			,Address
			,[MarketCountry]
			,[State]
			,[City]
			,[StateCode]
			,Phone
			)
		SELECT DISTINCT am.AgentName
			,am.AgentGroup
			,am.LegalEntity
			,am.Market
			,am.LegalName
			,am.Address
			,am.MarketCountry
			,am.STATE
			,am.City
			,am.StateCode
			,am.Phone
		FROM @AgentMaster am
		WHERE NOT EXISTS (
				SELECT 1
				FROM AgentMaster existing
				WHERE existing.AgentName = am.AgentName COLLATE SQL_Latin1_General_CP1_CI_AS
				);

		-- Table variable to store inserted AgentMaster IDs and names
		DECLARE @InsertedMasterIds TABLE (
			AgentMasterId INT
			,AgentName NVARCHAR(100)
			);

		-- Insert into AgentMaster
		INSERT INTO AgentMaster (
			AgentName
			,GroupID
			,LegalEntity
			,MarketID
			,LegalName
			,Address
			,AddressCountry
			,AddressState
			,AddressCity
			,StateCodeID
			,PhoneNo
			,Operation
			,OperationBy
			,OperationOn
			,AccCode
			,CategoryID
			,Miscellaneous
			,City_IATACode
			,Website
			,MobileNo
			,FaxNo
			,EmailID
			,PanNo
			,STRegNo
			,ChequeFavouring
			,CreateAdvanceAccount
			,IsActive
			,IsCorporate
			)
		OUTPUT INSERTED.AgentID
			,INSERTED.AgentName
		INTO @InsertedMasterIds(AgentMasterId, AgentName)
		SELECT AgentName
			,[AgentGroup]
			,LegalEntity
			,ISNULL((
					SELECT ID
					FROM Market
					WHERE name = #FilteredAgentMaster.Market
					), '') AS MarketID
			,LegalName
			,Address
			,ISNULL((
					SELECT IATACode
					FROM Country
					WHERE name = MarketCountry
					), '') AS MarketCountry
			,ISNULL((
					SELECT State_ID
					FROM STATE
					WHERE name = STATE
					), '') AS STATE
			,ISNULL((
					SELECT IATACode
					FROM City
					WHERE name = City
					), '') AS City
			,ISNULL((
					SELECT ID
					FROM State_Code_Master
					WHERE State_Code = StateCode
					), '') AS StateCode
			,Phone
			,'Insert'
			,'3fa85f64-5717-4562-b3fc-2c963f66afa6'
			,GETDATE()
			,@AccCode
			,@CategoryID
			,@Miscellaneous
			,@City_IATACode
			,@Website
			,@MobileNo
			,@FaxNo
			,@EmailID
			,@PanNo
			,@STRegNo
			,@ChequeFavouring
			,@CreateAdvanceAccount
			,@IsActive
			,@IsCorporate
		FROM #FilteredAgentMaster;

		IF EXISTS (
				SELECT 1
				FROM @AgentContact
				)
		BEGIN
			-- Insert corresponding AgentContact details
			INSERT INTO ContactDetails (
				ParentID
				,FirstName
				,CityIATACode
				,EmailID
				,MobileNo
				,TypeID
				,IsPrimaryContact
				)
			SELECT am.AgentMasterId
				,ac.FirstName
				,ISNULL((
						SELECT IATACode
						FROM City
						WHERE name = ac.City
						), '') AS CityIATACode
				,ac.EmailID
				,ac.MobileNo
				,@TypeID
				,@IsPrimaryContact
			FROM @AgentContact ac
			INNER JOIN @InsertedMasterIds am ON ac.AgentName = am.AgentName COLLATE SQL_Latin1_General_CP1_CI_AS;-- Ensure collation matches
		END

		-- Commit transaction
		COMMIT TRANSACTION;

		-- Return success response
		SELECT '200' AS returnCode
			,'Data Inserted' AS returnMessage;
	END TRY

	BEGIN CATCH
		-- Rollback transaction on error
		ROLLBACK TRANSACTION;

		-- Return error message
		DECLARE @ErrorMessage NVARCHAR(4000)
			,@ErrorSeverity INT
			,@ErrorState INT;

		SELECT @ErrorMessage = ERROR_MESSAGE()
			,@ErrorSeverity = ERROR_SEVERITY()
			,@ErrorState = ERROR_STATE();

		RAISERROR (
				@ErrorMessage
				,@ErrorSeverity
				,@ErrorState
				);
	END CATCH;
END;
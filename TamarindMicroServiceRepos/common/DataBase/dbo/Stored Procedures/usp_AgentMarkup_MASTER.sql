CREATE PROCEDURE [dbo].[usp_AgentMarkup_MASTER] (
	@AgentCategoryID INT
	,@CodeDescription VARCHAR(100)
	,@ValidFrom DATETIME
	,@ValidTo DATETIME
	,@Hotel NUMERIC(18, 2)
	,@Transport NUMERIC(18, 2)
	,@Guide NUMERIC(18, 2)
	,@Monument NUMERIC(18, 2)
	,@Flight_Train NUMERIC(18, 2)
	,@SpecialService NUMERIC(18, 2)
	,@Package NUMERIC(18, 2)
	,@IsActive BIT
	,@OperationBy UNIQUEIDENTIFIER
	,@SupplierID INT
	--added by snaket  
	-- @ErrMsg    VARCHAR(50) OUT      
	,@Action CHAR(2) = ''
	,@AgentMarkupID INT =''	
	)
AS
BEGIN

 Declare @LogID int; 
	IF @Action = 'I'
	BEGIN
		IF EXISTS (
				SELECT AgentMarkupID
				FROM AgentMarkup
				WHERE AgentCategoryID = @AgentCategoryID
					AND SupplierID = @SupplierID
					AND (
						CONVERT(VARCHAR, CAST(@ValidFrom AS DATETIME), 112) BETWEEN CONVERT(VARCHAR, ValidFrom, 112)
							AND CONVERT(VARCHAR, ValidTo, 112)
						OR CONVERT(VARCHAR, CAST(@ValidTo AS DATETIME), 112) BETWEEN CONVERT(VARCHAR, ValidFrom, 112)
							AND CONVERT(VARCHAR, ValidTo, 112)
						OR CONVERT(VARCHAR, CAST(ValidFrom AS DATETIME), 112) = CONVERT(VARCHAR, CAST(@ValidFrom AS DATETIME), 112)
						OR CONVERT(VARCHAR, CAST(ValidTo AS DATETIME), 112) = CONVERT(VARCHAR, CAST(@ValidTo AS DATETIME), 112)
						)
				)
		BEGIN
		
SELECT '201' AS returnCode, 'Agent category already exist for this period !'   AS returnMessage; 
		END
		ELSE
		BEGIN
			INSERT INTO AgentMarkup (
				AgentCategoryID
				,CodeDescription
				,ValidFrom
				,ValidTo
				,Hotel
				,Transport
				,Guide
				,Monument
				,FlightTrain
				,SpecialService
				,Package
				,IsActive
				,Operation
				,OperationBy
				,OperationOn
				,SupplierID
				)
			VALUES (
				@AgentCategoryID
				,@CodeDescription
				,@ValidFrom
				,@ValidTo
				,@Hotel
				,@Transport
				,@Guide
				,@Monument
				,@Flight_Train
				,@SpecialService
				,@Package
				,@IsActive
				,'Insert'
				,@OperationBy
				,GETDATE()
				,@SupplierID
				)

		Set @LogID =  SCOPE_IDENTITY()   
		SELECT '200' AS returnCode  ,'Record Added Sucessfully ' AS returnMessage  ,@LogID AS ID;  
		END
	END --I
	ELSE IF @Action = 'U'
	BEGIN
		IF EXISTS (
				SELECT AgentMarkupID
				FROM AgentMarkup
				WHERE AgentCategoryID = @AgentCategoryID
					AND AgentMarkupID <> @AgentMarkupID
					AND SupplierID = @SupplierID --added by sanket @ 25/02/2014    
					AND (
						CONVERT(VARCHAR, CAST(@ValidFrom AS DATETIME), 112) BETWEEN CONVERT(VARCHAR, ValidFrom, 112)
							AND CONVERT(VARCHAR, ValidTo, 112)
						OR CONVERT(VARCHAR, CAST(@ValidTo AS DATETIME), 112) BETWEEN CONVERT(VARCHAR, ValidFrom, 112)
							AND CONVERT(VARCHAR, ValidTo, 112)
						OR CONVERT(VARCHAR, CAST(ValidFrom AS DATETIME), 112) = CONVERT(VARCHAR, CAST(@ValidFrom AS DATETIME), 112)
						OR CONVERT(VARCHAR, CAST(ValidTo AS DATETIME), 112) = CONVERT(VARCHAR, CAST(@ValidTo AS DATETIME), 112)
						)
				)
		BEGIN
		
		SELECT '201' AS returnCode,'Agent category already exist for this period !'   AS returnMessage 
		
		END
		ELSE
		BEGIN
			UPDATE AgentMarkup
			SET AgentCategoryID = @AgentCategoryID
				,CodeDescription = @CodeDescription
				,ValidFrom = @ValidFrom
				,ValidTo = @ValidTo
				,Hotel = @Hotel
				,Transport = @Transport
				,Guide = @Guide
				,Monument = @Monument
				,FlightTrain = @Flight_Train
				,SpecialService = @SpecialService
				,Package = @Package
				,IsActive = @IsActive
				,Operation = 'Update'
				,UpdatedBy = @OperationBy
				,UpdatedOn = GETDATE()
				,SupplierID = @SupplierID --sanket      
			WHERE AgentMarkupID = @AgentMarkupID

			SELECT '200' AS returnCode  ,'Record Updated Sucessfully ' AS returnMessage  ,@AgentMarkupID AS ID; 
		END
	END --U
	ELSE IF @Action = 'S'
	BEGIN
		IF (@IsActive = 0)
		BEGIN
			SELECT AgentMarkupID
				,AgentCategoryID
				,AgentCategoryMaster.CategoryValue
				,CodeDescription
				,ValidFrom
				,ValidTo
				,Hotel
				,Transport
				,Guide
				,Monument
				,FlightTrain
				,SpecialService
				,Package
				,AgentMarkup.IsActive
				,AgentMarkup.Operation
				,AgentMarkup.OperationBy
				,AgentMarkup.OperationOn
				,SupplierID --addded by sanket @ 25/02/2014      
				,CASE 
					WHEN SupplierID = 0
						THEN 'Tamarind'
					ELSE VM.VendorName
					END AS SupplierName
			FROM AgentMarkup
			INNER JOIN AgentCategoryMaster ON AgentCategoryMaster.CategoryID = AgentMarkup.AgentCategoryID
			LEFT JOIN VendorMaster VM ON VM.VendorID = SupplierID
		END
		ELSE
		BEGIN
			SELECT AgentMarkupID
				,AgentCategoryID
				,AgentCategoryMaster.CategoryValue
				,CodeDescription
				,ValidFrom
				,ValidTo
				,Hotel
				,Transport
				,Guide
				,Monument
				,FlightTrain
				,SpecialService
				,Package
				,AgentMarkup.IsActive
				,AgentMarkup.Operation
				,AgentMarkup.OperationBy
				,AgentMarkup.OperationOn
				,SupplierID --addded by sanket @ 25/02/2014       
				,CASE 
					WHEN SupplierID = 952
						THEN 'Tamarind'
					ELSE VM.VendorName
					END AS SupplierName
			FROM AgentMarkup
			INNER JOIN AgentCategoryMaster ON AgentCategoryMaster.CategoryID = AgentMarkup.AgentCategoryID
			LEFT JOIN VendorMaster VM ON VM.VendorID = SupplierID
			WHERE AgentMarkup.IsActive = 1
		END
	END--S
END

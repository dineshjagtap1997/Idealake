-------------------------------------------------------  
CREATE PROCEDURE [dbo].[usp_InsertPlaceOfSupplyLogicMaster] (
	@TypeID INT
	,@ServiceID INT
	,@BuyerLocationID INT
	,@IsGST BIT
	,@IsAddress INT
	,@ServiceLocID INT
	,@POSID INT
	,@POSStateCode INT
	,@IsCommercial BIT
	,@IsActive BIT
	,@Createdby UNIQUEIDENTIFIER
	,@validFrom DATETIME
	,@validTo DATETIME
	,@ErrMsg VARCHAR(50) OUT
	,@Action char(2)='S'
	,@Updatedby UNIQUEIDENTIFIER=''
	,@ID INT =''
	)
AS
BEGIN
IF @Action='I'
BEGIN       
	DECLARE @new_identity INT

	INSERT INTO PlaceOfSupplyLogicMaster (
		TypeID
		,ServiceID
		,BuyerLocationID
		,IsGST
		,IsAddress
		,ServiceLocID
		,POSID
		,POSStateCode
		,IsCommercial
		,ISActive
		,Operation
		,Createdby
		,CreatedDatetime
		,validFrom
		,validTo
		)
	VALUES (
		@TypeID
		,@ServiceID
		,@BuyerLocationID
		,@IsGST
		,@IsAddress
		,@ServiceLocID
		,@POSID
		,@POSStateCode
		,@IsCommercial
		,@ISActive
		,'Insert'
		,@Createdby
		,GETDATE()
		,@validFrom
		,@validTo
		)

	SELECT @new_identity = SCOPE_IDENTITY()

	EXEC usp_InsertPlaceOfSupplyLogic_Audit @new_identity
		,@TypeID
		,@ServiceID
		,@BuyerLocationID
		,@IsGST
		,@IsAddress
		,@ServiceLocID
		,@POSStateCode
		,@IsCommercial
		,@IsActive
		,@validFrom
		,@validTo
		,'Insert'
		,@Createdby

	SET @ErrMsg = ''
		--END            
END
ELSE IF @Action='U'
BEGIN         
	UPDATE PlaceOfSupplyLogicMaster
	SET TypeID = @TypeID
		,ServiceID = @ServiceID
		,BuyerLocationID = @BuyerLocationID
		,IsGST = @IsGST
		,IsAddress = @IsAddress
		,ServiceLocID = @ServiceLocID
		,POSID = @POSID
		,POSStateCode = @POSStateCode
		,IsCommercial = @IsCommercial
		,IsActive = @IsActive
		,Updatedby = @Updatedby
		,Operation = 'Update'
		,validFrom = @validFrom
		,validTo = @validTo
		,UpdatedTime = GETDATE()
	WHERE ID = @ID

	EXEC usp_InsertPlaceOfSupplyLogic_Audit @ID
		,@TypeID
		,@ServiceID
		,@BuyerLocationID
		,@IsGST
		,@IsAddress
		,@ServiceLocID
		,@POSStateCode
		,@IsCommercial
		,@IsActive
		,@validFrom
		,@validTo
		,'Update'
		,@Updatedby

	SET @ErrMsg = ''       
END
ELSE IF @Action='S'
BEGIN
	IF (@IsActive = 0)
	BEGIN
		SELECT CASE 
				WHEN TypeID = 1
					THEN 'B2B'
				WHEN TypeID = 2
					THEN 'B2CWA'
				WHEN TypeID = 3
					THEN 'B2CWOA'
				END AS Type
			,s.Description ServiceType
			,CASE 
				WHEN BuyerLocationID = 1
					THEN 'India'
				WHEN BuyerLocationID = 2
					THEN 'Non India'
				END AS BuyerLoc
			,CASE 
				WHEN POSStateCode = 1
					THEN 'Agent Master'
				WHEN POSStateCode = 2
					THEN 'Tamarind Logged in Branch'
				WHEN POSStateCode = 3
					THEN 'Open to user Selection'
				END AS POsStaeCode
			,su.Description AS ServiceUtilsation
			,validFrom AS validFromDate
			,validTo AS validToDate
			,*
		FROM PlaceOfSupplyLogicMaster p
		INNER JOIN QuotationServiceType_Master s ON p.ServiceID = s.QutServ_ID
		INNER JOIN ServiceLocation_Master su ON p.ServiceLocID = su.ServLoc_ID
	END
	ELSE
	BEGIN
		SELECT *
		FROM PlaceOfSupplyLogicMaster
		WHERE IsActive = 1
	END
END

END
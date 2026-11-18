CREATE PROCEDURE [dbo].[usp_InsertTCSRateMaster] @AcCode NVARCHAR(50)
	,@Description NVARCHAR(50)=''
	,@ValidFrom DATETIME=''
	,@ValidTo DATETIME=''
	,@TCSRate DECIMAL(4, 2)=''
	,@IsActive BIT=''
	,@CreatedBy UNIQUEIDENTIFIER=''
	,@SAPCode NVARCHAR(6)=''
	--,@ErrMsg VARCHAR(50) OUT
	,@Action char(2)=''
	,@TCSID INT =''
	,@Updatedby UNIQUEIDENTIFIER=''

AS
BEGIN
If @Action='I'
BEGIN
	DECLARE @new_identity INT

	INSERT INTO TCSRateMaster (
		ACCode
		,Description
		,ValidFrom
		,ValidTo
		,TCSRate
		,IsActive
		,Operation
		,CreatedBy
		,CreatedDate
		,UpdatedDate
		,SAPCode
		)
	VALUES (
		@AcCode
		,@Description
		,@ValidFrom
		,@ValidTo
		,@TCSRate
		,@IsActive
		,'Insert'
		,@CreatedBy
		,GETDATE()
		,GETDATE()
		,@SAPCode
		)

	SELECT @new_identity = SCOPE_IDENTITY()

	EXEC usp_InsertTCSRateMaster_Audit @new_identity
		,@AcCode
		,@Description
		,@ValidFrom
		,@ValidTo
		,@TCSRate
		,@IsActive
		,'Insert'
		,@CreatedBy
		,@SAPCode

	--SET @ErrMsg = ''
END
ELSE IF @Action='S'

BEGIN
	UPDATE TCSRateMaster
	SET --ACCode    = @AcCode ,  
		Description = @Description
		,ValidFrom = @ValidFrom
		,ValidTo = @ValidTo
		,TCSRate = @TCSRate
		,IsActive = @IsActive
		,Operation = 'Update'
		,Updatedby = @Updatedby
		,UpdatedDate = GETDATE()
		,SAPCode = @SAPCode
	WHERE TCSID = @TCSID

	EXEC usp_InsertTCSRateMaster_Audit @TCSID
		,@AcCode
		,@Description
		,@ValidFrom
		,@ValidTo
		,@TCSRate
		,@IsActive
		,'Update'
		,@Updatedby
		,@SAPCode

	--SET @ErrMsg = ''
END
END
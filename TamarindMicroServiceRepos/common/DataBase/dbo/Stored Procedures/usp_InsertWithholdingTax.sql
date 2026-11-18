-----------------------------------------  
CREATE PROCEDURE [dbo].[usp_InsertWithholdingTax] @Tax_Code CHAR(4)
	,@Description VARCHAR(50)=''
	,@IsActive BIT=''
	,@OperationBy UNIQUEIDENTIFIER=''
	--,@ErrMsg VARCHAR(50) OUT
	,@Action char(2)=''
	,@Tax_ID INT=''
AS
BEGIN 
Declare @LogID int; 
IF @Action='I'
BEGIN
	IF EXISTS (
			SELECT Tax_Code
			FROM Withholding_Tax_Master
			WHERE UPPER(Tax_Code) = UPPER(@Tax_Code)
			)
	BEGIN
	SELECT '201' AS returnCode, 'Tax Code already exists!'   AS returnMessage;  
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

    SET @LogID = SCOPE_IDENTITY()
	SELECT '200' AS returnCode, 'Data Inserted'   AS returnMessage,  @LogID as ID;  
	END
END
ELSE IF @Action='U'
BEGIN
	UPDATE Withholding_Tax_Master
	SET Description = @Description
		,IsActive = @IsActive
		,Operation = 'Update'
		,UpdatedBy = @OperationBy
				,UpdatedOn = GETDATE()
	WHERE Tax_ID = @Tax_ID


	SELECT '200' AS returnCode, 'Data Updated'   AS returnMessage, @Tax_ID as ID;  
END
ELSE IF @Action='S'
BEGIN          
 IF(@IsActive=0)        
 BEGIN        
  SELECT *          
  FROM Withholding_Tax_Master C      
  Order by C.Tax_ID desc    
 END         
 ELSE        
 BEGIN        
  SELECT *          
  FROM Withholding_Tax_Master C         
  WHERE C.IsActive=1        
  Order by C.Tax_ID desc    
 END         
END   

END 

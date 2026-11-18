       
CREATE PROCEDURE [dbo].[usp_InsertVendorPreferred] (
	@VendorID INT=''
	,@ValidFrom DATETIME=NULL
	,@ValidTo DATETIME=NULL
	,@IsPreferred BIT =0
	,@OperationBy UNIQUEIDENTIFIER=NULL
	,@Action char(2)=''
	,@PreferredVendorID INT=''
	--,@ErrMsg VARCHAR(50) OUT
	)
AS
BEGIN
IF @Action='I'
BEGIN
	IF EXISTS (
			SELECT PreferredVendorID
			FROM VendorPreferred
			WHERE VendorID = @VendorID
				AND CONVERT(VARCHAR, CAST(@ValidFrom AS DATETIME), 112) BETWEEN CONVERT(VARCHAR, ValidFrom, 112)
					AND CONVERT(VARCHAR, ValidTo, 112)
			)
	BEGIN
	 SELECT '201' AS returnCode,  'Valid peroid already exist for this vendor!' AS returnMessage;     
	END
	ELSE
	BEGIN
		INSERT INTO VendorPreferred (
			VendorID
			,ValidFrom
			,ValidTo
			,IsPreferred
			,Operation
			,OperationBy
			,OperationOn
			)
		VALUES (
			@VendorID
			,@ValidFrom
			,@ValidTo
			,@IsPreferred
			,'Insert'
			,@OperationBy
			,GETDATE()
			)
	
	
	SELECT '200' AS returnCode, 'New record added successfully' AS returnMessage;     

	END

END
ELSE IF @Action='U'
BEGIN        
        
  IF EXISTS (SELECT PreferredVendorID FROM VendorPreferred         
    WHERE VendorID=@VendorID      
    AND CONVERT(varchar,CAST(@ValidFrom AS datetime),112) BETWEEN CONVERT(varchar,ValidFrom,112) AND  CONVERT(varchar,ValidTo,112)        
    AND PreferredVendorID <> @PreferredVendorID)        
            
  BEGIN
  SELECT '200' AS returnCode, 'Valid peroid already exist for this vendor!'   AS returnMessage;        
  END        
  ELSE        
  BEGIN        
    UPDATE  VendorPreferred           
    SET  VendorID=@VendorID,        
      ValidFrom=@ValidFrom,        
      ValidTo=@ValidTo,        
      IsPreferred=@IsPreferred,        
      Operation='Update',         
      OperationBy=@OperationBy,        
      OperationOn=GETDATE()        
        
    WHERE PreferredVendorID=@PreferredVendorID  
		
	SELECT '200' AS returnCode, 'Record updated successfully.' AS returnMessage;     
        
  END        
         
END 

ELSE IF @Action='S'
BEGIN          
        
 BEGIN        
  SELECT PreferredVendorID,VP.VendorID,ValidFrom,ValidTo,IsPreferred,        
    VendorName         
  FROM VendorPreferred VP       
  INNER JOIN VendorMaster VM ON VM.VendorID=VP.VendorID   
  WHERE  (@PreferredVendorID IS NULL OR @PreferredVendorID = 0  OR PreferredVendorID = @PreferredVendorID )  
 
 END         
END 

END
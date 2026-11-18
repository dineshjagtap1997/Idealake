CREATE PROCEDURE [dbo].[usp_VehicleTypeMaster] @VehicleType VARCHAR(50) = ''                
 ,@MISSequence INT = ''                
 ,@IsActive BIT = ''                
 ,@OperationBy UNIQUEIDENTIFIER = NULL                
 --,@ErrMsg VARCHAR(50) = NULL                
 ,@IsOnline BIT = 0                
 ,@DisplayName VARCHAR(100) = NULL                
 ,@Action CHAR(2) = ''                
 ,@VehicleTypeID INT = ''                
AS                
BEGIN            
        
Declare @LogID int;         
 IF @Action = 'I'                
 BEGIN                
  IF EXISTS (                
    SELECT TOP 1 1                
    FROM VehicleTypeMaster                
    WHERE VehicleType = @VehicleType                
    )                
  BEGIN                
   SELECT '201' AS returnCode, 'Vehicle Type already exists. Please check and try again.' AS returnMessage                
  END                
  ELSE                
  BEGIN                
   DECLARE @MaxID INT = (                
     SELECT MAX(OldID)                
     FROM VehicleTypeMaster                
     ) + 1                
                
   INSERT INTO VehicleTypeMaster (                
    VehicleType                
    ,IsActive                
    ,MISSequence                
    ,Operation                
    ,OperationBy                
    ,OldID                
    ,IsOnline                
    ,DisplayName                
    )                
   VALUES (                
    @VehicleType ,    
 @IsActive    
    ,@MISSequence             
    ,'Insert'                
    ,@OperationBy                
    ,@MaxID                
    ,@IsOnline                
    ,@DisplayName                
    )                
                
   --EXEC usp_InsertVehicleTypeMaster_Audit @@IDENTITY                
   -- ,'Insert'                
   -- ,@OperationBy              
  Set @LogID =  SCOPE_IDENTITY()         
  SELECT '200' AS returnCode, 'New record added successfully.' AS returnMessage , @LogID as ID;               
  END                
 END --I                
 ELSE IF @Action = 'U'                
 BEGIN                
  IF NOT EXISTS (                
    SELECT TOP 1 1                
    FROM VehicleTypeMaster                
    WHERE VehicleType = @VehicleType                
     AND ID != @VehicleTypeID                
    )                
  BEGIN                
   UPDATE VehicleTypeMaster                
   SET VehicleType = isnull(@VehicleType,VehicleType)               
    ,MISSequence = isnull(@MISSequence,MISSequence)                
    ,IsActive = isnull(@IsActive,  IsActive   )           
    ,Operation = 'Update'                
      ,UpdatedBy = isnull(@OperationBy,OperationBy)               
    ,UpdatedOn = GETDATE()                
    ,IsOnline =ISNULL( @IsOnline,IsOnline)                
    ,DisplayName =ISNULL( @DisplayName ,DisplayName)               
   WHERE ID = @VehicleTypeID                
                
   --EXEC usp_InsertVehicleTypeMaster_Audit @VehicleTypeID                
   -- ,'Update'                
   -- ,@OperationBy                
                
   SELECT '200' AS returnCode, 'Record updated successfully.' AS returnMessage  , @VehicleTypeID AS ID;              
  END                
  ELSE                
  BEGIN                
   SELECT '201' AS returnCode, 'Vehicle Type already exists. Please check and try again.' AS returnMessage                
  END                
 END -- U                
 ELSE IF @Action = 'S'                
 BEGIN                
  SELECT ID AS VehicleTypeID                
   ,VehicleType                
   ,MISSequence                
   ,IsActive                
   ,IsOnline                
   ,DisplayName                
  FROM VehicleTypeMaster                
  WHERE (@VehicleTypeID IS NULL OR @VehicleTypeID = 0 OR ID = @VehicleTypeID)                
  ORDER BY ID DESC                  
  --SELECT '' AS returnCode, '' AS returnMessage                
 END --S    
 --ELSE IF @Action = 'EX'                
 --BEGIN                
 -- SELECT                
 --  VehicleType                
 --,CASE   
 --       WHEN IsActive = 1 THEN 'True'  
 --       WHEN IsActive = 0 THEN 'False'  
 --   END AS IsActive                 
 --,CASE   
 --       WHEN IsOnline = 1 THEN 'Yes'  
 --       WHEN IsOnline = 0 THEN 'No'  
 --   END AS IsOnline                 
 --  ,DisplayName                
 -- FROM VehicleTypeMaster                
 -- WHERE (@VehicleTypeID IS NULL OR @VehicleTypeID = 0 OR ID = @VehicleTypeID)                
 -- ORDER BY ID DESC                  
 -- --SELECT '' AS returnCode, '' AS returnMessage                
 --END --S
 ELSE IF @Action = 'EX'                
BEGIN                
	SELECT                
		VehicleType,                
		IsActive,                
		IsOnline,                
		DisplayName                
	FROM VehicleTypeMaster                
	WHERE (@VehicleTypeID IS NULL OR @VehicleTypeID = 0 OR ID = @VehicleTypeID)                
	ORDER BY ID DESC                  
END

END 
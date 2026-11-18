CREATE PROCEDURE [dbo].[GSTTypeMaster_proc]       
 @GstTypename NVARCHAR(20),      
 @IsActive BIT,      
 @OperationBy UNIQUEIDENTIFIER,      
 @Action CHAR(2) = '',      
 @GSTID INT = ''      
AS      
BEGIN      
  Declare @LogID int;       
 -- Insert action      
 IF @Action = 'I'      
 BEGIN      
  -- Check if GSTTypeName already exists      
  IF EXISTS (      
   SELECT GSTID      
   FROM GSTTypeMaster      
   WHERE GstTypename = @GstTypename      
   )      
  BEGIN      
   -- Return error if exists      
   Select '201' AS ReturnCode, 'Gst Type name already exists. Please check and try again.' AS ReturnMessage, @LogID as ID       
  END      
  ELSE      
  BEGIN      
   -- Insert new record      
   INSERT INTO GSTTypeMaster (      
    GSTTypeName, IsActive, Operation, OperationBy, OperationOn      
   )      
   VALUES (      
    @GstTypename, @IsActive, 'Insert', @OperationBy, GETDATE()      
   )      
   SET @LogID = SCOPE_IDENTITY()    
   Select '200' AS ReturnCode, 'New record added successfully.' AS ReturnMessage , @LogID AS ID       
  END      
 END      
      
 -- Update action      
 ELSE IF @Action = 'U'      
 BEGIN      
  -- Check if GSTTypeName already exists for a different GSTID      
  IF NOT EXISTS (      
   SELECT GSTID      
   FROM GSTTypeMaster      
   WHERE GstTypename = @GstTypename      
    AND GSTID != @GSTID      
   )      
  BEGIN      
   -- Check if GSTID exists for updating      
   IF EXISTS (      
    SELECT GSTID      
    FROM GSTTypeMaster      
    WHERE GSTID = @GSTID      
   )      
   BEGIN      
    -- Perform update if GSTID exists      
    UPDATE GSTTypeMaster      
    SET GSTTypeName = @GstTypename,      
     IsActive = @IsActive,      
     Operation = 'Update',      
     OperationBy = @OperationBy,      
     OperationOn = GETDATE()      
    WHERE GSTID = @GSTID      
    Select '200' AS ReturnCode, 'Record updated successfully.' AS ReturnMessage , @GSTID AS ID      
   END      
   ELSE      
   BEGIN      
    -- Return error if no matching GSTID found      
    Select '202' AS ReturnCode, 'No data found to update.' AS ReturnMessage       
   END      
  END      
  ELSE      
  BEGIN      
   -- Return error if GSTTypeName already exists      
   Select '203' AS ReturnCode, 'Gst Type name already exists. Please check and try again.' AS ReturnMessage       
  END      
 END      
      
 -- Select action      
 ELSE IF @Action = 'S'      
 BEGIN      
  -- Fetch all records      
  SELECT *       
  FROM GSTTypeMaster      
  WHERE (@GSTID IS NULL OR @GSTID = 0) OR GSTID = @GSTID      
  ORDER BY GSTID desc   
        
  -- Return success message      
 -- SELECT '200' AS returnCode, 'Data Fetched' AS returnMessage;      
 END      

 ELSE IF @Action = 'EX'      
 BEGIN      
  -- Fetch all records      
<<<<<<< HEAD
<<<<<<< HEAD
  SELECT GSTTypeName,
=======
  SELECT 
  GSTID,
  GSTTypeName,
>>>>>>> dev
=======
  SELECT 
  GSTID,
  GSTTypeName,
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
  CASE 
		WHEN IsActive = 1 THEN 'True'
		WHEN IsActive = 0 THEN 'False'
		END AS IsActive  	
  FROM GSTTypeMaster      
  WHERE (@GSTID IS NULL OR @GSTID = 0) OR GSTID = @GSTID      
  ORDER BY GSTID desc   
          
 END         
END 
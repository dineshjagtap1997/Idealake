CREATE PROCEDURE [dbo].[usp_Nationality_Master] @ID INT = NULL                
 ,@Nationality VARCHAR(50) = ''                
 ,@HeaderInfo_Nationality VARCHAR(50) = ''                
 ,@IsActive BIT = ''                
 ,@OperationBy UNIQUEIDENTIFIER = NULL                
 ,@Action CHAR(2) = ''                
AS                
BEGIN                
 IF @Action = 'I'                
 BEGIN                
  BEGIN                
   IF NOT EXISTS (                
     SELECT TOP 1 1                
     FROM Nationality                
     WHERE Nationality = @Nationality                
     )                
   BEGIN                
    INSERT INTO Nationality (                
     Nationality                
     ,IsActive                
     ,Operation                
     ,OperationBy                
     ,OperationOn                
     ,HeaderInfo_Nationality                
     )                
    VALUES (                
     @Nationality                
     ,@IsActive                
     ,'Insert'                
     ,@OperationBy                
     ,GETDATE()                
     ,@HeaderInfo_Nationality                
     )                
                
    --EXEC usp_InsertNationality_Audit @@IDENTITY                
    -- ,'Insert'                
    -- ,@HeaderInfo_Nationality                
    -- ,@OperationBy                
          
  Set @ID =  SCOPE_IDENTITY()         
    SELECT '200' AS returnCode ,'New record added successfully.' AS returnMessage, @ID as ID;                
   END                
   ELSE                
   BEGIN                
    SELECT '201' AS returnCode                
     ,'Nationality already exists. Please check and try again.' AS returnMessage                
   END                
  END                
 END                
                
 IF @Action = 'U'                
 BEGIN                
  -- Check if the nationality name exists with a different ID                    
  IF NOT EXISTS (                
    SELECT 1                
    FROM Nationality                
    WHERE Nationality = @Nationality                
     AND ID != @ID                
    )                
  BEGIN                
   -- Update the nationality record                    
   UPDATE Nationality                
   SET Nationality = @Nationality                
    ,HeaderInfo_Nationality = @HeaderInfo_Nationality                
    ,IsActive = @IsActive                
    ,Operation = 'Update'                
    ,UpdatedBy = @OperationBy                
    ,UpdatedOn = GETDATE()                
   WHERE ID = @ID;                
                
   --EXEC usp_InsertNationality_Audit @NationalityID = @ID                
   -- ,@Operation = 'Update'                
   -- ,@HeaderInfo_Nationality = @HeaderInfo_Nationality                
   -- ,@OperationBy = @OperationBy;                
                
   SELECT '200' AS ReturnCode ,'Record updated successfully.' AS ReturnMessage ,  @ID as ID;                
  END                
  ELSE                
  BEGIN                
   SELECT '201' AS ReturnCode                
    ,'Nationality already exists. Please check and try again.' AS ReturnMessage                
  END                
 END                
 ELSE IF @Action = 's'                
 BEGIN              
                
  IF (@IsActive = 0)                
  BEGIN                
   SELECT ID                
    ,Nationality                
    ,HeaderInfo_Nationality                
    ,IsActive                
   FROM Nationality                
   WHERE  (@ID IS NULL OR @ID = 0 OR ID = @ID)            
   ORDER BY ID DESC          
  END                
  ELSE                
  BEGIN                
   SELECT ID                
    ,Nationality                
    ,HeaderInfo_Nationality                
    ,IsActive                
   FROM Nationality                
   WHERE IsActive = 1 AND (@ID IS NULL OR @ID = 0 OR ID = @ID)            
   ORDER BY ID DESC          
  END             
  --SELECT '200' AS returnCode        
  --   ,'This data already exists. Please check and try again' AS returnMessage              
 END  
 ELSE IF @Action='EX'
 BEGIN
  IF (@IsActive = 0)                
  BEGIN                
   SELECT                 
    Nationality                
    ,HeaderInfo_Nationality                
   ,CASE   
        WHEN IsActive = 1 THEN 'True'  
        WHEN IsActive = 0 THEN 'False'  
    END AS IsActive                
   FROM Nationality                
   WHERE  (@ID IS NULL OR @ID = 0 OR ID = @ID)            
   ORDER BY ID DESC          
  END                
  ELSE                
  BEGIN                
   SELECT Nationality                
    ,HeaderInfo_Nationality                
   ,CASE   
        WHEN IsActive = 1 THEN 'True'  
        WHEN IsActive = 0 THEN 'False'  
    END AS IsActive                
   FROM Nationality                
   WHERE IsActive = 1 AND (@ID IS NULL OR @ID = 0 OR ID = @ID)            
   ORDER BY ID DESC          
  END     
 END
END 
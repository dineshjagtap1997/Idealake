CREATE PROCEDURE [dbo].[usp_ClassType_Master] @MOT INT = ''                      
 ,@Class VARCHAR(50) = NULL                      
 ,@IsActive BIT = 1                      
 ,@OperationBy UNIQUEIDENTIFIER = ''                      
 --,@ErrMsg VARCHAR(50) = ''                        
 ,@Action CHAR(2) = ''                      
 ,@ID INT = NULL                      
 --,@Active BIT = 1                        
AS                      
BEGIN                      
 DECLARE @returnCode NVARCHAR(3)                      
  ,@returnMessage NVARCHAR(MAX)            
  ,@LogID int;          
                      
 IF @Action = 'I'                      
 BEGIN                      
  IF NOT EXISTS (                      
    SELECT TOP 1 1                      
    FROM ClassType                      
    WHERE Class = @Class                      
     AND MOT = @MOT                      
    )                      
  BEGIN                      
   --DECLARE @MaxID INT = (                        
   --  SELECT MAX(OldID)                        
   --  FROM ClassType                        
   --  ) + 1                        
   INSERT INTO ClassType (                      
    MOT                      
    ,Class                      
    ,IsActive                      
    ,Operation                      
    ,OperationBy                      
    ,OperationOn                      
    ,OldID                      
    ,UpdatedBy                      
    )                      
   VALUES (                      
    @MOT                      
    ,@Class                      
    ,@IsActive                      
    ,'Insert'                      
    ,@OperationBy                      
    ,GETDATE()                      
    ,'1'                      
    ,'00000000-0000-0000-0000-000000000000'                      
    )                      
                      
   --EXEC usp_InsertClassType_Audit @@IDENTITY                        
   -- ,'Insert'                        
   -- ,@OperationBy                        
   --SELECT @ID AS ClassTypeID             
             
   Set @LogID =  @@identity            
                      
   SET @returnCode = '200';                      
   SET @returnMessage = 'New record added successfully.';                      
   SELECT '200' as returnCode, 'New record added successfully.' as returnMessage ,@LogID AS ID;                   
  END                      
  ELSE                      
  BEGIN                      
 -- SELECT @ID AS ClassTypeID                       
                      
   SET @returnCode = '201';                      
   SET @returnMessage = 'Class Type already exists. Please check and try again.';           
   SELECT '201' as returnCode, 'Class Type already exists. Please check and try again.' as returnMessage;              
  END                      
 END                      
 ELSE IF @Action = 'U'                      
 BEGIN                      
  UPDATE ClassType                      
  SET MOT = ISNULL(@MOT,MOT)                   
   ,Class = ISNULL(@Class,Class)                    
   ,IsActive =ISNULL(@IsActive,IsActive)                    
   ,Operation = 'Update'                      
   ,UpdatedBy = @OperationBy                    
   ,UpdatedOn = GETDATE()                      
  WHERE ID = @ID                      
                      
  --EXEC usp_InsertClassType_Audit @ID                        
  -- ,'Update'                        
  -- ,@OperationBy                        
  --SELECT @ID AS ClassTypeID                      
                      
   SET @returnCode = '200';                      
   SET @returnMessage = 'New record added successfully.';                      
   SELECT @returnCode as returnCode, @returnMessage as returnMessage ,@ID AS ID;             
 END                      
 ELSE IF @Action = 'S'                      
 BEGIN                      
                      
  IF EXISTS (                      
    SELECT 1                      
    FROM ClassType c WITH (NOLOCK)                      
    INNER JOIN MOT m ON m.ID = c.MOT                         
    )                      
  BEGIN                      
   SELECT c.ID                      
    ,M.MOT AS MOTNAME                     
    ,c.Class             
    ,C.MOT                      
   -- ,m.OperationBy                      
    ,c.IsActive                      
   FROM ClassType c WITH (NOLOCK)                      
   INNER JOIN MOT m ON m.ID = c.MOT          
   where                 
      (                  
    @ID IS NULL                  
    OR @ID = 0                  
    OR C.ID = @ID                  
    )                  
 ORDER BY c.ID DESC;                
   SET @returnCode = '200';                      
   SET @returnMessage = 'Success';                      
  END                      
  ELSE                      
  BEGIN                      
  SELECT @ID AS ClassTypeID                      
                      
                       
  END                      
                      
                       
 END           
 ELSE IF @Action='EX'  
 BEGIN                      
                      
  IF EXISTS (                      
    SELECT 1                      
    FROM ClassType c WITH (NOLOCK)                      
    INNER JOIN MOT m ON m.ID = c.MOT                         
    )                      
  BEGIN                      
   SELECT                       
    M.MOT AS MOTNAME                     
    ,c.Class             
   -- ,m.OperationBy                      
    ,CASE   
        WHEN C.IsActive = 1 THEN 'True'  
        WHEN C.IsActive = 0 THEN 'False'  
    END AS IsActive                     
   FROM ClassType c WITH (NOLOCK)                      
   INNER JOIN MOT m ON m.ID = c.MOT          
   where                 
      (                  
    @ID IS NULL                  
    OR @ID = 0                  
    OR C.ID = @ID                  
    )                  
 ORDER BY c.ID DESC;                
   SET @returnCode = '200';                      
   SET @returnMessage = 'Success';                      
  END                      
  ELSE                      
  BEGIN                      
  SELECT @ID AS ClassTypeID                      
                      
                       
  END                      
                      
                       
 END          
  --SELECT @returnCode AS returnCode            
  -- ,@returnMessage AS returnMessage;                      
END
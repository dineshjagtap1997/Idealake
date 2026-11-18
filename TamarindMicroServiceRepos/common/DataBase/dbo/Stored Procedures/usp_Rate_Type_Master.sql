CREATE PROCEDURE [dbo].[usp_Rate_Type_Master] @Rate_Type_Name VARCHAR(50) =''                     
 ,@IsActive BIT  =''                    
 ,@OperationBy UNIQUEIDENTIFIER =''                     
 ,@Rate_Type_Code VARCHAR(50)=''                      
 --,@ErrMsg VARCHAR(50) OUT                      
 ,@Action CHAR(2)=''                      
   ,@Rate_Type_ID int =''                    
AS                      
BEGIN         
Declare @LogID int;    
IF @Action='I'                       
BEGIN                      
 IF EXISTS (                      
   SELECT TOP 1 1                      
   FROM Rate_Type                      
   WHERE Rate_Type_Name = @Rate_Type_Name                      
   )                      
 BEGIN                      
 SELECT '201' AS returnCode, 'Rate Type already exists. Please check and try again.'   AS returnMessage, @LogID AS ID;                      
                        
 END                      
 ELSE IF EXISTS (                      
   SELECT TOP 1 1                      
   FROM Rate_Type                      
   WHERE Rate_Type_Code = @Rate_Type_Code                      
   )                      
 BEGIN                      
 SELECT '201' AS returnCode, 'Rate Type already exists. Please check and try again.'   AS returnMessage, @LogID AS ID;                      
 END                      
 ELSE                      
 BEGIN                      
  DECLARE @MaxID INT = (                      
    SELECT MAX(OldID)                      
    FROM Rate_Type                      
    ) + 1                      
                      
  INSERT INTO Rate_Type (                      
   Rate_Type_Name                      
   ,IsActive                      
   ,Operation                      
   ,OperationBy                      
   ,OperationOn                      
   ,OldID                      
   ,Rate_Type_Code                      
   )                      
  VALUES (                      
   @Rate_Type_Name                      
   ,@IsActive                      
   ,'Insert'                      
   ,@OperationBy                      
   ,GETDATE()                      
   ,@MaxID                      
   ,@Rate_Type_Code                      
   )                      
                      
  --EXEC usp_InsertRate_Type_Audit @@IDENTITY                      
  -- ,'Insert'                      
  -- ,@OperationBy                      
  SET @LogID = SCOPE_IDENTITY()                     
 SELECT '200' AS returnCode, 'New record added successfully.' AS returnMessage, @LogID AS ID;                      
 END                      
END                      
ELSE IF @Action='U'                      
BEGIN                    
 IF EXISTS (                    
   SELECT TOP 1 1                    
   FROM Rate_Type                    
   WHERE Rate_Type_Name = @Rate_Type_Name                    
    AND Rate_Type_ID != @Rate_Type_ID                    
   )                    
 BEGIN                    
  SELECT '201' AS returnCode, 'Rate Type already exists. Please check and try again.'   AS returnMessage, @Rate_Type_ID AS ID;                      
 END                    
 ELSE IF EXISTS (                    
   SELECT TOP 1 1                    
   FROM Rate_Type                    
   WHERE Rate_Type_Code = @Rate_Type_Code                    
    AND Rate_Type_ID != @Rate_Type_ID                    
   )                    
 BEGIN                    
   SELECT '201' AS returnCode, 'Rate Type already exists. Please check and try again.'   AS returnMessage , @LogID AS ID;                      
 END                    
 ELSE                    
 BEGIN                    
  UPDATE Rate_Type                    
  SET Rate_Type_Name = @Rate_Type_Name                    
   ,IsActive = @IsActive                    
   ,Operation = 'Update'                    
   ,UpdatedBy = @OperationBy                  
   ,UpdatedOn = GETDATE()                  
   ,Rate_Type_Code = @Rate_Type_Code                    
  WHERE Rate_Type_ID = @Rate_Type_ID                    
                      --EXEC usp_InsertRate_Type_Audit @Rate_Type_ID                    
  -- ,'Update'                    
  -- ,@OperationBy                    
                    
   SELECT '200' AS returnCode, 'Record updated successfully.'   AS returnMessage, @Rate_Type_ID AS  ID ;                      
 END                    
END                    
ELSE IF @Action='S'                      
BEGIN                    
 SELECT Rate_Type_ID                    
 ,Rate_Type_Name        
 ,IsActive                    
 ,Rate_Type_Code                    
 FROM Rate_Type                    
 WHERE (Rate_Type_ID IS NULL OR @Rate_Type_ID = 0 OR Rate_Type_ID = @Rate_Type_ID)                    
   ORDER By Rate_Type_ID DESC              
   --SELECT '200' AS returnCode, 'Data Retrived'   AS returnMessage;                      
                    
END                    
ELSE IF @Action='EX'  
BEGIN  
SELECT Rate_Type_Name        
 ,CASE   
        WHEN IsActive = 1 THEN 'True'  
        WHEN IsActive = 0 THEN 'False'  
    END AS IsActive                    
 ,Rate_Type_Code                    
 FROM Rate_Type                    
 WHERE (Rate_Type_ID IS NULL OR @Rate_Type_ID = 0 OR Rate_Type_ID = @Rate_Type_ID)                    
   ORDER By Rate_Type_ID DESC   
END  
END                    
--SELECT * FROM Rate_Type 
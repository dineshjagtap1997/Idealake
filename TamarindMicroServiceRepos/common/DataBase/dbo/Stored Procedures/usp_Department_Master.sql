CREATE PROCEDURE [dbo].[usp_Department_Master]                    
(                    
@Dept_Name  varchar(50)='',                    
@IsActive  bit='',                    
@OperationBy uniqueidentifier= null,                    
@Action char(2)='S',                  
@ID INT =''                  
)                    
AS                    
BEGIN                  
IF @Action='I'                  
BEGIN                  
                    
IF EXISTS(SELECT TOP 1 1 FROM Department WHERE UPPER(Dept_Name)=UPPER(@Dept_Name))                    
 BEGIN                    
 SELECT '201' AS returnCode, 'Department Name already exists. Please check and try again.' AS returnMessage;                    
 END                    
ELSE                    
 BEGIN                    
 INSERT INTO Department (Dept_Name,IsActive,Operation,OperationBy,OperationOn)                    
   VALUES (@Dept_Name,@IsActive,'INSERT',@OperationBy,GETDATE())                    
                       
   --EXEC usp_InsertDepartment_Audit @@IDENTITY,'INSERT', @OperationBy                    
              
  Set @ID =  SCOPE_IDENTITY()               
  SELECT '200' AS returnCode, 'New record added successfully.'   AS returnMessage, @ID AS ID;                    
 END                   
 END-- I                  
 ELSE IF @Action='U'                  
 BEGIN                  
 IF EXISTS(SELECT TOP 1 1 FROM Department WHERE UPPER(Dept_Name)=UPPER(@Dept_Name) AND ID<>@ID)                    
 BEGIN                    
  SELECT '201' AS returnCode, 'Department Name already exists. Please check and try again.'   AS returnMessage;                    
 END                    
ELSE                    
 BEGIN                    
  UPDATE Department SET                    
  Dept_Name=ISNULL(@Dept_Name,Dept_Name),                    
  IsActive=ISNULL(@IsActive,IsActive),                    
  Operation='UPDATE'                  
  ,UpdatedBy = ISNULL(@OperationBy,OperationBy)                 
  ,UpdatedOn = GETDATE()                   
  WHERE ID=@ID                    
                      
  --EXEC usp_InsertDepartment_Audit @ID,'UPDATE', @OperationBy                    
                       
  SELECT '200' AS returnCode, 'Record updated successfully.'   AS returnMessage,  @ID AS ID;                    
                       
                       
 END                    
                  
END --U                    
ELSE IF @Action='S'                  
BEGIN                   
                  
SELECT ID,Dept_Name,IsActive                    
FROM Department                  
WHERE (@ID IS NULL OR @ID = 0 OR ID = @ID)                
order By 1 desc              
                  
END                
      
ELSE IF @Action='EX'                  
BEGIN                   
                  
SELECT Dept_Name,CASE   
        WHEN IsActive = 1 THEN 'True'  
        WHEN IsActive = 0 THEN 'False'  
    END AS IsActive                     
FROM Department                  
WHERE (@ID IS NULL OR @ID = 0 OR ID = @ID)                
order By 1 desc                
                  
END                  
      
END 
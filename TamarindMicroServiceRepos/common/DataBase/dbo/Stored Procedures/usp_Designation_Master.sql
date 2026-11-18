CREATE PROCEDURE [dbo].[usp_Designation_Master]                    
(                    
@Desg_Name  varchar(50)= '' ,                    
@IsActive  bit='',                    
@OperationBy uniqueidentifier=null,                    
--@ErrMsg   VARCHAR(50) ='',                  
@Action char (2)='',                  
@ID INT =''                  
)                    
AS                    
BEGIN                    
IF @Action='I'                  
BEGIN                   
IF EXISTS(SELECT TOP 1 1 FROM Designation WHERE UPPER(Desg_Name)=UPPER(@Desg_Name))                    
 BEGIN                    
 SELECT '201' AS returnCode, 'Designation Name already exists. Please check and try again.' AS returnMessage;                  
 END                    
ELSE                    
 BEGIN                    
 INSERT INTO Designation (Desg_Name,IsActive,Operation,OperationBy,OperationOn)                    
   VALUES   (@Desg_Name,@IsActive,'INSERT',@OperationBy, GETDATE())                    
                       
   --EXEC usp_InsertDesignation_Audit @@IDENTITY,'INSERT', @OperationBy                    
   Set @ID =  SCOPE_IDENTITY()                       
  SELECT '200' AS returnCode, 'New record added successfully.'   AS returnMessage, @ID AS ID;                  
 END                   
 END--I                  
 ELSE IF @Action='U'                  
 BEGIN                  
 IF EXISTS(SELECT TOP 1 1 FROM Designation WHERE UPPER(Desg_Name)=UPPER(@Desg_Name) AND ID<>@ID)                    
 BEGIN                    
  SELECT '201' AS returnCode, 'Designation Name already exists. Please check and try again.'   AS returnMessage, @ID AS ID;                  
 END                    
ELSE                    
 BEGIN                    
  UPDATE Designation SET                    
  Desg_Name=ISNULL(@Desg_Name,Desg_Name) ,                   
  IsActive=ISNULL(@IsActive,IsActive) ,                   
  Operation='UPDATE'                
 ,UpdatedBy = ISNULL(@OperationBy, OperationBy)               
 ,UpdatedOn = GETDATE()                   
  WHERE ID=@ID                    
                      
  --EXEC usp_InsertDesignation_Audit @ID,'UPDATE', @OperationBy                    
                       
  SELECT '200' AS returnCode, 'Record updated successfully.'   AS returnMessage, @ID AS ID;                   
                       
                       
 END                    
 END--U                  
 ELSE IF @Action='S'                  
 BEGIN                  
                  
                  
SELECT ID,Desg_Name,IsActive,Operation,OperationBy,OperationOn                    
FROM Designation                
WHERE (@ID IS NULL OR @ID = 0 OR ID = @ID)              
Order by ID DESC            
                
                  
 END                  
 ELSE IF @Action='EX'                  
 BEGIN                  
                  
SELECT Desg_Name,CASE   
        WHEN IsActive = 1 THEN 'True'  
        WHEN IsActive = 0 THEN 'False'  
    END AS IsActive                     
FROM Designation                
WHERE (@ID IS NULL OR @ID = 0 OR ID = @ID)              
Order by ID DESC            
                  
 END             
END 
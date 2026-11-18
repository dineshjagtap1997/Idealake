CREATE PROCEDURE [dbo].[usp_Agent_Classification_Master] @Description NVARCHAR(50)            
 ,@IsActive BIT            
 ,@OperationBy UNIQUEIDENTIFIER            
 --,@ErrMsg VARCHAR(50) OUT            
 ,@Action CHAR(2)=''            
 ,@ID INT =''            
AS            
BEGIN         
      
 Declare @LogID int;       
IF @Action='I'            
BEGIN            
 DECLARE @new_identity INT            
  IF EXISTS(SELECT TOP 1 1 FROM Agent_Classification_Master WHERE UPPER(Description) = UPPER(@Description))          
  BEGIN         
   SELECT '201' AS returnCode, 'This Description already exists. Please check and try again.' AS returnMessage;          
  END         
  ELSE         
  BEGIN        
 INSERT INTO Agent_Classification_Master (            
  Description            
  ,IsActive            
  ,Operation            
  ,CreatedBy            
  ,CreatedDate            
  ,Updatedby            
  ,UpdatedOn            
  )            
 VALUES (            
  @Description            
  ,@IsActive            
  ,'Insert'            
  ,@OperationBy            
  ,GETDATE()            
  ,@OperationBy            
  ,GETDATE()            
  )            
            
 SELECT @new_identity = SCOPE_IDENTITY()            
             
            
SELECT '200' AS returnCode, 'New record added successfully.'   AS returnMessage, @new_identity as ID; END         
END        
 --ELSE IF @Action='U'            
 --BEGIN            
 --UPDATE Agent_Classification_Master            
 --SET Description = @Description            
 -- ,IsActive = @IsActive            
 -- ,Operation = 'Update'            
 --   ,UpdatedBy = @OperationBy            
 --   ,UpdatedOn = GETDATE()            
 --WHERE ID = @ID        
     
 ELSE IF @Action='U'            
BEGIN            
    -- Check for duplicate description excluding the current record    
    IF EXISTS (    
        SELECT 1     
        FROM Agent_Classification_Master    
        WHERE Description = @Description    
        AND ID <> @ID    
    )    
    BEGIN    
        SELECT '201' AS returnCode, 'This description already exists. Please check and try again.' AS returnMessage;    
    END    
    ELSE    
    BEGIN            
        UPDATE Agent_Classification_Master            
        SET Description = @Description            
            ,IsActive = @IsActive            
            ,Operation = 'Update'            
            ,UpdatedBy = @OperationBy            
            ,UpdatedOn = GETDATE()            
        WHERE ID = @ID;      
    
        SELECT '200' AS returnCode, 'Record updated successfully.' AS returnMessage, @ID AS ID;    
    END    
END    
           
ELSE IF @Action='S'            
BEGIN           
  SELECT *            
  FROM Agent_Classification_Master C           
  where (       @ID IS NULL       OR @ID = 0       OR ID = @ID       )            
  ORDER BY C.ID DESC            
 END     
            
ELSE IF @Action='EX'            
BEGIN           
  SELECT  Description, IsActive            
  FROM Agent_Classification_Master C           
  where (       @ID IS NULL       OR @ID = 0       OR ID = @ID       )            
  ORDER BY C.ID DESC            
 END  
END            
            
--select * from Agent_Classification_Master
CREATE PROCEDURE [dbo].[usp_LandMarks_Master]               
 @LandMarkName VARCHAR(50)  =''            
 ,@IsActive BIT              
 ,@OperationBy UNIQUEIDENTIFIER              
 --,@ErrMsg VARCHAR(50) OUT              
 ,@Action char(2)=''              
 ,@LandMarkID int =''              
AS              
BEGIN           
Declare @LogID int;  
IF @Action='I'              
BEGIN              
IF EXISTS (              
  SELECT LandMarkID              
  FROM LandMarksMaster              
  WHERE Upper(LandMarkName) = upper(@LandMarkName)              
  )              
BEGIN              
              
SELECT '201' AS returnCode, 'Location code already exists. Please check and try again.'  AS returnMessage, @LogID as ID;               
END              
ELSE              
BEGIN              
 DECLARE @MaxID INT = (              
   SELECT MAX(OldID)              
   FROM LandMarksMaster              
   ) + 1              
              
 INSERT INTO LandMarksMaster (              
  LandMarkName              
  ,IsActive              
  ,Operation              
  ,OperationBy              
  ,OperationOn              
  ,OldID              
  )              
 VALUES (              
  @LandMarkName              
  ,@IsActive              
  ,'Insert'              
  ,@OperationBy              
  ,GETDATE()              
  ,@MaxID              
  )              
     
   SET @LogID = SCOPE_IDENTITY()  
 SELECT '200' AS returnCode, 'New record added successfully.'  AS returnMessage, @LogID AS ID;               
  --EXEC   usp_InsertMOT_Audit  @@IDENTITY, 'Insert', @OperationBy                    
END              
END--I              
ELSE IF @Action='U'              
BEGIN                
 IF NOT EXISTS(SELECT LandMarkID FROM LandMarksMaster WHERE Upper(LandMarkName) = Upper(@LandMarkName) AND LandMarkID != @LandMarkID)                
 BEGIN                
  UPDATE LandMarksMaster                
  SET  LandMarkName =@LandMarkName,                
    IsActive  =@IsActive,                
    Operation  ='Update'            
    ,UpdatedBy = @OperationBy            
    ,UpdatedOn = GETDATE()            
  WHERE LandMarkID  =@LandMarkID                
                  
  --EXEC usp_InsertMOT_Audit @ID,'Update',@OperationBy                
                  
SELECT '200' AS returnCode, 'Record updated successfully.'  AS returnMessage, @LandMarkID AS ID;               
 END                
 ELSE                
 BEGIN                
 SELECT '201' AS returnCode, 'Location code already exists. Please check and try again.'   AS returnMessage, @LogID as ID;               
 END                
END  --U              
ELSE IF @Action='S'              
BEGIN                  
               
BEGIN                
  SELECT LandMarkID,LandMarkName,IsActive                  
  FROM LandMarksMaster                 
  --WHERE IsActive=1               
  WHERE (@LandMarkID IS NULL OR @LandMarkID = 0 OR LandMarkID = @LandMarkID)            
  Order By OperationOn Desc                  
                
END                
END                
 ELSE IF @Action='EX'
 BEGIN
   SELECT LandMarkName,CASE   
        WHEN IsActive = 1 THEN 'True'  
        WHEN IsActive = 0 THEN 'False'  
    END AS IsActive                   
  FROM LandMarksMaster                 
  --WHERE IsActive=1               
  WHERE (@LandMarkID IS NULL OR @LandMarkID = 0 OR LandMarkID = @LandMarkID)            
  Order By OperationOn Desc        
 END
END            
            
--select * from LandMarksMaster 
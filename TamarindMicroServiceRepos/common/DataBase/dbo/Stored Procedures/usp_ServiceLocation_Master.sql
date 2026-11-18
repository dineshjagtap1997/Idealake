<<<<<<< HEAD
<<<<<<< HEAD
﻿CREATE PROCEDURE [dbo].[usp_ServiceLocation_Master] @Description NVARCHAR(25)        
=======
﻿
CREATE PROCEDURE [dbo].[usp_ServiceLocation_Master] @Description NVARCHAR(25)        
>>>>>>> dev
=======
﻿
CREATE PROCEDURE [dbo].[usp_ServiceLocation_Master] @Description NVARCHAR(25)        
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
 ,@IsActive BIT        
 ,@OperationBy UNIQUEIDENTIFIER        
 --,@ErrMsg VARCHAR(50) OUT        
 ,@Action CHAR(2)=''        
 ,@ServLoc_ID INT =''        
 ,@Active BIT=''        
AS        
BEGIN        
--IF @Action='I'        
--BEGIN        
-- DECLARE @new_identity INT        
        
-- INSERT INTO ServiceLocation_Master (        
--  Description        
--  ,IsActive        
--  ,Operation        
--  ,CreatedBy        
--  ,CreatedDate        
--  --,Updatedby        
--  --,UpdatedOn        
--  )        
-- VALUES (        
--  @Description        
--  ,@IsActive        
--  ,'Insert'        
--  ,@OperationBy        
--  ,GETDATE()        
--  --,@OperationBy        
--  --,GETDATE()        
--  )        
        
-- SELECT @new_identity = SCOPE_IDENTITY()        
           
        
--SELECT '200' AS returnCode, 'New record added successfully.'   AS returnMessage, @new_identity as ID;        
--END  
IF @Action='I'        
BEGIN        
    -- Check for duplicates
    IF EXISTS (
        SELECT 1 
        FROM ServiceLocation_Master 
        WHERE LTRIM(RTRIM(Description)) = LTRIM(RTRIM(@Description))
    )
    BEGIN
<<<<<<< HEAD
<<<<<<< HEAD
        SELECT '409' AS returnCode, 'Duplicate record exists.' AS returnMessage, NULL AS ID;
=======
        SELECT '409' AS returnCode, 'Description already exists. Please check and try again.' AS returnMessage, NULL AS ID;
>>>>>>> dev
=======
        SELECT '409' AS returnCode, 'Description already exists. Please check and try again.' AS returnMessage, NULL AS ID;
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
        RETURN;
    END

    DECLARE @new_identity INT;        
        
    INSERT INTO ServiceLocation_Master (        
        Description,        
        IsActive,        
        Operation,        
        CreatedBy,        
        CreatedDate        
    )        
    VALUES (        
        @Description,        
        @IsActive,        
        'Insert',        
        @OperationBy,        
        GETDATE()        
    );        
        
    SELECT @new_identity = SCOPE_IDENTITY();        
        
    SELECT '200' AS returnCode, 'New record added successfully.' AS returnMessage, @new_identity AS ID;        
END 

ELSE IF @Action='U'        
BEGIN        
 UPDATE ServiceLocation_Master        
 SET Description = @Description        
  ,IsActive = @IsActive        
  ,Operation = 'Update'        
    ,UpdatedBy = @OperationBy        
    ,UpdatedOn = GETDATE()        
 WHERE ServLoc_ID = @ServLoc_ID        
        
      
        
SELECT '200' AS returnCode, 'Record updated successfully.'   AS returnMessage , @ServLoc_ID AS ID;        
END        
ELSE IF @Action='S'        
BEGIN                
  SELECT *                  
  FROM ServiceLocation_Master C WHERE (       @ServLoc_ID IS NULL       OR @ServLoc_ID = 0       OR ServLoc_ID = @ServLoc_ID       )               
  Order by C.ServLoc_ID desc            
 END                 
       
ELSE IF @Action='EX'        
BEGIN                
  SELECT Description, IsActive                   
  FROM ServiceLocation_Master C WHERE (       @ServLoc_ID IS NULL       OR @ServLoc_ID = 0       OR ServLoc_ID = @ServLoc_ID       )               
  Order by C.ServLoc_ID desc            
 END          
        
        
END 
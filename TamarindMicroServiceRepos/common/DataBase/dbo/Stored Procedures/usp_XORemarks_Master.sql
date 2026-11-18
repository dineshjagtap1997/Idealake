<<<<<<< HEAD
<<<<<<< HEAD
﻿CREATE PROCEDURE [dbo].[usp_XORemarks_Master]            
(            
@XoRemarks VARCHAR(500),            
@IsActive BIT,            
@OperationBy UNIQUEIDENTIFIER,            
--@ErrMsg   VARCHAR(50) OUT,             
@Action char(2)='',        
@XOID INT =''        
)            
AS            
BEGIN         
DECLARE @ReturnCode NVARCHAR(3), @ReturnMessage NVARCHAR(MAX);        
IF        
@Action ='I'        
BEGIN        
 IF EXISTS (SELECT XoRemarks FROM XORemarks WHERE UPPER(XORemarks)=UPPER(@XORemarks))             
 BEGIN           
 SET @ReturnCode = '201';        
 SET @ReturnMessage = 'XO Remarks already exists. Please check and try again.';                
            
 END            
 ELSE            
 BEGIN            
  INSERT INTO XORemarks (XoRemarks,IsActive,Operation,OperationBy,OperationOn)            
  VALUES(@XoRemarks,@IsActive,'INSERT',@OperationBy,GETDATE())            
        
 SET @XOID =SCOPE_IDENTITY();      
 SET @ReturnCode = '200';        
 SET @ReturnMessage = 'New record added successfully.';         
 --SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;        
 END         
         
 END--I        
 ELSE IF @Action='S'        
 BEGIN        
  SELECT XOID,XoRemarks,IsActive,Operation,OperationBy,OperationOn           
  FROM XORemarks         
   WHERE (@XOID IS NULL OR @XOID = 0 OR XOID = @XOID)        
   ORDER BY XOID DESC    
 --IF (@IsActive=1)          
 --BEGIN          
 -- SELECT XOID,XoRemarks,IsActive,Operation,OperationBy,OperationOn           
 -- FROM XORemarks          
 -- WHERE IsActive=1          
 --END          
 --ELSE          
 --BEGIN          
 -- SELECT XOID,XoRemarks,IsActive,Operation,OperationBy,OperationOn           
 -- FROM XORemarks          
 --END          
 END--S        
 ELSE IF @Action='EX'
 BEGIN
  SELECT XoRemarks,CASE   
        WHEN IsActive = 1 THEN 'True'  
        WHEN IsActive = 0 THEN 'False'  
    END AS IsActive            
  FROM XORemarks         
   WHERE (@XOID IS NULL OR @XOID = 0 OR XOID = @XOID)        
   ORDER BY XOID DESC 
 END
 ELSE IF @Action='U'        
 BEGIN        
  IF EXISTS(SELECT XoRemarks FROM XORemarks WHERE UPPER(XoRemarks)=UPPER(@XoRemarks) AND XOID<>@XOID)          
 BEGIN          
 SET @ReturnCode = '201';        
 SET @ReturnMessage = 'XO Remarks already exists. Please check and try again.';         
  --SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;        
 END          
 ELSE          
 BEGIN          
  UPDATE XORemarks SET          
  XoRemarks=@XoRemarks,          
  IsActive=@IsActive,          
  Operation='UPDATE'        
  ,UpdatedBy = @OperationBy        
  ,UpdatedOn = GETDATE()        
  WHERE XOID=@XOID          
        
  SET @ReturnCode = '200';        
 SET @ReturnMessage = 'Record updated successfully.';         
 -- SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;        
 END         
 END        
    SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @XOID AS ID ;         
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
﻿CREATE PROCEDURE [dbo].[usp_XORemarks_Master]              
(              
@XoRemarks VARCHAR(500)='',              
@IsActive BIT = 0,              
@OperationBy UNIQUEIDENTIFIER=NULL,              
--@ErrMsg   VARCHAR(50) OUT,               
@Action char(2)='',          
@XOID INT =''          
)              
AS              
BEGIN           
DECLARE @ReturnCode NVARCHAR(3), @ReturnMessage NVARCHAR(MAX);          
IF          
@Action ='I'          
BEGIN          
 IF EXISTS (SELECT XoRemarks FROM XORemarks WHERE UPPER(XORemarks)=UPPER(@XORemarks))               
 BEGIN             
 SELECT  '201' AS returnCode , 'XO Remarks already exists. Please check and try again.' AS returnMessage;                  
              
 END              
 ELSE              
 BEGIN              
  INSERT INTO XORemarks (XoRemarks,IsActive,Operation,OperationBy,OperationOn)              
  VALUES(@XoRemarks,@IsActive,'INSERT',@OperationBy,GETDATE())              
          
 SET @XOID =SCOPE_IDENTITY(); 
  SELECT  '200' AS returnCode , 'New record added successfully.' AS returnMessage; 
END           
           
 END--I          
 ELSE IF @Action='S'          
 BEGIN          
  SELECT XOID,XoRemarks,IsActive,Operation,OperationBy,OperationOn             
  FROM XORemarks           
   WHERE (@XOID IS NULL OR @XOID = 0 OR XOID = @XOID)          
   ORDER BY XOID DESC      
SELECT  '200' AS returnCode , 'DataFound.' AS returnMessage; 
 END--S          
 ELSE IF @Action='EX'  
 BEGIN  
  SELECT XoRemarks,CASE     
        WHEN IsActive = 1 THEN 'True'    
        WHEN IsActive = 0 THEN 'False'    
    END AS IsActive              
  FROM XORemarks           
   WHERE (@XOID IS NULL OR @XOID = 0 OR XOID = @XOID)          
   ORDER BY XOID DESC   
 END  
 ELSE IF @Action='U'          
 BEGIN          
  IF EXISTS(SELECT XoRemarks FROM XORemarks WHERE UPPER(XoRemarks)=UPPER(@XoRemarks) AND XOID<>@XOID)            
 BEGIN
 SELECT '201' AS  returnCode ,'XO Remarks already exists. Please check and try again.' AS returnMessage
 
 END            
 ELSE            
 BEGIN            
  UPDATE XORemarks SET            
  XoRemarks=@XoRemarks,            
  IsActive=@IsActive,            
  Operation='UPDATE'          
  ,UpdatedBy = @OperationBy          
  ,UpdatedOn = GETDATE()          
  WHERE XOID=@XOID            
     SELECT '201' AS  returnCode ,'Record updated successfully' AS returnMessage
      
   
 END           
 END          
   
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
END 
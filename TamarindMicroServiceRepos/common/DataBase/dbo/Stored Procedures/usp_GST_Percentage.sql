CREATE PROCEDURE [dbo].[usp_GST_Percentage]                  
@GSTPercentageValue DECIMAL(10, 2)=''                    
 ,@IsActive BIT  =0                  
 ,@OperationBy UNIQUEIDENTIFIER =NULL                   
 ,@Action CHAR(2) =''                    
 ,@GSTID  INT=''                     
AS                    
BEGIN                    
IF @Action='I'                    
BEGIN     
Declare @LogID int;    
    
 DECLARE @new_identity INT                    
                    
 IF EXISTS (                    
   SELECT GSTPercentage                    
   FROM GST_Percentage                    
   WHERE GSTPercentage = @GSTPercentageValue                    
   )                    
 BEGIN                  
 SELECT '201' AS returnCode, 'GST percentage value already exists. Please check and try again.'   AS returnMessage, @new_identity as ID;                    
 END                    
 ELSE                    
 BEGIN                    
  INSERT INTO GST_Percentage (                    
   GSTPercentage                    
   ,IsActive                    
   ,Operation                    
   ,CreatedBy                    
   ,CreatedDate                    
   ,Updatedby                    
   ,UpdatedOn                  
   )                    
  VALUES (                    
   @GSTPercentageValue                    
   ,@IsActive                    
   ,'Insert'                    
   ,@OperationBy                    
   ,GETDATE()                    
   ,@OperationBy                    
   ,GETDATE()                    
   )                    
                    
   SELECT @new_identity = SCOPE_IDENTITY()                    
                    
  --EXEC usp_InsertGST_Percentage_Audit @new_identity                    
  -- ,@GSTPercentage                    
  -- ,@IsActive                    
  -- ,'Insert'                    
  -- ,@OperationBy                    
                    
 SELECT '200' AS returnCode, 'New record added successfully.'   AS returnMessage, @new_identity AS ID;                    
 END                    
 END                    
 ELSE IF @Action='U'                    
 BEGIN      
 IF EXISTs (SELECT 1 FROM GST_Percentage    
 WHERE @GSTPercentageValue = GSTPercentage    
 AND GSTID <> @GSTID)    
 BEGIN    
 SELECT '201' AS returnCode, 'GST percentage value already exists. Please check and try again.' as returnMessage    
 END    
 ELSE    
 BEGIN    
 UPDATE GST_Percentage                    
 SET GSTPercentage = @GSTPercentageValue                    
  ,IsActive = @IsActive                    
  ,Operation = 'Update'                    
  ,UpdatedBy = @OperationBy                  
  ,UpdatedOn = GETDATE()                  
 WHERE GSTID = @GSTID                    
                
 --EXEC usp_InsertGST_Percentage_Audit @GSTID                    
 -- ,@GSTPercentage                    
 -- ,@IsActive                    
 -- ,'Update'                    
 -- ,@OperationBy                    
                    
 SELECT '200' AS returnCode, 'Record updated successfully.'   AS returnMessage , @GSTID AS ID;      
   END      
END                    
ELSE IF @Action='S'                    
BEGIN                       
SELECT GSTID,GSTPercentage,            
GSTPercentage AS GSTPercentageValue, IsActive FROM GST_Percentage WHERE (@GSTID IS NULL OR @GSTID = 0 OR GSTID = @GSTID)         
ORDER by GSTID DESC      
 --IF(@IsActive=0)                              
 --BEGIN                              
 -- SELECT *                                
 -- FROM GST_Percentage C                            
 -- Order by C.GSTID desc                          
 --END                               
 --ELSE                              
 --BEGIN                              
 -- SELECT *                                
 -- FROM GST_Percentage C                               
 -- WHERE C.IsActive=1                              
 -- Order by C.GSTID desc                          
 --END                            
END                    
               
--ELSE IF @Action='EX'                    
--BEGIN                       
--SELECT GSTPercentage,            
--GSTPercentage AS GSTPercentageValue, 
--IsActive 
--Case 
--	WHEN IsActive = 1 THEN 'Yes'
--	WHEN IsActive = 0 THEN 'No'
--	END AS IsActive
--FROM GST_Percentage WHERE (@GSTID IS NULL OR @GSTID = 0 OR GSTID = @GSTID)         
ELSE IF @Action='EX'                    
BEGIN                       
    SELECT 
<<<<<<< HEAD
<<<<<<< HEAD
        GSTPercentage,            
        GSTPercentage AS GSTPercentageValue, 
        IsActive 
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
		GSTID,           
        GSTPercentage AS GSTPercentageValue, 
         CASE 
		WHEN IsActive = 1 THEN 'True'
		WHEN IsActive = 0 THEN 'False'
		END AS IsActive   
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    FROM GST_Percentage 
    WHERE (@GSTID IS NULL OR @GSTID = 0 OR GSTID = @GSTID)         
    ORDER BY GSTID DESC      
END  
      
     
END                  

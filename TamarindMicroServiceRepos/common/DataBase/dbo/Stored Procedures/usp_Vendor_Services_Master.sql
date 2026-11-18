<<<<<<< HEAD
<<<<<<< HEAD
﻿---------------------------------------                        
=======
﻿                
---------------------------------------                        
>>>>>>> dev
=======
﻿                
---------------------------------------                        
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
CREATE PROCEDURE [dbo].[usp_Vendor_Services_Master] @Description NVARCHAR(50)=''                      
 ,@IsActive BIT  =''                    
 ,@OperationBy UNIQUEIDENTIFIER  =Null                    
 --,@ErrMsg VARCHAR(50) OUT                      
 ,@Action char(2)=''                      
 ,@Vendor_ID INT =''                      
                       
AS                      
BEGIN                      
IF @Action='I'                      
BEGIN                      
 DECLARE @new_identity INT                      
      IF NOT EXISTS (     SELECT 1      FROM Vendor_Services_Master      WHERE Description = @Description ) BEGIN              
 INSERT INTO Vendor_Services_Master (                      
  Description                      
  ,IsActive                      
  ,Operation                      
  ,OperationBy                      
  ,CreatedDate                      
  --,Updatedby                      
  --,UpdatedOn                      
  )                      
 VALUES (                      
  @Description                      
  ,@IsActive                      
  ,'Insert'                      
  ,@OperationBy                      
  ,GETDATE()                      
  --,@OperationBy                      
  --,GETDATE()                      
  )       
      
  set @new_identity = SCOPE_IDENTITY()    
SELECT '200' AS returnCode, 'New record added successfully.'   AS returnMessage, @new_identity AS ID;                            
  end        
  else        
  begin        
          
SELECT '201' AS returnCode, 'Description already exists. Please check and try again.'   AS returnMessage, @new_identity AS ID;               
  end        
 SELECT @new_identity = SCOPE_IDENTITY()                      
                      
 --EXEC usp_InsertVendor_Services_Audit @new_identity                      
 -- ,@Description                      
 -- ,@IsActive                      
 -- ,'Insert'                      
 -- ,@OperationBy                      
                             
END                      
ELSE IF @Action='U'      
   IF NOT EXISTS (     SELECT 1      FROM Vendor_Services_Master      WHERE Description = @Description and IsActive = @IsActive     )      
BEGIN                      
 UPDATE Vendor_Services_Master                      
 SET Description = @Description                      
  ,IsActive = @IsActive                      
  ,Operation = 'Update'                      
    ,UpdatedBy = @OperationBy                      
    ,UpdatedOn = GETDATE()                      
 WHERE Vendor_ID = @Vendor_ID                      
                      
 --EXEC usp_InsertVendor_Services_Audit @Vendor_ID                      
 -- ,@Description                      
 -- ,@IsActive                      
 -- ,'Update'                      
 -- ,@OperationBy                      
                      
SELECT '200' AS returnCode, 'Record updated successfully.'   AS returnMessage, @Vendor_ID AS ID;                      
END        
ELSE      
BEGIN      
SELECT '201' AS returnCode, 'Description already exists. Please check and try again.'   AS returnMessage, @new_identity AS ID;               
END      
<<<<<<< HEAD
<<<<<<< HEAD
ELSE IF @Action='S'                      
=======
ELSE IF @Action='F'                      
>>>>>>> dev
=======
ELSE IF @Action='F'                      
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
BEGIN                              
 SELECT *                                
 FROM Vendor_Services_Master C                 
 WHERE (@Vendor_ID IS NULL OR @Vendor_ID = 0 OR Vendor_ID = @Vendor_ID )    Order by C.Vendor_ID desc                          
 END                     
                    
ELSE IF @Action='EX'                      
BEGIN                              
 SELECT Description, IsActive                                
 FROM Vendor_Services_Master C                 
 WHERE (@Vendor_ID IS NULL OR @Vendor_ID = 0 OR Vendor_ID = @Vendor_ID )    Order by C.Vendor_ID desc                          
 END                     
         
		 
END 
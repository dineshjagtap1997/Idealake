CREATE PROCEDURE [dbo].[usp_QuotationServiceType_Master]          
         
 @Description  nvarchar(70)='',          
 @IsActive  BIT=0,          
 @OperationBy UNIQUEIDENTIFIER= null,      
 @Action CHAR(2)=''      
 ,@QutServ_ID INT =''      
 --@ErrMsg   VARCHAR(50) OUT          
AS       
BEGIN      
if @Action='I'      
BEGIN        
 Declare @new_identity INT          
         
 INSERT INTO QuotationServiceType_Master          
 (Description,  IsActive,  Operation, CreatedBy,  CreatedDate)--,Updatedby , UpdatedOn)          
 VALUES  (@Description, @IsActive, 'Insert',  @OperationBy, GETDATE())--,@OperationBy, GETDATE())            
     
    
 set @new_identity = SCOPE_IDENTITY()    
 SELECT '200' AS returnCode,'New record added successfully.' AS returnMessage, @new_identity AS ID       
          
      
        
-- EXEC  usp_InsertQuotationServiceType_Audit   @new_identity,@Description,@IsActive,'Insert', @OperationBy          
        
  END      
  if @Action='U'      
  BEGIN      
   UPDATE QuotationServiceType_Master        
 SET  Description   = @Description,        
   IsActive   = @IsActive,        
   Operation   = 'Update',        
   Updatedby     = @OperationBy,         
   UpdatedOn   = GETDATE()        
 WHERE  QutServ_ID       = @QutServ_ID      
 SELECT '200' AS returnCode,'Record updated successfully.' AS returnMessage, @QutServ_ID AS ID       
 --EXEC usp_InsertQuotationServiceType_Audit @QutServ_ID,@Description,@IsActive,'Update', @OperationBy        
  END      
  if @Action='S'      
  BEGIN      
  SELECT *                
  FROM QuotationServiceType_Master C       
  WHERE (@QutServ_ID IS NULL OR @QutServ_ID = 0) OR QutServ_ID = @QutServ_ID      
  Order by C.QutServ_ID desc          
  --BEGIN                
 --IF(@IsActive=0)              
 --BEGIN              
  --SELECT *                
  --FROM QuotationServiceType_Master C            
  --Order by C.QutServ_ID desc          
 --END               
 --ELSE              
 --BEGIN              
 -- SELECT *                
 -- FROM QuotationServiceType_Master C               
 -- WHERE C.IsActive=1              
 -- Order by C.QutServ_ID desc          
 --END             
 -- END      
  END      
      
  if @Action='EX'      
  BEGIN      
  SELECT Description, 
  CASE 
	WHEN IsActive = 1 THEN 'Yes'
	WHEN IsActive = 0 THEN 'No'
  END AS IsActive	
  FROM QuotationServiceType_Master C       
  WHERE (@QutServ_ID IS NULL OR @QutServ_ID = 0) OR QutServ_ID = @QutServ_ID      
  Order by C.QutServ_ID desc          
     
  END            
END 
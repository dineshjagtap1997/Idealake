CREATE PROCEDURE [dbo].[usp_ServiceTaxNew_Master]                  
                 
@Tax_Desc  VARCHAR(500),                                
@GSTTaxID INT,                  
@Tax_From_Date  VARCHAR(10),                  
@Tax_To_Date    VARCHAR(10),                                
@IsActive       BIT,                  
@OperationBy    UNIQUEIDENTIFIER,                  
@ErrMsg      VARCHAR(50) OUT,    
@GSTType varchar(500),     
@SAPCode varchar(5) = null,  
@IsCommercial bit = 0  ,
@Action Char(2)='' ,
@Tax_ID INT =''
AS
BEGIN 
IF @Action='I'
 BEGIN     
 Declare @LogID int; 
 IF EXISTS (SELECT TOP 1 1 FROM ServiceTaxNew WHERE GSTType = @GSTType AND GSTID = @GSTTaxID AND                
   (Tax_From_Date = CAST(@Tax_From_Date AS DATETIME)          
   OR Tax_To_Date =CAST(@Tax_To_Date AS DATETIME)          
   OR  CAST(@Tax_From_Date AS DATETIME) BETWEEN Tax_From_Date AND Tax_To_Date                 
   OR  CAST(@Tax_To_Date AS DATETIME) BETWEEN Tax_From_Date AND Tax_To_Date)                
    AND IsActive=1 )            
 BEGIN    
              
    SELECT '201' AS returnCode, 'Service Tax record already exists for similar data.' AS returnMessage, @LogID as ID;
 END                  
 ELSE                  
 BEGIN         
            
                 
  INSERT INTO ServiceTaxNew                  
     (Tax_Desc ,GSTID,IsActive,Tax_From_Date,Tax_To_Date,Operation,OperationBy,OperationOn,GSTType,SAPCode,IsCommercial)                  
  VALUES  (@Tax_Desc,@GSTTaxID,@IsActive,CAST(@Tax_From_Date AS DATETIME),CAST(@Tax_To_Date AS DATETIME),'Insert',@OperationBy, GETDATE(),@GSTType,@SAPCode,@IsCommercial)                  
        
		 SET @LogID = SCOPE_IDENTITY()  
  ---EXEC  usp_InsertServiceTax_Audit @@IDENTITY, 'Insert', @OperationBy                  
  SELECT '200' AS returnCode, 'Data Inserted' AS returnMessage, @LogID AS ID;                
 END                  
END  --I
ELSE IF @Action='U'
BEGIN                  
  IF EXISTS (SELECT TOP 1 1 FROM ServiceTaxNew WHERE                
   GSTType = @GSTType and GSTID = @GSTTaxID                  
   AND (Tax_From_Date = CAST(@Tax_From_Date AS DATETIME)                   
   OR Tax_To_Date = CAST(@Tax_To_Date AS DATETIME)              
   OR  CAST(@Tax_From_Date AS DATETIME)  BETWEEN Tax_From_Date AND Tax_To_Date                   
   OR  CAST(@Tax_To_Date AS DATETIME) BETWEEN Tax_From_Date AND Tax_To_Date)                  
   AND Tax_ID!= @Tax_ID   AND IsActive=1 )                  
 BEGIN 
  SELECT '201' AS returnCode, 'Service Tax record already exists for similar data.' AS returnMessage, @Tax_ID AS ID;                      
 END                  
 ELSE                  
 BEGIN                  
 UPDATE ServiceTaxNew                  
 SET  Tax_Desc =@Tax_Desc,                               
   GSTID  =@GSTTaxID,                  
   IsActive   =@IsActive,                  
   Tax_From_Date  =CAST(@Tax_From_Date AS DATETIME),                  
   Tax_To_Date   =CAST(@Tax_To_Date AS DATETIME),                   
   Operation   ='Update'
   ,UpdatedBy = @OperationBy
   ,UpdatedOn = GETDATE(),
   GSTType=@GSTType ,  
   SAPCode = @SAPCode ,  
   IsCommercial = @IsCommercial             
 WHERE Tax_ID   = @Tax_ID                  
 ---EXEC  usp_InsertServiceTax_Audit @Tax_ID, 'Update', @OperationBy                  
                  
 SELECT '200' AS returnCode, 'Data Updated.' AS returnMessage, @Tax_ID AS ID;    ;                 
 END                  
END     --U

ELSE IF @Action='S'
BEGIN                 
SELECT     ST.Tax_ID,ST.Tax_Desc,ST.GSTID,ST.Tax_From_Date,                 
   ST.Tax_To_Date,ST.IsActive,     
   --,ST.Tax_SalesType AS TaxSalesType---STC.ServiceTaxCategory ,                
   --CASE WHEN   ST.Tax_SalesType='1' THEN 'Sales'                 
   -- WHEN ST.Tax_SalesType='2' THEN 'B2B'                 
   -- WHEN ST.Tax_SalesType='3' THEN 'B2C'                 
   -- WHEN ST.Tax_SalesType='4' THEN 'XO Purchase'              
   -- WHEN ST.Tax_SalesType='5' THEN 'B2B India'                
   -- WHEN ST.Tax_SalesType='6' THEN 'B2B Non-India'                
   -- END AS Tax_SalesType       
     ST.GSTType       
    ,N3.GSTTypeName as State_Code3,GSTPER.GSTPercentage, ST.SAPCode , ST.IsCommercial              
FROM ServiceTaxNew ST                  
Left join GSTTypeMaster N3 on N3.GSTID=ST.GSTType    
INNER JOIN GST_Percentage GSTPER ON GSTPER.GSTID = ST.GSTID                
ORDER BY Tax_ID DESC                
END     

END
  

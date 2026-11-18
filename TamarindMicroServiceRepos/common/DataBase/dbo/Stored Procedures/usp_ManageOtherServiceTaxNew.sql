CREATE PROCEDURE [dbo].[usp_ManageOtherServiceTaxNew]                                  
<<<<<<< HEAD
<<<<<<< HEAD
    @Action VARCHAR(10), -- 'SELECT', 'INSERT', 'UPDATE'                                  
    @Tax_ID INT = '',                                
 @Tax_Desc VARCHAR(500) = NULL,                                
 @Tax_Percentage DECIMAL(18,6) = NULL,                                
 @IsActive BIT = NULL,                                 
    @Tax_Category INT = NULL,                      
    @Tax_From_Date DateTime = NULL,                                  
    @Tax_To_Date DateTime = NULL,                     
    @Other_Tax_Id INT = NULL,                                  
    @ST_Tax_ID INT = NULL,                                  
    @OperationBy UNIQUEIDENTIFIER = NULL,                         
 @GSTType NVARCHAR(MAX) =NULL                        
 ,@SAPCode varchar(20)=null                        
 ,@IsCommercial bit=0                        
                                    
 --@PageNumber BIGINT = NULL,                                  
 --   @PageSize INT= NULL                                  
AS                                  
BEGIN      
 declare @LogID int ;  
DECLARE @ReturnCode NVARCHAR(3), @ReturnMessage NVARCHAR(MAX);                                          
                                    
                                  
    IF @Action = 'S'                                  
    BEGIN                                  
SELECT                       
    OST.Tax_ID                    
   ,OT.Name AS Tax_Desc                   
   ,OST.Tax_Percentage,            
   OST.Tax_Type,OST.Tax_From_Date,                               
   OST.Tax_To_Date,OST.IsActive                         
   ,OST.Other_Tax_Id                 
   ,GSTM.GSTTypeName AS GSTType                         
   ,STN.Tax_Desc AS ServiceTaxDescription                
   ,OST.ST_Tax_ID AS ST_Tax_ID                
   ,GSTM.GSTID AS GSTID            
   ,GSTM.GSTID AS Tax_Category          
FROM OtherServiceTaxNew OST                                      
INNER JOIN Other_Taxes   OT ON OT.Other_Tax_Id=OST.Other_Tax_Id                   
LEFT JOIN ServiceTaxNew STN ON OST.ST_Tax_ID = STN.Tax_ID            
--LEFT JOIN ServiceTaxNew STN ON OST.Tax_Type = STN.Tax_ID                   
--Left join GSTTypeMaster GSTM on GSTM.GSTID=STN.GSTType                      
Left join GSTTypeMaster GSTM on GSTM.GSTID=OST.Tax_Type       
  WHERE (       @Tax_ID IS NULL       OR @Tax_ID = 0       OR OST.Tax_ID = @Tax_ID       )                  
        ORDER BY OST.Tax_ID DESC                            
                            
  -- added for pagination                                  
    --OFFSET @PageNumber * @PageSize ROWS                                  
    --FETCH NEXT @PageSize ROWS ONLY;                                  
    END                                  
 ELSE IF @Action='EX'
 BEGIN
 SELECT                       
   OT.Name AS Tax_Desc                   
   ,OST.Tax_Percentage,            
  OST.Tax_From_Date,                               
   OST.Tax_To_Date,CASE WHEN OST.IsActive='1' THEN 'True' WHEN OST.IsActive='0' THEN 'False' END AS IsActive                         
   ,GSTM.GSTTypeName AS GSTType                         
   ,STN.Tax_Desc AS ServiceTaxDescription                
FROM OtherServiceTaxNew OST                                      
INNER JOIN Other_Taxes   OT ON OT.Other_Tax_Id=OST.Other_Tax_Id                   
LEFT JOIN ServiceTaxNew STN ON OST.ST_Tax_ID = STN.Tax_ID            
--LEFT JOIN ServiceTaxNew STN ON OST.Tax_Type = STN.Tax_ID                   
--Left join GSTTypeMaster GSTM on GSTM.GSTID=STN.GSTType                      
Left join GSTTypeMaster GSTM on GSTM.GSTID=OST.Tax_Type       
  WHERE (       @Tax_ID IS NULL       OR @Tax_ID = 0       OR OST.Tax_ID = @Tax_ID       )                  
        ORDER BY OST.Tax_ID DESC     
 END
    ELSE IF @Action = 'I'                                  
   BEGIN                
 --IF EXISTS (                
 --  SELECT TOP 1 1                
 --  FROM OtherServiceTaxNew                
 --  WHERE Tax_Type = @Tax_Category                
 --   AND (                
 --    Tax_From_Date = CAST(@Tax_From_Date AS DATETIME)                
 --    OR Tax_To_Date = CAST(@Tax_To_Date AS DATETIME)                
 --    OR CAST(@Tax_From_Date AS DATETIME) BETWEEN Tax_From_Date                
 --     AND Tax_To_Date                
 --    OR CAST(@Tax_To_Date AS DATETIME) BETWEEN Tax_From_Date                
 --     AND Tax_To_Date                
 --    )                
 --   AND IsActive = 1                
 --   AND Other_Tax_Id = @Other_Tax_Id                
 --  )           
     
 IF EXISTS (    
   SELECT TOP 1 1    
   FROM OtherServiceTaxNew    
   WHERE Tax_Type = @Tax_Category    
    --AND IsActive = 1    
    AND Other_Tax_Id = @Other_Tax_Id    
    AND (    
     Tax_From_Date = CAST(@Tax_From_Date AS DATETIME)    
     OR Tax_To_Date = CAST(@Tax_To_Date AS DATETIME)    
     OR CAST(@Tax_From_Date AS DATETIME) BETWEEN Tax_From_Date AND Tax_To_Date    
     OR CAST(@Tax_To_Date AS DATETIME) BETWEEN Tax_From_Date AND Tax_To_Date    
     )    
)    
 BEGIN        
 --Set @ReturnCode = '201'      
 -- SET @ReturnMessage ='This data already exists. Please check and try again.'                              
   select '201'  as returnCode, ' Service Tax record already exists for similar data. Please check and try again.'  as returnMessage , @LogID as ID      
              
 END                
 ELSE                
 BEGIN                
  INSERT INTO OtherServiceTaxNew (      
   Tax_Desc      
   ,Tax_Percentage      
   ,IsActive      
   ,Tax_Type      
   ,Tax_From_Date      
   ,Tax_To_Date      
   ,Operation      
   ,OperationBy      
   ,OperationOn      
   ,Other_Tax_Id      
   ,ST_Tax_ID      
   )      
  VALUES (      
   @Tax_Desc      
   ,@Tax_Percentage      
   ,@IsActive      
   ,@Tax_Category      
   ,CAST(@Tax_From_Date AS DATETIME)      
   ,CAST(@Tax_To_Date AS DATETIME)      
   ,'Insert'      
   ,@OperationBy      
   ,GETDATE()      
   ,@Other_Tax_Id      
   ,@ST_Tax_ID      
   )       
     
SET @LogID = SCOPE_IDENTITY()  
 Set @ReturnCode = '200'      
  SET @ReturnMessage ='New record added successfully.';                              
   select @ReturnCode as returnCode, @ReturnMessage as returnMessage, @LogID AS ID                   
 END                
END                              
                
    ELSE IF @Action = 'U'                                  
BEGIN                
 IF EXISTS (                
   SELECT TOP 1 1                
   FROM OtherServiceTaxNew                
   WHERE Tax_Type = @Tax_Category                
    AND (                
     Tax_From_Date = CAST(@Tax_From_Date AS DATETIME)                
     OR Tax_To_Date = CAST(@Tax_To_Date AS DATETIME)                
     OR CAST(@Tax_From_Date AS DATETIME) BETWEEN Tax_From_Date                
      AND Tax_To_Date                
     OR CAST(@Tax_To_Date AS DATETIME) BETWEEN Tax_From_Date                
      AND Tax_To_Date                
     )                
    AND Tax_ID != @Tax_ID                
    AND IsActive = 1                
    AND Other_Tax_Id = @Other_Tax_Id                
   )                
 BEGIN                
 Set @ReturnCode = '201'      
  SET @ReturnMessage ='Service Tax record already exists for similar data. Please check and try again.';                              
   select @ReturnCode as returnCode, @ReturnMessage as returnMessage , @LogID AS ID                
 END                
 ELSE                
 BEGIN                
  UPDATE OtherServiceTaxNew      
  SET Tax_Desc = @Tax_Desc      
   ,Tax_Percentage = @Tax_Percentage      
   ,IsActive = @IsActive      
   ,Tax_Type = @Tax_Category      
   ,Tax_From_Date = CAST(@Tax_From_Date AS DATETIME)      
   ,Tax_To_Date = CAST(@Tax_To_Date AS DATETIME)      
   ,Operation = 'Update'      
   ,OperationBy = @OperationBy      
   ,OperationOn = GETDATE()      
   ,Other_Tax_Id = @Other_Tax_Id      
   ,ST_Tax_ID = @ST_Tax_ID      
  WHERE Tax_ID = @Tax_ID              
 Set @ReturnCode = '200'      
  SET @ReturnMessage ='Record updated successfully. ';                              
   select @ReturnCode as returnCode, @ReturnMessage as returnMessage , @Tax_ID as ID               
 END                
END                          
END 
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

    @Action VARCHAR(10), -- 'SELECT', 'INSERT', 'UPDATE'                                  

    @Tax_ID INT = '',                                

@Tax_Desc VARCHAR(500) = NULL,                                

@Tax_Percentage DECIMAL(18,6) = NULL,                                

@IsActive BIT = NULL,                                 

    @Tax_Category INT = NULL,                      

    @Tax_From_Date DateTime = NULL,                                  

    @Tax_To_Date DateTime = NULL,                     

    @Other_Tax_Id INT = NULL,                                  

    @ST_Tax_ID INT = NULL,                                  

    @OperationBy UNIQUEIDENTIFIER = NULL,                         

@GSTType NVARCHAR(MAX) =NULL                        

,@SAPCode varchar(20)=null                        

,@IsCommercial bit=0                        

--@PageNumber BIGINT = NULL,                                  

--   @PageSize INT= NULL                                  

AS                                  

BEGIN      

declare @LogID int ;  

DECLARE @ReturnCode NVARCHAR(3), @ReturnMessage NVARCHAR(MAX);                                          


    IF @Action = 'S'                                  

    BEGIN                                  

SELECT                       

    OST.Tax_ID                    

   ,OT.Name AS Tax_Desc                   

   ,OST.Tax_Percentage,            

   OST.Tax_Type,OST.Tax_From_Date,                               

   OST.Tax_To_Date,OST.IsActive                         

   ,OST.Other_Tax_Id                 

   ,GSTM.GSTTypeName AS GSTType                         

   ,STN.Tax_Desc AS ServiceTaxDescription                

   ,OST.ST_Tax_ID AS ST_Tax_ID                

   ,GSTM.GSTID AS GSTID            

   ,GSTM.GSTID AS Tax_Category          

FROM OtherServiceTaxNew OST                                      

INNER JOIN Other_Taxes   OT ON OT.Other_Tax_Id=OST.Other_Tax_Id                   

LEFT JOIN ServiceTaxNew STN ON OST.ST_Tax_ID = STN.Tax_ID            

--LEFT JOIN ServiceTaxNew STN ON OST.Tax_Type = STN.Tax_ID                   

--Left join GSTTypeMaster GSTM on GSTM.GSTID=STN.GSTType                      

Left join GSTTypeMaster GSTM on GSTM.GSTID=OST.Tax_Type       

  WHERE (       @Tax_ID IS NULL       OR @Tax_ID = 0       OR OST.Tax_ID = @Tax_ID       )                  

        ORDER BY OST.Tax_ID DESC                            

  -- added for pagination                                  

    --OFFSET @PageNumber * @PageSize ROWS                                  

    --FETCH NEXT @PageSize ROWS ONLY;                                  

    END                                  

-- ELSE IF @Action='EX'

-- BEGIN

-- SELECT                       

--   OT.Name AS Tax_Desc                   

--   ,OST.Tax_Percentage,            

--  OST.Tax_From_Date,                               

--   OST.Tax_To_Date,CASE WHEN OST.IsActive='1' THEN 'True' WHEN OST.IsActive='0' THEN 'False' END AS IsActive                         

--   ,GSTM.GSTTypeName AS GSTType                         

--   ,STN.Tax_Desc AS ServiceTaxDescription                

--FROM OtherServiceTaxNew OST                                      

--INNER JOIN Other_Taxes   OT ON OT.Other_Tax_Id=OST.Other_Tax_Id                   

--LEFT JOIN ServiceTaxNew STN ON OST.ST_Tax_ID = STN.Tax_ID            

----LEFT JOIN ServiceTaxNew STN ON OST.Tax_Type = STN.Tax_ID                   

----Left join GSTTypeMaster GSTM on GSTM.GSTID=STN.GSTType                      

--Left join GSTTypeMaster GSTM on GSTM.GSTID=OST.Tax_Type       

--  WHERE (       @Tax_ID IS NULL       OR @Tax_ID = 0       OR OST.Tax_ID = @Tax_ID       )                  

--        ORDER BY OST.Tax_ID DESC     

-- END

ELSE IF @Action = 'EX'

BEGIN

  SELECT 

    OST.Tax_ID,                            -- ✅ Include Tax_ID

    OT.Name AS Tax_Desc,

    OST.Tax_Percentage,

    CAST(OST.Tax_From_Date AS DATETIME) AS Tax_From_Date,

    CAST(OST.Tax_To_Date AS DATETIME) AS Tax_To_Date,

    CASE 

      WHEN OST.IsActive = 1 THEN 'TRUE' 

      ELSE 'FALSE' 

    END AS IsActive,

    GSTM.GSTTypeName AS GSTType,

    STN.Tax_Desc AS ServiceTaxDescription

  FROM OtherServiceTaxNew OST

  INNER JOIN Other_Taxes OT ON OT.Other_Tax_Id = OST.Other_Tax_Id

  LEFT JOIN ServiceTaxNew STN ON OST.ST_Tax_ID = STN.Tax_ID

  LEFT JOIN GSTTypeMaster GSTM ON GSTM.GSTID = OST.Tax_Type

  WHERE (@Tax_ID IS NULL OR @Tax_ID = 0 OR OST.Tax_ID = @Tax_ID)

  ORDER BY OST.Tax_ID DESC

END
 
    ELSE IF @Action = 'I'                                  

   BEGIN                

--IF EXISTS (                

--  SELECT TOP 1 1                

--  FROM OtherServiceTaxNew                

--  WHERE Tax_Type = @Tax_Category                

--   AND (                

--    Tax_From_Date = CAST(@Tax_From_Date AS DATETIME)                

--    OR Tax_To_Date = CAST(@Tax_To_Date AS DATETIME)                

--    OR CAST(@Tax_From_Date AS DATETIME) BETWEEN Tax_From_Date                

--     AND Tax_To_Date                

--    OR CAST(@Tax_To_Date AS DATETIME) BETWEEN Tax_From_Date                

--     AND Tax_To_Date                

--    )                

--   AND IsActive = 1                

--   AND Other_Tax_Id = @Other_Tax_Id                

--  )           

IF EXISTS (    

   SELECT TOP 1 1    

   FROM OtherServiceTaxNew    

   WHERE Tax_Type = @Tax_Category    

    --AND IsActive = 1    

    AND Other_Tax_Id = @Other_Tax_Id    

    AND (    

     Tax_From_Date = CAST(@Tax_From_Date AS DATETIME)    

     OR Tax_To_Date = CAST(@Tax_To_Date AS DATETIME)    

     OR CAST(@Tax_From_Date AS DATETIME) BETWEEN Tax_From_Date AND Tax_To_Date    

     OR CAST(@Tax_To_Date AS DATETIME) BETWEEN Tax_From_Date AND Tax_To_Date    

     )    

)    

BEGIN        

--Set @ReturnCode = '201'      

-- SET @ReturnMessage ='This data already exists. Please check and try again.'                              

   select '201'  as returnCode, ' Service Tax record already exists for similar data. Please check and try again.'  as returnMessage , @LogID as ID      

END                

ELSE                

BEGIN                

  INSERT INTO OtherServiceTaxNew (      

   Tax_Desc      

   ,Tax_Percentage      

   ,IsActive      

   ,Tax_Type      

   ,Tax_From_Date      

   ,Tax_To_Date      

   ,Operation      

   ,OperationBy      

   ,OperationOn      

   ,Other_Tax_Id      

   ,ST_Tax_ID      

   )      

  VALUES (      

   @Tax_Desc      

   ,@Tax_Percentage      

   ,@IsActive      

   ,@Tax_Category      

   ,CAST(@Tax_From_Date AS DATETIME)      

   ,CAST(@Tax_To_Date AS DATETIME)      

   ,'Insert'      

   ,@OperationBy      

   ,GETDATE()      

   ,@Other_Tax_Id      

   ,@ST_Tax_ID      

   )       

SET @LogID = SCOPE_IDENTITY()  

Set @ReturnCode = '200'      

  SET @ReturnMessage ='New record added successfully.';                              

   select @ReturnCode as returnCode, @ReturnMessage as returnMessage, @LogID AS ID                   

END                

END                              

    ELSE IF @Action = 'U'                                  

BEGIN                

IF EXISTS (                

   SELECT TOP 1 1                

   FROM OtherServiceTaxNew                

   WHERE Tax_Type = @Tax_Category                

    AND (                

     Tax_From_Date = CAST(@Tax_From_Date AS DATETIME)                

     OR Tax_To_Date = CAST(@Tax_To_Date AS DATETIME)                

     OR CAST(@Tax_From_Date AS DATETIME) BETWEEN Tax_From_Date                

      AND Tax_To_Date                

     OR CAST(@Tax_To_Date AS DATETIME) BETWEEN Tax_From_Date                

      AND Tax_To_Date                

     )                

    AND Tax_ID != @Tax_ID                

    AND IsActive = 1                

    AND Other_Tax_Id = @Other_Tax_Id                

   )                

BEGIN                

Set @ReturnCode = '201'      

  SET @ReturnMessage ='Service Tax record already exists for similar data. Please check and try again.';                              

   select @ReturnCode as returnCode, @ReturnMessage as returnMessage , @LogID AS ID                

END                

ELSE                

BEGIN                

  UPDATE OtherServiceTaxNew      

  SET Tax_Desc = @Tax_Desc      

   ,Tax_Percentage = @Tax_Percentage      

   ,IsActive = @IsActive      

   ,Tax_Type = @Tax_Category      

   ,Tax_From_Date = CAST(@Tax_From_Date AS DATETIME)      

   ,Tax_To_Date = CAST(@Tax_To_Date AS DATETIME)      

   ,Operation = 'Update'      

   ,OperationBy = @OperationBy      

   ,OperationOn = GETDATE()      

   ,Other_Tax_Id = @Other_Tax_Id      

   ,ST_Tax_ID = @ST_Tax_ID      

  WHERE Tax_ID = @Tax_ID              

Set @ReturnCode = '200'      

  SET @ReturnMessage ='Record updated successfully. ';                              

   select @ReturnCode as returnCode, @ReturnMessage as returnMessage , @Tax_ID as ID               

END                

END                          

END
<<<<<<< HEAD
 
>>>>>>> dev
=======
 
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

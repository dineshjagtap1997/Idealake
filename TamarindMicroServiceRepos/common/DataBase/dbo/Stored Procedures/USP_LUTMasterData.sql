<<<<<<< HEAD
<<<<<<< HEAD
﻿                    
CREATE PROCEDURE [dbo].[USP_LUTMasterData]                       
@LUTNumber NVARCHAR(50)='',                      
@ValidFrom datetime=NULL,                      
@ValidTo datetime=NULL,                      
@CompanyID BIGINT='',                      
@YearCode BIGINT='',                      
@IsActive BIT='',                      
@OperationBy UNIQUEIDENTIFIER=null,                      
@Action CHAR(2) = '',                      
@id INT = ''                      
                      
 --@ErrMsg   VARCHAR(50) OUT                                
AS                      
BEGIN                      
 IF @Action = 'I'                      
 BEGIN                      
  DECLARE @new_identity INT                      
                      
  --IF EXISTS (                      
  --  SELECT *                      
  --  FROM LUTMaster                      
  --  WHERE companyid = @companyid                      
  --   AND (                      
  --    (                      
  --     @validfrom >= validfrom                      
  --     AND @validfrom <= Validto                      
  --     )                      
  --    OR (                      
  --     @validto >= validfrom                      
  --     AND @validto <= Validto                      
  --     )                      
  --    )                      
  --   --AND isactive = 1                      
  --  )                      
  --BEGIN                      
  --SELECT '201' AS returnCode, 'This data already exists. Please check and try again'   AS returnMessage;                      
  --END           
          
  IF EXISTS (        
    SELECT 1        
    FROM LUTMaster        
    WHERE companyid = @companyid        
    AND (@validfrom <= Validto AND @validto >= validfrom) -- Overlapping date range check        
)        
BEGIN        
    SELECT '201' AS returnCode, 'Valid from-Valid to dates already exists. Please check and try again.' AS returnMessage;        
END        
        
  ELSE                      
  BEGIN                      
   INSERT INTO LUTMaster (                      
    LUTNumber                      
    ,ValidFrom                      
    ,ValidTo                      
    ,CompanyID                      
    ,YearCode                      
    ,IsActive                      
    ,OperationBy                    
 ,InsertedDate                  
    )                      
   VALUES (                      
    @LUTNumber                      
    ,cAST (@ValidFrom AS datetime)                   
    ,cAST(@ValidTo  AS datetime)                    
    ,@CompanyID                      
    ,@YearCode                      
    ,@IsActive                      
    ,@OperationBy                      
 ,GETDATE()                  
    )                      
                      
   SELECT @new_identity = SCOPE_IDENTITY()                      
                      
   --EXEC USP_InsertLUTMaster_Audit @new_identity                      
   -- ,@LUTNumber                      
   -- ,@ValidFrom                      
   -- ,@ValidTo                      
   -- ,@CompanyID                      
   -- ,@YearCode                      
   -- ,@IsActive                      
   -- ,'Insert'                      
   -- ,@InsertedBy                      
                      
  SELECT '200' AS returnCode, 'New record added successfully.'   AS returnMessage, @new_identity AS ID;                      
                      
                         
  END                      
 END --I                      
 ELSE IF @Action = 'U'                      
 BEGIN                      
  IF EXISTS (                      
    SELECT *                      
    FROM LUTMaster                      
    WHERE companyid = @companyid                      
     AND (                      
      (                      
       @validfrom >= validfrom                      
       AND @validfrom <= Validto                      
       )                      
      OR (                      
       @validto >= validfrom              
       AND @validto <= Validto                      
       )                      
      )                      
     AND isactive = 1                      
     AND id != @id                      
    )                  
  BEGIN                      
  SELECT '201' AS returnCode, 'Valid from-Valid to dates already exists. Please check and try again.'   AS returnMessage, @id as ID ;                      
                        
  END                      
  ELSE            
  BEGIN                      
   UPDATE LUTMaster                      
   SET LUTNumber = @LUTNumber                      
    ,ValidFrom = @ValidFrom                      
    ,ValidTo = @ValidTo                      
    ,CompanyID = @CompanyID                
    ,YearCode = @YearCode                      
    ,IsActive = @IsActive                      
    ,UpdatedBy = @OperationBy                      
    ,updatedon = GETDATE()                      
   WHERE ID = @ID                      
                      
   --EXEC USP_InsertLUTMaster_Audit @ID                      
   -- ,@LUTNumber                      
   -- ,@ValidFrom                      
   -- ,@ValidTo                      
   -- ,@CompanyID                      
   -- ,@YearCode                      
   -- ,@IsActive                      
   -- ,'Update'                      
   -- ,@InsertedBy                      
                      
  SELECT '200' AS returnCode, 'Record updated successfully.'   AS returnMessage, @ID as ID;                      
  END                      
 END                      
 ELSE IF @Action = 'S'                      
 BEGIN                      
  SELECT CAST(L.ValidFrom AS DATE) AS ValidFrom,  CAST(L.ValidTo AS DATE) AS ValidTo,                  
  L.CompanyID,                  
  L.yearcode,                  
  L.LUTNumber,                  
  L.ID                  
  ,L.IsActive                  
   ,C.companyname AS CompnayName                      
  FROM LUTMaster L                      
  LEFT JOIN companymaster c ON L.companyid = c.companyid                      
  WHERE (@id IS NULL OR @id = 0 OR L.ID = @id  )              
  order by id desc      
END         

--ELSE IF @Action = 'ex'                      
-- BEGIN                      
--  SELECT CAST(L.ValidFrom AS DATE) AS ValidFrom,  CAST(L.ValidTo AS DATE) AS ValidTo,        
--  L.yearcode,                  
--  L.LUTNumber                             
--  ,Case 
--	WHEN L.IsActive = 1 THEN 'Yes'
--	WHEN L.IsActive = 0 THEN 'No'
--	END AS IsActive
--   ,C.companyname AS CompanyName                      
--  FROM LUTMaster L                      
--  LEFT JOIN companymaster c ON L.companyid = c.companyid                      
--  WHERE (@id IS NULL OR @id = 0 OR L.ID = @id  )              
--  order by id desc      
--END   
ELSE IF @Action = 'ex'
BEGIN
  SELECT 
    CAST(L.ValidFrom AS DATE) AS ValidFrom,  
    CAST(L.ValidTo AS DATE) AS ValidTo,        
    L.yearcode,                  
    L.LUTNumber,                             
    L.IsActive,  -- keep as BIT (0/1)
    C.companyname AS CompanyName                      
  FROM LUTMaster L                      
  LEFT JOIN companymaster c ON L.companyid = c.companyid                      
  WHERE (@id IS NULL OR @id = 0 OR L.ID = @id)              
  ORDER BY id DESC      
END


END 
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
﻿CREATE PROCEDURE [dbo].[USP_LUTMasterData]                       

@LUTNumber NVARCHAR(50)='',                      

@ValidFrom datetime=NULL,                      

@ValidTo datetime=NULL,                      

@CompanyID BIGINT='',                      

@YearCode BIGINT='',                      

@IsActive BIT='',                      

@OperationBy UNIQUEIDENTIFIER=null,                      

@Action CHAR(2) = '',                      

@id INT = ''                      

--@ErrMsg   VARCHAR(50) OUT                                

AS                      

BEGIN                      

IF @Action = 'I'                      

BEGIN                      

  DECLARE @new_identity INT                      

  --IF EXISTS (                      

  --  SELECT *                      

  --  FROM LUTMaster                      

  --  WHERE companyid = @companyid                      

  --   AND (                      

  --    (                      

  --     @validfrom >= validfrom                      

  --     AND @validfrom <= Validto                      

  --     )                      

  --    OR (                      

  --     @validto >= validfrom                      

  --     AND @validto <= Validto                      

  --     )                      

  --    )                      

  --   --AND isactive = 1                      

  --  )                      

  --BEGIN                      

  --SELECT '201' AS returnCode, 'This data already exists. Please check and try again'   AS returnMessage;                      

  --END           

  IF EXISTS (        

    SELECT 1        

    FROM LUTMaster        

    WHERE companyid = @companyid        

    AND (@validfrom <= Validto AND @validto >= validfrom) -- Overlapping date range check        

)        

BEGIN        

    SELECT '201' AS returnCode, 'Valid from-Valid to dates already exists. Please check and try again.' AS returnMessage;        

END        

  ELSE                      

  BEGIN                      

   INSERT INTO LUTMaster (                      

    LUTNumber                      

    ,ValidFrom                      

    ,ValidTo                      

    ,CompanyID                      

    ,YearCode                      

    ,IsActive                      

    ,OperationBy                    

,InsertedDate                  

    )                      

   VALUES (                      

    @LUTNumber                      

    ,cAST (@ValidFrom AS datetime)                   

    ,cAST(@ValidTo  AS datetime)                    

    ,@CompanyID                      

    ,@YearCode                      

    ,@IsActive                      

    ,@OperationBy                      

,GETDATE()                  

    )                      

   SELECT @new_identity = SCOPE_IDENTITY()                      

   --EXEC USP_InsertLUTMaster_Audit @new_identity                      

   -- ,@LUTNumber                      

   -- ,@ValidFrom                      

   -- ,@ValidTo                      

   -- ,@CompanyID                      

   -- ,@YearCode                      

   -- ,@IsActive                      

   -- ,'Insert'                      

   -- ,@InsertedBy                      

  SELECT '200' AS returnCode, 'New record added successfully.'   AS returnMessage, @new_identity AS ID;                      


  END                      

END --I                      

ELSE IF @Action = 'U'                      

BEGIN                      

  IF EXISTS (                      

    SELECT *                      

    FROM LUTMaster                      

    WHERE companyid = @companyid                      

     AND (                      

      (                      

       @validfrom >= validfrom                      

       AND @validfrom <= Validto                      

       )                      

      OR (                      

       @validto >= validfrom              

       AND @validto <= Validto                      

       )                      

      )                      

     AND isactive = 1                      

     AND id != @id                      

    )                  

  BEGIN                      

  SELECT '201' AS returnCode, 'Valid from-Valid to dates already exists. Please check and try again.'   AS returnMessage, @id as ID ;                      

  END                      

  ELSE            

  BEGIN                      

   UPDATE LUTMaster                      

   SET LUTNumber = @LUTNumber                      

    ,ValidFrom = @ValidFrom                      

    ,ValidTo = @ValidTo                      

    ,CompanyID = @CompanyID                

    ,YearCode = @YearCode                      

    ,IsActive = @IsActive                      

    ,UpdatedBy = @OperationBy                      

    ,updatedon = GETDATE()                      

   WHERE ID = @ID                      

   --EXEC USP_InsertLUTMaster_Audit @ID                      

   -- ,@LUTNumber                      

   -- ,@ValidFrom                      

   -- ,@ValidTo                      

   -- ,@CompanyID                      

   -- ,@YearCode                      

   -- ,@IsActive                      

   -- ,'Update'                      

   -- ,@InsertedBy                      

  SELECT '200' AS returnCode, 'Record updated successfully.'   AS returnMessage, @ID as ID;                      

  END                      

END                      

ELSE IF @Action = 'S'                      

BEGIN                      

  SELECT CAST(L.ValidFrom AS DATE) AS ValidFrom,  CAST(L.ValidTo AS DATE) AS ValidTo,                  

  L.CompanyID,                  

  L.yearcode,                  

  L.LUTNumber,                  

  L.ID                  

  ,L.IsActive                  

   ,C.companyname AS CompnayName                      

  FROM LUTMaster L                      

  LEFT JOIN companymaster c ON L.companyid = c.companyid                      

  WHERE (@id IS NULL OR @id = 0 OR L.ID = @id  )              

  order by id desc      

END         
 
--ELSE IF @Action = 'ex'                      

-- BEGIN                      

--  SELECT CAST(L.ValidFrom AS DATE) AS ValidFrom,  CAST(L.ValidTo AS DATE) AS ValidTo,        

--  L.yearcode,                  

--  L.LUTNumber                             

--  ,Case 

--	WHEN L.IsActive = 1 THEN 'Yes'

--	WHEN L.IsActive = 0 THEN 'No'

--	END AS IsActive

--   ,C.companyname AS CompanyName                      

--  FROM LUTMaster L                      

--  LEFT JOIN companymaster c ON L.companyid = c.companyid                      

--  WHERE (@id IS NULL OR @id = 0 OR L.ID = @id  )              

--  order by id desc      

--END   

--ELSE IF @Action = 'ex'

--BEGIN

--  SELECT 

--    CAST(L.ValidFrom AS DATE) AS ValidFrom,  

--    CAST(L.ValidTo AS DATE) AS ValidTo,        

--    L.yearcode,                  

--    L.LUTNumber,                             

--    L.IsActive,  -- keep as BIT (0/1)

--    C.companyname AS CompanyName                      

--  FROM LUTMaster L                      

--  LEFT JOIN companymaster c ON L.companyid = c.companyid                      

--  WHERE (@id IS NULL OR @id = 0 OR L.ID = @id)              

--  ORDER BY id DESC      

--END

ELSE IF @Action = 'EX'

BEGIN

  SELECT 

    L.ID,                       

    L.LUTNumber,

    CAST(L.ValidFrom AS DATE) AS ValidFrom,  

    CAST(L.ValidTo AS DATE) AS ValidTo,        

    L.IsActive,                 

    C.CompanyName               

  FROM LUTMaster L

  LEFT JOIN companymaster C ON L.CompanyID = C.CompanyID

  WHERE (@id IS NULL OR @id = 0 OR L.ID = @id)

  ORDER BY L.ID DESC

END
 
 
END
<<<<<<< HEAD
 
>>>>>>> dev
=======
 
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

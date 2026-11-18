<<<<<<< HEAD
<<<<<<< HEAD
﻿--------------------------------------------                
CREATE PROCEDURE [dbo].[usp_InvoiceDescription_Master] @Description NVARCHAR(100)              
 ,@IsActive BIT              
 ,@ISComm BIT              
 ,@OperationBy UNIQUEIDENTIFIER              
 ,@SACCode INT              
 ,@Action NVARCHAR(2)=''              
 ,@InvDesc_ID INT =''              
 --,@ErrMsg VARCHAR(50) OUT              
AS              
BEGIN              
IF @Action='I'              
BEGIN              
 DECLARE @new_identity INT              
              
 IF NOT EXISTS (        
    SELECT 1         
    FROM InvoiceDescription_Master         
    WHERE Description = @Description        
)        
BEGIN        
    INSERT INTO InvoiceDescription_Master (        
        Description,        
        IsActive,        
        Operation,        
        CreatedBy,        
        CreatedDate,        
        Updatedby,        
        UpdatedOn,        
        SACCode,        
        ISComm        
    )         
    VALUES (        
        @Description,        
        @IsActive,        
        'Insert',        
        @OperationBy,        
        GETDATE(),        
        @OperationBy,        
        GETDATE(),        
        @SACCode,        
        @ISComm        
    )        
        
    SELECT @new_identity = SCOPE_IDENTITY()        
        
    SELECT '200' AS returnCode,         
           'New record added successfully.' AS returnMessage,         
           @new_identity AS ID        
END        
ELSE        
BEGIN        
    SELECT '201' AS returnCode,         
           'Description already exists. Please check and try again.' AS returnMessage        
END        
end        
ELSE IF @Action='U'             
IF NOT EXISTS (        
    SELECT 1         
    FROM InvoiceDescription_Master         
    WHERE Description = @Description and IsActive = @IsActive       
)        
BEGIN              
 UPDATE InvoiceDescription_Master              
 SET Description = @Description              
  ,SACCode = @SACCode              
  ,IsActive = @IsActive              
  ,ISComm = @ISComm              
  ,Operation = 'Update'              
  ,UpdatedBy = @OperationBy              
    ,UpdatedOn = GETDATE()              
 WHERE InvDesc_ID = @InvDesc_ID              
              
 EXEC usp_InsertInvoiceDescription_Audit @InvDesc_ID              
  ,@Description              
  ,@IsActive              
  ,@ISComm              
  ,'Update'              
  ,@OperationBy              
  ,@SACCode              
              
SELECT '200' AS returnCode, 'Record updated successfully.'   AS returnMessage, @InvDesc_ID AS ID;              
END         
ELSE      
BEGIN      
 SELECT '201' AS returnCode,         
           'Description already exists. Please check and try again.' AS returnMessage       
END      
ELSE IF @Action='S'              
BEGIN              
 IF (@IsActive = 0)              
 BEGIN              
  SELECT c.*              
   ,s.Description AS SACDescription              
   ,s.ID AS SACID              
  FROM InvoiceDescription_Master C              
  LEFT JOIN SAC_Master s ON c.SACCode = s.ID              
  WHERE (       @InvDesc_ID IS NULL       OR @InvDesc_ID = 0       OR InvDesc_ID = @InvDesc_ID       )                
            
  ORDER BY C.InvDesc_ID DESC              
 END              
 ELSE              
 BEGIN              
  SELECT c.*              
   ,s.Description AS SACDescription              
   ,s.ID AS SACID              
  FROM InvoiceDescription_Master C              
  LEFT JOIN SAC_Master s ON c.SACCode = s.ID              
  WHERE C.IsActive = 1              
   AND (              
    c.ISComm = 0              
    OR c.ISComm IS NULL              
    )  AND (       @InvDesc_ID IS NULL       OR @InvDesc_ID = 0       OR InvDesc_ID = @InvDesc_ID       )               
  ORDER BY C.InvDesc_ID DESC              
 END              
              
END              
              
--ELSE IF @Action='EX'              
--BEGIN                         
             
--  SELECT c.Description,
--   SACCode,
--   Case 
--		WHEN IsComm = 1 Then 'Yes'
--		WHEN IsComm = 0 tHEN 'No'
--   End as IsComm,
--   Case 
--		WHEN c.IsActive = 1 Then 'Yes'
--		WHEN c.IsActive = 0 tHEN 'No'
--   End as IsActive
--  FROM InvoiceDescription_Master C              
--  LEFT JOIN SAC_Master s ON c.SACCode = s.ID              
--  WHERE (       @InvDesc_ID IS NULL       OR @InvDesc_ID = 0       OR InvDesc_ID = @InvDesc_ID       )                
            
--  ORDER BY C.InvDesc_ID DESC              
-- END    
ELSE IF @Action = 'EX'
BEGIN
  SELECT 
     c.Description,
     SACCode,
     c.ISComm,      -- return bit as is
     c.IsActive     -- return bit as is
  FROM InvoiceDescription_Master C
  LEFT JOIN SAC_Master s ON c.SACCode = s.ID
  WHERE (@InvDesc_ID IS NULL OR @InvDesc_ID = 0 OR InvDesc_ID = @InvDesc_ID)
  ORDER BY C.InvDesc_ID DESC
END

END 
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
﻿
--------------------------------------------                

CREATE PROCEDURE [dbo].[usp_InvoiceDescription_Master] @Description NVARCHAR(100)              

,@IsActive BIT              

,@ISComm BIT              

,@OperationBy UNIQUEIDENTIFIER              

,@SACCode INT              

,@Action NVARCHAR(2)=''              

,@InvDesc_ID INT =''              

--,@ErrMsg VARCHAR(50) OUT              

AS              

BEGIN              

IF @Action='I'              

BEGIN              

DECLARE @new_identity INT              

IF NOT EXISTS (        

    SELECT 1         

    FROM InvoiceDescription_Master         

    WHERE Description = @Description        

)        

BEGIN        

    INSERT INTO InvoiceDescription_Master (        

        Description,        

        IsActive,        

        Operation,        

        CreatedBy,        

        CreatedDate,        

        Updatedby,        

        UpdatedOn,        

        SACCode,        

        ISComm        

    )         

    VALUES (        

        @Description,        

        @IsActive,        

        'Insert',        

        @OperationBy,        

        GETDATE(),        

        @OperationBy,        

        GETDATE(),        

        @SACCode,        

        @ISComm        

    )        

    SELECT @new_identity = SCOPE_IDENTITY()        

    SELECT '200' AS returnCode,         

           'New record added successfully.' AS returnMessage,         

           @new_identity AS ID        

END        

ELSE        

BEGIN        

    SELECT '201' AS returnCode,         

           'Description already exists. Please check and try again.' AS returnMessage        

END        

end        

ELSE IF @Action='U'             

IF NOT EXISTS (        

    SELECT 1         

    FROM InvoiceDescription_Master         

    WHERE Description = @Description and IsActive = @IsActive       

)        

BEGIN              

UPDATE InvoiceDescription_Master              

SET Description = @Description              

  ,SACCode = @SACCode              

  ,IsActive = @IsActive              

  ,ISComm = @ISComm              

  ,Operation = 'Update'              

  ,UpdatedBy = @OperationBy              

    ,UpdatedOn = GETDATE()              

WHERE InvDesc_ID = @InvDesc_ID              


SELECT '200' AS returnCode, 'Record updated successfully.'   AS returnMessage, @InvDesc_ID AS ID;              

END         

ELSE      

BEGIN      

SELECT '201' AS returnCode,         

           'Description already exists. Please check and try again.' AS returnMessage       

END      

ELSE IF @Action='S'              

BEGIN              

IF (@IsActive = 0)              

BEGIN              

  SELECT c.*              

   ,s.Description AS SACDescription              

   ,s.ID AS SACID              

  FROM InvoiceDescription_Master C              

  LEFT JOIN SAC_Master s ON c.SACCode = s.ID              

  WHERE (       @InvDesc_ID IS NULL       OR @InvDesc_ID = 0       OR InvDesc_ID = @InvDesc_ID       )                

  ORDER BY C.InvDesc_ID DESC              

END              

ELSE              

BEGIN              

  SELECT c.*              

   ,s.Description AS SACDescription              

   ,s.ID AS SACID              

  FROM InvoiceDescription_Master C              

  LEFT JOIN SAC_Master s ON c.SACCode = s.ID              

  WHERE C.IsActive = 1              

   AND (              

    c.ISComm = 0              

    OR c.ISComm IS NULL              

    )  AND (       @InvDesc_ID IS NULL       OR @InvDesc_ID = 0       OR InvDesc_ID = @InvDesc_ID       )               

  ORDER BY C.InvDesc_ID DESC              

END              

END              

--ELSE IF @Action='EX'              

--BEGIN                         

--  SELECT c.Description,

--   SACCode,

--   Case 

--		WHEN IsComm = 1 Then 'Yes'

--		WHEN IsComm = 0 tHEN 'No'

--   End as IsComm,

--   Case 

--		WHEN c.IsActive = 1 Then 'Yes'

--		WHEN c.IsActive = 0 tHEN 'No'

--   End as IsActive

--  FROM InvoiceDescription_Master C              

--  LEFT JOIN SAC_Master s ON c.SACCode = s.ID              

--  WHERE (       @InvDesc_ID IS NULL       OR @InvDesc_ID = 0       OR InvDesc_ID = @InvDesc_ID       )                

--  ORDER BY C.InvDesc_ID DESC              

-- END    

ELSE IF @Action = 'EX'

BEGIN

  SELECT 

     c.InvDesc_ID,        -- Added the missing InvDesc_ID field

     c.Description,

     c.SACCode,

     s.Description AS SACDescription,  -- Added SAC Description

     CASE 

        WHEN c.ISComm = 1 THEN 'True'

        WHEN c.ISComm = 0 THEN 'False'

        ELSE 'False'

     END as ISComm,

     CASE 

        WHEN c.IsActive = 1 THEN 'True'

        WHEN c.IsActive = 0 THEN 'False'

        ELSE 'False'

     END as IsActive

  FROM InvoiceDescription_Master C

  LEFT JOIN SAC_Master s ON c.SACCode = s.ID

  WHERE (@InvDesc_ID IS NULL OR @InvDesc_ID = 0 OR InvDesc_ID = @InvDesc_ID)

  ORDER BY C.InvDesc_ID DESC

END

end
<<<<<<< HEAD
 
>>>>>>> dev
=======
 
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

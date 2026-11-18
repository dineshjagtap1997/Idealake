CREATE PROCEDURE [dbo].[usp_LegalEntityType_Master] @LegalEntityType NVARCHAR(80)            
 ,@IsActive BIT            
 ,@OperationBy UNIQUEIDENTIFIER            
 --,@ErrMsg VARCHAR(50) OUT                    
 ,@Action CHAR(2) = ''            
 ,@LegalEntTypeID INT = ''  
 --,@PageNumber BIGINT=NULL  
 --,@PageSize INT=NULL  
 --,@Active BIT=''                    
AS            
BEGIN            
 IF @Action = 'I'            
 BEGIN            
  DECLARE @new_identity INT            
            
  IF NOT EXISTS (            
    SELECT 1            
    FROM LegalEntityType_Master            
    WHERE LegalEntityType = @LegalEntityType            
    )            
  BEGIN            
   INSERT INTO LegalEntityType_Master (            
    LegalEntityType            
    ,IsActive            
    ,Operation            
    ,CreatedBy            
    ,CreatedDate            
    )            
   VALUES (            
    @LegalEntityType            
    ,@IsActive            
    ,'Insert'            
    ,@OperationBy            
    ,GETDATE()            
    )            
            
   SELECT '200' AS returnCode            
    ,'New record added successfully.' AS returnMessage            
    ,@@IDENTITY AS ID;            
  END            
  ELSE            
  BEGIN            
   SELECT '201' AS returnCode            
    ,'Legal Entity Type already exists. Please check and try again.' AS returnMessage            
    ,@@IDENTITY AS ID;            
  END            
    --SELECT @new_identity = SCOPE_IDENTITY()                    
    --EXEC usp_InsertLegalEntityType_Audit @new_identity                    
    -- ,@LegalEntityType                    
    -- ,@IsActive                    
    -- ,'Insert'                    
    -- ,@OperationBy                    
 END            
 ELSE IF @Action = 'U'            
 IF NOT EXISTS (            
    SELECT 1            
    FROM LegalEntityType_Master            
    WHERE LegalEntityType = @LegalEntityType  and IsActive = @IsActive               
    )            
 BEGIN            
  UPDATE LegalEntityType_Master            
  SET LegalEntityType = @LegalEntityType            
   ,IsActive = @IsActive            
   ,Operation = 'Update'            
   ,UpdatedBy = @OperationBy            
   ,UpdatedOn = GETDATE()            
  WHERE LegalEntTypeID = @LegalEntTypeID            
            
  --EXEC usp_InsertLegalEntityType_Audit @LegalEntTypeID                    
  -- ,@LegalEntityType                    
  -- ,@IsActive                    
  -- ,'Update'                    
  -- ,@OperationBy                    
  SELECT '200' AS returnCode            
   ,'Record updated successfully.' AS returnMessage            
   ,@LegalEntTypeID AS ID;            
 END            
 ELSE             
 BEGIN            
 SELECT '201' AS returnCode            
    ,'Legal Entity Type already exists. Please check and try again.' AS returnMessage            
    ,@@IDENTITY AS ID;            
 END            
 ELSE IF @Action = 'S'            
 BEGIN            
  SELECT *            
  FROM LegalEntityType_Master C            
  WHERE (            
    @LegalEntTypeID IS NULL            
    OR @LegalEntTypeID = 0            
    OR LegalEntTypeID = @LegalEntTypeID            
    )  
	order by C.LegalEntityType ASC
  --ORDER BY C.LegalEntTypeID DESC     
  -- OFFSET (@PageNumber - 1) * @PageSize ROWS     FETCH NEXT @PageSize ROWS ONLY;  
   --ELSE                            
   --BEGIN                            
   -- SELECT *                              
   -- FROM LegalEntityType_Master C                             
   -- WHERE C.IsActive=1  and                    
   --(@LegalEntTypeID IS NULL OR @LegalEntTypeID = 0 OR LegalEntTypeID = @LegalEntTypeID)                    
   -- Order by C.LegalEntTypeID desc                        
   --END                      
   --SELECT '' AS returnCode, ''   AS returnMessage;                    
 END      
     
 ELSE IF @Action = 'EX'            
 BEGIN            
  SELECT LegalEntityType, IsActive           
  FROM LegalEntityType_Master C            
  WHERE (            
    @LegalEntTypeID IS NULL            
    OR @LegalEntTypeID = 0            
    OR LegalEntTypeID = @LegalEntTypeID            
    )            
  ORDER BY C.LegalEntTypeID DESC                          
 END     
    
END
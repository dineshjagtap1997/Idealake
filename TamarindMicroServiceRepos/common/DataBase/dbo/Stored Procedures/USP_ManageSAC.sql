CREATE PROCEDURE [dbo].[USP_ManageSAC]            
    @Action VARCHAR(10), -- 'SELECT', 'INSERT', 'UPDATE'            
    @ID INT = NULL,            
    @Code VARCHAR(8) = NULL,            
    @Description VARCHAR(75) = NULL,            
    @IsActive BIT = NULL,            
    @OperationBy UNIQUEIDENTIFIER = NULL,            
    @ForTkt BIT = 0            
AS            
BEGIN            
DECLARE @ReturnCode NVARCHAR(3), @ReturnMessage NVARCHAR(MAX);                    
            
    IF @Action = 'S'            
    BEGIN            
  IF @ID != NULL OR @ID <> 0            
  BEGIN            
   SELECT ID, Code, Description, IsActive, Operation, OperationBy, OperationDate, ForTkt            
   FROM SAC_Master             
   WHERE (@ID IS NULL OR @ID = 0 OR ID = @ID)            
   order by ID desc          
  END            
  ELSE            
  BEGIN            
   SELECT ID, Code, Description, IsActive, Operation, OperationBy, OperationDate, ForTkt            
   FROM SAC_Master            
    order by ID desc          
  END            
   SET @ReturnCode = '';                      
   SET @ReturnMessage ='';            
    END         
     
  -- ELSE IF @Action = 'EX'            
  --   BEGIN            
  --IF @ID != NULL OR @ID <> 0            
  --BEGIN            
  -- SELECT  Code, Description ,CASE   
  --      WHEN IsActive = 1 THEN 'True'  
  --      WHEN IsActive = 0 THEN 'False'  
  --  END AS IsActive, Operation, OperationBy, OperationDate, CASE   
  --      WHEN ForTkt = 1 THEN 'Yes'  
  --      WHEN ForTkt = 0 THEN 'No'  
  --  END AS ForTkt               
  -- FROM SAC_Master             
  -- WHERE (@ID IS NULL OR @ID = 0 OR ID = @ID)            
  -- order by ID desc          
  --END            
  --ELSE            
  --BEGIN            
  -- SELECT Code, Description ,CASE   
  --      WHEN IsActive = 1 THEN 'True'  
  --      WHEN IsActive = 0 THEN 'False'  
  --  END AS IsActive, Operation, OperationBy, OperationDate, CASE   
  --      WHEN ForTkt = 1 THEN 'Yes'  
  --      WHEN ForTkt = 0 THEN 'No'  
  --  END AS ForTkt            
  -- FROM SAC_Master            
  --  order by ID desc          
  --END            
  -- SET @ReturnCode = '';                      
  -- SET @ReturnMessage ='';            
  --  END   
  ELSE IF @Action = 'EX'            
BEGIN            
<<<<<<< HEAD
<<<<<<< HEAD
    SELECT 
        Code, 
        Description,
        IsActive,
        Operation, 
        OperationBy, 
        OperationDate, 
        ForTkt
    FROM SAC_Master             
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
   SELECT	
		ID,
        Code, 
        Description,
        SM.IsActive,
        SM.Operation, 
        --OperationBy, 
		EM.EmpName ,
        OperationDate, 
        ForTkt
    FROM SAC_Master     SM
	left join EmployeeMaster EM on EM.UserID=SM.OperationBy
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    WHERE (@ID IS NULL OR @ID = 0 OR ID = @ID)            
    ORDER BY ID DESC;          

    SET @ReturnCode = '';                      
    SET @ReturnMessage = '';            
END

            
    ELSE IF @Action = 'I'            
    BEGIN            
        IF EXISTS (SELECT Code FROM SAC_Master WHERE UPPER(Code) = UPPER(@Code))            
        BEGIN            
   SET @ReturnCode = '201';                      
   SET @ReturnMessage ='SAC code already exists. Please check and try again.' ;       END            
        ELSE IF EXISTS (SELECT Description FROM SAC_Master WHERE UPPER(Description) = UPPER(@Description))            
        BEGIN            
            SET @ReturnCode = '201';                      
   SET @ReturnMessage ='SAC code already exists. Please check and try again.';            
        END            
        ELSE            
        BEGIN            
            INSERT INTO SAC_Master            
                (Code, Description, IsActive, Operation, OperationBy, OperationDate, ForTkt)            
            VALUES            
                (UPPER(@Code), @Description, @IsActive, 'Insert', @OperationBy, GETDATE(), @ForTkt);          
            
 SET @ID =SCOPE_IDENTITY()        
    SET @ReturnCode = '200';                      
    SET @ReturnMessage ='New record added successfully.';            
  END            
    END            
            
    ELSE IF @Action = 'U'            
    BEGIN            
        IF EXISTS (SELECT Code FROM SAC_Master WHERE UPPER(Code) = UPPER(@Code) AND Code <> @Code)            
        BEGIN            
            SET @ReturnCode = '201';                      
   SET @ReturnMessage ='SAC code already exists. Please check and try again.';            
        END            
        ELSE            
        BEGIN            
            UPDATE SAC_Master            
            SET            
                Code = ISNULL(@Code, code),           
                Description =ISNULL(@Description, Description),           
                IsActive = ISNULL(@IsActive,  IsActive),          
                Operation = 'Update' ,           
                UpdatedBy = ISNULL(@OperationBy , UpdatedBy)          
    ,UpdatedOn = GETDATE(),            
                ForTkt =ISNULL( @ForTkt  ,ForTkt)          
            WHERE ID = @ID;            
            
         
            SET @ReturnCode = '200';                  
   SET @ReturnMessage ='Record updated successfully.';            
        END            
    END            
    ELSE            
    BEGIN            
        SET @ReturnCode = '201';                  
  SET @ReturnMessage ='Invalid action.';            
    END            
 SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @ID AS  ID;                
END 
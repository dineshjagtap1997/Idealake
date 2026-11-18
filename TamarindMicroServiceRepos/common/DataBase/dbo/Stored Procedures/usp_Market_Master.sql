<<<<<<< HEAD
<<<<<<< HEAD
﻿CREATE PROCEDURE [dbo].[usp_Market_Master]                                
=======
﻿
CREATE PROCEDURE [dbo].[usp_Market_Master]                                
>>>>>>> dev
=======
﻿
CREATE PROCEDURE [dbo].[usp_Market_Master]                                
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    @ID INT='',                                
    @Name VARCHAR(50)='',                                
    @IsActive BIT='',                                
    @ABRV VARCHAR(10)='',                                
    @OperationBy UNIQUEIDENTIFIER= null,                                
    --@ErrMsg VARCHAR(50) ='',                                
    @Action CHAR(2) = ''                                
AS                                
BEGIN                                
    SET NOCOUNT ON;                              
                              
    IF @Action = 'I'                                  
    BEGIN                                
        IF EXISTS (SELECT Name FROM Market WHERE UPPER(Name) = UPPER(@Name))                                  
        BEGIN                                  
            SELECT '201' AS returnCode, 'Market name already exists. Please check and try again.' AS returnMessage                                  
        END                                  
        ELSE IF EXISTS (SELECT ABRV FROM Market WHERE UPPER(ABRV) = UPPER(@ABRV))                                  
        BEGIN                                  
                                        
<<<<<<< HEAD
<<<<<<< HEAD
   SELECT '201' AS returnCode, 'Market name already exists. Please check and try again.' AS returnMessage                            
=======
   SELECT '201' AS returnCode, 'ABRV name already exists. Please check and try again.' AS returnMessage                            
>>>>>>> dev
=======
   SELECT '201' AS returnCode, 'ABRV name already exists. Please check and try again.' AS returnMessage                            
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
        END                                  
        ELSE                                  
        BEGIN                                  
            INSERT INTO Market (Name, IsActive, ABRV, Operation, OperationBy, OperationOn, OldID)                                  
            VALUES (@Name, @IsActive, UPPER(@ABRV), 'Insert', @OperationBy, GETDATE(), UPPER(@ABRV));                                  
                                          
     --SELECT * FROM Market WHERE ID = @@IDENTITY                            
                                 
                                          
             SELECT *, '200' AS returnCode, 'New record added successfully.' AS returnMessage FROM Market WHERE ID = @@IDENTITY                               
        END                                  
    END -- I                              
    ELSE IF @Action = 'U'                                  
    BEGIN                               
        IF EXISTS (SELECT Name FROM Market WHERE UPPER(Name) = UPPER(@Name) AND ID != @ID)                                
        BEGIN                                
            SELECT '201' AS returnCode, 'Market name already exists. Please check and try again.' AS returnMessage                              
        END                                
        ELSE IF EXISTS (SELECT ABRV FROM Market WHERE UPPER(ABRV) = UPPER(@ABRV) AND ID != @ID)                                
        BEGIN                                
<<<<<<< HEAD
<<<<<<< HEAD
   SELECT '201' AS returnCode, 'Market name already exists. Please check and try again.' AS returnMessage                              
=======
   SELECT '201' AS returnCode, 'ABRV name already exists. Please check and try again.' AS returnMessage                              
>>>>>>> dev
=======
   SELECT '201' AS returnCode, 'ABRV name already exists. Please check and try again.' AS returnMessage                              
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
        END                                
        ELSE                                
        BEGIN                                
            UPDATE Market                                
            SET Name = @Name,                                
                IsActive = @IsActive,                                
                ABRV = UPPER(@ABRV),                                
                Operation = 'Update'                               
                ,UpdatedBy = @OperationBy                            
    ,UpdatedOn = GETDATE()                               
            WHERE ID = @ID;                                
                               
                                          
   SELECT '200' AS returnCode, 'Record updated successfully.' AS returnMessage , @ID as ID                               
        END                                
    END  -- U                              
    ELSE IF @Action = 'S'                                  
    BEGIN                              
  --SELECT ID, Name, IsActive, ABRV                             
  --FROM Market              
  --WHERE (@ID IS NULL OR @ID = 0 OR ID = @ID)            
  --ORDER BY Name;                                         
                                                    
        BEGIN                           
<<<<<<< HEAD
<<<<<<< HEAD
          SELECT ID, Name, IsActive, ABRV FROM Market where (@ID IS NULL OR @ID = 0 OR ID = @ID)      ORDER  BY 1 DESC;                                     
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
        -- sarthak-- SELECT ID, Name, IsActive, ABRV FROM Market where (@ID IS NULL OR @ID = 0 OR ID = @ID)      ORDER  BY 1 DESC;       
		SELECT ID, Name, IsActive, ABRV 
FROM Market 
WHERE (@ID IS NULL OR @ID = 0 OR ID = @ID)      
ORDER BY ISNULL(UpdatedOn, OperationOn) DESC;

<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
          --SELECT Name FROM Country   ORDER BY 1 desc;                                  
        END                                    
        --ELSE                             
        --BEGIN                                    
        --    SELECT ID, Name, IsActive, ABRV FROM Market                                      
        --    WHERE IsActive = 1 and (@ID IS NULL OR @ID = 0 OR ID = @ID)      ORDER BY 1desc;                                  
                                          
        --END                               
  --SELECT '' AS returnCode, '' AS returnMessage                               
    END  -- S            
           
 else if @Action = 'F'          
 BEGIN          
 SELECT ID, NAME FROM MARKET          
 WHERE (@ID = 0 OR @ID = NULL OR ID = @ID)          
 END          
    
 ELSE IF @Action = 'EX'                                  
      BEGIN                           
          SELECT  Name,CASE   
        WHEN IsActive = 1 THEN 'True'  
        WHEN IsActive = 0 THEN 'False'  
    END AS IsActive , ABRV FROM Market where (@ID IS NULL OR @ID = 0 OR ID = @ID)      ORDER  BY 1 DESC;                                     
                                       
        END                                
               
           
 else if @Action = 'F'          
 BEGIN          
 SELECT ID, NAME FROM MARKET          
 WHERE (@ID = 0 OR @ID = NULL OR ID = @ID)          
 END       
    
END 
<<<<<<< HEAD
<<<<<<< HEAD
﻿CREATE PROCEDURE [dbo].[usp_RuleGroups_Master] @Name VARCHAR(50)              
=======
﻿
CREATE PROCEDURE [dbo].[usp_RuleGroups_Master] @Name VARCHAR(50)              
>>>>>>> dev
=======
﻿
CREATE PROCEDURE [dbo].[usp_RuleGroups_Master] @Name VARCHAR(50)              
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
 ,@IsActive BIT = 1              
 ,@OperationBy UNIQUEIDENTIFIER              
 ,@Action CHAR(2) = ''               
 ,@ID INT = NULL -- Default to NULL if no ID is provided                
AS              
BEGIN              
          
 Declare @LogID int;           
          
           
 IF @Action = 'I'              
 BEGIN              
  IF EXISTS (              
    SELECT TOP 1 1              
    FROM RuleGroups              
    WHERE Name = @Name              
    )              
  BEGIN              
   SELECT '201' AS returnCode              
    ,'Rule Group already exists. Please check and try again.' AS returnMessage;              
  END              
  ELSE              
  BEGIN              
   INSERT INTO RuleGroups (              
    Name              
    ,IsActive              
    ,Operation              
    ,OperationBy              
    ,OperationOn              
    )              
   VALUES (              
    @Name              
    ,@IsActive              
    ,'Insert'              
    ,@OperationBy              
    ,GETDATE()              
    );              
              
                  
   DECLARE @NewID INT = SCOPE_IDENTITY();              
<<<<<<< HEAD
<<<<<<< HEAD
   EXEC usp_InsertRuleGroups_Audit @Name,@IsActive,@OperationBy,'INSERT',@ID              
=======
          
>>>>>>> dev
=======
          
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
                
   SELECT '200' AS returnCode              
    ,'New record added successfully.' AS returnMessage, @NewID AS ID;              
  END              
 END              
 ELSE IF @Action = 'U'              
 BEGIN              
  IF EXISTS (              
    SELECT TOP 1 1              
    FROM RuleGroups              
    WHERE Name = @Name              
     AND ID != @ID              
    )              
  BEGIN              
   SELECT '201' AS returnCode              
    ,'Rule Group already exists. Please check and try again.' AS returnMessage;              
  END              
  ELSE              
  BEGIN              
   UPDATE RuleGroups              
   SET Name = @Name              
    ,IsActive = @IsActive              
    ,Operation = 'Update'              
    ,UpdatedBy = @OperationBy              
    ,UpdatedOn = GETDATE()              
<<<<<<< HEAD
<<<<<<< HEAD
   WHERE ID = @ID;              
              
   EXEC usp_InsertRuleGroups_Audit @Name,@IsActive,@OperationBy,'Update',@ID              
=======
   WHERE ID = @ID;                    
>>>>>>> dev
=======
   WHERE ID = @ID;                    
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
              
   SELECT '200' AS returnCode              
    ,'Record updated successfully.' AS returnMessage, @ID AS ID;              
  END              
 END              
 ELSE IF @Action = 'S'              
 BEGIN              
  SELECT ID              
   ,Name 
   ,Name AS [Rule]
   ,IsActive
  FROM RuleGroups              
  WHERE (              
    @ID IS NULL              
    OR @ID = 0              
    OR ID = @ID              
    )  order by ID desc            
              
               
 END              
 ELSE IF @Action='EX'    
 BEGIN    
   SELECT Name              
   ,CASE     
        WHEN IsActive = 1 THEN 'True'    
        WHEN IsActive = 0 THEN 'False'    
    END AS IsActive               
  FROM RuleGroups              
  WHERE (              
    @ID IS NULL              
    OR @ID = 0              
    OR ID = @ID              
    )  order by ID desc      
 END    
END
<<<<<<< HEAD
<<<<<<< HEAD
﻿CREATE PROCEDURE [dbo].[usp_ManageBusinessMaster]                
(                
    @Action VARCHAR(10), -- 'SELECT', 'INSERT', 'UPDATE'                
    @BussinessModuleID nvarchar = NULL,                
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
﻿
CREATE PROCEDURE [dbo].[usp_ManageBusinessMaster]                
(                
    @Action VARCHAR(10), -- 'SELECT', 'INSERT', 'UPDATE'                
   -- @BussinessModuleID nvarchar = NULL, 
    @BussinessModuleID INT = NULL,
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    @BusinessModuleName VARCHAR(50) = NULL,                
    @IsActive BIT = NULL,                
    @OperationBy UNIQUEIDENTIFIER = NULL,                
    @IsTTCLogo BIT = 0                
)                
AS                
BEGIN                
DECLARE @ReturnCode NVARCHAR(3), @ReturnMessage NVARCHAR(MAX);                        
   Declare @LogID int;              
    -- SELECT Operation                
    IF @Action = 'S'                
    BEGIN                
        -- If @IsActive is NULL, it will return all records, else only active records.                
        IF (@IsActive IS NULL OR @IsActive = 0)                
        BEGIN                
            SELECT                 
                BussinessModuleID,                 
                BusinessModuleName,                 
                IsActive,                 
                IsTTCLogo --, Operation, OperationBy, InsertedDatetime                
            FROM BusinessMaster    WHERE (@BussinessModuleID IS NULL OR @BussinessModuleID = 0 OR BussinessModuleID = @BussinessModuleID)                 
            ORDER BY BussinessModuleID DESC;                
        END                
        ELSE                
        BEGIN                
            SELECT                 
                BussinessModuleID,                 
                BusinessModuleName,                 
                IsActive,                 
                IsTTCLogo --, Operation, OperationBy, InsertedDatetime                
            FROM BusinessMaster                
            WHERE IsActive = 1  AND  (@BussinessModuleID IS NULL OR @BussinessModuleID = 0 OR BussinessModuleID = @BussinessModuleID)               
            ORDER BY BussinessModuleID DESC;                
        END                
    END                
   --      ELSE IF @Action='EX'  
   --BEGIN  
   --  IF (@IsActive IS NULL OR @IsActive = 0)                
   --     BEGIN                
   --         SELECT  BusinessModuleName,                 
   --             CASE   
   --     WHEN IsActive = 1 THEN 'True'  
   --     WHEN IsActive = 0 THEN 'False'  
   -- END AS IsActive  , CASE   
   --     WHEN IsTTCLogo = 1 THEN 'Yes'  
   --     WHEN IsTTCLogo = 0 THEN 'No'  
   -- END AS IsTTCLogo  --, Operation, OperationBy, InsertedDatetime                
   --         FROM BusinessMaster    WHERE (@BussinessModuleID IS NULL OR @BussinessModuleID = 0 OR BussinessModuleID = @BussinessModuleID)                 
   --         ORDER BY BussinessModuleID DESC;                
   --     END                
   --     ELSE                
   --     BEGIN                
   --         SELECT                 
                                
   --             BusinessModuleName,                 
   --             CASE   
   --     WHEN IsActive = 1 THEN 'True'  
   --     WHEN IsActive = 0 THEN 'False'  
   -- END AS IsActive  ,                 
   --              CASE   
   --     WHEN IsTTCLogo = 1 THEN 'Yes'  
   --     WHEN IsTTCLogo = 0 THEN 'No'  
   -- END AS IsTTCLogo   --, Operation, OperationBy, InsertedDatetime                
   --         FROM BusinessMaster                
   --         WHERE IsActive = 1  AND  (@BussinessModuleID IS NULL OR @BussinessModuleID = 0 OR BussinessModuleID = @BussinessModuleID)               
   --         ORDER BY BussinessModuleID DESC;                
   --     END    
   --END  
   ELSE IF @Action = 'EX'  
BEGIN  
<<<<<<< HEAD
<<<<<<< HEAD
    IF (@IsActive IS NULL OR @IsActive = 0)                
    BEGIN                
        SELECT  
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

    IF (@IsActive IS NULL OR @IsActive = 0)                
    BEGIN    
	
        SELECT  
			BussinessModuleID,
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
            BusinessModuleName,                 
            IsActive,                 
            IsTTCLogo  
        FROM BusinessMaster    
        WHERE (@BussinessModuleID IS NULL OR @BussinessModuleID = 0 OR BussinessModuleID = @BussinessModuleID)                 
        ORDER BY BussinessModuleID DESC;                
    END                
    ELSE                
    BEGIN                
<<<<<<< HEAD
<<<<<<< HEAD
        SELECT                 
=======
        SELECT   
			BussinessModuleID,
>>>>>>> dev
=======
        SELECT   
			BussinessModuleID,
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
            BusinessModuleName,                 
            IsActive,                 
            IsTTCLogo  
        FROM BusinessMaster                
        WHERE IsActive = 1  
          AND (@BussinessModuleID IS NULL OR @BussinessModuleID = 0 OR BussinessModuleID = @BussinessModuleID)               
        ORDER BY BussinessModuleID DESC;                
    END    
END

    -- INSERT Operation                
    ELSE IF @Action = 'I'                
    BEGIN                
        -- Check if the BusinessModuleName already exists                
        IF EXISTS (SELECT BussinessModuleID FROM BusinessMaster WHERE UPPER(BusinessModuleName) = UPPER(@BusinessModuleName))                
        BEGIN                
            SET @ReturnCode = '201';                          
     SET @ReturnMessage ='This data already exists. Please check and try again.';                
        END                
        ELSE                
        BEGIN                
            -- Insert the new record                
            INSERT INTO BusinessMaster                
                (BusinessModuleName, IsActive, Operation, OperationBy, IsTTCLogo)                
        VALUES                
                (@BusinessModuleName, @IsActive, 'Insert', @OperationBy, @IsTTCLogo);         
            
   set @BussinessModuleID = SCOPE_IDENTITY()        
            select '200' AS returnCode, 'New record added successfully.' AS returnMessage, @BussinessModuleID AS ID  -- Successful insert, no error message                
        END                
    END                
 --Select * from BusinessMaster                
    -- UPDATE Operation                
    ELSE IF @Action = 'U'                
    BEGIN                
        -- Check if BusinessModuleName already exists for another record                
        IF NOT EXISTS (SELECT BussinessModuleID FROM BusinessMaster WHERE UPPER(BusinessModuleName) = UPPER(@BusinessModuleName) AND BussinessModuleID <> @BussinessModuleID)                
        BEGIN                
            -- Update the record                
            UPDATE BusinessMaster                
            SET                 
                BusinessModuleName = @BusinessModuleName,                
                IsActive = @IsActive,                
                Operation = 'Update'                
               ,UpdatedBy = @OperationBy                
    ,UpdatedOn = GETDATE(),                
                IsTTCLogo = @IsTTCLogo                
     WHERE BussinessModuleID = @BussinessModuleID;           
           
            SET @ReturnCode = '200';                          
     SET @ReturnMessage ='Record updated successfully.'; -- Successful update, no error message                
        END                
        ELSE                
        BEGIN                
            SET @ReturnCode = '201';                          
     SET @ReturnMessage ='This data already exists. Please check and try again.';                
        END                
    END                
    ELSE                
    BEGIN                
        SET @ReturnCode = '201';                          
     SET @ReturnMessage ='Invalid action.';                
    END                
    SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @BussinessModuleID AS ID ;                    
END 
<<<<<<< HEAD
<<<<<<< HEAD
﻿CREATE PROCEDURE [dbo].[sp_ManageCurrencyMaster]                      
=======
﻿
CREATE PROCEDURE [dbo].[sp_ManageCurrencyMaster]                      
>>>>>>> dev
=======
﻿
CREATE PROCEDURE [dbo].[sp_ManageCurrencyMaster]                      
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    @id INT = NULL,                        
    @CurrencyCode VARCHAR(10) = NULL,                        
    @Symbol VARCHAR(10) = NULL,                        
    @Effective_Date DATETIME = NULL,                        
    @Hedge_perc DECIMAL(10,4) = NULL,                        
    @IsActive BIT = 1,                        
    @CreatedBy uniqueidentifier = NULL,                      
    @UpdatedBy uniqueidentifier = NULL,                      
    @Action VARCHAR(10),                  
 @Name VARCHAR(200) = ''      
 ,@OperationBy uniqueidentifier =''      
AS                      
BEGIN                      
    SET NOCOUNT ON;                      
                      
    IF @Action = 'I'                      
    BEGIN                      
        -- Check if CurrencyCode already exists                      
        IF EXISTS (SELECT 1 FROM CurrencyMaster WHERE CurrencyCode = @CurrencyCode)                      
        BEGIN                      
            SELECT '201' AS returnCode, 'Currency Code already exists. Please check and try again.' AS returnMessage;                      
            RETURN;                      
        END                      
                              
        -- Insert new record                      
        INSERT INTO CurrencyMaster (CurrencyCode, Symbol, Effective_Date, Hedge_perc, IsActive, OperationBy, CreatedDateTime, Name)                      
        VALUES (@CurrencyCode, @Symbol, @Effective_Date, @Hedge_perc, @IsActive, @OperationBy, GETDATE(), @Name);                      
                             
                       
        SET @id = SCOPE_IDENTITY()                  
        SELECT '200' AS returnCode, 'New record added successfully.' AS returnMessage, @id AS ID;                      
    END                      
    ELSE IF @Action = 'U'                      
    BEGIN                      
        -- Check if record exists                      
        IF NOT EXISTS (SELECT 1 FROM CurrencyMaster WHERE id = @id)                      
        BEGIN                      
            SELECT '404' AS returnCode, 'Record not found.' AS returnMessage;                      
            RETURN;                      
        END                      
                              
        -- Update record                      
        UPDATE CurrencyMaster                      
        SET CurrencyCode = @CurrencyCode,                       
            Symbol = @Symbol,                       
            Effective_Date = @Effective_Date,                       
            Hedge_perc = @Hedge_perc,                       
            IsActive = @IsActive,                      
            UpdatedBy = @OperationBy,                       
            UpdatedDateTime = GETDATE(),                  
   Name = @Name                  
        WHERE id = @id;                      
                      
        SELECT '200' AS returnCode, 'Record updated successfully.' AS returnMessage, @id AS ID;                      
    END                      
    ELSE IF @Action = 'S'                      
    BEGIN                      
        -- Select record(s)                      
        SELECT * FROM CurrencyMaster                     
where (       @id IS NULL       OR @id = 0       OR id = @id       )   -- and IsActive = 1             
ORDER BY ID DESC              
       -- WHERE id = @id OR @id = 0 OR @id IS NULL;                      
    END  
	ELSE IF @Action='EX'
	BEGIN
<<<<<<< HEAD
<<<<<<< HEAD
	  SELECT CurrencyCode,Hedge_perc,CASE WHEN IsActive='1' THEN 'True' WHEN IsActive='0' THEN 'False' END AS IsActive FROM CurrencyMaster                     
=======
	  SELECT CurrencyCode,Name,Symbol,Hedge_perc,CASE WHEN IsActive='1' THEN 'True' WHEN IsActive='0' THEN 'False' END AS IsActive FROM CurrencyMaster                     
>>>>>>> dev
=======
	  SELECT CurrencyCode,Name,Symbol,Hedge_perc,CASE WHEN IsActive='1' THEN 'True' WHEN IsActive='0' THEN 'False' END AS IsActive FROM CurrencyMaster                     
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
where (       @id IS NULL       OR @id = 0       OR id = @id       )   -- and IsActive = 1             
ORDER BY ID DESC              
       -- WHERE id = @id OR @id = 0 OR @id IS NULL;    
	END
    ELSE                      
    BEGIN                      
        SELECT '400' AS returnCode, 'Invalid Action.' AS returnMessage;                      
    END                      
END; 
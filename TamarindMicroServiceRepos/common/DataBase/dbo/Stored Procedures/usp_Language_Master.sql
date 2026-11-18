CREATE PROCEDURE [dbo].[usp_Language_Master]                   
    @ID CHAR(2)=NULL,                  
    @Language VARCHAR(50)='',                  
    @IsActive BIT=0,                  
    @OperationBy UNIQUEIDENTIFIER = NULL,                  
    @Action CHAR(2) = ''                  
AS                  
BEGIN               
 Declare @LogID int;       
    DECLARE @ReturnCode NVARCHAR(3),                  
            @ReturnMessage NVARCHAR(MAX);                  
                  
    IF @Action = 'I'                  
    BEGIN                  
        -- Check if the ID already exists                  
        IF EXISTS (                  
            SELECT 1                  
            FROM LANGUAGE                  
            WHERE ID = @ID                  
        )                  
        BEGIN     
            SET @ReturnCode = '201';                  
         SET @ReturnMessage = 'Language already exists. Please check and try again.';                  
                  
            SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @LogID as ID;                  
            RETURN;                  
        END                  
                  
        -- Check if the Language already exists                  
        IF EXISTS (                  
            SELECT 1                  
            FROM LANGUAGE                  
            WHERE LANGUAGE = @Language                  
        )                  
        BEGIN                  
            SET @ReturnCode = '201';                  
            SET @ReturnMessage = 'Language already exists. Please check and try again.';                  
                  
            SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @LogID AS ID;                  
            RETURN;                  
        END                  
                  
        -- Proceed with Insert                  
        DECLARE @MaxID INT = (                  
            SELECT ISNULL(MAX(OldID), 0) + 1                  
            FROM LANGUAGE                  
        );                  
                  
        INSERT INTO LANGUAGE (                  
            ID, LANGUAGE, IsActive, Operation, OperationBy, OperationOn, OldID                  
        )                  
        VALUES (                  
            @ID, @Language, @IsActive, 'Insert', @OperationBy, GETDATE(), @MaxID                  
        );                  
                  
        --EXEC usp_InsertLanguage_Audit @ID, 'Insert', @OperationBy;                  
        SET @LogID = SCOPE_IDENTITY()    
        SET @ReturnCode = '200';                  
        SET @ReturnMessage = 'New record added successfully.';                  
                  
        SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @MaxID AS ID;                  
    END                  
    ELSE IF @Action = 'U'                  
    BEGIN                  
        -- Check if the Language already exists for another record                  
        IF EXISTS (                  
            SELECT 1                  
            FROM LANGUAGE                  
            WHERE LANGUAGE = @Language AND ID != @ID                  
        )                  
        BEGIN                  
            SET @ReturnCode = '201';                  
            SET @ReturnMessage = 'Language already exists. Please check and try again.';                  
                  
            SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @ID AS ID;                  
            RETURN;                  
        END                  
                  
        -- Proceed with Update                  
        UPDATE LANGUAGE                  
        SET LANGUAGE = @Language,                  
            IsActive = @IsActive,                  
            Operation = 'Update'                  
           ,UpdatedBy = @OperationBy                  
    ,UpdatedOn = GETDATE()                  
        WHERE ID = @ID;          
      
    
  SET @MaxID = (SELECT OldID FROM Language       WHERE ID = @ID)         
       
                  
        --EXEC usp_InsertLanguage_Audit @ID, 'Update', @OperationBy;                  
                  
        SET @ReturnCode = '200';                  
        SET @ReturnMessage = 'Record updated successfully.';                  
                  
        SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @MaxID AS ID ;                  
    END                  
    ELSE IF @Action = 'S'                  
    BEGIN            
        -- Fetch the records                  
        SELECT OldID as IDS , ID, [Language], IsActive                  
        FROM LANGUAGE                  
        WHERE (       @ID IS NULl OR @ID ='' OR ID = @ID       )    Order by OperationOn desc        
    END  
	   ELSE IF @Action = 'EX'                  
    BEGIN            
        -- Fetch the records                  
        SELECT  ID, [Language] ,CASE   
        WHEN IsActive = 1 THEN 'True'  
        WHEN IsActive = 0 THEN 'False'  
    END AS IsActive                  
        FROM LANGUAGE                  
        WHERE (       @ID IS NULl OR @ID ='' OR ID = @ID       )    Order by OperationOn desc        
    END  
    ELSE                  
    BEGIN                  
        SET @ReturnCode = '201';                  
        SET @ReturnMessage = 'Invalid Action';                  
                  
        SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @LogID AS ID;                  
    END  
	
END 
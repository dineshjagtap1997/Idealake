CREATE PROCEDURE [dbo].[usp_MOT_Master]                 
    @MOT VARCHAR(50),                
    @IsActive BIT,                
    @OperationBy UNIQUEIDENTIFIER,                
    @Action CHAR(2) = '',                
    @ID INT = null      
       
AS                
BEGIN              
      
    declare @LogID int      
    IF @Action = 'I'                
    BEGIN                
        IF EXISTS (SELECT TOP 1 1 FROM MOT WHERE MOT = @MOT)                
        BEGIN                
            SELECT '201' AS returnCode, 'Mode of travel already exists. Please check and try again.' AS returnMessage;                  
        END                
        ELSE                
        BEGIN                
            INSERT INTO MOT (MOT, IsActive, Operation, OperationBy)                
            VALUES (@MOT, @IsActive, 'Insert', @OperationBy)                
                         
   Set @LogID =  @@identity            
            -- Removed audit call here                
            SELECT '200' AS returnCode, 'New record added successfully.' AS returnMessage,  @LogID AS ID;                    
        END                
    END                
    ELSE IF @Action = 'U'                
    BEGIN                  
        IF NOT EXISTS (SELECT TOP 1 1 FROM MOT WHERE MOT = @MOT AND ID != @ID)                  
        BEGIN                  
            UPDATE MOT                
            SET MOT = isnull(@MOT,MOT) ,              
                IsActive = isnull(@IsActive,IsActive),                
                Operation = 'Update',                
                OperationBy = isnull(@OperationBy, OperationBy),               
                OperationOn = GETDATE()                
            WHERE ID = @ID                
                            
            -- Removed audit call here                
            SELECT '200' AS returnCode, 'Record updated successfully.' AS returnMessage, @ID AS ID;                  
        END                  
        ELSE                  
        BEGIN                  
            SELECT '201' AS returnCode, 'Mode of travel already exists. Please check and try again.' AS returnMessage;                  
        END                  
    END                  
    ELSE IF @Action = 'S'                
    BEGIN                    
        SELECT * FROM MOT WHERE (@ID IS NULL OR ID = 0 OR ID = @ID) ORDER by 1 DESC                
        --SELECT '200' AS returnCode, 'Data Fetched' AS returnMessage;                  
    END    
	 ELSE IF @Action = 'EX'                
    BEGIN                    
        SELECT MOT,CASE   
        WHEN IsActive = 1 THEN 'True'  
        WHEN IsActive = 0 THEN 'False'  
    END AS IsActive  FROM MOT WHERE (@ID IS NULL OR ID = 0 OR ID = @ID) ORDER by 1 DESC                
        --SELECT '200' AS returnCode, 'Data Fetched' AS returnMessage;                  
    END    
END 
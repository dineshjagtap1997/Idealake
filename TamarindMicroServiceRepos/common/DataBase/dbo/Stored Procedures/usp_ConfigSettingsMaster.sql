CREATE PROCEDURE [dbo].[usp_ConfigSettingsMaster]     
    @Action CHAR(1),    
    @ConfigSettingID INT = NULL,     
    @ConfigKey VARCHAR(100) = NULL,     
    @ConfigValue VARCHAR(100) = NULL,    
    @OperationBy uniqueidentifier = NULL    
    
AS    
BEGIN    
    SET NOCOUNT ON;    
        
    IF @Action = 'I' -- Insert Operation    
    BEGIN    
        IF EXISTS (SELECT ConfigKey FROM ConfigSettings WHERE UPPER(ConfigKey) = UPPER(@ConfigKey))    
        BEGIN    
            SELECT '201' AS returnCode, 'ConfigKey Name already exists!' AS returnMessage;    
        END    
        ELSE    
        BEGIN    
            INSERT INTO ConfigSettings (ConfigKey, ConfigValue, CreatedBy, CreatedDate)    
            VALUES (@ConfigKey, @ConfigValue, @OperationBy, GETDATE());    
                
            SELECT '200' AS returnCode, 'Data Inserted Successfully!' AS returnMessage;    
        END    
    END    
    ELSE IF @Action = 'U' -- Update Operation    
    BEGIN    
        IF NOT EXISTS (SELECT ConfigKey FROM ConfigSettings WHERE UPPER(ConfigKey) = UPPER(@ConfigKey) AND ConfigSettingID <> @ConfigSettingID)    
        BEGIN    
            UPDATE ConfigSettings    
            SET ConfigKey = @ConfigKey,    
                ConfigValue = @ConfigValue,    
            UpdatedBy = @OperationBy   
    ,UpdatedDate = GETDATE()    
            WHERE ConfigSettingID = @ConfigSettingID;    
                
   SELECT '200' AS returnCode, 'Data Updated Successfully!' AS returnMessage;    
       
        END    
        ELSE    
        BEGIN    
            SELECT '200' AS returnCode, 'ConfigKey Name already exists!' AS returnMessage;    
        END    
    END    
    ELSE IF @Action = 'S' -- Select Operation    
    BEGIN    
        SELECT ConfigSettingID, ConfigKey, ConfigValue, CreatedBy    
        FROM ConfigSettings    
  WHERE  (@ConfigSettingID IS NULL OR @ConfigSettingID = 0 OR ConfigSettingID = @ConfigSettingID)  
        ORDER BY ConfigSettingID ASC;    
                         --       SELECT '200' AS returnCode, 'Data Retrived' AS returnMessage;    
    END    
    ELSE -- Invalid Operation    
    BEGIN    
        SELECT '201' AS returnCode, 'Invalid Action Performed!' AS returnMessage;    
    END    
END 
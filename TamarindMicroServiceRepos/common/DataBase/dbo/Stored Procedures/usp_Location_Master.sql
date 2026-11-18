CREATE PROCEDURE [dbo].[usp_Location_Master]                
    @LocationCode VARCHAR(50),                
    @LocationValue VARCHAR(50),                
    @SequenceNo INT,                
    @IsActive  BIT,                 
    @OperationBy UNIQUEIDENTIFIER,           
    @Action CHAR(2) = '',          
    @Active BIT = NULL,          
    @LocationID INT = NULL          
AS           
BEGIN          
    -- Declare common return variables          
    DECLARE @ReturnCode NVARCHAR(3), @ReturnMessage NVARCHAR(MAX);          
 Declare @LogID int;      
          
    BEGIN TRY          
        IF @Action = 'I'          
        BEGIN                
            -- Check for duplicates          
            IF EXISTS(SELECT 1 FROM LocationMaster WHERE UPPER(LocationCode) = UPPER(@LocationCode))                
            BEGIN           
                SET @ReturnCode = '201';          
                SET @ReturnMessage = 'LandMark Name already exists. Please check and try again.';          
                SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;          
                RETURN;          
            END                
                 
            IF EXISTS(SELECT 1 FROM LocationMaster WHERE UPPER(LocationValue) = UPPER(@LocationValue))                
            BEGIN            
                SET @ReturnCode = '201';          
                SET @ReturnMessage = 'LandMark Name already exists. Please check and try again.';          
                SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;          
                RETURN;          
            END                
          
            IF EXISTS(SELECT 1 FROM LocationMaster WHERE SequenceNo = @SequenceNo)                
            BEGIN           
                SET @ReturnCode = '201';          
                SET @ReturnMessage = 'LandMark Name already exists. Please check and try again.';          
                SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;          
                RETURN;          
            END                
          
            -- Insert data into LocationMaster          
            DECLARE @MaxID INT;          
            --EXEC usp_InsertCustomCaption 'Location', 'Location', @LocationCode, @SequenceNo, @MaxID OUT;          
          
            INSERT INTO LocationMaster(LocationCode, LocationValue, SequenceNo, IsActive, Operation, OperationBy, OperationOn, OldID)                
            VALUES (UPPER(@LocationCode), @LocationValue, @SequenceNo, @IsActive, 'Insert', @OperationBy, GETDATE(), @MaxID);                
         
   SET @LogID = SCOPE_IDENTITY()      
            SET @ReturnCode = '200';          
            SET @ReturnMessage = 'New record added successfully.';          
            SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @LogID as ID;          
        END          
          
        ELSE IF @Action = 'U'          
        BEGIN              
            -- Check for duplicates during update          
            IF EXISTS(SELECT 1 FROM LocationMaster WHERE UPPER(LocationCode) = UPPER(@LocationCode) AND LocationID <> @LocationID)              
            BEGIN           
                SET @ReturnCode = '201';          
                SET @ReturnMessage = 'LandMark Name already exists. Please check and try again.';          
                SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;          
                RETURN;          
            END              
               
            IF EXISTS(SELECT 1 FROM LocationMaster WHERE UPPER(LocationValue) = UPPER(@LocationValue) AND LocationID <> @LocationID)              
            BEGIN            
                SET @ReturnCode = '201';          
                SET @ReturnMessage = 'LandMark Name already exists. Please check and try again.';          
                SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;          
    RETURN;          
            END              
          
            IF EXISTS(SELECT 1 FROM LocationMaster WHERE SequenceNo = @SequenceNo AND LocationID <> @LocationID)      
            BEGIN           
                SET @ReturnCode = '201';          
                SET @ReturnMessage = 'LandMark Name already exists. Please check and try again.';         
                SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;          
                RETURN;          
            END              
          
            -- Update data in LocationMaster          
            UPDATE LocationMaster           
            SET LocationCode = UPPER(@LocationCode),              
                LocationValue = @LocationValue,              
                SequenceNo  = @SequenceNo,              
                IsActive = @IsActive,              
                Operation = 'Update'              
              ,OperationBy = @OperationBy          
    ,OperationOn = GETDATE()            
            WHERE LocationID = @LocationID;              
          
            DECLARE @ID INT;          
            --SELECT @ID = OldID FROM LocationMaster WHERE LocationID = @LocationID;                 
            --EXEC usp_UpdateCustomCaption @LocationCode, @SequenceNo, @ID;          
          
            SET @ReturnCode = '200';          
            SET @ReturnMessage = 'Record updated successfully.';          
            SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @LocationID as ID;           
        END          
          
        ELSE IF @Action = 'S'          
        BEGIN              
            -- Select records based on the @Active parameter          
            IF @Active = 0            
            BEGIN            
                SELECT LocationID, LocationCode, LocationValue, SequenceNo, IsActive            
                FROM LocationMaster;            
            END            
            ELSE            
            BEGIN            
                SELECT LocationID, LocationCode, LocationValue, SequenceNo, IsActive            
                FROM LocationMaster           
                WHERE IsActive = 1;            
            END            
          
            --SET @ReturnCode = '200';          
            --SET @ReturnMessage = 'Data Retrieved Successfully!';          
            --SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;          
        END          
    ELSE IF @Action = 'EX'          
        BEGIN              
            -- Select records based on the @Active parameter          
            IF @Active = 0            
            BEGIN            
                SELECT  LocationCode, LocationValue,CASE   
        WHEN IsActive = 1 THEN 'True'  
        WHEN IsActive = 0 THEN 'False'  
    END AS IsActive             
                FROM LocationMaster;            
            END            
            ELSE            
            BEGIN            
                SELECT LocationCode, LocationValue,CASE   
        WHEN IsActive = 1 THEN 'True'  
        WHEN IsActive = 0 THEN 'False'  
    END AS IsActive             
                FROM LocationMaster           
                WHERE IsActive = 1;            
            END            
          
            --SET @ReturnCode = '200';          
            --SET @ReturnMessage = 'Data Retrieved Successfully!';          
            --SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;          
        END    
   
        ELSE          
        BEGIN          
            SET @ReturnCode = '400';          
            SET @ReturnMessage = 'Invalid Action!';          
            SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;          
        END          
    END TRY          
          
    BEGIN CATCH          
        -- Handle errors gracefully          
        SET @ReturnCode = '500';          
        SET @ReturnMessage = 'Something went wrong! Error: ' + ERROR_MESSAGE();          
        SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;          
    END CATCH          
END 
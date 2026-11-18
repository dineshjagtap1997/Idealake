CREATE PROCEDURE [dbo].[usp_Transfer_Master]                              
@TransferID INT = NULL,                              
@TransferCode VARCHAR(50) = '',                              
@TransferValue VARCHAR(500) = '',                              
@Sequence INT = NULL,                              
@IsActive BIT = NULL,                              
@OperationBy UNIQUEIDENTIFIER = NULL,                              
@Action CHAR(2) = ''                    
AS                     
BEGIN                    
    DECLARE @ReturnCode NVARCHAR(3), @ReturnMessage NVARCHAR(MAX);                    
                    
    IF @Action = 'I'                    
    BEGIN                    
        -- Check if the TransferCode or TransferValue already exists                    
        IF EXISTS(SELECT 1 FROM TransferMaster WHERE UPPER(TransferCode) = UPPER(@TransferCode))                    
        BEGIN                    
            SET @ReturnCode = '201';                    
            SET @ReturnMessage =  'Transfer Code already exists. Please check and try again.';                     
            SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;                    
            RETURN;                    
        END                    
        IF EXISTS(SELECT 1 FROM TransferMaster WHERE UPPER(TransferValue) = UPPER(@TransferValue))                    
        BEGIN                    
            SET @ReturnCode = '201';                    
            SET @ReturnMessage = 'Transfer Value already exists. Please check and try again.';                    
            SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;                    
            RETURN;                    
        END                    
        IF EXISTS(SELECT 1 FROM TransferMaster WHERE SequenceNo = @Sequence)                    
        BEGIN                    
            SET @ReturnCode = '201';                    
            SET @ReturnMessage = 'Sequence Number already exists. Please check and try again.';                    
            SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;                    
            RETURN;                    
        END                    
                    
        -- Insert the new transfer record                    
        INSERT INTO TransferMaster (TransferCode, TransferValue, SequenceNo, IsActive, Operation, OperationBy, OperationOn)                    
        VALUES (UPPER(@TransferCode), @TransferValue, @Sequence, @IsActive, 'Insert', @OperationBy, GETDATE());                    
                    
        -- Retrieve the newly inserted TransferID                    
        DECLARE @NewTransferID INT = SCOPE_IDENTITY();                    
                    
        -- Audit entry (if required)                    
        --EXEC usp_InsertCustomCaption 'Transfer', 'Transfer', @TransferCode, @Sequence, @NewTransferID;                    
                    
        SET @ReturnCode = '200';                    
        SET @ReturnMessage = 'New record added successfully.';                    
        SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @NewTransferID as ID;                    
    END                    
    ELSE IF @Action = 'U'                    
    BEGIN                    
        -- Check if the TransferCode or TransferValue exists with a different TransferID                    
        IF EXISTS(SELECT 1 FROM TransferMaster WHERE UPPER(TransferCode) = UPPER(@TransferCode) AND TransferID != @TransferID)                    
        BEGIN                    
            SET @ReturnCode = '201';                    
            SET @ReturnMessage = 'Transfer Code already exists. Please check and try again.';                    
            SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;                    
            RETURN;                    
        END                    
        IF EXISTS(SELECT 1 FROM TransferMaster WHERE UPPER(TransferValue) = UPPER(@TransferValue) AND TransferID != @TransferID)                    
        BEGIN                    
            SET @ReturnCode = '201';                    
            SET @ReturnMessage = 'Transfer Value already exists. Please check and try again.';        
            SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;                    
            RETURN;                    
        END                    
        IF EXISTS(SELECT 1 FROM TransferMaster WHERE SequenceNo = @Sequence AND TransferID != @TransferID)                    
      BEGIN                    
            SET @ReturnCode = '201';                    
            SET @ReturnMessage = 'Sequence Number already exists. Please check and try again.';                    
            SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;                    
            RETURN;                    
        END                    
                    
        -- Update the transfer record                    
        UPDATE TransferMaster                    
        SET TransferCode = UPPER(@TransferCode),                    
         TransferValue = @TransferValue,                    
            SequenceNo = @Sequence,                    
            IsActive = @IsActive,                    
            Operation = 'Update'                    
              ,UpdatedBy = @OperationBy                    
    ,UpdatedOn = GETDATE()                    
        WHERE TransferID = @TransferID;                    
                    
        -- Audit entry (if required)                    
        --EXEC usp_UpdateCustomCaption @TransferCode, @Sequence, @TransferID;                    
                    
        SET @ReturnCode = '200';                    
        SET @ReturnMessage = 'Record updated successfully.';                    
       SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @TransferID AS ID;                    
    END                    
    ELSE IF @Action = 'S'                    
    BEGIN                    
        -- Retrieve records based on IsActive filter                    
   SELECT TransferID, TransferCode, TransferValue, SequenceNo As Sequence , IsActive                    
           FROM TransferMaster                    
     WHERE (@TransferID IS NULL OR @TransferID = 0 OR TransferID=@TransferID)                     
              order by TransferID DESC        
        SET @ReturnCode = '200';                    
        SET @ReturnMessage = 'Success';                    
        --SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;                    
    END
	ELSE IF @Action='EX'
	 BEGIN                    
        -- Retrieve records based on IsActive filter                    
   SELECT TransferCode, TransferValue, SequenceNo As Sequence ,CASE   
        WHEN IsActive = 1 THEN 'True'  
        WHEN IsActive = 0 THEN 'False'  
    END AS IsActive                     
           FROM TransferMaster                    
     WHERE (@TransferID IS NULL OR @TransferID = 0 OR TransferID=@TransferID)                     
              order by TransferID DESC        
        SET @ReturnCode = '200';                    
        SET @ReturnMessage = 'Success';                    
        --SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;                    
    END   
    ELSE                    
    BEGIN                    
        -- Invalid action                    
        SET @ReturnCode = '201';                    
        SET @ReturnMessage = 'Invalid Action!';                    
        SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;                    
    END  
	      
END 
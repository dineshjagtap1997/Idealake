CREATE PROCEDURE [dbo].[usp_DestinationHeaderMaster]
(
    @Action CHAR(1),  -- 'I' for Insert, 'U' for Update, 'S' for Select
    @DestinationHeaderID INT = NULL,                    
    @DestinationHeaderCode VARCHAR(50) = NULL,   
    @DestinationHeader VARCHAR(50) = NULL,      
    @MISSequenceNo INT = NULL,        
    @IsActive BIT = NULL,                      
    @OperationBy UNIQUEIDENTIFIER = NULL                   
)
AS
BEGIN
    SET NOCOUNT ON;
	DECLARE @ReturnCode NVARCHAR(3), @ReturnMessage NVARCHAR(MAX);
	 Declare @LogID int; 

    -- Select Operation (S)
    IF (@Action = 'S')
    BEGIN
        IF(@IsActive IS NULL OR @IsActive = 0)
        BEGIN
            SELECT DestinationHeaderID, DestinationHeaderCode, DestinationHeader, MISSequenceNo, IsActive, Operation, OperationBy, OperationOn               
            FROM DestinationHeader              
            ORDER BY OperationOn DESC;              
        END
        ELSE
        BEGIN
            SELECT DestinationHeaderID, DestinationHeaderCode, DestinationHeader, MISSequenceNo, IsActive, Operation, OperationBy, OperationOn                          
            FROM DestinationHeader         
            WHERE IsActive = 1            
            ORDER BY OperationOn DESC;              
        END
    END

    -- Insert Operation (I)
    ELSE IF (@Action = 'I')
    BEGIN
        IF EXISTS(SELECT 1 FROM DestinationHeader     
                  WHERE UPPER(DestinationHeaderCode) = UPPER(@DestinationHeaderCode)    
                  AND UPPER(DestinationHeader) = UPPER(@DestinationHeader))                
        BEGIN                
            
			SET @ReturnCode = '201';
			SET @ReturnMessage = 'Destination Header already exists.';        
        END               
        ELSE              
        BEGIN              
            DECLARE @MaxID INT;   
            EXEC usp_InsertCustomCaption 'Destination Details header', 'Destination Details header', @DestinationHeaderCode, @MISSequenceNo, @MaxID OUT;

            INSERT INTO DestinationHeader              
            (DestinationHeaderCode, DestinationHeader, MISSequenceNo, IsActive, Operation, OperationBy, OperationOn, OldID)              
            VALUES (@DestinationHeaderCode, @DestinationHeader, @MISSequenceNo, @IsActive, 'Insert', @OperationBy, GETDATE(), @MaxID);

			SET @LogID = SCOPE_IDENTITY()
			SET @ReturnCode = '200';
			SET @ReturnMessage = 'Destination Header Inserted Successfully.';        
			--SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @LogID as ID;
	   END              
    END

    -- Update Operation (U)
    ELSE IF (@Action = 'U')
    BEGIN
        IF NOT EXISTS(SELECT 1 FROM DestinationHeader       
                      WHERE UPPER(DestinationHeaderCode) = UPPER(@DestinationHeaderCode)        
                      AND UPPER(DestinationHeader) = UPPER(@DestinationHeader)              
                      AND DestinationHeaderID <> @DestinationHeaderID)                        
        BEGIN                 
            DECLARE @ID INT;  
            SELECT @ID = OldID FROM DestinationHeader WHERE DestinationHeaderID = @DestinationHeaderID;
            EXEC usp_UpdateCustomCaption @DestinationHeaderCode, @MISSequenceNo, @ID;

            UPDATE DestinationHeader                        
            SET DestinationHeaderCode = @DestinationHeaderCode,       
                DestinationHeader = @DestinationHeader,       
                MISSequenceNo = @MISSequenceNo,                        
                IsActive = @IsActive,                  
                Operation = 'Update'                        
                ,UpdatedBy = @OperationBy
				,UpdatedOn = GETDATE()                       
            WHERE DestinationHeaderID = @DestinationHeaderID;
			SET @ReturnCode = '200';
			SET @ReturnMessage = 'Destination Header Updated Successfully.';        
		--	SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;
        END                        
        ELSE                  
        BEGIN        
		SET @ReturnCode = '201';
			SET @ReturnMessage = 'Destination Header already exists.';        
		--	SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;
        END                        
    END
    ELSE
    BEGIN
       SET @ReturnCode = '201';
			SET @ReturnMessage = 'Invalid Action Flag.';        
		--	SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;
    END
			SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @LogID AS ID;

END

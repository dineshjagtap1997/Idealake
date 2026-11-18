CREATE PROCEDURE [Invoice].[usp_InsertUpdateAgentRefNumberandVoid]
    @Action VARCHAR(1),
	@ID INT,
    @AgentRefPO VARCHAR(50),
	@isVoid BIT



AS
BEGIN
    SET NOCOUNT ON;

    DECLARE 
        @ReturnCode NVARCHAR(3),
        @ReturnMessage NVARCHAR(MAX),
        @LogID INT;

    IF @Action = 'A'
    BEGIN
        UPDATE [Invoice].Invoice
        SET
            AgentRefPO = @AgentRefPO,
			AgentRefPOCreatedDateTime = GETDATE()
		    WHERE ID = @ID;

        SET @LogID = @ID;
        SET @ReturnCode = '200';
        SET @ReturnMessage = ' record updated successfully';
    END

    ELSE IF @Action = 'V'
    BEGIN
        UPDATE [Invoice].Invoice
        SET
            isVoid = @isVoid
        WHERE ID = @ID;

        SET @LogID = @ID;
        SET @ReturnCode = '200';
        SET @ReturnMessage = ' record updated successfully';
    END

    ELSE
    BEGIN
        SET @ReturnCode = '400';
        SET @ReturnMessage = 'Invalid Action Code';
        SET @LogID = 0;
    END

    SELECT 
        @ReturnCode AS returnCode,
        @ReturnMessage AS returnMessage,
<<<<<<< HEAD
<<<<<<< HEAD
        @LogID AS ID;
=======
        @LogID AS ID,
		GETDATE() as LastSavedOn;
>>>>>>> dev
=======
        @LogID AS ID,
		GETDATE() as LastSavedOn;
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
END;

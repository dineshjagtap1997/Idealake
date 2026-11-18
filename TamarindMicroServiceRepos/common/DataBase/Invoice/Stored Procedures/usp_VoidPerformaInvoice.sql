


Create Procedure [Invoice].[usp_VoidPerformaInvoice]
(
   @Action VARCHAR(1),
   @ID INT,
   @YearCode VARCHAR(50)

)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE 
        @ReturnCode NVARCHAR(3),
        @ReturnMessage NVARCHAR(MAX),
        @RecordID BIGINT;

    IF @Action = 'U'
    BEGIN
	   UPDATE [Invoice].Invoice SET isVoid = 1  Where ID = @ID   

	    SET @RecordID = @ID 
        SET @ReturnCode = '200';
        SET @ReturnMessage = 'Record inserted successfully'; 
	END

	    SELECT 
        @ReturnCode AS ReturnCode,
        @ReturnMessage AS ReturnMessage,
        @RecordID AS ID; 


END

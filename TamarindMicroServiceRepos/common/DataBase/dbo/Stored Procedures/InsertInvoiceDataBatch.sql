CREATE PROCEDURE [dbo].[InsertInvoiceDataBatch]
    @InvoiceData IRNDataType READONLY -- Table-valued parameter
  
   
AS
BEGIN
DECLARE @ReturnCode NVARCHAR(3)
		,@ReturnMessage NVARCHAR(MAX);
    SET NOCOUNT ON;
    BEGIN TRY
        -- Start a transaction
        BEGIN TRANSACTION;

        -- Insert data into InvoiceData_IRN table
        INSERT INTO InvoiceData_IRN (
            INVOICENO,
            INVOICEDATE,
            Ackno,
            Ackdate,
            IRN,
            SignedQR,
            CreatedBy,
            CreatedDateTime,
            
            IsActive
        )
        SELECT 
            INVOICENO,
            INVOICEDATE,
            Ackno,
            Ackdate,
            IRN,
            SignedQR,
            CreatedBy,
            GETDATE() AS CreatedDateTime,
            
1
        FROM @InvoiceData;

        -- Commit the transaction
        COMMIT TRANSACTION;

        -- Set return code and message for success
        SET @ReturnCode = 200;
        SET @ReturnMessage = 'Data inserted successfully.';
    END TRY
    BEGIN CATCH
        -- Rollback transaction on error
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        -- Capture error details
        SET @ReturnCode = 201;
        SET @ReturnMessage = 'Error';
    END CATCH

	SELECT @ReturnCode AS returnCode
		,@ReturnMessage AS returnMessage
END;

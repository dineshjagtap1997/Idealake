Create PROCEDURE [Invoice].[usp_InsertUpdateInvoiceDetails_n]
    @Action VARCHAR(1),
    @ID BIGINT = NULL,
    @InvoiceID BIGINT,
    @Invoice_Desc VARCHAR(255),
    @SACID BIGINT,
    @Tax_ID INT,
    @TCS_ID INT,
    @TotalBasicAmount NUMERIC(18, 2),
    @Taxable_Amount NUMERIC(18, 2),
    @TotalTax_Amount NUMERIC(18, 2),
    @TotalInvoiceAmt NUMERIC(18, 2),
    @TCSAmount NUMERIC(18, 2),
    @YearCode INT,
    @CGST NUMERIC(18, 2),
    @SGST NUMERIC(18, 2),
    @UTGST NUMERIC(18, 2),
    @IGST NUMERIC(18, 2),
    @Invoice_Desc_ID INT,
    @CreatedBy UNIQUEIDENTIFIER,
    @AddendumJSON NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE 
        @ReturnCode NVARCHAR(10) = '200',
        @ReturnMessage NVARCHAR(255) = '',
        @RecordID BIGINT = 0;

    DECLARE 
        @OutAddendumCode NVARCHAR(10),
        @OutAddendumMsg NVARCHAR(255),
        @OutAddendumID BIGINT;

    BEGIN TRY
        BEGIN TRAN;

        IF @Action = 'I'
        BEGIN
            IF EXISTS (
                SELECT 1
                FROM [Invoice].InvoiceDetails
                WHERE Invoice_ID = @InvoiceID AND YearCode = @YearCode
            )
            BEGIN
                SET @ReturnCode = '409';
                SET @ReturnMessage = 'Duplicate record exists for the same Invoice_ID and YearCode.';
                ROLLBACK TRAN;
                GOTO FINAL_RETURN;
            END

            DECLARE 
                @InvoiceDate DATE,
                @CompanyID VARCHAR(3),
                @InvoiceTypeID INT,
                @InvoiceType VARCHAR(2),
                @GeneratedInvoiceNo VARCHAR(50);

            SELECT 
                @InvoiceDate = I.Invoice_Date,
                @CompanyID = I.compcode,
                @InvoiceTypeID = I.TypeOfDoc
            FROM [Invoice].[Invoice] I 
            WHERE I.ID = @InvoiceID;

            IF @InvoiceTypeID = 1 SET @InvoiceType = 'IN';
            IF @InvoiceTypeID = 2 SET @InvoiceType = 'PF';

            EXEC [Invoice].[usp_GenerateInvoiceNumber]
                @InvoiceDate = @InvoiceDate,
                @CompanyID = @CompanyID,
                @InvoiceType = @InvoiceType,
                @YearID = @YearCode,
                @GeneratedInvoiceNo = @GeneratedInvoiceNo OUTPUT;

            UPDATE [Invoice].Invoice 
            SET InvoiceNumber = @GeneratedInvoiceNo 
            WHERE ID = @InvoiceID;

            INSERT INTO [Invoice].InvoiceDetails (
                Invoice_ID, Invoice_Desc, SACID, Tax_ID,
                TotalBasicAmount, TotalTaxable_Amount, TotalTax_Amount, TotalInvoiceAmount,
                YearCode, CGST, SGST, UTGST, IGST, Invoice_Desc_ID, CreatedBy, CreatedDateTime
            )
            VALUES (
                @InvoiceID, @Invoice_Desc, @SACID, @Tax_ID,
                @TotalBasicAmount, @Taxable_Amount, @TotalTax_Amount, @TotalInvoiceAmt,
                @YearCode, @CGST, @SGST, @UTGST, @IGST, @Invoice_Desc_ID, @CreatedBy, GETDATE()
            );

            SET @RecordID = SCOPE_IDENTITY();
        END
        ELSE IF @Action = 'U'
        BEGIN
            UPDATE [Invoice].InvoiceDetails
            SET
                Invoice_ID = @InvoiceID,
                Invoice_Desc = @Invoice_Desc,
                SACID = @SACID,
                Tax_ID = @Tax_ID,
                TotalBasicAmount = @TotalBasicAmount,
                TotalTaxable_Amount = @Taxable_Amount,
                TotalTax_Amount = @TotalTax_Amount,
                TotalInvoiceAmount = @TotalInvoiceAmt,
                YearCode = @YearCode,
                CGST = @CGST,
                SGST = @SGST,
                UTGST = @UTGST,
                IGST = @IGST,
                Invoice_Desc_ID = @Invoice_Desc_ID,
                LastUpdatedBy = @CreatedBy,
                LastUpdateDateTime = GETDATE()
            WHERE ID = @ID;

            SET @RecordID = @ID;
        END
        ELSE
        BEGIN
            SET @ReturnCode = '400';
            SET @ReturnMessage = 'Invalid Action';
            ROLLBACK TRAN;
            GOTO FINAL_RETURN;
        END

        -- Call Addendum SP with OUTPUT parameters
        EXEC [Invoice].[usp_InsertUpdateAddendumWithDetails]
            @Action = @Action,
            @AddendumJSON = @AddendumJSON,
            @OutReturnCode = @OutAddendumCode OUTPUT,
            @OutReturnMessage = @OutAddendumMsg OUTPUT,
            @OutAddendumID = @OutAddendumID OUTPUT;

        IF @OutAddendumCode <> '200'
        BEGIN
            SET @ReturnCode = '400';
            SET @ReturnMessage = 'Error';
            SET @RecordID = 0;
            ROLLBACK TRAN;
            GOTO FINAL_RETURN;
        END

        SET @ReturnMessage = CASE 
                                WHEN @Action = 'I' THEN 'Record inserted successfully.'
                                WHEN @Action = 'U' THEN 'Record updated successfully.'
                             END;

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;

        SET @ReturnCode = '500';
        SET @ReturnMessage = ERROR_MESSAGE();
        SET @RecordID = 0;
		GOTO FINAL_RETURN; 
    END CATCH

FINAL_RETURN:
    SELECT 
        '200' AS returnCode,
        @ReturnMessage AS returnMessage,
        @RecordID AS ID;
END

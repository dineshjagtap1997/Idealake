
CREATE PROCEDURE [Invoice].[usp_InsertUpdateInvoiceDetails_bkup]
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
    @CreatedBy UNIQUEIDENTIFIER
    --@AddendumJSON NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN;

        DECLARE 
            @ReturnCode NVARCHAR(3),
            @ReturnMessage NVARCHAR(MAX),
            @RecordID BIGINT;

        DECLARE 
            @AddendumCode NVARCHAR(10),
            @AddendumMsg NVARCHAR(255),
            @AddendumID BIGINT;

        DECLARE @AddendumResult TABLE (
            returnCode NVARCHAR(10),
            returnMessage NVARCHAR(255),
            ID BIGINT
        );

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
                RETURN;
            END

            DECLARE @InvoiceDate DATE;
            DECLARE @CompanyID VARCHAR(3);
            DECLARE @InvoiceTypeID INT;
            DECLARE @InvoiceType VARCHAR(2);
            DECLARE @GeneratedInvoiceNo VARCHAR(50);

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
					Invoice_ID, Invoice_Desc, SACID, Tax_ID, TCSRateID, TCSAmount,
					TotalBasicAmount, TotalTaxable_Amount, TotalTax_Amount, TotalInvoiceAmount,
					YearCode, CGST, SGST, UTGST, IGST, Invoice_Desc_ID, CreatedBy, CreatedDateTime
				)
				VALUES (
					@InvoiceID, @Invoice_Desc, @SACID, @Tax_ID, @TCS_ID, @TCSAmount,
					@TotalBasicAmount, @Taxable_Amount, @TotalTax_Amount, @TotalInvoiceAmt,
					@YearCode, @CGST, @SGST, @UTGST, @IGST, @Invoice_Desc_ID, @CreatedBy, GETDATE()
				);

            SET @RecordID = SCOPE_IDENTITY();
				    SET @ReturnCode = '200';
					SET @ReturnMessage = CASE 
                                WHEN @Action = 'I' THEN 'Record inserted successfully.'
                             END;
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
				TCSRateID = @TCS_ID,
				TCSAmount = @TCSAmount,
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
            RETURN;
        END


		       -- Declare variables for AddendumNo generation
        DECLARE @GeneratedAddendumNo VARCHAR(50) = '';

        -- Get invoice details
        SELECT 
            @InvoiceDate = I.Invoice_Date,
            @CompanyID = I.compcode
        FROM [Invoice].[Invoice] I 
        WHERE I.ID = @InvoiceID;

        -- Generate Addendum number
        EXEC [Invoice].[usp_GenerateAddendumNumber]
            @InvoiceDate = @InvoiceDate,
            @CompanyID = @CompanyID,
            @AddendumType = 'AD',
            @GeneratedAddendumNo = @GeneratedAddendumNo OUTPUT; 

         UPDATE Addendum set Addendum.AddendumNo =  @GeneratedAddendumNo where Addendum.InvoiceID = @InvoiceID  
            
        -- Call Addendum Procedure
        --INSERT INTO @AddendumResult (returnCode, returnMessage, ID)
        --EXEC [Invoice].[usp_InsertUpdateAddendumWithDetails] 
        --    @Action = @Action,
        --    @AddendumJSON = @AddendumJSON;
        


	    --SET @ReturnCode = '200';
     --   SET @ReturnMessage = CASE 
     --                           WHEN @Action = 'I' THEN 'Record inserted successfully.'
     --                           WHEN @Action = 'U' THEN 'Record updated successfully.'
     --                        END;


        COMMIT TRAN;

        SELECT 
            @ReturnCode AS returnCode,
            @ReturnMessage AS returnMessage,
            @RecordID AS ID;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;

        DECLARE @ErrorMessage NVARCHAR(MAX), 
                @ErrorSeverity INT, 
                @ErrorState INT;

        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END

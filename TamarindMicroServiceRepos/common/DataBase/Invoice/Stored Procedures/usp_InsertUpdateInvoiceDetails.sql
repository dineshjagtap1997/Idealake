
<<<<<<< HEAD
<<<<<<< HEAD
=======

>>>>>>> dev
=======

>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
CREATE PROCEDURE [Invoice].[usp_InsertUpdateInvoiceDetails]
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
<<<<<<< HEAD
<<<<<<< HEAD
	@AddendumTotalAmount NUMERIC(18, 2) 
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
	@AddendumTotalAmount NUMERIC(18, 2), 
	@TaxableAmountDetail NUMERIC(18, 2) ,
    @TotalAmount NUMERIC(18, 2) ,
    @TaxAmount NUMERIC(18, 2) ,
    @BasicAmount NUMERIC(18, 2)
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN;

        DECLARE 
            @ReturnCode NVARCHAR(3),
            @ReturnMessage NVARCHAR(MAX),
            @RecordID BIGINT;

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
                SET @RecordID = 0;
                ROLLBACK TRAN;
                
<<<<<<< HEAD
<<<<<<< HEAD
                SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @RecordID AS ID;
=======
                SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @RecordID AS ID,GETDATE() as LastSavedOn;
>>>>>>> dev
=======
                SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @RecordID AS ID,GETDATE() as LastSavedOn;
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
                RETURN;
            END

            DECLARE @InvoiceDate DATE;
            DECLARE @CompanyID VARCHAR(3);
            DECLARE @InvoiceTypeID INT;
            DECLARE @InvoiceType VARCHAR(2);
            DECLARE @GeneratedInvoiceNo VARCHAR(50);
            DECLARE @GeneratedAddendumNo VARCHAR(50);

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
<<<<<<< HEAD
<<<<<<< HEAD
                YearCode, CGST, SGST, UTGST, IGST, Invoice_Desc_ID, CreatedBy, CreatedDateTime
=======
                YearCode, CGST, SGST, UTGST, IGST, Invoice_Desc_ID, CreatedBy, CreatedDateTime,
				TaxableAmountDetail , TotalAmount , TaxAmount, BasicAmount  
>>>>>>> dev
=======
                YearCode, CGST, SGST, UTGST, IGST, Invoice_Desc_ID, CreatedBy, CreatedDateTime,
				TaxableAmountDetail , TotalAmount , TaxAmount, BasicAmount  
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
            )
            VALUES (
                @InvoiceID, @Invoice_Desc, @SACID, @Tax_ID, @TCS_ID, @TCSAmount,
                @TotalBasicAmount, @Taxable_Amount, @TotalTax_Amount, @TotalInvoiceAmt,
<<<<<<< HEAD
<<<<<<< HEAD
                @YearCode, @CGST, @SGST, @UTGST, @IGST, @Invoice_Desc_ID, @CreatedBy, GETDATE()
=======
                @YearCode, @CGST, @SGST, @UTGST, @IGST, @Invoice_Desc_ID, @CreatedBy, GETDATE(),
				@TaxableAmountDetail , @TotalAmount , @TaxAmount, @BasicAmount  
>>>>>>> dev
=======
                @YearCode, @CGST, @SGST, @UTGST, @IGST, @Invoice_Desc_ID, @CreatedBy, GETDATE(),
				@TaxableAmountDetail , @TotalAmount , @TaxAmount, @BasicAmount  
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
            );

            SET @RecordID = SCOPE_IDENTITY();


            --  Generate Addendum No only on insert
            EXEC [Invoice].[usp_GenerateAddendumNumber]
                @InvoiceDate = @InvoiceDate,
                @CompanyID = @CompanyID,
                @AddendumType = 'AD',
                @GeneratedAddendumNo = @GeneratedAddendumNo OUTPUT;

            UPDATE [Invoice].Addendum 
            SET AddendumNo = @GeneratedAddendumNo 
            WHERE InvoiceID = @InvoiceID; 

			SET @ReturnCode = '200';
            SET @ReturnMessage = 'Record inserted successfully.';
        END
        ELSE IF @Action = 'U'
        BEGIN
<<<<<<< HEAD
<<<<<<< HEAD
=======
			
>>>>>>> dev
=======
			
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
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
<<<<<<< HEAD
<<<<<<< HEAD
                YearCode = @YearCode,
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
                --YearCode = @YearCode,
				YearCode = CASE 
					WHEN @YearCode IS NULL OR @YearCode = 0 THEN YearCode 
					ELSE @YearCode 
				END,
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
                CGST = @CGST,
                SGST = @SGST,
                UTGST = @UTGST,
                IGST = @IGST,
                TCSRateID = @TCS_ID,
                TCSAmount = @TCSAmount,
                Invoice_Desc_ID = @Invoice_Desc_ID,
                LastUpdatedBy = @CreatedBy,
<<<<<<< HEAD
<<<<<<< HEAD
                LastUpdateDateTime = GETDATE()
            WHERE ID = @ID;
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
                LastUpdateDateTime = GETDATE(),
				TaxableAmountDetail = @TaxableAmountDetail , 
				TotalAmount = @TotalAmount , 
				TaxAmount = @TaxAmount, 
				BasicAmount =@BasicAmount 
            WHERE Invoice_ID = @ID;
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

            SET @RecordID = @ID;
            SET @ReturnCode = '200';
            SET @ReturnMessage = 'Record updated successfully.';
        END
        ELSE
        BEGIN
            SET @ReturnCode = '400';
            SET @ReturnMessage = 'Invalid Action';
            SET @RecordID = 0;
            ROLLBACK TRAN;

<<<<<<< HEAD
<<<<<<< HEAD
            SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @RecordID AS ID;
=======
            SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @RecordID AS ID,GETDATE() as LastSavedOn;
>>>>>>> dev
=======
            SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @RecordID AS ID,GETDATE() as LastSavedOn;
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
            RETURN;
        END

        COMMIT TRAN;

 
<<<<<<< HEAD
<<<<<<< HEAD
        SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @RecordID AS ID;
=======
        SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @RecordID AS ID,GETDATE() as LastSavedOn;
>>>>>>> dev
=======
        SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @RecordID AS ID,GETDATE() as LastSavedOn;
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
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


        SELECT 
            '500' AS returnCode,
            @ErrorMessage AS returnMessage,
            ISNULL(@RecordID, 0) AS ID;
    END CATCH
END

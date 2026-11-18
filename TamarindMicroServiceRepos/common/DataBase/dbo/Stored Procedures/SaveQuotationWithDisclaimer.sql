CREATE PROCEDURE [dbo].[SaveQuotationWithDisclaimer]
    @Action CHAR(1) = 'I', -- 'I' for Insert, 'U' for Update
    @QuotationNo NVARCHAR(50) OUTPUT,
    @EnquiryID BIGINT,
    @Currency INT = 1,
    @TaxType INT = 0,
    @TaxonSale INT = 0,
    @ParentID INT = NULL,
    @DisclaimerText NVARCHAR(500) = NULL,
    @OperationBy UNIQUEIDENTIFIER,
    @QuoteStatus INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        IF @Action = 'I'
        BEGIN
            DECLARE @Year CHAR(2) = RIGHT(CAST(YEAR(GETDATE()) AS VARCHAR(4)), 2);
            DECLARE @NextSeq INT;
            DECLARE @InsertedQuotationID BIGINT;

            SELECT @NextSeq = ISNULL(MAX(CAST(SUBSTRING(QuotationNo, 3, 6) AS INT)), 0) + 1
            FROM Quotations
            WHERE QuotationNo LIKE 'Q' + @Year + '%' AND LEN(QuotationNo) = 9;

            SET @QuotationNo = 'Q' + @Year + RIGHT('000000' + CAST(@NextSeq AS VARCHAR(6)), 6);

            -- Insert into Quotations table
            INSERT INTO Quotations (
                QuotationNo, EnquiryID, Status, Currency, TaxType, TaxonSale,
                ParentID, Disclaimer, BookingID, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate
            )
            VALUES (
                @QuotationNo, @EnquiryID, @QuoteStatus, @Currency, @TaxType, @TaxonSale,
                @ParentID, @DisclaimerText, NULL, @OperationBy, GETDATE(), @OperationBy, GETDATE()
            );

            SET @InsertedQuotationID = SCOPE_IDENTITY(); -- Get the auto-incremented BIGINT ID

            -- Insert into Disclaimer table
            INSERT INTO Disclaimer (
                QuotationID, DisclaimerText, CreatedDate, ModifiedDate
            )
            VALUES (
                @InsertedQuotationID, @DisclaimerText, GETDATE(), GETDATE()
            );
        END
        ELSE IF @Action = 'U'
        BEGIN
            -- Update Quotations table
            UPDATE Quotations
            SET
                EnquiryID = @EnquiryID,
                Status = @QuoteStatus,
                Currency = @Currency,
                TaxType = @TaxType,
                TaxonSale = @TaxonSale,
                ParentID = @ParentID,
                Disclaimer = @DisclaimerText,
                UpdatedBy = @OperationBy,
                UpdatedDate = GETDATE()
            WHERE QuotationNo = @QuotationNo;

            DECLARE @QuotationIDToUpdate BIGINT;

            SELECT @QuotationIDToUpdate = QuotationID
            FROM Quotations
            WHERE QuotationNo = @QuotationNo;

            -- Update Disclaimer table
            UPDATE Disclaimer
            SET
                DisclaimerText = @DisclaimerText,
                ModifiedDate = GETDATE()
            WHERE QuotationID = @QuotationIDToUpdate;
        END

        COMMIT TRANSACTION;

        SELECT 
            '200' AS ReturnCode,
            CASE @Action
                WHEN 'I' THEN 'Quotation and disclaimer created successfully'
                WHEN 'U' THEN 'Quotation and disclaimer updated successfully'
            END AS ReturnMessage,
            @QuotationNo AS GeneratedQuotationID;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        SELECT 
            ERROR_NUMBER() AS ReturnCode,
            'Error: ' + ERROR_MESSAGE() AS ReturnMessage,
            NULL AS GeneratedQuotationID;
    END CATCH
END

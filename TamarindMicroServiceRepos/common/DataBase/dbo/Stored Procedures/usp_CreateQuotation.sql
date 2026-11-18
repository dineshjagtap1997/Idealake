CREATE   PROCEDURE [dbo].[usp_CreateQuotation]
    @Action VARCHAR(10), -- 'CREATE' or 'UPDATE'
    @EnquiryID BIGINT = NULL,
    @AgentID BIGINT = NULL,
    @AgentName NVARCHAR(100) = NULL,
    @Currency INT = NULL,
    @TaxType INT = NULL,
    @TaxonSale INT = NULL,
    @RateCardType INT = NULL,
    @Disclaimer NVARCHAR(500) = NULL,
    @VersionComment NVARCHAR(200) = NULL,
    @Status INT = NULL,
    @QuotationID NVARCHAR(50) OUTPUT,
    @OperationBy UNIQUEIDENTIFIER = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Year CHAR(2) = RIGHT(CAST(YEAR(GETDATE()) AS VARCHAR(4)), 2);
    DECLARE @NewQuotationNo NVARCHAR(50);
    DECLARE @ResultCode INT = 200;
    DECLARE @ResultMessage NVARCHAR(255) = '';

    BEGIN TRY
        BEGIN TRANSACTION;

        IF @Action = 'I'
        BEGIN
            -- Handle Enquiry
            IF ISNULL(@EnquiryID, 0) = 0
            BEGIN
                IF @AgentID IS NULL OR @AgentName IS NULL OR LTRIM(RTRIM(@AgentName)) = ''
                BEGIN
                    SET @ResultCode = 400;
                    SET @ResultMessage = 'AgentID and AgentName are required when EnquiryID is not provided or invalid';
                    GOTO ReturnResult;
                END

                INSERT INTO tbl_Enquiry (EQID, EnquiryID)
                EXEC [dbo].[usp_Enquiry]
                    @AgentID = @AgentID,
                    @AgentStaffName = @AgentName,
                    @OperationBy = @OperationBy,
                    @Action = 'I',
                    @IsDraft = 1;

                SELECT TOP 1 @EnquiryID = EQID FROM tbl_Enquiry ORDER BY EnquiryID DESC;

                IF @EnquiryID IS NULL
                BEGIN
                    SET @ResultCode = 500;
                    SET @ResultMessage = 'Failed to create Enquiry via usp_Enquiry';
                    GOTO ReturnResult;
                END
            END

            -- Generate QuotationNo like QYY000001
            SET @NewQuotationNo = 'Q' + @Year + RIGHT('000000' + CAST(
                ISNULL((SELECT MAX(CAST(SUBSTRING(QuotationNo, 3, 6) AS INT))
                        FROM QuotationMasterNew
                        WHERE QuotationNo LIKE 'Q' + @Year + '%' AND LEN(QuotationNo) = 9), 0) + 1 AS VARCHAR), 6);

            -- Insert new Quotation
            INSERT INTO QuotationMasterNew (
                QuotationNo, EnquiryID, Currency, TaxType, TaxonSale, Disclaimer,
                Status, CreatedBy, CreatedDate, OperationBy
            )
            VALUES (
                @NewQuotationNo, @EnquiryID, @Currency, @TaxType, @TaxonSale, @Disclaimer,
                0, 'System', GETDATE(), @OperationBy
            );

            SET @QuotationID = @NewQuotationNo;
            SET @ResultMessage = 'Quotation created successfully';
        END

        ELSE IF @Action = 'UPDATE'
        BEGIN
            IF @QuotationID IS NULL
            BEGIN
                SET @ResultCode = 400;
                SET @ResultMessage = 'QuotationID is required for update operation';
                GOTO ReturnResult;
            END

            UPDATE QuotationMasterNew
            SET 
                Disclaimer = ISNULL(@Disclaimer, Disclaimer),
                Status = ISNULL(@Status, Status),
                VersionComment = ISNULL(@VersionComment, VersionComment),
                ModifiedDate = GETDATE(),
                ModifiedBy = 'System'
            WHERE QuotationNo = @QuotationID;

            SET @ResultMessage = 'Quotation updated successfully';
        END

        COMMIT TRANSACTION;

        ReturnResult:
        SELECT 
            @ResultCode AS returnCode,
            @ResultMessage AS returnMessage,
            @QuotationID AS QuotationID,
            @EnquiryID AS EnquiryID;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_MESSAGE() AS ErrorMessage,
            '500' AS returnCode,
            'Error occurred in usp_CreateQuotation' AS returnMessage;
    END CATCH
END

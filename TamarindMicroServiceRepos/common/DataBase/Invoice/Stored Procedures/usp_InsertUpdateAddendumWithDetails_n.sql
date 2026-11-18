Create PROCEDURE [Invoice].[usp_InsertUpdateAddendumWithDetails_n]
    @Action CHAR(1),
    @AddendumJSON NVARCHAR(MAX),
    @OutReturnCode NVARCHAR(10) OUTPUT,
    @OutReturnMessage NVARCHAR(255) OUTPUT,
    @OutAddendumID BIGINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN;

        -- Extract Addendum fields from JSON
        DECLARE @AddendumNo VARCHAR(50)      = JSON_VALUE(@AddendumJSON, '$.AddendumNo'),
                @AddendumDate DATETIME       = JSON_VALUE(@AddendumJSON, '$.AddendumDate'),
                @Currency VARCHAR(10)        = JSON_VALUE(@AddendumJSON, '$.Currency'),
                @Amount NUMERIC(18,2)        = JSON_VALUE(@AddendumJSON, '$.Amount'),
                @InvoiceID BIGINT            = JSON_VALUE(@AddendumJSON, '$.InvoiceID'),
                @InvoiceDate DATETIME        = JSON_VALUE(@AddendumJSON, '$.InvoiceDate'),
                @CreatedDate DATETIME        = JSON_VALUE(@AddendumJSON, '$.CreatedDate'),
                @CreatedBy NCHAR(10)         = JSON_VALUE(@AddendumJSON, '$.CreatedBy'),
                @UpdatedDate DATETIME        = JSON_VALUE(@AddendumJSON, '$.UpdatedDate'),
                @UpdatedBy VARCHAR(50)       = JSON_VALUE(@AddendumJSON, '$.UpdatedBy'),
                @YearCode VARCHAR(10)        = JSON_VALUE(@AddendumJSON, '$.YearCode'),
                @Details NVARCHAR(MAX)       = JSON_QUERY(@AddendumJSON, '$.Details');

        DECLARE @AddendumID INT;

        IF @Action = 'I'
        BEGIN
            -- Check for duplicates
            IF EXISTS (
                SELECT 1
                FROM [Invoice].Addendum
                WHERE InvoiceID = @InvoiceID
            )
            BEGIN
                ROLLBACK TRAN;
                SET @OutReturnCode = '409';
                SET @OutReturnMessage = 'Duplicate record. Addendum already exists for the given InvoiceID.';
                SET @OutAddendumID = NULL;
                RETURN;
            END

            -- Declare variables for AddendumNo generation
            DECLARE @CompanyID VARCHAR(3),
                    @InvoiceType VARCHAR(2),
                    @GeneratedAddendumNo VARCHAR(50) = '';

            -- Get invoice details
            SELECT 
                @InvoiceDate = I.Invoice_Date,
                @InvoiceType = I.InvoiceType,
                @CompanyID = I.compcode
            FROM [Invoice].[Invoice] I 
            WHERE I.ID = @InvoiceID;

            -- Generate Addendum number
            EXEC [Invoice].[usp_GenerateAddendumNumber]
                @InvoiceDate = @InvoiceDate,
                @CompanyID = @CompanyID,
                @AddendumType = 'AD',
                @GeneratedAddendumNo = @GeneratedAddendumNo OUTPUT;

            -- Insert into Addendum table
            INSERT INTO [Invoice].Addendum (
                AddendumNo, AddendumDate, Currency, Amount, InvoiceID,
                InvoiceDate, CreatedDate, CreatedBy, UpdatedDate, UpdatedBy, YearCode
            )
            VALUES (
                @GeneratedAddendumNo, @AddendumDate, @Currency, @Amount, @InvoiceID,
                @InvoiceDate, @CreatedDate, @CreatedBy, @UpdatedDate, @UpdatedBy, @YearCode
            );

            SET @AddendumID = SCOPE_IDENTITY();

            -- Handle Addendum Details
            DECLARE @Desc VARCHAR(255), 
                    @ChildInvoiceID VARCHAR(50), 
                    @ChildCurrency VARCHAR(10),
                    @ChildAmount VARCHAR(50); 

            DECLARE cur CURSOR FOR
            SELECT *
            FROM OPENJSON(@Details)
            WITH (
                Description VARCHAR(255),
                InvoiceID VARCHAR(50),
                Currency VARCHAR(10),
                Amount VARCHAR(50)
            );

            OPEN cur;
            FETCH NEXT FROM cur 
            INTO @Desc, @ChildInvoiceID, @ChildCurrency, @ChildAmount;

            WHILE @@FETCH_STATUS = 0
            BEGIN
                INSERT INTO [Invoice].AddendumDetails (
                    AddendumID, Description, InvoiceID, Currency, Amount
                )
                VALUES (
                    @AddendumID, @Desc, @ChildInvoiceID, @ChildCurrency, @ChildAmount
                );

                FETCH NEXT FROM cur 
                INTO @Desc, @ChildInvoiceID, @ChildCurrency, @ChildAmount;
            END

            CLOSE cur;
            DEALLOCATE cur;

            COMMIT TRAN;

            SET @OutReturnCode = '200';
            SET @OutReturnMessage = 'Record inserted successfully.';
            SET @OutAddendumID = @AddendumID;
        END
        ELSE IF @Action = 'U'
        BEGIN
            -- Update logic placeholder
            COMMIT TRAN;
            SET @OutReturnCode = '202';
            SET @OutReturnMessage = 'Update operation successful (placeholder).';
            SET @OutAddendumID = NULL;
        END
        ELSE
        BEGIN
            ROLLBACK TRAN;
            SET @OutReturnCode = '400';
            SET @OutReturnMessage = 'Invalid Action specified.';
            SET @OutAddendumID = NULL;
            RETURN;
        END
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;

        SET @OutReturnCode = '500';
        SET @OutReturnMessage = ERROR_MESSAGE();
        SET @OutAddendumID = NULL;
    END CATCH
END

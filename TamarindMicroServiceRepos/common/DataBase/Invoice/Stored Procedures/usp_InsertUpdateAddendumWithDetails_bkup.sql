CREATE PROCEDURE [Invoice].[usp_InsertUpdateAddendumWithDetails_bkup]
    @Action CHAR(1),
    @AddendumJSON NVARCHAR(MAX)
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
            SELECT '409' AS returnCode, 
                   'Duplicate record. Addendum already exists for the given InvoiceID and AddendumNo.' AS returnMessage, 
                   NULL AS ID;
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

        PRINT '@GeneratedAddendumNo';
        PRINT @GeneratedAddendumNo;

        -- Insert into Addendum table
        INSERT INTO [Invoice].Addendum (
            AddendumNo, AddendumDate, Currency, Amount, InvoiceID,
            InvoiceDate, CreatedDate, CreatedBy, UpdatedDate, UpdatedBy, YearCode
        )
        VALUES (
            @GeneratedAddendumNo, @AddendumDate, @Currency, @Amount, @InvoiceID,
            @InvoiceDate, @CreatedDate, @CreatedBy, @UpdatedDate, @UpdatedBy, @YearCode
        );

        -- Get inserted AddendumID
        SET @AddendumID = SCOPE_IDENTITY();

        -- Declare variables for details
        DECLARE @Desc VARCHAR(255), 
                @ChildInvoiceID VARCHAR(50), 
                @ChildCurrency VARCHAR(10),
                @ChildAmount VARCHAR(50); 

        -- Cursor for details
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

        SELECT '200' AS returnCode, 
               'Record inserted successfully.' AS returnMessage, 
               @AddendumID AS ID;
    END
    ELSE IF @Action = 'U'
    BEGIN
        -- Placeholder for update logic
        PRINT 'UPDATE logic not implemented yet';
        COMMIT TRAN;
        SELECT '202' AS returnCode, 
               'Update ' AS returnMessage, 
               NULL AS ID;
    END
    ELSE
    BEGIN
        ROLLBACK TRAN;
        SELECT '400' AS returnCode, 
               'Invalid Action specified.' AS returnMessage, 
               NULL AS ID;
        RETURN;
    END
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
END CATCH;

   
END

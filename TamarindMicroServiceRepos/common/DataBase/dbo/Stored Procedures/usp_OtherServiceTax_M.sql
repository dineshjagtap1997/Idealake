CREATE PROCEDURE usp_OtherServiceTax_M
    @TaxID INT = NULL,
    @TaxCode VARCHAR(100),
    @TaxDescription VARCHAR(255),
    @TaxRate DECIMAL(10,2),
    @OperationBy UNIQUEIDENTIFIER,
    @Action CHAR(1)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @returnCode VARCHAR(10), @returnMessage VARCHAR(255);

    -- Normalize the TaxCode to ensure consistent comparison
    SET @TaxCode = UPPER(LTRIM(RTRIM(@TaxCode)));

    -- Check for duplicate TaxCode in both Insert and Update actions
    IF (@Action = 'I' OR @Action = 'U')
    BEGIN
        -- For Update, exclude current TaxID from the check
        DECLARE @ExistingCount INT;
        SELECT @ExistingCount = COUNT(*)
        FROM OtherServiceTax
        WHERE UPPER(LTRIM(RTRIM(TaxCode))) = @TaxCode
          AND (@Action = 'I' OR TaxID <> @TaxID);

        IF @ExistingCount > 0
        BEGIN
            SET @returnCode = '201';
            SET @returnMessage = 'Duplicate Tax Code detected. Operation aborted.';
            SELECT @returnCode AS returnCode, @returnMessage AS returnMessage, @TaxID AS ID;
            RETURN;
        END
    END

    IF @Action = 'I'
    BEGIN
        BEGIN TRY
            INSERT INTO OtherServiceTax (
                TaxCode, TaxDescription, TaxRate, CreatedBy, CreatedOn
            )
            VALUES (
                @TaxCode, @TaxDescription, @TaxRate, @OperationBy, GETDATE()
            );

            SET @TaxID = SCOPE_IDENTITY();
            SET @returnCode = '200';
            SET @returnMessage = 'Tax record inserted successfully.';
        END TRY
        BEGIN CATCH
            SET @returnCode = '500';
            SET @returnMessage = ERROR_MESSAGE();
        END CATCH
    END
    ELSE IF @Action = 'U'
    BEGIN
        BEGIN TRY
            UPDATE OtherServiceTax
            SET TaxCode = @TaxCode,
                TaxDescription = @TaxDescription,
                TaxRate = @TaxRate,
                UpdatedBy = @OperationBy,
                UpdatedOn = GETDATE()
            WHERE TaxID = @TaxID;

            SET @returnCode = '200';
            SET @returnMessage = 'Tax record updated successfully.';
        END TRY
        BEGIN CATCH
            SET @returnCode = '500';
            SET @returnMessage = ERROR_MESSAGE();
        END CATCH
    END

    SELECT @returnCode AS returnCode, @returnMessage AS returnMessage, @TaxID AS ID;
END
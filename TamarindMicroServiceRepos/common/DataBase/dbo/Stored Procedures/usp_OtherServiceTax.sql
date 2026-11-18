CREATE PROCEDURE [dbo].[usp_OtherServiceTax] 
    @TaxID INT = NULL,
    @TaxCode VARCHAR(50) = NULL,
    @TaxDescription VARCHAR(200) = NULL,
    @TaxRate DECIMAL(18, 5) = NULL,
    @Action CHAR(2) = '',
    @OperationBy UNIQUEIDENTIFIER = NULL
AS
BEGIN
    IF @Action = 'I'
    BEGIN
        -- Check if the tax already exists
        IF EXISTS (
            SELECT TaxCode
            FROM OtherServiceTax
            WHERE LTRIM(UPPER(TaxCode)) = LTRIM(UPPER(@TaxCode))
        )
        BEGIN
            SELECT '201' AS returnCode, 'This tax code already exists. Please check and try again.' AS returnMessage
        END
        ELSE
        BEGIN
            -- Insert new tax record
            INSERT INTO OtherServiceTax (TaxCode, TaxDescription, TaxRate, CreatedBy, CreatedOn)
            VALUES (@TaxCode, @TaxDescription, @TaxRate, @OperationBy, GETDATE())

			set @TaxID = SCOPE_IDENTITY()
            SELECT '200' AS returnCode, 'New tax record added successfully.' AS returnMessage, @TaxID AS ID;
        END
    END
    ELSE IF @Action = 'U'
    BEGIN
        -- Check if the tax exists and is not the same record
        IF EXISTS (
            SELECT TaxCode
            FROM OtherServiceTax
            WHERE LTRIM(UPPER(TaxCode)) = LTRIM(UPPER(@TaxCode))
            AND TaxID <> @TaxID
        )
        BEGIN
            SELECT '201' AS returnCode, 'This tax code already exists. Please check and try again.' AS returnMessage
        END
        ELSE
        BEGIN
            -- Update the existing tax record
            UPDATE OtherServiceTax
            SET TaxDescription = @TaxDescription,
                TaxRate = @TaxRate,
                UpdatedBy = @OperationBy,
                UpdatedOn = GETDATE()
            WHERE TaxID = @TaxID

            SELECT '200' AS returnCode, 'Tax record updated successfully.' AS returnMessage, @TaxID AS ID;
        END
    END
    ELSE IF @Action = 'S'
    BEGIN
        -- Select and return data
        SELECT TaxID, TaxCode, TaxDescription, TaxRate
        FROM OtherServiceTax
        WHERE TaxCode LIKE '%' + @TaxCode + '%'
    END
    ELSE
    BEGIN
        -- Handle invalid action
        SELECT '400' AS returnCode, 'Invalid action specified.' AS returnMessage
    END
END

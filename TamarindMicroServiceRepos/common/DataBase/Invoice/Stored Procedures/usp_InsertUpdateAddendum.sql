				
CREATE PROCEDURE [Invoice].[usp_InsertUpdateAddendum]
    @Action VARCHAR(1),
    @ID BIGINT = NULL,               -- Used for update/delete
    @InvoiceID INT,
    @Description VARCHAR(100),
    @Amount DECIMAL(18,2),
    @CreatedBy UNIQUEIDENTIFIER,
    @YearCode INT  
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ReturnCode VARCHAR(10),
            @ReturnMessage VARCHAR(100),
            @LogID INT,
            @AddendumID BIGINT;

    BEGIN TRY
        IF @Action = 'I'
        BEGIN
            -- Check if Addendum exists for InvoiceID
            SELECT @AddendumID = AddendumID
            FROM [Invoice].[Addendum]
            WHERE InvoiceID = @InvoiceID;

            IF @AddendumID IS NULL
            BEGIN
                -- Insert new Addendum
                INSERT INTO [Invoice].[Addendum]
                (
                    [Amount],
                    [InvoiceID],
                    [CreatedBy],
                    [YearCode]
                )
                VALUES
                (
                    @Amount,
                    @InvoiceID,
                    @CreatedBy,
                    @YearCode
                );

                SET @AddendumID = SCOPE_IDENTITY();
            END

            SET @LogID = @AddendumID;

            -- Insert into AddendumDetails
            INSERT INTO [Invoice].[AddendumDetails]
            (
                [AddendumID],
                [Description],
                [InvoiceID],
                [Currency],
                [Amount],
                [CreatedDate],
                [YearCode]
            )
            VALUES
            (
                @AddendumID,
                @Description,
                @InvoiceID,
                NULL,
                @Amount,
                GETDATE(),
                @YearCode
            );

            SET @ReturnCode = '200';
            SET @ReturnMessage = 'Addendum/Details inserted successfully.';
        END
        ELSE IF @Action = 'U'
        BEGIN
            IF @ID IS NULL
            BEGIN
                SET @ReturnCode = '400';
                SET @ReturnMessage = 'ID must be provided for update.';
                SET @LogID = 0;
            END
            ELSE
            BEGIN
                -- Update Addendum
                UPDATE [Invoice].[Addendum]
                SET 
                    [Amount] = @Amount,
                    [YearCode] = @YearCode
                WHERE AddendumID = (Select TOP 1 AddendumID  FROM  Invoice.AddendumDetails Where ID = @ID  )  and InvoiceID = @InvoiceID;

                -- Update AddendumDetails
                UPDATE AD
                SET
                    AD.Description = @Description,
                    AD.Amount = @Amount,
                    AD.YearCode = @YearCode,
                    AD.UpdatedDate = GETDATE()
                FROM [Invoice].[AddendumDetails] AD
                WHERE AD.ID = @ID AND  InvoiceID = @InvoiceID;

                SET @ReturnCode = '200';
                SET @ReturnMessage = 'Addendum updated successfully.';
                SET @LogID = @ID;
            END
        END
        ELSE IF @Action = 'D'
        BEGIN
            IF @ID IS NULL
            BEGIN
                SET @ReturnCode = '400';
                SET @ReturnMessage = 'ID must be provided for delete.';
                SET @LogID = 0;
            END
            ELSE
            BEGIN
                -- Get AddendumID of the Detail to delete
                SELECT @AddendumID = AddendumID
                FROM [Invoice].[AddendumDetails]
                WHERE ID = @ID;

                -- Delete from AddendumDetails
                DELETE FROM [Invoice].[AddendumDetails]
                WHERE ID = @ID;

                -- Check remaining details for same AddendumID
                IF NOT EXISTS (
                    SELECT 1 FROM [Invoice].[AddendumDetails]
                    WHERE AddendumID = @AddendumID
                )
                BEGIN
                    -- Delete from Addendum if no more details exist
                    DELETE FROM [Invoice].[Addendum]
                    WHERE AddendumID = @AddendumID;
                END

                SET @ReturnCode = '200';
                SET @ReturnMessage = 'Record deleted successfully.';
                SET @LogID = @ID;
            END
        END
        ELSE
        BEGIN
            SET @ReturnCode = '400';
            SET @ReturnMessage = 'Invalid Action specified.';
            SET @LogID = ISNULL(@ID, 0);
        END
    END TRY
    BEGIN CATCH
        SET @ReturnCode = '500';
        SET @ReturnMessage = ERROR_MESSAGE();
        SET @LogID = 0;
    END CATCH

    -- Final output
    SELECT @ReturnCode AS ReturnCode, @ReturnMessage AS ReturnMessage, @LogID AS ID;
END

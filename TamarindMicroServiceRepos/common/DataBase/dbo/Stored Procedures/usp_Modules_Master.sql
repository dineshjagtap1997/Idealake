CREATE PROCEDURE [dbo].[usp_Modules_Master]
    @Action VARCHAR(10),   -- Action: 'Create', 'Read', 'Update', or 'Delete'
    @ModuleID INT = NULL,  -- ModuleID (used in Update/Delete)
    @ModuleName VARCHAR(100) = NULL, 
    @DisplayOrder INT = NULL,
    @ParentMenuID INT = NULL,
    @Level INT = NULL,
    @Type VARCHAR(10) = NULL,
    @CreatedBy INT = NULL,
    @CreatedDateTime DATETIME = NULL,
    @UpdatedBy INT = NULL,
    @UpdatedDateTime DATETIME = NULL,
    @IsActive BIT = NULL,
	@Link NVARCHAR(MAX)= NULL,
	@visibleSection BIT = 0
AS
BEGIN
    SET NOCOUNT ON;

    -- Initialize return variables
    DECLARE @ReturnCode VARCHAR(3);
    DECLARE @ReturnMessage VARCHAR(100);

    BEGIN TRY
        -- CREATE
        IF @Action = 'I'
        BEGIN
            INSERT INTO [dbo].[Modules]
            (
                [ModuleName],
                [DisplayOrder],
                [ParentMenuID],
                [Level],
                [Type],
                [CreatedBy],
                [CreatedDateTime],
                [IsActive],
				[Link],
				[visibleSection]
            )
            VALUES
            (
                @ModuleName,
                @DisplayOrder,
                @ParentMenuID,
                @Level,
                @Type,
                @CreatedBy,
                 GETDATE(),
                @IsActive,
				@Link,
				@visibleSection
            );
            
            SET @ReturnCode = '200';
            SET @ReturnMessage = 'Data Created Successfully';
        END

        -- READ
        IF @Action = 'S'
        BEGIN
            -- Fetch modules based on ModuleID (if provided), else return all records
            IF @ModuleID IS NULL OR @ModuleID = 0
            BEGIN
                -- Return all modules if ModuleID is NULL or 0
                SELECT 
                    ModuleID,
                    ModuleName,
                    DisplayOrder,
                    Level,
                    Type,
                    ParentMenuID,
					Link,
					visibleSection
                FROM Modules
                WHERE IsActive = 1
                ORDER BY ParentMenuID, DisplayOrder;
            END
            ELSE
            BEGIN
                -- Return specific module based on provided ModuleID
                SELECT 
                    ModuleID,
                    ModuleName,
                    DisplayOrder,
                    Level,
                    Type,
                    ParentMenuID,
					Link,
					visibleSection
                FROM Modules
                WHERE ModuleID = @ModuleID
                  AND isActive = 1
                ORDER BY ParentMenuID, DisplayOrder;
            END

            SET @ReturnCode = '200';
            SET @ReturnMessage = 'Data Retrieved Successfully';
        END

        -- UPDATE
        IF @Action = 'U'
        BEGIN
            UPDATE [dbo].[Modules]
            SET 
                [ModuleName] = @ModuleName,
                [DisplayOrder] = @DisplayOrder,
                [ParentMenuID] = @ParentMenuID,
                [Level] = @Level,
                [Type] = @Type,
                [UpdatedBy] = @UpdatedBy,
                [UpdatedDateTime] = GETDATE(),
                [IsActive] = @IsActive,
				[Link]= @Link,
				[visibleSection]= @visibleSection
            WHERE [ModuleID] = @ModuleID;

            SET @ReturnCode = '200';
            SET @ReturnMessage = 'Data Updated Successfully';
        END

        -- DELETE (Soft Delete)
        IF @Action = 'D'
        BEGIN
            delete [dbo].[Modules]
            -- Soft delete by marking as inactive
            WHERE [ModuleID] = @ModuleID;

            SET @ReturnCode = '200';
            SET @ReturnMessage = 'Data Deleted Successfully';
        END

    END TRY
    BEGIN CATCH
        -- Catch all errors and return a generic error message
        SET @ReturnCode = '201';
        SET @ReturnMessage = 'Error occurred while processing the data';
    END CATCH

    -- Return metadata
    SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;
END;

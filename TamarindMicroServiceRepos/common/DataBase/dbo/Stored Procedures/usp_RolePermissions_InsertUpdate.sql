CREATE PROCEDURE [dbo].[usp_RolePermissions_InsertUpdate]
    @Action VARCHAR(10),  -- Action: 'I' (Insert), 'U' (Update)
    @CreatedBy INT = NULL,  -- CreatedBy or UpdatedBy
    @IsActive BIT = NULL,  -- IsActive
    @RolePermissions dbo.RolePermissionsType READONLY -- TVP for batch insert and batch update
AS
BEGIN
    DECLARE @ReturnCode NVARCHAR(3),
            @ReturnMessage NVARCHAR(MAX);

    BEGIN TRY
        -- Action: 'I' for Batch Insert or Update based on RolePermissionID
        IF @Action = 'I'
        BEGIN
            -- Insert or Update based on RolePermissionID
            MERGE INTO [dbo].[RolePermissions] AS rp
            USING @RolePermissions AS r
            ON rp.RolePermissionID = r.RolePermissionID
            WHEN MATCHED AND (r.RolePermissionID IS NOT NULL AND r.RolePermissionID <> 0) THEN
                UPDATE
                SET 
                    rp.RoleId = r.RoleId,
                    rp.ModuleID = r.ModuleId,
                    rp.CanView = r.CanView,
                    rp.CanEdit = r.CanEdit,
                    rp.CanAdd = r.CanAdd,
                    rp.CanExport = r.CanExport,
                    rp.CanDelete = r.CanDelete,
                    rp.CanPrint = r.CanPrint,
                    rp.CanUndoXO = r.CanUndoXO,
                    rp.CanReassignTo = r.CanReassignTo,
                    rp.CanViewAllFiles = r.CanViewAllFiles,
                    rp.CanViewAllFilesReadOnly = r.CanViewAllFilesReadOnly,
                    rp.UpdatedBy = @CreatedBy,
                    rp.UpdatedDateTime = GETDATE(),
                    rp.IsActive = r.IsActive
            WHEN NOT MATCHED AND (r.RolePermissionID IS NULL OR r.RolePermissionID = 0) THEN
                INSERT
                (
                    [RoleId],
                    [ModuleID],
                    [CanView],
                    [CanEdit],
                    [CanAdd],
                    [CanExport],
                    [CanDelete],
                    [CanPrint],
                    [CanUndoXO],
                    [CanReassignTo],
                    [CanViewAllFiles],
                    [CanViewAllFilesReadOnly],
                    [CreatedBy],
                    [CreatedDateTime],
                    [IsActive]
                )
                VALUES
                (
                    r.RoleId,
                    r.ModuleId,
                    r.CanView,
                    r.CanEdit,
                    r.CanAdd,
                    r.CanExport,
                    r.CanDelete,
                    r.CanPrint,
                    r.CanUndoXO,
                    r.CanReassignTo,
                    r.CanViewAllFiles,
                    r.CanViewAllFilesReadOnly,
                    @CreatedBy,  -- Common CreatedBy for all
                    GETDATE(),   -- CreatedDateTime
                    r.IsActive    -- Common IsActive for all
                );

            SET @ReturnCode = 200;
            SET @ReturnMessage = 'Permissions updated successfully';
        END

        -- Action: 'U' for Batch Update
        IF @Action = 'U'
        BEGIN
            -- Update multiple records at once using TVP
            UPDATE rp
            SET 
                rp.RoleId = r.RoleId,
                rp.ModuleID = r.ModuleId,
                rp.CanView = r.CanView,
                rp.CanEdit = r.CanEdit,
                rp.CanAdd = r.CanAdd,
                rp.CanExport = r.CanExport,
                rp.CanDelete = r.CanDelete,
                rp.CanPrint = r.CanPrint,
                rp.CanUndoXO = r.CanUndoXO,
                rp.CanReassignTo = r.CanReassignTo,
                rp.CanViewAllFiles = r.CanViewAllFiles,
                rp.CanViewAllFilesReadOnly = r.CanViewAllFilesReadOnly,
                rp.UpdatedBy = @CreatedBy,
                rp.UpdatedDateTime = GETDATE(),
                rp.IsActive =r.IsActive
            FROM [dbo].[RolePermissions] rp
            INNER JOIN @RolePermissions r ON rp.RolePermissionID = r.RolePermissionID;

            SET @ReturnCode = 200;
            SET @ReturnMessage = 'Permissions updated successfully';
        END
    END TRY
    BEGIN CATCH
        SET @ReturnCode = 500;
        SET @ReturnMessage = ERROR_MESSAGE(); 
    END CATCH

    SELECT @ReturnCode AS returnCode,
           @ReturnMessage AS returnMessage;
END;

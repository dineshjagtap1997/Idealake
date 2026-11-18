CREATE PROCEDURE [dbo].[usp_RolePermissions_Master]
    @Action VARCHAR(10),  -- Action: 'Create', 'Read', 'Update', 'Delete', 'BatchInsert', 'BatchUpdate'
    @RolePermissionID INT = NULL,  -- RolePermissionID (used in Update/Delete)
    @RoleId INT = NULL,  -- RoleId
    --@ModuleId INT = NULL,  -- ModuleId
    --@CanView BIT = NULL,  -- CanView
    --@CanEdit BIT = NULL,  -- CanEdit
    --@CanAdd BIT = NULL,   -- CanAdd
    --@CanExport BIT = NULL,  -- CanExport
    --@CanDelete BIT = NULL,  -- CanDelete
    --@CanPrint BIT = NULL,  -- CanPrint
    --@CanUndoXO BIT = NULL,  -- CanUndoXO
    --@CanReassignTo BIT = NULL,  -- CanReassignTo
    --@CanViewAllFiles BIT = NULL,  -- CanViewAllFiles
    --@CanViewAllFilesReadOnly BIT = NULL,  -- CanViewAllFilesReadOnly
    @CreatedBy INT = NULL,  -- CreatedBy
   
    @IsActive BIT = NULL,  -- IsActive
    @RolePermissions dbo.RolePermissionsType READONLY -- TVP for batch insert and batch update
AS
BEGIN
    DECLARE @ReturnCode NVARCHAR(3)
           ,@ReturnMessage NVARCHAR(MAX);

    BEGIN TRY
        -- Action: 'BatchInsert' for inserting multiple permissions at once
        IF @Action = 'I'
        BEGIN
            -- Insert multiple records at once using TVP
            INSERT INTO [dbo].[RolePermissions]
            (
                [RoleId],
                [ModuleId],
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
            SELECT 
                RoleId,
                ModuleId,
                CanView,
                CanEdit,
                CanAdd,
                CanExport,
                CanDelete,
                CanPrint,
                CanUndoXO,
                CanReassignTo,
                CanViewAllFiles,
               CanViewAllFilesReadOnly,
                @CreatedBy,  -- Common CreatedBy for all
                GETDATE(),   -- CreatedDateTime
                @IsActive    -- Common IsActive for all
            FROM @RolePermissions;

            SET @ReturnCode = 200;
            SET @ReturnMessage = 'Role Permissions Batch Inserted Successfully';
        END

        -- Action: 'BatchUpdate' for updating multiple permissions at once
        IF @Action = 'U'
        BEGIN
            -- Update multiple records at once using TVP
            UPDATE rp
            SET 
                rp.RoleId = r.RoleId,
                rp.ModuleId = r.ModuleId,
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
                rp.IsActive = @IsActive
            FROM [dbo].[RolePermissions] rp
            INNER JOIN @RolePermissions r ON rp.RolePermissionID = r.RolePermissionID;

            SET @ReturnCode = 200;
            SET @ReturnMessage = 'Role Permissions Batch Updated Successfully';
        END

       

        -- Action: 'S' (Select based on RoleId)
        IF @Action = 'S'
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM [dbo].[RolePermissions] WHERE RoleId = @RoleId)
            BEGIN
                SET @ReturnCode = 202;
                SET @ReturnMessage = 'RoleId does not exist';
                RETURN;
            END

            SELECT 
                m.ModuleID,
                m.ModuleName,
                m.ParentMenuID,
                m.Level,
                m.Type,
                rp.CanView,
                rp.CanEdit,
                rp.CanAdd,
                rp.CanExport,
                rp.CanDelete,
                rp.CanPrint,
                rp.CanUndoXO,
                rp.CanReassignTo,
                rp.CanViewAllFiles,
                rp.CanViewAllFilesReadOnly
            FROM [dbo].[Modules] m
            LEFT JOIN [dbo].[RolePermissions] rp ON rp.ModuleId = m.ModuleID
            WHERE rp.RoleId = @RoleId AND m.IsActive = 1
            ORDER BY m.ParentMenuID, m.DisplayOrder;

            SET @ReturnCode = 200;
            SET @ReturnMessage = 'Role Permissions Retrieved Successfully';
        END

        

        
        

    END TRY
    BEGIN CATCH
        SET @ReturnCode = 500;
        SET @ReturnMessage = ERROR_MESSAGE(); 
    END CATCH

    SELECT @ReturnCode AS returnCode,
           @ReturnMessage AS returnMessage;
END;

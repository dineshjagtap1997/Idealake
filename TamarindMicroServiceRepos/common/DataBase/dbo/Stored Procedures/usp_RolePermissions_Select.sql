CREATE PROCEDURE [dbo].[usp_RolePermissions_Select]
    @RoleId INT  -- RoleId
AS
BEGIN
    DECLARE @ReturnCode NVARCHAR(3),
            @ReturnMessage NVARCHAR(MAX);

    BEGIN TRY
        -- Check if the RoleId exists
        --IF NOT EXISTS (SELECT 1 FROM [dbo].[RolePermissions] WHERE RoleId = @RoleId)
        --BEGIN
        --    SET @ReturnCode = 202;
        --    SET @ReturnMessage = 'RoleId does not exist';
        --    RETURN;
        --END

        -- Select the role permissions based on RoleId
        SELECT 
		RolePermissionID,
		RoleId,
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
            rp.CanViewAllFilesReadOnly,
			rp.IsActive
        FROM [dbo].[Modules] m
        --LEFT 
		JOIN [dbo].[RolePermissions] rp ON rp.ModuleID = m.ModuleID
        WHERE 
		 (rp.RoleId = @RoleId OR @RoleId IS NULL) and
		m.IsActive = 1
        ORDER BY m.ParentMenuID, m.DisplayOrder;

        SET @ReturnCode = 200;
        SET @ReturnMessage = 'Role Permissions Retrieved Successfully';
    END TRY
    BEGIN CATCH
        SET @ReturnCode = 500;
        SET @ReturnMessage = ERROR_MESSAGE(); 
    END CATCH

    SELECT @ReturnCode AS returnCode,
           @ReturnMessage AS returnMessage;
END;

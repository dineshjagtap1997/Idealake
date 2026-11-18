CREATE PROCEDURE [dbo].[usp_GetUserPermissions]
    @UserId int  -- Input: UserId
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Fetch modules and permissions based on UserId
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
        FROM [dbo].[UsersInRoles] u
        JOIN [dbo].[RolePermissions] rp ON rp.RoleId = u.RoleId  -- Join RolePermissions on RoleId
        JOIN [dbo].[Modules] m ON m.ModuleID = rp.ModuleId       -- Join Modules on ModuleId
        WHERE u.UserId = @UserId AND m.IsActive = 1              -- Filter by UserId and active modules
        ORDER BY m.ParentMenuID, m.DisplayOrder;

        -- Return success metadata
        SELECT 
            '200' AS ReturnCode,
            'Data retrieved successfully' AS ReturnMessage;
    END TRY
    BEGIN CATCH
        -- Return error metadata
        SELECT 
            ERROR_NUMBER() AS ErrorCode,
            ERROR_MESSAGE() AS ErrorMessage;
    END CATCH

END;

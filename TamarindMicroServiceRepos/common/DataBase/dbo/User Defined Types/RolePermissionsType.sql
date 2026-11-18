CREATE TYPE [dbo].[RolePermissionsType] AS TABLE (
    [RolePermissionID]        INT NULL,
    [RoleId]                  INT NULL,
    [ModuleId]                INT NULL,
    [CanView]                 BIT NULL,
    [CanEdit]                 BIT NULL,
    [CanAdd]                  BIT NULL,
    [CanExport]               BIT NULL,
    [CanDelete]               BIT NULL,
    [CanPrint]                BIT NULL,
    [CanUndoXO]               BIT NULL,
    [CanReassignTo]           BIT NULL,
    [CanViewAllFiles]         BIT NULL,
    [CanViewAllFilesReadOnly] BIT NULL,
    [IsActive]                BIT NULL);


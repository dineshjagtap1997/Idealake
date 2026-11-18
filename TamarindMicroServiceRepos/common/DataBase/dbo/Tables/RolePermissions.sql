CREATE TABLE [dbo].[RolePermissions] (
    [RolePermissionID]        INT      IDENTITY (1, 1) NOT NULL,
    [RoleId]                  INT      NOT NULL,
    [ModuleID]                INT      NULL,
    [CanView]                 BIT      NOT NULL,
    [CanEdit]                 BIT      NOT NULL,
    [CanAdd]                  BIT      NOT NULL,
    [CanExport]               BIT      NOT NULL,
    [CanDelete]               BIT      NOT NULL,
    [CanPrint]                BIT      NOT NULL,
    [CanUndoXO]               BIT      NOT NULL,
    [CanReassignTo]           BIT      NOT NULL,
    [CanViewAllFiles]         BIT      NOT NULL,
    [CanViewAllFilesReadOnly] BIT      NOT NULL,
    [CreatedBy]               INT      NOT NULL,
    [CreatedDateTime]         DATETIME NOT NULL,
    [UpdatedBy]               INT      NULL,
    [UpdatedDateTime]         DATETIME NULL,
    [IsActive]                BIT      NOT NULL
);


CREATE TABLE [dbo].[Sec_RolePermissions] (
    [RoleID]      UNIQUEIDENTIFIER NOT NULL,
    [ModuleiD]    SMALLINT         NOT NULL,
    [Permissions] SMALLINT         NOT NULL,
    CONSTRAINT [PK_Sec_RolePermissions] PRIMARY KEY CLUSTERED ([RoleID] ASC, [ModuleiD] ASC)
);


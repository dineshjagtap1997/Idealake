CREATE TABLE [dbo].[Roles] (
    [RoleId]          INT            IDENTITY (1, 1) NOT NULL,
    [RoleName]        NVARCHAR (256) NOT NULL,
    [Description]     NVARCHAR (256) NULL,
    [CreatedBy]       INT            NOT NULL,
    [CreatedDateTime] DATETIME       DEFAULT (getdate()) NOT NULL,
    [UpdatedBy]       INT            NULL,
    [UpdatedDateTime] DATETIME       NULL,
    [IsActive]        BIT            DEFAULT ((1)) NOT NULL,
    PRIMARY KEY CLUSTERED ([RoleId] ASC)
);


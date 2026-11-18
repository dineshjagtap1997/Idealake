CREATE TABLE [dbo].[Modules] (
    [ModuleID]        INT            IDENTITY (1, 1) NOT NULL,
    [ModuleName]      VARCHAR (100)  NOT NULL,
    [DisplayOrder]    INT            NOT NULL,
    [ParentMenuID]    INT            NULL,
    [Level]           INT            NOT NULL,
    [Type]            VARCHAR (10)   NOT NULL,
    [CreatedBy]       INT            NULL,
    [CreatedDateTime] DATETIME       NULL,
    [UpdatedBy]       INT            NULL,
    [UpdatedDateTime] DATETIME       NULL,
    [IsActive]        BIT            NULL,
    [Link]            NVARCHAR (MAX) NULL,
    [visibleSection]  BIT            DEFAULT ((0)) NULL,
    PRIMARY KEY CLUSTERED ([ModuleID] ASC)
);


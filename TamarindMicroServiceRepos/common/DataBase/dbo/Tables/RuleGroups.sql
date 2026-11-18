CREATE TABLE [dbo].[RuleGroups] (
    [ID]          INT              IDENTITY (1, 1) NOT NULL,
    [Name]        VARCHAR (50)     NOT NULL,
    [IsActive]    BIT              NOT NULL,
    [Operation]   VARCHAR (10)     NOT NULL,
    [OperationBy] UNIQUEIDENTIFIER NOT NULL,
    [OperationOn] DATETIME         NOT NULL,
    [UpdatedBy]   UNIQUEIDENTIFIER NULL,
    [UpdatedOn]   DATETIME         NULL,
    CONSTRAINT [PK_RuleGroups] PRIMARY KEY CLUSTERED ([ID] ASC)
);


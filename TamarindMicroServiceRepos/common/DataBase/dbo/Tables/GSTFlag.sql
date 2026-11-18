CREATE TABLE [dbo].[GSTFlag] (
    [ID]       INT          IDENTITY (1, 1) NOT NULL,
    [FlagName] VARCHAR (15) NULL,
    CONSTRAINT [PK_FlagID] PRIMARY KEY CLUSTERED ([ID] ASC)
);


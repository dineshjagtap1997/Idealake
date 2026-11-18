CREATE TABLE [dbo].[Tax_Percentage] (
    [taxID]    INT NOT NULL,
    [taxValue] INT NULL,
    CONSTRAINT [PK_Tax_Percentage] PRIMARY KEY CLUSTERED ([taxID] ASC)
);


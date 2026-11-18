CREATE TABLE [dbo].[BankMaster] (
    [BankID]    INT              IDENTITY (1, 1) NOT NULL,
    [BankName]  VARCHAR (200)    NULL,
    [UpdatedBy] UNIQUEIDENTIFIER NULL,
    [UpdatedOn] DATETIME         NULL,
    CONSTRAINT [PK_BankMaster] PRIMARY KEY CLUSTERED ([BankID] ASC)
);


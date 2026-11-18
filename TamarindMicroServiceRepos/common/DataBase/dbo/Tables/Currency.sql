CREATE TABLE [dbo].[Currency] (
    [CurrencyID]  INT              IDENTITY (1, 1) NOT NULL,
    [Code]        VARCHAR (10)     NOT NULL,
    [Name]        VARCHAR (100)    NOT NULL,
    [Symbol]      VARCHAR (10)     NOT NULL,
    [IsActive]    BIT              NULL,
    [Operation]   VARCHAR (50)     NULL,
    [OperationBy] UNIQUEIDENTIFIER NULL,
    [OperationOn] DATETIME         NULL,
    [OldID]       VARCHAR (50)     NULL,
    [UpdatedBy]   UNIQUEIDENTIFIER NULL,
    [UpdatedOn]   DATETIME         NULL,
    PRIMARY KEY CLUSTERED ([CurrencyID] ASC)
);


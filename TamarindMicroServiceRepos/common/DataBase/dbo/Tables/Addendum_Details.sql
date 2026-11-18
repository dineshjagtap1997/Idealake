CREATE TABLE [dbo].[Addendum_Details] (
    [ID]          INT           IDENTITY (1, 1) NOT NULL,
    [AddendumNo]  VARCHAR (50)  NULL,
    [Description] VARCHAR (500) NULL,
    [InvoiceID]   VARCHAR (50)  NULL,
    [Currency]    VARCHAR (50)  NULL,
    [Amount]      VARCHAR (50)  NULL,
    [CreatedDate] DATETIME      NULL,
    [YearCode]    VARCHAR (10)  NULL,
    [UpdatedDate] DATETIME      NULL
);


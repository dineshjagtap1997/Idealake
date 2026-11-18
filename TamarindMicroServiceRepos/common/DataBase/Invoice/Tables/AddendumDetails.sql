CREATE TABLE [Invoice].[AddendumDetails] (
    [ID]          INT           IDENTITY (1, 1) NOT NULL,
    [AddendumID]  INT           NULL,
    [Description] VARCHAR (255) NULL,
    [InvoiceID]   VARCHAR (50)  NULL,
    [Currency]    VARCHAR (10)  NULL,
    [Amount]      VARCHAR (50)  NULL,
    [CreatedDate] DATETIME      NULL,
    [YearCode]    VARCHAR (10)  NULL,
    [UpdatedDate] DATETIME      NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


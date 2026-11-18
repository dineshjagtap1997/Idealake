CREATE TABLE [Invoice].[InvoiceSequence] (
    [ID]           INT          IDENTITY (1, 1) NOT NULL,
    [CompanyID]    VARCHAR (10) NOT NULL,
    [InvoiceType]  VARCHAR (2)  NOT NULL,
    [FiscalYear]   INT          NOT NULL,
    [MaxCounterID] INT          DEFAULT ((0)) NOT NULL,
    [YearCode]     INT          NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


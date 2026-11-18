CREATE TABLE [dbo].[Addendum] (
    [AddendumID]   INT             IDENTITY (1, 1) NOT NULL,
    [AddendumNo]   VARCHAR (50)    NULL,
    [AddendumDate] DATETIME        NULL,
    [Currency]     VARCHAR (50)    NULL,
    [Amount]       NUMERIC (18, 2) NULL,
    [InvoiceID]    VARCHAR (50)    NULL,
    [InvoiceDate]  DATETIME        NULL,
    [CreatedDate]  DATETIME        NULL,
    [CreatedBy]    NCHAR (10)      NULL,
    [UpdatedDate]  DATETIME        NULL,
    [UpdatedBy]    VARCHAR (50)    NULL,
    [YearCode]     VARCHAR (10)    NULL,
    [QuotationID]  VARCHAR (10)    NULL
);


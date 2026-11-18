CREATE TABLE [Invoice].[Addendum] (
    [AddendumID]   INT             IDENTITY (1, 1) NOT NULL,
    [AddendumNo]   VARCHAR (50)    NULL,
    [AddendumDate] DATETIME        NULL,
    [Currency]     VARCHAR (10)    NULL,
    [Amount]       NUMERIC (18, 2) NULL,
    [InvoiceID]    BIGINT          NULL,
    [InvoiceDate]  DATETIME        NULL,
    [CreatedDate]  DATETIME        NULL,
    [CreatedBy]    NCHAR (50)      NULL,
    [UpdatedDate]  DATETIME        NULL,
    [UpdatedBy]    VARCHAR (50)    NULL,
    [YearCode]     VARCHAR (10)    NULL,
    PRIMARY KEY CLUSTERED ([AddendumID] ASC)
);


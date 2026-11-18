CREATE TABLE [dbo].[SAP_ASTRA_SALES] (
    [SALES_ID]         BIGINT          IDENTITY (1, 1) NOT NULL,
    [CompCode]         VARCHAR (50)    NULL,
    [FiscalYear]       VARCHAR (10)    NULL,
    [Status]           VARCHAR (5)     NULL,
    [SAPDocID]         VARCHAR (50)    NULL,
    [SAPPostingDate]   VARCHAR (50)    NULL,
    [DocType]          VARCHAR (5)     NULL,
    [VendorID]         VARCHAR (50)    NULL,
    [RefNo]            VARCHAR (50)    NULL,
    [FileCode]         VARCHAR (50)    NULL,
    [DocDate]          VARCHAR (50)    NULL,
    [DocCurr]          VARCHAR (50)    NULL,
    [TotalDocAmt]      DECIMAL (18, 2) NULL,
    [ROE]              DECIMAL (18, 2) NULL,
    [NonTaxableSaleLC] DECIMAL (18, 2) NULL,
    [TaxableSaleLC]    DECIMAL (18, 2) NULL,
    [TotalSaleLC]      DECIMAL (18, 2) NULL,
    [IsReversed]       VARCHAR (5)     NULL,
    [CreatedDate]      DATETIME        NULL,
    [UpdatedDateTime]  DATETIME        NULL
);


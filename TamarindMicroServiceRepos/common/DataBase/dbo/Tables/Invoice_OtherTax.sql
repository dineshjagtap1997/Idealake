CREATE TABLE [dbo].[Invoice_OtherTax] (
    [Invoice_OtherTaxID] INT             IDENTITY (1, 1) NOT NULL,
    [Invoice_ID]         VARCHAR (50)    NOT NULL,
    [YearCode]           INT             NOT NULL,
    [ServiceTax_Amount]  NUMERIC (18, 2) NOT NULL,
    [SBT_TaxAmount]      NUMERIC (18, 2) NULL,
    [InsertionDate]      DATETIME        NOT NULL,
    [OtherServiceTaxID]  INT             NOT NULL,
    [KKT_TaxAmount]      NUMERIC (18, 2) NULL,
    [SGST]               NUMERIC (18, 2) NULL,
    [IGST]               NUMERIC (18, 2) NULL,
    [CGST]               NUMERIC (18, 2) NULL
);


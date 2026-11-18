CREATE TABLE [dbo].[Invoice_New_IRN_SuperTaxJob_Details] (
    [ID]                       INT            IDENTITY (1, 1) NOT NULL,
    [InvoiceID]                VARCHAR (50)   NULL,
    [IRN]                      VARCHAR (100)  NULL,
    [QR_Code]                  VARCHAR (MAX)  NULL,
    [Status]                   VARCHAR (50)   NULL,
    [Messages]                 VARCHAR (8000) NULL,
    [YearCode]                 VARCHAR (50)   NULL,
    [AckDate]                  VARCHAR (100)  NULL,
    [AckNumber]                VARCHAR (100)  NULL,
    [QR_Code_Signed]           VARCHAR (MAX)  NULL,
    [Customer_Document_Number] VARCHAR (50)   NULL,
    [CreatedDate]              DATETIME       NULL,
    [InvoiceDate]              VARCHAR (50)   NULL,
    [Flag]                     VARCHAR (3)    NULL,
    [UpdatedDate]              DATETIME       NULL
);


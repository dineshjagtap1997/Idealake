CREATE TABLE [dbo].[Invoice_ARN_ErrorLog] (
    [ID]             INT           IDENTITY (1, 1) NOT NULL,
    [InvoiceID]      VARCHAR (50)  NULL,
    [YearCode]       VARCHAR (50)  NULL,
    [Status]         VARCHAR (50)  NULL,
    [Messages]       VARCHAR (800) NULL,
    [CreatedDate]    DATETIME      NULL,
    [ARN]            VARCHAR (100) NULL,
    [QR_Code]        VARCHAR (MAX) NULL,
    [AckDate]        VARCHAR (100) NULL,
    [AckNo]          VARCHAR (100) NULL,
    [QR_Code_Signed] VARCHAR (MAX) NULL
);


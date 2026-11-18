CREATE TYPE [dbo].[IRNDataType] AS TABLE (
    [INVOICENO]   NVARCHAR (50)  NULL,
    [INVOICEDATE] DATE           NULL,
    [Ackno]       BIGINT         NULL,
    [Ackdate]     DATETIME       NULL,
    [IRN]         NVARCHAR (MAX) NULL,
    [SignedQR]    NVARCHAR (MAX) NULL,
    [CreatedBy]   INT            NULL);


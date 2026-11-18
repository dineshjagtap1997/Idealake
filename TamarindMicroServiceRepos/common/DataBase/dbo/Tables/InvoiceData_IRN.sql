CREATE TABLE [dbo].[InvoiceData_IRN] (
    [IRNId]           INT            IDENTITY (1, 1) NOT NULL,
    [INVOICENO]       NVARCHAR (50)  NULL,
    [INVOICEDATE]     DATE           NULL,
    [Ackno]           BIGINT         NULL,
    [Ackdate]         DATETIME       NULL,
    [IRN]             NVARCHAR (MAX) NULL,
    [SignedQR]        NVARCHAR (MAX) NULL,
    [CreatedBy]       INT            NULL,
    [CreatedDateTime] DATETIME       NULL,
    [UpdatedBy]       INT            NULL,
    [UpdatedDateTime] DATETIME       NULL,
    [IsActive]        BIT            NULL,
    PRIMARY KEY CLUSTERED ([IRNId] ASC)
);


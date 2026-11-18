CREATE TABLE [Invoice].[InvoiceDetails] (
    [ID]                  BIGINT           IDENTITY (1, 1) NOT NULL,
    [Invoice_ID]          BIGINT           NULL,
    [Invoice_Desc]        VARCHAR (255)    NULL,
    [Invoice_Value]       NUMERIC (18, 2)  NULL,
    [YearCode]            INT              NULL,
    [flag]                BIT              NULL,
    [SAC]                 VARCHAR (100)    NULL,
    [Tax_Per]             DECIMAL (10, 2)  NULL,
<<<<<<< HEAD
<<<<<<< HEAD
    [Allocate]            BIGINT           NULL,
=======
    [Allocate]            VARCHAR (50)     NULL,
>>>>>>> dev
=======
    [Allocate]            VARCHAR (50)     NULL,
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    [StateCode]           NVARCHAR (100)   NULL,
    [SACID]               BIGINT           NULL,
    [Tax_ID]              INT              NULL,
    [TCSRateID]           INT              NULL,
    [CGST]                NUMERIC (18, 2)  NULL,
    [SGST]                NUMERIC (18, 2)  NULL,
    [UTGST]               NUMERIC (18, 2)  NULL,
    [IGST]                NUMERIC (18, 2)  NULL,
    [TotalBasicAmount]    NUMERIC (18, 2)  NULL,
    [TotalTaxable_Amount] NUMERIC (18, 2)  NULL,
    [TotalTax_Amount]     NUMERIC (18, 2)  NULL,
    [TotalInvoiceAmount]  NUMERIC (18, 2)  NULL,
    [TCSAmount]           NUMERIC (18, 2)  NULL,
    [StateCodeID]         BIGINT           NULL,
    [InvGenerated]        INT              NULL,
    [Commercial_ID]       NVARCHAR (100)   NULL,
    [Parent_ID]           BIGINT           NULL,
    [TotalTktCost]        NUMERIC (18, 2)  NULL,
    [MarkUp]              NUMERIC (18, 2)  NULL,
    [TTC_MarkUp]          NUMERIC (18, 2)  NULL,
    [BaseFare]            NUMERIC (18, 2)  NULL,
    [Invoice_Desc_ID]     INT              NULL,
    [CreatedBy]           UNIQUEIDENTIFIER NULL,
    [CreatedDateTime]     DATETIME         NULL,
    [LastUpdatedBy]       UNIQUEIDENTIFIER NULL,
    [LastUpdateDateTime]  DATETIME         NULL,
<<<<<<< HEAD
<<<<<<< HEAD
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    [TaxableAmountDetail] NUMERIC (18, 2)  NULL,
    [TotalAmount]         NUMERIC (18, 2)  NULL,
    [TaxAmount]           NUMERIC (18, 2)  NULL,
    [BasicAmount]         NUMERIC (18, 2)  NULL,
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


CREATE TABLE [dbo].[GSTITCRateMaster] (
    [TaxID]           BIGINT           IDENTITY (1, 1) NOT NULL,
    [ITCPercentage]   DECIMAL (18, 2)  NULL,
    [RateForSAP]      DECIMAL (18, 2)  NULL,
    [IsActive]        BIT              NULL,
    [CreatedBy]       UNIQUEIDENTIFIER NULL,
    [CreatedDatetime] DATETIME         NULL,
    [UpdatedBy]       UNIQUEIDENTIFIER NULL,
    [UpdatedDatetime] DATETIME         NULL,
    [Operation]       VARCHAR (MAX)    NULL,
    CONSTRAINT [PK_GST ITCRateMaster] PRIMARY KEY CLUSTERED ([TaxID] ASC) WITH (FILLFACTOR = 80)
);


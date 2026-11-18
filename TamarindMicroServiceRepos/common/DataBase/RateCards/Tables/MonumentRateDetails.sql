CREATE TABLE [RateCards].[MonumentRateDetails] (
    [MonumentDetailID] BIGINT           IDENTITY (1, 1) NOT NULL,
    [TaxID]            INT              NULL,
    [ValidFrom]        DATETIME         NULL,
    [ValidTo]          DATETIME         NULL,
    [NationalityID]    INT              NULL,
    [MISSequence]      VARCHAR (100)    NULL,
    [IsActive]         BIT              DEFAULT ((1)) NULL,
    [CreatedBy]        UNIQUEIDENTIFIER NULL,
    [UpdatedBy]        UNIQUEIDENTIFIER NULL,
    [CreatedOn]        DATETIME         NULL,
    [UpdatedOn]        DATETIME         NULL,
    [MonumentRateID]   BIGINT           NULL,
    [OldRateDetailID]  VARCHAR (200)    NULL,
    PRIMARY KEY CLUSTERED ([MonumentDetailID] ASC)
);


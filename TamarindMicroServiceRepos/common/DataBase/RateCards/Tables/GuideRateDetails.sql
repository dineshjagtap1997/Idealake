CREATE TABLE [RateCards].[GuideRateDetails] (
    [GuideRateDetailID] BIGINT           IDENTITY (1, 1) NOT NULL,
    [GuideRateID]       BIGINT           NULL,
    [ValidFrom]         DATETIME         NULL,
    [ValidTo]           DATETIME         NULL,
    [MISSequence]       VARCHAR (20)     NULL,
    [IsActive]          BIT              DEFAULT ((1)) NULL,
    [CreatedOn]         DATETIME         NULL,
    [UpdatedOn]         DATETIME         NULL,
    [UpdatedBy]         UNIQUEIDENTIFIER NULL,
    [CreatedBy]         UNIQUEIDENTIFIER NULL,
    [TaxID]             INT              NULL,
    [OldRateID]         VARCHAR (250)    NULL,
    PRIMARY KEY CLUSTERED ([GuideRateDetailID] ASC)
);


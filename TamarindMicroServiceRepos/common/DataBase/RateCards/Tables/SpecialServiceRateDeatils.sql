CREATE TABLE [RateCards].[SpecialServiceRateDeatils] (
    [ID]                         UNIQUEIDENTIFIER DEFAULT (newid()) NULL,
    [SpecialServiceRateDetailID] BIGINT           IDENTITY (1, 1) NOT NULL,
    [TaxID]                      INT              NULL,
    [ValidFrom]                  DATETIME         NULL,
    [ValidTo]                    DATETIME         NULL,
    [NationalityID]              INT              NULL,
    [RatePreferenceID]           INT              NULL,
    [MISSequence]                VARCHAR (100)    NULL,
    [IsActive]                   BIT              DEFAULT ((1)) NULL,
    [CreatedBy]                  UNIQUEIDENTIFIER DEFAULT (newid()) NULL,
    [UpdatedBy]                  UNIQUEIDENTIFIER DEFAULT (newid()) NULL,
    [CreatedOn]                  DATETIME         DEFAULT (getdate()) NULL,
    [UpdatedOn]                  DATETIME         DEFAULT (getdate()) NULL,
    [SpecialServiceRateID]       BIGINT           NULL,
    [OldRateDeatilsID]           NVARCHAR (100)   NULL,
    PRIMARY KEY CLUSTERED ([SpecialServiceRateDetailID] ASC)
);


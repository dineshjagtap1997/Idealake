CREATE TABLE [dbo].[MonumentRateDetails] (
    [MonumentRateDetailsID] UNIQUEIDENTIFIER NOT NULL,
    [MonumentRateID]        INT              NOT NULL,
    [NationalityID]         INT              NOT NULL,
    [RateValidFrom]         DATETIME         NOT NULL,
    [RateValidTo]           DATETIME         NOT NULL,
    [AdultRate]             NUMERIC (18, 2)  NULL,
    [ChildRate]             NUMERIC (18, 2)  NULL,
    [MISSequenceNo]         INT              NULL,
    [IsActive]              BIT              NOT NULL,
    [OldID]                 INT              NULL,
    CONSTRAINT [PK_MonumentRateDetails] PRIMARY KEY CLUSTERED ([MonumentRateDetailsID] ASC) WITH (FILLFACTOR = 80)
);


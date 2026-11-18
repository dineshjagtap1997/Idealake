CREATE TABLE [dbo].[GuideRateDetails] (
    [GuideRateDetailsID] UNIQUEIDENTIFIER NOT NULL,
    [GuideRateID]        INT              NOT NULL,
    [RateValidFrom]      DATETIME         NOT NULL,
    [RateValidTo]        DATETIME         NOT NULL,
    [PaxFrom]            INT              NOT NULL,
    [PaxTo]              INT              NOT NULL,
    [MISSequenceNo]      INT              NULL,
    [Amount]             NUMERIC (18, 2)  NOT NULL,
    [IsActive]           BIT              NOT NULL,
    [ShowOnline]         BIT              NOT NULL,
    [OldID]              INT              NULL
);


CREATE TABLE [dbo].[SpecialServiceRateDetails] (
    [SpecialServiceRateDetailsID] UNIQUEIDENTIFIER NOT NULL,
    [SpecialServiceRateID]        INT              NOT NULL,
    [RateValidFrom]               DATETIME         NOT NULL,
    [RateValidTo]                 DATETIME         NOT NULL,
    [NationalityID]               INT              NOT NULL,
    [PaxFrom]                     INT              NULL,
    [PaxTo]                       INT              NULL,
    [Adult]                       NUMERIC (18, 2)  NULL,
    [Child]                       NUMERIC (18, 2)  NULL,
    [Consolidated]                NUMERIC (18, 2)  NULL,
    [PP_Gross]                    VARCHAR (10)     NULL,
    [MISSequenceNo]               INT              NULL,
    [IsActive]                    BIT              NOT NULL,
    [OldID]                       INT              NULL,
    [ConsolidatedCommission]      DECIMAL (18, 2)  DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_SpecialServiceRateDetails] PRIMARY KEY CLUSTERED ([SpecialServiceRateDetailsID] ASC)
);


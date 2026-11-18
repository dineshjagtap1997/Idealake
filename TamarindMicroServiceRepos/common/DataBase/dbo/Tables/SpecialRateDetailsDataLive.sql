CREATE TABLE [dbo].[SpecialRateDetailsDataLive] (
    [SpecialServiceRateDetailsID] NVARCHAR (255) NULL,
    [SpecialServiceRateID]        INT            NULL,
    [RateValidFrom]               DATETIME       NULL,
    [RateValidTo]                 DATETIME       NULL,
    [NationalityID]               FLOAT (53)     NULL,
    [PaxFrom]                     FLOAT (53)     NULL,
    [PaxTo]                       FLOAT (53)     NULL,
    [Adult]                       NVARCHAR (255) NULL,
    [Child]                       NVARCHAR (255) NULL,
    [Consolidated]                FLOAT (53)     NULL,
    [PP_Gross]                    NVARCHAR (255) NULL,
    [MISSequenceNo]               FLOAT (53)     NULL,
    [IsActive]                    FLOAT (53)     NULL,
    [OldID]                       FLOAT (53)     NULL,
    [ConsolidatedCommission]      FLOAT (53)     NULL
);


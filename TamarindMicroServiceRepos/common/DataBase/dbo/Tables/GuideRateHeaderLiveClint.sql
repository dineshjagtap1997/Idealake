CREATE TABLE [dbo].[GuideRateHeaderLiveClint] (
    [GuideRateID]   FLOAT (53)      NULL,
    [GuideCardNo]   NVARCHAR (255)  NULL,
    [RateCardMode]  FLOAT (53)      NULL,
    [Heading]       NVARCHAR (2000) NULL,
    [ContractDate]  DATETIME        NULL,
    [CityIATACode]  NVARCHAR (255)  NULL,
    [VendorID]      FLOAT (53)      NULL,
    [CurrencyID]    NVARCHAR (255)  NULL,
    [GuideCode]     FLOAT (53)      NULL,
    [LanguageID]    NVARCHAR (255)  NULL,
    [InfoForOps]    NVARCHAR (2000) NULL,
    [InfoForAgents] NVARCHAR (255)  NULL,
    [InfoForXO]     NVARCHAR (500)  NULL,
    [Notes]         NVARCHAR (2000) NULL,
    [IsActive]      FLOAT (53)      NULL,
    [Operation]     NVARCHAR (255)  NULL,
    [OperationBy]   NVARCHAR (255)  NULL,
    [OperationOn]   DATETIME        NULL,
    [OldID]         FLOAT (53)      NULL
);


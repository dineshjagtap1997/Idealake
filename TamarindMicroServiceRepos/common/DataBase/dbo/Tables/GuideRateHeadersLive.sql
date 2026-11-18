CREATE TABLE [dbo].[GuideRateHeadersLive] (
    [GuideRateID]   INT             NULL,
    [GuideCardNo]   NVARCHAR (255)  NULL,
    [RateCardMode]  FLOAT (53)      NULL,
    [Heading]       VARCHAR (250)   NULL,
    [ContractDate]  DATETIME        NULL,
    [CityIATACode]  NVARCHAR (255)  NULL,
    [VendorID]      INT             NULL,
    [CurrencyID]    NVARCHAR (255)  NULL,
    [GuideCode]     FLOAT (53)      NULL,
    [LanguageID]    NVARCHAR (255)  NULL,
    [InfoForOps]    NVARCHAR (1000) NULL,
    [InfoForAgents] NVARCHAR (255)  NULL,
    [InfoForXO]     NVARCHAR (255)  NULL,
    [Notes]         NVARCHAR (255)  NULL,
    [IsActive]      FLOAT (53)      NULL,
    [Operation]     NVARCHAR (255)  NULL,
    [OperationBy]   NVARCHAR (255)  NULL,
    [OperationOn]   DATETIME        NULL,
    [OldID]         FLOAT (53)      NULL
);


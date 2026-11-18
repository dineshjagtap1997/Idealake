CREATE TABLE [dbo].[MonumentRateHeaderLiveClint] (
    [MonumentRateID] INT             NULL,
    [MonumentCardNo] NVARCHAR (255)  NULL,
    [RateCardMode]   FLOAT (53)      NULL,
    [Heading]        NVARCHAR (1000) NULL,
    [ContractDate]   DATETIME        NULL,
    [CityIATACode]   NVARCHAR (255)  NULL,
    [VendorID]       FLOAT (53)      NULL,
    [CurrencyID]     NVARCHAR (255)  NULL,
    [MonumentID]     FLOAT (53)      NULL,
    [InfoForOps]     NVARCHAR (1000) NULL,
    [InfoForAgents]  NVARCHAR (255)  NULL,
    [InfoForXO]      NVARCHAR (500)  NULL,
    [Notes]          NVARCHAR (255)  NULL,
    [IsActive]       FLOAT (53)      NULL,
    [Operation]      NVARCHAR (255)  NULL,
    [OperationBy]    NVARCHAR (255)  NULL,
    [OperationOn]    DATETIME        NULL,
    [OldID]          FLOAT (53)      NULL
);


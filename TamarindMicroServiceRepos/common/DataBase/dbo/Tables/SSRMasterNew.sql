CREATE TABLE [dbo].[SSRMasterNew] (
    [SpecialServiceRateID] INT             NULL,
    [SpecialCardNo]        NVARCHAR (255)  NULL,
    [RateCardMode]         FLOAT (53)      NULL,
    [Heading]              NVARCHAR (1000) NULL,
    [ContractDate]         DATETIME        NULL,
    [CityIATACode]         NVARCHAR (255)  NULL,
    [IsVendorHotel]        FLOAT (53)      NULL,
    [VendorHotelID]        FLOAT (53)      NULL,
    [CurrencyID]           NVARCHAR (255)  NULL,
    [SpecialServiceID]     FLOAT (53)      NULL,
    [InfoForOps]           NVARCHAR (2000) NULL,
    [InfoForAgents]        NVARCHAR (255)  NULL,
    [InfoForXO]            NVARCHAR (500)  NULL,
    [Notes]                NVARCHAR (255)  NULL,
    [IsActive]             FLOAT (53)      NULL,
    [Operation]            NVARCHAR (255)  NULL,
    [OperationBy]          NVARCHAR (255)  NULL,
    [OperationOn]          DATETIME        NULL,
    [OldID]                FLOAT (53)      NULL,
    [IsDirectPayment]      FLOAT (53)      NULL
);


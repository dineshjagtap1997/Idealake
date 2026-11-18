CREATE TABLE [dbo].[SpecialServiceRateMaster] (
    [SpecialServiceRateID] INT              IDENTITY (1, 1) NOT NULL,
    [SpecialCardNo]        VARCHAR (15)     NOT NULL,
    [RateCardMode]         TINYINT          NOT NULL,
    [Heading]              VARCHAR (200)    NULL,
    [ContractDate]         DATETIME         NOT NULL,
    [CityIATACode]         CHAR (3)         NOT NULL,
    [IsVendorHotel]        TINYINT          NOT NULL,
    [VendorHotelID]        INT              NOT NULL,
    [CurrencyID]           VARCHAR (5)      NOT NULL,
    [SpecialServiceID]     INT              NOT NULL,
    [InfoForOps]           VARCHAR (250)    NULL,
    [InfoForAgents]        VARCHAR (250)    NULL,
    [InfoForXO]            VARCHAR (250)    NULL,
    [Notes]                VARCHAR (250)    NULL,
    [IsActive]             BIT              NOT NULL,
    [Operation]            VARCHAR (10)     NOT NULL,
    [OperationBy]          UNIQUEIDENTIFIER NOT NULL,
    [OperationOn]          DATETIME         NOT NULL,
    [OldID]                INT              NULL,
    [IsDirectPayment]      BIT              DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_SpecialServiceRateMaster] PRIMARY KEY CLUSTERED ([SpecialServiceRateID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'(1-Contract,2-Adhoc,3-Negotiated)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SpecialServiceRateMaster', @level2type = N'COLUMN', @level2name = N'RateCardMode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1-Vendor,2-Hotel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SpecialServiceRateMaster', @level2type = N'COLUMN', @level2name = N'IsVendorHotel';


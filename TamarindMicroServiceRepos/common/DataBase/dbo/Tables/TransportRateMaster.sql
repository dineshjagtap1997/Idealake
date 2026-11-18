CREATE TABLE [dbo].[TransportRateMaster] (
    [TransportRateID]    INT              IDENTITY (1, 1) NOT NULL,
    [TransportCardNo]    VARCHAR (15)     NOT NULL,
    [RateCardMode]       TINYINT          NOT NULL,
    [Heading]            VARCHAR (200)    NOT NULL,
    [ContractDate]       DATETIME         NOT NULL,
    [CityIATACode]       CHAR (3)         NOT NULL,
    [IsVendorHotel]      TINYINT          NOT NULL,
    [VendorHotelID]      INT              NULL,
    [CurrencyID]         VARCHAR (5)      NOT NULL,
    [TransportCode]      INT              NULL,
    [ModeOfTransport]    TINYINT          NOT NULL,
    [InfoForOps]         VARCHAR (250)    NULL,
    [InfoForAgents]      VARCHAR (250)    NULL,
    [InfoForXO]          VARCHAR (250)    NULL,
    [Remarks]            VARCHAR (250)    NULL,
    [IsActive]           BIT              NOT NULL,
    [Operation]          VARCHAR (10)     NOT NULL,
    [OperationBy]        UNIQUEIDENTIFIER NOT NULL,
    [OperationOn]        DATETIME         CONSTRAINT [DF_TransportRateMaster_OperationOn] DEFAULT (getdate()) NOT NULL,
    [OldID]              INT              NULL,
    [ServiceDescription] VARCHAR (500)    NULL,
    [CityCode1]          VARCHAR (3)      NULL,
    [CityCode2]          VARCHAR (3)      NULL,
    CONSTRAINT [PK_TransportRateMaster] PRIMARY KEY CLUSTERED ([TransportRateID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'(1-Contract,2-Adhoc,3-Negotiated)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TransportRateMaster', @level2type = N'COLUMN', @level2name = N'RateCardMode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1-Vendor,2-Hotel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TransportRateMaster', @level2type = N'COLUMN', @level2name = N'IsVendorHotel';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1-Transfer,2-Tours', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TransportRateMaster', @level2type = N'COLUMN', @level2name = N'ModeOfTransport';


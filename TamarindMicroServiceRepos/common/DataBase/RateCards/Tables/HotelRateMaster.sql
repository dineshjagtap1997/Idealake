CREATE TABLE [RateCards].[HotelRateMaster] (
    [HotelRateID]        BIGINT           IDENTITY (1, 1) NOT NULL,
    [CardNumber]         CHAR (15)        NOT NULL,
    [ContractDate]       DATETIME         NOT NULL,
    [CurrencyID]         VARCHAR (5)      NULL,
    [PaymentTypeID]      INT              NULL,
    [Heading]            VARCHAR (100)    NOT NULL,
    [RateCardModeTypeID] INT              NOT NULL,
    [HotelID]            BIGINT           NOT NULL,
    [VendorID]           BIGINT           NULL,
    [CityID]             VARCHAR (3)      NOT NULL,
    [RateTypeID]         INT              NULL,
    [ValueAddOn]         VARCHAR (MAX)    NULL,
    [InfoForOperation]   VARCHAR (200)    NULL,
    [InfoForRemark]      VARCHAR (250)    NULL,
    [InfoForAgent]       VARCHAR (MAX)    NULL,
    [IsActive]           BIT              DEFAULT ((0)) NOT NULL,
    [CreatedOn]          DATETIME         NULL,
    [UpdatedOn]          DATETIME         NULL,
    [CreatedBy]          UNIQUEIDENTIFIER NULL,
    [UpdatedBy]          UNIQUEIDENTIFIER NULL,
    [StateID]            INT              NULL,
    [GstStatus]          VARCHAR (20)     NULL,
    [IsCommission]       BIT              NULL,
    [BookingID]          BIGINT           NULL,
    PRIMARY KEY CLUSTERED ([HotelRateID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_HotelRateMaster_ActiveCityMode]
    ON [RateCards].[HotelRateMaster]([IsActive] ASC, [CityID] ASC, [RateCardModeTypeID] ASC)
    INCLUDE([HotelID], [CreatedOn], [BookingID], [VendorID]);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Direct Payment/ BTC Commission', @level0type = N'SCHEMA', @level0name = N'RateCards', @level1type = N'TABLE', @level1name = N'HotelRateMaster', @level2type = N'COLUMN', @level2name = N'PaymentTypeID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1-Contract, 2-Adhoc, 3-Negotiated', @level0type = N'SCHEMA', @level0name = N'RateCards', @level1type = N'TABLE', @level1name = N'HotelRateMaster', @level2type = N'COLUMN', @level2name = N'RateCardModeTypeID';


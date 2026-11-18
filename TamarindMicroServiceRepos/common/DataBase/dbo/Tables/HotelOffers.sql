CREATE TABLE [dbo].[HotelOffers] (
    [HotelOfferID]    INT              IDENTITY (1, 1) NOT NULL,
    [CardNo]          NCHAR (15)       NULL,
    [IsVendorHotel]   TINYINT          NOT NULL,
    [CityIATACode]    CHAR (3)         NULL,
    [HotelVendorID]   INT              NULL,
    [HotelGroupCode]  CHAR (3)         NULL,
    [HotelVendorName] VARCHAR (500)    NULL,
    [HotelGroupName]  VARCHAR (500)    NULL,
    [HotelRatingID]   INT              NULL,
    [Heading]         VARCHAR (500)    NOT NULL,
    [RateValidFrom]   DATETIME         NOT NULL,
    [RateValidTo]     DATETIME         NOT NULL,
    [InfoForOps]      VARCHAR (MAX)    NOT NULL,
    [Rules]           VARCHAR (MAX)    NULL,
    [IsMarketAgent]   TINYINT          CONSTRAINT [DF_HotelOffers_IsMarketAgent] DEFAULT ((1)) NULL,
    [IsActive]        BIT              NOT NULL,
    [Operation]       VARCHAR (10)     NOT NULL,
    [OperationBy]     UNIQUEIDENTIFIER NOT NULL,
    [OperationOn]     DATETIME         CONSTRAINT [DF_HotelOffers_OperationOn] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_HotelOffers] PRIMARY KEY CLUSTERED ([HotelOfferID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1-Vendor,2-Hotel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HotelOffers', @level2type = N'COLUMN', @level2name = N'IsVendorHotel';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1-Market,2 -Agent', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HotelOffers', @level2type = N'COLUMN', @level2name = N'IsMarketAgent';


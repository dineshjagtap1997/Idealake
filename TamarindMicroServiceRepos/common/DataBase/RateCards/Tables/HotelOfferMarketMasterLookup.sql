CREATE TABLE [RateCards].[HotelOfferMarketMasterLookup] (
    [ID]           BIGINT IDENTITY (1, 1) NOT NULL,
    [MarketRateID] INT    NULL,
    [HotelOfferID] BIGINT NULL,
    [IsActive]     BIT    DEFAULT ((1)) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


CREATE TABLE [RateCards].[HotelRateMarketMasterLookup] (
    [ID]           INT    IDENTITY (1, 1) NOT NULL,
    [MarketRateID] INT    NULL,
    [HotelRateID]  BIGINT NULL,
    [IsActive]     BIT    DEFAULT ((1)) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_HotelRateMarketMasterLookup]
    ON [RateCards].[HotelRateMarketMasterLookup]([HotelRateID] ASC, [MarketRateID] ASC, [IsActive] ASC);


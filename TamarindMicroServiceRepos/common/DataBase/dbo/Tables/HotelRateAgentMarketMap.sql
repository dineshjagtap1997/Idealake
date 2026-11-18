CREATE TABLE [dbo].[HotelRateAgentMarketMap] (
    [RateAgentMarketMapID] INT IDENTITY (1, 1) NOT NULL,
    [HotelRateID]          INT NOT NULL,
    [AgentID]              INT NULL,
    [MarketID]             INT NOT NULL,
    CONSTRAINT [PK_HotelRateAgentMarketMap] PRIMARY KEY CLUSTERED ([RateAgentMarketMapID] ASC)
);


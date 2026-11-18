CREATE TABLE [dbo].[HotelOfferAgentMarketMap] (
    [HotelOfferAgentMarketMapID] INT IDENTITY (1, 1) NOT NULL,
    [HotelOfferID]               INT NOT NULL,
    [AgentID]                    INT NULL,
    [MarketID]                   INT NOT NULL,
    CONSTRAINT [PK_HotelOfferAgentMarketMap] PRIMARY KEY CLUSTERED ([HotelOfferAgentMarketMapID] ASC)
);


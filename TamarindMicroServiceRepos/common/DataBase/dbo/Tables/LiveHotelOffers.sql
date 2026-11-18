CREATE TABLE [dbo].[LiveHotelOffers] (
    [HotelOfferID]    FLOAT (53)     NULL,
    [CardNo]          NVARCHAR (255) NULL,
    [IsVendorHotel]   FLOAT (53)     NULL,
    [CityIATACode]    NVARCHAR (255) NULL,
    [HotelVendorID]   FLOAT (53)     NULL,
    [HotelGroupCode]  NVARCHAR (255) NULL,
    [HotelVendorName] NVARCHAR (255) NULL,
    [HotelGroupName]  NVARCHAR (255) NULL,
    [HotelRatingID]   FLOAT (53)     NULL,
    [Heading]         NVARCHAR (255) NULL,
    [RateValidFrom]   DATETIME       NULL,
    [RateValidTo]     DATETIME       NULL,
    [InfoForOps]      NVARCHAR (255) NULL,
    [Rules]           NVARCHAR (255) NULL,
    [IsMarketAgent]   FLOAT (53)     NULL,
    [IsActive]        FLOAT (53)     NULL,
    [Operation]       NVARCHAR (255) NULL,
    [OperationBy]     NVARCHAR (255) NULL,
    [OperationOn]     DATETIME       NULL
);


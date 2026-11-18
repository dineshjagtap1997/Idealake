CREATE TABLE [RateCards].[HotelOfferMapping] (
    [ID]           BIGINT IDENTITY (1, 1) NOT NULL,
    [HotelID]      INT    NULL,
    [HotelOfferID] BIGINT NULL,
    [IsActive]     BIT    DEFAULT ((1)) NULL
);


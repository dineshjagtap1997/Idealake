CREATE TABLE [dbo].[HotelOfferRateType] (
    [HotelOfferRateTypeID] INT IDENTITY (1, 1) NOT NULL,
    [HotelOfferID]         INT NOT NULL,
    [RateTypeID]           INT NOT NULL,
    CONSTRAINT [PK_HotelOfferRateType] PRIMARY KEY CLUSTERED ([HotelOfferRateTypeID] ASC)
);


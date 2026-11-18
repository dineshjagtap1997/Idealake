CREATE TABLE [RateCards].[HotelOfferRateSheetMasterLookup] (
    [ID]           BIGINT IDENTITY (1, 1) NOT NULL,
    [RateSheetID]  INT    NULL,
    [HotelOfferID] BIGINT NULL,
    [IsActive]     BIT    DEFAULT ((1)) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


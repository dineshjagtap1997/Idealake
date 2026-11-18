CREATE TABLE [RateCards].[HotelRatesheetMasterLookup] (
    [ID]          INT    IDENTITY (1, 1) NOT NULL,
    [RateSheetID] INT    NULL,
    [HotelRateID] BIGINT NULL,
    [IsActive]    BIT    DEFAULT ((1)) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_HotelRatesheetMasterLookup]
    ON [RateCards].[HotelRatesheetMasterLookup]([HotelRateID] ASC, [RateSheetID] ASC, [IsActive] ASC);


CREATE TABLE [RateCards].[HotelRateVoucherTypeLookup] (
    [ID]            INT    IDENTITY (1, 1) NOT NULL,
    [VoucherTypeID] INT    NULL,
    [HotelRateID]   BIGINT NULL,
    [IsActive]      BIT    DEFAULT ((1)) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


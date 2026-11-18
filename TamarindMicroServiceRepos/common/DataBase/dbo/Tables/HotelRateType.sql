CREATE TABLE [dbo].[HotelRateType] (
    [HotelRateTypeID] INT              IDENTITY (1, 1) NOT NULL,
    [HotelRateID]     INT              NOT NULL,
    [RateTypeID]      INT              NOT NULL,
    [UpdatedBy]       UNIQUEIDENTIFIER NULL,
    [UpdatedOn]       DATETIME         NULL,
    CONSTRAINT [PK_HotelRateType] PRIMARY KEY CLUSTERED ([HotelRateTypeID] ASC)
);


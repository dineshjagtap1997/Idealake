CREATE TABLE [dbo].[HotelOccupancyMarkupOverride] (
    [HotelOccupancyID]   INT              IDENTITY (1, 1) NOT NULL,
    [HotelRateDetailsID] UNIQUEIDENTIFIER NOT NULL,
    [HotelRateID]        INT              NOT NULL,
    [AgentCategoryID]    INT              NOT NULL,
    [OccupancySingle]    NUMERIC (18, 2)  NULL,
    [OccupancyDouble]    NUMERIC (18, 2)  NULL,
    CONSTRAINT [PK_HotelOccupancyMarkupOverride] PRIMARY KEY CLUSTERED ([HotelOccupancyID] ASC)
);


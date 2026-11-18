CREATE TABLE [dbo].[HotelProximity] (
    [ProximityID] INT             IDENTITY (1, 1) NOT NULL,
    [HotelID]     INT             NOT NULL,
    [LandMark]    VARCHAR (50)    NOT NULL,
    [Distance]    DECIMAL (18, 4) NOT NULL,
    [Measure]     VARCHAR (50)    NOT NULL,
    CONSTRAINT [PK_HotelProximity] PRIMARY KEY CLUSTERED ([ProximityID] ASC)
);


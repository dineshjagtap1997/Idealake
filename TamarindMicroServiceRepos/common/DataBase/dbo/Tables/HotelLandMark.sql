CREATE TABLE [dbo].[HotelLandMark] (
    [HotelLandMarkID] INT IDENTITY (1, 1) NOT NULL,
    [HotelID]         INT NOT NULL,
    [LandMarkID]      INT NOT NULL,
    CONSTRAINT [PK_HotelLandMark] PRIMARY KEY CLUSTERED ([HotelLandMarkID] ASC)
);


CREATE TABLE [dbo].[TransportRateZoneDetails] (
    [TransportRateZoneID] INT IDENTITY (1, 1) NOT NULL,
    [TransportRateID]     INT NOT NULL,
    [ZoneID]              INT NOT NULL,
    CONSTRAINT [PK_TransportRateZoneDetails] PRIMARY KEY CLUSTERED ([TransportRateZoneID] ASC)
);


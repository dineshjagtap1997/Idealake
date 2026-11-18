CREATE TABLE [dbo].[HotelRoomCancellation] (
    [CancellationID]  INT             IDENTITY (1, 1) NOT NULL,
    [HotelRateID]     INT             NOT NULL,
    [ValidFrom]       DATETIME        NOT NULL,
    [ValidTo]         DATETIME        NOT NULL,
    [TSStart]         INT             NOT NULL,
    [TSEnd]           INT             NOT NULL,
    [AgentStart]      INT             NOT NULL,
    [AgentEnd]        INT             NOT NULL,
    [ChargePercent]   NUMERIC (18, 2) NULL,
    [ChargeNight]     INT             NULL,
    [BookedNight]     INT             NULL,
    [IsActive]        BIT             NOT NULL,
    [BookedMaxNights] INT             NULL,
    [BookedMinNights] INT             NULL,
    CONSTRAINT [PK_HotelRoomCancellation_1] PRIMARY KEY CLUSTERED ([CancellationID] ASC)
);


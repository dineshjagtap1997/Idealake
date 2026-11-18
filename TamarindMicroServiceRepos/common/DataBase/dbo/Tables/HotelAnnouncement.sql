CREATE TABLE [dbo].[HotelAnnouncement] (
    [AnnouncementID]      INT           IDENTITY (1, 1) NOT NULL,
    [HotelID]             INT           NOT NULL,
    [HeaderID]            INT           NOT NULL,
    [AnnouncementDetails] VARCHAR (MAX) NOT NULL,
    [ValidTo]             DATETIME      NULL,
    CONSTRAINT [PK_HotelAnnouncement] PRIMARY KEY CLUSTERED ([AnnouncementID] ASC)
);


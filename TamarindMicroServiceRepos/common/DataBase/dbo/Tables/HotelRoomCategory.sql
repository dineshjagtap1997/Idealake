CREATE TABLE [dbo].[HotelRoomCategory] (
    [HotelRoomCategoryID]     INT      IDENTITY (1, 1) NOT NULL,
    [HotelID]                 INT      NOT NULL,
    [RoomCategoryID]          INT      NOT NULL,
    [NoOfRooms]               INT      NULL,
    [MaxAdult]                INT      NULL,
    [ExtraBedMattress]        TINYINT  NOT NULL,
    [IsInterconnecting]       TINYINT  NOT NULL,
    [NoOfInterconnectingRoom] SMALLINT NULL,
    [IsActive]                BIT      NOT NULL,
    [NoOfBedrooms]            INT      NULL,
    CONSTRAINT [PK_HotelRoomCategory] PRIMARY KEY CLUSTERED ([HotelRoomCategoryID] ASC)
);


GO
<<<<<<< HEAD
<<<<<<< HEAD
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
CREATE NONCLUSTERED INDEX [IX_HotelRoomCategory_RoomCategoryID]
    ON [dbo].[HotelRoomCategory]([HotelID] ASC, [RoomCategoryID] ASC, [IsActive] ASC);


GO
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0-NA,1-Bed,2-Mattress', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HotelRoomCategory', @level2type = N'COLUMN', @level2name = N'ExtraBedMattress';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0-No,1-Yes,2-TBA(ToBeAnnounced)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HotelRoomCategory', @level2type = N'COLUMN', @level2name = N'IsInterconnecting';


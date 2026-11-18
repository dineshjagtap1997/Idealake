CREATE TABLE [dbo].[HotelFactSheetInformation] (
    [FactSheetID]    INT IDENTITY (1, 1) NOT NULL,
    [HotelID]        INT NOT NULL,
    [FacilityInfoID] INT NOT NULL,
    [LandMarksID]    INT NOT NULL,
    CONSTRAINT [PK_HotelFactSheetInformation] PRIMARY KEY CLUSTERED ([FactSheetID] ASC)
);


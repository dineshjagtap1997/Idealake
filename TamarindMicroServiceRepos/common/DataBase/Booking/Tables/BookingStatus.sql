CREATE TABLE [Booking].[BookingStatus] (
    [StatusID]   INT           IDENTITY (1, 1) NOT NULL,
    [StatusName] VARCHAR (50)  NOT NULL,
    [StatusCode] INT           NOT NULL,
    [ColourCode] NVARCHAR (50) NULL
);


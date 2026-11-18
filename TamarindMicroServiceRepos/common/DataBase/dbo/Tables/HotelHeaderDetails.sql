CREATE TABLE [dbo].[HotelHeaderDetails] (
    [HotelHeaderID] INT              IDENTITY (1, 1) NOT NULL,
    [HotelID]       INT              NOT NULL,
    [HeaderID]      INT              NOT NULL,
    [Description]   VARCHAR (MAX)    NOT NULL,
    [UpdatedBy]     UNIQUEIDENTIFIER NULL,
    [UpdatedOn]     DATETIME         NULL,
    CONSTRAINT [PK_HotelHeaderDetails] PRIMARY KEY CLUSTERED ([HotelHeaderID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [idxhoteldetails]
    ON [dbo].[HotelHeaderDetails]([HotelID] ASC);


CREATE TABLE [dbo].[DestinationMaster] (
    [ID]          INT      IDENTITY (1, 1) NOT NULL,
    [CountryID]   INT      NULL,
    [StateID]     INT      NULL,
    [CityID]      INT      NULL,
    [CreatedDate] DATETIME DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


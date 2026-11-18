CREATE TABLE [Booking].[FileCodeCounter] (
    [ID]            INT           IDENTITY (1, 1) NOT NULL,
    [CompCode]      NVARCHAR (50) NOT NULL,
    [Year]          INT           NOT NULL,
    [Month]         INT           NOT NULL,
    [Counter]       INT           NOT NULL,
    [LastUpdatedOn] DATETIME      DEFAULT (getdate()) NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


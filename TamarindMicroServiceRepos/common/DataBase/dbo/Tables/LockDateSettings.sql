CREATE TABLE [dbo].[LockDateSettings] (
    [ID]           INT           IDENTITY (1, 1) NOT NULL,
    [Year]         VARCHAR (100) NOT NULL,
    [MonthID]      INT           NOT NULL,
    [LockTillDate] INT           NOT NULL,
    [CreatedDate]  DATETIME      DEFAULT (getdate()) NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


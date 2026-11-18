CREATE TABLE [Invoice].[AddendumSequence] (
    [ID]           INT          IDENTITY (1, 1) NOT NULL,
    [CompanyID]    VARCHAR (10) NOT NULL,
    [AddendumType] VARCHAR (2)  NOT NULL,
    [FiscalYear]   INT          NOT NULL,
    [MaxCounterID] INT          DEFAULT ((0)) NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


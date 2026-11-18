CREATE TABLE [dbo].[MealPlan] (
    [ID]          INT              IDENTITY (1, 1) NOT NULL,
    [Code]        VARCHAR (5)      NOT NULL,
    [Description] VARCHAR (500)    NULL,
    [Breakfast]   BIT              NOT NULL,
    [Lunch]       BIT              NOT NULL,
    [Dinner]      BIT              NOT NULL,
    [IsActive]    BIT              NOT NULL,
    [Operation]   VARCHAR (10)     NOT NULL,
    [OperationBy] UNIQUEIDENTIFIER NOT NULL,
    [OperationOn] DATETIME         DEFAULT (getdate()) NOT NULL,
    [OldID]       INT              NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 80)
);


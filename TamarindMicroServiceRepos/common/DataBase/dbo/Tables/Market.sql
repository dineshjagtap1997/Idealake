CREATE TABLE [dbo].[Market] (
    [ID]          INT              IDENTITY (1, 1) NOT NULL,
    [Name]        VARCHAR (50)     NOT NULL,
    [IsActive]    BIT              NOT NULL,
    [ABRV]        VARCHAR (10)     NULL,
    [Operation]   VARCHAR (10)     NOT NULL,
    [OperationBy] UNIQUEIDENTIFIER NOT NULL,
    [OperationOn] DATETIME         NOT NULL,
    [OldID]       VARCHAR (10)     NULL,
    [UpdatedBy]   UNIQUEIDENTIFIER NULL,
    [UpdatedOn]   DATETIME         NULL,
    CONSTRAINT [pk_market_id] PRIMARY KEY CLUSTERED ([ID] ASC)
);


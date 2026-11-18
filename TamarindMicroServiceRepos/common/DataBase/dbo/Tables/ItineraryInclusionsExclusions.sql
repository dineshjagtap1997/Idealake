CREATE TABLE [dbo].[ItineraryInclusionsExclusions] (
    [ID]               INT              IDENTITY (1, 1) NOT NULL,
    [Country_IATACode] VARCHAR (5)      NOT NULL,
    [City_IATACode]    VARCHAR (5)      NOT NULL,
    [Type]             VARCHAR (20)     NOT NULL,
    [Header]           VARCHAR (200)    NULL,
    [Description]      VARCHAR (MAX)    NULL,
    [IsActive]         BIT              NULL,
    [IsDefault]        BIT              NULL,
    [SeqNo]            VARCHAR (MAX)    NULL,
    [Operation]        VARCHAR (10)     NULL,
    [OperationBy]      UNIQUEIDENTIFIER NOT NULL,
    [OperationOn]      DATETIME         DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


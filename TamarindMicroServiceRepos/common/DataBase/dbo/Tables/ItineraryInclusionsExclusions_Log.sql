CREATE TABLE [dbo].[ItineraryInclusionsExclusions_Log] (
    [LogID]            INT              IDENTITY (1, 1) NOT NULL,
    [ItineraryID]      INT              NULL,
    [Country_IATACode] VARCHAR (5)      NULL,
    [City_IATACode]    VARCHAR (5)      NULL,
    [Type]             VARCHAR (20)     NULL,
    [Header]           VARCHAR (200)    NULL,
    [Description]      VARCHAR (MAX)    NULL,
    [IsActive]         BIT              NULL,
    [IsDefault]        BIT              NULL,
    [SeqNo]            VARCHAR (MAX)    NULL,
    [Operation]        VARCHAR (10)     NULL,
    [OperationBy]      UNIQUEIDENTIFIER NULL,
    [OperationOn]      DATETIME         DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([LogID] ASC)
);


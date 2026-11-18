CREATE TABLE [dbo].[HeaderMaster] (
    [HeaderID]    INT              IDENTITY (1, 1) NOT NULL,
    [HeaderCode]  VARCHAR (50)     NOT NULL,
    [HeaderValue] VARCHAR (50)     NOT NULL,
    [SequenceNo]  INT              NOT NULL,
    [IsActive]    BIT              NOT NULL,
    [Operation]   VARCHAR (10)     NOT NULL,
    [OperationBy] UNIQUEIDENTIFIER NOT NULL,
    [OperationOn] DATETIME         CONSTRAINT [DF_HeaderMaster_OperationOn] DEFAULT (getdate()) NOT NULL,
    [OldID]       INT              NULL,
    CONSTRAINT [PK_HeaderMaster] PRIMARY KEY CLUSTERED ([HeaderID] ASC)
);


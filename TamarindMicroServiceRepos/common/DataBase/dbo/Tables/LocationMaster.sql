CREATE TABLE [dbo].[LocationMaster] (
    [LocationID]    INT              IDENTITY (1, 1) NOT NULL,
    [LocationCode]  VARCHAR (50)     NOT NULL,
    [LocationValue] VARCHAR (50)     NOT NULL,
    [SequenceNo]    INT              NOT NULL,
    [IsActive]      BIT              NOT NULL,
    [Operation]     VARCHAR (10)     NOT NULL,
    [OperationBy]   UNIQUEIDENTIFIER NOT NULL,
    [OperationOn]   DATETIME         CONSTRAINT [DF_LocationMaster_OperationOn] DEFAULT (getdate()) NOT NULL,
    [OldID]         INT              NULL,
    CONSTRAINT [PK_LocationMaster] PRIMARY KEY CLUSTERED ([LocationID] ASC)
);


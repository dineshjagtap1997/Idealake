CREATE TABLE [dbo].[TransferMaster] (
    [TransferID]    INT              IDENTITY (1, 1) NOT NULL,
    [TransferCode]  VARCHAR (50)     NOT NULL,
    [TransferValue] VARCHAR (500)    NOT NULL,
    [SequenceNo]    INT              NOT NULL,
    [IsActive]      BIT              NOT NULL,
    [Operation]     VARCHAR (10)     NOT NULL,
    [OperationBy]   UNIQUEIDENTIFIER NOT NULL,
    [OperationOn]   DATETIME         CONSTRAINT [DF_TransferMaster_OperationOn] DEFAULT (getdate()) NOT NULL,
    [OldID]         INT              NULL,
    [UpdatedBy]     UNIQUEIDENTIFIER NULL,
    [UpdatedOn]     DATETIME         NULL,
    CONSTRAINT [PK_TransferMaster] PRIMARY KEY CLUSTERED ([TransferID] ASC)
);


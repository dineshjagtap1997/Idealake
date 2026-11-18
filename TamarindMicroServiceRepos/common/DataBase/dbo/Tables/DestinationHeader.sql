CREATE TABLE [dbo].[DestinationHeader] (
    [DestinationHeaderID]   INT              IDENTITY (1, 1) NOT NULL,
    [DestinationHeaderCode] VARCHAR (50)     NOT NULL,
    [DestinationHeader]     VARCHAR (50)     NOT NULL,
    [MISSequenceNo]         INT              NULL,
    [IsActive]              BIT              NOT NULL,
    [Operation]             VARCHAR (10)     NOT NULL,
    [OperationBy]           UNIQUEIDENTIFIER NOT NULL,
    [OperationOn]           DATETIME         NOT NULL,
    [OldID]                 INT              NULL,
    [UpdatedBy]             UNIQUEIDENTIFIER NULL,
    [UpdatedOn]             DATETIME         NULL,
    CONSTRAINT [PK_DestinationHeader] PRIMARY KEY CLUSTERED ([DestinationHeaderID] ASC)
);


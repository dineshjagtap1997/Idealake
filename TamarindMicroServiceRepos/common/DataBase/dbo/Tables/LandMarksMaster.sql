CREATE TABLE [dbo].[LandMarksMaster] (
    [LandMarkID]   INT              IDENTITY (1, 1) NOT NULL,
    [LandMarkName] VARCHAR (100)    NOT NULL,
    [IsActive]     BIT              NOT NULL,
    [Operation]    VARCHAR (10)     NOT NULL,
    [OperationBy]  UNIQUEIDENTIFIER NOT NULL,
    [OperationOn]  DATETIME         CONSTRAINT [DF_LandMarksMaster_OperationOn] DEFAULT (getdate()) NOT NULL,
    [OldID]        INT              NULL,
    [UpdatedBy]    UNIQUEIDENTIFIER NULL,
    [UpdatedOn]    DATETIME         NULL,
    CONSTRAINT [PK_LandMarksMaster] PRIMARY KEY CLUSTERED ([LandMarkID] ASC)
);


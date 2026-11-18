CREATE TABLE [dbo].[ClassType] (
    [ID]          INT              IDENTITY (1, 1) NOT NULL,
    [MOT]         INT              NOT NULL,
    [Class]       VARCHAR (50)     NOT NULL,
    [IsActive]    BIT              CONSTRAINT [DF_ClassType_IsActive] DEFAULT ((1)) NOT NULL,
    [Operation]   VARCHAR (10)     NOT NULL,
    [OperationBy] UNIQUEIDENTIFIER NOT NULL,
    [OperationOn] DATETIME         CONSTRAINT [DF_ClassType_OperationOn] DEFAULT (getdate()) NOT NULL,
    [OldID]       INT              NULL,
    [UpdatedBy]   UNIQUEIDENTIFIER NULL,
    [UpdatedOn]   DATETIME         NULL,
    CONSTRAINT [PK_ClassType] PRIMARY KEY CLUSTERED ([ID] ASC)
);


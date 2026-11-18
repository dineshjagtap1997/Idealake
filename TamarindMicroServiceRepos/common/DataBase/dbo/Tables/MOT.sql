CREATE TABLE [dbo].[MOT] (
    [ID]          INT              IDENTITY (1, 1) NOT NULL,
    [MOT]         VARCHAR (50)     NOT NULL,
    [IsActive]    BIT              CONSTRAINT [DF_MOT_IsActive] DEFAULT ((1)) NOT NULL,
    [Operation]   VARCHAR (10)     NOT NULL,
    [OperationBy] UNIQUEIDENTIFIER NOT NULL,
    [OperationOn] DATETIME         CONSTRAINT [DF_MOT_OperationOn] DEFAULT (getdate()) NOT NULL,
    [UpdatedBy]   UNIQUEIDENTIFIER NULL,
    [UpdatedOn]   DATETIME         NULL,
    CONSTRAINT [PK_MOT] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 80)
);


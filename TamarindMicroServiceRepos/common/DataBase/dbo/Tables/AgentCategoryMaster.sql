CREATE TABLE [dbo].[AgentCategoryMaster] (
    [CategoryID]    INT              IDENTITY (1, 1) NOT NULL,
    [CategoryCode]  VARCHAR (10)     NOT NULL,
    [CategoryValue] VARCHAR (50)     NOT NULL,
    [IsActive]      BIT              NOT NULL,
    [Operation]     VARCHAR (10)     NOT NULL,
    [OperationBy]   UNIQUEIDENTIFIER NOT NULL,
    [OperationOn]   DATETIME         CONSTRAINT [DF_AgentCategoryMaster_OperationOn] DEFAULT (getdate()) NOT NULL,
    [UpdatedBy]     UNIQUEIDENTIFIER NULL,
    [UpdatedDate]   DATETIME         NULL,
    CONSTRAINT [PK_AgentCategoryMaster] PRIMARY KEY CLUSTERED ([CategoryID] ASC)
);


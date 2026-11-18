CREATE TABLE [dbo].[AgentGroup] (
    [AgentGroupID]   INT              IDENTITY (1, 1) NOT NULL,
    [AgentGroupCode] VARCHAR (50)     NOT NULL,
    [AgentGroupName] VARCHAR (50)     NOT NULL,
    [IsActive]       BIT              NOT NULL,
    [Operation]      VARCHAR (10)     NOT NULL,
    [OperationBy]    UNIQUEIDENTIFIER NOT NULL,
    [OperationDate]  DATETIME         CONSTRAINT [DF_AgentGroup_OperationDate] DEFAULT (getdate()) NOT NULL,
    [OldID]          INT              NULL,
    CONSTRAINT [PK_AgentGroup] PRIMARY KEY CLUSTERED ([AgentGroupID] ASC)
);


CREATE TABLE [dbo].[AgentBranchMapping] (
    [AgentBranchID] INT           IDENTITY (1, 1) NOT NULL,
    [AgentID]       INT           NOT NULL,
    [BranchName]    VARCHAR (250) NOT NULL
);


CREATE TABLE [dbo].[tbl_lostEnquiry] (
    [ID]      BIGINT        IDENTITY (1, 1) NOT NULL,
    [EQID]    BIGINT        NULL,
    [LostID]  BIGINT        NULL,
    [AgentID] BIGINT        NULL,
    [Comment] VARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


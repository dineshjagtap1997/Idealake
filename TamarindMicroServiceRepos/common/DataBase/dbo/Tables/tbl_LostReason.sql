CREATE TABLE [dbo].[tbl_LostReason] (
    [ID]         BIGINT        IDENTITY (1, 1) NOT NULL,
    [LostReason] VARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


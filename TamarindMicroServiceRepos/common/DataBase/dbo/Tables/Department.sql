CREATE TABLE [dbo].[Department] (
    [ID]          INT              IDENTITY (1, 1) NOT NULL,
    [Dept_Name]   VARCHAR (50)     NOT NULL,
    [IsActive]    BIT              NOT NULL,
    [Operation]   VARCHAR (10)     NOT NULL,
    [OperationBy] UNIQUEIDENTIFIER NOT NULL,
    [OperationOn] DATETIME         NOT NULL,
    [OldID]       VARCHAR (100)    NULL,
    [UpdatedBy]   UNIQUEIDENTIFIER NULL,
    [UpdatedOn]   DATETIME         NULL,
    CONSTRAINT [PK_Department] PRIMARY KEY CLUSTERED ([ID] ASC)
);


CREATE TABLE [dbo].[Language] (
    [ID]          CHAR (2)         NOT NULL,
    [Language]    VARCHAR (50)     NOT NULL,
    [IsActive]    BIT              CONSTRAINT [DF_Language_IsActive] DEFAULT ((1)) NOT NULL,
    [Operation]   VARCHAR (10)     NOT NULL,
    [OperationBy] UNIQUEIDENTIFIER NOT NULL,
    [OperationOn] DATETIME         CONSTRAINT [DF_Language_OperationOn] DEFAULT (getdate()) NOT NULL,
    [OldID]       INT              NULL,
    [UpdatedBy]   UNIQUEIDENTIFIER NULL,
    [UpdatedOn]   DATETIME         NULL,
    CONSTRAINT [PK_Language] PRIMARY KEY CLUSTERED ([ID] ASC)
);


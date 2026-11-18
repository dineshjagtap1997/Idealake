CREATE TABLE [dbo].[Rules] (
    [ID]             INT              IDENTITY (1, 1) NOT NULL,
    [RuleGroupID]    INT              NOT NULL,
    [Header]         VARCHAR (50)     NOT NULL,
    [Description]    VARCHAR (500)    NULL,
    [IsActive]       BIT              CONSTRAINT [DF__Rules__IsActive__220B0B18] DEFAULT ((1)) NOT NULL,
    [IsMandatory]    BIT              CONSTRAINT [DF_Rules_IsMandatory] DEFAULT ((0)) NOT NULL,
    [Operation]      VARCHAR (10)     NOT NULL,
    [OperationBy]    UNIQUEIDENTIFIER NOT NULL,
    [OperationOn]    DATETIME         CONSTRAINT [DF__Rules__Operation__22FF2F51] DEFAULT (getdate()) NOT NULL,
    [OldID]          INT              NULL,
    [SequenceNo]     INT              NULL,
    [RuleHeaderType] INT              NULL,
    [UpdatedBy]      UNIQUEIDENTIFIER NULL,
    [UpdatedOn]      DATETIME         NULL,
    CONSTRAINT [PK__Rules__3214EC274D94879B] PRIMARY KEY CLUSTERED ([ID] ASC)
);


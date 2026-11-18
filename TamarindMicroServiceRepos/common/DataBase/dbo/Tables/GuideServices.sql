CREATE TABLE [dbo].[GuideServices] (
    [Code]                INT              IDENTITY (1, 1) NOT NULL,
    [Name]                VARCHAR (500)    NOT NULL,
    [ShortDescription]    VARCHAR (500)    NULL,
    [DetailedDescription] VARCHAR (MAX)    NULL,
    [IsActive]            BIT              NOT NULL,
    [Operation]           VARCHAR (10)     NOT NULL,
    [OperationBy]         UNIQUEIDENTIFIER NOT NULL,
    [OperationOn]         DATETIME         NOT NULL,
    [OldID]               VARCHAR (10)     NULL,
    [IsPreferred]         BIT              DEFAULT ((0)) NOT NULL,
    [UpdatedBy]           UNIQUEIDENTIFIER NULL,
    [UpdatedOn]           DATETIME         NULL,
    CONSTRAINT [PK_GuideServices] PRIMARY KEY CLUSTERED ([Code] ASC)
);


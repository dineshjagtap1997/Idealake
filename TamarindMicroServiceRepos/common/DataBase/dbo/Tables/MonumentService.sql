CREATE TABLE [dbo].[MonumentService] (
    [ID]                  INT              IDENTITY (1, 1) NOT NULL,
    [Name]                VARCHAR (200)    NOT NULL,
    [State_IATACode]      INT              NOT NULL,
    [City_IATACode]       CHAR (3)         NOT NULL,
    [Timing]              VARCHAR (50)     NULL,
    [ClosedOn]            VARCHAR (200)    NULL,
    [Holidays]            VARCHAR (200)    NULL,
    [Remarks]             VARCHAR (500)    NULL,
    [ShortDescription]    VARCHAR (200)    NULL,
    [DetailedDescription] VARCHAR (MAX)    NULL,
    [IsActive]            BIT              NOT NULL,
    [Operation]           VARCHAR (10)     NOT NULL,
    [OperationBy]         UNIQUEIDENTIFIER NOT NULL,
    [OperationOn]         DATETIME         NOT NULL,
    [OldID]               VARCHAR (50)     NULL,
    [IsPreferred]         BIT              DEFAULT ((0)) NOT NULL,
    [UpdatedBy]           UNIQUEIDENTIFIER NULL,
    [UpdatedOn]           DATETIME         NULL,
    CONSTRAINT [PK_MonumentService] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 80)
);


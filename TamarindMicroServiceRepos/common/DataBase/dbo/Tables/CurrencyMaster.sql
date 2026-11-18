CREATE TABLE [dbo].[CurrencyMaster] (
    [id]              INT              IDENTITY (1, 1) NOT NULL,
    [CurrencyCode]    VARCHAR (10)     NOT NULL,
    [Symbol]          VARCHAR (10)     NULL,
    [Effective_Date]  DATETIME         NULL,
    [Hedge_perc]      DECIMAL (10, 4)  NULL,
    [IsActive]        BIT              DEFAULT ((1)) NULL,
    [CreatedDateTime] DATETIME         DEFAULT (getdate()) NULL,
    [UpdatedDateTime] DATETIME         NULL,
    [Name]            VARCHAR (200)    NULL,
    [OperationBy]     UNIQUEIDENTIFIER NULL,
    [CreatedBy]       UNIQUEIDENTIFIER NULL,
    [UpdatedBy]       UNIQUEIDENTIFIER NULL,
    PRIMARY KEY CLUSTERED ([id] ASC),
    UNIQUE NONCLUSTERED ([CurrencyCode] ASC)
);


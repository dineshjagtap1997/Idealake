CREATE TABLE [RateCards].[CancellationPolicy] (
    [PolicyID]       BIGINT           IDENTITY (1, 1) NOT NULL,
    [RateCardTypeID] INT              NULL,
    [RateCardID]     BIGINT           NULL,
    [ValidFrom]      DATETIME         NULL,
    [ValidTo]        DATETIME         NULL,
    [TsStart]        VARCHAR (100)    NULL,
    [TsEnd]          VARCHAR (100)    NULL,
    [AgentStart]     VARCHAR (100)    NULL,
    [AgentEnd]       VARCHAR (100)    NULL,
    [ChangePercent]  VARCHAR (100)    NULL,
    [ChargeNight]    VARCHAR (100)    NULL,
    [IsActive]       BIT              DEFAULT ((1)) NULL,
    [CreatedBy]      UNIQUEIDENTIFIER DEFAULT (newid()) NULL,
    [UpdatedBy]      UNIQUEIDENTIFIER NULL,
    [CreatedOn]      DATETIME         DEFAULT (getdate()) NULL,
    [UpdatedOn]      DATETIME         NULL,
    PRIMARY KEY CLUSTERED ([PolicyID] ASC)
);


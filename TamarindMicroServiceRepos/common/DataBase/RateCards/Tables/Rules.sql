CREATE TABLE [RateCards].[Rules] (
    [ID]             BIGINT           IDENTITY (1, 1) NOT NULL,
    [RateCardTypeID] INT              NULL,
    [RateCardID]     BIGINT           NULL,
    [RuleID]         INT              NULL,
    [MISSeqeunce]    VARCHAR (40)     NULL,
    [ApplicableID]   INT              NULL,
    [Description]    VARCHAR (300)    NULL,
    [IsActive]       BIT              DEFAULT ((1)) NULL,
    [CreatedBy]      UNIQUEIDENTIFIER NULL,
    [ModifiedBy]     UNIQUEIDENTIFIER NULL,
    [CreateOn]       DATETIME         DEFAULT (getdate()) NULL,
    [ModifiedOn]     DATETIME         NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


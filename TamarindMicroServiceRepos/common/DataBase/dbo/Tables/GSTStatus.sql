CREATE TABLE [dbo].[GSTStatus] (
    [ID]            INT              IDENTITY (1, 1) NOT NULL,
    [State]         INT              NULL,
    [Status]        INT              NULL,
    [EffectiveDate] DATETIME         NULL,
    [CreatedDate]   DATETIME         NULL,
    [CreatedBy]     UNIQUEIDENTIFIER NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


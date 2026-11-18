CREATE TABLE [dbo].[YearMaster] (
    [YearID]      INT              IDENTITY (1, 1) NOT NULL,
    [YearCode]    VARCHAR (15)     NOT NULL,
    [CompanyID]   INT              NULL,
    [FromDate]    DATE             NOT NULL,
    [ToDate]      DATE             NOT NULL,
    [Old_ID]      INT              NULL,
    [FiscalYear]  BIGINT           NULL,
    [IsLocked]    BIT              NULL,
    [EntityID]    INT              NULL,
    [VID]         INT              NULL,
    [IsActive]    BIT              NULL,
    [OpreationBy] UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_YearMaster] PRIMARY KEY CLUSTERED ([YearID] ASC)
);


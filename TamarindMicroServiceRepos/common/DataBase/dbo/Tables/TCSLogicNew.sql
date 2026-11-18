CREATE TABLE [dbo].[TCSLogicNew] (
    [TCSLogicID]           BIGINT           IDENTITY (1, 1) NOT NULL,
    [BillingTo]            NVARCHAR (50)    NULL,
    [FromDate]             DATETIME         NULL,
    [ToDate]               DATETIME         NULL,
    [AgentMasterCountryIN] BIT              NULL,
    [AddressonRecord]      BIT              NULL,
    [TANonRecord]          BIT              NULL,
    [NonResident]          BIT              NULL,
    [TDSDeduction]         BIT              NULL,
    [PANExists]            BIT              NULL,
    [TCSRateID]            BIGINT           NULL,
    [Blockdetails]         NVARCHAR (50)    NULL,
    [IsActive]             BIT              NULL,
    [Operation]            NVARCHAR (10)    NULL,
    [CreatedBy]            UNIQUEIDENTIFIER NULL,
    [CreatedDate]          DATETIME         NULL,
    [UpdatedBy]            UNIQUEIDENTIFIER NULL,
    [Updateddate]          DATETIME         NULL,
    CONSTRAINT [PK_TCSLogicNew] PRIMARY KEY CLUSTERED ([TCSLogicID] ASC) WITH (FILLFACTOR = 80)
);


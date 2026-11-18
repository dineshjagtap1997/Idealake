CREATE TABLE [dbo].[TCSRateConfig] (
    [TCSRateConfigID]      BIGINT           IDENTITY (1, 1) NOT NULL,
    [BillingTo]            NVARCHAR (50)    NOT NULL,
    [FromDate]             DATETIME         NOT NULL,
    [ToDate]               DATETIME         NOT NULL,
    [PANExists]            BIT              NULL,
    [AddressonRecord]      BIT              NULL,
    [AgentMasterCountryIN] BIT              NULL,
    [Resident]             BIT              NULL,
    [TCSRateID]            BIGINT           NULL,
    [ViewDetailsID]        INT              NULL,
    [IsActive]             BIT              NULL,
    [Operation]            NVARCHAR (10)    NULL,
    [CreatedBy]            UNIQUEIDENTIFIER NULL,
    [CreatedDate]          DATETIME         NULL,
    [UpdatedBy]            UNIQUEIDENTIFIER NULL,
    [Updateddate]          DATETIME         NULL,
    [TDSDeduction]         BIT              NULL,
    CONSTRAINT [PK_TCSRateConfig] PRIMARY KEY CLUSTERED ([TCSRateConfigID] ASC)
);


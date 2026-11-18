CREATE TABLE [RateCards].[TransportRateCommissionDetails] (
    [TransportCommissionDetailID] BIGINT           IDENTITY (1, 1) NOT NULL,
    [TransportRateDetailID]       BIGINT           NULL,
    [CommissionMasterID]          INT              NULL,
    [IsAmtIncludedInBasic]        BIT              DEFAULT ((0)) NULL,
    [TaxPercentage]               DECIMAL (18, 2)  NULL,
    [TaxAmount]                   DECIMAL (18, 2)  NULL,
    [NetAmountExcludingTax]       DECIMAL (18, 2)  NULL,
    [NetAmountIncludingTax]       DECIMAL (18, 2)  NULL,
    [IsActive]                    BIT              DEFAULT ((1)) NULL,
    [CreatedBy]                   UNIQUEIDENTIFIER DEFAULT (newid()) NULL,
    [CreatedOn]                   DATETIME         DEFAULT (getdate()) NULL,
    [UpdatedBy]                   UNIQUEIDENTIFIER NULL,
    [UpdatedOn]                   DATETIME         NULL,
    PRIMARY KEY CLUSTERED ([TransportCommissionDetailID] ASC)
);


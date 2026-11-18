CREATE TABLE [RateCards].[MonumentRateCommissionDetails] (
    [MonumentCommissionDetailID] BIGINT           IDENTITY (1, 1) NOT NULL,
    [CommissionMasterID]         INT              NULL,
    [TaxPercentage]              DECIMAL (18, 2)  NULL,
    [TaxAmount]                  DECIMAL (18, 2)  NULL,
    [NetAmountIncludingTax]      DECIMAL (18, 2)  NULL,
    [NetAmountExcludingTax]      DECIMAL (18, 2)  NULL,
    [IsActive]                   BIT              DEFAULT ((1)) NULL,
    [CreatedBy]                  UNIQUEIDENTIFIER NULL,
    [UpdatedBy]                  UNIQUEIDENTIFIER NULL,
    [CreatedOn]                  DATETIME         NULL,
    [UpdatedOn]                  DATETIME         NULL,
    [MonumentDetailID]           BIGINT           NULL,
    PRIMARY KEY CLUSTERED ([MonumentCommissionDetailID] ASC)
);


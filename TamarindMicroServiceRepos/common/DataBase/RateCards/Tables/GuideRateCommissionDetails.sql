CREATE TABLE [RateCards].[GuideRateCommissionDetails] (
    [GuideRateCommissionID] BIGINT           IDENTITY (1, 1) NOT NULL,
    [GuideRateDetailID]     BIGINT           NULL,
    [TaxPercentage]         DECIMAL (18, 2)  NULL,
    [TaxAmount]             DECIMAL (18, 2)  NULL,
    [NetAmountIncludingTax] DECIMAL (18, 2)  NULL,
    [NetAmountExcludingTax] DECIMAL (18, 2)  NULL,
    [PaxMinimum]            INT              NULL,
    [PaxMaximum]            INT              NULL,
    [IsActive]              BIT              DEFAULT ((1)) NULL,
    [CreatedOn]             DATETIME         NULL,
    [UpdatedOn]             DATETIME         NULL,
    [UpdatedBy]             UNIQUEIDENTIFIER NULL,
    [CreatedBy]             UNIQUEIDENTIFIER NULL,
    PRIMARY KEY CLUSTERED ([GuideRateCommissionID] ASC)
);


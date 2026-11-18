CREATE TABLE [RateCards].[SpecialServiceRateCommissionDeatils] (
    [ID]                             UNIQUEIDENTIFIER DEFAULT (newid()) NULL,
    [SpecialServiceRateCommissionID] BIGINT           IDENTITY (1, 1) NOT NULL,
    [MinimumPax]                     INT              NULL,
    [MaximumPax]                     INT              NULL,
    [TaxPercentage]                  DECIMAL (18, 2)  NULL,
    [TaxAmount]                      DECIMAL (18, 2)  NULL,
    [NetAmountIncludingTax]          DECIMAL (18, 2)  NULL,
    [NetAmountExcludingTax]          DECIMAL (18, 2)  NULL,
    [IsActive]                       BIT              DEFAULT ((1)) NULL,
    [CreatedBy]                      UNIQUEIDENTIFIER DEFAULT (newid()) NULL,
    [UpdatedBy]                      UNIQUEIDENTIFIER DEFAULT (newid()) NULL,
    [CreatedOn]                      DATETIME         DEFAULT (getdate()) NULL,
    [UpdatedOn]                      DATETIME         DEFAULT (getdate()) NULL,
    [SpecialServiceRateDetailID]     BIGINT           NULL,
    [CommissionMasterID]             INT              NULL,
    PRIMARY KEY CLUSTERED ([SpecialServiceRateCommissionID] ASC)
);


CREATE TABLE [RateCards].[RateCommisionDetails] (
    [RateCommisionID]         BIGINT           IDENTITY (1, 1) NOT NULL,
    [CommissionMasterID]      INT              NULL,
    [TaxPercentage]           DECIMAL (18, 2)  DEFAULT ((0)) NOT NULL,
    [TaxAmount]               DECIMAL (18, 2)  NULL,
    [GrossAmountIncludingTax] DECIMAL (18, 2)  NULL,
    [GrossAmountExcludingTax] DECIMAL (18, 2)  NULL,
    [CommisionPercentage]     DECIMAL (18, 2)  NULL,
    [CommissionAmount]        DECIMAL (18, 2)  NULL,
    [NetAmountExcludingTax]   DECIMAL (18, 2)  NULL,
    [NetAmountIncludingTax]   DECIMAL (18, 2)  NULL,
    [HotelRateDetailID]       BIGINT           NULL,
    [IsTax]                   BIT              DEFAULT ((0)) NOT NULL,
    [CreatedOn]               DATETIME         NULL,
    [UpdatedOn]               DATETIME         NULL,
    [IsActive]                BIT              DEFAULT ((0)) NULL,
    [UpdatedBy]               UNIQUEIDENTIFIER NULL,
    [CreatedBy]               UNIQUEIDENTIFIER NULL,
    PRIMARY KEY CLUSTERED ([RateCommisionID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_RateCommisionDetails_DetailID_Active]
    ON [RateCards].[RateCommisionDetails]([HotelRateDetailID] ASC, [IsActive] ASC);


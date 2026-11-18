CREATE TABLE [CustomRateCards].[HotelRateCommisionDetails] (
    [RateCommisionID]         BIGINT           IDENTITY (1, 1) NOT NULL,
    [CommissionMasterID]      INT              NULL,
    [NetAmountExcludingTax]   DECIMAL (18, 2)  NULL,
    [NetAmountIncludingTax]   DECIMAL (18, 2)  NULL,
    [GrossAmountIncludingTax] DECIMAL (18, 2)  NULL,
    [GrossAmountExcludingTax] DECIMAL (18, 2)  NULL,
    [CommisionPercentage]     DECIMAL (18, 2)  NULL,
    [CommissionAmount]        DECIMAL (18, 2)  NULL,
    [IsTax]                   BIT              DEFAULT ((0)) NOT NULL,
    [TaxPercentage]           DECIMAL (18, 2)  DEFAULT ((0)) NOT NULL,
    [TaxAmount]               DECIMAL (18, 2)  NULL,
    [HotelRateID]             BIGINT           NULL,
    [CreatedOn]               DATETIME         NULL,
    [UpdatedOn]               DATETIME         NULL,
    [IsActive]                BIT              DEFAULT ((0)) NULL,
    [UpdatedBy]               UNIQUEIDENTIFIER NULL,
    [CreatedBy]               UNIQUEIDENTIFIER NULL,
    [IsAmtIncludedInBasic]    BIT              NULL,
    [MinimumPax]              INT              NULL,
    [MaximumPax]              INT              NULL,
    PRIMARY KEY CLUSTERED ([RateCommisionID] ASC)
);


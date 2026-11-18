CREATE TABLE [Quotation].[HotelRateOfferConfigurationCommission] (
    [OfferCommissionID]           BIGINT          IDENTITY (1, 1) NOT NULL,
    [OfferConfigurationID]        BIGINT          NULL,
    [MasterCommissionID]          INT             NULL,
    [Discount]                    DECIMAL (18, 2) NULL,
    [DiscountAmount]              DECIMAL (18, 2) NULL,
    [Tax]                         DECIMAL (18, 2) NULL,
    [TaxAmount]                   DECIMAL (18, 2) NULL,
    [PaidNightAmountExcludingTax] DECIMAL (18, 2) NULL,
    [PaidNightAmountIncludingTax] DECIMAL (18, 2) NULL,
    [FreeNightAmountExcludingTax] DECIMAL (18, 2) NULL,
    [FreeNightAmountIncludingTax] DECIMAL (18, 2) NULL,
    [GrossAmountExcludingTax]     DECIMAL (18, 2) NULL,
    [GrossAmountIncludingTax]     DECIMAL (18, 2) NULL,
    [NetAmountExcludingTax]       DECIMAL (18, 2) NULL,
    [NetAmountIncludingTax]       DECIMAL (18, 2) NULL,
    [IsActive]                    BIT             DEFAULT ((1)) NULL,
    [IsDeleted]                   BIT             NULL,
    [QuotationHotelRateID]        INT             NULL,
    PRIMARY KEY CLUSTERED ([OfferCommissionID] ASC)
);


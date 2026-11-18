CREATE TABLE [Quotation].[RateValidityMaster] (
    [QuotationRateValidityID] BIGINT           IDENTITY (1, 1) NOT NULL,
    [RateValidityID]          BIGINT           NULL,
    [QuotationHotelRateID]    BIGINT           NULL,
    [BookFrom]                DATETIME         NULL,
    [BookTo]                  DATETIME         NULL,
    [RateValidFrom]           DATETIME         NOT NULL,
    [RateValidTo]             DATETIME         NOT NULL,
    [HotelRateDetailID]       BIGINT           NULL,
    [CreatedOn]               DATETIME         NULL,
    [UpdatedOn]               DATETIME         NULL,
    [IsActive]                BIT              NULL,
    [UpdatedBy]               UNIQUEIDENTIFIER NULL,
    [CreatedBy]               UNIQUEIDENTIFIER NULL,
    [QuotationId]             BIGINT           NULL,
    PRIMARY KEY CLUSTERED ([QuotationRateValidityID] ASC)
);


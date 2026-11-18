CREATE TABLE [Quotation].[HotelRateOfferConfiguration] (
    [OfferID]              BIGINT   IDENTITY (1, 1) NOT NULL,
    [HotelRateDetailID]    BIGINT   NULL,
    [Days]                 INT      NULL,
    [FromDate]             DATETIME NULL,
    [ToDate]               DATETIME NULL,
    [TotalNights]          INT      NULL,
    [PaidNights]           INT      NULL,
    [FreeNights]           INT      NULL,
    [IsExtendible]         BIT      NULL,
    [IsActive]             BIT      DEFAULT ((1)) NULL,
    [IsDeleted]            BIT      NULL,
    [QuotationHotelRateID] INT      NULL,
    PRIMARY KEY CLUSTERED ([OfferID] ASC)
);


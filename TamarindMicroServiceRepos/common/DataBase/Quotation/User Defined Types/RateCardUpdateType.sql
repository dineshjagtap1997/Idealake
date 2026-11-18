CREATE TYPE [Quotation].[RateCardUpdateType] AS TABLE (
    [QuotationRateCardId]  INT NULL,
    [ShowAnnouncement]     BIT NULL,
    [ShowTransfers]        BIT NULL,
    [ShowValueAddOns]      BIT NULL,
    [ShowCancellationDays] BIT NULL);


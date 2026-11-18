CREATE TYPE [dbo].[TransportCommissionTableType] AS TABLE (
    [TransportCommissionDetailID] BIGINT          NULL,
    [TransportRateDetailID]       BIGINT          NULL,
    [CommissionMasterID]          BIGINT          NULL,
    [SellingRates]                DECIMAL (18, 2) NULL,
    [GrossRate]                   DECIMAL (18, 2) NULL,
    [Markup_IsRate]               BIT             NULL,
    [MarkupRate]                  DECIMAL (18, 2) NULL,
    [OthersRateCardCommissionID]  BIGINT          NULL);


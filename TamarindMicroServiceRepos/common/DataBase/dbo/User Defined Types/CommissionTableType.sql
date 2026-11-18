CREATE TYPE [dbo].[CommissionTableType] AS TABLE (
    [MonumentCommissionDetailID] BIGINT          NULL,
    [MonumentDetailID]           BIGINT          NULL,
    [CommissionMasterID]         BIGINT          NULL,
    [SellingRates]               DECIMAL (18, 2) NULL,
    [GrossRate]                  DECIMAL (18, 2) NULL,
    [Markup_IsRate]              BIT             NULL,
    [MarkupRate]                 DECIMAL (18, 2) NULL,
    [OthersRateCardCommissionID] BIGINT          NULL,
    [AdultReasonId]              INT             NULL,
    [ChildReasonId]              INT             NULL);


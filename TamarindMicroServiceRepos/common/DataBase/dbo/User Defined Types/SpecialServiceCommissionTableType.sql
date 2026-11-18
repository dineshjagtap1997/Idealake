CREATE TYPE [dbo].[SpecialServiceCommissionTableType] AS TABLE (
    [SpecialCommissionDetailID]  BIGINT          NULL,
    [SpecialDetailID]            BIGINT          NULL,
    [CommissionMasterID]         BIGINT          NULL,
    [SellingRates]               DECIMAL (18, 2) NULL,
    [GrossRate]                  DECIMAL (18, 2) NULL,
    [Markup_IsRate]              BIT             NULL,
    [MarkupRate]                 DECIMAL (18, 2) NULL,
    [OthersRateCardCommissionID] BIGINT          NULL);


CREATE TYPE [dbo].[CurrencyConversionTableType] AS TABLE (
    [FromCurrencyId]  INT             NULL,
    [ToCurrencyId]    INT             NULL,
    [Actual_Value]    DECIMAL (10, 4) NULL,
    [Hedge_Perc]      DECIMAL (5, 2)  NULL,
    [EffectiveDate]   DATETIME        NULL,
    [Purchase_Value]  DECIMAL (10, 4) NULL,
    [Sales_Value]     DECIMAL (10, 4) NULL,
    [CreatedBy]       INT             NULL,
    [CreatedDateTime] DATETIME        NULL,
    [UpdatedBy]       INT             NULL,
    [UpdatedDateTime] DATETIME        NULL,
    [Action]          VARCHAR (10)    NULL);


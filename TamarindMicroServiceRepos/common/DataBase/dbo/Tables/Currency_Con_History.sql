CREATE TABLE [dbo].[Currency_Con_History] (
    [id]              INT             IDENTITY (1, 1) NOT NULL,
    [FromCurrencyId]  INT             NOT NULL,
    [ToCurrencyId]    INT             NOT NULL,
    [Actual_Value]    DECIMAL (10, 4) NULL,
    [Hedge_Perc]      DECIMAL (5, 2)  NULL,
    [EffectiveDate]   DATETIME        DEFAULT (getdate()) NOT NULL,
    [Purchase_Value]  DECIMAL (10, 4) NULL,
    [Sales_Value]     DECIMAL (10, 4) NULL,
    [CreatedBy]       INT             NULL,
    [CreatedDateTime] DATETIME        DEFAULT (getdate()) NULL,
    [UpdatedBy]       INT             NULL,
    [UpdatedDateTime] DATETIME        NULL,
    PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_Currency_Hist_From] FOREIGN KEY ([FromCurrencyId]) REFERENCES [dbo].[CurrencyMaster] ([id]),
    CONSTRAINT [FK_Currency_Hist_To] FOREIGN KEY ([ToCurrencyId]) REFERENCES [dbo].[CurrencyMaster] ([id])
);


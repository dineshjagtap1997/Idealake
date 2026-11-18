CREATE TABLE [dbo].[Currency_Con_Tab] (
    [id]              INT             IDENTITY (1, 1) NOT NULL,
    [FromCurrencyId]  INT             NOT NULL,
    [ToCurrencyId]    INT             NOT NULL,
    [Hedge_Perc]      DECIMAL (5, 2)  NULL,
    [Actual_Value]    DECIMAL (10, 4) NULL,
    [EffectiveDate]   DATETIME        DEFAULT (getdate()) NULL,
    [Purchase_Value]  DECIMAL (10, 4) NULL,
    [Sales_Value]     DECIMAL (10, 4) NULL,
    [CreatedBy]       INT             NULL,
    [CreatedDateTime] DATETIME        DEFAULT (getdate()) NULL,
    [UpdatedBy]       INT             NULL,
    [UpdatedDateTime] DATETIME        NULL,
    PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_Currency_Con_From] FOREIGN KEY ([FromCurrencyId]) REFERENCES [dbo].[CurrencyMaster] ([id]),
    CONSTRAINT [FK_Currency_Con_To] FOREIGN KEY ([ToCurrencyId]) REFERENCES [dbo].[CurrencyMaster] ([id])
);


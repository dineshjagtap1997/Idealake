CREATE TABLE [dbo].[CurrencyConversion_N] (
    [ID]               INT              IDENTITY (1, 1) NOT NULL,
    [CCParentID]       INT              NOT NULL,
    [FromCurrency]     VARCHAR (5)      NOT NULL,
    [ToCurrency]       VARCHAR (5)      NOT NULL,
    [FromDate]         DATETIME         NOT NULL,
    [ToDate]           DATETIME         NOT NULL,
    [PurchaseRate_FTI] DECIMAL (18, 5)  NOT NULL,
    [PurchaseRate_ITF] DECIMAL (18, 5)  NOT NULL,
    [SalesRate_FTI]    DECIMAL (18, 5)  NOT NULL,
    [SalesRate_ITF]    DECIMAL (18, 5)  NOT NULL,
    [CostingRate_FTI]  DECIMAL (18, 5)  NOT NULL,
    [CostingRate_ITF]  DECIMAL (18, 5)  NOT NULL,
    [IsActive]         BIT              NOT NULL,
    [Operation]        VARCHAR (10)     NOT NULL,
    [OperationBy]      UNIQUEIDENTIFIER NOT NULL,
    [OperationOn]      DATETIME         NOT NULL,
    [UpdatedBy]        UNIQUEIDENTIFIER NULL,
    [UpdatedOn]        DATETIME         NULL,
    CONSTRAINT [PK_CurrencyConversion_N] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 80)
);


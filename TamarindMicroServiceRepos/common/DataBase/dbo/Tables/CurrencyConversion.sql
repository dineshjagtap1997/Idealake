CREATE TABLE [dbo].[CurrencyConversion] (
    [ID]           INT              IDENTITY (1, 1) NOT NULL,
    [FromCurrency] VARCHAR (5)      NOT NULL,
    [ToCurrency]   VARCHAR (5)      NOT NULL,
    [FromDate]     DATE             NOT NULL,
    [ToDate]       DATE             NOT NULL,
    [PurchaseRate] DECIMAL (18, 4)  NOT NULL,
    [SalesRate]    DECIMAL (18, 4)  NOT NULL,
    [CostingRate]  DECIMAL (18, 4)  NOT NULL,
    [IsActive]     BIT              NOT NULL,
    [Operation]    VARCHAR (10)     NOT NULL,
    [OperationBy]  UNIQUEIDENTIFIER NOT NULL,
    [OperationOn]  DATETIME         NOT NULL,
    [UpdatedBy]    UNIQUEIDENTIFIER NULL,
    [UpdatedOn]    DATETIME         NULL,
    CONSTRAINT [PK__Currency__3214EC270FEC5ADD] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 80)
);


CREATE TABLE [dbo].[CurrencyConversion_Log] (
    [ID]               INT              NOT NULL,
    [CCParentID]       INT              NOT NULL,
    [FromCurrency]     VARCHAR (5)      NOT NULL,
    [ToCurrency]       VARCHAR (5)      NOT NULL,
    [FromDate]         DATE             NOT NULL,
    [ToDate]           DATE             NOT NULL,
    [PurchaseRate_FTI] DECIMAL (18, 4)  NOT NULL,
    [PurchaseRate_ITF] DECIMAL (18, 4)  NOT NULL,
    [SalesRate_FTI]    DECIMAL (18, 4)  NOT NULL,
    [SalesRate_ITF]    DECIMAL (18, 5)  NOT NULL,
    [CostingRate_FTI]  DECIMAL (18, 4)  NOT NULL,
    [CostingRate_ITF]  DECIMAL (18, 5)  NOT NULL,
    [IsActive]         BIT              NOT NULL,
    [Operation]        VARCHAR (10)     NOT NULL,
    [OperationBy]      UNIQUEIDENTIFIER NOT NULL,
    [OperationOn]      DATETIME         NOT NULL
);


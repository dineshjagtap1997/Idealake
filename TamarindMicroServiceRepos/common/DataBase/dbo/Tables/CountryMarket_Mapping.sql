CREATE TABLE [dbo].[CountryMarket_Mapping] (
    [ID]               INT              IDENTITY (1, 1) NOT NULL,
    [Country_IATACode] CHAR (4)         NOT NULL,
    [CountryName]      VARCHAR (50)     NOT NULL,
    [Market_ID]        INT              NOT NULL,
    [MarketName]       VARCHAR (50)     NOT NULL,
    [IsActive]         BIT              NOT NULL,
    [Operation]        VARCHAR (10)     NOT NULL,
    [OperationBy]      UNIQUEIDENTIFIER NOT NULL,
    [OperationOn]      DATETIME         NOT NULL,
    [UpdatedBy]        UNIQUEIDENTIFIER NULL,
    [UpdatedOn]        DATETIME         NULL,
    CONSTRAINT [PK_CountryMarket_Mapping] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 80)
);


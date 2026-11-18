CREATE TABLE [dbo].[MonumentRateMaster] (
    [MonumentRateID] INT              IDENTITY (1, 1) NOT NULL,
    [MonumentCardNo] VARCHAR (15)     NOT NULL,
    [RateCardMode]   TINYINT          NOT NULL,
    [Heading]        VARCHAR (200)    NULL,
    [ContractDate]   DATETIME         NOT NULL,
    [CityIATACode]   CHAR (3)         NOT NULL,
    [VendorID]       INT              NOT NULL,
    [CurrencyID]     VARCHAR (5)      NOT NULL,
    [MonumentID]     INT              NOT NULL,
    [InfoForOps]     VARCHAR (500)    NULL,
    [InfoForAgents]  VARCHAR (500)    NULL,
    [InfoForXO]      VARCHAR (500)    NULL,
    [Notes]          VARCHAR (500)    NULL,
    [IsActive]       BIT              NOT NULL,
    [Operation]      VARCHAR (10)     NOT NULL,
    [OperationBy]    UNIQUEIDENTIFIER NOT NULL,
    [OperationOn]    DATETIME         CONSTRAINT [DF_MonumentRateMaster_OperationOn] DEFAULT (getdate()) NOT NULL,
    [OldID]          INT              NULL,
    CONSTRAINT [PK_MonumentRateMaster] PRIMARY KEY CLUSTERED ([MonumentRateID] ASC) WITH (FILLFACTOR = 80)
);


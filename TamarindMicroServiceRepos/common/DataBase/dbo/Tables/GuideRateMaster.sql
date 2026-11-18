CREATE TABLE [dbo].[GuideRateMaster] (
    [GuideRateID]   INT              IDENTITY (1, 1) NOT NULL,
    [GuideCardNo]   VARCHAR (15)     NOT NULL,
    [RateCardMode]  TINYINT          NOT NULL,
    [Heading]       VARCHAR (100)    NOT NULL,
    [ContractDate]  DATETIME         NOT NULL,
    [CityIATACode]  CHAR (3)         NOT NULL,
    [VendorID]      INT              NOT NULL,
    [CurrencyID]    VARCHAR (5)      NOT NULL,
    [GuideCode]     INT              NULL,
    [LanguageID]    CHAR (2)         NULL,
    [InfoForOps]    VARCHAR (MAX)    NULL,
    [InfoForAgents] VARCHAR (MAX)    NULL,
    [InfoForXO]     VARCHAR (MAX)    NULL,
    [Notes]         VARCHAR (MAX)    NULL,
    [IsActive]      BIT              NOT NULL,
    [Operation]     VARCHAR (10)     NOT NULL,
    [OperationBy]   UNIQUEIDENTIFIER NOT NULL,
    [OperationOn]   DATETIME         CONSTRAINT [DF_GuideRateMaster_OperationOn] DEFAULT (getdate()) NOT NULL,
    [OldID]         INT              NULL,
    CONSTRAINT [PK_GuideRateMaster] PRIMARY KEY CLUSTERED ([GuideRateID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'(1-Contract,2-Adhoc,3-Negotiated)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'GuideRateMaster', @level2type = N'COLUMN', @level2name = N'RateCardMode';


CREATE TABLE [dbo].[QuotationXOMap] (
    [QuotationXOMapID] INT          NOT NULL,
    [QuotationID]      VARCHAR (25) NOT NULL,
    [ServiceTypeID]    TINYINT      NOT NULL,
    [QuotationItemID]  INT          NOT NULL,
    [XOID]             VARCHAR (50) NOT NULL,
    [XOYearCode]       INT          NOT NULL
);


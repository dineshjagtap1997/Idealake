CREATE TABLE [Quotation].[QuotationStatus] (
    [StatusID]   INT           IDENTITY (1, 1) NOT NULL,
    [StatusName] VARCHAR (50)  NOT NULL,
    [StatusCode] INT           DEFAULT ((0)) NOT NULL,
    [ColourCode] NVARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([StatusID] ASC)
);


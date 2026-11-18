CREATE TABLE [Quotation].[QuotationMaster] (
    [QuotationID]       BIGINT           IDENTITY (1, 1) NOT NULL,
    [QuotationNo]       NVARCHAR (50)    NOT NULL,
    [EnquiryID]         BIGINT           NULL,
    [Status]            INT              NOT NULL,
    [TaxonSale]         INT              NULL,
    [ParentID]          INT              NULL,
    [Disclaimer]        NVARCHAR (500)   NULL,
    [BookingID]         BIGINT           NULL,
    [CreatedBy]         UNIQUEIDENTIFIER NULL,
    [UpdatedBy]         UNIQUEIDENTIFIER NULL,
    [UpdatedDate]       DATETIME         NULL,
    [CompanyID]         INT              NULL,
    [TaxType]           BIT              CONSTRAINT [DF_QuotationMaster_TaxType] DEFAULT ((0)) NULL,
    [Currency]          INT              NULL,
    [YearID]            INT              NULL,
    [CreatedDate]       DATETIME         NULL,
    [RateCardMode]      NVARCHAR (15)    NULL,
    [ParentQuotationID] INT              NULL,
    [AgentName]         NVARCHAR (200)   NULL,
    [QuotationSequence] INT              NULL
);


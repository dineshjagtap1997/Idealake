CREATE TABLE [dbo].[QuotationMasterNew] (
    [QuotationID]     BIGINT           IDENTITY (1, 1) NOT NULL,
    [QuotationNo]     NVARCHAR (50)    NOT NULL,
    [EnquiryID]       BIGINT           NULL,
    [CreatedDate]     DATE             DEFAULT (getdate()) NOT NULL,
    [Status]          INT              NOT NULL,
    [Currency]        INT              NOT NULL,
    [TaxType]         BIT              NULL,
    [TaxonSale]       INT              NULL,
    [ParentID]        INT              NULL,
    [Disclaimer]      NVARCHAR (500)   NULL,
    [BookingID]       BIGINT           NULL,
    [CreatedBy]       UNIQUEIDENTIFIER NULL,
    [ModifiedBy]      UNIQUEIDENTIFIER NULL,
    [ModifiedDate]    DATETIME         NULL,
    [OperationBy]     UNIQUEIDENTIFIER NULL,
    [Action]          CHAR (2)         NULL,
    [VersionComment]  NVARCHAR (200)   NULL,
    [VersionSequence] VARCHAR (10)     NULL,
    PRIMARY KEY CLUSTERED ([QuotationID] ASC)
);


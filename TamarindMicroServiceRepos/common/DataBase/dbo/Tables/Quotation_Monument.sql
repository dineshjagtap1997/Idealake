CREATE TABLE [dbo].[Quotation_Monument] (
    [QuotationMonumentID] INT              IDENTITY (1, 1) NOT NULL,
    [QuotationID]         VARCHAR (25)     NOT NULL,
    [ItineraryDay]        INT              NOT NULL,
    [ItineraryDate]       DATETIME         NULL,
    [RateDetailsID]       UNIQUEIDENTIFIER NULL,
    [CityCode]            CHAR (3)         NOT NULL,
    [ServiceTypeID]       INT              NOT NULL,
    [MonumentServiceID]   INT              NOT NULL,
    [NationalityID]       INT              NOT NULL,
    [VendorID]            INT              NULL,
    [NoofAdult]           INT              NOT NULL,
    [AdultCost]           NUMERIC (18, 2)  NOT NULL,
    [NoofChild]           INT              NOT NULL,
    [ChildCost]           NUMERIC (18, 2)  NOT NULL,
    [MonumentSubTotal]    NUMERIC (18, 2)  NOT NULL,
    [Remarks]             VARCHAR (200)    NULL,
    [OldID]               INT              NULL,
    [StateCodeID]         INT              NULL,
    CONSTRAINT [PK_Quotation_Monument] PRIMARY KEY CLUSTERED ([QuotationMonumentID] ASC)
);


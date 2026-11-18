CREATE TABLE [dbo].[Quotation_Guide] (
    [QuotationGuideID] INT              IDENTITY (1, 1) NOT NULL,
    [QuotationID]      VARCHAR (25)     NOT NULL,
    [ItineraryDay]     INT              NOT NULL,
    [ItineraryDate]    DATETIME         NULL,
    [RateDetailsID]    UNIQUEIDENTIFIER NULL,
    [CityCode]         CHAR (3)         NOT NULL,
    [ServiceTypeID]    INT              NOT NULL,
    [GuideServiceID]   INT              NOT NULL,
    [LanguageID]       CHAR (2)         NOT NULL,
    [VendorID]         INT              NULL,
    [NoOfGuides]       INT              NOT NULL,
    [GuideCost]        NUMERIC (18, 2)  NOT NULL,
    [GuideSubTotal]    NUMERIC (18, 2)  NOT NULL,
    [Remarks]          VARCHAR (500)    NULL,
    [OldID]            INT              NULL,
    [StateCodeID]      INT              NULL,
    CONSTRAINT [PK_Quotation_Guide] PRIMARY KEY CLUSTERED ([QuotationGuideID] ASC)
);


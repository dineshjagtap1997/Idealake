CREATE TABLE [dbo].[Quotation_Special] (
    [QuotationSpecialID]   INT              IDENTITY (1, 1) NOT NULL,
    [QuotationID]          VARCHAR (25)     NOT NULL,
    [ItineraryDay]         INT              NOT NULL,
    [ItineraryDate]        DATETIME         NULL,
    [RateDetailsID]        UNIQUEIDENTIFIER NULL,
    [CityCode]             CHAR (3)         NOT NULL,
    [ServiceTypeID]        INT              NOT NULL,
    [SpecialServiceID]     INT              NOT NULL,
    [NationalityID]        INT              NOT NULL,
    [IsVendorHotel]        TINYINT          NOT NULL,
    [VendorHotelID]        INT              NULL,
    [NoofAdult]            INT              NULL,
    [AdultCost]            NUMERIC (18, 2)  NULL,
    [NoOfChild]            INT              NULL,
    [ChildCost]            NUMERIC (18, 2)  NULL,
    [NoOfConsolidatedUnit] INT              NULL,
    [ConsolidatedUnitCost] NUMERIC (18, 2)  NULL,
    [SpecialSubTotal]      NUMERIC (18, 2)  NOT NULL,
    [Remarks]              VARCHAR (500)    NULL,
    [OldID]                INT              NULL,
    [StateCodeID]          INT              NULL,
    CONSTRAINT [PK_Quotation_Special] PRIMARY KEY CLUSTERED ([QuotationSpecialID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1-Vendor, 2-Hotel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Quotation_Special', @level2type = N'COLUMN', @level2name = N'IsVendorHotel';


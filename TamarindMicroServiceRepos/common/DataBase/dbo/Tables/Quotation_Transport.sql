CREATE TABLE [dbo].[Quotation_Transport] (
    [QuotationTransportID] INT              IDENTITY (1, 1) NOT NULL,
    [QuotationID]          VARCHAR (25)     NOT NULL,
    [ItineraryDay]         INT              NULL,
    [ItineraryDate]        DATETIME         NULL,
    [RateDetailsID]        UNIQUEIDENTIFIER NULL,
    [CityCode]             CHAR (3)         NOT NULL,
    [ServiceTypeID]        INT              NOT NULL,
    [TransportServiceID]   INT              NOT NULL,
    [VehicleTypeID]        INT              NOT NULL,
    [NoOfVehicles]         INT              NOT NULL,
    [VehicleBase]          VARCHAR (10)     NULL,
    [IsVendorHotel]        SMALLINT         NULL,
    [VendorHotelID]        INT              NULL,
    [VehicleUnitCost]      NUMERIC (18, 2)  NULL,
    [TransportSubTotal]    NUMERIC (18, 2)  NULL,
    [Remarks]              VARCHAR (500)    NULL,
    [OldID]                INT              NULL,
    CONSTRAINT [PK_Quotation_Transport] PRIMARY KEY CLUSTERED ([QuotationTransportID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1-Vendor, 2-Hotel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Quotation_Transport', @level2type = N'COLUMN', @level2name = N'IsVendorHotel';


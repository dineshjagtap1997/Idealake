CREATE TABLE [RateCards].[HotelOfferMaster] (
    [HotelOfferID]         BIGINT           IDENTITY (1, 1) NOT NULL,
    [CardNumber]           VARCHAR (30)     NULL,
    [HospitalityPartnerID] INT              NULL,
    [CityID]               VARCHAR (10)     NULL,
    [HotelID]              INT              NULL,
    [HotelGroupID]         INT              NULL,
    [VendorID]             INT              NULL,
    [Heading]              VARCHAR (200)    NULL,
    [ValidFrom]            DATETIME         NULL,
    [ValidTo]              DATETIME         NULL,
    [InfoForOperation]     VARCHAR (300)    NULL,
    [Rule]                 VARCHAR (100)    NULL,
    [IsMarketOrAgent]      BIT              DEFAULT ((0)) NULL,
    [IsActive]             BIT              DEFAULT ((1)) NULL,
    [CreatedBy]            UNIQUEIDENTIFIER NULL,
    [CreatedOn]            DATETIME         NULL,
    [UpdatedBy]            UNIQUEIDENTIFIER NULL,
    [UpdatedOn]            DATETIME         NULL,
    PRIMARY KEY CLUSTERED ([HotelOfferID] ASC)
);


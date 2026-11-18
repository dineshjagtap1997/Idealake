CREATE TABLE [dbo].[HotelOfferMapping] (
    [HotelOfferMappingID] UNIQUEIDENTIFIER NULL,
    [HotelOfferID]        INT              NULL,
    [CityIATACode]        VARCHAR (10)     NULL,
    [HotelID]             INT              NULL,
    [HotelName]           VARCHAR (500)    NULL,
    [InsertedDatetime]    DATETIME         CONSTRAINT [DF_HotelOfferMapping_InsertedDatetime] DEFAULT (getdate()) NULL
);


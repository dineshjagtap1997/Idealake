CREATE TABLE [dbo].[ItineraryDescription] (
    [ItineraryDescID]   INT              IDENTITY (1, 1) NOT NULL,
    [ItineraryCode]     VARCHAR (50)     NOT NULL,
    [Header]            VARCHAR (500)    NOT NULL,
    [ShortDescription]  VARCHAR (MAX)    NULL,
    [DetailDescription] VARCHAR (MAX)    NULL,
    [IsActive]          BIT              NOT NULL,
    [Operation]         VARCHAR (10)     NOT NULL,
    [OperationOn]       DATETIME         NOT NULL,
    [City_IATACode]     CHAR (3)         NULL,
    [Country_IATACode]  CHAR (4)         NULL,
    [ShortCode]         VARCHAR (30)     NULL,
    [AllCities]         CHAR (3)         NULL,
    [DetailedHeader]    VARCHAR (500)    NULL,
    [City2_IATACode]    CHAR (3)         NULL,
    [TourDate]          DATETIME         NULL,
    [OperationBy]       UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_ItineraryDescription] PRIMARY KEY CLUSTERED ([ItineraryDescID] ASC)
);


CREATE TABLE [dbo].[Quotation_MOT] (
    [QuotationMOTID] INT              IDENTITY (1, 1) NOT NULL,
    [QuotationID]    VARCHAR (25)     NOT NULL,
    [ItineraryDay]   INT              NOT NULL,
    [ItineraryDate]  DATETIME         NULL,
    [RateDetailsID]  UNIQUEIDENTIFIER NULL,
    [CityCode]       CHAR (3)         NOT NULL,
    [ServiceTypeID]  INT              NOT NULL,
    [ServiceName]    VARCHAR (200)    NOT NULL,
    [MOTID]          INT              NOT NULL,
    [ClassTypeID]    INT              NOT NULL,
    [VendorID]       INT              NULL,
    [NoOfAdult]      INT              NULL,
    [AdultCost]      NUMERIC (18, 2)  NULL,
    [NoOfChild]      INT              NULL,
    [ChildCost]      NUMERIC (18, 2)  NULL,
    [MOTSubTotal]    NUMERIC (18, 2)  NULL,
    [Remarks]        VARCHAR (500)    NULL,
    [OldID]          INT              NULL,
    [StateCodeID]    INT              NULL,
    CONSTRAINT [PK_Quotation_MOT] PRIMARY KEY CLUSTERED ([QuotationMOTID] ASC)
);


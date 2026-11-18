CREATE TABLE [dbo].[ItineraryCreator_Details] (
    [ID]             INT              IDENTITY (1, 1) NOT NULL,
    [ItineraryID]    INT              NOT NULL,
    [DAYS]           INT              NULL,
    [ArrCity]        CHAR (3)         NULL,
    [DeptCity]       CHAR (3)         NULL,
    [Header]         VARCHAR (500)    NULL,
    [Operation]      VARCHAR (10)     NULL,
    [OperationBy]    UNIQUEIDENTIFIER NULL,
    [OperationOn]    DATETIME         NULL,
    [UpdatedBy]      UNIQUEIDENTIFIER NULL,
    [UpdatedOn]      DATETIME         NULL,
    [HotelTypeValue] VARCHAR (200)    NULL,
    [Onward]         BIT              NULL,
    [TourDate]       DATETIME         NULL,
    [WeekDay]        VARCHAR (15)     NULL
);


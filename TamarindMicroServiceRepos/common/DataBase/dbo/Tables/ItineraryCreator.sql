CREATE TABLE [dbo].[ItineraryCreator] (
    [ItineraryID] INT              IDENTITY (100000, 1) NOT NULL,
    [EnquiryID]   VARCHAR (50)     NULL,
    [FileCode]    VARCHAR (30)     NULL,
    [COUNTRY]     CHAR (4)         NULL,
    [TourDate]    DATETIME         NULL,
    [IsActive]    BIT              NULL,
    [Operation]   VARCHAR (10)     NULL,
    [OperationBy] UNIQUEIDENTIFIER NULL,
    [OperationOn] DATETIME         NULL,
    [UpdatedBy]   UNIQUEIDENTIFIER NULL,
    [UpdatedOn]   DATETIME         NULL
);


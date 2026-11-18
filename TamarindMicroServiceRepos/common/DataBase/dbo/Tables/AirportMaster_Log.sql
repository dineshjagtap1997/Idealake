CREATE TABLE [dbo].[AirportMaster_Log] (
    [ID]                INT              IDENTITY (1, 1) NOT NULL,
    [ParentID]          INT              NULL,
    [Airport_Code]      CHAR (3)         NOT NULL,
    [Airport_City_Name] VARCHAR (50)     NOT NULL,
    [Airport_Name]      VARCHAR (75)     NOT NULL,
    [Airport_Country]   VARCHAR (50)     NOT NULL,
    [IsActive]          BIT              NOT NULL,
    [Operation]         VARCHAR (10)     NOT NULL,
    [OperationBy]       UNIQUEIDENTIFIER NOT NULL,
    [OperationDate]     DATETIME         NOT NULL,
    [UpdatedBy]         UNIQUEIDENTIFIER NULL,
    [UpdatedDate]       DATETIME         NULL,
    [CreatedDate]       DATETIME         NULL
);


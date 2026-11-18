CREATE TABLE [dbo].[AirportMaster] (
    [ID]                INT              IDENTITY (1, 1) NOT NULL,
    [Airport_Code]      CHAR (3)         NOT NULL,
    [Airport_City_Name] VARCHAR (50)     NOT NULL,
    [Airport_Name]      VARCHAR (75)     NOT NULL,
    [Airport_Country]   VARCHAR (50)     NOT NULL,
    [IsActive]          BIT              NOT NULL,
    [Operation]         VARCHAR (10)     NOT NULL,
    [OperationBy]       UNIQUEIDENTIFIER NULL,
    [OperationDate]     DATETIME         NULL,
    [UpdatedBy]         UNIQUEIDENTIFIER NULL,
    [UpdatedOn]         DATETIME         NULL,
    CONSTRAINT [PK_AirportMaster] PRIMARY KEY CLUSTERED ([Airport_Code] ASC)
);


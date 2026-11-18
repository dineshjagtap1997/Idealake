CREATE TABLE [dbo].[DestinationDetails] (
    [DestinationDetailID] INT              IDENTITY (1, 1) NOT NULL,
    [CityIATACode]        CHAR (3)         NOT NULL,
    [DestinationHeaderID] INT              NOT NULL,
    [Details]             VARCHAR (MAX)    NULL,
    [IsActive]            BIT              NOT NULL,
    [Operation]           VARCHAR (10)     NOT NULL,
    [OperationBy]         UNIQUEIDENTIFIER NOT NULL,
    [OperationOn]         DATETIME         NOT NULL,
    [OldID]               INT              NULL,
    [UpdatedBy]           UNIQUEIDENTIFIER NULL,
    [UpdatedOn]           DATETIME         NULL,
    CONSTRAINT [PK_DestinationDetails] PRIMARY KEY CLUSTERED ([DestinationDetailID] ASC)
);


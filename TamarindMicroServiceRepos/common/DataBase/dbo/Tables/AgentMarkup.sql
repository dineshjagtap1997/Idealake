CREATE TABLE [dbo].[AgentMarkup] (
    [AgentMarkupID]   INT              IDENTITY (1, 1) NOT NULL,
    [AgentCategoryID] INT              NOT NULL,
    [CodeDescription] VARCHAR (100)    NOT NULL,
    [ValidFrom]       DATETIME         NOT NULL,
    [ValidTo]         DATETIME         NOT NULL,
    [Hotel]           NUMERIC (18, 2)  NOT NULL,
    [Transport]       NUMERIC (18, 2)  NOT NULL,
    [Guide]           NUMERIC (18, 2)  NOT NULL,
    [Monument]        NUMERIC (18, 2)  NOT NULL,
    [FlightTrain]     NUMERIC (18, 2)  NOT NULL,
    [SpecialService]  NUMERIC (18, 2)  NOT NULL,
    [Package]         NUMERIC (18, 2)  NOT NULL,
    [IsActive]        BIT              NOT NULL,
    [Operation]       VARCHAR (50)     NOT NULL,
    [OperationBy]     UNIQUEIDENTIFIER NOT NULL,
    [OperationOn]     DATETIME         DEFAULT (getdate()) NOT NULL,
    [SupplierID]      INT              NOT NULL,
    [UpdatedBy]       UNIQUEIDENTIFIER NULL,
    [UpdatedOn]       DATETIME         NULL,
    PRIMARY KEY CLUSTERED ([AgentMarkupID] ASC)
);


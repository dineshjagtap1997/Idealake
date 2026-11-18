CREATE TABLE [dbo].[BusinessMaster] (
    [BussinessModuleID]  INT              IDENTITY (1, 1) NOT NULL,
    [BusinessModuleName] VARCHAR (100)    NOT NULL,
    [IsActive]           BIT              NOT NULL,
    [Operation]          VARCHAR (10)     NOT NULL,
    [OperationBy]        UNIQUEIDENTIFIER NOT NULL,
    [InsertedDatetime]   DATETIME         CONSTRAINT [DF_BusinessMaster_InsertedDatetime] DEFAULT (getdate()) NOT NULL,
    [IsTTCLogo]          BIT              NULL,
    [UpdatedBy]          UNIQUEIDENTIFIER NULL,
    [UpdatedOn]          DATETIME         NULL,
    CONSTRAINT [PK_BusinessMaster] PRIMARY KEY CLUSTERED ([BussinessModuleID] ASC)
);


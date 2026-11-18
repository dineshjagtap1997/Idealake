CREATE TABLE [dbo].[Rate_Type] (
    [Rate_Type_ID]   INT              IDENTITY (1, 1) NOT NULL,
    [Rate_Type_Name] VARCHAR (50)     NOT NULL,
    [Rate_Type_Code] VARCHAR (50)     CONSTRAINT [DF_Rate_Type_Rate_Type_Code] DEFAULT (' ') NOT NULL,
    [IsActive]       BIT              NOT NULL,
    [Operation]      VARCHAR (10)     NOT NULL,
    [OperationBy]    UNIQUEIDENTIFIER NOT NULL,
    [OperationOn]    DATETIME         NOT NULL,
    [OldID]          INT              NULL,
    [UpdatedBy]      UNIQUEIDENTIFIER NULL,
    [UpdatedOn]      DATETIME         NULL,
    CONSTRAINT [PK_Rate_Type] PRIMARY KEY CLUSTERED ([Rate_Type_ID] ASC)
);


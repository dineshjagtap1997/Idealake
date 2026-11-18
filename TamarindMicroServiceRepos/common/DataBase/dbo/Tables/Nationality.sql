CREATE TABLE [dbo].[Nationality] (
    [ID]                     INT              IDENTITY (1, 1) NOT NULL,
    [Nationality]            VARCHAR (50)     NOT NULL,
    [IsActive]               BIT              CONSTRAINT [DF_Nationality_IsActive] DEFAULT ((1)) NOT NULL,
    [Operation]              VARCHAR (50)     NOT NULL,
    [OperationBy]            UNIQUEIDENTIFIER NOT NULL,
    [OperationOn]            DATETIME         CONSTRAINT [DF_Nationality_OperationOn] DEFAULT (getdate()) NOT NULL,
    [HeaderInfo_Nationality] VARCHAR (50)     NULL,
    [UpdatedBy]              UNIQUEIDENTIFIER NULL,
    [UpdatedOn]              DATETIME         NULL
);


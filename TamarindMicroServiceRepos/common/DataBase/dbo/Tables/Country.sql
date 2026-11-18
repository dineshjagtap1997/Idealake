CREATE TABLE [dbo].[Country] (
    [IATACode]      CHAR (4)         NOT NULL,
    [Name]          VARCHAR (50)     NOT NULL,
    [Nationality]   INT              NULL,
    [ISDCode]       INT              NULL,
    [IsActive]      BIT              CONSTRAINT [DF_Country_IsActive] DEFAULT ((1)) NOT NULL,
    [Operation]     VARCHAR (10)     NOT NULL,
    [OperationBy]   UNIQUEIDENTIFIER NOT NULL,
    [OperationDate] DATETIME         NOT NULL,
    [OldID]         VARCHAR (10)     NULL,
    [PostalCode]    VARCHAR (10)     NULL,
    [UpdatedBy]     UNIQUEIDENTIFIER NULL,
    [UpdatedOn]     DATETIME         NULL,
    [ID]            BIGINT           IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_Country] PRIMARY KEY CLUSTERED ([IATACode] ASC) WITH (FILLFACTOR = 80)
);


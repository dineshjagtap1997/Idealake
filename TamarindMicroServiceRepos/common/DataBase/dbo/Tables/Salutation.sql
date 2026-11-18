CREATE TABLE [dbo].[Salutation] (
    [SalutationID] INT              IDENTITY (1, 1) NOT NULL,
    [Salutation]   VARCHAR (15)     NOT NULL,
    [IsActive]     BIT              NOT NULL,
    [Operation]    VARCHAR (10)     NOT NULL,
    [OperationBy]  UNIQUEIDENTIFIER NOT NULL,
    [OperationOn]  DATETIME         NOT NULL,
    [OldID]        INT              NULL,
    [UpdatedBy]    UNIQUEIDENTIFIER NULL,
    [UpdatedOn]    DATETIME         NULL,
    CONSTRAINT [PK_Salutation] PRIMARY KEY CLUSTERED ([SalutationID] ASC)
);


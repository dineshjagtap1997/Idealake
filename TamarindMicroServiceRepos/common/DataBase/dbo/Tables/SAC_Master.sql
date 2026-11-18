CREATE TABLE [dbo].[SAC_Master] (
    [ID]            INT              IDENTITY (1, 1) NOT NULL,
    [Code]          VARCHAR (50)     NOT NULL,
    [Description]   VARCHAR (MAX)    NOT NULL,
    [IsActive]      BIT              NOT NULL,
    [Operation]     VARCHAR (10)     NOT NULL,
    [OperationBy]   UNIQUEIDENTIFIER NOT NULL,
    [OperationDate] DATETIME         NOT NULL,
    [ForTkt]        BIT              NULL,
    [UpdatedBy]     UNIQUEIDENTIFIER NULL,
    [UpdatedOn]     DATETIME         NULL,
    CONSTRAINT [PK_SAC_Master] PRIMARY KEY CLUSTERED ([ID] ASC)
);


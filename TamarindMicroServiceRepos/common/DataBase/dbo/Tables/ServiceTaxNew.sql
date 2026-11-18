CREATE TABLE [dbo].[ServiceTaxNew] (
    [Tax_ID]        INT              IDENTITY (1, 1) NOT NULL,
    [Tax_Desc]      VARCHAR (500)    NULL,
    [GSTID]         INT              NULL,
    [IsActive]      BIT              NOT NULL,
    [Tax_From_Date] DATETIME         NOT NULL,
    [Tax_To_Date]   DATETIME         NOT NULL,
    [Operation]     VARCHAR (10)     NOT NULL,
    [OperationBy]   UNIQUEIDENTIFIER NOT NULL,
    [OperationOn]   DATETIME         NOT NULL,
    [GSTType]       INT              NULL,
    [IsCommercial]  BIT              NULL,
    [SAPCode]       VARCHAR (10)     NULL,
    [UpdatedBy]     UNIQUEIDENTIFIER NULL,
    [UpdatedOn]     DATETIME         NULL,
    [Tax_Perc]      DECIMAL (5, 2)   NULL,
    CONSTRAINT [PK_ServiceTaxNew] PRIMARY KEY CLUSTERED ([Tax_ID] ASC)
);


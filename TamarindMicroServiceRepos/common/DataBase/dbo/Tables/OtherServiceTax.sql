CREATE TABLE [dbo].[OtherServiceTax] (
    [Tax_ID]         INT              IDENTITY (1, 1) NOT NULL,
    [Tax_Desc]       VARCHAR (500)    NULL,
    [Tax_ACCode]     NVARCHAR (100)   NULL,
    [Tax_Percentage] DECIMAL (18, 5)  NOT NULL,
    [IsActive]       BIT              NOT NULL,
    [Tax_Type]       INT              NOT NULL,
    [Tax_From_Date]  DATETIME         NOT NULL,
    [Tax_To_Date]    DATETIME         NOT NULL,
    [Operation]      VARCHAR (10)     NOT NULL,
    [OperationBy]    UNIQUEIDENTIFIER NOT NULL,
    [OperationOn]    DATETIME         NOT NULL,
    [OldID]          INT              NULL,
    [Other_Tax_Id]   INT              NULL,
    [TaxCode]        VARCHAR (50)     NULL,
    [TaxDescription] VARCHAR (200)    NULL,
    [TaxRate]        DECIMAL (18, 5)  NULL,
    [CreatedBy]      UNIQUEIDENTIFIER NULL,
    [CreatedOn]      DATETIME         NULL,
    [TaxID]          INT              NULL,
    [UpdatedBy]      UNIQUEIDENTIFIER NULL,
    [UpdatedOn]      DATETIME         NULL,
    CONSTRAINT [PK_OtherServiceTax] PRIMARY KEY CLUSTERED ([Tax_ID] ASC),
    CONSTRAINT [UQ_OtherServiceTax_TaxCode] UNIQUE NONCLUSTERED ([TaxCode] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UX_OtherServiceTax_TaxCode]
    ON [dbo].[OtherServiceTax]([TaxCode] ASC);


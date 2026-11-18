CREATE TABLE [dbo].[OtherServiceTaxNew] (
    [Tax_ID]         INT              IDENTITY (1, 1) NOT NULL,
    [Tax_Desc]       VARCHAR (500)    NULL,
    [Tax_Percentage] DECIMAL (18, 5)  NOT NULL,
    [IsActive]       BIT              NOT NULL,
    [Tax_Type]       INT              NOT NULL,
    [Tax_From_Date]  DATETIME         NOT NULL,
    [Tax_To_Date]    DATETIME         NOT NULL,
    [Operation]      VARCHAR (10)     NOT NULL,
    [OperationBy]    UNIQUEIDENTIFIER NOT NULL,
    [OperationOn]    DATETIME         NOT NULL,
    [Other_Tax_Id]   INT              NULL,
    [ST_Tax_ID]      INT              NULL,
    CONSTRAINT [PK_OtherServiceTaxNew] PRIMARY KEY CLUSTERED ([Tax_ID] ASC) WITH (FILLFACTOR = 80)
);


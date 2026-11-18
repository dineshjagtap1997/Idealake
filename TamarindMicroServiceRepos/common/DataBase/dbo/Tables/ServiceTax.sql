CREATE TABLE [dbo].[ServiceTax] (
    [Tax_ID]         INT              IDENTITY (1, 1) NOT NULL,
    [Tax_Desc]       VARCHAR (500)    NULL,
    [Tax_ACCode]     NVARCHAR (100)   NULL,
    [Tax_Percentage] DECIMAL (18, 5)  NOT NULL,
    [IsActive]       BIT              NOT NULL,
    [Tax_Type]       INT              NOT NULL,
    [Tax_From_Date]  DATETIME         NOT NULL,
    [Tax_To_Date]    DATETIME         NOT NULL,
    [Tax_SalesType]  INT              NOT NULL,
    [Operation]      VARCHAR (10)     NOT NULL,
    [OperationBy]    UNIQUEIDENTIFIER NOT NULL,
    [OperationOn]    DATETIME         NOT NULL,
    [OldID]          INT              NULL,
    [GSTType]        VARCHAR (500)    NULL,
    CONSTRAINT [PK_ServiceTax] PRIMARY KEY CLUSTERED ([Tax_ID] ASC)
);


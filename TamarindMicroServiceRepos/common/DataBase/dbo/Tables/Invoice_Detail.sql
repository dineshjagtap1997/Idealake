CREATE TABLE [dbo].[Invoice_Detail] (
    [ID]             NUMERIC (18)    IDENTITY (1, 1) NOT NULL,
    [Invoice_ID]     NVARCHAR (50)   NOT NULL,
    [Invoice_Desc]   VARCHAR (5000)  NOT NULL,
    [Invoice_Value]  NUMERIC (18, 2) NOT NULL,
    [YearCode]       INT             NULL,
    [Taxable_Amount] NUMERIC (18, 2) NULL,
    [Tax_Amount]     NUMERIC (18, 2) NULL,
    [flag]           INT             NULL,
    [TCSAmount]      NUMERIC (18, 2) NULL,
    [SubTotal]       NUMERIC (18, 2) NULL,
    [ServiceFee_Amt] NUMERIC (18, 2) NULL,
    [IsServFee_Inv]  BIT             NULL,
    CONSTRAINT [PK_Invoice_Detail] PRIMARY KEY CLUSTERED ([ID] ASC)
);


CREATE TABLE [dbo].[tbl_FiscalData] (
    [Fiscal_ID]   INT          IDENTITY (1, 1) NOT NULL,
    [Fiscal_Year] INT          NULL,
    [Fiscal_Code] INT          NULL,
    [Variant]     VARCHAR (10) NULL,
    [Start_Date]  DATETIME     NULL,
    [End_Date]    DATETIME     NULL,
    PRIMARY KEY CLUSTERED ([Fiscal_ID] ASC)
);


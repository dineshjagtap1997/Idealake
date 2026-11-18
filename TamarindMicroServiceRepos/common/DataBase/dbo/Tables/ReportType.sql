CREATE TABLE [dbo].[ReportType] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [ReportTypeValue] CHAR (10)     NULL,
    [ReportTypeName]  VARCHAR (255) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


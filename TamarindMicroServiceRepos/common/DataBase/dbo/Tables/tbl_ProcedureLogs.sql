CREATE TABLE [dbo].[tbl_ProcedureLogs] (
    [ID]            INT           IDENTITY (1, 1) NOT NULL,
    [ProcedureName] VARCHAR (255) NOT NULL,
    [LogStatus]     BIT           NOT NULL
);


CREATE TABLE [dbo].[TCS_Documents] (
    [ID]             BIGINT           IDENTITY (1, 1) NOT NULL,
    [YearCode]       INT              NOT NULL,
    [Invoice_ID]     NVARCHAR (50)    NOT NULL,
    [Type]           INT              NOT NULL,
    [DocName]        NVARCHAR (500)   NOT NULL,
    [Doc_ID]         NVARCHAR (100)   NOT NULL,
    [DocUnqName]     UNIQUEIDENTIFIER NOT NULL,
    [InsertBy]       UNIQUEIDENTIFIER NOT NULL,
    [InsertDateTime] DATETIME         NOT NULL,
    [isTSCDocNew]    BIT              NULL,
    CONSTRAINT [PK_TCS_Documents] PRIMARY KEY CLUSTERED ([ID] ASC)
);


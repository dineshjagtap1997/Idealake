CREATE TABLE [dbo].[QuotationServiceType_Master] (
    [QutServ_ID]  INT              IDENTITY (1, 1) NOT NULL,
    [Description] NVARCHAR (70)    NOT NULL,
    [IsActive]    BIT              NOT NULL,
    [Operation]   NVARCHAR (10)    NOT NULL,
    [CreatedBy]   UNIQUEIDENTIFIER NOT NULL,
    [CreatedDate] DATETIME         NOT NULL,
    [Updatedby]   UNIQUEIDENTIFIER NULL,
    [UpdatedOn]   DATETIME         NULL,
    CONSTRAINT [PK_QuotationServiceType_Master] PRIMARY KEY CLUSTERED ([QutServ_ID] ASC)
);


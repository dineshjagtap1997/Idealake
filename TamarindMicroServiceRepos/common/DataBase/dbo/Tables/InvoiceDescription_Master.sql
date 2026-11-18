CREATE TABLE [dbo].[InvoiceDescription_Master] (
    [InvDesc_ID]  INT              IDENTITY (1, 1) NOT NULL,
    [Description] NVARCHAR (100)   NOT NULL,
    [SACCode]     INT              NULL,
    [ISComm]      BIT              NULL,
    [IsActive]    BIT              NOT NULL,
    [Operation]   NVARCHAR (10)    NOT NULL,
    [CreatedBy]   UNIQUEIDENTIFIER NOT NULL,
    [CreatedDate] DATETIME         NOT NULL,
    [Updatedby]   UNIQUEIDENTIFIER NOT NULL,
    [UpdatedOn]   DATETIME         NOT NULL,
    CONSTRAINT [PK_InvoiceDescription_Master] PRIMARY KEY CLUSTERED ([InvDesc_ID] ASC)
);


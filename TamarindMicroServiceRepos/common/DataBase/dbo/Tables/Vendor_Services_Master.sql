CREATE TABLE [dbo].[Vendor_Services_Master] (
    [Vendor_ID]   INT              IDENTITY (1, 1) NOT NULL,
    [Description] NVARCHAR (50)    NOT NULL,
    [IsActive]    BIT              NOT NULL,
    [Operation]   NVARCHAR (10)    NOT NULL,
    [OperationBy] UNIQUEIDENTIFIER NOT NULL,
    [CreatedDate] DATETIME         NOT NULL,
    [Updatedby]   UNIQUEIDENTIFIER NULL,
    [UpdatedOn]   DATETIME         NULL,
    CONSTRAINT [PK_Vendor_Services_Master] PRIMARY KEY CLUSTERED ([Vendor_ID] ASC)
);


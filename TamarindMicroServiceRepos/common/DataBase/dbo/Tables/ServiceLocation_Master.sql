CREATE TABLE [dbo].[ServiceLocation_Master] (
    [ServLoc_ID]  INT              IDENTITY (1, 1) NOT NULL,
    [Description] NVARCHAR (25)    NOT NULL,
    [IsActive]    BIT              NOT NULL,
    [Operation]   NVARCHAR (10)    NOT NULL,
    [CreatedBy]   UNIQUEIDENTIFIER NOT NULL,
    [CreatedDate] DATETIME         NOT NULL,
    [Updatedby]   UNIQUEIDENTIFIER NULL,
    [UpdatedOn]   DATETIME         NULL,
    CONSTRAINT [PK_ServiceLocation_Master] PRIMARY KEY CLUSTERED ([ServLoc_ID] ASC)
);


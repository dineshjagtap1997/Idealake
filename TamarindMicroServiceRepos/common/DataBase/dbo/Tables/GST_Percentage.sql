CREATE TABLE [dbo].[GST_Percentage] (
    [GSTID]         INT              IDENTITY (1, 1) NOT NULL,
    [GSTPercentage] DECIMAL (5, 2)   NULL,
    [IsActive]      BIT              NULL,
    [Operation]     NVARCHAR (10)    NULL,
    [CreatedBy]     UNIQUEIDENTIFIER NULL,
    [CreatedDate]   DATETIME         NULL,
    [Updatedby]     UNIQUEIDENTIFIER NULL,
    [UpdatedOn]     DATETIME         NULL,
    CONSTRAINT [PK_GST_] PRIMARY KEY CLUSTERED ([GSTID] ASC) WITH (FILLFACTOR = 80)
);


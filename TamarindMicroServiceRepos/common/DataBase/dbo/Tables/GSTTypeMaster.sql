CREATE TABLE [dbo].[GSTTypeMaster] (
    [GSTID]       INT              IDENTITY (1, 1) NOT NULL,
    [GSTTypeName] NVARCHAR (20)    NULL,
    [IsActive]    BIT              NULL,
    [Operation]   NVARCHAR (10)    NULL,
    [OperationBy] UNIQUEIDENTIFIER NULL,
    [OperationOn] DATETIME         NULL,
    [UpdatedBy]   UNIQUEIDENTIFIER NULL,
    [UpdatedOn]   DATETIME         NULL,
    CONSTRAINT [PK_GSTTypeMaster] PRIMARY KEY CLUSTERED ([GSTID] ASC) WITH (FILLFACTOR = 80)
);


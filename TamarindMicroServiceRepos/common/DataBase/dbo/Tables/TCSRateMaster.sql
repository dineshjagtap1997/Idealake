CREATE TABLE [dbo].[TCSRateMaster] (
    [TCSID]       BIGINT           IDENTITY (1, 1) NOT NULL,
    [ACCode]      NVARCHAR (50)    NOT NULL,
    [Description] NVARCHAR (50)    NOT NULL,
    [ValidFrom]   DATETIME         NULL,
    [ValidTo]     DATETIME         NULL,
    [TCSRate]     DECIMAL (4, 2)   NOT NULL,
    [IsActive]    BIT              NULL,
    [Operation]   NVARCHAR (10)    NULL,
    [CreatedBy]   UNIQUEIDENTIFIER NULL,
    [CreatedDate] DATETIME         NULL,
    [UpdatedBy]   UNIQUEIDENTIFIER NULL,
    [UpdatedDate] DATETIME         NULL,
    [SAPCode]     NVARCHAR (6)     NULL,
    CONSTRAINT [PK_TCSRateMaster] PRIMARY KEY CLUSTERED ([TCSID] ASC)
);


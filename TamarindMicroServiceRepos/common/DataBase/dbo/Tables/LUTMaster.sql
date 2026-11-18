CREATE TABLE [dbo].[LUTMaster] (
    [ID]           BIGINT           IDENTITY (1, 1) NOT NULL,
    [LUTNumber]    NVARCHAR (35)    NULL,
    [ValidFrom]    DATETIME         NULL,
    [ValidTo]      DATETIME         NULL,
    [CompanyID]    BIGINT           NULL,
    [yearcode]     BIGINT           NULL,
    [IsActive]     BIT              NULL,
    [OperationBy]  UNIQUEIDENTIFIER NULL,
    [InsertedDate] DATETIME         NULL,
    [UpdatedBy]    UNIQUEIDENTIFIER NULL,
    [UpdatedOn]    DATETIME         NULL,
    CONSTRAINT [PK_LUTMaster] PRIMARY KEY CLUSTERED ([ID] ASC)
);


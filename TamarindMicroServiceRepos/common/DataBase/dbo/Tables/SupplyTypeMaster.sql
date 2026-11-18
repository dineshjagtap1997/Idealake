CREATE TABLE [dbo].[SupplyTypeMaster] (
    [SuppTypeID]      BIGINT           IDENTITY (1, 1) NOT NULL,
    [Code]            NVARCHAR (10)    NOT NULL,
    [Description]     NVARCHAR (50)    NOT NULL,
    [LongDescription] NVARCHAR (150)   NULL,
    [IsActive]        BIT              NULL,
    [Operation]       NVARCHAR (10)    NULL,
    [CreatedBy]       UNIQUEIDENTIFIER NULL,
    [CreatedDate]     DATETIME         NULL,
    [Updatedby]       UNIQUEIDENTIFIER NULL,
    [UpdatedOn]       DATETIME         NULL,
    CONSTRAINT [PK_SupplyTypeMaster] PRIMARY KEY CLUSTERED ([SuppTypeID] ASC)
);


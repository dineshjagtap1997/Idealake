CREATE TABLE [dbo].[LegalEntityType_Master] (
    [LegalEntTypeID]  BIGINT           IDENTITY (1, 1) NOT NULL,
    [LegalEntityType] NVARCHAR (80)    NULL,
    [IsActive]        BIT              NULL,
    [Operation]       NVARCHAR (10)    NULL,
    [CreatedBy]       UNIQUEIDENTIFIER NULL,
    [CreatedDate]     DATETIME         NULL,
    [UpdatedBy]       UNIQUEIDENTIFIER NULL,
    [UpdatedOn]       DATETIME         NULL,
    [UpdatedDate]     DATETIME         NULL,
    CONSTRAINT [PK_LegalEntityType_Master] PRIMARY KEY CLUSTERED ([LegalEntTypeID] ASC)
);


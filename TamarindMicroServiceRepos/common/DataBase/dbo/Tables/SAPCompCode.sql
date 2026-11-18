CREATE TABLE [dbo].[SAPCompCode] (
    [SAPCompCodeId]   BIGINT           IDENTITY (1, 1) NOT NULL,
    [ParentID]        BIGINT           NULL,
    [TypeID]          INT              NULL,
    [SAPCompCodename] INT              NULL,
    [BPCode]          NVARCHAR (15)    NULL,
    [IsActive]        BIT              NULL,
    [InsertedDate]    DATETIME         NULL,
    [UpdatedDate]     DATETIME         NULL,
    [CreatedBy]       UNIQUEIDENTIFIER NULL,
    [UpdatedBy]       UNIQUEIDENTIFIER NULL,
    [SAPID]           INT              NULL,
    CONSTRAINT [PK_SAPCompCode] PRIMARY KEY CLUSTERED ([SAPCompCodeId] ASC)
);


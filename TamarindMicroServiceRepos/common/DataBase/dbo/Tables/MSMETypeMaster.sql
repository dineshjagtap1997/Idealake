CREATE TABLE [dbo].[MSMETypeMaster] (
    [MSMETypeID]   INT              IDENTITY (1, 1) NOT NULL,
    [MSMETypeName] VARCHAR (100)    NOT NULL,
    [Description]  VARCHAR (255)    NULL,
    [IsActive]     BIT              NOT NULL,
    [Operation]    VARCHAR (10)     NOT NULL,
    [OperationBy]  UNIQUEIDENTIFIER NOT NULL,
    [OperationOn]  DATETIME         NOT NULL,
    [UpdatedBy]    UNIQUEIDENTIFIER NULL,
    [UpdatedDate]  DATETIME         NULL
);


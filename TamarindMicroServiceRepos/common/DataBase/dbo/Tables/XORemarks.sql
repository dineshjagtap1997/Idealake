CREATE TABLE [dbo].[XORemarks] (
    [XOID]        INT              IDENTITY (1, 1) NOT NULL,
    [XoRemarks]   VARCHAR (500)    NOT NULL,
    [IsActive]    BIT              NOT NULL,
    [Operation]   VARCHAR (10)     NOT NULL,
    [OperationBy] UNIQUEIDENTIFIER NOT NULL,
    [OperationOn] DATETIME         NOT NULL,
    [UpdatedBy]   UNIQUEIDENTIFIER NULL,
    [UpdatedOn]   DATETIME         NULL
);


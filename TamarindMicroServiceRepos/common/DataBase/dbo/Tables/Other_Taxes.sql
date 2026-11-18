CREATE TABLE [dbo].[Other_Taxes] (
    [Name]         VARCHAR (100)    NOT NULL,
    [IsActive]     BIT              NOT NULL,
    [Operation]    VARCHAR (50)     NULL,
    [OperationOn]  DATETIME         NULL,
    [OperationBy]  UNIQUEIDENTIFIER NULL,
    [UpdatedBy]    UNIQUEIDENTIFIER NULL,
    [UpdatedOn]    DATETIME         NULL,
    [Other_Tax_Id] INT              IDENTITY (1, 1) NOT NULL,
    PRIMARY KEY CLUSTERED ([Other_Tax_Id] ASC)
);


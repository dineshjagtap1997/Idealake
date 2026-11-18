CREATE TABLE [dbo].[AccountsBankMaster] (
    [AccountBankMasterID] INT              IDENTITY (1, 1) NOT NULL,
    [BankAccountName]     VARCHAR (500)    NOT NULL,
    [BankAccountDetails]  VARCHAR (MAX)    NULL,
    [IsActive]            BIT              NULL,
    [Operation]           VARCHAR (10)     NULL,
    [OperationBy]         UNIQUEIDENTIFIER NULL,
    [InsertedDatetime]    DATETIME         NULL,
    [UpdatedBy]           UNIQUEIDENTIFIER NULL,
    [UpdatedOn]           DATETIME         NULL,
    [Currency]            NVARCHAR (50)    NULL,
    [LegalEntityId]       INT              NULL,
    [AccountName]         NVARCHAR (100)   NULL,
    [AccountNumber]       NVARCHAR (100)   NULL,
    [AccountPrefix]       NVARCHAR (50)    NULL,
    [IsVirtualAccount]    BIT              NULL,
    CONSTRAINT [PK_AccountsBankMaster] PRIMARY KEY CLUSTERED ([AccountBankMasterID] ASC)
);


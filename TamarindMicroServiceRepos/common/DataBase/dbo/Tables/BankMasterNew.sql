CREATE TABLE [dbo].[BankMasterNew] (
    [BankID]              INT           IDENTITY (1, 1) NOT NULL,
    [AccountBankMasterID] INT           NULL,
    [Currency]            VARCHAR (50)  NULL,
    [Details]             VARCHAR (MAX) NULL,
    [CompanyID]           INT           NULL,
    [isTTCBankDetails]    BIT           NULL,
    [isActive]            BIT           NULL,
    [CreatedBy]           VARCHAR (500) NULL,
    [CreatedDatetime]     DATETIME      NULL,
    [UpdatedBy]           VARCHAR (500) NULL,
    [UpdatedDatetime]     DATETIME      NULL,
    [AccountName]         VARCHAR (500) NULL,
    [AccountNo]           VARCHAR (500) NULL,
    [IsVirtualAccount]    BIT           NULL,
    [AccountPrefix]       VARCHAR (50)  NULL,
    [IsRedDot]            BIT           NULL,
    CONSTRAINT [PK_BankMasterNew] PRIMARY KEY CLUSTERED ([BankID] ASC)
);


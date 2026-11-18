CREATE TABLE [dbo].[City] (
    [IATACode]       CHAR (4)         NOT NULL,
    [State_IATACode] INT              NOT NULL,
    [Name]           VARCHAR (50)     NOT NULL,
    [STDCode]        INT              NOT NULL,
    [IsActive]       BIT              CONSTRAINT [DF__City__IsActive__4589517F] DEFAULT ((1)) NOT NULL,
    [Operation]      VARCHAR (10)     NOT NULL,
    [OperationBy]    UNIQUEIDENTIFIER NOT NULL,
    [OperationOn]    DATETIME         CONSTRAINT [DF__City__OperationO__467D75B8] DEFAULT (getdate()) NOT NULL,
    [OldID]          VARCHAR (10)     NULL,
    [UpdatedBy]      UNIQUEIDENTIFIER NULL,
    [UpdatedOn]      DATETIME         NULL,
    [ID]             BIGINT           IDENTITY (1, 1) NOT NULL,
    [UserIDNew]      INT              NULL,
    CONSTRAINT [PK__City__EFD6F5BF43A1090D] PRIMARY KEY CLUSTERED ([IATACode] ASC)
);


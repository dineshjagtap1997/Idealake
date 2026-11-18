CREATE TABLE [dbo].[State] (
    [State_ID]         INT              IDENTITY (1, 1) NOT NULL,
    [Country_IATACode] CHAR (4)         NOT NULL,
    [Name]             VARCHAR (50)     NOT NULL,
    [Tax_On_RateCard]  BIT              CONSTRAINT [DF__State__Tax_On_Ra__047AA831] DEFAULT ((0)) NOT NULL,
    [IsActive]         BIT              CONSTRAINT [DF__State__IsActive__056ECC6A] DEFAULT ((1)) NOT NULL,
    [Operation]        VARCHAR (50)     NOT NULL,
    [OperationBy]      UNIQUEIDENTIFIER NOT NULL,
    [OperationOn]      DATETIME         CONSTRAINT [DF__State__Operation__0662F0A3] DEFAULT (getdate()) NOT NULL,
    [OldID]            INT              NULL,
    [StateCode]        VARCHAR (50)     NULL,
    [StateCodeID]      BIGINT           NULL,
    [BranchCode]       NVARCHAR (500)   NULL,
    [UpdatedBy]        UNIQUEIDENTIFIER NULL,
    [UpdatedOn]        DATETIME         NULL,
    CONSTRAINT [PK_State_1] PRIMARY KEY CLUSTERED ([State_ID] ASC)
);


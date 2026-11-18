CREATE TABLE [dbo].[TransportServices] (
    [Code]                INT              IDENTITY (1, 1) NOT NULL,
    [Name]                VARCHAR (500)    NOT NULL,
    [ModeOfTransport]     TINYINT          NULL,
    [ShortDescription]    VARCHAR (500)    NULL,
    [DetailedDescription] VARCHAR (MAX)    NULL,
    [IsActive]            BIT              CONSTRAINT [DF_TransportService_IsActive] DEFAULT ((1)) NOT NULL,
    [Operation]           VARCHAR (10)     NOT NULL,
    [OperationBy]         UNIQUEIDENTIFIER NOT NULL,
    [OperationOn]         DATETIME         CONSTRAINT [DF_TransportService_OperationOn] DEFAULT (getdate()) NOT NULL,
    [OldID]               VARCHAR (10)     NULL,
    [IsPreferred]         BIT              DEFAULT ((0)) NOT NULL,
    [Pickup]              INT              NULL,
    [DropOff]             INT              NULL,
    [IsViceVersa]         BIT              CONSTRAINT [DF_TransportServices_IsViceVersa] DEFAULT ((0)) NULL,
    [TotalDays]           BIGINT           NULL,
    [UpdatedBy]           UNIQUEIDENTIFIER NULL,
    [UpdatedOn]           DATETIME         NULL,
    CONSTRAINT [PK_TransportService] PRIMARY KEY CLUSTERED ([Code] ASC)
);


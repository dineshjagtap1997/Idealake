CREATE TABLE [dbo].[VehicleTypeMaster] (
    [ID]          INT              IDENTITY (1, 1) NOT NULL,
    [VehicleType] VARCHAR (50)     NOT NULL,
    [IsActive]    BIT              CONSTRAINT [DF_VehicleTypeMaster_IsActive] DEFAULT ((1)) NOT NULL,
    [MISSequence] INT              NULL,
    [Operation]   VARCHAR (10)     NOT NULL,
    [OperationBy] UNIQUEIDENTIFIER NOT NULL,
    [OperationOn] DATETIME         CONSTRAINT [DF_VehicleTypeMaster_OperationOn] DEFAULT (getdate()) NOT NULL,
    [OldID]       INT              NULL,
    [IsOnline]    BIT              DEFAULT ((0)) NULL,
    [DisplayName] VARCHAR (200)    NULL,
    [UpdatedBy]   UNIQUEIDENTIFIER NULL,
    [UpdatedOn]   DATETIME         NULL,
    CONSTRAINT [PK_VehicleTypeMaster] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 80)
);


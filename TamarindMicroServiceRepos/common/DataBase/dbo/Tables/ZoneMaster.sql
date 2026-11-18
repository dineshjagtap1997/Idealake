CREATE TABLE [dbo].[ZoneMaster] (
    [ZoneID]          INT              IDENTITY (1, 1) NOT NULL,
    [ZoneName]        VARCHAR (100)    NOT NULL,
    [IsActive]        BIT              NOT NULL,
    [Operation]       VARCHAR (10)     NOT NULL,
    [OperationBy]     UNIQUEIDENTIFIER NOT NULL,
    [OperationOn]     DATETIME         CONSTRAINT [DF_ZoneMaster_OperationOn] DEFAULT (getdate()) NOT NULL,
    [HeaderInfo_Zone] VARCHAR (50)     NULL,
    [UpdatedBy]       UNIQUEIDENTIFIER NULL,
    [UpdatedOn]       DATETIME         NULL,
    CONSTRAINT [PK_ZoneMaster] PRIMARY KEY CLUSTERED ([ZoneID] ASC)
);


CREATE TABLE [dbo].[AirlineCodeMaster] (
    [Airlineid]   BIGINT           IDENTITY (1, 1) NOT NULL,
    [AirlineCode] NVARCHAR (5)     NULL,
    [AirlineName] NVARCHAR (80)    NULL,
    [IsActive]    BIT              NULL,
    [CreatedBy]   UNIQUEIDENTIFIER NULL,
    [CreatedDate] DATETIME         NULL,
    [UpdatedBy]   UNIQUEIDENTIFIER NULL,
    [UpdatedOn]   DATETIME         NULL,
    [Operation]   NVARCHAR (10)    NULL,
    CONSTRAINT [PK_AirlineCodeMaster] PRIMARY KEY CLUSTERED ([Airlineid] ASC)
);


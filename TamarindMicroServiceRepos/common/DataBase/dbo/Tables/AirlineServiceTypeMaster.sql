CREATE TABLE [dbo].[AirlineServiceTypeMaster] (
    [AirlineServiceTypeID] BIGINT           IDENTITY (1, 1) NOT NULL,
    [AirlineServiceType]   NVARCHAR (50)    NULL,
    [ShortCode]            NVARCHAR (5)     NULL,
    [IsActive]             BIT              NULL,
    [CreatedBy]            UNIQUEIDENTIFIER NULL,
    [CreatedDate]          DATETIME         NULL,
    [UpdatedBy]            UNIQUEIDENTIFIER NULL,
    [UpdatedOn]            DATETIME         NULL,
    [Operation]            NVARCHAR (10)    NULL,
    CONSTRAINT [PK_AirlineServiceTypeMaster] PRIMARY KEY CLUSTERED ([AirlineServiceTypeID] ASC)
);


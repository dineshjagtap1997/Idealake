CREATE TABLE [RateCards].[TransportRateDetails] (
    [TransportRateDetailID] BIGINT           IDENTITY (1, 1) NOT NULL,
    [TaxID]                 INT              NULL,
    [VehicleCategoryID]     INT              NULL,
    [VehicleBaseID]         INT              NULL,
    [ValidFrom]             DATETIME         NULL,
    [ValidTo]               DATETIME         NULL,
    [MISSequence]           VARCHAR (30)     NULL,
    [IsActive]              BIT              DEFAULT ((1)) NULL,
    [CreatedBy]             UNIQUEIDENTIFIER DEFAULT (newid()) NULL,
    [CreatedOn]             DATETIME         DEFAULT (getdate()) NULL,
    [UpdatedBy]             UNIQUEIDENTIFIER NULL,
    [UpdatedOn]             DATETIME         NULL,
    [TransportRateID]       BIGINT           NULL,
    PRIMARY KEY CLUSTERED ([TransportRateDetailID] ASC)
);


CREATE TABLE [RateCards].[RateValidityMaster] (
    [RateValidityID]    BIGINT           IDENTITY (1, 1) NOT NULL,
    [BookFrom]          DATETIME         NULL,
    [BookTo]            DATETIME         NULL,
    [RateValidFrom]     DATETIME         NOT NULL,
    [RateValidTo]       DATETIME         NOT NULL,
    [HotelRateDetailID] BIGINT           NULL,
    [CreatedOn]         DATETIME         NULL,
    [UpdatedOn]         DATETIME         NULL,
    [IsActive]          BIT              DEFAULT ((0)) NULL,
    [UpdatedBy]         UNIQUEIDENTIFIER NULL,
    [CreatedBy]         UNIQUEIDENTIFIER NULL,
    PRIMARY KEY CLUSTERED ([RateValidityID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_RateValidityMaster_ValidDates]
    ON [RateCards].[RateValidityMaster]([HotelRateDetailID] ASC, [IsActive] ASC, [RateValidFrom] ASC, [RateValidTo] ASC);


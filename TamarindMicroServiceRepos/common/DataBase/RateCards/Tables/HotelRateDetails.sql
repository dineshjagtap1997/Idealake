CREATE TABLE [RateCards].[HotelRateDetails] (
    [HotelRateDetailID]     BIGINT           IDENTITY (1, 1) NOT NULL,
    [HotelRateID]           BIGINT           NOT NULL,
    [RoomCategoryID]        INT              NOT NULL,
    [Days]                  VARCHAR (7)      NOT NULL,
    [MealPlanID]            INT              NOT NULL,
    [TransferID]            INT              NOT NULL,
    [MISSequence]           NVARCHAR (50)    NULL,
    [IsActive]              BIT              DEFAULT ((0)) NOT NULL,
    [MinNights]             INT              NULL,
    [MaxNights]             INT              NULL,
    [RateTypeID]            INT              DEFAULT ((0)) NOT NULL,
    [OfferTypeID]           INT              NULL,
    [CreatedOn]             DATETIME         NOT NULL,
    [UpdatedOn]             DATETIME         NULL,
    [CreatedBy]             UNIQUEIDENTIFIER NULL,
    [UpdatedBy]             UNIQUEIDENTIFIER NULL,
    [OldHotelRateDetailsID] UNIQUEIDENTIFIER NULL,
    [TaxID]                 INT              NULL,
    [FITorGIT]              INT              NULL,
    [BusinessType]          INT              NULL,
    [FIT]                   BIT              NULL,
    [GIT]                   BIT              NULL,
    PRIMARY KEY CLUSTERED ([HotelRateDetailID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_HotelRateDetails_ActiveNights]
    ON [RateCards].[HotelRateDetails]([HotelRateID] ASC, [IsActive] ASC, [MinNights] ASC, [MaxNights] ASC, [RoomCategoryID] ASC, [FIT] ASC, [GIT] ASC, [BusinessType] ASC);


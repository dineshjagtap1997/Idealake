CREATE TABLE [RateCards].[HotelMealOverviewMaster] (
    [HotelRateMealID]       BIGINT           IDENTITY (1, 1) NOT NULL,
    [HotelRateDetailID]     BIGINT           NULL,
    [MealTypeID]            INT              NULL,
    [GstPercentage]         DECIMAL (18, 2)  NULL,
    [GstAmount]             DECIMAL (18, 2)  NULL,
    [NetAmountIncludingTax] DECIMAL (18, 2)  NULL,
    [NetAmountExcludingTax] DECIMAL (18, 2)  NULL,
    [IsActive]              BIT              DEFAULT ((1)) NULL,
    [CreatedOn]             DATETIME         DEFAULT (getdate()) NULL,
    [UpdatedOn]             DATETIME         NULL,
    [MasterCommissionID]    INT              NULL,
    [UpdatedBy]             UNIQUEIDENTIFIER NULL,
    [CreatedBy]             UNIQUEIDENTIFIER NULL,
    [IsMealDetails]         BIT              NULL,
    [DefineAmount]          BIT              NULL,
    PRIMARY KEY CLUSTERED ([HotelRateMealID] ASC)
);


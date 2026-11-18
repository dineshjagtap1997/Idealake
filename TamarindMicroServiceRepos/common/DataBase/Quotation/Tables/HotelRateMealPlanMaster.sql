CREATE TABLE [Quotation].[HotelRateMealPlanMaster] (
    [QuotationHotelRateMealId] BIGINT           IDENTITY (1, 1) NOT NULL,
    [MealTypeID]               INT              NULL,
    [GstPercentage]            DECIMAL (9, 2)   NULL,
    [GstAmount]                DECIMAL (18, 2)  NULL,
    [NetAmountIncludingTax]    DECIMAL (18, 2)  NULL,
    [NetAmountExcludingTax]    DECIMAL (18, 2)  NULL,
    [IsActive]                 BIT              NULL,
    [CreatedOn]                DATETIME         NULL,
    [UpdatedOn]                DATETIME         NULL,
    [MasterCommissionID]       INT              NULL,
    [UpdatedBy]                UNIQUEIDENTIFIER NULL,
    [CreatedBy]                UNIQUEIDENTIFIER NULL,
    [IsMealDetails]            BIT              NULL,
    [DefineAmount]             BIT              NULL,
    [QuotationHotelRateID]     INT              NULL,
    [SellingRate]              DECIMAL (18, 2)  NULL,
    [ReasonMasterId]           INT              NULL,
    [HotelRateID]              BIGINT           NULL,
    [QuotationID]              BIGINT           NULL,
    [HotelRateDetailID]        INT              NULL,
    [Disclaimer]               NVARCHAR (MAX)   NULL,
<<<<<<< HEAD
<<<<<<< HEAD
=======
    [IsSupplementary]          BIT              NULL,
    [IsGross]                  BIT              NULL,
>>>>>>> dev
=======
    [IsSupplementary]          BIT              NULL,
    [IsGross]                  BIT              NULL,
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    PRIMARY KEY CLUSTERED ([QuotationHotelRateMealId] ASC)
);


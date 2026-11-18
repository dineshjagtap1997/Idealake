CREATE TABLE [Quotation].[HotelRateCardMaster] (
    [ID]                   INT              IDENTITY (1, 1) NOT NULL,
    [HotelRateID]          BIGINT           NULL,
    [CardNumber]           NVARCHAR (50)    NULL,
    [ContractDate]         DATETIME         NULL,
    [Days]                 NVARCHAR (100)   NULL,
    [RoomCategoryID]       INT              NULL,
    [MealPlanID]           INT              NULL,
    [InfoForRemark]        NVARCHAR (500)   NULL,
    [HotelID]              INT              NULL,
    [StateID]              INT              NULL,
    [GstStatus]            NVARCHAR (10)    NULL,
    [CityID]               NVARCHAR (10)    NULL,
    [Heading]              NVARCHAR (200)   NULL,
    [InfoForAgent]         NVARCHAR (MAX)   NULL,
    [InfoForOperation]     NVARCHAR (MAX)   NULL,
    [PaymentTypeID]        INT              NULL,
    [RateCardModeTypeID]   INT              NULL,
    [RateTypeID]           INT              NULL,
    [ValueAddOn]           NVARCHAR (MAX)   NULL,
    [IsActive]             BIT              NULL,
    [QuotationID]          BIGINT           NULL,
    [Disclaimer]           NVARCHAR (500)   NULL,
    [CheckIn]              DATETIME         NULL,
    [CheckOut]             DATETIME         NULL,
    [OfferTypeID]          INT              NULL,
    [HotelRateDetailID]    INT              NULL,
    [UpdatedBy]            UNIQUEIDENTIFIER NULL,
    [UpdatedOn]            DATETIME         NULL,
    [ShowAnnouncement]     BIT              DEFAULT ((0)) NULL,
    [ShowTransfers]        BIT              DEFAULT ((0)) NULL,
    [ShowValueAddOns]      BIT              DEFAULT ((0)) NULL,
    [ShowCancellationDays] BIT              DEFAULT ((0)) NULL,
    [IsCustom]             BIT              NULL,
    [CurrencyID]           NVARCHAR (50)    NULL,
    [IsSummary]            BIT              DEFAULT ((0)) NOT NULL,
    [CreatedBy]            UNIQUEIDENTIFIER NULL,
    [CreatedOn]            DATETIME         NULL,
<<<<<<< HEAD
<<<<<<< HEAD
=======
    [VendorID]             BIGINT           NULL,
>>>>>>> dev
=======
    [VendorID]             BIGINT           NULL,
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


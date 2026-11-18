CREATE TYPE [dbo].[HotelMealPlanTableType] AS TABLE (
    [MealTypeID]           INT             NULL,
    [SellingRate]          DECIMAL (18, 2) NULL,
    [ReasonMasterId]       INT             NULL,
    [Disclaimer]           NVARCHAR (MAX)  NULL,
<<<<<<< HEAD
<<<<<<< HEAD
    [OthersRateCardMealID] BIGINT          NULL);
=======
    [OthersRateCardMealID] BIGINT          NULL,
    [IsSupplementary]      BIT             NULL,
    [IsGross]              BIT             NULL);
>>>>>>> dev
=======
    [OthersRateCardMealID] BIGINT          NULL,
    [IsSupplementary]      BIT             NULL,
    [IsGross]              BIT             NULL);
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6


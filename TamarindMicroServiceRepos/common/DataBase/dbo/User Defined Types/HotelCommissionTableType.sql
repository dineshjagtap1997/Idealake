CREATE TYPE [dbo].[HotelCommissionTableType] AS TABLE (
    [CommissionMasterID]         BIGINT          NULL,
    [CommMstId]                  INT             NULL,
    [GrossRate]                  DECIMAL (18, 2) NULL,
    [IsMarkup]                   BIT             NULL,
    [MarkupValue]                DECIMAL (18, 2) NULL,
    [SellingRate]                DECIMAL (18, 2) NULL,
    [ReasonMasterId]             INT             NULL,
    [Disclaimer]                 NVARCHAR (MAX)  NULL,
    [OthersRateCardCommissionID] BIGINT          NULL);


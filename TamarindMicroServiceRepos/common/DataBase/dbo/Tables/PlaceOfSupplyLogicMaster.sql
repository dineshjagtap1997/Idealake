CREATE TABLE [dbo].[PlaceOfSupplyLogicMaster] (
    [ID]              INT              IDENTITY (1, 1) NOT NULL,
    [TypeID]          INT              NULL,
    [ServiceID]       INT              NULL,
    [BuyerLocationID] INT              NULL,
    [IsGST]           BIT              NULL,
    [IsAddress]       INT              NULL,
    [ServiceLocID]    INT              NULL,
    [POSID]           INT              NULL,
    [POSStateCode]    INT              NULL,
    [IsCommercial]    BIT              NULL,
    [IsActive]        BIT              NULL,
    [Operation]       NVARCHAR (50)    NULL,
    [Createdby]       UNIQUEIDENTIFIER NULL,
    [CreatedDatetime] DATETIME         NULL,
    [validFrom]       DATETIME         NULL,
    [validTo]         DATETIME         NULL,
    [Updatedby]       UNIQUEIDENTIFIER NULL,
    [UpdatedTime]     DATETIME         NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


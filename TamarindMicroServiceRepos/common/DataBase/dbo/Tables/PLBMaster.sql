CREATE TABLE [dbo].[PLBMaster] (
    [ID]              INT              IDENTITY (1, 1) NOT NULL,
    [CityCode]        CHAR (3)         NOT NULL,
    [HotelID]         INT              NOT NULL,
    [ValidFrom]       DATETIME         NULL,
    [ValidTo]         DATETIME         NULL,
    [Target]          VARCHAR (40)     NULL,
    [ValidonRateType] VARCHAR (50)     NULL,
    [PLBClaim]        VARCHAR (50)     NULL,
    [PLBType]         VARCHAR (20)     NULL,
    [ClaimPeriod]     VARCHAR (20)     NULL,
    [IsActive]        BIT              CONSTRAINT [DF__PLBMaster__IsActive__4589517F] DEFAULT ((1)) NOT NULL,
    [Operation]       VARCHAR (10)     NOT NULL,
    [OperationOn]     DATETIME         CONSTRAINT [DF__PLBMaster__Operadt__467D75B8] DEFAULT (getdate()) NOT NULL,
    [UpdatedOn]       DATETIME         NULL,
    [HotelGroupID]    INT              NULL,
    [OperationBy]     UNIQUEIDENTIFIER NULL,
    [UpdatedBy]       UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_PlbMasterID] PRIMARY KEY CLUSTERED ([ID] ASC)
);


CREATE TABLE [dbo].[RateCommissionMaster] (
    [CommMasterID] BIGINT        IDENTITY (1, 1) NOT NULL,
    [Type]         INT           NOT NULL,
    [RateType]     VARCHAR (100) NULL,
    PRIMARY KEY CLUSTERED ([CommMasterID] ASC)
);


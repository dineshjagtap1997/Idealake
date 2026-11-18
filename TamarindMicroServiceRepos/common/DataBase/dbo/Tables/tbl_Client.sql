CREATE TABLE [dbo].[tbl_Client] (
    [ClientId]        BIGINT        IDENTITY (1, 1) NOT NULL,
    [ClientName]      VARCHAR (255) NULL,
    [MobileNumber]    VARCHAR (20)  NULL,
    [Reference]       VARCHAR (MAX) NULL,
    [EmailID]         VARCHAR (255) NULL,
    [CreatedBy]       INT           NULL,
    [CreatedDateTime] DATETIME      NOT NULL,
    [UpdatedBy]       INT           NULL,
    [UpdatedDateTime] DATETIME      NULL,
    PRIMARY KEY CLUSTERED ([ClientId] ASC)
);


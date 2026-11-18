CREATE TABLE [Quotation].[ReasonMaster] (
    [ID]       INT            IDENTITY (1, 1) NOT NULL,
    [Reason]   NVARCHAR (500) NULL,
    [isActive] BIT            NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


CREATE TABLE [dbo].[VendorPreferred] (
    [PreferredVendorID] INT              IDENTITY (1, 1) NOT NULL,
    [VendorID]          INT              NOT NULL,
    [ValidFrom]         DATETIME         NOT NULL,
    [ValidTo]           DATETIME         NOT NULL,
    [IsPreferred]       BIT              NOT NULL,
    [Operation]         VARCHAR (10)     NOT NULL,
    [OperationBy]       UNIQUEIDENTIFIER NOT NULL,
    [OperationOn]       DATETIME         NOT NULL,
    CONSTRAINT [PK_VendorPreferred] PRIMARY KEY CLUSTERED ([PreferredVendorID] ASC)
);


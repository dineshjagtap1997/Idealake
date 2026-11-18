CREATE TABLE [dbo].[ServiceTaxCategory] (
    [ID]                 INT          IDENTITY (1, 1) NOT NULL,
    [ServiceTaxCategory] VARCHAR (50) NOT NULL,
    [IsActive]           BIT          NOT NULL,
    CONSTRAINT [PK_ServiceTaxCategory] PRIMARY KEY CLUSTERED ([ID] ASC)
);


CREATE TABLE [dbo].[MVCDemo] (
    [ID]              INT            IDENTITY (1, 1) NOT NULL,
    [Name]            NVARCHAR (100) NULL,
    [Address]         NVARCHAR (255) NULL,
    [Mobileno]        NVARCHAR (20)  NULL,
    [Birthdate]       DATE           NULL,
    [EmailID]         NVARCHAR (100) NULL,
    [IsActive]        BIT            NULL,
    [Createdby]       VARCHAR (100)  NULL,
    [CreatedDateTime] DATETIME       NULL,
    [UpdatedBy]       VARCHAR (100)  NULL,
    [UpdatedDateTime] DATETIME       NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


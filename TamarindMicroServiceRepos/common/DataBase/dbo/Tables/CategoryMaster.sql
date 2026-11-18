CREATE TABLE [dbo].[CategoryMaster] (
    [CategoryTypeID] INT          IDENTITY (1, 1) NOT NULL,
    [Category]       VARCHAR (40) NULL,
    [IsActive]       BIT          DEFAULT ((1)) NULL,
    PRIMARY KEY CLUSTERED ([CategoryTypeID] ASC)
);


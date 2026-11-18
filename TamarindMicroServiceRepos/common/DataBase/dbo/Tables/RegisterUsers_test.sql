CREATE TABLE [dbo].[RegisterUsers_test] (
    [Id]       INT          IDENTITY (1, 1) NOT NULL,
    [Name]     VARCHAR (50) NULL,
    [Email]    VARCHAR (50) NULL,
    [Password] VARCHAR (50) NULL,
    [Phone]    INT          NULL,
    [IsActive] BIT          NULL
);


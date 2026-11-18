CREATE TABLE [dbo].[RefreshTokens] (
    [Id]             INT              IDENTITY (1, 1) NOT NULL,
    [RefreshToken]   NVARCHAR (500)   NULL,
    [ExpirationDate] DATETIME         NULL,
    [UpdatedBy]      UNIQUEIDENTIFIER NULL,
    [UpdatedOn]      DATETIME         NULL,
    [EmpId]          INT              NULL,
    [IsRemembered]   BIT              DEFAULT ((0)) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


CREATE TABLE [dbo].[UserSessionTokens] (
    [Id]                 INT            IDENTITY (1, 1) NOT NULL,
    [UserId]             NVARCHAR (100) NOT NULL,
    [AccessToken]        NVARCHAR (MAX) NULL,
    [RefreshToken]       NVARCHAR (MAX) NULL,
    [TokenExpiry]        DATETIME       NULL,
    [RefreshTokenExpiry] DATETIME       NULL,
    [LastApiCall]        DATETIME       NULL,
    [CreatedAt]          DATETIME       DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


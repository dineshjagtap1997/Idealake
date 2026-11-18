CREATE TABLE [dbo].[HotelRegistration_Mail] (
    [ID]           INT            IDENTITY (1, 1) NOT NULL,
    [FromEmail]    NVARCHAR (255) NOT NULL,
    [ToEmail]      NVARCHAR (255) NOT NULL,
    [CcEmail]      NVARCHAR (255) NULL,
    [EmailSubject] NVARCHAR (500) NOT NULL,
    [EmailBody]    NVARCHAR (MAX) NOT NULL,
    [CreatedDate]  DATETIME       DEFAULT (getdate()) NULL,
    [CreatedBy]    NVARCHAR (100) NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


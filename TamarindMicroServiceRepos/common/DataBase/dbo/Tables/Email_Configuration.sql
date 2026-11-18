CREATE TABLE [dbo].[Email_Configuration] (
    [EmailTemplateID]  INT            IDENTITY (1, 1) NOT NULL,
    [EmailCategory]    TINYINT        NOT NULL,
    [FromEmailAddress] VARCHAR (35)   NOT NULL,
    [ToEmailAddress]   VARCHAR (1000) NOT NULL,
    [Subject]          VARCHAR (200)  NOT NULL,
    [EmailBody]        NVARCHAR (MAX) NOT NULL,
    [Operation]        VARCHAR (10)   NOT NULL,
    [OperationOn]      DATETIME       CONSTRAINT [DF_Email_Configuration_OperationOn] DEFAULT (getdate()) NOT NULL,
    [CCEmailAddress]   VARCHAR (1000) NULL,
<<<<<<< HEAD
<<<<<<< HEAD
    [OperationBy]      INT            NULL,
    [DocumentID]       INT            NULL,
=======
    [OperationBy]      VARCHAR (250)  NULL,
    [DocumentID]       VARCHAR (250)  NULL,
>>>>>>> dev
=======
    [OperationBy]      VARCHAR (250)  NULL,
    [DocumentID]       VARCHAR (250)  NULL,
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    CONSTRAINT [PK_Email_Configuration] PRIMARY KEY CLUSTERED ([EmailTemplateID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1 - New User Creation, 2 - Change Password, 3 - New Agent Registration Request, 4 - Login IDs for Agent, 5 - Send Request for Contacts Edit,6-Send Request For Monument,7-Missing ROE
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Email_Configuration', @level2type = N'COLUMN', @level2name = N'EmailCategory';


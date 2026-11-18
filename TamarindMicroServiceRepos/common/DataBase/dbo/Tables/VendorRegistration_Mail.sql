CREATE TABLE [dbo].[VendorRegistration_Mail] (
    [ID]                    INT             IDENTITY (1, 1) NOT NULL,
    [FromEmail]             NVARCHAR (255)  NOT NULL,
    [ToEmail]               NVARCHAR (255)  NOT NULL,
    [CcEmail]               NVARCHAR (255)  NULL,
    [EmailSubject]          NVARCHAR (500)  NOT NULL,
    [EmailBody]             NVARCHAR (MAX)  NOT NULL,
    [ReasonForAddingVendor] NVARCHAR (1000) NULL,
    [VendorService]         NVARCHAR (255)  NOT NULL,
    [AccountGroupCode]      NVARCHAR (50)   NOT NULL,
    [AccountGroupName]      NVARCHAR (255)  NOT NULL,
    [CreatedDate]           DATETIME        DEFAULT (getdate()) NULL,
    [CreatedBy]             NVARCHAR (100)  NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


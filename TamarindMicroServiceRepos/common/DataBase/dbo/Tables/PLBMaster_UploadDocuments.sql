CREATE TABLE [dbo].[PLBMaster_UploadDocuments] (
    [DocumentID]     INT              IDENTITY (1, 1) NOT NULL,
    [PLBMasterID]    INT              NULL,
    [DocumentName]   VARCHAR (200)    NOT NULL,
    [DocMimeType]    VARCHAR (100)    NULL,
    [Documents]      VARBINARY (MAX)  NULL,
    [UploadedBy]     UNIQUEIDENTIFIER NOT NULL,
    [UploadedOn]     DATETIME         CONSTRAINT [DF_PLBMaster_UploadDocuments_UploadedOn] DEFAULT (getdate()) NOT NULL,
    [UploadedByText] VARCHAR (20)     NULL,
    CONSTRAINT [PK_PLBMaster_UploadDocuments] PRIMARY KEY CLUSTERED ([DocumentID] ASC)
);


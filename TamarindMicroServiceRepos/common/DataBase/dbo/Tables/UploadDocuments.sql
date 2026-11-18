CREATE TABLE [dbo].[UploadDocuments] (
    [DocumentID]     INT            IDENTITY (1, 1) NOT NULL,
    [ParentTypeID]   TINYINT        NOT NULL,
    [DocumentName]   VARCHAR (200)  NOT NULL,
    [DocMimeType]    VARCHAR (100)  NULL,
<<<<<<< HEAD
<<<<<<< HEAD
    [UploadedBy]     INT            NOT NULL,
    [UploadedOn]     DATETIME       DEFAULT (getdate()) NOT NULL,
    [UpdatedBy]      INT            NULL,
    [UpdatedOn]      DATETIME       NULL,
    [Documents]      NVARCHAR (MAX) NULL,
    [DocumentTypeId] INT            NULL
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    [UploadedOn]     DATETIME       DEFAULT (getdate()) NOT NULL,
    [UpdatedOn]      DATETIME       NULL,
    [Documents]      NVARCHAR (MAX) NULL,
    [DocumentTypeId] INT            NULL,
    [UpdatedBy]      INT            NULL,
    [UploadedBy]     INT            NULL
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
);


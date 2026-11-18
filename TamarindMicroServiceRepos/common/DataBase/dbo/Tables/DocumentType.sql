CREATE TABLE [dbo].[DocumentType] (
<<<<<<< HEAD
<<<<<<< HEAD
    [DocumentTypeId] INT           IDENTITY (1, 1) NOT NULL,
    [DocumentType]   VARCHAR (255) NOT NULL,
    [IsActive]       BIT           DEFAULT ((1)) NOT NULL,
    [CreatedBy]      INT           NOT NULL,
    [CreatedOn]      DATETIME      DEFAULT (getdate()) NOT NULL,
    [UpdatedBy]      INT           NULL,
    [UpdatedOn]      DATETIME      NULL,
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    [DocumentTypeId] INT              IDENTITY (1, 1) NOT NULL,
    [DocumentType]   VARCHAR (255)    NOT NULL,
    [IsActive]       BIT              DEFAULT ((1)) NOT NULL,
    [CreatedOn]      DATETIME         DEFAULT (getdate()) NOT NULL,
    [UpdatedOn]      DATETIME         NULL,
    [CreatedBy]      UNIQUEIDENTIFIER NULL,
    [UpdatedBy]      UNIQUEIDENTIFIER NULL,
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    PRIMARY KEY CLUSTERED ([DocumentTypeId] ASC)
);


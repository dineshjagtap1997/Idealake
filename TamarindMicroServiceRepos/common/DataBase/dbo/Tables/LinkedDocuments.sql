CREATE TABLE [dbo].[LinkedDocuments] (
    [DocumentLinkID] INT            IDENTITY (1, 1) NOT NULL,
    [ParentID]       INT            NOT NULL,
    [ParentTypeID]   TINYINT        NOT NULL,
    [DocumentID]     NVARCHAR (MAX) NULL
);


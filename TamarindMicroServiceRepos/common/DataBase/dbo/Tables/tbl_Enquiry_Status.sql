CREATE TABLE [dbo].[tbl_Enquiry_Status] (
    [StatusID]          INT            IDENTITY (1, 1) NOT NULL,
    [StatusDescription] VARCHAR (100)  NOT NULL,
    [CreatedDateTime]   DATETIME       NULL,
    [CreatedBy]         INT            NULL,
    [UpdatedBy]         INT            NULL,
    [UpdatedDateTime]   DATETIME       NULL,
    [Colourcode]        NVARCHAR (500) NULL,
<<<<<<< HEAD
<<<<<<< HEAD
=======
    [DisplayOrder]      INT            NULL,
>>>>>>> dev
=======
    [DisplayOrder]      INT            NULL,
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    PRIMARY KEY CLUSTERED ([StatusID] ASC)
);


CREATE TABLE [dbo].[ContactDetails] (
    [ContactDetailsID]        INT              IDENTITY (1, 1) NOT NULL,
    [ParentID]                INT              NOT NULL,
    [TypeID]                  TINYINT          NOT NULL,
    [IsPrimaryContact]        BIT              NULL,
    [SalutationID]            INT              NULL,
    [FirstName]               VARCHAR (50)     NOT NULL,
    [LastName]                VARCHAR (50)     NULL,
    [DesignationOrDepartment] VARCHAR (100)    NULL,
    [EmailID]                 VARCHAR (200)    NULL,
    [OfficeNo]                VARCHAR (30)     NULL,
    [MobileNo]                VARCHAR (30)     NULL,
    [FaxNo]                   VARCHAR (30)     NULL,
    [DateofBirth]             DATETIME         NULL,
    [CityIATACode]            CHAR (3)         NULL,
    [IsActive]                BIT              NULL,
    [IsAccStatement]          BIT              DEFAULT ((0)) NULL,
    [IsCC]                    BIT              DEFAULT ((0)) NULL,
    [IsForContracting]        BIT              DEFAULT ((0)) NULL,
    [InsertedDate]            DATETIME         NULL,
    [UpdatedOn]               DATETIME         NULL,
    [IsBills]                 BIT              NULL,
    [CreatedBy]               UNIQUEIDENTIFIER NULL,
    [UpdatedBy]               VARCHAR (200)    NULL,
    [BizPStatus]              BIT              NULL,
<<<<<<< HEAD
<<<<<<< HEAD
=======
    [HideNumberEmail]         BIT              DEFAULT ((0)) NULL,
>>>>>>> dev
=======
    [HideNumberEmail]         BIT              DEFAULT ((0)) NULL,
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    CONSTRAINT [PK_ContactDetails] PRIMARY KEY CLUSTERED ([ContactDetailsID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1-Hotel,2-Vendor,3-Agent', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ContactDetails', @level2type = N'COLUMN', @level2name = N'TypeID';


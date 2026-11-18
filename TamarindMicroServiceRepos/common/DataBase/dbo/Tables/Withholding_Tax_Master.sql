CREATE TABLE [dbo].[Withholding_Tax_Master] (
    [Tax_ID]      INT              IDENTITY (1, 1) NOT NULL,
    [Tax_Code]    CHAR (4)         NOT NULL,
    [Description] VARCHAR (50)     NULL,
    [IsActive]    BIT              NOT NULL,
    [Operation]   VARCHAR (50)     NULL,
    [CreatedBy]   UNIQUEIDENTIFIER NULL,
    [CreatedDate] DATETIME         DEFAULT (getdate()) NULL,
    [Updatedby]   UNIQUEIDENTIFIER NULL,
    [UpdatedOn]   DATETIME         DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([Tax_ID] ASC)
);


CREATE TABLE [dbo].[Agent_Classification_Master] (
    [ID]          INT              IDENTITY (1, 1) NOT NULL,
    [Description] NVARCHAR (50)    NOT NULL,
    [IsActive]    BIT              NOT NULL,
    [Operation]   NVARCHAR (10)    NOT NULL,
    [CreatedBy]   UNIQUEIDENTIFIER NOT NULL,
    [CreatedDate] DATETIME         NOT NULL,
    [Updatedby]   UNIQUEIDENTIFIER NOT NULL,
    [UpdatedOn]   DATETIME         NOT NULL,
    CONSTRAINT [PK_Agent_Classification_Master] PRIMARY KEY CLUSTERED ([ID] ASC)
);


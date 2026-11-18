CREATE TABLE [dbo].[Documents] (
    [DocumentID]   INT             IDENTITY (1, 1) NOT NULL,
    [ContactID]    INT             NOT NULL,
    [DocType]      VARCHAR (10)    NOT NULL,
    [DocumentData] VARBINARY (MAX) NOT NULL,
    PRIMARY KEY CLUSTERED ([DocumentID] ASC),
    CHECK ([DocType]='PAN' OR [DocType]='Passport')
);


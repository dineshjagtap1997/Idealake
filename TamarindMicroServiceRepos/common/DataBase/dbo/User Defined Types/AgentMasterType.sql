CREATE TYPE [dbo].[AgentMasterType] AS TABLE (
    [AgentName]     VARCHAR (200) NULL,
    [AgentGroup]    VARCHAR (50)  NULL,
    [LegalEntity]   NVARCHAR (50) NULL,
    [Market]        VARCHAR (50)  NULL,
    [LegalName]     VARCHAR (80)  NULL,
    [Address]       VARCHAR (MAX) NULL,
    [MarketCountry] VARCHAR (50)  NULL,
    [State]         VARCHAR (50)  NULL,
    [City]          VARCHAR (50)  NULL,
    [StateCode]     VARCHAR (500) NULL,
    [Phone]         VARCHAR (45)  NULL);


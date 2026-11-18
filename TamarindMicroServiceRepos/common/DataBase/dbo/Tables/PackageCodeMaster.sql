CREATE TABLE [dbo].[PackageCodeMaster] (
    [PackageID]        BIGINT           IDENTITY (1, 1) NOT NULL,
    [PkgMktCode]       VARCHAR (5)      NULL,
    [Nights]           INT              NULL,
    [StateRouteCode]   VARCHAR (5)      NULL,
    [ExtnAssignedCode] VARCHAR (3)      NULL,
    [PackageName]      VARCHAR (75)     NULL,
    [Remarks]          VARCHAR (75)     NULL,
    [PackageCode]      NVARCHAR (25)    NULL,
    [IsActive]         BIT              NULL,
    [Operation]        VARCHAR (10)     NULL,
    [OperationBy]      UNIQUEIDENTIFIER NULL,
    [OperationOn]      DATETIME         NULL,
    [UpdatedBy]        UNIQUEIDENTIFIER NULL,
    [UpdatedOn]        DATETIME         NULL
);


CREATE TYPE [dbo].[TableMappingType] AS TABLE (
    [SourceDatabase]      NVARCHAR (128) NULL,
    [SourceTable]         NVARCHAR (128) NULL,
    [DestinationDatabase] NVARCHAR (128) NULL,
    [DestinationTable]    NVARCHAR (128) NULL,
    [TopRecords]          INT            NULL);


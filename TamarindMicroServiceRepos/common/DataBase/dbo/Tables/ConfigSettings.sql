CREATE TABLE [dbo].[ConfigSettings] (
    [ConfigSettingID] INT              IDENTITY (1, 1) NOT NULL,
    [ConfigKey]       VARCHAR (100)    NULL,
    [ConfigValue]     VARCHAR (100)    NULL,
    [CreatedDate]     DATETIME         NULL,
    [UpdatedDate]     DATETIME         NULL,
    [CreatedBy]       UNIQUEIDENTIFIER NULL,
    [UpdatedBy]       UNIQUEIDENTIFIER NULL
);


CREATE TABLE [dbo].[UploadImage] (
    [ID]             INT            IDENTITY (1, 1) NOT NULL,
    [ParentID]       INT            NOT NULL,
    [ParentPageType] TINYINT        NOT NULL,
    [ImageName]      VARCHAR (200)  NOT NULL,
    [Image]          NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_UploadImage] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1-Guide,2-Transport,3-Special,4-Monument,5-VehicleMaster,6-Hotel Master,7-Agent,8-DestinationDetails', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'UploadImage', @level2type = N'COLUMN', @level2name = N'ParentPageType';


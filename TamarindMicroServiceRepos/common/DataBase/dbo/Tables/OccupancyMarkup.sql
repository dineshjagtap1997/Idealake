CREATE TABLE [dbo].[OccupancyMarkup] (
    [OccupancyID]         INT              IDENTITY (1, 1) NOT NULL,
    [ParentRateDetailsID] UNIQUEIDENTIFIER NOT NULL,
    [ParentRateID]        INT              NOT NULL,
    [ParentRateType]      TINYINT          NOT NULL,
    [AgentCategoryID]     INT              NOT NULL,
    [Occupancy]           NUMERIC (18, 2)  NULL,
    CONSTRAINT [PK_OccupancyMarkup] PRIMARY KEY CLUSTERED ([OccupancyID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1-Guide,2-Monument,3-Transport,4-MOT,5-SpecialService', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'OccupancyMarkup', @level2type = N'COLUMN', @level2name = N'ParentRateType';


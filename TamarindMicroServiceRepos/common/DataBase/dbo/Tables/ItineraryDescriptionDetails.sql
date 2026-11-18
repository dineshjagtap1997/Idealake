CREATE TABLE [dbo].[ItineraryDescriptionDetails] (
    [ItineraryDescDetailID] INT     IDENTITY (1, 1) NOT NULL,
    [ItineraryDescID]       INT     NOT NULL,
    [ServiceType]           TINYINT NOT NULL,
    [ServiceID]             INT     NOT NULL,
    [IsActive]              BIT     NULL,
    CONSTRAINT [PK_ItineraryDescriptionDetails] PRIMARY KEY CLUSTERED ([ItineraryDescDetailID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Accomodation=1,Transport=2,Monument=3,Special=4,Guide=5,MOT=6', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ItineraryDescriptionDetails', @level2type = N'COLUMN', @level2name = N'ServiceType';


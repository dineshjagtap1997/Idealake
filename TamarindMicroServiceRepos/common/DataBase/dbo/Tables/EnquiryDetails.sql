CREATE TABLE [dbo].[EnquiryDetails] (
    [EnquiryID]             UNIQUEIDENTIFIER CONSTRAINT [DF_EnquiryDetails_EnquiryID] DEFAULT (newid()) NOT NULL,
    [EnquiryNo]             VARCHAR (50)     NOT NULL,
    [AgentID]               INT              NULL,
    [DestinationCity]       CHAR (10)        NOT NULL,
    [TravelDate]            DATETIME         NOT NULL,
    [Nights]                NCHAR (10)       NOT NULL,
    [Value]                 INT              NULL,
    [Description]           VARCHAR (MAX)    NOT NULL,
    [YearID]                INT              NOT NULL,
    [CompanyID]             INT              NOT NULL,
    [OperationBy]           UNIQUEIDENTIFIER NOT NULL,
    [OperationOn]           DATETIME         NOT NULL,
    [AgentName]             VARCHAR (500)    NULL,
    [StatusId]              INT              NULL,
    [Status]                VARCHAR (MAX)    NULL,
    [AgentStaffName]        VARCHAR (MAX)    NULL,
    [Remark]                VARCHAR (MAX)    NULL,
    [LastUpdated]           DATETIME         DEFAULT (getdate()) NULL,
    [BigBilling]            BIT              DEFAULT ((0)) NOT NULL,
    [RelatedSaleEmployeeID] INT              DEFAULT ((0)) NOT NULL,
    [FHE]                   UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_EnquiryDetails] PRIMARY KEY CLUSTERED ([EnquiryID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1.Pending To Action,2.Quoted,3.Converted,4.Lost – delayed reply from_____,5.Lost – inadequate profit margins,6.Lost – mismatched product,7.Lost – misquote by ____,8.Lost – non-availability of rooms,9.Lost – non-availability on contracted rate,10.Lost – rates incorrect / missing in Astra,11.Lost – to hotel directly,12.Lost – to offline competition,13.Lost – to online competition', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'EnquiryDetails', @level2type = N'COLUMN', @level2name = N'StatusId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1.Pending To Action,2.Quoted,3.Converted,4.Lost – delayed reply from_____,5.Lost – inadequate profit margins,6.Lost – mismatched product,7.Lost – misquote by ____,8.Lost – non-availability of rooms,9.Lost – non-availability on contracted rate,10.Lost – rates incorrect / missing in Astra,11.Lost – to hotel directly,12.Lost – to offline competition,13.Lost – to online competition', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'EnquiryDetails', @level2type = N'COLUMN', @level2name = N'Status';


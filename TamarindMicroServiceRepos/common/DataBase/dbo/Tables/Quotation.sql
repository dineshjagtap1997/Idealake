CREATE TABLE [dbo].[Quotation] (
    [QuotationID]                   INT              NOT NULL,
    [QuotationNo]                   VARCHAR (25)     NOT NULL,
    [QuotationDate]                 DATETIME         NOT NULL,
    [ParenQuotationID]              VARCHAR (25)     NULL,
    [CompanyID]                     INT              NOT NULL,
    [YearID]                        INT              NOT NULL,
    [CustomerName]                  VARCHAR (150)    NOT NULL,
    [PaxFrom]                       SMALLINT         NOT NULL,
    [PaxTo]                         SMALLINT         NOT NULL,
    [TravelDateType]                TINYINT          NOT NULL,
    [TravelDateFrom]                DATE             NOT NULL,
    [TravelDateTo]                  DATE             NOT NULL,
    [ItineraryHeader]               VARCHAR (200)    NULL,
    [StarRatingFrom]                INT              NOT NULL,
    [StarRatingTo]                  INT              NOT NULL,
    [Costing]                       TINYINT          NOT NULL,
    [RateType]                      TINYINT          NOT NULL,
    [CostingCurrencyCode]           VARCHAR (5)      NOT NULL,
    [CostingCurrencyRate]           NUMERIC (18, 4)  NOT NULL,
    [RateCategory]                  TINYINT          NOT NULL,
    [AgentID]                       INT              NOT NULL,
    [Description]                   VARCHAR (2500)   NULL,
    [Total]                         NUMERIC (18, 2)  NOT NULL,
    [Markup]                        NUMERIC (12, 2)  NOT NULL,
    [IsMarkupPercent]               BIT              NOT NULL,
    [GST]                           NUMERIC (18, 5)  NOT NULL,
    [OtherCosts]                    NUMERIC (18, 2)  NOT NULL,
    [GrandTotal]                    NUMERIC (18, 2)  NOT NULL,
    [Status]                        TINYINT          NOT NULL,
    [Preferences]                   VARCHAR (10)     NULL,
    [FileCode]                      VARCHAR (30)     NULL,
    [Operation]                     VARCHAR (10)     NOT NULL,
    [OperationBy]                   UNIQUEIDENTIFIER NULL,
    [OperationOn]                   DATETIME         CONSTRAINT [DF_Quotation_OperationOn] DEFAULT (getdate()) NOT NULL,
    [Origin]                        TINYINT          CONSTRAINT [DF_Quotation_Origin] DEFAULT ((1)) NOT NULL,
    [OldID]                         INT              NULL,
    [ApprovalHrs]                   INT              CONSTRAINT [DF_Quotation_ApprovalHrs] DEFAULT ((0)) NULL,
    [OnlineStatus]                  VARCHAR (50)     NULL,
    [IsLocked]                      TINYINT          NULL,
    [LockedDate]                    DATETIME         NULL,
    [AgentBranch]                   UNIQUEIDENTIFIER CONSTRAINT [DF_Quotation_AgentBranch] DEFAULT ('00000000-0000-0000-0000-000000000000') NOT NULL,
    [IsInvoiceReqd]                 BIT              CONSTRAINT [DF_Quotation_IsInvoiceReqd_1] DEFAULT ((1)) NOT NULL,
    [IsMICE]                        BIT              CONSTRAINT [DF_Quotation_IsMICE] DEFAULT ((0)) NOT NULL,
    [ApprovalDate]                  DATETIME         NULL,
    [BussinessModuleID]             INT              NULL,
    [EstimationID]                  INT              DEFAULT (NULL) NULL,
    [OnlineQuotationID]             INT              NULL,
    [OnlineQuotationNo]             VARCHAR (50)     NULL,
    [OnlineRefNo]                   VARCHAR (MAX)    NULL,
    [BookingType]                   INT              NULL,
    [RelatedEmployeeID]             INT              DEFAULT ((0)) NULL,
    [EnquiryID]                     UNIQUEIDENTIFIER NULL,
    [GST_Online]                    DECIMAL (18, 2)  NULL,
    [GSTTypeID]                     BIGINT           NULL,
    [PlaceOfSupplierId]             BIGINT           NULL,
    [CompName]                      VARCHAR (3)      NULL,
    [FCStatus]                      VARCHAR (10)     NULL,
    [FCOperationOn]                 DATETIME         NULL,
    [ServiceTypeID]                 INT              NULL,
    [ServiceLocID]                  INT              NULL,
    [Month]                         VARCHAR (10)     NULL,
    [Year]                          VARCHAR (10)     NULL,
    [YEAREndDate]                   VARCHAR (10)     NULL,
    [Market]                        VARCHAR (10)     NULL,
    [City]                          VARCHAR (10)     NULL,
    [OnlineBookingID]               NVARCHAR (30)    NULL,
    [ApproveRejectMailFlag]         BIT              NULL,
    [ApproveRejectMailFlagDateTime] DATETIME         NULL,
    [ApproveRejectReason]           VARCHAR (50)     NULL,
    [Guests_Nationality]            NVARCHAR (50)    NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1 - Exact, 2 - Tentative', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Quotation', @level2type = N'COLUMN', @level2name = N'TravelDateType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'To', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Quotation', @level2type = N'COLUMN', @level2name = N'StarRatingTo';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1 - Per Person, 2 - Consolidated', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Quotation', @level2type = N'COLUMN', @level2name = N'Costing';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1 - Net Rates, 2 - Agent Specific', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Quotation', @level2type = N'COLUMN', @level2name = N'RateType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1 - FIT, 2 - GIT, 3 - Both', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Quotation', @level2type = N'COLUMN', @level2name = N'RateCategory';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0 - Cancelled, 1 - Quote, 2 - Costing Approved, 3 - XO Generated, 4 - Invoice Generated', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Quotation', @level2type = N'COLUMN', @level2name = N'Status';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1-Monument Entrance Fee
2-MOT
3-Other charge
4-Breakfast
5-Lunch
6-Dinner', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Quotation', @level2type = N'COLUMN', @level2name = N'Preferences';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1-Offline,2-Online,3-XML,4-DOTW', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Quotation', @level2type = N'COLUMN', @level2name = N'Origin';


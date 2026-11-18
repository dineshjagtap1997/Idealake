CREATE TABLE [dbo].[OnlineAgentContactDetails] (
    [AgentContactDetailsID]   INT           IDENTITY (1, 1) NOT NULL,
    [AgentID]                 INT           NOT NULL,
    [SalutationID]            INT           NULL,
    [Name]                    VARCHAR (50)  NOT NULL,
    [DesignationOrDepartment] VARCHAR (100) NULL,
    [EmailID]                 VARCHAR (200) NOT NULL,
    [OfficeNo]                VARCHAR (30)  NULL,
    [MobileNo]                VARCHAR (30)  NULL,
    [DOB]                     DATETIME      NULL,
    [IsBookingAccess]         BIT           NOT NULL,
    [IsAdminUser]             BIT           CONSTRAINT [DF_Table_1_IsActive] DEFAULT ((0)) NOT NULL,
    [IsOperationAccount]      TINYINT       CONSTRAINT [DF_OnlineAgentContactDetails_IsOperationAccount] DEFAULT ((1)) NOT NULL,
    [IsAccStatement]          BIT           NULL,
    [IsCCtoAdmin]             BIT           NULL,
    CONSTRAINT [PK_OnlineAgentContactDetails] PRIMARY KEY CLUSTERED ([AgentContactDetailsID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1=Operation and 2=Accounts', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'OnlineAgentContactDetails', @level2type = N'COLUMN', @level2name = N'IsOperationAccount';


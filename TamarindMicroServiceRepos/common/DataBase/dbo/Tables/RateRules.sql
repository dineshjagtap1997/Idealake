CREATE TABLE [dbo].[RateRules] (
    [RuleID]           UNIQUEIDENTIFIER NOT NULL,
    [ParentRateID]     INT              NOT NULL,
    [ParentRateTypeID] TINYINT          NOT NULL,
    [HeaderRuleID]     INT              NOT NULL,
    [MISSequenceNo]    INT              NOT NULL,
    [ApplicableTo]     TINYINT          NOT NULL,
    [Description]      VARCHAR (MAX)    NULL,
    CONSTRAINT [PK_RateRules] PRIMARY KEY CLUSTERED ([RuleID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1-Hotel,2-Guide,3-Transport,4-Monument,5-SpecialRate,6-MOT', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RateRules', @level2type = N'COLUMN', @level2name = N'ParentRateTypeID';


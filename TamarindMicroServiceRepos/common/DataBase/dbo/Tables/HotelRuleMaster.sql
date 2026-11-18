CREATE TABLE [dbo].[HotelRuleMaster] (
    [HotelRuleID]   INT           IDENTITY (1, 1) NOT NULL,
    [HotelID]       INT           NOT NULL,
    [RuleID]        INT           NOT NULL,
    [MISSequenceNo] INT           NULL,
    [ApplicableTo]  TINYINT       NULL,
    [Description]   VARCHAR (500) NULL,
    CONSTRAINT [PK_HotelRuleMaster] PRIMARY KEY CLUSTERED ([HotelRuleID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0-ALL,1-B2BAgent,3-Operation', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HotelRuleMaster', @level2type = N'COLUMN', @level2name = N'ApplicableTo';


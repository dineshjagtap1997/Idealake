
CREATE TABLE [RateCards].[MOTRateCommissionDetail](
	[MotRateCommissionDetailID] [bigint] IDENTITY(1,1) NOT NULL,
	[MOTRateDetailID] [bigint] NULL,
	[CategoryID] [int] NULL,
	[Tax] [decimal](18, 2) NULL,
	[TaxAmount] [decimal](18, 2) NULL,
	[NetAmountIncludingTax] [decimal](18, 2) NULL,
	[NetAmountExcludingTax] [decimal](18, 2) NULL,
	[IsActive] [bit] NULL,
	[CreatedBy] [uniqueidentifier] NULL,
	[UpdatedBy] [uniqueidentifier] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedOn] [datetime] NULL,
	[CommissionMasterID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[MotRateCommissionDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [RateCards].[MOTRateCommissionDetail] ADD  DEFAULT ((1)) FOR [IsActive]
GO

ALTER TABLE [RateCards].[MOTRateCommissionDetail] ADD  DEFAULT (getdate()) FOR [CreatedOn]
GO



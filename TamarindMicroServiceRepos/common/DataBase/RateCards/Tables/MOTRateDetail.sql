
CREATE TABLE [RateCards].[MOTRateDetail](
	[MOTRateDetailID] [bigint] IDENTITY(1,1) NOT NULL,
	[ClassTypeID] [int] NULL,
	[ValidFrom] [datetime] NULL,
	[ValidTo] [datetime] NULL,
	[MISSequence] [varchar](100) NULL,
	[IsActive] [bit] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedOn] [datetime] NULL,
	[MOTRateID] [bigint] NULL,
	[ApplicableTo] [varchar](500) NULL,
	[Description] [varchar](500) NULL,
	[CreatedBy] [uniqueidentifier] NULL,
	[UpdatedBy] [uniqueidentifier] NULL,
PRIMARY KEY CLUSTERED 
(
	[MOTRateDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [RateCards].[MOTRateDetail] ADD  DEFAULT ((1)) FOR [IsActive]
GO

ALTER TABLE [RateCards].[MOTRateDetail] ADD  DEFAULT (getdate()) FOR [CreatedOn]
GO



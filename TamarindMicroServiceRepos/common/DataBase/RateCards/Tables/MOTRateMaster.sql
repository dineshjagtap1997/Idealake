
CREATE TABLE [RateCards].[MOTRateMaster](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[RateCardNo] [varchar](50) NOT NULL,
	[ContractDate] [datetime] NULL,
	[ValidFrom] [datetime] NULL,
	[ValidTO] [datetime] NULL,
	[FromDate] [datetime] NULL,
	[ToDate] [datetime] NULL,
	[ContractHeading] [nvarchar](200) NULL,
	[TravelModeTypeID] [int] NULL,
	[MOTNameORNumber] [nvarchar](100) NULL,
	[Sector] [nvarchar](200) NULL,
	[RateCardModeTypeID] [int] NULL,
	[InformationToOperations] [nvarchar](max) NULL,
	[XORemarks] [nvarchar](max) NULL,
	[VendorID] [int] NULL,
	[CurrencyCode] [nvarchar](10) NULL,
	[IsActive] [bit] NOT NULL,
	[CompanyID] [int] NULL,
	[YearID] [int] NULL,
	[BookingID] [int] NULL,
	[CreatedBy] uniqueidentifier NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] uniqueidentifier NULL,
	[ModifiedOn] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [RateCards].[MOTRateMaster] ADD  DEFAULT ((0)) FOR [IsActive]
GO

ALTER TABLE [RateCards].[MOTRateMaster] ADD  DEFAULT (getdate()) FOR [CreatedOn]
GO



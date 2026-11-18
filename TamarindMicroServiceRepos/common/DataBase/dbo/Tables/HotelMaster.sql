CREATE TABLE [dbo].[HotelMaster] (
    [HotelID]                 INT              IDENTITY (1, 1) NOT NULL,
    [AccCode]                 VARCHAR (50)     NOT NULL,
    [HotelCode]               VARCHAR (50)     NOT NULL,
    [HotelName]               VARCHAR (200)    NOT NULL,
    [HotelRatingID]           INT              NOT NULL,
    [ChainIATACode]           CHAR (3)         NULL,
    [ReuseAllocation]         BIT              NOT NULL,
    [CityIATACode]            CHAR (3)         NOT NULL,
    [Website]                 VARCHAR (1000)   NOT NULL,
    [ZoneID]                  INT              NULL,
    [PhoneNo]                 VARCHAR (35)     NOT NULL,
    [MobileNo]                VARCHAR (15)     NULL,
    [FaxNo]                   VARCHAR (35)     NOT NULL,
    [EmailID]                 VARCHAR (200)    NULL,
    [PanNo]                   VARCHAR (50)     NULL,
    [STRegNo]                 VARCHAR (50)     NULL,
    [ChequeFavouring]         VARCHAR (200)    NULL,
    [BankName]                VARCHAR (200)    NULL,
    [Address]                 VARCHAR (MAX)    NULL,
    [AccountNo]               VARCHAR (100)    NULL,
    [CreateAdvanceAccount]    BIT              NULL,
    [CreditApplicable]        BIT              NULL,
    [CreditPeriod]            INT              NULL,
    [CreditCurrencyCode]      VARCHAR (5)      NULL,
    [CreditAmount]            DECIMAL (18, 5)  NULL,
    [CreditApproveBy]         VARCHAR (100)    NULL,
    [InfantFromAge]           INT              NULL,
    [InfantToAge]             INT              NULL,
    [ChildFromAge]            INT              NULL,
    [ChildToAge]              INT              NULL,
    [AdultFromAge]            INT              NULL,
    [AdultToAge]              INT              NULL,
    [IsActive]                BIT              NULL,
    [Operation]               VARCHAR (10)     NOT NULL,
    [OperationBy]             UNIQUEIDENTIFIER NOT NULL,
    [OperationOn]             DATETIME         NOT NULL,
    [OldID]                   VARCHAR (100)    NULL,
    [Latitude]                VARCHAR (MAX)    NULL,
    [Longitude]               VARCHAR (MAX)    NULL,
    [CreateCommissionAccount] BIT              NOT NULL,
    [BankAccountID]           INT              NULL,
    [HotelTypeID]             INT              NULL,
    [BranchName]              VARCHAR (200)    NULL,
    [DOTW_HotelID]            VARCHAR (50)     NULL,
    [IFSCCode]                VARCHAR (50)     NULL,
    [SWIFTCode]               VARCHAR (50)     NULL,
    [Comment]                 VARCHAR (100)    NULL,
    [RoomNight]               INT              NULL,
    [HotelPreferred]          BIT              NULL,
    [BestSellUpdationDate]    DATETIME         NULL,
    [StateCodeID]             BIGINT           NULL,
    [SupplierID]              VARCHAR (5)      NULL,
    [CompanyID]               INT              NULL,
    [GSTNID]                  VARCHAR (20)     NULL,
    [LegalName]               VARCHAR (200)    NULL,
    [BTCBranchPosting]        INT              NULL,
    [isActiveMSME]            BIT              NULL,
    [MSMEType]                VARCHAR (20)     NULL,
    [MSMERegFromDt]           DATETIME         NULL,
    [MSMERegToDt]             DATETIME         NULL,
    [HotelSAPCode]            VARCHAR (10)     NULL,
    [GSTRequired]             BIT              NULL,
    [isActiveSAP]             BIT              NULL,
    [TANDetails]              VARCHAR (500)    NULL,
    [PreviousCode]            VARCHAR (500)    NULL,
    [MSME]                    VARCHAR (500)    NULL,
    [Deductee]                VARCHAR (500)    NULL,
    [WithHoldigTax]           VARCHAR (500)    NULL,
    [RoomCount]               VARCHAR (10)     NULL,
    [PostalCode]              VARCHAR (20)     NULL,
    [LegalEntity]             INT              NULL,
    [MembershipNo]            NVARCHAR (30)    NULL,
    [isSEZ]                   BIT              NULL,
    [NonGSTRegistered]        BIT              NULL,
    [PayMode]                 BIT              NULL,
    [UpdatedBy]               UNIQUEIDENTIFIER NULL,
    [UpdatedOn]               DATETIME         NULL,
    [Beneficiary_Name]        VARCHAR (MAX)    NULL,
    [Tax_Reg_Number]          NVARCHAR (MAX)   NULL,
    [EmailGeneral]            NVARCHAR (MAX)   NULL,
    [EmailFinance]            NVARCHAR (MAX)   NULL,
    [Country_IATACode]        CHAR (10)        NULL,
    [Contact1]                VARCHAR (50)     NULL,
    [Contact2]                VARCHAR (50)     NULL,
    [Contact1IsMobile]        BIT              NULL,
    [Contact2IsMobile]        BIT              NULL,
    [ChainIATACodeHG]         INT              NULL,
    [TaxType]                 VARCHAR (20)     NULL,
    [issapcompcode]           BIT              NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [IDC_Hotel]
    ON [dbo].[HotelMaster]([HotelID] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_NCHotel]
    ON [dbo].[HotelMaster]([HotelName] ASC, [HotelSAPCode] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_NCStre]
    ON [dbo].[HotelMaster]([AccCode] ASC, [STRegNo] ASC, [CityIATACode] ASC, [IsActive] ASC, [HotelRatingID] ASC, [HotelName] ASC);

<<<<<<< HEAD
<<<<<<< HEAD
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

GO
CREATE NONCLUSTERED INDEX [IX_HotelMaster_RatingType]
    ON [dbo].[HotelMaster]([HotelID] ASC, [HotelRatingID] ASC, [HotelTypeID] ASC, [CityIATACode] ASC, [ZoneID] ASC);

<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

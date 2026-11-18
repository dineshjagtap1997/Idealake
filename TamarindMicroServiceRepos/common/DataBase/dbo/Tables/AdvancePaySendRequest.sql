CREATE TABLE [dbo].[AdvancePaySendRequest] (
    [Request_ID]         NVARCHAR (20)   NULL,
    [Request_Date]       DATETIME        NULL,
    [Requested_By]       NVARCHAR (50)   NULL,
    [SAPCompCode]        NVARCHAR (10)   NULL,
    [SAPXOBizPlaceCode]  NVARCHAR (10)   NULL,
    [BizVertical]        NVARCHAR (10)   NULL,
    [FileCode]           NVARCHAR (20)   NULL,
    [GuestName]          NVARCHAR (150)  NULL,
    [AgentName]          NVARCHAR (150)  NULL,
    [AgentCredit]        NVARCHAR (50)   NULL,
    [XO_ID]              NVARCHAR (20)   NULL,
    [Check_In]           DATETIME        NULL,
    [Check_Out]          DATETIME        NULL,
    [XO_Curr]            NVARCHAR (50)   NULL,
    [XO_Amt]             DECIMAL (18, 2) NULL,
    [GST_Per]            DECIMAL (18, 2) NULL,
    [TAC_Invoice_Amt]    DECIMAL (18, 2) NULL,
    [TDS_Amt]            DECIMAL (18, 2) NULL,
    [Vendor_Bill_Amt]    DECIMAL (18, 2) NULL,
    [Amt_To_be_Released] DECIMAL (18, 2) NULL,
<<<<<<< HEAD
<<<<<<< HEAD
    [Hotel_Name]         NVARCHAR (150)  NULL,
=======
    [HotelName]          NVARCHAR (150)  NULL,
>>>>>>> dev
=======
    [HotelName]          NVARCHAR (150)  NULL,
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    [Vendor_Name]        NVARCHAR (150)  NULL,
    [PayTo]              NVARCHAR (50)   NULL,
    [Supplier_Credit]    BIT             NULL,
    [Bank_Account_Name]  NVARCHAR (150)  NULL,
    [Bank_Account_No]    NVARCHAR (20)   NULL,
    [Bank_Name]          NVARCHAR (150)  NULL,
    [IFSC]               NVARCHAR (15)   NULL,
    [SAP_Vendor_Code]    NVARCHAR (15)   NULL,
    [TAC_Invoice_No]     NVARCHAR (15)   NULL,
    [Approved_By]        NVARCHAR (50)   NULL,
    [Reason_For_Advance] NVARCHAR (200)  NULL,
    [ID]                 INT             IDENTITY (1, 1) NOT NULL,
    [ModeOfPayment]      NVARCHAR (50)   NULL,
    [TaxAmount]          DECIMAL (18, 2) NULL,
    [AgentPaymentStatus] NVARCHAR (50)   NULL,
    [Status]             NVARCHAR (20)   NULL,
    [ApprovedOn]         DATETIME        NULL,
    [Remarks]            NVARCHAR (50)   NULL,
    [Reason]             NVARCHAR (MAX)  NULL,
<<<<<<< HEAD
<<<<<<< HEAD
=======
    [EmailFrom]          NVARCHAR (200)  NULL,
    [EmailTo]            NVARCHAR (500)  NULL,
    [EmailCC]            NVARCHAR (500)  NULL,
>>>>>>> dev
=======
    [EmailFrom]          NVARCHAR (200)  NULL,
    [EmailTo]            NVARCHAR (500)  NULL,
    [EmailCC]            NVARCHAR (500)  NULL,
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


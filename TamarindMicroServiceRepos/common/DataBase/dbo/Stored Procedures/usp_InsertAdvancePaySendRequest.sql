<<<<<<< HEAD
<<<<<<< HEAD
﻿
CREATE PROCEDURE [dbo].[usp_InsertAdvancePaySendRequest] 
 --   @Request_ID NVARCHAR(20),
 --   @Requested_By NVARCHAR(50),
 --   @SAPCompCode NVARCHAR(10),
 --   @SAPXOBizPlaceCode NVARCHAR(10),
 --   @BizVertical NVARCHAR(10),
 --   @FileCode NVARCHAR(20),
 --   @GuestName NVARCHAR(150),
 --   @AgentName NVARCHAR(150),
 --   @AgentCredit NVARCHAR(50),
 --   @XO_ID NVARCHAR(20) = NULL,
 --   @XODayWiseID BIGINT,
 --   @Check_In DATETIME,
 --   @Check_Out DATETIME,
 --   @XO_Curr NVARCHAR(50),
 --   @XO_Amt DECIMAL(18, 2),
 --   @GST_Per DECIMAL(18, 2),
 --   @TAC_Invoice_Amt DECIMAL(18, 2),
 --   @TDS_Amt DECIMAL(18, 2),
 --   @Vendor_Bill_Amt DECIMAL(18, 2),
 --   @Amt_To_be_Released DECIMAL(18, 2),
 --   @Hotel_Name NVARCHAR(150),
 --   @Vendor_Name NVARCHAR(150),
 --   @PayTo NVARCHAR(50),
 --   @Supplier_Credit BIT,
 --   @Bank_Account_Name NVARCHAR(150),
 --   @Bank_Account_No NVARCHAR(20),
 --   @Bank_Name NVARCHAR(150),
 --   @IFSC NVARCHAR(15),
 --   @SAP_Vendor_Code NVARCHAR(15) OUTPUT,
 --   @TAC_Invoice_No NVARCHAR(15),
 --   @Approved_By NVARCHAR(50),
 --   @Reason_For_Advance NVARCHAR(200),
 --   @Status NVARCHAR(20), -- NEW: Approved/Rejected/Pending
 --   @Action CHAR(2) = 'I',
 --   @ModeOfPayment NVARCHAR(50) = NULL,
 --   @TaxAmount DECIMAL(18, 2) = 0,
 --   @AgentPaymentStatus NVARCHAR(50) = NULL,
	--@Remarks nvarchar(50)=null
	 @Request_ID NVARCHAR(20) = NULL,
=======
﻿CREATE PROCEDURE [dbo].[usp_InsertAdvancePaySendRequest] 
    @Request_ID NVARCHAR(20) = NULL,
>>>>>>> dev
=======
﻿CREATE PROCEDURE [dbo].[usp_InsertAdvancePaySendRequest] 
    @Request_ID NVARCHAR(20) = NULL,
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    @Requested_By NVARCHAR(50) = NULL,
    @SAPCompCode NVARCHAR(10) = NULL,
    @SAPXOBizPlaceCode NVARCHAR(10) = NULL,
    @BizVertical NVARCHAR(10) = NULL,
<<<<<<< HEAD
<<<<<<< HEAD
    @FileCode NVARCHAR(20), -- only this is mandatory for 'S'
    @GuestName NVARCHAR(150) = NULL,
    @AgentName NVARCHAR(150) = NULL,
    @AgentCredit NVARCHAR(50) = NULL,
    @XO_ID NVARCHAR(20) = NULL,
    @XODayWiseID BIGINT = NULL,
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    @FileCode NVARCHAR(20)=null, -- only this is mandatory for 'S'
    @GuestName NVARCHAR(150) = NULL,
    @AgentName NVARCHAR(150) = NULL,
    @AgentCredit NVARCHAR(50) = NULL,
    @XO_ID NVARCHAR(20) = 'TINH26000068',
    @XODayWiseID NVARCHAR(MAX) = NULL,
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    @Check_In DATETIME = NULL,
    @Check_Out DATETIME = NULL,
    @XO_Curr NVARCHAR(50) = NULL,
    @XO_Amt DECIMAL(18, 2) = NULL,
    @GST_Per DECIMAL(18, 2) = NULL,
    @TAC_Invoice_Amt DECIMAL(18, 2) = NULL,
    @TDS_Amt DECIMAL(18, 2) = NULL,
    @Vendor_Bill_Amt DECIMAL(18, 2) = NULL,
    @Amt_To_be_Released DECIMAL(18, 2) = NULL,
<<<<<<< HEAD
<<<<<<< HEAD
    @Hotel_Name NVARCHAR(150) = NULL,
=======
    @HotelName NVARCHAR(150) = NULL,
>>>>>>> dev
=======
    @HotelName NVARCHAR(150) = NULL,
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    @Vendor_Name NVARCHAR(150) = NULL,
    @PayTo NVARCHAR(50) = NULL,
    @Supplier_Credit BIT = NULL,
    @Bank_Account_Name NVARCHAR(150) = NULL,
    @Bank_Account_No NVARCHAR(20) = NULL,
    @Bank_Name NVARCHAR(150) = NULL,
    @IFSC NVARCHAR(15) = NULL,
    @SAP_Vendor_Code NVARCHAR(15) = NULL OUTPUT,
    @TAC_Invoice_No NVARCHAR(15) = NULL,
    @Approved_By NVARCHAR(50) = NULL,
    @Reason_For_Advance NVARCHAR(200) = NULL,
    @Status NVARCHAR(20) = NULL,
<<<<<<< HEAD
<<<<<<< HEAD
    @Action CHAR(2) = 'I',
    @ModeOfPayment NVARCHAR(50) = NULL,
    @TaxAmount DECIMAL(18, 2) = NULL,
    @AgentPaymentStatus NVARCHAR(50) = NULL,
    @Remarks NVARCHAR(50) = NULL
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    @Action CHAR(2) = 'S',
    @ModeOfPayment NVARCHAR(50) = NULL,
    @TaxAmount DECIMAL(18, 2) = NULL,
    @AgentPaymentStatus NVARCHAR(50) = NULL,
    @Remarks NVARCHAR(50) = NULL,
    @EmailFrom NVARCHAR(200) = NULL,
    @EmailTo NVARCHAR(500) = NULL,
    @EmailCC NVARCHAR(500) = NULL,
	@ID Bigint = 0
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @LogID INT;

    IF @Action = 'I'
    BEGIN
<<<<<<< HEAD
<<<<<<< HEAD
        IF EXISTS (
            SELECT 1
            FROM [dbo].[AdvancePaySendRequest]
            WHERE [Request_ID] = @Request_ID
        )
        BEGIN
            SELECT '409' AS returnCode,
                   'Duplicate record exists. Request_ID already present.' AS returnMessage;
            RETURN;
        END
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
        --IF EXISTS (
        --    SELECT 1
        --    FROM [dbo].[AdvancePaySendRequest]
        --    WHERE XO_ID = @XO_ID
        --)
        --BEGIN
        --    SELECT '409' AS returnCode,
        --           'Duplicate record exists. Request_ID already present.' AS returnMessage;
        --    RETURN;
        --END
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

        -- Generate SAP_Vendor_Code if not passed
        IF ISNULL(@SAP_Vendor_Code, '') = ''
        BEGIN
            DECLARE @NewVendorCode NVARCHAR(15);
            SELECT @NewVendorCode = 'VEN' + RIGHT('00000' + CAST(ISNULL(MAX(ID), 0) + 1 AS VARCHAR), 5)
            FROM [dbo].[AdvancePaySendRequest];
            SET @SAP_Vendor_Code = @NewVendorCode;
        END
<<<<<<< HEAD
<<<<<<< HEAD

        -- Insert the record
        INSERT INTO [dbo].[AdvancePaySendRequest] (
            [Request_ID],
            [Request_Date],
            [Requested_By],
            [SAPCompCode],
            [SAPXOBizPlaceCode],
            [BizVertical],
            [FileCode],
            [GuestName],
            [AgentName],
            [AgentCredit],
            [XO_ID],
            [Check_In],
            [Check_Out],
            [XO_Curr],
            [XO_Amt],
            [GST_Per],
            [TAC_Invoice_Amt],
            [TDS_Amt],
            [Vendor_Bill_Amt],
            [Amt_To_be_Released],
            [Hotel_Name],
            [Vendor_Name],
            [PayTo],
            [Supplier_Credit],
            [Bank_Account_Name],
            [Bank_Account_No],
            [Bank_Name],
            [IFSC],
            [SAP_Vendor_Code],
            [TAC_Invoice_No],
            [Approved_By],
            [Reason_For_Advance],
            [Status],               -- New field
            [ModeOfPayment],
            [TaxAmount],
            [AgentPaymentStatus],
			[Remarks]
        )
        VALUES (
            @Request_ID,
            GETDATE(),
            @Requested_By,
            @SAPCompCode,
            @SAPXOBizPlaceCode,
            @BizVertical,
            @FileCode,
            @GuestName,
            @AgentName,
            @AgentCredit,
            @XO_ID,
            @Check_In,
            @Check_Out,
            @XO_Curr,
            @XO_Amt,
            @GST_Per,
            @TAC_Invoice_Amt,
            @TDS_Amt,
            @Vendor_Bill_Amt,
            @Amt_To_be_Released,
            @Hotel_Name,
            @Vendor_Name,
            @PayTo,
            @Supplier_Credit,
            @Bank_Account_Name,
            @Bank_Account_No,
            @Bank_Name,
            @IFSC,
            @SAP_Vendor_Code,
            @TAC_Invoice_No,
            @Approved_By,
            @Reason_For_Advance,
            @Status,               -- New value
            @ModeOfPayment,
            @TaxAmount,
            @AgentPaymentStatus,
			@Remarks
        );

        -- Lock XO
        UPDATE t1
        SET t1.IsLock = 1
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
		SELECT @Request_ID= [XO].[fn_GenerateAdvancePayID](B.ID, X.CheckInDate),@SAPCompCode=CM.SAP_CompanyCode,@SAPXOBizPlaceCode= CM.SAP_BusinessPlaceCode,
		@FileCode=B.FileCode,@Check_In=X.CheckINDate,@Check_Out=X.CheckOutDate,@XO_Curr=X.Curr_ID,@XO_Amt=x.XO_Amt,@Bank_Account_Name=AM.BankAccountID,
		@Bank_Account_No=AM.Accountnumber,@Bank_Name=AM.BankName,@IFSC=AM.ifsccode,@BizVertical=B.BizVirticale,@AgentCredit=AM.CreditApplicable  
		,@AgentName=AM.AgentName,@PayTo=(case when Isnull(@Vendor_Name,'') ='' then  @HotelName else  @Vendor_Name end)--X.XO_Supplier_Name
		FROM  XO X 
		Inner JOIN Booking.tbl_Booking B ON B.ID = X.Qut_ID
		LEFT JOIN EmployeeMaster E ON B.FHE = E.UserID
		LEFT JOIN AgentMaster AM ON AM.AgentID = B.AgentID
		LEFT JOIN CompanyMaster CM ON CM.CompanyID = B.CompanyID
		LEFT JOIN Invoice.Invoice I ON I.XO_ID = I.XO_ID AND InvoiceType  = 4 
		LEFT JOIN Invoice.InvoiceDetails  ID ON I.ID = ID.Invoice_ID
		WHERE (@XO_ID IS NULL OR X.XO_ID = @XO_ID)

        -- Insert the record
        INSERT INTO [dbo].[AdvancePaySendRequest] (
            [Request_ID], [Request_Date], [Requested_By], [SAPCompCode], [SAPXOBizPlaceCode],
            [BizVertical], [FileCode], [GuestName], [AgentName], [AgentCredit], [XO_ID],
            [Check_In], [Check_Out], [XO_Curr], [XO_Amt], [GST_Per], [TAC_Invoice_Amt],
            [TDS_Amt], [Vendor_Bill_Amt], [Amt_To_be_Released], [HotelName], [Vendor_Name],
            [PayTo], [Supplier_Credit], [Bank_Account_Name], [Bank_Account_No], [Bank_Name],
            [IFSC], [SAP_Vendor_Code], [TAC_Invoice_No], [Approved_By], [Reason_For_Advance],
            [Status], [ModeOfPayment], [TaxAmount], [AgentPaymentStatus], [Remarks],
            [EmailFrom], [EmailTo], [EmailCC]
        )
        VALUES (
            @Request_ID, GETDATE(), @Requested_By, @SAPCompCode, @SAPXOBizPlaceCode,
            @BizVertical, @FileCode, @GuestName, @AgentName, @AgentCredit, @XO_ID,
            Convert(datetime,@Check_In), Convert(datetime,@Check_Out), @XO_Curr, @XO_Amt, @GST_Per, @TAC_Invoice_Amt,
            @TDS_Amt, @Vendor_Bill_Amt, @Amt_To_be_Released, @HotelName, @Vendor_Name,
            @PayTo, @Supplier_Credit, @Bank_Account_Name, @Bank_Account_No, @Bank_Name,
            @IFSC, @SAP_Vendor_Code, @TAC_Invoice_No, @Approved_By, @Reason_For_Advance,
            @Status, @ModeOfPayment, @TaxAmount, @AgentPaymentStatus, @Remarks,
            @EmailFrom, @EmailTo, @EmailCC
        );
		

        -- Lock XO
        UPDATE t1
        SET t1.IsLock = 1, t1.XOLock = 1
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
        FROM Booking.DayWiseBooking t1
        JOIN dbo.XO t2 ON t1.GroupKey = t2.GroupKey
            AND t1.BookingID = t2.Qut_ID
            AND t2.DayWiseID = @XODayWiseID;

<<<<<<< HEAD
<<<<<<< HEAD
        SET @LogID = SCOPE_IDENTITY();
		  
		 DECLARE @BookingIDS BIGINT;
		 DECLARE @BHRMID BIGINT;

		 --SELECT @BookingIDS= BookingID,  @BHRMID=BHRMID  FROM Booking.DayWiseBooking t1
   --     JOIN dbo.XO t2 ON t1.GroupKey = t2.GroupKey
   --         AND t1.BookingID = t2.Qut_ID
   --         AND t2.DayWiseID = @XODayWiseID;
			 
			-- IF(@BookingIDS IS NOT NULL AND @BHRMID IS NOT NULL OR @BHRMID <> 0) 
			-- BEGIN 
			-- END  -- Keep Commented Dont touch this
		 
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
        UPDATE BB 
        SET BB.LOCK = 1 
        FROM Booking.tbl_booking BB
        INNER JOIN Booking.DayWiseBooking BD ON BD.BookingID = BB.ID            
        WHERE ISNULL(BD.IsLock, 0) = 1 
        AND BD.ID IN (
            SELECT CAST(value AS BIGINT)
            FROM STRING_SPLIT(@XODayWiseID, ',')
        );

        SET @LogID = SCOPE_IDENTITY();
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

        SELECT '200' AS returnCode,
               'Record INSERTED successful.' AS returnMessage,
               @LogID AS ID,
<<<<<<< HEAD
<<<<<<< HEAD
               @SAP_Vendor_Code AS SAP_Vendor_Code;
			   END
			 ELSE IF @Action = 'U'
    BEGIN
        UPDATE [dbo].[AdvancePaySendRequest]
        SET
           
            [Approved_By] = @Approved_By,
            [Reason_For_Advance] = @Reason_For_Advance,
            [Status] = @Status,
            [ModeOfPayment] = @ModeOfPayment,
            [TaxAmount] = @TaxAmount,
            [AgentPaymentStatus] = @AgentPaymentStatus,
            [ApprovedOn] = getdate(),
			[Remarks] = @Remarks
        WHERE [Request_ID] = @Request_ID;

        -- You may consider setting @LogID as the record's primary key (if needed)
       SELECT '200' AS returnCode,
       'Record UPDATED successfully.' AS returnMessage,
       @Request_ID AS Request_ID,  -- ✅ Fix here
       @SAP_Vendor_Code AS SAP_Vendor_Code;

    END
	ELSE IF @Action = 'S'
BEGIN
    SELECT 
        Request_ID,
        Requested_By,
        SAPCompCode,
        SAPXOBizPlaceCode,
        BizVertical,
        FileCode,
        GuestName,
        AgentName,
        AgentCredit,
        XO_ID,
        Check_In,
        Check_Out,
        XO_Curr,
        XO_Amt,
        GST_Per,
        TAC_Invoice_Amt,
        TDS_Amt,
        Vendor_Bill_Amt,
        Amt_To_be_Released,
        Hotel_Name,
        Vendor_Name,
        PayTo,
        Supplier_Credit,
        Bank_Account_Name,
        Bank_Account_No,
        Bank_Name,
        IFSC,
        SAP_Vendor_Code,
        TAC_Invoice_No,
        Approved_By,
        Reason_For_Advance,
        Status,
        ModeOfPayment,
        TaxAmount,
        AgentPaymentStatus,
        Remarks,
        ApprovedOn
    FROM [dbo].[AdvancePaySendRequest]
    WHERE FileCode = @FileCode;

    
END
 SELECT '200' AS returnCode, 'Data Found' AS returnMessage

END

=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
               @SAP_Vendor_Code AS SAP_Vendor_Code,
			   @Request_ID as XONumber,
               GETDATE() as LastSavedOn;
    END
    ELSE IF @Action = 'U'
    BEGIN
        UPDATE [dbo].[AdvancePaySendRequest]
        SET [EmailTo] = @EmailTo,
            [EmailFrom] = ISNULL(@EmailFrom, 'developer@tamarindglobal.com'),
            [EmailCC] = @EmailCC, Remarks=@Remarks, AgentPaymentStatus= @Status
        WHERE ID = @ID;
		SELECT DISTINCT TOP 1 APSR.Request_ID,
			APSR.Request_Date,
			FORMAT(APSR.Request_Date, 'dd/MM/yyyy HH:mm:ss')  as Request_Date_Formatted,
			EReq.EmpName as Requested_By,
			E.EmpName AS FileHandler,
			CM.SAP_CompanyCode AS SAPCompCode,
			APSR.SAPXOBizPlaceCode,
			APSR.BizVertical,
			APSR.FileCode,
			B.GuestName AS GuestName,
			AM.AgentName AS AgentName,
			AM.CreditApplicable AS AgentCreditStatus,
			APSR.XO_ID,
			APSR.Check_In,
			FORMAT(APSR.Check_In, 'dd/MM/yyyy HH:mm:ss')  as Check_In_Formatted ,
			FORMAT(APSR.Check_Out, 'dd/MM/yyyy HH:mm:ss')  as Check_Out_Formatted,
			@EmailTo as EmailFrom,
			ISNULL(@EmailFrom, 'developer@tamarindglobal.com') as EmailTo,
			@EmailCC as EmailCC,
			APSR.Check_Out,
			APSR.XO_Curr,
			APSR.XO_Amt,
			Convert(varchar(500),APSR.GST_Per) AS GSTPer,
			APSR.TAC_Invoice_Amt,
			APSR.TDS_Amt,
			APSR.Vendor_Bill_Amt,
			APSR.Amt_To_be_Released,
			DWB.HotelName,
			APSR.Vendor_Name,
			APSR.PayTo,
			APSR.Supplier_Credit,
			APSR.Bank_Name AS Bank_Account_Name,
			APSR.Bank_Account_No AS Bank_Account_No,
			APSR.Bank_Name AS Bank_Name,
			APSR.IFSC AS IFSC,
			APSR.SAP_Vendor_Code,
			APSR.TAC_Invoice_No AS TAC_Invoice_No,
			APSR.TAC_Invoice_Amt AS TAC_Invoice_Amt, 
			APSR.Approved_By,
			APSR.Reason_For_Advance,
			APSR.TaxAmount AS GST_Amt,
			APSR.ModeOfPayment,
			APSR.EmailFrom,
			APSR.EmailTo,
			APSR.EmailCC
		FROM [dbo].[AdvancePaySendRequest] APSR  
		LEFT JOIN XO X ON X.XO_ID = APSR.XO_ID
		Left JOIN Booking.DayWiseBooking DWB on DWB.BookingID=X.Qut_ID and DWB.GroupKey=X.GroupKey
		LEFT JOIN Booking.tbl_Booking B ON B.ID = X.Qut_ID
		LEFT JOIN EmployeeMaster E ON B.FHE = E.UserID
		LEFT JOIN EmployeeMaster EReq ON B.CreatedBy = EReq.UserID

		LEFT JOIN AgentMaster AM ON  AM.AgentID = B.AgentID
		LEFT JOIN CompanyMaster CM ON CM.SAP_CompanyCode = APSR.SAPCompCode
		LEFT JOIN Invoice.Invoice I ON I.XO_ID = I.XO_ID AND InvoiceType  = 4 
	--	LEFT JOIN Invoice.InvoiceDetails  ID ON I.ID = ID.Invoice_ID  
		WHERE APSR.ID=@ID;
    END

    -- CRITICAL: This SELECT query must be executed for email data
    Else IF @Action IN ('S')
    BEGIN
			SELECT DISTINCT  APSR.Request_ID,
			APSR.Request_Date,
			FORMAT(APSR.Request_Date, 'dd/MM/yyyy HH:mm:ss')  as Request_Date_Formatted,

			EReq.EmpName as Requested_By,
			E.EmpName AS FileHandler,
			CM.SAP_CompanyCode AS SAPCompCode,
			CM.SAP_BusinessPlaceCode AS SAPXOBizPlaceCode,
			APSR.BizVertical,
			APSR.FileCode,
			B.GuestName AS GuestName,
			AM.AgentName AS AgentName,
			AM.CreditApplicable AS AgentCreditStatus,
			APSR.XO_ID,
			APSR.Check_In,
			FORMAT(APSR.Check_In, 'dd/MM/yyyy HH:mm:ss')  as Check_In_Formatted ,
			FORMAT(APSR.Check_Out, 'dd/MM/yyyy HH:mm:ss')  as Check_Out_Formatted,
			APSR.Check_Out,
			APSR.XO_Curr,
			APSR.XO_Amt,
			Convert(varchar(500),APSR.GST_Per) AS GSTPer,
			ID.TotalInvoiceAmount AS  TAC_Invoice_Amt,
			APSR.TDS_Amt,
			APSR.Vendor_Bill_Amt,
			APSR.Amt_To_be_Released,
			APSR.HotelName,
			APSR.Vendor_Name,
			APSR.PayTo,
			APSR.Supplier_Credit,
			--APSR.Bank_Name AS Bank_Account_Name,
			--APSR.Bank_Account_No AS Bank_Account_No,
			--APSR.Bank_Name AS Bank_Name,
			--APSR.IFSC AS IFSC,
			 case when (VM.VendorName IS NULL OR VM.VendorName = '') then HM.ChequeFavouring else VM.ChequeFavouring end                        
			 as ChequeFavouring                        
			 ,case when (VM.VendorName IS NULL OR VM.VendorName = '') then HM.AccountNo else VM.AccountNo end as AccountNo      
			  ,case when (VM.VendorName IS NULL OR VM.VendorName = '') then HM.ChequeFavouring else VM.ChequeFavouring end  as Bank_Account_Name                        
			 ,case when (VM.VendorName IS NULL OR VM.VendorName = '') then HM.BankName else VM.BankName end as BankName                        
			 ,case when (VM.VendorName IS NULL OR VM.VendorName = '') then HM.IFSCCode else VM.IFSCCode end as IFSCCode        
			,VM.VendorSAPCode AS 'SAP_Vendor_Code',
			((2 * ID.TotalInvoiceAmount )/ 100 ) as 'TDS' ,X.XO_Amt as 'VoucherAmt',  
			(X.XO_Amt * APSR.GST_Per) / 100  as 'VendorBillAmt', 
			I.InvoiceNumber AS TAC_Invoice_No,
			ID.TotalInvoiceAmount AS TAC_Invoice_Amt, 
			APSR.Approved_By,
			APSR.Reason_For_Advance,
			APSR.TaxAmount AS GST_Amt,
			APSR.ModeOfPayment,
			APSR.EmailFrom,
			APSR.EmailTo,
			APSR.EmailCC
		FROM [dbo].[AdvancePaySendRequest] APSR  
		LEFT JOIN XO X ON X.XO_ID = APSR.XO_ID
		left join Booking.DayWiseBooking DB ON DB.GroupKey = X.GroupKey AND DB.BookingID = X.Qut_ID
		LEFT JOIN Booking.tbl_Booking B ON DB.BookingID = B.ID
		LEFT JOIN EmployeeMaster E ON B.FHE = E.UserID
		LEFT JOIN EmployeeMaster EReq ON B.CreatedBy = EReq.UserID

		LEFT JOIN AgentMaster AM ON  AM.AgentID = B.AgentID
		LEFT JOIN CompanyMaster CM ON CM.SAP_CompanyCode = APSR.SAPCompCode
		LEFT JOIN Invoice.Invoice I ON I.XO_ID = I.XO_ID AND InvoiceType  = 4 
		LEFT JOIN Invoice.InvoiceDetails  ID ON I.ID = ID.Invoice_ID  
		LEFT JOIN VendorMaster VM ON VM.VendorID = DB.Vendor 
		 left join HotelMaster HM on DB.Vendor = HM.HotelID    
		WHERE (@XO_ID IS NULL OR X.XO_ID = @XO_ID)
    END
END
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6


create PROCEDURE [dbo].[usp_InsertAdvancePaySendRequest_bkp1] @Request_ID NVARCHAR(20)
	,
	--@Request_Date DATETIME ,
	@Requested_By NVARCHAR(50)
	,@SAPCompCode NVARCHAR(10)
	,@SAPXOBizPlaceCode NVARCHAR(10)
	,@BizVertical NVARCHAR(10)
	,@FileCode NVARCHAR(20)
	,@GuestName NVARCHAR(150)
	,@AgentName NVARCHAR(150)
	,@AgentCredit NVARCHAR(50)
	,@XO_ID NVARCHAR(20)=nULL
	,@XODayWiseID BIGINT 
	,@Check_In DATETIME
	,@Check_Out DATETIME
	,@XO_Curr NVARCHAR(50)
	,@XO_Amt DECIMAL(18, 2)
	,@GST_Per DECIMAL(18, 2)
	,@TAC_Invoice_Amt DECIMAL(18, 2)
	,@TDS_Amt DECIMAL(18, 2)
	,@Vendor_Bill_Amt DECIMAL(18, 2)
	,@Amt_To_be_Released DECIMAL(18, 2)
	,@Hotel_Name NVARCHAR(150)
	,@Vendor_Name NVARCHAR(150)
	,@PayTo NVARCHAR(50)
	,@Supplier_Credit BIT
	,@Bank_Account_Name NVARCHAR(150)
	,@Bank_Account_No NVARCHAR(20)
	,@Bank_Name NVARCHAR(150)
	,@IFSC NVARCHAR(15)
	,@SAP_Vendor_Code NVARCHAR(15) OUTPUT
	,@TAC_Invoice_No NVARCHAR(15)
	,@Approved_By NVARCHAR(50)
	,@Reason_For_Advance NVARCHAR(200)
	,@Action CHAR(2) = 'I'
	,@ModeOfPayment NVARCHAR(50) = NULL
	,@TaxAmount DECIMAL(18, 2) = 0
	,@AgentPaymentStatus NVARCHAR(50) = NULL
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @LogID INT;

	IF @Action = 'I'
	BEGIN
		IF EXISTS (
				SELECT 1
				FROM [dbo].[AdvancePaySendRequest]
				WHERE [Request_ID] = @Request_ID
				)
		BEGIN
			SELECT '409' AS returnCode
				,'Duplicate record exists. Request_ID already present.' AS returnMessage;

			RETURN;
		END

		-- Generate SAP_Vendor_Code if not passed
		IF ISNULL(@SAP_Vendor_Code, '') = ''
		BEGIN
			DECLARE @NewVendorCode NVARCHAR(15);

			SELECT @NewVendorCode = 'VEN' + RIGHT('00000' + CAST(ISNULL(MAX(ID), 0) + 1 AS VARCHAR), 5)
			FROM [dbo].[AdvancePaySendRequest];

			SET @SAP_Vendor_Code = @NewVendorCode;
		END

		INSERT INTO [dbo].[AdvancePaySendRequest] (
			[Request_ID]
			,[Request_Date]
			,[Requested_By]
			,[SAPCompCode]
			,[SAPXOBizPlaceCode]
			,[BizVertical]
			,[FileCode]
			,[GuestName]
			,[AgentName]
			,[AgentCredit]
			,[XO_ID]
			,[Check_In]
			,[Check_Out]
			,[XO_Curr]
			,[XO_Amt]
			,[GST_Per]
			,[TAC_Invoice_Amt]
			,[TDS_Amt]
			,[Vendor_Bill_Amt]
			,[Amt_To_be_Released]
			,[Hotel_Name]
			,[Vendor_Name]
			,[PayTo]
			,[Supplier_Credit]
			,[Bank_Account_Name]
			,[Bank_Account_No]
			,[Bank_Name]
			,[IFSC]
			,[SAP_Vendor_Code]
			,[TAC_Invoice_No]
			,[Approved_By]
			,[Reason_For_Advance]
			,[ModeOfPayment]
			,[TaxAmount]
			,[AgentPaymentStatus]
			)
		VALUES (
			@Request_ID
			,GETDATE()
			,@Requested_By
			,@SAPCompCode
			,@SAPXOBizPlaceCode
			,@BizVertical
			,@FileCode
			,@GuestName
			,@AgentName
			,@AgentCredit
			,@XO_ID
			,@Check_In
			,@Check_Out
			,@XO_Curr
			,@XO_Amt
			,@GST_Per
			,@TAC_Invoice_Amt
			,@TDS_Amt
			,@Vendor_Bill_Amt
			,@Amt_To_be_Released
			,@Hotel_Name
			,@Vendor_Name
			,@PayTo
			,@Supplier_Credit
			,@Bank_Account_Name
			,@Bank_Account_No
			,@Bank_Name
			,@IFSC
			,@SAP_Vendor_Code
			,@TAC_Invoice_No
			,@Approved_By
			,@Reason_For_Advance
			,@ModeOfPayment
			,@TaxAmount
			,@AgentPaymentStatus
			);

		UPDATE t1
		SET t1.IsLock = 1
		FROM Booking.DayWiseBooking t1
		JOIN dbo.XO t2 ON t1.GroupKey = t2.GroupKey
			AND t1.BookingID = t2.Qut_ID
			AND t2.DayWiseID = @XODayWiseID

		SET @LogID = SCOPE_IDENTITY();

		SELECT '200' AS returnCode
			,'Record INSERTED successful.' AS returnMessage
			,@LogID AS ID
			,@SAP_Vendor_Code AS SAP_Vendor_Code;
	END
END
ALTER PROCEDURE [dbo].[USP_InsertXO] (
	@XO_Amt NUMERIC(18, 2) = 0
	,@YearCode INT = 4
	,@Accode NVARCHAR(100) = 0
	,@PaymentAmt NUMERIC(18, 2) = 0
	,@AmtInINR NUMERIC(18, 2) = 0
	,@BillReceived NUMERIC(18, 2) = 0
	,@CompanyCode VARCHAR(50) = 9
	,@OperationBy VARCHAR(100) = '656c85e1-81a1-4e78-903b-c0f4110efa99'
	,@UpdatedBy VARCHAR(100) = '656c85e1-81a1-4e78-903b-c0f4110efa99'
	,@DayWiseID NVARCHAR(100) = NULL
	,@BookingID BIGINT = 51
	,@GroupKey INT = 60
	,@Action NVARCHAR(10) = 'I'
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @XO_ID NVARCHAR(100)
		,@XONumber NVARCHAR(100)
		,@ServiceType VARCHAR(1)
		,@FiscalYear VARCHAR(2)
		,@SequenceNumber INT
		,@CompanyPrefix VARCHAR(3) = 'TIN'
		,@XONO NVARCHAR(100)
		,@DayWise NVARCHAR(500)
		,@BaseCurrencyCode VARCHAR(10) = ''
		,@Location VARCHAR(10)
		,@BookingCurrencyCode VARCHAR(10) = ''
		,@VendorCode VARCHAR(10),@IsDirectPayment BIT=0
		,@XO_CustomerName Varchar(max),
		@CheckIn DateTime, @CheckOut Datetime,@BHRMID BIGINT= 0,@HotelCode Varchar(10),
		@HotelVendorFlag varchar(2),@SapCode varchar(100),@Supplier varchar(max),@XOPost VARCHAR(10) = 'BOM'
		,@FileCode varchar(100);

	-- Default GroupKey if NULL or 0 and BookingID not zero
	IF (
			(
				@GroupKey IS NULL
				OR @GroupKey = 0
				)
			AND @BookingID != 0
			)
	BEGIN
		SELECT '201' AS returnCode
			,CONCAT (
				''
				,' Booking not found'
				) AS returnMessage
			,'' AS XONumber;

		RETURN;
	END

	select  @CheckIn = MIN(DWB.DayWiseDate),
	        @CheckOut = CASE MAX(DWB.RateTypeID) WHEN 5 
					THEN DATEADD(DAY, 1,MAX(DWB.DayWiseDate))
				ELSE MAX(DWB.DayWiseDate)
			END
		,@BHRMID = CASE MIN(DWB.RateTypeID) WHEN 5 THEN (MIN(DWB.BHRMID)) ELSE 0 END
	FROM Booking.tbl_Booking B
	INNER JOIN Booking.DayWiseBooking DWB ON B.ID = DWB.BookingID
	WHERE B.ID = @BookingID AND DWB.GroupKey = @GroupKey

	-- Get Service Type from DayWiseBooking
	-- Get Fiscal Year suffix from YearMaster
	SELECT TOP 1 @ServiceType = CASE DWB.RateTypeID
			WHEN 1
				THEN 'G'
			WHEN 2
				THEN 'M'
			WHEN 3
				THEN 'T'
			WHEN 4
				THEN 'S'
			WHEN 5
				THEN 'H'
			WHEN 7
				THEN 'A'
			ELSE 'N'
			END
		,@FiscalYear = Y.YearCode
		,@Location = ISNULL(B.CityIATACode, 'BOM')
		,@BaseCurrencyCode = ISNULL(C.CurrencyCode, 'INR')
		,@BookingCurrencyCode = ISNULL(DWB.Currency, 'INR')
		,@VendorCode = ISNULL(VM.VendorSAPCode, '')
		,@XO_CustomerName =ISNULL(B.GuestName,'')
		,@HotelCode = ISNULL(HM.HotelSAPCode, '')
		,@HotelVendorFlag = CASE 
					WHEN DWB.RateTypeID = 5 THEN CASE WHEN DWB.HotelName IS NOT NULL THEN 'H' ELSE 'V' END
					ELSE 'V' END
		,@SapCode=CASE WHEN DWB.RateTypeID = 5 THEN 
						CASE WHEN DWB.HotelName IS NOT NULL THEN HM.HotelSAPCode ELSE VM.VendorSAPCode END
					ELSE VM.VendorSAPCode END
		,@Supplier = CASE 
                WHEN DWB.RateTypeID = 5 THEN ISNULL(DWB.HotelName,VM.VendorName)
                ELSE VM.VendorName
				END,
		@XOPost =  Case when ISNULL(B.SupplierTax_InCluding, 0) = 1 THEN ISNULL(CM.CityIATACode, 'BOM')
		ELSE 
			CASE when CM.StateCodeID IS NOT NULL and HM.StateCodeID IS NOT NULL and CM.StateCodeID = HM.StateCodeID THEN CAST(HM.StateCodeID AS VARCHAR)
			ELSE ISNULL(CM.CityIATACode, 'BOM') END
		END,
		@CompanyCode = CM.CompanyID,@FileCode = B.FileCode
	FROM Booking.tbl_Booking B
	INNER JOIN Booking.DayWiseBooking DWB ON B.ID = DWB.BookingID
	LEFT JOIN YearMaster Y ON Y.YearID = B.YearID
	LEFT JOIN CompanyMaster CM ON CM.CompanyID = b.CompanyID
	LEFT JOIN Dbo.CurrencyMaster C ON CM.CurrencyComp_id = C.id
	LEFT JOIN DBO.VendorMaster VM ON VM.VendorID = DWB.Vendor
	LEFT JOIN Booking.HotelRateCardMasterBooking  HRCMB ON HRCMB.ID = DWB.BHRMID 
    LEFT JOIN dbo.HotelMaster HM On HM.HotelID = HRCMB.HotelID
	WHERE B.ID = @BookingID AND DWB.GroupKey = @GroupKey

	IF(@ServiceType = 'H')
	BEGIN
		SELECT TOP 1 @IsDirectPayment =
                    (CASE WHEN HRM.PaymentTypeID = 2 THEN 0 ELSE 1 END)
                FROM RateCards.HotelRateMaster HRM
                LEFT JOIN Booking.HotelRateCardMasterBooking HRMB 
                    ON HRM.HotelRateID = HRMB.HotelRateID
                WHERE HRMB.ID IN (@BHRMID)
	END
	-- Get new sequence number
	SELECT @SequenceNumber = ISNULL(MAX(CAST(RIGHT(XONumber, 6) AS INT)), 0) + 1
	FROM DBO.XO
	WHERE LEFT(XONumber, 3) = @CompanyPrefix
		AND SUBSTRING(XONumber, 4, 1) = @ServiceType
		AND SUBSTRING(XONumber, 5, 2) = @FiscalYear;

	DECLARE @PurchaseRate DECIMAL(18, 6)
		,@CurrencyRowID INT;

	SELECT @XO_Amt = isnull([XO].[fn_Get_XO_Amount](@BookingID, @GroupKey), 0);

	IF (@BaseCurrencyCode != @BookingCurrencyCode)
	BEGIN
		--SELECT 
		--@PurchaseRate = PurchaseRate,
		--@CurrencyRowID = ID,
		--@XO_Amt= isnull([XO].[fn_Get_XO_Amount](@BookingID, @GroupKey),0)*PurchaseRate
		--FROM dbo.fnGetCurrencyConversionRate(@BookingCurrencyCode, @BaseCurrencyCode);
		SELECT @PurchaseRate = PurchaseRate,@AmtInINR = isnull(@XO_Amt, 0) * PurchaseRate
		FROM dbo.fnGetCurrencyConversionRate(@BookingCurrencyCode, 'INR');
	END
	ELSE
	BEGIN
		SET @AmtInINR = @XO_Amt;
	END

	-- Format sequence to 6 digits
	DECLARE @SequenceStr VARCHAR(6) = RIGHT('000000' + CAST(@SequenceNumber AS VARCHAR(6)), 6);

	-- Construct XO ID and Number
	SET @XO_ID = @CompanyPrefix + @ServiceType + @FiscalYear + @SequenceStr;
	SET @XONumber = @XO_ID;
	-- Initialize variables
	SET @XONO = NULL;
	SET @DayWise = NULL;

	-- Assign Undo and XONumber from xo table if exists
	SELECT TOP 1 @XONO = Undo
		,@DayWise = XONumber
	FROM xo
	WHERE Qut_ID = @BookingID and GroupKey=@GroupKey;


	-- Check condition for updating existing XO
	IF (
			@XONO = '1'
			AND @Action = 'K'
			)
	BEGIN
		PRINT 'XONO: ' + ISNULL(@XONO, 'NULL');
		PRINT 'DayWise: ' + ISNULL(@DayWise, 'NULL');

		UPDATE XO
		SET XONumber = @XONumber,XO_ID=@XONumber,Undo=0,UpdatedDate = GETDATE(),
                UpdatedBy = @OperationBy
		WHERE Qut_ID = @BookingID and GroupKey=@GroupKey;

		-- Unlock the DayWiseBooking record
			UPDATE Booking.DayWiseBooking
			SET XOLock = 0
				,IsXOGen = 1
			WHERE BookingID = @BookingID
				AND GroupKey = @GroupKey;
	END
	ELSE
	BEGIN
		IF @Action = 'K'
		BEGIN
		select * from dbo.XO
			INSERT INTO XO (
			Undo,
				XONumber
				,XO_ID
				,XO_Amt
				,Hotel_Qut_ID
				,Trans_Qut_ID
				,YearCode
				,Accode
				,PaymentAmt
				,AmtInINR
				,Curr_ID
				,BillReceived
				,XoType
				,InsertedBy
				,InsertedDate
				,UpdatedBy
				,DayWiseID
				,Qut_ID
				,XO_Supplier_Name
				,GroupKey
				,CheckINDate
				,CheckOutDate
				,File_ID
				,XO_Date
				,Xo_Exchg_Rate
				,VendorCode,HotelCode,HotelVendorFlag,SAPCode
				,IsDirectPayment
				,XO_Customer_Name,PlaceOfSupply,CompanyCode,FileCode
				)
			SELECT DISTINCT 0,@XONumber
				,@XONumber
				,@XO_Amt
				,0
				,0
				,@YearCode
				,@Accode
				,@XO_Amt
				,@AmtInINR
				,@BookingCurrencyCode
				,@BillReceived
				,@ServiceType
				,@OperationBy
				,GETDATE()
				,@UpdatedBy
				,@DayWiseID
				,@BookingID
				,@Supplier,
				--DWB.HotelName,
				@GroupKey,
				@CheckIn,
				@CheckOut,
				@BookingID
				,GETDATE()
				,@PurchaseRate
				,@VendorCode,@HotelCode, @HotelVendorFlag,@SapCode
				,@IsDirectPayment
				,@XO_CustomerName,@XOPost,@CompanyCode,@FileCode;

			-- Unlock the DayWiseBooking record
			UPDATE Booking.DayWiseBooking
			SET XOLock = 0
				,IsXOGen = 1
			WHERE BookingID = @BookingID
				AND GroupKey = @GroupKey;
		END

		SELECT TOP 1 *
		FROM DBO.xo;

		-- Return success message
		SELECT '200' AS returnCode
			,GETDATE() AS LastSavedOn
			,CONCAT (
				@XO_ID
				,' created successfully.'
				) AS returnMessage
			,@XO_ID AS XONumber
			,GETDATE() AS LastSavedOn;
	END
END

create PROCEDURE [dbo].[USP_InsertXO_bkp]
(
    @XO_ID nvarchar(100),
    @File_ID nvarchar(100),
    @Book_ID VARCHAR(25),
    @XO_Customer_Name varchar(200),
    @XO_Date datetime,
    @XO_Supplier_Name varchar(50),
    @XO_Amt numeric(18,2),
    @Hotel_Qut_ID numeric(18,2),
    @Trans_Qut_ID numeric(18,2),
    @Rail_Air_Qut_ID numeric(18,2),
    @Entrences_Qut_ID numeric(18,2),
    @Special_Serv_Qut_ID numeric(18,2),
    @Guide_Qut_ID numeric(18,2),
    @YearCode int,
    @Accode nvarchar(100),
    @PaymentAmt numeric(18,2),
    @BalAmt numeric(18,2),
    @AmtInINR numeric(18,2),
    @Curr_ID varchar(50),
    @Xo_Exchg_Rate varchar(50),
    @BillReceived numeric(18,2),
    @XoType char(1),
    @Undo bit,
    @UndoDate datetime = NULL,
    @ROEUpdatedOn datetime = NULL,
    @IsCancellationXo BIT,
    @IsDirectPayment BIT = 0,
    @HotelCode varchar(20) = NULL,
    @VendorCode varchar(20) = NULL,
    @HotelVendorFlag varchar(5) = NULL,
    @IsBTCComm BIT = 0,
    @DepartureDate datetime = NULL,
    @InsertedDate datetime = NULL,
    @OperationBy varchar(100) = NULL,
    @UpdatedDate datetime = NULL,
    @UpdatedBy varchar(100) = NULL,
    @Action NVARCHAR(10),
    @IsPayment BIT = 0,
	@BookingID BIGINT,
	@GroupKey int,
	@DayWiseID varchar(max)
--	@ID INT OUTPUT
)
AS
BEGIN
    DECLARE 
        @CompanyCode VARCHAR(50),
        @VendorHotelSAPCode VARCHAR(10),
        @FileID INT;
		  DECLARE @LogID INT;

    -- Convert File_ID to INT safely
    SET @FileID = TRY_CAST(@File_ID AS INT);

    -- Always check if cast worked
    IF @FileID IS NULL
    BEGIN
        RAISERROR('Invalid File_ID: cannot convert to INT.', 16, 1);
        RETURN;
    END

    -- Insert logic
    IF @Action = 'I'
    BEGIN
        INSERT INTO XO (
            XO_ID, File_ID, Qut_ID, XO_Customer_Name, XO_Date, XO_Supplier_Name, XO_Amt,
            Hotel_Qut_ID, Trans_Qut_ID, Rail_Air_Qut_ID, Entrences_Qut_ID, Special_Serv_Qut_ID, Guide_Qut_ID,
            YearCode, Accode, PaymentAmt, BalAmt, AmtInINR, Curr_ID, Xo_Exchg_Rate, BillReceived, XoType,
            Undo, UndoDate, ROEUpdatedOn, IsCancellationXo, IsDirectPayment, HotelCode, VendorCode,
            HotelVendorFlag, IsBTCComm, DepartureDate, CompName, SAPCode, InsertedDate, InsertedBy, UpdatedDate, UpdatedBy, IsPayment, DayWiseID
        )
		select @XO_ID,B.FileCode,B.ID, B.PaxName,GETDATE(),DWB.HotelName,@XO_Amt,
		@Hotel_Qut_ID, @Trans_Qut_ID, @Rail_Air_Qut_ID, @Entrences_Qut_ID, @Special_Serv_Qut_ID, @Guide_Qut_ID,
		@YearCode, @Accode,@PaymentAmt, @XO_Amt,@AmtInINR, DWB.Currency, @Xo_Exchg_Rate, @BillReceived,
		CASE DWB.RateTypeID
			WHEN 1 THEN 'G'
			WHEN 2 THEN 'M'
			WHEN 3 THEN 'T'
			WHEN 4 THEN 'S'
			WHEN 5 THEN 'H'
			WHEN 7 THEN 'A'
			ELSE 'Unknown'
		END AS XOType,
		0,getdate(), getdate(), 0, 0 , 0,0,
		0, 0, 0, @CompanyCode, 0, 
		ISNULL(@InsertedDate, GETDATE()), @OperationBy, ISNULL(@UpdatedDate, GETDATE()), @UpdatedBy,0,@DayWiseID
		from Booking.tbl_Booking B inner join Booking.DayWiseBooking DWB on B.ID=DWB.BookingID
		WHERE B.ID = @BookingID AND DWB.GroupKey=@GroupKey;
		
		SET @LogID = SCOPE_IDENTITY();
		--SET @ID = @LogID;
		SELECT '200' AS returnCode, CONCAT(@XO_ID, ' created successfully.') AS returnMessage,@LogID AS ID;
    END
END




CREATE PROCEDURE [Booking].[usp_AddSubBooking]
@BID bigint = 10353,
@NewCreatedBy uniqueidentifier = 'FEECEB69-C92C-41A9-98DE-FA86FCC009E9'
AS                
BEGIN                
 DECLARE @ReturnCode NVARCHAR(3),
	@ReturnMessage NVARCHAR(MAX),             
	@logStatus BIT,
	@NewBookingID bigint,
	@NewID bigint,
    @ID bigint,
    @QuotationID bigint,
    @StartDate datetime,
    @EndDate datetime,
    @City varchar(255),
    @Service int,
    @Vehical int,
    @Vendor int,
    @Currency varchar(10),
    @Count int,
    @Adult int,
    @Child int,
    @Consolidated bigint,
    @Nationality int,
    @Cost int,
    @Type varchar(500),
    @Lock bit,
    @FileCode varchar(255),
    @GuestName varchar(255),
    @XONumber varchar(255),
    @BookingID varchar(255),
    @Status int,
    @FHE uniqueidentifier,
    @PaxName varchar(200),
    @MobileNO varchar(30),
    @PaxEmailID varchar(200),
    @Numberofpax int,
    @BizVirticale varchar(500),
    @DepartmentID varchar(max),
    @BookingCreationDate datetime,
    @PrePone tinyint,
    @PrePoneDate datetime,
    @AgentInvoiceReq tinyint,
    @Reason varchar(max),
    @PacageCode varchar(50),
    @PrmSrvcLoc varchar(500),
    @Origin varchar(50),
    @OnlineBookingID varchar(500),
    @FIT tinyint,
    @SupplierTax_B2b tinyint,
    @SupplierTax_InCluding tinyint,
    @MarkupType_Gross tinyint,
    @AgentID int,
    @MarketID int,
    @CityIATACode char(3),
    @BillingAddress varchar(max),
    @PANNo varchar(20),
    @GSTNo varchar(20),
    @TANNo varchar(20),
    @SEZ varchar(20),
    @FreeZone tinyint,
    @AgentOnCredit tinyint,
    @CreditAmount decimal(18, 2),
    @OutStandingAmount decimal(18, 2),
    @DBL int,
    @EBA int,
    @EBC int,
    @CNB int,
    @SGL int,
    @taxID int,
    @UserNote1 varchar(max),
    @UserNote2 varchar(max),
    @CreatedBy uniqueidentifier,
    @ModifiedBy uniqueidentifier,
    @TamSalesrep INT,
    @EnquiryID bigint,
	@IsSubBooking bit =1,
	@CompanyId int,
	@YearID int;

DECLARE clone_cursor CURSOR FOR
SELECT 
    ID, QuotationID, StartDate, EndDate, null as City, Service, Vehical, Vendor, Currency, [Count],
    Adult, Child, Consolidated, Nationality, Cost, Type, [Lock], FileCode, GuestName, XONumber,
    BookingID, Status, FHE, PaxName, MobileNO, PaxEmailID, Numberofpax, BizVirticale, DepartmentID,
    BookingCreationDate, PrePone, PrePoneDate, AgentInvoiceReq, Reason, PacageCode, PrmSrvcLoc,
    Origin, OnlineBookingID, FIT, SupplierTax_B2b, SupplierTax_InCluding, MarkupType_Gross,
    AgentID, MarketID, CityIATACode, BillingAddress, PANNo, GSTNo, TANNo, SEZ, FreeZone,
    AgentOnCredit, CreditAmount, OutStandingAmount, DBL, EBA, EBC, CNB, SGL, taxID,
    UserNote1, UserNote2, CreatedBy, ModifiedBy, TamSalesrep, EnquiryID,CompanyID,YearID
FROM Booking.tbl_Booking 
WHERE ID = @BID
OPEN clone_cursor  
FETCH NEXT FROM clone_cursor INTO 
    @ID, @QuotationID, @StartDate, @EndDate, @City, @Service, @Vehical, @Vendor, @Currency, @Count,
    @Adult, @Child, @Consolidated, @Nationality, @Cost, @Type, @Lock, @FileCode, @GuestName, @XONumber,
    @BookingID, @Status, @FHE, @PaxName, @MobileNO, @PaxEmailID, @Numberofpax, @BizVirticale, @DepartmentID,
    @BookingCreationDate, @PrePone, @PrePoneDate, @AgentInvoiceReq, @Reason, @PacageCode, @PrmSrvcLoc,
    @Origin, @OnlineBookingID, @FIT, @SupplierTax_B2b, @SupplierTax_InCluding, @MarkupType_Gross,
    @AgentID, @MarketID, @CityIATACode, @BillingAddress, @PANNo, @GSTNo, @TANNo, @SEZ, @FreeZone,
    @AgentOnCredit, @CreditAmount, @OutStandingAmount, @DBL, @EBA, @EBC, @CNB, @SGL, @taxID,
    @UserNote1, @UserNote2, @CreatedBy, @ModifiedBy, @TamSalesrep, @EnquiryID,@CompanyID,@YearID
BEGIN  
    EXEC dbo.usp_InsertUpdateBooking_PrimaryInfo 
        @Action = 'I',
        @QuotationID = @QuotationID,
        @StartDate = @StartDate,
        @EndDate = @EndDate,
        @City = @City,
        @Service = @Service,
        @Vehical = @Vehical,
        @Vendor = @Vendor,
        @Currency = @Currency,
        @Count = @Count,
        @Adult = @Adult,
        @Child = @Child,
        @Consolidated = @Consolidated,
        @Nationality = @Nationality,
        @Cost = @Cost,
        @Type = @Type,
        @Lock = @Lock,
        @FileCode = @FileCode,
        @GuestName = @GuestName,
        @XONumber = @XONumber,
        @BookingID = @BookingID,
        @Status = @Status,
        @FHE = @FHE,
        @PaxName = @PaxName,
        @MobileNO = @MobileNO,
        @PaxEmailID = @PaxEmailID,
        @Numberofpax = @Numberofpax,
        @BizVirticale = @BizVirticale,
        @DepartmentID = @DepartmentID,
        @BookingCreationDate = @BookingCreationDate,
        @PrePone = @PrePone,
        @PrePoneDate = @PrePoneDate,
        @AgentInvoiceReq = @AgentInvoiceReq,
        @Reason = @Reason,
        @PacageCode = @PacageCode,
        @PrmSrvcLoc = @PrmSrvcLoc,
        @Origin = @Origin,
        @OnlineBookingID = @OnlineBookingID,
        @FIT = @FIT,
        @SupplierTax_B2b = @SupplierTax_B2b,
        @SupplierTax_InCluding = @SupplierTax_InCluding,
        @MarkupType_Gross = @MarkupType_Gross,
        @AgentID = @AgentID,
        @MarketID = @MarketID,
        @CityIATACode = @CityIATACode,
        @BillingAddress = @BillingAddress,
        @PANNo = @PANNo,
        @GSTNo = @GSTNo,
        @TANNo = @TANNo,
        @SEZ = @SEZ,
        @FreeZone = @FreeZone,
        @AgentOnCredit = @AgentOnCredit,
        @CreditAmount = @CreditAmount,
        @OutStandingAmount = @OutStandingAmount,
        @DBL = @DBL,
        @EBA = @EBA,
        @EBC = @EBC,
        @CNB = @CNB,
        @SGL = @SGL,
        @taxID = @taxID,
        @UserNote1 = @UserNote1,
        @UserNote2 = @UserNote2,
        @CreatedBy = @NewCreatedBy,
        @TamSalesrep = @TamSalesrep,
		@IsSubBooking=@IsSubBooking
		,@EQID=@EnquiryID,
		@CompanyId=@CompanyId,
		@YearID=@YearID,

		@ID = @NewID Output;
		--SELECT @NewID = @ID
		--	FROM #TempBooking

			SET @NewBookingID = @NewID;

		select @NewBookingID as NewBookingID
		select @NewID as 'NewID'
		print @BookingID
			--Update Booking.tbl_Booking set ParentID=@BID,BookingSequence=(Isnull((select top 1 BookingSequence from Booking.tbl_Booking where BookingID=@BookingID  order by ID desc),0)+1) where ID=@NewBookingID
UPDATE Booking.tbl_Booking 
SET ParentID = @BID,
    BookingSequence = (
        ISNULL((
            SELECT MAX(BookingSequence) 
            FROM Booking.tbl_Booking 
            WHERE BookingID = @BookingID
        ), 0) + 1
    )
WHERE ID = @NewBookingID 

END
CLOSE clone_cursor;
DEALLOCATE clone_cursor;


--Declare @IsDirectBooking int ;
--set @IsDirectBooking =(select case when Isnull(quotationid,0)=0 then 1 else 0 end from booking.tbl_booking where ID=@BID);
--if(@IsDirectBooking=1)
--BEGIN
----Hotel--
--Declare @CheckIn Date,@CheckOut Date,@RateDetailID NVARCHAR(Max)
--IF(ISNULL((Select top 1 1 from booking.Daywisebooking where BookingID=@BID and RateTypeID=5 and Isnull(IsActive,0)=1 ),0)=1)
--BEGIN
--set @CheckIn=(select top 1 DayWiseDate from booking.Daywisebooking where BookingID=@BID and RateTypeID=5 and Isnull(IsActive,0)=1 Order by ID )
--set @CheckOut=(select top 1  DayWiseDate from booking.Daywisebooking where BookingID=@BID and RateTypeID=5 and Isnull(IsActive,0)=1  Order by ID desc )
--SET @RateDetailID=(SELECT STRING_AGG(RateDetailID, ',') AS CommaSeparatedIDs FROM booking.Daywisebooking WHERE BookingID=@BID and RateTypeID=5 and Isnull(IsActive,0)=1 );
--EXEC [Booking].[usp_HotelDayWiseService] 
--	@CheckIn  = @CheckIn
--	,@CheckOut  = @CheckOut
--	,@BookingID  = @NewBookingID
--	,@UserID  = @NewCreatedBy
--	,@RateDetailID = @RateDetailID
--END

--IF(ISNULL((Select top 1 1 from booking.Daywisebooking where BookingID=@BID and RateTypeID=1 and Isnull(IsActive,0)=1 ),0)=1)
--BEGIN

----GUID--
--set @CheckIn=(select top 1 DayWiseDate from booking.Daywisebooking where BookingID=@BID and RateTypeID=1 and Isnull(IsActive,0)=1 Order by ID )
--set @CheckOut=(select top 1  DayWiseDate from booking.Daywisebooking where BookingID=@BID and RateTypeID=1 and Isnull(IsActive,0)=1  Order by ID desc )
--SET @RateDetailID=(SELECT STRING_AGG(RateDetailID, ',') AS CommaSeparatedIDs FROM booking.Daywisebooking WHERE BookingID=@BID and RateTypeID=1 and Isnull(IsActive,0)=1 );

--EXEC [Booking].[usp_GuidDayWiseService] 
--	@CheckIn  = @CheckIn
--	,@CheckOut  = @CheckOut
--	,@BookingID  = @NewBookingID
--	,@UserID  = @NewCreatedBy
--	,@RateDetailID = @RateDetailID

--	END
--	IF(ISNULL((Select top 1 1 from booking.Daywisebooking where BookingID=@BID and RateTypeID=2 and Isnull(IsActive,0)=1 ),0)=1)
--BEGIN
----Monument--
--set @CheckIn=(select top 1 DayWiseDate from booking.Daywisebooking where BookingID=@BID and RateTypeID=2 and Isnull(IsActive,0)=1 Order by ID )
--set @CheckOut=(select top 1  DayWiseDate from booking.Daywisebooking where BookingID=@BID and RateTypeID=2 and Isnull(IsActive,0)=1  Order by ID desc )
--SET @RateDetailID=(SELECT STRING_AGG(RateDetailID, ',') AS CommaSeparatedIDs FROM booking.Daywisebooking WHERE BookingID=@BID and RateTypeID=2 and Isnull(IsActive,0)=1 );

--EXEC [Booking].[usp_MonumentDayWiseService] 
--	@CheckIn  = @CheckIn
--	,@CheckOut  = @CheckOut
--	,@BookingID  = @NewBookingID
--	,@UserID  = @NewCreatedBy
--	,@RateDetailID = @RateDetailID
--END

--IF(ISNULL((Select top 1 1 from booking.Daywisebooking where BookingID=@BID and RateTypeID=3 and Isnull(IsActive,0)=1 ),0)=1)
--BEGIN
----Transport--
--set @CheckIn=(select top 1 DayWiseDate from booking.Daywisebooking where BookingID=@BID and RateTypeID=3 and Isnull(IsActive,0)=1 Order by ID )
--set @CheckOut=(select top 1  DayWiseDate from booking.Daywisebooking where BookingID=@BID and RateTypeID=3 and Isnull(IsActive,0)=1  Order by ID desc )
--SET @RateDetailID=(SELECT distinct STRING_AGG(RateDetailID, ',') AS CommaSeparatedIDs FROM booking.Daywisebooking WHERE BookingID=@BID and RateTypeID=3 and Isnull(IsActive,0)=1 );
--print @CheckIn
--print @CheckOut
--print @RateDetailID
--print @NewBookingID
--EXEC [Booking].[usp_TransportDayWiseService] 
--	@CheckIn  = @CheckIn
--	,@CheckOut  = @CheckOut
--	,@BookingID  = @NewBookingID
--	,@UserID  = @NewCreatedBy
--	,@RateDetailID = @RateDetailID
--END
--	IF(ISNULL((Select top 1 1 from booking.Daywisebooking where BookingID=@BID and RateTypeID=4 and Isnull(IsActive,0)=1 ),0)=1)
--BEGIN
	
----SpecialService--
--set @CheckIn=(select top 1 DayWiseDate from booking.Daywisebooking where BookingID=@BID and RateTypeID=4 and Isnull(IsActive,0)=1 Order by ID )
--set @CheckOut=(select top 1  DayWiseDate from booking.Daywisebooking where BookingID=@BID and RateTypeID=4 and Isnull(IsActive,0)=1  Order by ID desc )
--SET @RateDetailID=(SELECT STRING_AGG(RateDetailID, ',') AS CommaSeparatedIDs FROM booking.Daywisebooking WHERE BookingID=@BID and RateTypeID=4 and Isnull(IsActive,0)=1 );

--EXEC [Booking].[usp_TransportDayWiseService] 
--	@CheckIn  = @CheckIn
--	,@CheckOut  = @CheckOut
--	,@BookingID  = @NewBookingID
--	,@UserID  = @NewCreatedBy
--	,@RateDetailID = @RateDetailID

	
	

----INSERT INTO [Booking].[OthersRateCardMasterBooking] (
----    [RateId], [ServiceID], [RateType], [CardNumber], [Heading], [ContractDate], [RateCardModeTypeID], [CurrencyID],
----    [VendorID], [CityID], [StateID], [GstStatus], [InfoForOperation], [InfoForAgent], [InfoForRemark], [IsActive],
----    [CreatedOn], [UpdatedOn], [CreatedBy], [UpdatedBy], [LanguageID], [Notes], [HotelID], [HrsPerDay], [KmPerDay],
----    [TransportModeTypeID], [HotelZone], [CityID2], [ReferenceRateDetailID], [TaxID], [ValidFrom], [ValidTo], [MISSequence],
----    [NationalityID], [RatePreferenceID], [VehicleCategoryID], [QuotationID], [Disclaimer], [ReasonID], [BookingID],
----    [CountOfVehicles], [CountOfGuide], [CountOfAdult], [CountOfChild], [Adult], [PerPersonChild], [QuotationNo],
----    [Consolidate], [AddedfromBooking], [FromDate], [ToDate], [IsCustom]
----)
----SELECT
----    [RateId], [ServiceID], [RateType], [CardNumber], [Heading], [ContractDate], [RateCardModeTypeID], [CurrencyID],
----    [VendorID], [CityID], [StateID], [GstStatus], [InfoForOperation], [InfoForAgent], [InfoForRemark], [IsActive],
----    GETDATE(), [UpdatedOn], @NewCreatedBy, [UpdatedBy], [LanguageID], [Notes], [HotelID], [HrsPerDay], [KmPerDay],
----    [TransportModeTypeID], [HotelZone], [CityID2], [ReferenceRateDetailID], [TaxID], [ValidFrom], [ValidTo], [MISSequence],
----    [NationalityID], [RatePreferenceID], [VehicleCategoryID], [QuotationID], [Disclaimer], [ReasonID], @NewBookingID,
----    [CountOfVehicles], [CountOfGuide], [CountOfAdult], [CountOfChild], [Adult], [PerPersonChild], [QuotationNo],
----    [Consolidate], [AddedfromBooking], [FromDate], [ToDate], [IsCustom]
----FROM [Booking].[OthersRateCardMasterBooking]
----WHERE BookingID = @BID;

----INSERT INTO [Booking].[DayWiseBooking] (
----    [QuotationID], [DayWiseDate], [City], [ServiceID], [ServiceName], [Guide], [Language], [Vehical], [Vendor], [Currency],
----    [Count], [Adult], [Child], [Consolidated], [Nationality], [TotalCost], [ServiceType], [IsLock], [RateCardStatus],
----    [BookingID], [RateTypeID], [HotelName], [RoomCategory], [RateType], [MealPlan], [Breakfast], [Lunch], [Dinner],
----    [TransportServive], [VehicleType], [CountOfVehicle], [GuideService], [CountOfGuide], [CountOfAdult], [CountOfChild],
----    [SpecialSerivice], [VendorInfo], [NationalityInfo], [DBL], [EBA], [EBC], [CNB], [SGL], [IsActive],
----    [CreatedBy], [CreatedOn],  [GroupKey], [GrossRate], [RateID], [RateDetailID],
----    [DBL_Rate], [EBA_Rate], [EBC_Rate], [CNB_Rate], [SGL_Rate], [Adult_Rate], [Child_Rate], [TCountRate],
----    [BHRMID], [BORMID], [XOLock], [IsOkXO], [ParentID], [QuotationSequence]
----)
----SELECT 
----    [QuotationID], [DayWiseDate], [City], [ServiceID], [ServiceName], [Guide], [Language], [Vehical], [Vendor], [Currency],
----    [Count], [Adult], [Child], [Consolidated], [Nationality], [TotalCost], [ServiceType], [IsLock], [RateCardStatus],
----    @NewBookingID, [RateTypeID], [HotelName], [RoomCategory], [RateType], [MealPlan], [Breakfast], [Lunch], [Dinner],
----    [TransportServive], [VehicleType], [CountOfVehicle], [GuideService], [CountOfGuide], [CountOfAdult], [CountOfChild],
----    [SpecialSerivice], [VendorInfo], [NationalityInfo], [DBL], [EBA], [EBC], [CNB], [SGL], [IsActive],
----    @NewCreatedBy, getdate(), [GroupKey], [GrossRate], [RateID], [RateDetailID],
----    [DBL_Rate], [EBA_Rate], [EBC_Rate], [CNB_Rate], [SGL_Rate], [Adult_Rate], [Child_Rate], [TCountRate],
----    [BHRMID], [BORMID], [XOLock], [IsOkXO], [ParentID], [QuotationSequence]
----FROM [Booking].[DayWiseBooking]
----WHERE BookingID = @BID; 
--IF(Isnull((Select Top 1 1 FROM [Booking].[OthersRateCardMasterBooking] where BookingID=@NewBookingID),0)=1)
--BEGIN
--print 'Updated [Booking].[OthersRateCardMasterBooking]'
--Print @BID
--Print @NewBookingID
--UPDATE Target
--SET Target.IsActive = Source.IsActive
--FROM [Booking].[OthersRateCardMasterBooking] AS Target
--JOIN [Booking].[OthersRateCardMasterBooking] AS Source
--    ON Source.ServiceID = Target.ServiceID
--WHERE Target.BookingID = @NewBookingID
--  AND Source.BookingID =@BID
--END
 
--IF(Isnull((Select Top 1 1 FROM [Booking].[OthersRateCardCommissionBooking] where BookingID=@NewBookingID),0)=1)
--BEGIN
--print 'Updated [Booking].[[OthersRateCardCommissionBooking]]'
--Print @BID
--Print @NewBookingID

--update Target SET Target.IsActive = Source.IsActive
--FROM [Booking].[OthersRateCardCommissionBooking] AS Target
--INNER JOIN [Booking].[OthersRateCardCommissionBooking] AS Source
--    ON Source.CommissionRefrenceID = Target.CommissionRefrenceID
--   AND Source.CommissionMasterID = Target.CommissionMasterID
--WHERE Target.BookingID = @NewBookingID
--  AND Source.BookingID =@BID
--  END


  
--IF(Isnull((Select Top 1 1 FROM [Booking].[HotelRateCardMasterBooking] where BookingID=@NewBookingID),0)=1)
--BEGIN

--print 'Updated [Booking].[HotelRateCardMasterBooking]'
--Print @BID
--Print @NewBookingID


--UPDATE Target
--SET Target.IsActive = Source.IsActive
--FROM [Booking].[HotelRateCardMasterBooking] AS Target
--JOIN [Booking].[HotelRateCardMasterBooking] AS Source
--    ON Source.HotelRateDetailID = Target.HotelRateDetailID
--WHERE Target.BookingID = @NewBookingID
--  AND Source.BookingID =@BID
--END


  
--IF(Isnull((Select Top 1 1 FROM [Booking].[HotelRateCommissionDetailsBooking] where BookingID=@NewBookingID),0)=1)
--BEGIN

--print 'Updated [Booking].[HotelRateCommissionDetailsBooking]'
--Print @BID
--Print @NewBookingID
--UPDATE Target
--SET Target.IsActive = Source.IsActive
--FROM [Booking].[HotelRateCommissionDetailsBooking] AS Target
--JOIN [Booking].[HotelRateCommissionDetailsBooking] AS Source
-- ON Source.RateCommisionID = Target.RateCommisionID
--   AND Source.CommissionMasterID = Target.CommissionMasterID
--   WHERE Target.BookingID = @NewBookingID
--  AND Source.BookingID = @BID 
--END

  
--IF(Isnull((Select Top 1 1 FROM [Booking].[HotelRateMealPlanMasterBooking] where BookingID=@NewBookingID),0)=1)
--BEGIN

--print 'Updated [Booking].[HotelRateMealPlanMasterBooking]'
--Print @BID
--Print @NewBookingID
--UPDATE Target
--SET Target.IsActive = Source.IsActive
--FROM [Booking].[HotelRateMealPlanMasterBooking] AS Target
--JOIN [Booking].[HotelRateMealPlanMasterBooking] AS Source
-- ON Source.MealTypeID = Target.MealTypeID
--   AND Source.MasterCommissionID = Target.MasterCommissionID
--   WHERE Target.BookingID = @NewBookingID
--  AND Source.BookingID = @BID
--END

--END
--END
--else
--begin
--	BEGIN TRY
--			BEGIN TRANSACTION;
--      exec [Booking].[ConvertQuotationToSubBooking] @QuotationID =@QuotationID ,@BookingID = @NewBookingID

--	  exec [Booking].[InsertDayWiseData] @BookingID =@NewBookingID ,@Action ='I' , @OperationBy =@NewCreatedBy

	  
--	  COMMIT;

--			Select '200' AS returnCode,'Success' returnMessage
--		END TRY

--		BEGIN CATCH
--			ROLLBACK;

--			SELECT 'Error' AS STATUS
--				,ERROR_MESSAGE() AS ErrorMessage;
--		END CATCH
--end
END
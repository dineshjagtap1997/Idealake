CREATE PROCEDURE [Booking].[ConvertQuotationToBooking] (
	@QuotationID BIGINT=621
	,@Action VARCHAR(1) = 'c'
	,@CompanyID INT = 9
	,@YearID INT = 6
	,@OutBookingID BIGINT = NULL OUTPUT
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @QuotationCount INT = 0;
	DECLARE @CompanyCode NVARCHAR(5) = '';
	DECLARE @YearCode NVARCHAR(5) = '';
	DECLARE @Prefix NVARCHAR(20) = '';
	DECLARE @MaxNumber INT = 0;
	DECLARE @NewBookingNo NVARCHAR(50);
	DECLARE @HRMID INT;
	DECLARE @ORMID INT;
	DECLARE @HotelRateID INT;
	DECLARE @CardNumber NVARCHAR(50);
	DECLARE @ContractDate DATETIME;
	DECLARE @Days NVARCHAR(100);
	DECLARE @RoomCategoryID INT;
	DECLARE @MealPlanID INT;
	DECLARE @CurrencyID NVARCHAR(200);
	DECLARE @InfoForRemark NVARCHAR(500);
	DECLARE @HotelID INT;
	DECLARE @StateID INT;
	DECLARE @GstStatus NVARCHAR(10);
	DECLARE @CityID NVARCHAR(10);
	DECLARE @Heading NVARCHAR(200);
	DECLARE @InfoForAgent NVARCHAR(MAX);
	DECLARE @InfoForOperation NVARCHAR(MAX);
	DECLARE @PaymentTypeID INT;
	DECLARE @RateCardModeTypeID INT;
	DECLARE @RateTypeID INT;
	DECLARE @ValueAddOn NVARCHAR(MAX);
	DECLARE @IsActive BIT;
	DECLARE @BookingID BIGINT;
	DECLARE @Disclaimer NVARCHAR(500);
	DECLARE @CheckIn DATETIME;
	DECLARE @CheckOut DATETIME;
	DECLARE @OfferTypeID INT;
	DECLARE @HotelRateDetailID INT;
	DECLARE @UpdatedBy UNIQUEIDENTIFIER;
	DECLARE @UpdatedOn DATETIME;
	DECLARE @RMQuotationID BIGINT;
	DECLARE @QuotationNo NVARCHAR(150);
	DECLARE @RateId BIGINT;
	DECLARE @ServiceID INT;
	DECLARE @RateType INT;
	DECLARE @VendorID INT;
	DECLARE @CreatedOn DATETIME;
	DECLARE @CreatedBy UNIQUEIDENTIFIER;
	DECLARE @LanguageID CHAR(5);
	DECLARE @Notes VARCHAR(255);
	DECLARE @HrsPerDay INT;
	DECLARE @KmPerDay INT;
	DECLARE @TransportModeTypeID INT;
	DECLARE @HotelZone VARCHAR(255);
	DECLARE @CityID2 VARCHAR(255);
	DECLARE @ReferenceRateDetailID BIGINT;
	DECLARE @TaxID INT;
	DECLARE @ValidFrom DATETIME;
	DECLARE @ValidTo DATETIME;
	DECLARE @MISSequence VARCHAR(255);
	DECLARE @NationalityID INT;
	DECLARE @RatePreferenceID INT;
	DECLARE @VehicleCategoryID INT;
	DECLARE @ReasonID INT;
	DECLARE @CountofVehicles INT;
	DECLARE @CountofGuide INT;
	DECLARE @Consolidate INT;
	DECLARE @Child INT;
	DECLARE @Adult INT;
	DECLARE @PerPersonChild INT;
	DECLARE @ORMCurrencyID NVARCHAR(100);
	-- variable for Hotel/other Rate Card Master Commission reference ID
	DECLARE @OutHotelRateCardMasterID INT;
	DECLARE @OutOtherRateCardMasterID INT;
	DECLARE @IsCustom INT;
	DECLARE @FromDate DATETIME;
	DECLARE @ToDate DATETIME;

	DECLARE	@offerIncluded BIT=1;

	-- Fetch CompanyCode
	IF @CompanyID IS NOT NULL
		AND @CompanyID > 0
	BEGIN
		SELECT @CompanyCode = ISNULL(CompCode, '')
		FROM CompanyMaster
		WHERE CompanyID = @CompanyID;
	END

	-- Fetch YearCode
	IF @YearID IS NOT NULL
		AND @YearID > 0
	BEGIN
		SELECT @YearCode = ISNULL(YearCode, '')
		FROM YearMaster
		WHERE YearID = @YearID;
	END

	IF @QuotationID IS NOT NULL
		AND @QuotationID > 0
	BEGIN
		SELECT @QuotationCount = Count(1)
		FROM Quotation.QuotationMaster
		WHERE QuotationID = @QuotationID and Status = 3;
	END

	SET @Prefix = 'B' + @CompanyCode + @YearCode;

	SELECT @MaxNumber = ISNULL(MAX(CAST(RIGHT(BookingID, 6) AS INT)), 0)
	FROM [Booking].[tbl_Booking]
	WHERE BookingID LIKE @Prefix + '%'
		AND ISNUMERIC(RIGHT(BookingID, 6)) = 1;

	SET @NewBookingNo = @Prefix + RIGHT('000000' + CAST(@MaxNumber + 1 AS VARCHAR(6)), 6);

	BEGIN TRY
		BEGIN TRANSACTION;

		DECLARE @AgentId INT ;
		select @AgentId = AgentId from Quotation.QuotationMaster QM
 INNER JOIN tbl_Enquiry E ON QM.EnquiryID = E.EQID
  WHERE QuotationID = @QuotationID and Status = 3

		IF @QuotationID IS NOT NULL
			AND @QuotationID > 0 AND @QuotationCount > 0
		BEGIN
			INSERT INTO [Booking].[tbl_Booking] (
				[QuotationID]
				,[Currency]
				,[BookingID]
				,[Status]
				,CompanyID
				,YearID
				,CreatedBy
				,CreatedOn
				,EnquiryID
				,taxID
				,AgentID
				,SupplierTax_InCluding
				,StartDate
				,EndDate
				,FHE
				)
			SELECT QuotationID
				,Currency
				,@NewBookingNo AS BookingID
				,2
				,@CompanyID
				,@YearID
				,CreatedBy
				,getdate()
				,EnquiryID
				,TaxonSale
				,ISNULL(@AgentId,0)
				,
				CASE
					WHEN TaxType=0 THEN 1
					ELSE 0
				END
				,(SELECT dbo.fn_GetQuotationDateForBooking(@QuotationID, 1))
				,(SELECT dbo.fn_GetQuotationDateForBooking(@QuotationID, 0))
				,CreatedBy

				--,(select min(CheckIn) from Quotation.HotelRateCardMaster where QuotationID=@QuotationID)
				--,(select max(CheckOut) from Quotation.HotelRateCardMaster where QuotationID=@QuotationID)

			FROM Quotation.QuotationMaster
			WHERE QuotationID = @QuotationID and Status = 3;

			SET @OutBookingID = SCOPE_IDENTITY();
			Update Quotation.QuotationMaster set BookingID =@OutBookingID where QuotationID=@QuotationID
			--Inserting in Hotel Table
			DECLARE HotelRateCardMasterBooking_Cursor CURSOR
			FOR
			SELECT [ID] AS [HRMID]
				,[HotelRateID]
				,[CardNumber]
				,[ContractDate]
				,[Days]
				,[RoomCategoryID]
				,[MealPlanID]
				,[CurrencyID]
				,[InfoForRemark]
				,[HotelID]
				,[StateID]
				,[GstStatus]
				,[CityID]
				,[Heading]
				,[InfoForAgent]
				,[InfoForOperation]
				,[PaymentTypeID]
				,[RateCardModeTypeID]
				,[RateTypeID]
				,[ValueAddOn]
				,[IsActive]
				,@OutBookingID AS [BookingID]
				,HRM.[Disclaimer]
				,[CheckIn]
				,[CheckOut]
				,[OfferTypeID]
				,[HotelRateDetailID]
				,HRM.[UpdatedBy]
				,getdate() AS [UpdatedOn]
				,HRM.[QuotationID] AS [RMQuotationID]
				,QM.[QuotationNo]
				,Cast(HRM.IsCustom AS INT) as IsCustom
			FROM Quotation.HotelRateCardMaster HRM
			LEFT JOIN [Quotation].[QuotationMaster] QM ON HRM.QuotationID = QM.QuotationID
			WHERE HRM.QuotationID IN (
					SELECT QuotationID
					FROM Quotation.QuotationMaster
					WHERE (
							QuotationID = @QuotationID
							
							--OR ParentID IN (
							--	SELECT ParentID
							--	FROM Quotation.QuotationMaster
							--	WHERE QuotationID = @QuotationID
							--	UNION
							--	Select @QuotationID as ParentID
							--	)
							OR ((QuotationNo = (
								SELECT QuotationNo
								FROM Quotation.QuotationMaster
								WHERE QuotationID = @QuotationID
								))and (ParentID is null or ParentID = 0))
							) and Status = 3
					)

			OPEN HotelRateCardMasterBooking_Cursor;

			FETCH NEXT
			FROM HotelRateCardMasterBooking_Cursor
			INTO @HRMID
				,@HotelRateID
				,@CardNumber
				,@ContractDate
				,@Days
				,@RoomCategoryID
				,@MealPlanID
				,@CurrencyID
				,@InfoForRemark
				,@HotelID
				,@StateID
				,@GstStatus
				,@CityID
				,@Heading
				,@InfoForAgent
				,@InfoForOperation
				,@PaymentTypeID
				,@RateCardModeTypeID
				,@RateTypeID
				,@ValueAddOn
				,@IsActive
				,@BookingID
				,@Disclaimer
				,@CheckIn
				,@CheckOut
				,@OfferTypeID
				,@HotelRateDetailID
				,@UpdatedBy
				,@UpdatedOn
				,@RMQuotationID
				,@QuotationNo
				,@IsCustom;

			WHILE @@FETCH_STATUS = 0
			BEGIN
				INSERT INTO [Booking].[HotelRateCardMasterBooking] (
					[HotelRateID]
					,[CardNumber]
					,[ContractDate]
					,[Days]
					,[RoomCategoryID]
					,[MealPlanID]
					,[CurrencyID]
					,[InfoForRemark]
					,[HotelID]
					,[StateID]
					,[GstStatus]
					,[CityID]
					,[Heading]
					,[InfoForAgent]
					,[InfoForOperation]
					,[PaymentTypeID]
					,[RateCardModeTypeID]
					,[RateTypeID]
					,[ValueAddOn]
					,[IsActive]
					,[BookingID]
					,[Disclaimer]
					,[CheckIn]
					,[CheckOut]
					,[OfferTypeID]
					,[HotelRateDetailID]
					,[UpdatedBy]
					,[UpdatedOn]
					,[QuotationID]
					,[QuotationNo]
					,[IsCustom]
					)
				VALUES (
					@HotelRateID
					,@CardNumber
					,@ContractDate
					,@Days
					,@RoomCategoryID
					,@MealPlanID
					,@CurrencyID
					,@InfoForRemark
					,@HotelID
					,@StateID
					,@GstStatus
					,@CityID
					,@Heading
					,@InfoForAgent
					,@InfoForOperation
					,@PaymentTypeID
					,@RateCardModeTypeID
					,@RateTypeID
					,@ValueAddOn
					,@IsActive
					,@BookingID
					,@Disclaimer
					,@CheckIn
					,@CheckOut
					,@OfferTypeID
					,@HotelRateDetailID
					,@UpdatedBy
					,@UpdatedOn
					,@RMQuotationID
					,@QuotationNo
					,@IsCustom
					);

				SET @OutHotelRateCardMasterID = SCOPE_IDENTITY();

				INSERT INTO [Booking].[HotelRateCommissionDetailsBooking] (
					[QuotationHotelRateID]
					,[CommissionMasterID]
					,[TaxPercentage]
					,[TaxAmount]
					,[GrossAmountIncludingTax]
					,[GrossAmountExcludingTax]
					,[CommisionPercentage]
					,[IsMarkup]
					,[MarkupValue]
					,[ReasonMasterId]
					,[CreatedOn]
					,[UpdatedOn]
					,[IsActive]
					,[UpdatedBy]
					,[CreatedBy]
					,[GrossRate]
					,[SellingRate]
					,[RateCommisionID]
					,[HotelRateID]
					,[BookingID]
					,[HotelRateDetailID]
					,[NetAmountIncludingTax]
					,[NetAmountExcludingTax]
					,[QuotationID]
					,[COUNT]
					,[Breakfast]
					,[Lunch]
					,[Dinner]
					)
				SELECT @OutHotelRateCardMasterID AS [QuotationHotelRateID]
					,[CommissionMasterID]
					,[TaxPercentage]
					,[TaxAmount]
					,[GrossAmountIncludingTax]
					,[GrossAmountExcludingTax]
					,[CommisionPercentage]
					,[IsMarkup]
					,[MarkupValue]
					,[ReasonMasterId]
					,GETDATE() AS [CreatedOn]
					,GETDATE() AS [UpdatedOn]
					,HRC.[IsActive]
					,HRC.[UpdatedBy]
					,HRC.[CreatedBy]
					,case when Isnull([IsGrossRateModified],0) =1 then ModifiedGrossRate else GrossRate end
					,[SellingRate]
					,[RateCommisionID]
					,HRC.[HotelRateID]
					,@OutBookingID AS [BookingID]
					,HRC.[HotelRateDetailID]
					,[NetAmountIncludingTax]
					,[NetAmountExcludingTax]
					,HRC.[QuotationID]
					,1 AS [COUNT]
					,MP.Breakfast
					,MP.Lunch
					,MP.Dinner
				FROM Quotation.HotelRateCommissionDetails HRC
				LEFT JOIN Quotation.HotelRateCardMaster HRM on HRM.ID = HRC.QuotationHotelRateID
				LEFT JOIN MealPlan MP on MP.ID = HRM.MealPlanID
				WHERE QuotationHotelRateID = @HRMID

				INSERT INTO [Booking].[HotelRateMealPlanMasterBooking] (
					[MealTypeID]
					,[GstPercentage]
					,[GstAmount]
					,[NetAmountIncludingTax]
					,[NetAmountExcludingTax]
					,[IsActive]
					,[CreatedOn]
					,[UpdatedOn]
					,[MasterCommissionID]
					,[UpdatedBy]
					,[CreatedBy]
					,[IsMealDetails]
					,[DefineAmount]
					,[QuotationHotelRateID]
					,[SellingRate]
					,[ReasonMasterId]
					,[HotelRateID]
					,[BookingID]
					,[HotelRateDetailID]
					,[QuotationID]
					,IsSupplementary
					,IsGross
					
					)
				SELECT [MealTypeID]
					,[GstPercentage]
					,[GstAmount]
					,[NetAmountIncludingTax]
					,[NetAmountExcludingTax]
					,[IsActive]
					,[CreatedOn]
					,[UpdatedOn]
					,[MasterCommissionID]
					,[UpdatedBy]
					,[CreatedBy]
					,[IsMealDetails]
					,[DefineAmount]
					,@OutHotelRateCardMasterID AS [QuotationHotelRateID]
					,[SellingRate]
					,[ReasonMasterId]
					,[HotelRateID]
					,@OutBookingID AS [BookingID]
					,[HotelRateDetailID]
					,[QuotationID]
					--,
					--CASE
					--	WHEN ISNULL(IsSupplementary,0)=1 OR ISNULL(IsGross,0)=1 
					--	THEN 1
					--	ELSE 0
					--END,
					,IsSupplementary
					,IsGross
							
				FROM Quotation.HotelRateMealPlanMaster
				WHERE QuotationHotelRateID = @HRMID

				-----------OfferIncluded---------Open

				IF EXISTS (
					SELECT 1
					FROM RateCards.HotelRateDetails HRD
					WHERE 
						@IsCustom = 0 AND
						HRD.HotelRateDetailID = @HotelRateDetailID AND
						HRD.IsActive = 1 AND
						HRD.OfferTypeID IN (1, 2)
				)
				BEGIN
					-- Insert Offer Configuration if it exists
					IF EXISTS (
						SELECT 1
						FROM RateCards.HotelRateOfferConfiguration
						WHERE HotelRateDetailID = @HotelRateDetailID
					)
					BEGIN
						INSERT INTO [Booking].[HotelRateOfferConfigurationBooking]
						(
							HotelRateDetailID,
							Days,
							FromDate,
							ToDate,
							TotalNights,
							PaidNights,
							FreeNights,
							IsExtendible,
							IsActive,
							IsDeleted,
							BookingHotelRateID
						)
						SELECT
							HotelRateDetailID,
							Days,
							FromDate,
							ToDate,
							TotalNights,
							PaidNights,
							FreeNights,
							IsExtendible,
							IsActive,
							IsDeleted,
							@OutHotelRateCardMasterID
						FROM RateCards.HotelRateOfferConfiguration
						WHERE HotelRateDetailID = @HotelRateDetailID
					END

					-- Insert Offer Configuration Commission if it exists
					IF EXISTS (
						SELECT 1
						FROM RateCards.HotelRateOfferConfigurationCommission
						WHERE OfferConfigurationID IN (
							SELECT OfferID
							FROM RateCards.HotelRateOfferConfiguration
							WHERE HotelRateDetailID = @HotelRateDetailID
						)
					)
					BEGIN
						INSERT INTO [Booking].[HotelRateOfferConfigurationCommissionBooking]
						(
							OfferConfigurationID,
							MasterCommissionID,
							Discount,
							DiscountAmount,
							Tax,
							TaxAmount,
							PaidNightAmountExcludingTax,
							PaidNightAmountIncludingTax,
							FreeNightAmountExcludingTax,
							FreeNightAmountIncludingTax,
							GrossAmountExcludingTax,
							GrossAmountIncludingTax,
							NetAmountExcludingTax,
							NetAmountIncludingTax,
							IsActive,
							IsDeleted,
							BookingHotelRateID
						)
						SELECT
							OfferConfigurationID,
							MasterCommissionID,
							Discount,
							DiscountAmount,
							Tax,
							TaxAmount,
							PaidNightAmountExcludingTax,
							PaidNightAmountIncludingTax,
							FreeNightAmountExcludingTax,
							FreeNightAmountIncludingTax,
							GrossAmountExcludingTax,
							GrossAmountIncludingTax,
							NetAmountExcludingTax,
							NetAmountIncludingTax,
							IsActive,
							IsDeleted,
							@OutHotelRateCardMasterID
						FROM RateCards.HotelRateOfferConfigurationCommission
						WHERE OfferConfigurationID IN (
							SELECT OfferID
							FROM RateCards.HotelRateOfferConfiguration
							WHERE HotelRateDetailID = @HotelRateDetailID
						)
					END
				END
				-----------OfferIncluded---------END

				FETCH NEXT
				FROM HotelRateCardMasterBooking_Cursor
				INTO @HRMID
					,@HotelRateID
					,@CardNumber
					,@ContractDate
					,@Days
					,@RoomCategoryID
					,@MealPlanID
					,@CurrencyID
					,@InfoForRemark
					,@HotelID
					,@StateID
					,@GstStatus
					,@CityID
					,@Heading
					,@InfoForAgent
					,@InfoForOperation
					,@PaymentTypeID
					,@RateCardModeTypeID
					,@RateTypeID
					,@ValueAddOn
					,@IsActive
					,@BookingID
					,@Disclaimer
					,@CheckIn
					,@CheckOut
					,@OfferTypeID
					,@HotelRateDetailID
					,@UpdatedBy
					,@UpdatedOn
					,@RMQuotationID
					,@QuotationNo
					,@IsCustom;
			END

			CLOSE HotelRateCardMasterBooking_Cursor;

			DEALLOCATE HotelRateCardMasterBooking_Cursor;

			--Inserting in Transport/Guide/Monument/special Service Table
			DECLARE OthersRateCardMasterBooking_Cursor CURSOR
			FOR
			SELECT [ID] AS ORMID
				,[RateId]
				,[ServiceID]
				,[RateType]
				,[CardNumber]
				,QM.QuotationNo
				,[Heading]
				,[ContractDate]
				,[RateCardModeTypeID]
				,[CurrencyID] AS ORMCurrencyID
				,[VendorID]
				,[CityID]
				,[StateID]
				,[GstStatus]
				,[InfoForOperation]
				,[InfoForAgent]
				,[InfoForRemark]
				,[IsActive]
				,[CreatedOn]
				,[UpdatedOn]
				,ORM.[CreatedBy]
				,ORM.[UpdatedBy]
				,[LanguageID]
				,[Notes]
				,[HotelID]
				,[HrsPerDay]
				,[KmPerDay]
				,[TransportModeTypeID]
				,[HotelZone]
				,[CityID2]
				,[ReferenceRateDetailID]
				,[TaxID]
				,[ValidFrom]
				,[ValidTo]
				,[MISSequence]
				,[NationalityID]
				,[RatePreferenceID]
				,[VehicleCategoryID]
				,ORM.[QuotationID] AS RMQuotationID
				,ORM.[Disclaimer]
				,[ReasonID]
				,@OutBookingID AS BookingID
				,1 AS [CountofVehicles]
				,1 AS [CountofGuide]
				,IsNull((select 1 from Quotation.OthersRateCardCommission where OthersRateRefrenceID=Orm.ID and CommissionMasterID=0),0) AS [Consolidate]
				,IsNull((select 1 from Quotation.OthersRateCardCommission where OthersRateRefrenceID=Orm.ID and CommissionMasterID=7),0) AS [Child]
				,IsNull((select 1 from Quotation.OthersRateCardCommission where OthersRateRefrenceID=Orm.ID and CommissionMasterID=7),0) AS [Adult]
				,1 AS [PerPersonChild]
				,Cast(ORM.IsCustom AS INT) as IsCustom
				,ORM.FromDate
				,ORM.ToDate
				
			FROM [Quotation].[OthersRateCardMaster] ORM
			LEFT JOIN [Quotation].[QuotationMaster] QM ON ORM.QuotationID = QM.QuotationID
			--Where QM.QuotationID = @QuotationID  
			WHERE QM.QuotationID IN (
					SELECT QuotationID
					FROM Quotation.QuotationMaster
					WHERE (
							QuotationID = @QuotationID
							--OR ParentID IN (
							--	SELECT ParentID
							--	FROM Quotation.QuotationMaster
							--	WHERE QuotationID = @QuotationID
							--	UNION
							--	Select @QuotationID as ParentID
							--	)
							--OR QuotationID IN (
							--	SELECT ParentID
							--	FROM Quotation.QuotationMaster
							--	WHERE QuotationID = @QuotationID
							--	)
										OR ((QuotationNo = (
								SELECT QuotationNo
								FROM Quotation.QuotationMaster
								WHERE QuotationID = @QuotationID
								))and (ParentID is null or ParentID = 0))
							) and status = 3
					)

			OPEN OthersRateCardMasterBooking_Cursor;

			FETCH NEXT
			FROM OthersRateCardMasterBooking_Cursor
			INTO @ORMID
				,@RateId
				,@ServiceID
				,@RateType
				,@CardNumber
				,@QuotationNo
				,@Heading
				,@ContractDate
				,@RateCardModeTypeID
				,@ORMCurrencyID
				,@VendorID
				,@CityID
				,@StateID
				,@GstStatus
				,@InfoForOperation
				,@InfoForAgent
				,@InfoForRemark
				,@IsActive
				,@CreatedOn
				,@UpdatedOn
				,@CreatedBy
				,@UpdatedBy
				,@LanguageID
				,@Notes
				,@HotelID
				,@HrsPerDay
				,@KmPerDay
				,@TransportModeTypeID
				,@HotelZone
				,@CityID2
				,@ReferenceRateDetailID
				,@TaxID
				,@ValidFrom
				,@ValidTo
				,@MISSequence
				,@NationalityID
				,@RatePreferenceID
				,@VehicleCategoryID
				,@RMQuotationID
				,@Disclaimer
				,@ReasonID
				,@BookingID
				,@CountofVehicles
				,@CountofGuide
				,@Consolidate
				,@Child
				,@Adult
				,@PerPersonChild
				,@IsCustom
				,@FromDate
				,@ToDate;

			WHILE @@FETCH_STATUS = 0
			BEGIN
				INSERT INTO [Booking].[OthersRateCardMasterBooking] (
					[RateId]
					,[ServiceID]
					,[RateType]
					,[CardNumber]
					,[QuotationNo]
					,[Heading]
					,[ContractDate]
					,[RateCardModeTypeID]
					,[CurrencyID]
					,[VendorID]
					,[CityID]
					,[StateID]
					,[GstStatus]
					,[InfoForOperation]
					,[InfoForAgent]
					,[InfoForRemark]
					,[IsActive]
					,[CreatedOn]
					,[UpdatedOn]
					,[CreatedBy]
					,[UpdatedBy]
					,[LanguageID]
					,[Notes]
					,[HotelID]
					,[HrsPerDay]
					,[KmPerDay]
					,[TransportModeTypeID]
					,[HotelZone]
					,[CityID2]
					,[ReferenceRateDetailID]
					,[TaxID]
					,[ValidFrom]
					,[ValidTo]
					,[MISSequence]
					,[NationalityID]
					,[RatePreferenceID]
					,[VehicleCategoryID]
					,[QuotationID]
					,[Disclaimer]
					,[ReasonID]
					,[BookingID]
					,[CountofVehicles]
					,[CountofGuide]
					,[Consolidate]
					,[CountOfChild]
					,[Adult]
					,[PerPersonChild]
					,[IsCustom]
					,[FromDate]
					,[ToDate]
					)
				VALUES (
					@RateId
					,@ServiceID
					,@RateType
					,@CardNumber
					,@QuotationNo
					,@Heading
					,@ContractDate
					,@RateCardModeTypeID
					,@ORMCurrencyID
					,@VendorID
					,@CityID
					,@StateID
					,@GstStatus
					,@InfoForOperation
					,@InfoForAgent
					,@InfoForRemark
					,@IsActive
					,@CreatedOn
					,@UpdatedOn
					,@CreatedBy
					,@UpdatedBy
					,@LanguageID
					,@Notes
					,@HotelID
					,@HrsPerDay
					,@KmPerDay
					,@TransportModeTypeID
					,@HotelZone
					,@CityID2
					,@ReferenceRateDetailID
					,@TaxID
					,@ValidFrom
					,@ValidTo
					,@MISSequence
					,@NationalityID
					,@RatePreferenceID
					,@VehicleCategoryID
					,@RMQuotationID
					,@Disclaimer
					,@ReasonID
					,@BookingID
					,@CountofVehicles
					,@CountofGuide
					,@Consolidate
					,@Child
					,@Adult
					,@Child
					,@IsCustom
					,@FromDate
					,@ToDate

					);

				SET @OutOtherRateCardMasterID = SCOPE_IDENTITY();

				INSERT INTO [Booking].[OthersRateCardCommissionBooking] (
					[CommissionRefrenceID]
					,[RateID]
					,[CommissionMasterID]
					,[MinimumPax]
					,[MaximumPax]
					,[IsAmtIncludedInBasic]
					,[TaxPercentage]
					,[TaxAmount]
					,[NetAmountExcludingTax]
					,[NetAmountIncludingTax]
					,[Markup_IsRate]
					,[NetRate]
					,[SellingRates]
					,[IsActive]
					,[CreatedOn]
					,[UpdatedOn]
					,[CreatedBy]
					,[UpdatedBy]
					,[OthersRateRefrenceID]
					,[MarkupRate]
					,[GrossRate]
					,[BookingID]
					)
				SELECT [CommissionRefrenceID]
					,[RateID]
					,[CommissionMasterID]
					,[MinimumPax]
					,[MaximumPax]
					,[IsAmtIncludedInBasic]
					,[TaxPercentage]
					,[TaxAmount]
					,case when Isnull(IsGrossRateModified,0)=1 then ModifiedGrossRate else [GrossRate] end 
					,case when Isnull(IsGrossRateModified,0)=1 then ModifiedGrossRate + Isnull([TaxAmount],0) else [GrossRate] + Isnull([TaxAmount],0) end 
					,[Markup_IsRate]
					,[NetRate]
					,[SellingRates]
					,[IsActive]
					,[CreatedOn]
					,[UpdatedOn]
					,[CreatedBy]
					,[UpdatedBy]
					,@OutOtherRateCardMasterID AS [OthersRateRefrenceID]
					,[MarkupRate]
					,case when Isnull(IsGrossRateModified,0)=1 then ModifiedGrossRate else [GrossRate] end 
					,@OutBookingID AS BookingID
				FROM [Quotation].[OthersRateCardCommission]
				WHERE OthersRateRefrenceID = @ORMID

				FETCH NEXT
				FROM OthersRateCardMasterBooking_Cursor
				INTO @ORMID
					,@RateId
					,@ServiceID
					,@RateType
					,@CardNumber
					,@QuotationNo
					,@Heading
					,@ContractDate
					,@RateCardModeTypeID
					,@ORMCurrencyID
					,@VendorID
					,@CityID
					,@StateID
					,@GstStatus
					,@InfoForOperation
					,@InfoForAgent
					,@InfoForRemark
					,@IsActive
					,@CreatedOn
					,@UpdatedOn
					,@CreatedBy
					,@UpdatedBy
					,@LanguageID
					,@Notes
					,@HotelID
					,@HrsPerDay
					,@KmPerDay
					,@TransportModeTypeID
					,@HotelZone
					,@CityID2
					,@ReferenceRateDetailID
					,@TaxID
					,@ValidFrom
					,@ValidTo
					,@MISSequence
					,@NationalityID
					,@RatePreferenceID
					,@VehicleCategoryID
					,@RMQuotationID
					,@Disclaimer
					,@ReasonID
					,@BookingID
					,@CountofVehicles
					,@CountofGuide
					,@Consolidate
					,@Child
					,@Adult
					,@PerPersonChild
					,@IsCustom
					,@FromDate
					,@ToDate;
			END

			CLOSE OthersRateCardMasterBooking_Cursor;

			DEALLOCATE OthersRateCardMasterBooking_Cursor;
		END;
		SELECT '200' AS returnCode, 'Record Inserted successfully.' AS returnMessage, @BookingID AS ID; 
		COMMIT TRANSACTION;

		Update Quotation.QuotationMaster set Status=5 where QuotationID = @QuotationID
	END TRY

	BEGIN CATCH
		-- Roll back the transaction if an error occurs
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		-- Releasing Cursor in case of error
		CLOSE HotelRateCardMasterBooking_Cursor;

		DEALLOCATE HotelRateCardMasterBooking_Cursor;

		CLOSE OthersRateCardMasterBooking_Cursor;

		DEALLOCATE OthersRateCardMasterBooking_Cursor;

		-- Optionally re-throw or return the error
		DECLARE @ErrorMessage NVARCHAR(4000)
			,@ErrorSeverity INT
			,@ErrorState INT;

		SELECT @ErrorMessage = ERROR_MESSAGE()
			,@ErrorSeverity = ERROR_SEVERITY()
			,@ErrorState = ERROR_STATE();

		RAISERROR (
				@ErrorMessage
				,@ErrorSeverity
				,@ErrorState
				);
	END CATCH
END
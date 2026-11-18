
CREATE PROCEDURE [Booking].[ConvertQuotationToSubBooking] (
	@QuotationID BIGINT
	,@BookingID BIGINT = NULL 
	)
AS
BEGIN
	SET NOCOUNT ON;

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
	DECLARE @CountOfAdult INT;
	DECLARE @CountOfChild INT;
	DECLARE @Adult INT;
	DECLARE @PerPersonChild INT;
	DECLARE @ORMCurrencyID NVARCHAR(100);
	DECLARE @OutHotelRateCardMasterID INT;
	DECLARE @OutOtherRateCardMasterID INT;
	DECLARE @IsCustom INT;

	-- Fetch CompanyCode
	--IF @CompanyID IS NOT NULL
	--	AND @CompanyID > 0
	--BEGIN
	--	SELECT @CompanyCode = ISNULL(CompCode, '')
	--	FROM CompanyMaster
	--	WHERE CompanyID = @CompanyID;
	--END

	---- Fetch YearCode
	--IF @YearID IS NOT NULL
	--	AND @YearID > 0
	--BEGIN
	--	SELECT @YearCode = ISNULL(YearCode, '')
	--	FROM YearMaster
	--	WHERE YearID = @YearID;
	--END

	--SET @Prefix = 'B' + @CompanyCode + @YearCode;

	--SELECT @MaxNumber = ISNULL(MAX(CAST(RIGHT(BookingID, 6) AS INT)), 0)
	--FROM [Booking].[tbl_Booking]
	--WHERE BookingID LIKE @Prefix + '%'
	--	AND ISNUMERIC(RIGHT(BookingID, 6)) = 1;

	--SET @NewBookingNo = @Prefix + RIGHT('000000' + CAST(@MaxNumber + 1 AS VARCHAR(6)), 6);

	BEGIN TRY
		BEGIN TRANSACTION;

		IF @QuotationID IS NOT NULL
			AND @QuotationID > 0
		BEGIN
			--INSERT INTO [Booking].[tbl_Booking] (
			--	[QuotationID]
			--	,[Currency]
			--	,[BookingID]
			--	,[Status]
			--	)
			--SELECT QuotationID
			--	,Currency
			--	,@NewBookingNo AS BookingID
			--	,2
			--FROM Quotation.QuotationMaster
			--WHERE QuotationID = @QuotationID

			--SET @OutBookingID = SCOPE_IDENTITY();

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
				,@BookingID
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
							OR ParentID IN (
								SELECT ParentID
								FROM Quotation.QuotationMaster
								WHERE QuotationID = @QuotationID
								)
							OR QuotationID IN (
								SELECT ParentID
								FROM Quotation.QuotationMaster
								WHERE QuotationID = @QuotationID
								)
							)
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
					,[GrossRate]
					,[SellingRate]
					,[RateCommisionID]
					,HRC.[HotelRateID]
					,@BookingID
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
					,@BookingID
					,[HotelRateDetailID]
					,[QuotationID]
				FROM Quotation.HotelRateMealPlanMaster
				WHERE QuotationHotelRateID = @HRMID

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
				,@BookingID
				,1 AS [CountofVehicles]
				,1 AS [CountofGuide]
				,1 AS [CountOfAdult]
				,1 AS [CountOfChild]
				,1 AS [Adult]
				,1 AS [PerPersonChild]
			FROM [Quotation].[OthersRateCardMaster] ORM
			LEFT JOIN [Quotation].[QuotationMaster] QM ON ORM.QuotationID = QM.QuotationID
			--Where QM.QuotationID = @QuotationID  
			WHERE QM.QuotationID IN (
					SELECT QuotationID
					FROM Quotation.QuotationMaster
					WHERE (
							QuotationID = @QuotationID
							OR ParentID IN (
								SELECT ParentID
								FROM Quotation.QuotationMaster
								WHERE QuotationID = @QuotationID
								)
							OR QuotationID IN (
								SELECT ParentID
								FROM Quotation.QuotationMaster
								WHERE QuotationID = @QuotationID
								)
							)
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
				,@CountOfAdult
				,@CountOfChild
				,@Adult
				,@PerPersonChild;

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
					,[CountOfAdult]
					,[CountOfChild]
					,[Adult]
					,[PerPersonChild]
					,[consolidate]
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
					,@CountOfAdult
					,@CountOfChild
					,@Adult
					,@PerPersonChild
					,1
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
					,@OutOtherRateCardMasterID AS [OthersRateRefrenceID]
					,[MarkupRate]
					,[GrossRate]
					,@BookingID
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
					,@CountOfAdult
					,@CountOfChild
					,@Adult
					,@PerPersonChild;
			END

			CLOSE OthersRateCardMasterBooking_Cursor;

			DEALLOCATE OthersRateCardMasterBooking_Cursor;
		END;
		SELECT '200' AS returnCode, 'Record Inserted successfully.' AS returnMessage, @BookingID AS ID; 
		COMMIT TRANSACTION;
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
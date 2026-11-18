CREATE PROCEDURE [RateCards].[Copy_HotelRateCard]
    @RateCardID BIGINT,
    @CreatedBy UNIQUEIDENTIFIER = NULL,
    @HotelRateID BIGINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

	DECLARE @ContractDate DATETIME,@CurrencyID VARCHAR(10),@PaymentTypeID INT,@StateID INT,@GstStatus VARCHAR(20),@Heading VARCHAR(100),
        @RateCardModeTypeID INT,@HotelID INT,@VendorID INT,@CityID VARCHAR(3),@RateTypeID INT,@ValueAddOn VARCHAR(MAX),@InfoForOperation VARCHAR(200),
        @InfoForRemark VARCHAR(200),@InfoForAgent VARCHAR(MAX),@IsActive BIT,@IsCommission BIT,@CardNumber VARCHAR(20);

    -- Fetch main Hotel Rate Card data
    SELECT 
        @HotelRateID = HotelRateID,
        @ContractDate = ContractDate,
        @CurrencyID = CurrencyID,
        @PaymentTypeID = PaymentTypeID,
        @StateID = StateID,
        @GstStatus = GstStatus,
        @Heading = Heading,
        @RateCardModeTypeID = RateCardModeTypeID,
        @HotelID = HotelID,
        @VendorID = VendorID,
        @CityID = CityID,
        @RateTypeID = RateTypeID,
        @ValueAddOn = ValueAddOn,
        @InfoForOperation = InfoForOperation,
        @InfoForRemark = InfoForRemark,
        @InfoForAgent = InfoForAgent,
        @IsActive = IsActive,
        @IsCommission = IsCommission
    FROM [RateCards].HotelRateMaster
    WHERE HotelRateID = @RateCardID;

    -- Insert into HotelRateMaster using existing SP
    EXEC [RateCards].[CreateOrUpdate_HotelRateCard]
        @Operation = 'INSERT',
        @ID = 0,
        @ContractDate = @ContractDate,
        @CurrencyID = @CurrencyID,
        @PaymentTypeID = @PaymentTypeID,
        @StateID = @StateID,
        @GstStatus = @GstStatus,
        @Heading = @Heading,
        @RateCardModeTypeID = @RateCardModeTypeID,
        @HotelID = @HotelID,
        @VendorID = @VendorID,
        @CityID = @CityID,
        @RateTypeID = @RateTypeID,
        @ValueAddOn = @ValueAddOn,
        @InfoForOperation = @InfoForOperation,
        @InfoForRemark = @InfoForRemark,
        @InfoForAgent = @InfoForAgent,
        @IsActive = @IsActive,
        @CreatedBy = @CreatedBy,
        @UpdatedBy = NULL,
        @IsCommission = @IsCommission,
        @HotelRateID = @HotelRateID OUTPUT,
        @CardNumber = @CardNumber OUTPUT;

	-- Copy Market Sheet Lookups
    DECLARE @MarketSheetID INT;

    DECLARE MarketCursor CURSOR FOR
        SELECT RateSheetID 
        FROM RateCards.HotelRatesheetMasterLookup
        WHERE HotelRateID = @RateCardID AND IsActive = 1;

    OPEN MarketCursor;
    FETCH NEXT FROM MarketCursor INTO @MarketSheetID;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC [RateCards].[CreateOrUpdate_HotelRateMarketSheet]
            @Operation = 'ADD',
            @HotelRateID = @HotelRateID,
            @RateSheetID = @MarketSheetID;

        FETCH NEXT FROM MarketCursor INTO @MarketSheetID;
    END

    CLOSE MarketCursor;
    DEALLOCATE MarketCursor;

	-- Copy Market Lookups
    DECLARE @MarketRateID INT;

    DECLARE MarketLookupCursor CURSOR FOR
        SELECT MarketRateID 
        FROM RateCards.HotelRateMarketMasterLookup
        WHERE HotelRateID = @RateCardID AND IsActive = 1;

    OPEN MarketLookupCursor;
    FETCH NEXT FROM MarketLookupCursor INTO @MarketRateID;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC [RateCards].[CreateOrUpdate_HotelRateMarket]
            @Operation = 'ADD',
            @HotelRateID = @HotelRateID,
            @RateSheetID = @MarketRateID;

        FETCH NEXT FROM MarketLookupCursor INTO @MarketRateID;
    END

    CLOSE MarketLookupCursor;
    DEALLOCATE MarketLookupCursor;

	-- Copy Voucher Type Lookups
    DECLARE @VoucherTypeID INT;

    DECLARE VoucherCursor CURSOR FOR
        SELECT VoucherTypeID 
        FROM RateCards.HotelRateVoucherTypeLookup
        WHERE HotelRateID = @RateCardID AND IsActive = 1;

    OPEN VoucherCursor;
    FETCH NEXT FROM VoucherCursor INTO @VoucherTypeID;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC [RateCards].[CreateOrUpdate_HotelRateVoucherType]
            @Operation = 'ADD',
            @HotelRateID = @HotelRateID,
            @VoucherTypeID = @VoucherTypeID;

        FETCH NEXT FROM VoucherCursor INTO @VoucherTypeID;
    END
    CLOSE VoucherCursor;
    DEALLOCATE VoucherCursor;


    -- Loop over related Hotel Rate Details
    DECLARE @HotelRateDetailID BIGINT;

    DECLARE detail_cursor CURSOR FOR
    SELECT HotelRateDetailID, TaxID, RoomCategoryID, [Days], GIT, FIT, MealPlanID,
           TransferID, MinNights, MaxNights, RateTypeID, OfferTypeID, MISSequence, IsActive, BusinessType
    FROM [RateCards].HotelRateDetails
    WHERE HotelRateID = @RateCardID;

    DECLARE 
        @TaxID INT, @RoomCategoryID INT, @Days VARCHAR(7), @GIT BIT, @FIT BIT,
        @MealPlanID INT, @TransferID INT, @MinNights INT, @MaxNights INT,
        @DetailRateTypeID INT, @OfferTypeID INT, @MISSequence VARCHAR(50),
        @DetailIsActive BIT, @BusinessType INT, @HotelRateDetailID_New BigINT;

    OPEN detail_cursor;
    FETCH NEXT FROM detail_cursor INTO 
        @HotelRateDetailID, @TaxID, @RoomCategoryID, @Days, @GIT, @FIT,
        @MealPlanID, @TransferID, @MinNights, @MaxNights,
        @DetailRateTypeID, @OfferTypeID, @MISSequence, @DetailIsActive, @BusinessType;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC [RateCards].[CreateOrUpdate_HotelRateDetail]
            @Operation = 'INSERT',
            @ID = 0,
            @TaxID = @TaxID,
            @RoomCategoryID = @RoomCategoryID,
            @Days = @Days,
            @GIT = @GIT,
            @FIT = @FIT,
            @MealPlanID = @MealPlanID,
            @TransferID = @TransferID,
            @MinNights = @MinNights,
            @MaxNights = @MaxNights,
            @RateTypeID = @DetailRateTypeID,
            @OfferTypeID = @OfferTypeID,
            @MISSequence = @MISSequence,
            @IsActive = @DetailIsActive,
            @BusinessType = @BusinessType,
            @CreatedBy = @CreatedBy,
            @UpdatedBy = NULL,
            @HotelRateID = @HotelRateID,
            @HotelRateDetailID = @HotelRateDetailID_New OUTPUT;

		 -- Clone validity records
        DECLARE @ValidityID BIGINT;
        DECLARE ValidityCursor CURSOR FOR
            SELECT BookFrom, BookTo, RateValidFrom, RateValidTo FROM RateCards.RateValidityMaster
            WHERE HotelRateDetailID = @HotelRateDetailID AND IsActive = 1;

        DECLARE @BookFrom DATETIME, @BookTo DATETIME, @RateValidFrom DATETIME, @RateValidTo DATETIME;

        OPEN ValidityCursor;
        FETCH NEXT FROM ValidityCursor INTO @BookFrom, @BookTo, @RateValidFrom, @RateValidTo;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            EXEC [RateCards].[CreateOrUpdate_RateValidityMaster]
                @Operation = 'INSERT',
                @BookFrom = @BookFrom,
                @BookTo = @BookTo,
                @RateValidFrom = @RateValidFrom,
                @RateValidTo = @RateValidTo,
                @CreatedBy = @CreatedBy,
                @HotelRateDetailID = @HotelRateDetailID_New,
                @IsActive = 1,
                @RateValidityID = @ValidityID OUTPUT;

            FETCH NEXT FROM ValidityCursor INTO @BookFrom, @BookTo, @RateValidFrom, @RateValidTo;
        END

        CLOSE ValidityCursor;
        DEALLOCATE ValidityCursor;

		 -- Clone commission records
        DECLARE @CommissionID BIGINT;
        DECLARE CommissionCursor CURSOR FOR
            SELECT CommissionMasterID, TaxPercentage, TaxAmount, GrossAmountIncludingTax, GrossAmountExcludingTax,
                   CommisionPercentage, CommissionAmount, NetAmountIncludingTax, NetAmountExcludingTax, IsTax
            FROM RateCards.RateCommisionDetails
            WHERE HotelRateDetailID = @HotelRateDetailID AND IsActive = 1;

        DECLARE @MasterCommissionID INT, @TaxPercentage DECIMAL(18,2), @TaxAmount DECIMAL(18,2),
                @GrossAmountIncludingTax DECIMAL(18,2), @GrossAmountExcludingTax DECIMAL(18,2),
                @CommissionPercentage DECIMAL(18,2), @CommissionAmount DECIMAL(18,2),
                @NetAmountIncludingTax DECIMAL(18,2), @NetAmountExcludingTax DECIMAL(18,2), @IsTax BIT;

        OPEN CommissionCursor;
        FETCH NEXT FROM CommissionCursor INTO @MasterCommissionID, @TaxPercentage, @TaxAmount,
            @GrossAmountIncludingTax, @GrossAmountExcludingTax, @CommissionPercentage, @CommissionAmount,
            @NetAmountIncludingTax, @NetAmountExcludingTax, @IsTax;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            EXEC [RateCards].[CreateOrUpdate_RateCommissionDetail]
                @Operation = 'INSERT',
                @MasterCommissionID = @MasterCommissionID,
                @TaxPercentage = @TaxPercentage,
                @TaxAmount = @TaxAmount,
                @GrossAmountIncludingTax = @GrossAmountIncludingTax,
                @GrossAmountExcludingTax = @GrossAmountExcludingTax,
                @NetAmountIncludingTax = @NetAmountIncludingTax,
                @NetAmountExcludingTax = @NetAmountExcludingTax,
                @CommissionPercentage = @CommissionPercentage,
                @CommissionAmount = @CommissionAmount,
                @HotelRateDetailID = @HotelRateDetailID_New,
                @IsTax = @IsTax,
                @CreatedBy = @CreatedBy,
                @IsActive = 1,
                @RateCommissionID = @CommissionID OUTPUT;

            FETCH NEXT FROM CommissionCursor INTO @MasterCommissionID, @TaxPercentage, @TaxAmount,
                @GrossAmountIncludingTax, @GrossAmountExcludingTax, @CommissionPercentage, @CommissionAmount,
                @NetAmountIncludingTax, @NetAmountExcludingTax, @IsTax;
        END

        CLOSE CommissionCursor;
        DEALLOCATE CommissionCursor;

		-- Clone meal overview records for each commission
		DECLARE @MealTypeID INT, @IsMealDetails BIT, @DefineAmount DECIMAL(18,2),
				@MealGstPercentage DECIMAL(18,2), @MealGstAmount DECIMAL(18,2),
				@MealNetInclTax DECIMAL(18,2), @MealNetExclTax DECIMAL(18,2);

		DECLARE MealCursor CURSOR FOR
			SELECT MealTypeID,GstPercentage,GstAmount,NetAmountIncludingTax,NetAmountExcludingTax,IsActive, IsMealDetails, DefineAmount,MasterCommissionID
			FROM [RateCards].HotelMealOverviewMaster
			WHERE HotelRateDetailID = @HotelRateDetailID;

		OPEN MealCursor;
		FETCH NEXT FROM MealCursor INTO @MealTypeID,@MealGstPercentage,@MealGstAmount,@MealNetInclTax,@MealNetExclTax,@IsActive,@IsMealDetails, @DefineAmount,@MasterCommissionID;

		WHILE @@FETCH_STATUS = 0
		BEGIN
			EXEC [RateCards].[CreateOrUpdate_HotelRateMeal]
				@Operation = 'INSERT',
				@MasterCommissionID = @MasterCommissionID,
				@HotelRateDetailID = @HotelRateDetailID_New,
				@MealTypeID = @MealTypeID,
				@IsMealDetails = @IsMealDetails,
				@DefineAmount = @DefineAmount,
				@GstPercentage = @MealGstPercentage,
				@GstAmount = @MealGstAmount,
				@NetAmountIncludingTax = @MealNetInclTax,
				@NetAmountExcludingTax = @MealNetExclTax,
				@IsActive = @IsActive,
				@CreatedBy = @CreatedBy;

			FETCH NEXT FROM MealCursor INTO  @MealTypeID,@MealGstPercentage,@MealGstAmount,@MealNetInclTax,@MealNetExclTax,@IsActive,@IsMealDetails, @DefineAmount,@MasterCommissionID;
		END

		CLOSE MealCursor;
		DEALLOCATE MealCursor;

		-- Clone Hotel Rate Offer Configuration and its Commission
	DECLARE @OldOfferID BIGINT,@OfferDays INT,@FromDate DATETIME,@ToDate DATETIME,@TotalNights INT,@PaidNights INT,
    @FreeNights INT,@IsExtendible BIT,@OfferIsActive BIT,@IsDeleted BIT,@NewOfferID BIGINT,@OfferIDOutput BIGINT

			DECLARE OfferCloneCursor CURSOR FOR
			SELECT OfferID,Days,FromDate,ToDate,TotalNights,PaidNights,FreeNights,IsExtendible,IsActive,IsDeleted 
			from RateCards.HotelRateOfferConfiguration where HotelRateDetailID=@HotelRateDetailID;

			OPEN OfferCloneCursor
			FETCH NEXT FROM OfferCloneCursor INTO @OldOfferID,@OfferDays,@FromDate,@ToDate,@TotalNights,@PaidNights,@FreeNights,@IsExtendible,@OfferIsActive,@IsDeleted

			WHILE @@FETCH_STATUS = 0
			BEGIN
    
			-- Insert new offer configuration
			IF @OldOfferID IS NOT NULL
			BEGIN
				EXEC [RateCards].[CreateOrUpdate_HotelRateOfferConfiguration]
					@Operation = 'INSERT',
					@ID = NULL,
					@HotelRateDetailID = @HotelRateDetailID_New,
					@Days = @OfferDays,
					@FromDate = @FromDate,
					@ToDate = @ToDate,
					@TotalNights = @TotalNights,
					@PaidNights = @PaidNights,
					@FreeNights = @FreeNights,
					@IsExtendible = @IsExtendible,
					@IsActive = @OfferIsActive,
					@IsDeleted = @IsDeleted,
					@OfferID = @OfferIDOutput OUTPUT
				SET @NewOfferID = @OfferIDOutput
				-- Clone associated commission (if any)
				IF @NewOfferID IS NOT NULL
				BEGIN
						-- Declare variables for OfferCommission fields
						DECLARE @Discount DECIMAL(18,2),@DiscountAmount DECIMAL(18,2),@Tax DECIMAL(18,2),@PaidNightAmountExcludingTax DECIMAL(18,2),@PaidNightAmountIncludingTax DECIMAL(18,2),
						@FreeNightAmountExcludingTax DECIMAL(18,2),@FreeNightAmountIncludingTax DECIMAL(18,2)

						-- Declare cursor
						DECLARE offerCommission_cursor CURSOR FOR
						SELECT MasterCommissionID,Discount,DiscountAmount,Tax,TaxAmount,PaidNightAmountExcludingTax,PaidNightAmountIncludingTax,FreeNightAmountExcludingTax,
							FreeNightAmountIncludingTax,GrossAmountExcludingTax,GrossAmountIncludingTax,NetAmountExcludingTax,NetAmountIncludingTax
						FROM [RateCards].[HotelRateOfferConfigurationCommission] WHERE OfferConfigurationID = @OldOfferID

						-- Open cursor
						OPEN offerCommission_cursor

						-- Fetch first row
						FETCH NEXT FROM offerCommission_cursor INTO @MasterCommissionID,@Discount,@DiscountAmount,@Tax,@TaxAmount,@PaidNightAmountExcludingTax,@PaidNightAmountIncludingTax,
							@FreeNightAmountExcludingTax,@FreeNightAmountIncludingTax,@GrossAmountExcludingTax,@GrossAmountIncludingTax,@NetAmountExcludingTax,@NetAmountIncludingTax

     					-- Loop through cursor
						WHILE @@FETCH_STATUS = 0
						BEGIN
						-- Call SP to insert cloned OfferCommission
						EXEC [RateCards].[CreateOrUpdate_HotelRateOfferConfigurationCommission]
						@Operation = 'INSERT',
						@OfferID = @NewOfferID,
						@MasterCommissionID = @MasterCommissionID,
						@Discount = @Discount,
						@DiscountAmount = @DiscountAmount,
						@Tax = @Tax,
						@TaxAmount = @TaxAmount,
						@PaidNightAmountExcludingTax = @PaidNightAmountExcludingTax,
						@PaidNightAmountIncludingTax = @PaidNightAmountIncludingTax,
						@FreeNightAmountExcludingTax = @FreeNightAmountExcludingTax,
						@FreeNightAmountIncludingTax = @FreeNightAmountIncludingTax,
						@GrossAmountExcludingTax = @GrossAmountExcludingTax,
						@GrossAmountIncludingTax = @GrossAmountIncludingTax,
						@NetAmountExcludingTax = @NetAmountExcludingTax,
						@NetAmountIncludingTax = @NetAmountIncludingTax

						-- Fetch next
							FETCH NEXT FROM offerCommission_cursor INTO @MasterCommissionID,@Discount,@DiscountAmount,@Tax,@TaxAmount,@PaidNightAmountExcludingTax,@PaidNightAmountIncludingTax,
							@FreeNightAmountExcludingTax,@FreeNightAmountIncludingTax,@GrossAmountExcludingTax,@GrossAmountIncludingTax,@NetAmountExcludingTax,@NetAmountIncludingTax
					END

					-- Close and deallocate cursor
					CLOSE offerCommission_cursor
					DEALLOCATE offerCommission_cursor
				END
			END

			FETCH NEXT FROM OfferCloneCursor INTO @OldOfferID,@OfferDays,@FromDate,@ToDate,@TotalNights,@PaidNights,@FreeNights,@IsExtendible,@OfferIsActive,@IsDeleted;
			END

			CLOSE OfferCloneCursor
			DEALLOCATE OfferCloneCursor



        FETCH NEXT FROM detail_cursor INTO 
            @HotelRateDetailID, @TaxID, @RoomCategoryID, @Days, @GIT, @FIT,
            @MealPlanID, @TransferID, @MinNights, @MaxNights,
            @DetailRateTypeID, @OfferTypeID, @MISSequence, @DetailIsActive, @BusinessType;
    END

    CLOSE detail_cursor;
    DEALLOCATE detail_cursor;

	
	-- Clone Cancellation Policies associated with the old HotelRateID
	DECLARE @PolicyID BIGINT,@ValidFrom DATETIME,@ValidTo DATETIME,@TsStart VARCHAR(100),@TsEnd VARCHAR(100),@AgentStart VARCHAR(100),@AgentEnd VARCHAR(100),
    @ChangePercent VARCHAR(100),@ChargeNight VARCHAR(100),@PolicyIsActive BIT,@NewPolicyID BIGINT,@RateCardTypeID INT;

	DECLARE CancellationPolicyCursor CURSOR FOR
	SELECT PolicyID,RateCardTypeID,ValidFrom,ValidTo,TsStart,TsEnd,AgentStart,AgentEnd,ChangePercent,ChargeNight,IsActive
	FROM RateCards.CancellationPolicy WHERE RateCardID = @RateCardID;

	OPEN CancellationPolicyCursor;

	FETCH NEXT FROM CancellationPolicyCursor INTO @PolicyID,@RateCardTypeID,@ValidFrom,@ValidTo,@TsStart,@TsEnd,@AgentStart,@AgentEnd,@ChangePercent,@ChargeNight,@PolicyIsActive;

	WHILE @@FETCH_STATUS = 0
	BEGIN
    EXEC [RateCards].[Usp_CreateOrUpdate_RateCardCancellationPolicy]
        @Operation = 'INSERT',
        @RateCardTypeID = @RateCardTypeID,
        @RateCardID = @HotelRateID,
        @ValidFrom = @ValidFrom,
        @ValidTo = @ValidTo,
        @TsStart = @TsStart,
        @TsEnd = @TsEnd,
        @AgentStart = @AgentStart,
        @AgentEnd = @AgentEnd,
        @ChangePercent = @ChangePercent,
        @ChargeNight = @ChargeNight,
        @IsActive = @PolicyIsActive,
        @LogID = @PolicyID OUTPUT;

    FETCH NEXT FROM CancellationPolicyCursor INTO  @PolicyID,@RateCardTypeID,@ValidFrom,@ValidTo,@TsStart,@TsEnd,@AgentStart,@AgentEnd,@ChangePercent,@ChargeNight,@PolicyIsActive;
	END

	CLOSE CancellationPolicyCursor;
	DEALLOCATE CancellationPolicyCursor;

		-- Step 4: Copy Rules
	IF CURSOR_STATUS('global', 'rule_cursor') >= -1
    BEGIN
        CLOSE rule_cursor;
        DEALLOCATE rule_cursor;
    END
    DECLARE @RuleID INT, @MISSeqeunce VARCHAR(40), @ApplicableID INT, @RuleDescription VARCHAR(300), @RuleIsActive BIT, @RuleRecordID BIGINT;

    DECLARE rule_cursor CURSOR LOCAL FORWARD_ONLY READ_ONLY FOR
    SELECT RateCardTypeID,RuleID, MISSeqeunce, ApplicableID, [Description], IsActive
    FROM RateCards.Rules
    WHERE RateCardID = @RateCardID;

    OPEN rule_cursor;
    FETCH NEXT FROM rule_cursor INTO @RateCardTypeID,@RuleID, @MISSeqeunce, @ApplicableID, @RuleDescription, @RuleIsActive;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC [RateCards].[Usp_CreateOrUpdateRules]
            @Operation = 'INSERT',
            @ID = NULL,
            @RateCardTypeID = @RateCardTypeID,
            @RateCardID = @HotelRateID,
            @RuleID = @RuleID,
            @MISSeqeunce = @MISSeqeunce,
            @ApplicableID = @ApplicableID,
            @Description = @RuleDescription,
            @IsActive = @RuleIsActive,
            @OperationBy = @CreatedBy,
            @GuideRateID = @RuleRecordID OUTPUT;

        FETCH NEXT FROM rule_cursor INTO @RateCardTypeID,@RuleID, @MISSeqeunce, @ApplicableID, @RuleDescription, @RuleIsActive;
    END

    CLOSE rule_cursor;
    DEALLOCATE rule_cursor;

	-- Copy Documents 
	INSERT INTO LinkedDocuments (ParentID, ParentTypeID, DocumentID)
	SELECT @HotelRateID, ParentTypeID, DocumentID FROM LinkedDocuments
	WHERE ParentID = @RateCardID;

    SELECT '200' AS returnCode, 'Hotel Rate Card copied successfully.' AS returnMessage, @HotelRateID AS HotelRateID;
END
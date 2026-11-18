


CREATE PROCEDURE [Quotation].[InsertCloneVersionforQuotationID]
(
    @QuotationID INT,
    @Action VARCHAR(1)
)
AS
BEGIN
    DECLARE @Prefix NVARCHAR(20) = '';
    DECLARE @MaxNumber INT = 0;
    DECLARE @NewQuotationNo NVARCHAR(50);
    DECLARE @OutQuotationID VARCHAR(50);
    DECLARE @QuotationNo VARCHAR(50);
    DECLARE @CreatedBy UNIQUEIDENTIFIER;
    DECLARE @NextVersion INT;
    DECLARE @FinalQuotationNo VARCHAR(50);
    DECLARE @BaseQuotationNo VARCHAR(50);

    IF @Action = 'C' AND EXISTS (SELECT 1 FROM [Quotation].[QuotationMaster] WHERE QuotationID = @QuotationID)
    BEGIN
        SET @Prefix = 'Q';

        SELECT @MaxNumber = ISNULL(MAX(CAST(RIGHT(QuotationNo, 6) AS INT)), 0)
        FROM [Quotation].[QuotationMaster]
        WHERE QuotationNo LIKE @Prefix + '%'
          AND ISNUMERIC(RIGHT(QuotationNo, 6)) = 1;

        SET @NewQuotationNo = 'Q' + RIGHT('000000' + CAST(@MaxNumber + 1 AS VARCHAR(6)), 6);

        INSERT INTO [Quotation].[QuotationMaster] (
            QuotationNo, EnquiryID, Status, CreatedBy, CreatedDate,
            RateCardMode, CompanyID, AgentName, TaxonSale, YearID,
            Currency, ParentID
        )
        SELECT 
            @NewQuotationNo, EnquiryID, 1, CreatedBy, GETDATE(),
            RateCardMode, CompanyID, AgentName, TaxonSale, YearID,
            Currency, @QuotationID
        FROM [Quotation].[QuotationMaster]
        WHERE QuotationID = @QuotationID;

        SET @OutQuotationID = SCOPE_IDENTITY();
        SET @QuotationNo = @NewQuotationNo;
    END
    ELSE IF @Action = 'V' AND EXISTS (SELECT 1 FROM [Quotation].[QuotationMaster] WHERE QuotationID = @QuotationID)
    BEGIN
        SELECT @BaseQuotationNo = QuotationNo
        FROM [Quotation].[QuotationMaster]
        WHERE QuotationID = @QuotationID;
 

			SELECT @NextVersion = ISNULL(MAX(QuotationSequence), 0) + 1
					FROM [Quotation].[QuotationMaster]
					WHERE QuotationNo = @BaseQuotationNo;

		SET @FinalQuotationNo = @BaseQuotationNo;

        INSERT INTO [Quotation].[QuotationMaster] (
            QuotationNo, EnquiryID, Status, CreatedBy, CreatedDate,
<<<<<<< HEAD
<<<<<<< HEAD
            RateCardMode, ParentID, CompanyID, QuotationSequence 
=======
            RateCardMode, ParentID, CompanyID, QuotationSequence,YearID ,Currency,TaxonSale
>>>>>>> dev
=======
            RateCardMode, ParentID, CompanyID, QuotationSequence,YearID ,Currency,TaxonSale
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
        )
        SELECT
            @FinalQuotationNo, EnquiryID,
            CASE WHEN EnquiryID IS NOT NULL AND EnquiryID <> 0 THEN 1 ELSE 0 END,
<<<<<<< HEAD
<<<<<<< HEAD
            CreatedBy, GETDATE(), RateCardMode, QuotationID, CompanyID, @NextVersion 
        FROM [Quotation].[QuotationMaster]
=======
            CreatedBy, GETDATE(), RateCardMode, QuotationID, CompanyID, @NextVersion,YearID ,Currency,TaxonSale
			FROM [Quotation].[QuotationMaster]
>>>>>>> dev
=======
            CreatedBy, GETDATE(), RateCardMode, QuotationID, CompanyID, @NextVersion,YearID ,Currency,TaxonSale
			FROM [Quotation].[QuotationMaster]
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
        WHERE QuotationID = @QuotationID;

        SET @OutQuotationID = SCOPE_IDENTITY();
        SET @QuotationNo = @FinalQuotationNo;
    END

    -- ===========================
    -- Common Cursor Section Here OtherRateCards
    -- ===========================
    IF @OutQuotationID IS NOT NULL
    BEGIN
        DECLARE @OldID BIGINT, @NewID BIGINT;

        DECLARE cur CURSOR FOR
        SELECT ID
        FROM [Quotation].[OthersRateCardMaster]
        WHERE QuotationID = @QuotationID;

        OPEN cur;
        FETCH NEXT FROM cur INTO @OldID;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Insert into master table
            INSERT INTO [Quotation].[OthersRateCardMaster] (
                RateId, ServiceID, RateType, CardNumber, Heading, ContractDate, RateCardModeTypeID,
                CurrencyID, VendorID, CityID, StateID, GstStatus, InfoForOperation, InfoForAgent,
                InfoForRemark, IsActive, CreatedOn, UpdatedOn, CreatedBy, UpdatedBy, LanguageID, Notes,
                HotelID, HrsPerDay, KmPerDay, TransportModeTypeID, HotelZone, CityID2,
                ReferenceRateDetailID, TaxID, ValidFrom, ValidTo, MISSequence, NationalityID,
<<<<<<< HEAD
<<<<<<< HEAD
                RatePreferenceID, VehicleCategoryID, QuotationID, Disclaimer, ReasonID
=======
                RatePreferenceID, VehicleCategoryID, QuotationID, Disclaimer, ReasonID,FromDate,ToDate
>>>>>>> dev
=======
                RatePreferenceID, VehicleCategoryID, QuotationID, Disclaimer, ReasonID,FromDate,ToDate
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
            )
            SELECT 
                RateId, ServiceID, RateType, CardNumber, Heading, ContractDate, RateCardModeTypeID,
                CurrencyID, VendorID, CityID, StateID, GstStatus, InfoForOperation, InfoForAgent,
                InfoForRemark, IsActive, GETDATE(), GETDATE(), CreatedBy, UpdatedBy, LanguageID, Notes,
                HotelID, HrsPerDay, KmPerDay, TransportModeTypeID, HotelZone, CityID2,
                ReferenceRateDetailID, TaxID, ValidFrom, ValidTo, MISSequence, NationalityID,
<<<<<<< HEAD
<<<<<<< HEAD
                RatePreferenceID, VehicleCategoryID, @OutQuotationID, Disclaimer, ReasonID
=======
                RatePreferenceID, VehicleCategoryID, @OutQuotationID, Disclaimer, ReasonID,FromDate,ToDate
>>>>>>> dev
=======
                RatePreferenceID, VehicleCategoryID, @OutQuotationID, Disclaimer, ReasonID,FromDate,ToDate
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
            FROM [Quotation].[OthersRateCardMaster]
            WHERE ID = @OldID;

            SET @NewID = SCOPE_IDENTITY();

            -- Insert commissions
            INSERT INTO [Quotation].[OthersRateCardCommission] (
                CommissionRefrenceID, RateID, CommissionMasterID, MinimumPax, MaximumPax,
                IsAmtIncludedInBasic, TaxPercentage, TaxAmount, NetAmountExcludingTax,
                NetAmountIncludingTax, Markup_IsRate, NetRate, SellingRates, IsActive,
                CreatedOn, UpdatedOn, CreatedBy, UpdatedBy, OthersRateRefrenceID, MarkupRate, GrossRate
            )
            SELECT 
                CommissionRefrenceID, RateID, CommissionMasterID, MinimumPax, MaximumPax,
                IsAmtIncludedInBasic, TaxPercentage, TaxAmount, NetAmountExcludingTax,
                NetAmountIncludingTax, Markup_IsRate, NetRate, SellingRates, IsActive,
                GETDATE(), GETDATE(), CreatedBy, UpdatedBy, @NewID, MarkupRate, GrossRate
            FROM [Quotation].[OthersRateCardCommission]
            WHERE OthersRateRefrenceID = @OldID;

            FETCH NEXT FROM cur INTO @OldID;
        END;

        CLOSE cur;
        DEALLOCATE cur;
    END

	 -- ===========================
    -- Common Cursor Section Here HotelRateCards 3 Table
    -- ========================
	IF @OutQuotationID IS NOT NULL
	BEGIN 

			DECLARE @OldIDH BIGINT, @NewIDH BIGINT;

			DECLARE cur CURSOR FOR
			SELECT ID
			FROM [Quotation].[HotelRateCardMaster]
			WHERE QuotationID = @QuotationID 

			OPEN cur;
			FETCH NEXT FROM cur INTO @OldIDH;

			WHILE @@FETCH_STATUS = 0
			BEGIN
				---- Insert into HotelRateCardMaster and get new ID
				INSERT INTO [Quotation].[HotelRateCardMaster] (
					HotelRateID, CardNumber, ContractDate, Days, RoomCategoryID,
					MealPlanID, CurrencyID, InfoForRemark, HotelID,
					StateID, GstStatus, CityID, Heading, InfoForAgent, InfoForOperation,
					PaymentTypeID, RateCardModeTypeID, RateTypeID, ValueAddOn, IsActive,
<<<<<<< HEAD
<<<<<<< HEAD
					QuotationID, Disclaimer
=======
					QuotationID, Disclaimer,CheckIn,CheckOut
>>>>>>> dev
=======
					QuotationID, Disclaimer,CheckIn,CheckOut
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
				)
				SELECT 
					HotelRateID, CardNumber, ContractDate, Days, RoomCategoryID,
					MealPlanID, CurrencyID, InfoForRemark, HotelID,
					StateID, GstStatus, CityID, Heading, InfoForAgent, InfoForOperation,
					PaymentTypeID, RateCardModeTypeID, RateTypeID, ValueAddOn, IsActive,
					@OutQuotationID, --  new QuotationID
<<<<<<< HEAD
<<<<<<< HEAD
					Disclaimer
=======
					Disclaimer,CheckIn,CheckOut
>>>>>>> dev
=======
					Disclaimer,CheckIn,CheckOut
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
				FROM [Quotation].[HotelRateCardMaster]
				WHERE ID = @OldIDH;

				SET @NewIDH = SCOPE_IDENTITY();

				---- Copy Commission Details
				INSERT INTO [Quotation].[HotelRateCommissionDetails] (
					QuotationHotelRateID, CommissionMasterID, TaxPercentage, TaxAmount,
					GrossAmountIncludingTax, GrossAmountExcludingTax, CommisionPercentage,
					IsMarkup, MarkupValue, ReasonMasterId, CreatedOn, UpdatedOn, IsActive,
					UpdatedBy, CreatedBy, GrossRate, SellingRate
				)
				SELECT 
					@NewIDH, CommissionMasterID, TaxPercentage, TaxAmount,
					GrossAmountIncludingTax, GrossAmountExcludingTax, CommisionPercentage,
					IsMarkup, MarkupValue, ReasonMasterId, GETDATE(), GETDATE(), IsActive,
					UpdatedBy, CreatedBy, GrossRate, SellingRate
				FROM [Quotation].[HotelRateCommissionDetails]
				WHERE QuotationHotelRateID = @OldIDH;

				---- Copy Meal Plan Details
				INSERT INTO [Quotation].[HotelRateMealPlanMaster] (
					MealTypeID, GstPercentage, GstAmount, NetAmountIncludingTax,
					NetAmountExcludingTax, IsActive, CreatedOn, UpdatedOn, MasterCommissionID,
					UpdatedBy, CreatedBy, IsMealDetails, DefineAmount, QuotationHotelRateID,
<<<<<<< HEAD
<<<<<<< HEAD
					SellingRate, ReasonMasterId
=======
					SellingRate, ReasonMasterId,IsGross,IsSupplementary
>>>>>>> dev
=======
					SellingRate, ReasonMasterId,IsGross,IsSupplementary
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
				)
				SELECT 
					MealTypeID, GstPercentage, GstAmount, NetAmountIncludingTax,
					NetAmountExcludingTax, IsActive, GETDATE(), GETDATE(), MasterCommissionID,
					UpdatedBy, CreatedBy, IsMealDetails, DefineAmount, @NewIDH,
<<<<<<< HEAD
<<<<<<< HEAD
					SellingRate, ReasonMasterId
=======
					SellingRate, ReasonMasterId,IsGross,IsSupplementary
>>>>>>> dev
=======
					SellingRate, ReasonMasterId,IsGross,IsSupplementary
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
				FROM [Quotation].[HotelRateMealPlanMaster]
				WHERE QuotationHotelRateID = @OldIDH;


				---- Copy RateValidityMaster
				INSERT INTO [Quotation].[RateValidityMaster] (
					RateValidityID, QuotationHotelRateID, BookFrom, BookTo,
					RateValidFrom, RateValidTo, HotelRateDetailID,
					CreatedOn, UpdatedOn, IsActive, UpdatedBy, CreatedBy, QuotationId
				)
				SELECT 
					RateValidityID, @NewIDH, BookFrom, BookTo,
					RateValidFrom, RateValidTo, HotelRateDetailID,
					GETDATE(), GETDATE(), IsActive, UpdatedBy, CreatedBy, @OutQuotationID
				FROM [Quotation].[RateValidityMaster]
				WHERE QuotationHotelRateID = @OldIDH;

				FETCH NEXT FROM cur INTO @OldIDH;
			END;

			CLOSE cur;
			DEALLOCATE cur;






	END



    -- ===================
    -- Final Output
    -- ===================
    IF @OutQuotationID IS NOT NULL
    BEGIN
        SELECT 
            '200' AS returnCode,
            CASE 
                WHEN @Action = 'C' THEN 'Quotation Copy created successfully'
                WHEN @Action = 'V' THEN 'Quotation Version Created successfully'
            END AS returnMessage,
            CAST(@OutQuotationID AS VARCHAR) AS ID;
    END
END

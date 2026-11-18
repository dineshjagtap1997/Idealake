
CREATE PROCEDURE [RateCards].[Copy_SpecialServiceRateCard]
    @RateCardID BIGINT,
    @CreatedBy UNIQUEIDENTIFIER = NULL,
    @SpecialServiceRateID BIGINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE 
        @CardNumber VARCHAR(25),
        @SpecialServiceRateDetailID BIGINT,
        @SpecialServiceRateCommissionID BIGINT;

    -- Master data variables
    DECLARE @ContractDate DATETIME, @CurrencyID VARCHAR(10), @Heading VARCHAR(100), @RateCardModeTypeID INT,
            @VendorID INT, @CityID VARCHAR(3), @StateID INT, @GstStatus VARCHAR(20),
            @SpecialServiceID INT, @InfoForOperation VARCHAR(MAX), @InfoForRemark VARCHAR(MAX), @InfoForAgent VARCHAR(MAX),
            @HrsPerDay INT, @KmPerDay INT, @HotelId BIGINT, @IsActive BIT;

    -- Step 1: Fetch Master Data
    SELECT
        @ContractDate = ContractDate,
        @CurrencyID = CurrencyID,
        @Heading = Heading,
        @RateCardModeTypeID = RateCardModeTypeID,
        @VendorID = VendorID,
        @CityID = CityID,
        @StateID = StateID,
        @GstStatus = GSTStatus,
        @SpecialServiceID = SpecialServiceID,
        @InfoForOperation = InfoForOperation,
        @InfoForRemark = InfoForRemark,
        @InfoForAgent = InfoForAgent,
        @HrsPerDay = HrsPerDay,
        @KmPerDay = KmPerDay,
        @HotelId = HotelID,
        @IsActive = IsActive
    FROM [RateCards].[SpecialServiceRateMaster]
    WHERE SpecialServiceRateID = @RateCardID;

    -- Step 2: Insert into SpecialServiceRateMaster
    EXEC [RateCards].[CreateOrUpdate_SpecialServiceRateCard]
        @Operation = 'INSERT',
        @ContractDate = @ContractDate,
        @CurrencyID = @CurrencyID,
        @Heading = @Heading,
        @RateCardModeTypeID = @RateCardModeTypeID,
        @VendorID = @VendorID,
        @CityID = @CityID,
        @StateID = @StateID,
        @GSTStatus = @GstStatus,
        @SpecialServiceID = @SpecialServiceID,
        @InfoForOperation = @InfoForOperation,
        @InfoForRemark = @InfoForRemark,
        @InfoForAgent = @InfoForAgent,
        @HrsPerDay = @HrsPerDay,
        @KmPerDay = @KmPerDay,
        @HotelId = @HotelId,
        @IsActive = @IsActive,
        @CreatedBy = @CreatedBy,
        @SpecialServiceRateID = @SpecialServiceRateID OUTPUT,
        @CardNumber = @CardNumber OUTPUT;

    -- Step 3: Copy Detail Records
    DECLARE detail_cursor CURSOR FOR
    SELECT SpecialServiceRateDetailID, TaxID, ValidFrom, ValidTo, NationalityID, MISSequence, IsActive, RatePreferenceID
    FROM [RateCards].[SpecialServiceRateDeatils]
    WHERE SpecialServiceRateID = @RateCardID;

    DECLARE @DetailID BIGINT, @TaxID BIT, @ValidFrom DATETIME, @ValidTo DATETIME, @NationalityID INT,
            @MISSequence VARCHAR(100), @DetailIsActive BIT, @RatePreferenceID INT;

    OPEN detail_cursor;
    FETCH NEXT FROM detail_cursor INTO @DetailID, @TaxID, @ValidFrom, @ValidTo, @NationalityID, @MISSequence, @DetailIsActive, @RatePreferenceID;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Insert detail record
        EXEC [RateCards].[CreateOrUpdate_SpecialServiceRateDetail]
            @Operation = 'INSERT',
            @TaxID = @TaxID,
            @ValidFrom = @ValidFrom,
            @ValidTo = @ValidTo,
            @NationalityID = @NationalityID,
            @MISSequence = @MISSequence,
            @IsActive = @DetailIsActive,
            @CreatedBy = @CreatedBy,
            @RatePreferenceID = @RatePreferenceID,
            @SpecialServiceRateID = @SpecialServiceRateID,
            @SpecialServiceRateDetailID = @SpecialServiceRateDetailID OUTPUT;

        -- Insert commission records
        DECLARE comm_cursor CURSOR FOR
        SELECT MinimumPax, MaximumPax, CommissionMasterID, TaxPercentage, TaxAmount, NetAmountIncludingTax, NetAmountExcludingTax, IsActive
        FROM [RateCards].[SpecialServiceRateCommissionDeatils]
        WHERE SpecialServiceRateDetailID = @DetailID;

        DECLARE @MinimumPax INT, @MaximumPax INT, @CommissionMasterID INT, @TaxPercentage DECIMAL(18,2),
                @TaxAmount DECIMAL(18,2), @NetAmountIncl DECIMAL(18,2), @NetAmountExcl DECIMAL(18,2), @CommIsActive BIT;

        OPEN comm_cursor;
        FETCH NEXT FROM comm_cursor INTO @MinimumPax, @MaximumPax, @CommissionMasterID, @TaxPercentage, @TaxAmount, @NetAmountIncl, @NetAmountExcl, @CommIsActive;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            EXEC [RateCards].[CreateOrUpdate_SpecialServiceRateCommissionDetail]
                @Operation = 'INSERT',
                @MinimumPax = @MinimumPax,
                @MaximumPax = @MaximumPax,
                @CommissionMasterID = @CommissionMasterID,
                @TaxPercentage = @TaxPercentage,
                @TaxAmount = @TaxAmount,
                @NetAmountIncludingTax = @NetAmountIncl,
                @NetAmountExcludingTax = @NetAmountExcl,
                @SpecialServiceRateDetailID = @SpecialServiceRateDetailID,
                @CreatedBy = @CreatedBy,
                @IsActive = @CommIsActive,
                @SpecialServiceRateCommissionID = @SpecialServiceRateCommissionID OUTPUT;

            FETCH NEXT FROM comm_cursor INTO @MinimumPax, @MaximumPax, @CommissionMasterID, @TaxPercentage, @TaxAmount, @NetAmountIncl, @NetAmountExcl, @CommIsActive;
        END

        CLOSE comm_cursor;
        DEALLOCATE comm_cursor;

        FETCH NEXT FROM detail_cursor INTO @DetailID, @TaxID, @ValidFrom, @ValidTo, @NationalityID, @MISSequence, @DetailIsActive, @RatePreferenceID;
    END

    CLOSE detail_cursor;
    DEALLOCATE detail_cursor;

    -- Step 4: Copy Rules
    DECLARE @RuleID INT, @MISSeqeunce VARCHAR(40), @ApplicableID INT, @RuleDescription VARCHAR(300), @RuleIsActive BIT, @RuleRecordID BIGINT;

    DECLARE rule_cursor CURSOR LOCAL FORWARD_ONLY READ_ONLY FOR
    SELECT RuleID, MISSeqeunce, ApplicableID, [Description], IsActive
    FROM RateCards.Rules
    WHERE RateCardID = @RateCardID AND RateCardTypeID = 4;

    OPEN rule_cursor;
    FETCH NEXT FROM rule_cursor INTO @RuleID, @MISSeqeunce, @ApplicableID, @RuleDescription, @RuleIsActive;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC [RateCards].[Usp_CreateOrUpdateRules]
            @Operation = 'INSERT',
            @ID = NULL,
            @RateCardTypeID = 4,
            @RateCardID = @SpecialServiceRateID,
            @RuleID = @RuleID,
            @MISSeqeunce = @MISSeqeunce,
            @ApplicableID = @ApplicableID,
            @Description = @RuleDescription,
            @IsActive = @RuleIsActive,
            @OperationBy = @CreatedBy,
            @GuideRateID = @RuleRecordID OUTPUT;

        FETCH NEXT FROM rule_cursor INTO @RuleID, @MISSeqeunce, @ApplicableID, @RuleDescription, @RuleIsActive;
    END

    CLOSE rule_cursor;
    DEALLOCATE rule_cursor;

    -- Step 5: Copy Documents 
    INSERT INTO LinkedDocuments (ParentID, ParentTypeID, DocumentID)
    SELECT @SpecialServiceRateID, ParentTypeID, DocumentID 
    FROM LinkedDocuments
    WHERE ParentTypeID = 5 AND ParentID = @RateCardID;

    SELECT '200' AS returnCode, 'RateCard recreated successfully.' AS returnMessage, @SpecialServiceRateID AS SpecialServiceRateID;
END

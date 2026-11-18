
CREATE PROCEDURE [RateCards].[Copy_TransportRateCard]
    @RateCardID BIGINT,
    @CreatedBy UNIQUEIDENTIFIER = NULL,
    @TransportRateID BIGINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE 
        @CardNumber VARCHAR(25),
        @TransportRateDetailID BIGINT,
        @TransportRateCommissionID BIGINT;

    -- Master data variables
    DECLARE @ContractDate DATETIME, @CurrencyID VARCHAR(10), @Heading VARCHAR(100), @RateCardModeTypeID INT,
            @TransportModeTypeID INT, @TransportServiceID INT, @HotelID INT, @HotelZone VARCHAR(25), 
            @VendorID INT, @CityID VARCHAR(3), @CityID2 VARCHAR(3), @InfoForOperation VARCHAR(MAX), 
            @InfoForRemark VARCHAR(MAX), @InfoForAgent VARCHAR(MAX), @IsActive BIT, @StateID INT, 
            @GstStatus VARCHAR(20);

    -- Step 1: Fetch Master Data
    SELECT
        @ContractDate = ContractDate,
        @CurrencyID = CurrencyID,
        @Heading = Heading,
        @RateCardModeTypeID = RateCardModeTypeID,
        @TransportModeTypeID = TransportModeTypeID,
        @TransportServiceID = TransportServceID,
        @HotelID = HotelID,
        @HotelZone = HotelZone,
        @VendorID = VendorID,
        @CityID = CityID,
        @CityID2 = CityID2,
        @InfoForOperation = InfoForOperation,
        @InfoForRemark = InfoForRemark,
        @InfoForAgent = InfoForAgent,
        @IsActive = IsActive,
        @StateID = StateID,
        @GstStatus = GstStatus
    FROM [RateCards].[TransportRateMaster]
    WHERE TransportRateID = @RateCardID;

    -- Step 2: Insert into TransportRateMaster
    EXEC [RateCards].[CreateOrUpdate_TransportRateCard]
        @Operation = 'INSERT',
        @ContractDate = @ContractDate,
        @CurrencyID = @CurrencyID,
        @Heading = @Heading,
        @TransportModeTypeID = @TransportModeTypeID,
        @TransportServiceID = @TransportServiceID,
        @RateCardModeTypeID = @RateCardModeTypeID,
        @HotelID = @HotelID,
        @HotelZone = @HotelZone,
        @VendorID = @VendorID,
        @CityID = @CityID,
        @CityID2 = @CityID2,
        @InfoForOperation = @InfoForOperation,
        @InfoForRemark = @InfoForRemark,
        @InfoForAgent = @InfoForAgent,
        @IsActive = @IsActive,
        @CreatedBy = @CreatedBy,
        @TransportRateID = @TransportRateID OUTPUT,
        @CardNumber = @CardNumber OUTPUT;

    -- Step 3: Copy Detail Records
    DECLARE detail_cursor CURSOR FOR
    SELECT TransportRateDetailID, TaxID, VehicleCategoryID, VehicleBaseID, ValidFrom, ValidTo, MISSequence, IsActive
    FROM [RateCards].[TransportRateDetails]
    WHERE TransportRateID = @RateCardID;

    DECLARE @DetailID BIGINT, @TaxID INT, @VehicleCategoryID INT, @VehicleBaseID INT, 
            @ValidFrom DATETIME, @ValidTo DATETIME, @MISSequence VARCHAR(50), @DetailIsActive BIT;

    OPEN detail_cursor;
    FETCH NEXT FROM detail_cursor INTO @DetailID, @TaxID, @VehicleCategoryID, @VehicleBaseID, @ValidFrom, @ValidTo, @MISSequence, @DetailIsActive;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Insert detail record
        EXEC [RateCards].[CreateOrUpdate_TransportRateDetail]
            @Operation = 'INSERT',
            @TaxID = @TaxID,
            @VehicleCategoryID = @VehicleCategoryID,
            @VehicleBaseID = @VehicleBaseID,
            @ValidFrom = @ValidFrom,
            @ValidTo = @ValidTo,
            @MISSequence = @MISSequence,
            @IsActive = @DetailIsActive,
            @CreatedBy = @CreatedBy,
            @TransportRateID = @TransportRateID,
            @TransportRateDetailID = @TransportRateDetailID OUTPUT;

        -- Insert commission records
        DECLARE comm_cursor CURSOR FOR
        SELECT CommissionMasterID, TaxPercentage, TaxAmount, NetAmountIncludingTax, NetAmountExcludingTax, IsAmtIncludedInBasic, IsActive
        FROM [RateCards].[TransportRateCommissionDetails]
        WHERE TransportRateDetailID = @DetailID;

        DECLARE @MasterCommissionID INT, @TaxPercentage DECIMAL(18,2), @TaxAmount DECIMAL(18,2),
                @NetAmountIncl DECIMAL(18,2), @NetAmountExcl DECIMAL(18,2), @IsAmtIncludedInTax BIT, @CommIsActive BIT;

        OPEN comm_cursor;
        FETCH NEXT FROM comm_cursor INTO @MasterCommissionID, @TaxPercentage, @TaxAmount, @NetAmountIncl, @NetAmountExcl, @IsAmtIncludedInTax, @CommIsActive;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            EXEC [RateCards].[CreateOrUpdate_TransportRateCommissionDetail]
                @Operation = 'INSERT',
                @MasterCommissionID = @MasterCommissionID,
                @TaxPercentage = @TaxPercentage,
                @TaxAmount = @TaxAmount,
                @NetAmountIncludingTax = @NetAmountIncl,
                @NetAmountExcludingTax = @NetAmountExcl,
                @TransportRateDetailID = @TransportRateDetailID,
                @IsAmtIncludedInTax = @IsAmtIncludedInTax,
                @CreatedBy = @CreatedBy,
                @IsActive = @CommIsActive,
                @TransportRateCommissionID = @TransportRateCommissionID OUTPUT;

            FETCH NEXT FROM comm_cursor INTO @MasterCommissionID, @TaxPercentage, @TaxAmount, @NetAmountIncl, @NetAmountExcl, @IsAmtIncludedInTax, @CommIsActive;
        END

        CLOSE comm_cursor;
        DEALLOCATE comm_cursor;

        FETCH NEXT FROM detail_cursor INTO @DetailID, @TaxID, @VehicleCategoryID, @VehicleBaseID, @ValidFrom, @ValidTo, @MISSequence, @DetailIsActive;
    END

    CLOSE detail_cursor;
    DEALLOCATE detail_cursor;

    -- Step 4: Copy Rules
    DECLARE @RuleID INT, @MISSequenceRule VARCHAR(40), @ApplicableID INT, @RuleDescription VARCHAR(300), @RuleIsActive BIT, @RuleRecordID BIGINT;

    DECLARE rule_cursor CURSOR LOCAL FORWARD_ONLY READ_ONLY FOR
    SELECT RuleID, MISSeqeunce, ApplicableID, [Description], IsActive
    FROM RateCards.Rules
    WHERE RateCardID = @RateCardID AND RateCardTypeID = 5;

    OPEN rule_cursor;
    FETCH NEXT FROM rule_cursor INTO @RuleID, @MISSequenceRule, @ApplicableID, @RuleDescription, @RuleIsActive;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC [RateCards].[Usp_CreateOrUpdateRules]
            @Operation = 'INSERT',
            @ID = NULL,
            @RateCardTypeID = 5,
            @RateCardID = @TransportRateID,
            @RuleID = @RuleID,
            @MISSequence = @MISSequenceRule,
            @ApplicableID = @ApplicableID,
            @Description = @RuleDescription,
            @IsActive = @RuleIsActive,
            @OperationBy = @CreatedBy,
            @GuideRateID = @RuleRecordID OUTPUT;

        FETCH NEXT FROM rule_cursor INTO @RuleID, @MISSequenceRule, @ApplicableID, @RuleDescription, @RuleIsActive;
    END

    CLOSE rule_cursor;
    DEALLOCATE rule_cursor;

    -- Step 5: Copy Documents
    INSERT INTO LinkedDocuments (ParentID, ParentTypeID, DocumentID)
    SELECT @TransportRateID, ParentTypeID, DocumentID 
    FROM LinkedDocuments
    WHERE ParentTypeID = 3 AND ParentID = @RateCardID;

    SELECT '200' AS returnCode, 'RateCard recreated successfully.' AS returnMessage, @TransportRateID AS TransportRateID;
END

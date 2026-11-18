CREATE PROCEDURE [RateCards].[Copy_GuideRateCard]
    @RateCardID BIGINT,
    @CreatedBy UNIQUEIDENTIFIER = NULL,
    @GuideRateID BIGINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE 
        @CardNumber VARCHAR(25),
        @GuideRateDetailID BIGINT,
        @GuideRateCommissionID BIGINT;

    -- Master data variables
    DECLARE @ContractDate DATETIME, @CurrencyID VARCHAR(5), @Heading VARCHAR(100), @RateCardModeTypeID INT,
            @LanguageID CHAR(3), @VendorID INT, @CityID VARCHAR(10), @StateID VARCHAR(10), @GstStatus VARCHAR(10),
            @GuideServiceID INT, @InfoForOperation VARCHAR(MAX), @InfoForRemark VARCHAR(MAX), @InfoForAgent VARCHAR(MAX),
            @Notes VARCHAR(MAX), @IsActive BIT;

    -- Step 1: Fetch Master Data
    SELECT
        @ContractDate = ContractDate,
        @CurrencyID = CurrencyID,
        @Heading = Heading,
        @RateCardModeTypeID = RateCardModeTypeID,
        @LanguageID = LanguageID,
        @VendorID = VendorID,
        @CityID = CityID,
        @StateID = StateID,
        @GstStatus = GstStatus,
        @GuideServiceID = GuideServiceID,
        @InfoForOperation = InfoForOperation,
        @InfoForRemark = InfoForRemark,
        @InfoForAgent = InfoForAgent,
        @Notes = Notes,
        @IsActive = IsActive
    FROM [RateCards].[GuideRateMaster]
    WHERE GuideRateID = @RateCardID;

    -- Step 2: Insert into GuideRateMaster
    EXEC [RateCards].[CreateOrUpdate_GuideRateCard]
        @Operation = 'INSERT',
        @ContractDate = @ContractDate,
        @CurrencyID = @CurrencyID,
        @Heading = @Heading,
        @RateCardModeTypeID = @RateCardModeTypeID,
        @LanguageID = @LanguageID,
        @VendorID = @VendorID,
        @CityID = @CityID,
        @StateID = @StateID,
        @GstStatus = @GstStatus,
        @GuideServiceID = @GuideServiceID,
        @InfoForOperation = @InfoForOperation,
        @InfoForRemark = @InfoForRemark,
        @InfoForAgent = @InfoForAgent,
        @Notes = @Notes,
        @IsActive = @IsActive,
        @CreatedBy = @CreatedBy,
        @GuideRateID = @GuideRateID OUTPUT,
        @CardNumber = @CardNumber OUTPUT;

    -- Create temp table
    IF OBJECT_ID('tempdb..#TempCommission') IS NOT NULL DROP TABLE #TempCommission;
    CREATE TABLE #TempCommission (
        TaxPercentage DECIMAL(18,2),
        TaxAmount DECIMAL(18,2),
        NetAmountIncludingTax DECIMAL(18,2),
        NetAmountExcludingTax DECIMAL(18,2),
        PaxMinimum INT,
        PaxMaximum INT,
        IsActive BIT
    );

    -- Step 3: Copy Detail Records
    IF CURSOR_STATUS('global', 'detail_cursor') >= -1
    BEGIN
        CLOSE detail_cursor;
        DEALLOCATE detail_cursor;
    END

    DECLARE detail_cursor CURSOR FOR
    SELECT GuideRateDetailID, TaxID, ValidFrom, ValidTo, MISSequence, IsActive
    FROM [RateCards].[GuideRateDetails]
    WHERE GuideRateID = @RateCardID;

    DECLARE @DetailID BIGINT, @TaxID INT, @ValidFrom DATETIME, @ValidTo DATETIME, @MISSequence VARCHAR(30), @DetailIsActive BIT;

    OPEN detail_cursor;
    FETCH NEXT FROM detail_cursor INTO @DetailID, @TaxID, @ValidFrom, @ValidTo, @MISSequence, @DetailIsActive;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Insert detail record
        EXEC [RateCards].[CreateOrUpdate_GuideRateDetail]
            @Operation = 'INSERT',
            @GuideRateID = @GuideRateID,
            @TaxID = @TaxID,
            @ValidFrom = @ValidFrom,
            @ValidTo = @ValidTo,
            @MISSequence = @MISSequence,
            @IsActive = @DetailIsActive,
            @CreatedBy = @CreatedBy,
            @GuideRateDetailID = @GuideRateDetailID OUTPUT;

        -- Insert commission records into temp table
        DELETE FROM #TempCommission;
        INSERT INTO #TempCommission (TaxPercentage, TaxAmount, NetAmountIncludingTax, NetAmountExcludingTax, PaxMinimum, PaxMaximum, IsActive)
        SELECT TaxPercentage, TaxAmount, NetAmountIncludingTax, NetAmountExcludingTax, PaxMinimum, PaxMaximum, IsActive
        FROM [RateCards].[GuideRateCommissionDetails]
        WHERE GuideRateDetailID = @DetailID;

        -- Cursor safety check
        IF CURSOR_STATUS('global', 'comm_cursor') >= -1
        BEGIN
            CLOSE comm_cursor;
            DEALLOCATE comm_cursor;
        END

        DECLARE comm_cursor CURSOR FOR
        SELECT TaxPercentage, TaxAmount, NetAmountIncludingTax, NetAmountExcludingTax, PaxMinimum, PaxMaximum, IsActive
        FROM #TempCommission;

        DECLARE @TaxPercentage DECIMAL(18,2), @TaxAmount DECIMAL(18,2), @NetAmountIncl DECIMAL(18,2),
                @NetAmountExcl DECIMAL(18,2), @PaxMin INT, @PaxMax INT, @CommIsActive BIT;

        OPEN comm_cursor;
        FETCH NEXT FROM comm_cursor INTO @TaxPercentage, @TaxAmount, @NetAmountIncl, @NetAmountExcl, @PaxMin, @PaxMax, @CommIsActive;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            EXEC [RateCards].[CreateOrUpdate_GuideRateCommissionDetail]
                @Operation = 'INSERT',
                @TaxPercentage = @TaxPercentage,
                @TaxAmount = @TaxAmount,
                @NetAmountIncludingTax = @NetAmountIncl,
                @NetAmountExcludingTax = @NetAmountExcl,
                @PaxMinimum = @PaxMin,
                @PaxMaximum = @PaxMax,
                @GuideRateDetailID = @GuideRateDetailID,
                @IsActive = @CommIsActive,
                @CreatedBy = @CreatedBy,
                @GuideRateCommissionID = @GuideRateCommissionID OUTPUT;

            FETCH NEXT FROM comm_cursor INTO @TaxPercentage, @TaxAmount, @NetAmountIncl, @NetAmountExcl, @PaxMin, @PaxMax, @CommIsActive;
        END

        CLOSE comm_cursor;
        DEALLOCATE comm_cursor;

        FETCH NEXT FROM detail_cursor INTO @DetailID, @TaxID, @ValidFrom, @ValidTo, @MISSequence, @DetailIsActive;
    END

    CLOSE detail_cursor;
    DEALLOCATE detail_cursor;

    DROP TABLE #TempCommission;

	-- Step 4: Copy Rules
	IF CURSOR_STATUS('global', 'rule_cursor') >= -1
    BEGIN
        CLOSE rule_cursor;
        DEALLOCATE rule_cursor;
    END
    DECLARE @RuleID INT, @MISSeqeunce VARCHAR(40), @ApplicableID INT, @RuleDescription VARCHAR(300), @RuleIsActive BIT, @RuleRecordID BIGINT;

    DECLARE rule_cursor CURSOR LOCAL FORWARD_ONLY READ_ONLY FOR
    SELECT RuleID, MISSeqeunce, ApplicableID, [Description], IsActive
    FROM RateCards.Rules
    WHERE RateCardID = @RateCardID AND RateCardTypeID = 2;

    OPEN rule_cursor;
    FETCH NEXT FROM rule_cursor INTO @RuleID, @MISSeqeunce, @ApplicableID, @RuleDescription, @RuleIsActive;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC [RateCards].[Usp_CreateOrUpdateRules]
            @Operation = 'INSERT',
            @ID = NULL,
            @RateCardTypeID = 2,
            @RateCardID = @GuideRateID,
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

	-- Copy Documents 
	INSERT INTO LinkedDocuments (ParentID, ParentTypeID, DocumentID)
	SELECT @GuideRateID, ParentTypeID, DocumentID FROM LinkedDocuments
	WHERE ParentTypeID = 2 AND ParentID = @RateCardID;

    SELECT '200' AS returnCode, 'RateCard recreated successfully.' AS returnMessage, @GuideRateID AS GuideRateID;
END

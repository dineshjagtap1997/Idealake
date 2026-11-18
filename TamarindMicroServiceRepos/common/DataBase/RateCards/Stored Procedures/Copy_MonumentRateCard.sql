
CREATE PROCEDURE [RateCards].[Copy_MonumentRateCard]
    @RateCardID BIGINT,
    @CreatedBy UNIQUEIDENTIFIER = NULL,
    @MonumentRateID BIGINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE 
        @CardNumber VARCHAR(25),
        @MonumentRateDetailID BIGINT,
        @MonumentRateCommissionID BIGINT;

    -- Master data variables
    DECLARE @ContractDate DATETIME, @CurrencyID VARCHAR(10), @Heading VARCHAR(100), @RateCardModeTypeID INT,
            @VendorID INT, @CityID VARCHAR(3), @StateID INT, @GstStatus VARCHAR(20),
            @MonumentServiceID INT, @InfoForOperation VARCHAR(MAX), @InfoForRemark VARCHAR(MAX), @InfoForAgent VARCHAR(MAX),
            @IsActive BIT;

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
        @MonumentServiceID = MonumentServiceID,
        @InfoForOperation = InfoForOperation,
        @InfoForRemark = InfoForRemark,
        @InfoForAgent = InfoForAgent,
        @IsActive = IsActive
    FROM [RateCards].[MonumentRateMaster]
    WHERE MonumentRateID = @RateCardID;

    -- Step 2: Insert into MonumentRateMaster
    EXEC [RateCards].[CreateOrUpdate_MonumentRateCard]
        @Operation = 'INSERT',
        @ContractDate = @ContractDate,
        @CurrencyID = @CurrencyID,
        @Heading = @Heading,
        @RateCardModeTypeID = @RateCardModeTypeID,
        @VendorID = @VendorID,
        @CityID = @CityID,
        @StateID = @StateID,
        @GSTStatus = @GstStatus,
        @MonumentServiceID = @MonumentServiceID,
        @InfoForOperation = @InfoForOperation,
        @InfoForRemark = @InfoForRemark,
        @InfoForAgent = @InfoForAgent,
        @IsActive = @IsActive,
        @CreatedBy = @CreatedBy,
        @MonumentRateID = @MonumentRateID OUTPUT,
        @CardNumber = @CardNumber OUTPUT;

    -- Create temp table
    IF OBJECT_ID('tempdb..#TempCommission') IS NOT NULL DROP TABLE #TempCommission;
    CREATE TABLE #TempCommission (
        TaxPercentage DECIMAL(18,2),
        TaxAmount DECIMAL(18,2),
        NetAmountIncludingTax DECIMAL(18,2),
        NetAmountExcludingTax DECIMAL(18,2),
        MasterCommissionID INT,
        IsActive BIT
    );

    -- Step 3: Copy Detail Records
    DECLARE detail_cursor CURSOR FOR
    SELECT MonumentDetailID, TaxID, ValidFrom, ValidTo, NationalityID, MISSequence, IsActive
    FROM [RateCards].[MonumentRateDetails]
    WHERE MonumentRateID = @RateCardID;

    DECLARE @DetailID BIGINT, @TaxID INT, @ValidFrom DATETIME, @ValidTo DATETIME, @NationalityID INT,
            @MISSequence VARCHAR(100), @DetailIsActive BIT;

    OPEN detail_cursor;
    FETCH NEXT FROM detail_cursor INTO @DetailID, @TaxID, @ValidFrom, @ValidTo, @NationalityID, @MISSequence, @DetailIsActive;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Insert detail record
        EXEC [RateCards].[CreateOrUpdate_MonumentRateDetail]
            @Operation = 'INSERT',
            @TaxID = @TaxID,
            @ValidFrom = @ValidFrom,
            @ValidTo = @ValidTo,
            @NationalityID = @NationalityID,
            @MISSequence = @MISSequence,
            @IsActive = @DetailIsActive,
            @CreatedBy = @CreatedBy,
            @MonumentRateID = @MonumentRateID,
            @MonumentRateDetailID = @MonumentRateDetailID OUTPUT;

        -- Insert commission records into temp table
        DELETE FROM #TempCommission;
        INSERT INTO #TempCommission (TaxPercentage, TaxAmount, NetAmountIncludingTax, NetAmountExcludingTax, MasterCommissionID, IsActive)
        SELECT TaxPercentage, TaxAmount, NetAmountIncludingTax, NetAmountExcludingTax, CommissionMasterID, IsActive
        FROM [RateCards].[MonumentRateCommissionDetails]
        WHERE MonumentDetailID = @DetailID;

        DECLARE comm_cursor CURSOR FOR
        SELECT TaxPercentage, TaxAmount, NetAmountIncludingTax, NetAmountExcludingTax, MasterCommissionID, IsActive
        FROM #TempCommission;

        DECLARE @TaxPercentage DECIMAL(18,2), @TaxAmount DECIMAL(18,2), @NetAmountIncl DECIMAL(18,2),
                @NetAmountExcl DECIMAL(18,2), @CommMasterID INT, @CommIsActive BIT;

        OPEN comm_cursor;
        FETCH NEXT FROM comm_cursor INTO @TaxPercentage, @TaxAmount, @NetAmountIncl, @NetAmountExcl, @CommMasterID, @CommIsActive;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            EXEC [RateCards].[CreateOrUpdate_MonumentRateCommissionDetails]
                @Operation = 'INSERT',
                @TaxPercentage = @TaxPercentage,
                @TaxAmount = @TaxAmount,
                @NetAmountIncludingTax = @NetAmountIncl,
                @NetAmountExcludingTax = @NetAmountExcl,
                @MasterCommissionID = @CommMasterID,
                @MonumentDetailID = @MonumentRateDetailID,
                @IsActive = @CommIsActive,
                @CreatedBy = @CreatedBy,
                @MonumentRateCommissionID = @MonumentRateCommissionID OUTPUT;

            FETCH NEXT FROM comm_cursor INTO @TaxPercentage, @TaxAmount, @NetAmountIncl, @NetAmountExcl, @CommMasterID, @CommIsActive;
        END

        CLOSE comm_cursor;
        DEALLOCATE comm_cursor;

        FETCH NEXT FROM detail_cursor INTO @DetailID, @TaxID, @ValidFrom, @ValidTo, @NationalityID, @MISSequence, @DetailIsActive;
    END

    CLOSE detail_cursor;
    DEALLOCATE detail_cursor;

    DROP TABLE #TempCommission;

    -- Step 4: Copy Rules
    DECLARE @RuleID INT, @MISSeqeunce VARCHAR(40), @ApplicableID INT, @RuleDescription VARCHAR(300), @RuleIsActive BIT, @RuleRecordID BIGINT;

    DECLARE rule_cursor CURSOR LOCAL FORWARD_ONLY READ_ONLY FOR
    SELECT RuleID, MISSeqeunce, ApplicableID, [Description], IsActive
    FROM RateCards.Rules
    WHERE RateCardID = @RateCardID AND RateCardTypeID = 3;

    OPEN rule_cursor;
    FETCH NEXT FROM rule_cursor INTO @RuleID, @MISSeqeunce, @ApplicableID, @RuleDescription, @RuleIsActive;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC [RateCards].[Usp_CreateOrUpdateRules]
            @Operation = 'INSERT',
            @ID = NULL,
            @RateCardTypeID = 3,
            @RateCardID = @MonumentRateID,
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
    SELECT @MonumentRateID, ParentTypeID, DocumentID 
    FROM LinkedDocuments
    WHERE ParentTypeID = 4 AND ParentID = @RateCardID;

    SELECT '200' AS returnCode, 'RateCard recreated successfully.' AS returnMessage, @MonumentRateID AS MonumentRateID;
END

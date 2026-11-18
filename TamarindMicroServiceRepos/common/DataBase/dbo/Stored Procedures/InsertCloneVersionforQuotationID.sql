
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [InsertCloneVersionforQuotationID]      --exec  [Quotation].[InsertCloneVersionforQuotationID]   200 , 'C'
(
@ID INT,
@Action varchar(1)
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




IF @Action = 'C' AND EXISTS (SELECT 1 FROM [Quotation].[QuotationMaster] WHERE QuotationID = @ID)
BEGIN


SET @Prefix = 'Q'
 SELECT @MaxNumber = ISNULL(MAX(CAST(RIGHT(QuotationNo, 6) AS INT)), 0)
    FROM [Quotation].[QuotationMaster]
    WHERE QuotationNo LIKE @Prefix + '%'
    AND ISNUMERIC(RIGHT(QuotationNo, 6)) = 1;

    SET @NewQuotationNo = 'Q' + RIGHT('000000' + CAST(@MaxNumber + 1 AS VARCHAR(6)), 6);

	select @NewQuotationNo
    print @NewQuotationNo 


    INSERT INTO [Quotation].[QuotationMaster] (
        QuotationNo, 
        EnquiryID, 
        Status, 
        CreatedBy, 
        CreatedDate, 
        RateCardMode, 
        CompanyID,
		AgentName,
		TaxonSale,
		YearID,
		Currency,
		ParentID
    )
   SELECT 
        @NewQuotationNo,
        EnquiryID,
        1,
        CreatedBy,
        GETDATE(),
        RateCardMode,
        CompanyID,
		AgentName,
		TaxonSale,
		YearID
		,Currency 
		,@ID FROM [Quotation].[QuotationMaster] WHERE QuotationID = @ID
    

    SET @OutQuotationID = SCOPE_IDENTITY();
    SET @QuotationNo = @NewQuotationNo;   


		
		DECLARE @OldID BIGINT, @NewID BIGINT;

		-- Cursor to loop through each matching master row
		DECLARE cur CURSOR FOR
		SELECT ID
		FROM [Quotation].[OthersRateCardMaster]
		WHERE QuotationID = @ID;

		OPEN cur;
		FETCH NEXT FROM cur INTO @OldID;

		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- Insert the master row and get the new ID
			INSERT INTO [Quotation].[OthersRateCardMaster] (
				RateId, ServiceID, RateType, CardNumber, Heading, ContractDate, RateCardModeTypeID,
				CurrencyID, VendorID, CityID, StateID, GstStatus, InfoForOperation, InfoForAgent,
				InfoForRemark, IsActive, CreatedOn, UpdatedOn, CreatedBy, UpdatedBy, LanguageID, Notes,
				HotelID, HrsPerDay, KmPerDay, TransportModeTypeID, HotelZone, CityID2,
				ReferenceRateDetailID, TaxID, ValidFrom, ValidTo, MISSequence, NationalityID,
				RatePreferenceID, VehicleCategoryID, QuotationID, Disclaimer, ReasonID
			)
			SELECT 
				RateId, ServiceID, RateType, CardNumber, Heading, ContractDate, RateCardModeTypeID,
				CurrencyID, VendorID, CityID, StateID, GstStatus, InfoForOperation, InfoForAgent,
				InfoForRemark, IsActive, GETDATE(), GETDATE(), CreatedBy, UpdatedBy, LanguageID, Notes,
				HotelID, HrsPerDay, KmPerDay, TransportModeTypeID, HotelZone, CityID2,
				ReferenceRateDetailID, TaxID, ValidFrom, ValidTo, MISSequence, NationalityID,
				RatePreferenceID, VehicleCategoryID, @OutQuotationID, Disclaimer, ReasonID
			FROM [Quotation].[OthersRateCardMaster]
			WHERE ID = @OldID;

			-- Get new inserted ID
			SET @NewID = SCOPE_IDENTITY();

			-- Insert corresponding commission rows with updated foreign key
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

			-- Fetch next row
			FETCH NEXT FROM cur INTO @OldID;
		END;

		CLOSE cur;
		DEALLOCATE cur;





	
    SELECT 
        '200' AS returnCode,
        'Quotation created successfully' AS returnMessage,
        CAST(@OutQuotationID AS VARCHAR) AS ID;


END




IF @Action = 'V' AND EXISTS (SELECT 1 FROM [Quotation].[QuotationMaster] WHERE QuotationID = @ID)
BEGIN

	 
	
 
    -- Get the base QuotationNo from the record you are copying
    SELECT @BaseQuotationNo = QuotationNo
    FROM [Quotation].[QuotationMaster]
    WHERE QuotationID = @ID;
 
    -- Remove version suffix if it exists
    IF CHARINDEX('.', @BaseQuotationNo) > 0
        SET @BaseQuotationNo = LEFT(@BaseQuotationNo, CHARINDEX('.', @BaseQuotationNo) - 1);
 
    -- Get the next version number
    SELECT @NextVersion = 
        ISNULL(MAX(CAST(SUBSTRING(QuotationNo, LEN(@BaseQuotationNo) + 2, LEN(QuotationNo)) AS INT)), 0) + 1
    FROM [Quotation].[QuotationMaster]
    WHERE QuotationNo LIKE @BaseQuotationNo + '.%';
 
    -- Generate the new QuotationNo with version
    SET @FinalQuotationNo = @BaseQuotationNo + '.' + CAST(@NextVersion AS VARCHAR);
 
    -- Insert the copied record with the new versioned QuotationNo
    INSERT INTO [Quotation].[QuotationMaster] (
        QuotationNo,
        EnquiryID,
        Status,
        CreatedBy,
        CreatedDate,
        RateCardMode,
        ParentID,
        CompanyID
    )
    SELECT
        @FinalQuotationNo,
        EnquiryID,
        CASE 
            WHEN EnquiryID IS NOT NULL AND EnquiryID <> 0 THEN 1
            ELSE 0
        END,
        @CreatedBy,
        GETDATE(),
        RateCardMode,
        QuotationID, -- Original ID becomes ParentID
        CompanyID
    FROM [Quotation].[QuotationMaster]
    WHERE QuotationID = @ID;
 
    -- Output the new record info
    SET @OutQuotationID = SCOPE_IDENTITY();
    SET @QuotationNo = @FinalQuotationNo;
 
    SELECT 
        '200' AS returnCode,
        'Quotation copied and created successfully' AS returnMessage,
        CAST(@OutQuotationID AS VARCHAR) AS ID;
END;



END

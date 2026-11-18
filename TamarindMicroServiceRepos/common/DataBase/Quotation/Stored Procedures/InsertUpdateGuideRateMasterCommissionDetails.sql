
CREATE PROCEDURE [Quotation].[InsertUpdateGuideRateMasterCommissionDetails] (
	@Action VARCHAR(1)
	,@GuideRateID BIGINT
	,@QuotationID BIGINT
	,@Markup_IsRate BIT = NULL
	,@NetRate DECIMAL(18, 2) = NULL
	,@SellingRates DECIMAL(18, 2) = NULL
	,@GrossRate DECIMAL(18, 2) = NULL
	,@GrossRateAdult DECIMAL(18, 2) = NULL
	,@GrossRateChild DECIMAL(18, 2) = NULL
	,@MarkupRate DECIMAL(18, 2) = NULL
	,@Disclaimer NVARCHAR(500) = NULL
	,@ReasonID INT = NULL
	,@GuideRateDetailID BIGINT
	,@FromDate DATETIME = NULL
	,@ToDate DATETIME = NULL
	,@QGID BIGINT = NULL
	,@OthersRateCardCommissionID BIGINT = NULL
	,@IsSummary BIT = 0
	,@OperationBy UNIQUEIDENTIFIER = NULL
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @OthersRateRefrenceID BIGINT;
	DECLARE @IsCustom BIT = CASE 
			WHEN @GuideRateDetailID = 0
				THEN 1
			ELSE 0
			END;

	IF @Action = 'I'
	BEGIN
		INSERT INTO [Quotation].OthersRateCardMaster (
			RateId
			,ServiceID
			,RateType
			,CardNumber
			,Heading
			,ContractDate
			,RateCardModeTypeID
			,CurrencyID
			,VendorID
			,CityID
			,StateID
			,GstStatus
			,InfoForOperation
			,InfoForAgent
			,InfoForRemark
			,IsActive
			,LanguageID
			----,Notes
			,ReferenceRateDetailID
			,ValidFrom
			,ValidTo
			,MISSequence
			,CreatedOn
			,QuotationID
			,Disclaimer
			,ReasonID
			,FromDate
			,ToDate
			,IsCustom
			,IsSummary
			,CreatedBy
			)
		SELECT DISTINCT grm.GuideRateID
			,grm.GuideServiceID
			,1
			,grm.CardNumber
			,grm.Heading
			,grm.ContractDate
			,RateCardModeTypeID
			,grm.CurrencyID
			,grm.VendorID
			,grm.CityID
			,grm.StateID
			,grm.GstStatus
			,grm.InfoForOperation
			,grm.InfoForAgent
			,grm.InfoForRemark
			,grm.IsActive
			,grm.LanguageID
			----,grm.Notes
			,grd.GuideRateDetailID
			,grd.ValidFrom
			,grd.ValidTo
			,grd.MISSequence
			,GETDATE()
			,@QuotationID
			,@Disclaimer
			,@ReasonID
			,@FromDate
			,@ToDate
			,@IsCustom
			,@IsSummary
			,@OperationBy
		FROM [RateCards].[GuideRateDetails] grd
		INNER JOIN [RateCards].[GuideRateMaster] GRM ON GRM.GuideRateID = grd.GuideRateID
		LEFT JOIN [RateCards].[GuideRateCommissionDetails] grc ON grd.GuideRateDetailID = grc.GuideRateDetailID
		WHERE @IsCustom = 0
			AND grd.GuideRateID = @GuideRateID
			AND grd.GuideRateDetailID = @GuideRateDetailID
		
		UNION ALL
		
		SELECT DISTINCT CHRM.HotelRateID
			,CHRM.ServiceID
			,1
			,NULL
			,NULL
			,NULL
			,0
			,CHRM.CurrencyID
			,CHRM.VendorID
			,CHRM.CityID
			,0
			,NULL
			,''
			,''
			,''
			,CHRM.IsActive
			,CHRM.LanguageID
			----,''
			,0
			,NULL
			,NULL
			,0
			,GETDATE()
			,@QuotationID
			,@Disclaimer
			,@ReasonID
			,@FromDate
			,@ToDate
			,@IsCustom
			,@IsSummary
			,@OperationBy
		FROM CustomRateCards.HotelRateMaster CHRM
		WHERE @IsCustom = 1
			AND CHRM.HotelRateID = @GuideRateID

		SET @OthersRateRefrenceID = SCOPE_IDENTITY();

		INSERT INTO [Quotation].[OthersRateCardCommission] (
			CommissionRefrenceID
			,RateID
			,CommissionMasterID
			,MinimumPax
			,MaximumPax
			,IsAmtIncludedInBasic
			,TaxPercentage
			,TaxAmount
			,NetAmountExcludingTax
			,NetAmountIncludingTax
			,Markup_IsRate
			,NetRate
			,SellingRates
			,GrossRate
			,MarkupRate
			,IsActive
			,OthersRateRefrenceID
			,CreatedOn
			,CreatedBy
			)
		SELECT DISTINCT GRM.GuideRateID
			,grd.GuideRateDetailID
			,grc.GuideRateCommissionID
			,grc.PaxMinimum
			,grc.PaxMaximum
			,NULL
			,grc.TaxPercentage
			,grc.TaxAmount
			,grc.NetAmountExcludingTax
			,grc.NetAmountIncludingTax
			,@Markup_IsRate
			,@NetRate
			,@SellingRates
			,@GrossRate
			,@MarkupRate
			,GRM.IsActive
			,@OthersRateRefrenceID
			,GETDATE()
			,@OperationBy
		FROM [RateCards].[GuideRateDetails] grd
		INNER JOIN [RateCards].[GuideRateMaster] GRM ON GRM.GuideRateID = grd.GuideRateID
		LEFT JOIN [RateCards].[GuideRateCommissionDetails] grc ON grd.GuideRateDetailID = grc.GuideRateDetailID
		WHERE @IsCustom = 0
			AND grd.GuideRateID = @GuideRateID
			AND grd.GuideRateDetailID = @GuideRateDetailID
		
		UNION ALL
		
		SELECT DISTINCT CHRM.HotelRateID
			,0
			,RC.RateCommisionID
			,RC.MinimumPax
			,RC.MaximumPax
			,NULL
			,RC.TaxPercentage
			,RC.TaxAmount
			,RC.NetAmountExcludingTax
			,RC.NetAmountIncludingTax
			,@Markup_IsRate
			,@NetRate
			,@SellingRates
			,@GrossRate
			,@MarkupRate
			,CHRM.IsActive
			,@OthersRateRefrenceID
			,GETDATE()
			,@OperationBy
		FROM CustomRateCards.HotelRateMaster CHRM
		LEFT JOIN [CustomRateCards].[HotelRateCommisionDetails] RC ON CHRM.HotelRateID = RC.HotelRateID
		WHERE @IsCustom = 1
			AND CHRM.HotelRateID = @GuideRateID;

		SELECT '200' AS returnCode
			,'Record inserted successfully' AS returnMessage
			,@OthersRateRefrenceID AS ID;
	END
	ELSE IF @Action = 'U'
	BEGIN
		UPDATE [Quotation].OthersRateCardMaster
		SET ReasonID = @ReasonID
			,Disclaimer = @Disclaimer
			,IsSummary = @IsSummary
			,UpdatedBy = @OperationBy,
			UpdatedOn	 = GETDATE()
		WHERE ID = @QGID;

		UPDATE [Quotation].[OthersRateCardCommission]
		SET Markup_IsRate = @Markup_IsRate
			,NetRate = @NetRate
			,SellingRates = @SellingRates
			,IsGrossRateModified = (
				CASE 
					WHEN @GrossRate <> isnull(GrossRate, 0)
						THEN 1
					ELSE 0
					END
				)
			,ModifiedGrossRate = (
				CASE 
					WHEN @GrossRate <> isnull(GrossRate, 0)
						THEN @GrossRate
					ELSE ModifiedGrossRate
					END
				)
			,MarkupRate = @MarkupRate
			,UpdatedOn = GETDATE()
			,UpdatedBy =@OperationBy
		WHERE ID = @OthersRateCardCommissionID

		SELECT '200' AS returnCode
			,'Record updated successfully' AS returnMessage;
	END
END
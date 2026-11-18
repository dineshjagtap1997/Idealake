
CREATE PROCEDURE [Quotation].[InsertUpdateMonumentRateMasterCommissionDetails] (
	@Action VARCHAR(1)
	,@RateID BIGINT
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
	,@MonumentDetailID BIGINT
	,@CommissionList [dbo].[CommissionTableType] READONLY
	,@FromDate DATETIME = NULL
	,@ToDate DATETIME = NULL
	,@QMID BIGINT = NULL
	,@OthersRateCardCommissionID BIGINT = NULL
	,@IsSummary BIT = 0
	,@OperationBy UNIQUEIDENTIFIER = NULL
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @OthersRateRefrenceID BIGINT;
	DECLARE @IsCustom BIT = CASE 
			WHEN @MonumentDetailID = 0
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
			,Notes
			,ReferenceRateDetailID
			,ValidFrom
			,ValidTo
			,MISSequence
			,QuotationID
			,Disclaimer
			,ReasonID
			,NationalityID
			,FromDate
			,ToDate
			,IsCustom
			,IsSummary
			,CreatedBy
			,CreatedOn
			)
		SELECT DISTINCT grd.MonumentRateID
			,grm.MonumentServiceID
			,2
			,grm.CardNumber
			,grm.Heading
			,grm.ContractDate
			,grm.RateCardModeTypeID
			,grm.CurrencyID
			,grm.VendorID
			,grm.CityID
			,grm.StateID
			,grm.GstStatus
			,grm.InfoForOperation
			,grm.InfoForAgent
			,grm.InfoForRemark
			,grm.IsActive
			,''
			,''
			,grd.MonumentDetailID
			,grd.ValidFrom
			,grd.ValidTo
			,grd.MISSequence
			,@QuotationID
			,@Disclaimer
			,@ReasonID
			,grd.NationalityID
			,@FromDate
			,@ToDate
			,@IsCustom
			,@IsSummary
			,@OperationBy
			,GETDATE()

		FROM [RateCards].[MonumentRateDetails] grd
		INNER JOIN [RateCards].[MonumentRateMaster] grm ON grm.MonumentRateID = grd.MonumentRateID
		WHERE @IsCustom = 0
			AND grm.MonumentRateID = @RateID
			AND grd.MonumentDetailID = @MonumentDetailID
		
		UNION ALL
		
		SELECT DISTINCT CHRM.HotelRateID
			,CHRM.ServiceID
			,2
			,''
			,''
			,NULL
			,0
			,CHRM.CurrencyID
			,CHRM.VendorID
			,CHRM.CityID
			,0
			,''
			,''
			,''
			,''
			,CHRM.IsActive
			,''
			,''
			,0
			,NULL
			,NULL
			,0
			,@QuotationID
			,@Disclaimer
			,@ReasonID
			,CHRM.NationalityID
			,@FromDate
			,@ToDate
			,@IsCustom
			,@IsSummary
			,@OperationBy
			,GETDATE()
			
		FROM CustomRateCards.HotelRateMaster CHRM
		WHERE @IsCustom = 1
			AND CHRM.HotelRateID = @RateID

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
			,CreatedBy
			,AdultReasonId
			,ChildReasonId
			,CreatedOn
			)
		SELECT grc.MonumentCommissionDetailID
			,grd.MonumentDetailID
			,TVP.CommissionMasterID
			,NULL
			,NULL
			,NULL
			,grc.TaxPercentage
			,grc.TaxAmount
			,grc.NetAmountExcludingTax
			,grc.NetAmountIncludingTax
			,@Markup_IsRate
			,@NetRate
			,TVP.SellingRates
			,TVP.GrossRate
			,TVP.MarkupRate
			,grm.IsActive
			,@OthersRateRefrenceID
			,@OperationBy
			,TVP.AdultReasonId
			,TVP.ChildReasonId
			,GETDATE()
		FROM [RateCards].[MonumentRateDetails] grd
		INNER JOIN [RateCards].[MonumentRateMaster] grm ON grm.MonumentRateID = grd.MonumentRateID
		LEFT JOIN [RateCards].[MonumentRateCommissionDetails] grc ON grd.MonumentDetailID = grc.MonumentDetailID
		LEFT JOIN @CommissionList AS TVP ON grc.MonumentCommissionDetailID = TVP.MonumentCommissionDetailID
			AND grd.MonumentDetailID = TVP.MonumentDetailID
		WHERE @IsCustom = 0
			AND grd.MonumentRateID = @RateID
			AND grd.MonumentDetailID = @MonumentDetailID
		
		UNION ALL
		
		SELECT RC.RateCommisionID
			,CHRM.HotelRateId
			,TVP.CommissionMasterID
			,NULL
			,NULL
			,NULL
			,RC.TaxPercentage
			,RC.TaxAmount
			,RC.NetAmountExcludingTax
			,RC.NetAmountIncludingTax
			,@Markup_IsRate
			,@NetRate
			,TVP.SellingRates
			,TVP.GrossRate
			,TVP.MarkupRate
			,CHRM.IsActive
			,@OthersRateRefrenceID
			,@OperationBy
			,TVP.AdultReasonId
			,TVP.ChildReasonId
			,GETDATE()
		FROM CustomRateCards.HotelRateMaster CHRM
		LEFT JOIN [CustomRateCards].[HotelRateCommisionDetails] RC ON CHRM.HotelRateID = RC.HotelRateID
		LEFT JOIN @CommissionList AS TVP ON RC.RateCommisionID = TVP.MonumentCommissionDetailID
		WHERE @IsCustom = 1
			AND CHRM.HotelRateID = @RateID

		SELECT @OthersRateRefrenceID AS ID
			,'200' AS returnCode
			,'Record inserted successfully' AS returnMessage;
	END
	ELSE IF @Action = 'U'
	BEGIN
		UPDATE [Quotation].OthersRateCardMaster
		SET ReasonID = @ReasonID
			,Disclaimer = @Disclaimer
			,UpdatedBy =@OperationBy,
<<<<<<< HEAD
<<<<<<< HEAD
=======
			IsSummary=@IsSummary,

>>>>>>> dev
=======
			IsSummary=@IsSummary,

>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
			UpdatedOn  =GETDATE()
		WHERE ID = @QMID;

		UPDATE c
		SET c.MinimumPax = NULL
			,c.MaximumPax = NULL
			,c.IsAmtIncludedInBasic = NULL
			,c.Markup_IsRate = TVP.Markup_IsRate
			,c.NetRate = @NetRate
			,c.SellingRates = TVP.SellingRates
			,c.IsGrossRateModified = (
				CASE 
					WHEN (isnull(c.GrossRate, 0) != tvp.GrossRate)
						THEN 1
					ELSE 0
					END
				)
			,c.ModifiedGrossRate = (
				CASE 
					WHEN (isnull(c.GrossRate, 0) != tvp.GrossRate)
						THEN tvp.GrossRate
					ELSE c.ModifiedGrossRate
					END
				)
			,c.MarkupRate = TVP.MarkupRate
			,UpdatedBy =@OperationBy
			,UpdatedOn  =GETDATE()
			,AdultReasonId=TVP.AdultReasonId
			,ChildReasonId=TVP.ChildReasonId
		FROM [Quotation].[OthersRateCardCommission] c
		INNER JOIN @CommissionList AS tvp ON c.ID = tvp.OthersRateCardCommissionID
		WHERE c.OthersRateRefrenceID = @QMID;

		SELECT '200' AS returnCode
			,'Record updated successfully' AS returnMessage;
	END
END
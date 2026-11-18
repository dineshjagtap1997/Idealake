CREATE PROCEDURE [Quotation].[InsertUpdateTransportRateMasterCommissionDetails] 
(
    @Action                       VARCHAR(1),
    @TransportRateID             BIGINT,
    @QuotationID                 BIGINT,
    @Markup_IsRate               BIT = NULL,
    @NetRate                     DECIMAL(18, 2) = NULL,
    @SellingRates                DECIMAL(18, 2) = NULL,
    @GrossRate                   DECIMAL(18, 2) = NULL,
    @GrossRateAdult              DECIMAL(18, 2) = NULL,
    @GrossRateChild              DECIMAL(18, 2) = NULL,
    @MarkupRate                  DECIMAL(18, 2) = NULL,
    @Disclaimer                  NVARCHAR(500) = NULL,
    @ReasonID                    INT = NULL,
    @TransportRateDetailID      BIGINT,
    @CommissionList             [dbo].[TransportCommissionTableType] READONLY,
	@FromDate Datetime =null,
	@ToDate Datetime =null,
	@TQTID bigint=null,
	@OthersRateCardCommissionID   BIGINT=NULL,
	@IsSummary BIT=0,
	@OperationBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @OthersRateRefrenceID BIGINT, @ReturnCode NVARCHAR(3), @ReturnMessage NVARCHAR(MAX), @LogID BIGINT;
	DECLARE @IsCustom BIT = CASE WHEN @TransportRateDetailID = 0 THEN 1 ELSE 0 END;

	IF @Action = 'I'
	BEGIN
		INSERT INTO [Quotation].OthersRateCardMaster (
                RateId, ServiceID, RateType, CardNumber, Heading, ContractDate, RateCardModeTypeID,
                CurrencyID, VendorID, CityID, StateID, GstStatus, InfoForOperation, InfoForAgent,
                InfoForRemark, IsActive, LanguageID, ReferenceRateDetailID, ValidFrom, ValidTo,
                MISSequence, TransportModeTypeID, HotelZone, CityID2, QuotationID, VehicleCategoryID, ReasonID,
				Disclaimer,FromDate,ToDate,IsCustom,IsSummary,CreatedBy,CreatedOn
            )
        SELECT DISTINCT grd.TransportRateID, grm.TransportServceID, 3, grm.CardNumber, grm.Heading, grm.ContractDate, RateCardModeTypeID, 
				grm.CurrencyID, grm.VendorID, grm.CityID, grm.StateID, grm.GstStatus, grm.InfoForOperation, grm.InfoForAgent,
                grm.InfoForRemark, grm.IsActive, '', grd.TransportRateDetailID, grd.ValidFrom, grd.ValidTo, 
				grd.MISSequence, grm.TransportModeTypeID, grm.HotelZone, grm.CityID2, @QuotationID, grd.VehicleCategoryID, @ReasonID,
				@Disclaimer,@FromDate,@ToDate,@IsCustom,@IsSummary,@OperationBy,GETDATE()
       FROM [RateCards].[TransportRateDetails] grd INNER JOIN [RateCards].[TransportRateMaster] grm ON grm.TransportRateID = grd.TransportRateID
       WHERE @IsCustom = 0 and grd.TransportRateID = @TransportRateID AND grd.TransportRateDetailID = @TransportRateDetailID
	   UNION ALL
	   SELECT DISTINCT CHRM.HotelRateID, CHRM.ServiceID, 3, '', '',null,0, 
				CHRM.CurrencyID, CHRM.VendorID,CHRM.CityID, 0, '','','', 
				'', CHRM.IsActive, '', 0, null,null, 
				0,0,'','',@QuotationID,CHRM.VehicleCategoryID, @ReasonID ,
				@Disclaimer ,@FromDate,@ToDate,@IsCustom,@IsSummary,@OperationBy,GETDATE()
		FROM CustomRateCards.HotelRateMaster CHRM WHERE @IsCustom = 1 and CHRM.HotelRateID = @TransportRateID 
		
		SET @OthersRateRefrenceID = SCOPE_IDENTITY();

	   INSERT INTO [Quotation].[OthersRateCardCommission] (
			CommissionRefrenceID, RateID, CommissionMasterID, MinimumPax, MaximumPax, IsAmtIncludedInBasic,
			TaxPercentage, TaxAmount, NetAmountExcludingTax, NetAmountIncludingTax, Markup_IsRate, NetRate,
			SellingRates, GrossRate, MarkupRate, IsActive, OthersRateRefrenceID,CreatedBy,CreatedOn)
		SELECT GRM.TransportRateID, grd.TransportRateDetailID, TVP.CommissionMasterID, NULL, NULL, NULL,
			grc.TaxPercentage, grc.TaxAmount, grc.NetAmountExcludingTax, grc.NetAmountIncludingTax, @Markup_IsRate, @NetRate, 
			TVP.SellingRates, TVP.GrossRate, TVP.MarkupRate, GRM.IsActive, @OthersRateRefrenceID,@OperationBy,GETDATE()
		FROM [RateCards].[TransportRateDetails] grd
			INNER JOIN [RateCards].[TransportRateMaster] GRM ON GRM.TransportRateID = grd.TransportRateID
			INNER JOIN @CommissionList AS TVP ON grd.TransportRateDetailID = TVP.TransportRateDetailID
			LEFT JOIN [RateCards].[TransportRateCommissionDetails] grc 
			ON grd.TransportRateDetailID = grc.TransportRateDetailID
			AND ((TVP.TransportCommissionDetailID <> 0 AND grc.TransportCommissionDetailID = TVP.TransportCommissionDetailID)
			OR (TVP.TransportCommissionDetailID = 0 AND grc.TransportCommissionDetailID IS NULL))
		WHERE @IsCustom = 0 AND grd.TransportRateID = @TransportRateID AND grd.TransportRateDetailID = @TransportRateDetailID
		UNION ALL
		--SELECT RC.RateCommisionID,CHRM.HotelRateId, TVP.CommissionMasterID,RC.MinimumPax, RC.MaximumPax, NULL, 
		--	RC.TaxPercentage, RC.TaxAmount, RC.NetAmountExcludingTax,RC.NetAmountIncludingTax, @Markup_IsRate, @NetRate,
		--	TVP.SellingRates, TVP.GrossRate, TVP.MarkupRate, CHRM.IsActive, @OthersRateRefrenceID
		--FROM CustomRateCards.HotelRateMaster CHRM LEFT JOIN [CustomRateCards].[HotelRateCommisionDetails] RC ON CHRM.HotelRateID = RC.HotelRateID
		--	LEFT JOIN @CommissionList AS TVP ON  RC.RateCommisionID = TVP.TransportCommissionDetailID  
		--WHERE @IsCustom = 1 AND CHRM.HotelRateID = @TransportRateID
		--	AND ((TVP.TransportCommissionDetailID <> 0 AND  RC.RateCommisionID = TVP.TransportCommissionDetailID)
		--	OR (TVP.TransportCommissionDetailID = 0 AND  RC.RateCommisionID IS NULL))
		SELECT 
			isnull(RC.RateCommisionID,0),isnull(CHRM.HotelRateId,0), TVP.CommissionMasterID,RC.MinimumPax, RC.MaximumPax, NULL, 
			RC.TaxPercentage, RC.TaxAmount, RC.NetAmountExcludingTax,RC.NetAmountIncludingTax, @Markup_IsRate, @NetRate,
			TVP.SellingRates, TVP.GrossRate, TVP.MarkupRate, isnull(CHRM.IsActive,1), @OthersRateRefrenceID,@OperationBy,GETDATE()
		FROM @CommissionList TVP
			LEFT JOIN [CustomRateCards].[HotelRateCommisionDetails] RC ON TVP.TransportCommissionDetailID = RC.RateCommisionID
			LEFT JOIN CustomRateCards.HotelRateMaster CHRM ON RC.HotelRateID = CHRM.HotelRateID
		WHERE @IsCustom = 1 

        SET @LogID = @OthersRateRefrenceID;
        SELECT @LogID AS ID, '200' AS returnCode, 'Record inserted successfully' AS returnMessage;
	END
	ELSE IF (@Action = 'U')
	BEGIN
   		UPDATE [Quotation].OthersRateCardMaster SET ReasonID = @ReasonID,Disclaimer =@Disclaimer,IsSummary=@IsSummary 
		,UpdatedBy =@OperationBy,
			UpdatedOn  =GETDATE()
			WHERE ID=@TQTID;

		UPDATE c
		SET c.SellingRates = tvp.SellingRates,c.Markup_IsRate = tvp.Markup_IsRate,
		c.IsGrossRateModified=(case when(Isnull(c.GrossRate,0) != tvp.GrossRate) then 1 else  0 end),
		c.ModifiedGrossRate = tvp.GrossRate,
		--( case when (Isnull(c.GrossRate,0) != tvp.GrossRate) then tvp.GrossRate else c.ModifiedGrossRate end),
		c.MarkupRate = tvp.MarkupRate,
		c.UpdatedBy =@OperationBy,
			c.UpdatedOn  =GETDATE()
		FROM [Quotation].[OthersRateCardCommission] c
		INNER JOIN @CommissionList AS tvp ON c.ID = tvp.OthersRateCardCommissionID
		WHERE c.OthersRateRefrenceID = @TQTID;
		SELECT '200' AS returnCode, 'Record updated successfully' AS returnMessage; 
	END
END

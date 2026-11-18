CREATE PROCEDURE [Quotation].[InsertUpdateSpecialRateMasterCommissionDetails]
(
    @Action                          VARCHAR(1),
    @SpecialServiceRateID            BIGINT,
    @QuotationID                     BIGINT,
    @Markup_IsRate                   BIT = NULL,
    @NetRate                         DECIMAL(18, 2) = NULL,
    @SellingRates                    DECIMAL(18, 2) = NULL,
    @GrossRate                       DECIMAL(18, 2) = NULL,
	@GrossRateAdult               DECIMAL(18, 2) = NULL,
    @GrossRateChild               DECIMAL(18, 2) = NULL,
    @MarkupRate                      DECIMAL(18, 2) = NULL,
    @Disclaimer                      NVARCHAR(500) = NULL,
    @ReasonID                        INT = NULL,
    @SpecialServiceRateDetailID     BIGINT,
    @CommissionList                  [dbo].[SpecialCommissionTableType] READONLY,
	@FromDate Datetime =null,
	@ToDate Datetime =null,
	@QSSMID bigint=null,
	@OthersRateCardCommissionID   BIGINT=NULL,
	@IsSummary BIT=0,
	@OperationBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @OthersRateRefrenceID BIGINT;
	DECLARE @IsCustom BIT = CASE WHEN @SpecialServiceRateDetailID = 0 THEN 1 ELSE 0 END;

	IF @Action = 'I'
		BEGIN
			INSERT INTO [Quotation].OthersRateCardMaster (
				RateId, ServiceID, RateType, CardNumber, Heading, ContractDate, RateCardModeTypeID, CurrencyID,
				VendorID, CityID, StateID, GstStatus, InfoForOperation, InfoForAgent, InfoForRemark, IsActive,
				LanguageID, ReferenceRateDetailID, ValidFrom, ValidTo, MISSequence, CreatedOn, ReasonID,
				QuotationID, Disclaimer, FromDate, ToDate, IsCustom, NationalityID,IsSummary,CreatedBy
			)
			SELECT DISTINCT
				grd.SpecialServiceRateID, grm.SpecialServiceID, 4, grm.CardNumber, grm.Heading, grm.ContractDate, grm.RateCardModeTypeID, grm.CurrencyID, 
				grm.VendorID, grm.CityID, grm.StateID, grm.GstStatus, grm.InfoForOperation, grm.InfoForAgent, grm.InfoForRemark, grm.IsActive, 
				'', grd.SpecialServiceRateDetailID,grd.ValidFrom, grd.ValidTo, grd.MISSequence, GETDATE(), @ReasonID, 
				@QuotationID, @Disclaimer,@FromDate, @ToDate, @IsCustom, grd.NationalityID,@IsSummary,@OperationBy
			FROM [RateCards].[SpecialServiceRateDeatils] grd
			INNER JOIN [RateCards].[SpecialServiceRateMaster] grm ON grm.SpecialServiceRateID = grd.SpecialServiceRateID
			LEFT JOIN [RateCards].[SpecialServiceRateCommissionDeatils] grc ON grd.SpecialServiceRateDetailID = grc.SpecialServiceRateDetailID
			WHERE  @IsCustom = 0 and grd.SpecialServiceRateID = @SpecialServiceRateID AND grd.SpecialServiceRateDetailID = @SpecialServiceRateDetailID
			UNION ALL
			SELECT DISTINCT
				CHRM.HotelRateID, CHRM.ServiceID, 4, '','',null,0, CHRM.CurrencyID, 
				 CHRM.VendorID, CHRM.CityID, 0, '','', '', '', CHRM.IsActive, 
				'',  0, null,null, 0, GETDATE(),@ReasonID, 
				@QuotationID, @Disclaimer, @FromDate, @ToDate, @IsCustom, CHRM.NationalityID,@IsSummary,@OperationBy
			FROM 
				CustomRateCards.HotelRateMaster CHRM WHERE @IsCustom = 1 and CHRM.HotelRateID = @SpecialServiceRateID

     		SET @OthersRateRefrenceID = SCOPE_IDENTITY();

			INSERT INTO [Quotation].[OthersRateCardCommission] (
				CommissionRefrenceID, RateID, CommissionMasterID, MinimumPax, MaximumPax, IsAmtIncludedInBasic, 
				TaxPercentage, TaxAmount, NetAmountExcludingTax, NetAmountIncludingTax, Markup_IsRate, NetRate, 
				SellingRates, GrossRate, MarkupRate, IsActive, OthersRateRefrenceID,AdultReasonId,ChildReasonId,CreatedBy)
			SELECT grc.SpecialServiceRateCommissionID, TVP.SpecialDetailID, TVP.CommissionMasterID, grc.MinimumPax, grc.MaximumPax, 
				NULL, grc.TaxPercentage, grc.TaxAmount, grc.NetAmountExcludingTax, grc.NetAmountIncludingTax, TVP.Markup_IsRate, @NetRate, 
				TVP.SellingRates, TVP.GrossRate, TVP.MarkupRate, GRM.IsActive, @OthersRateRefrenceID,TVP.AdultReasonId,TVP.ChildReasonId,@OperationBy
			FROM [RateCards].[SpecialServiceRateDeatils] grd
				INNER JOIN [RateCards].[SpecialServiceRateMaster] GRM ON GRM.SpecialServiceRateID = grd.SpecialServiceRateID
				INNER JOIN @CommissionList AS TVP ON grd.SpecialServiceRateDetailID = TVP.SpecialDetailID
				LEFT JOIN [RateCards].[SpecialServiceRateCommissionDeatils] grc ON grd.SpecialServiceRateDetailID = grc.SpecialServiceRateDetailID 
				AND grc.CommissionMasterID = TVP.CommissionMasterID
			WHERE @IsCustom = 0 AND grd.SpecialServiceRateID = @SpecialServiceRateID AND grd.SpecialServiceRateDetailID = @SpecialServiceRateDetailID
			UNION ALL
			SELECT RC.RateCommisionID, TVP.SpecialDetailID, TVP.CommissionMasterID, NULL, NULL,
				NULL, RC.TaxPercentage, RC.TaxAmount, RC.NetAmountExcludingTax, RC.NetAmountIncludingTax, TVP.Markup_IsRate, @NetRate, 
				TVP.SellingRates, TVP.GrossRate, TVP.MarkupRate, CHRM.IsActive, @OthersRateRefrenceID,TVP.AdultReasonId,TVP.ChildReasonId,@OperationBy
			FROM CustomRateCards.HotelRateMaster CHRM
				LEFT JOIN CustomRateCards.HotelRateCommisionDetails RC ON CHRM.HotelRateID = RC.HotelRateID
				INNER JOIN @CommissionList AS TVP ON RC.RateCommisionID = TVP.SpecialCommissionDetailID
			WHERE @IsCustom = 1 AND CHRM.HotelRateID = @SpecialServiceRateID;
			SELECT '200' AS returnCode, 'Record inserted successfully' AS returnMessage;
			--end
		END
	ELSE IF @Action = 'U'
		BEGIN 
			UPDATE [Quotation].OthersRateCardMaster SET ReasonID = @ReasonID,Disclaimer =@Disclaimer,IsSummary=@IsSummary ,UpdatedBy =@OperationBy,
			UpdatedOn  =GETDATE()
			WHERE ID=@QSSMID;

			UPDATE c
			SET 
				c.SellingRates = tvp.SellingRates,
				c.IsGrossRateModified=(case when(isnull(c.GrossRate,0) != tvp.GrossRate) then 1 else  0 end),
				c.ModifiedGrossRate = (case when (isnull(c.GrossRate,0) != tvp.GrossRate) then tvp.GrossRate else c.ModifiedGrossRate end),
				c.MarkupRate = tvp.MarkupRate,
				c.Markup_IsRate=tvp.Markup_IsRate,
				c.RateID=TVP.SpecialDetailID,
				c.CommissionMasterID=TVP.CommissionMasterID,
				c.AdultReasonId=TVP.AdultReasonId,
				c.ChildReasonId=TVP.ChildReasonId,
				c.UpdatedBy =@OperationBy,
			c.UpdatedOn  =GETDATE()
			FROM [Quotation].[OthersRateCardCommission] c
			INNER JOIN @CommissionList AS tvp 
				ON c.ID = tvp.OthersRateCardCommissionID
				--where C.ID= @OthersRateCardCommissionID
			--	AND c.RateID = tvp.SpecialDetailID
			WHERE c.OthersRateRefrenceID = @QSSMID;
			SELECT '200' AS returnCode, 'Record updated successfully' AS returnMessage; 
		END		
END
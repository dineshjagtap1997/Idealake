
CREATE PROCEDURE [Booking].[usp_GuidDayWiseService_New_A] @CheckIn DATE = '2025-06-16'
	,@CheckOut DATE = '2025-06-18'
	,@Service INT = 151
	,--- Available
	@BookingID INT = 49
	,@QuotationID INT = NULL
	,@UserID UNIQUEIDENTIFIER = NULL
	,@RateID BIGINT = 7
	,@RateDetailID NVARCHAR(Max) = '14,15'
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @OthersRateRefrenceID BIGINT
		,@SupplierTax_InCluding TINYINT = 0;

	SET @SupplierTax_InCluding = (
			SELECT TOP 1 SupplierTax_InCluding
			FROM Booking.tbl_Booking
			WHERE ID = @BookingID
			);

	DECLARE @ReturnCode NVARCHAR(3)
		,@ReturnMessage NVARCHAR(MAX);

	

	INSERT INTO [Booking].OthersRateCardMasterBooking_New (
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
			--,Disclaimer
			--,ReasonID
			--,FromDate
			--,ToDate
			--,IsCustom
			--,IsSummary
			--,CreatedBy
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
			--,@Disclaimer
			--,@ReasonID
			--,@FromDate
			--,@ToDate
			--,@IsCustom
			--,@IsSummary
			--,@OperationBy
		FROM [RateCards].[GuideRateDetails] grd
		INNER JOIN [RateCards].[GuideRateMaster] GRM ON GRM.GuideRateID = grd.GuideRateID
		LEFT JOIN [RateCards].[GuideRateCommissionDetails] grc ON grd.GuideRateDetailID = grc.GuideRateDetailID
		WHERE
	 GRD.GuideRateDetailID IN (
			SELECT value
			FROM STRING_SPLIT(@RateDetailID, ',')
			)

	SET @OthersRateRefrenceID = SCOPE_IDENTITY();

	INSERT INTO [Booking].[OthersRateCardCommissionBooking_new] (
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
		,IsActive
		,OthersRateRefrenceID
		,CreatedOn
		,GrossRate
		,BookingID
		--,CommissionMasterID
		)
	SELECT DISTINCT 
		grd.GuideRateID
		,grc.GuideRateDetailID
		,grc.GuideRateCommissionID
		,grc.PaxMinimum
		,grc.PaxMaximum
		,NULL
		,grc.TaxPercentage
		,grc.TaxAmount
		,grc.NetAmountExcludingTax
		,grc.NetAmountIncludingTax
		,GRM.IsActive
		,@OthersRateRefrenceID
		,GETDATE()
		,(
			CASE 
				WHEN Isnull((
							SELECT Isnull(SupplierTax_InCluding, 0)
							FROM Booking.tbl_Booking
							WHERE ID = @BookingID
							), 0) = 0
					THEN grc.NetAmountExcludingTax
				ELSE grc.NetAmountIncludingTax
				END
			)
		,@BookingID
	--	,0
	FROM [RateCards].[GuideRateDetails] grd
	INNER JOIN [RateCards].[GuideRateMaster] GRM ON GRM.GuideRateID = grd.GuideRateID
	LEFT JOIN [RateCards].[GuideRateCommissionDetails] grc ON grd.GuideRateDetailID = grc.GuideRateDetailID
	WHERE GRD.GuideRateDetailID IN (
			SELECT value
			FROM STRING_SPLIT(@RateDetailID, ',')
			)

DECLARE @CommissionID BIGINT
	SET @CommissionID = SCOPE_IDENTITY();


			WITH DateRange
	AS (
		SELECT @CheckIn AS [Date]
		
		UNION ALL
		
		SELECT DATEADD(DAY, 1, [Date])
		FROM DateRange
		WHERE [Date] < @CheckOut
		)
	INSERT INTO Booking.DayWiseBooking (
		DayWiseDate
		,City
		,ServiceID
		,Guide
		,LANGUAGE
		,Vendor
		,Count
		,BookingID
		,RateTypeID
		,QuotationID
		,ServiceName
		,IsActive
		,CreatedBy
		,CreatedOn
		,RateID
		,RateDetailID
		,Currency
		,BORMID
		)
	SELECT DISTINCT D.[Date]
		,GRM.CityID
		,grm.GuideRateID
		,GRM.GuideServiceID
		,GRM.LanguageID
		,GRM.VendorID
		,0 AS [Count]
		,@BookingID
		,1
		,@QuotationID
		,GS.Name
		,1
		,@UserID
		,getdate()
		,GRD.GuideRateID
		,GRD.GuideRateDetailID
		,CurrencyID
		,@CommissionID
	FROM DateRange D
	JOIN RateCards.GuideRateMaster GRM ON 1 = 1
	INNER JOIN RateCards.GuideRateDetails GRD ON GRD.GuideRateID = GRM.GuideRateID
	LEFT JOIN GuideServices GS ON GS.Code = GRM.GuideServiceID
	WHERE GRD.GuideRateDetailID IN (
			SELECT value
			FROM STRING_SPLIT(@RateDetailID, ',')
			)
		AND GRM.IsActive = 1
		AND GRD.IsActive = 1
	SELECT '200' AS returnCode
		,'Record inserted successfully' AS returnMessage
		--,@OthersRateRefrenceID AS ID;
END;
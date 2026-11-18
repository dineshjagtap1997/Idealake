

CREATE PROCEDURE [Booking].[usp_SpecialServiceDayWiseService_bkp] 
	 @CheckIn DATE = '2025-07-01'
	,@CheckOut DATE = '2025-07-01'
	,@Adult INT = 1
	,@Child INT = 2
	,@Service INT = 363
	,--- Available
	 @BookingID INT = 42
	,@QuotationID INT = NULL
	,@UserID UNIQUEIDENTIFIER = 'feeceb69-c92c-41a9-98de-fa86fcc009e9'
	,@RateID BIGINT = 7
	,@RateDetailID Nvarchar(Max) ='23'
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ReturnCode NVARCHAR(3)
		,@ReturnMessage NVARCHAR(MAX);
	DECLARE @OthersRateRefrenceID BIGINT
		,@SupplierTax_InCluding TINYINT = 0;

	SET @SupplierTax_InCluding = (
			SELECT TOP 1 SupplierTax_InCluding
			FROM Booking.tbl_Booking
			WHERE ID = @BookingID
			);

	
	--(
	--		SSRM.SpecialServiceRateID = @RateID
	--		OR Isnull(@RateID, 0) = 0
	--		)

	--AND SSRM.IsActive = 1
	--AND SSRD.IsActive = 1
	INSERT INTO [Booking].OthersRateCardMasterBooking (
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
		,ReferenceRateDetailID
		,ValidFrom
		,ValidTo
		,MISSequence
		,CreatedOn
		,QuotationID
		,Disclaimer
		,FromDate
		,ToDate
		,NationalityID
		,CreatedBy
		,BookingID
		,IsCustom
		,TaxID
		,RatePreferenceID
		)
	SELECT DISTINCT grd.SpecialServiceRateID
		,grm.SpecialServiceID
		,4
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
		,grd.SpecialServiceRateDetailID
		,grd.ValidFrom
		,grd.ValidTo
		,grd.MISSequence
		,GETDATE()
		,@QuotationID
		,''
		,@CheckIn
		,@CheckOut
		,grd.NationalityID
		,@UserID
		,@BookingID
		,0
		,grd.TaxID
		,grd.RatePreferenceID
	FROM [RateCards].[SpecialServiceRateDeatils] grd
	INNER JOIN [RateCards].[SpecialServiceRateMaster] grm ON grm.SpecialServiceRateID = grd.SpecialServiceRateID
	LEFT JOIN [RateCards].[SpecialServiceRateCommissionDeatils] grc ON grd.SpecialServiceRateDetailID = grc.SpecialServiceRateDetailID
	--WHERE grd.SpecialServiceRateID = @RateID
	--	AND  = @RateDetailID
	WHERE grd.SpecialServiceRateDetailID IN (
    SELECT value FROM STRING_SPLIT(@RateDetailID, ',')
	);
	SET @OthersRateRefrenceID = SCOPE_IDENTITY();

	INSERT INTO [Booking].[OthersRateCardCommissionBooking] (
		CommissionRefrenceID
		,MinimumPax
		,MaximumPax
		,IsAmtIncludedInBasic
		,TaxPercentage
		,TaxAmount
		,NetAmountExcludingTax
		,NetAmountIncludingTax
		,GrossRate
		,IsActive
		,OthersRateRefrenceID
		,RateID
		,BookingID
		,CommissionMasterID
		)
	SELECT grc.SpecialServiceRateCommissionID
		,grc.MinimumPax
		,grc.MaximumPax
		,NULL
		,grc.TaxPercentage
		,grc.TaxAmount
		,grc.NetAmountExcludingTax
		,grc.NetAmountIncludingTax
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
		,GRM.IsActive
		,@OthersRateRefrenceID
		,grd.SpecialServiceRateID,
		@BookingID
		,grc.CommissionMasterID
	FROM [RateCards].[SpecialServiceRateDeatils] grd
	INNER JOIN [RateCards].[SpecialServiceRateMaster] GRM ON GRM.SpecialServiceRateID = grd.SpecialServiceRateID
	LEFT JOIN [RateCards].[SpecialServiceRateCommissionDeatils] grc ON grd.SpecialServiceRateDetailID = grc.SpecialServiceRateDetailID
		WHERE grd.SpecialServiceRateDetailID IN (
    SELECT value FROM STRING_SPLIT(@RateDetailID, ',')
	);

	-------------------------------------------Booking--------------------------------------------------------------

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
		,Vendor
		,Nationality
		,Adult
		,Child
		,BookingID
		,QuotationID
		,RateTypeID
		,ServiceName
		,IsActive
		,CreatedBy
		,CreatedOn
		,RateID
		,RateDetailID
		,Currency
		,Adult_Rate
		,Child_Rate
		,Consolidated
		,BORMID
		)
	SELECT DISTINCT 
		 D.[Date]
		,SSRM.CityID
		,SSRM.SpecialServiceID
		,SSRM.VendorID
		,SSRD.NationalityID
		,0
		,0
		,@BookingID
		,@QuotationID
		,4
		,SS.Name
		,1
		,@UserID
		,GETDATE()
		,SSRM.SpecialServiceRateID
		,SSRD.SpecialServiceRateDetailID
		,CurrencyID
		,0
		,0
		,0
		--,Isnull((
		--		SELECT TOP 1 CAST(CAST(dbo.fnSearchCalculateROE(CASE 
		--							WHEN Isnull(@SupplierTax_InCluding, 0) = 0
		--								THEN SCRD.NetAmountExcludingTax
		--							ELSE SCRD.NetAmountIncludingTax
		--							END, @CheckIn, NULL, SSRM.CurrencyID) AS NUMERIC(18, 0)) AS VARCHAR(20))
		--		FROM RateCommissionMaster RCM
		--		INNER JOIN RateCards.SpecialServiceRateCommissionDeatils SCRD ON RCM.CommMasterID = SCRD.CommissionMasterID
		--		WHERE SCRD.SpecialServiceRateDetailID = SSRD.SpecialServiceRateDetailID
		--			AND RCM.CommMasterID = 7
		--		), 0)
		--,Isnull((
		--		SELECT TOP 1 CAST(CAST(dbo.fnSearchCalculateROE(CASE 
		--							WHEN Isnull(@SupplierTax_InCluding, 0) = 0
		--								THEN SCRD.NetAmountExcludingTax
		--							ELSE SCRD.NetAmountIncludingTax
		--							END, @CheckIn, NULL, SSRM.CurrencyID) AS NUMERIC(18, 0)) AS VARCHAR(20))
		--		FROM RateCommissionMaster RCM
		--		INNER JOIN RateCards.SpecialServiceRateCommissionDeatils SCRD ON RCM.CommMasterID = SCRD.CommissionMasterID
		--		WHERE SCRD.SpecialServiceRateDetailID = SSRD.SpecialServiceRateDetailID
		--			AND RCM.CommMasterID = 8
		--		), 0)
		--,Isnull((
		--		SELECT TOP 1 CAST(CAST(dbo.fnSearchCalculateROE(CASE 
		--							WHEN Isnull(@SupplierTax_InCluding, 0) = 0
		--								THEN SCRD.NetAmountExcludingTax
		--							ELSE SCRD.NetAmountIncludingTax
		--							END, @CheckIn, NULL, SSRM.CurrencyID) AS NUMERIC(18, 0)) AS VARCHAR(20))
		--		FROM RateCommissionMaster RCM
		--		INNER JOIN RateCards.SpecialServiceRateCommissionDeatils SCRD ON RCM.CommMasterID = SCRD.CommissionMasterID
		--		WHERE SCRD.SpecialServiceRateDetailID = SSRD.SpecialServiceRateDetailID
		--			AND Isnull(SCRD.CommissionMasterID, 0) = 0
		--		), 0)
		,@OthersRateRefrenceID
	FROM DateRange D
	JOIN RateCards.SpecialServiceRateMaster SSRM ON 1 = 1
	INNER JOIN RateCards.SpecialServiceRateDeatils SSRD ON SSRD.SpecialServiceRateID = SSRM.SpecialServiceRateID
	INNER JOIN SpecialServices SS ON SS.ID = SSRM.SpecialServiceID
	WHERE SSRD.SpecialServiceRateDetailID IN (
    SELECT value FROM STRING_SPLIT(@RateDetailID, ',')
);


	SELECT '200' AS returnCode
		,'Record inserted successfully' AS returnMessage
		,@OthersRateRefrenceID AS ID;
END;

CREATE PROCEDURE [RateCards].[usp_GetTransportRateCardSearchReportNew]
(
    @DisplayRate        VARCHAR(5)  = NULL,
    @RateCardModeTypeID VARCHAR(10) = NULL,
    @TaxID              INT         = NULL,
    @Service            INT         = NULL,
    @CityIata           CHAR(3)     = NULL,
    @VendorID           INT         = NULL,
    @ValidFrom          DATETIME    = NULL,
    @ValidTo            DATETIME    = NULL,
    @VTypeID            INT         = NULL,
    @TransportRateDetailID INT      = NULL,  -- Fetch specific record
	@QuotationID        INT        = NULL,
	@BookingID bigint =null,
@TransportRateID bigint =NULL


)

--EXEC [RateCards].[usp_GetTransportRateCardSearchReportNew] 'INR','1',1,2058,'OOO',3023,'2025-07-09T00:00:00','2025-07-24T00:00:00',0
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @RateCardModeTable TABLE (ModeID INT);

    -- Split RateCardModeTypeID CSV
    INSERT INTO @RateCardModeTable (ModeID)
    SELECT DISTINCT TRY_CAST(value AS INT)
    FROM STRING_SPLIT(@RateCardModeTypeID, ',')
    WHERE TRY_CAST(value AS INT) IS NOT NULL;

	WITH CTE_Transport
	AS (
		-- Select with JSON commission
		SELECT DISTINCT 
			TRD.TransportRateDetailID,
			TRM.TransportRateID,
			'RateCard' as Type,
			CT.Name AS City,
			CT.IATACode,
			TS.Name AS TransportService,
			VTM.VehicleType,
			TRD.ValidFrom,
			TRD.ValidTo,
			@DisplayRate AS Currency,
			TRM.CardNumber,
			TRM.ContractDate,
			TRM.CurrencyID,
			TRM.StateID,
			TRM.VendorID,
		   VM.VendorName,
			TRM.InfoForOperation,
			TRM.InfoForAgent,
			TRM.InfoForRemark,
			TRM.IsActive,
			TRM.CreatedOn,
			TRM.UpdatedOn,
			TRM.GSTStatus,
			TRM.RateCardModeTypeID,
			TRM.CityID,
			TRD.TaxID,
			TRM.TransportServceID,
			CASE TRM.RateCardModeTypeID
				WHEN 1 THEN 'Contract'
				WHEN 2 THEN 'Adhoc'
				WHEN 3 THEN 'Negotiated'
			END AS RateCardModeType,
			--TS.ModeOfTransport,
			--CASE WHEN TS.ModeOfTransport IN (1,2) THEN 1 ELSE 0 END AS Arrival,
			--CASE WHEN TS.ModeOfTransport = 1 THEN 1 ELSE 0 END AS Departure,
			--VTM.ID AS VehicleCategoryID,

		 (
		SELECT *
		FROM
		(
			-- First object: grouped totals
			SELECT
				Null as TransportCommissionDetailID,
				NULL AS CommissionMasterID,
				NULL AS RateType,
		
				SUM(TaxAmount) AS TaxAmount,
				SUM(NetAmountExcludingTax) AS NetAmountExcludingTax,
				SUM(NetAmountIncludingTax) AS NetAmountIncludingTax,
				 SUM(NetAmountExcludingTax) * dbo.fnGetPurchaseRate(TRM.CurrencyID, @DisplayRate, GETDATE()) AS NetAmountExcludingTax_Con,
			   SUM(NetAmountIncludingTax) * dbo.fnGetPurchaseRate(TRM.CurrencyID, @DisplayRate, GETDATE()) AS NetAmountIncludingTax_Con,
				'Total' AS CommissionType
			FROM RateCards.TransportRateCommissionDetails
			WHERE TransportRateDetailID = TRD.TransportRateDetailID
			  AND CommissionMasterID IN (9, 10, 13, 14, 15, 18, 19)

			UNION ALL

			-- Individual commissions
			SELECT
				TRCD.TransportCommissionDetailID,
				TRCD.CommissionMasterID,
		
				RCM.RateType,
				TRCD.TaxAmount,
				TRCD.NetAmountExcludingTax,
				TRCD.NetAmountIncludingTax,
				 TRCD.NetAmountExcludingTax * dbo.fnGetPurchaseRate(TRM.CurrencyID, @DisplayRate, GETDATE()) AS NetAmountExcludingTax_Con,
				TRCD.NetAmountIncludingTax * dbo.fnGetPurchaseRate(TRM.CurrencyID, @DisplayRate, GETDATE()) AS NetAmountIncludingTax_Con,
				'Detail' AS CommissionType
			FROM RateCards.TransportRateCommissionDetails TRCD
			INNER JOIN RateCommissionMaster RCM ON RCM.CommMasterID = TRCD.CommissionMasterID
			WHERE TRCD.TransportRateDetailID = TRD.TransportRateDetailID
			  AND TRCD.CommissionMasterID NOT IN (9, 10, 13, 14, 15, 18, 19)

		) AS CombinedCommissions
		FOR JSON PATH
	) AS TransportRateCommissionDetails,
	 --TRM.InfoForOperation,
	--TRM.InfoForRemark,
	TRM.XORemark,
	XO.XoRemarks AS XORemarkName ,
		TRD.MISSequence,
		HM.HotelName,
		TRM.HotelID

		FROM RateCards.TransportRateMaster TRM
		INNER JOIN RateCards.TransportRateDetails TRD ON TRD.TransportRateID = TRM.TransportRateID
		Inner Join RateCards.TransportRateCommissionDetails RComm On RComm.TransportRateDetailID=TRD.TransportRateDetailID
		LEFT JOIN VendorMaster VM ON VM.VendorID = TRM.VendorID
		LEFT JOIN City CT ON CT.IATACode = TRM.CityID
		INNER JOIN TransportServices TS ON TS.Code = TRM.TransportServceID
		LEFT JOIN VehicleTypeMaster VTM ON VTM.ID = TRD.VehicleCategoryID
		LEFT JOIN XORemarks XO  ON XO.XOID = TRM.XORemark
		LEFT JOIN HotelMaster HM ON TRM.HotelID=HM.HotelID

		WHERE 
			--( @TransportRateDetailID IS NULL OR @TransportRateDetailID = '' OR TRD.TransportRateDetailID = @TransportRateDetailID  
			--)
		--    OR
		--    (
		--        @TransportRateDetailID IS NULL AND
		--        TRM.TransportServceID = @Service
		--and
		 (TRM.TransportRateID =@TransportRateID and Isnull(@TransportRateID,0)<>0) Or

		   ( (Isnull(@TransportRateID,0)=0) and 
		(@Service IS NULL OR @Service = 0 OR TRM.TransportServceID = @Service)
		  AND TRM.RateCardModeTypeID IN (SELECT ModeID FROM @RateCardModeTable)
		  AND TRM.CityID = @CityIata
		   AND (@VendorID IS NULL OR @VendorID = 0 OR TRM.VendorID = @VendorID)

			  --  AND (@TaxID IS NULL OR TRD.TaxID = @TaxID) ----As discussed with Ajinkya removed Tax filter
	   AND (@VTypeID IS NULL  OR @VTypeID = 0 OR VTM.ID = @VTypeID)
			   AND TRM.IsActive = 1 
	   --         AND TRD.IsActive = 1 
				--AND (TRD.ValidFrom >= @ValidFrom AND TRD.ValidTo <= @ValidTo)
					AND TRD.ValidFrom <= @ValidTo AND TRD.ValidTo >= @ValidFrom

	   --AND( (( TRM.BookingID=@BookingID and TRM.RateCardModeTypeID=3) or(TRM.BookingID is null and TRM.RateCardModeTypeID in (1,2,3,4))) or (@BookingID is null) or (@BookingID =0 ))
	   )
		   -- )
		--ORDER BY TRD.TransportRateDetailID;
		UNION
		select 
			0 as TransportRateDetailID,
			CHRM.HotelRateID as TransportRateID,
			'CustomRateCard' as Type,
			CT.Name AS City,
			CT.IATACode,
			TS.Name AS TransportService,
			VTM.VehicleType,
			'' as ValidFrom,
			'' as ValidTo,
			@DisplayRate AS Currency,
			'' CardNumber,
			'' as ContractDate,
			CHRM.CurrencyID,
			0 as StateID,
			CHRM.VendorID,
			VM.VendorName,
			'' as InfoForOperation,
			'' as InfoForAgent,
			'' as InfoForRemark,
			'' as IsActive,
			CHRM.CreatedOn,
			CHRM.UpdatedOn,
			'' as GSTStatus,
			0 as RateCardModeTypeID,
			CHRM.CityID,
			0 as TaxID,
			CHRM.ServiceID as TransportServceID,
			'' AS RateCardModeType,
		

			(
				SELECT *
					FROM
					(
						-- First object: grouped totals
						SELECT
						Null as TransportCommissionDetailID,
						NULL AS CommissionMasterID,
						NULL AS RateType,
		
						SUM(TaxAmount) AS TaxAmount,
						SUM(NetAmountExcludingTax) AS NetAmountExcludingTax,
						SUM(NetAmountIncludingTax) AS NetAmountIncludingTax,
						 SUM(NetAmountExcludingTax) * dbo.fnGetPurchaseRate(CHRM.CurrencyID, @DisplayRate, GETDATE()) AS NetAmountExcludingTax_Con,
			   SUM(NetAmountIncludingTax) * dbo.fnGetPurchaseRate(CHRM.CurrencyID, @DisplayRate, GETDATE()) AS NetAmountIncludingTax_Con,
						'Total' AS CommissionType
						FROM CustomRateCards.HotelRateCommisionDetails
						WHERE HotelRateID = CHRM.HotelRateID

						UNION ALL

						-- Individual commissions
						SELECT
						TRCD.RateCommisionID as TransportCommissionDetailID,
						TRCD.CommissionMasterID,
		
						RCM.RateType,
						TRCD.TaxAmount,
						TRCD.NetAmountExcludingTax,
						TRCD.NetAmountIncludingTax,
						 TRCD.NetAmountExcludingTax * dbo.fnGetPurchaseRate(CHRM.CurrencyID, @DisplayRate, GETDATE()) AS NetAmountExcludingTax_Con,
				TRCD.NetAmountIncludingTax * dbo.fnGetPurchaseRate(CHRM.CurrencyID, @DisplayRate, GETDATE()) AS NetAmountIncludingTax_Con,
						'Detail' AS CommissionType
						FROM CustomRateCards.HotelRateCommisionDetails TRCD
						INNER JOIN RateCommissionMaster RCM ON RCM.CommMasterID = TRCD.CommissionMasterID
						WHERE TRCD.HotelRateID = CHRM.HotelRateID
					) AS CombinedCommissions
					FOR JSON PATH
			) AS TransportRateCommissionDetails,
			--'' as InfoForOperation,
	--'' as InfoForRemark,
	'' AS XORemark,
	'' AS XORemarkName ,
	'' AS MISSequence,
	H.HotelName,
	CHRM.HotelID
		from
			CustomRateCards.HotelRateMaster CHRM WITH (NOLOCK)
			LEFT OUTER JOIN HotelMaster H WITH (NOLOCK) ON CHRM.HotelID = H.HotelID
			LEFT OUTER JOIN City CT WITH (NOLOCK) ON CHRM.CityID = CT.IATACode
			LEFT JOIN VehicleTypeMaster VTM WITH (NOLOCK) ON VTM.ID = CHRM.VehicleCategoryID
			LEFT JOIN VendorMaster VM WITH (NOLOCK) ON VM.VendorID = CHRM.VendorID
			LEFT JOIN TransportServices TS ON TS.Code = CHRM.ServiceID
		WHERE
			CHRM.RateType=3
			AND CHRM.IsActive = 1 
			AND CHRM.QuotationID=@QuotationID
			AND (@VendorID IS NULL OR @VendorID = 0 OR CHRM.VendorID = @VendorID)
			AND
			(
				(@ValidFrom IS NOT NULL AND @ValidTo IS NOT NULL AND CAST(CHRM.CheckIn AS DATE) <= CAST(@ValidTo AS DATE) AND CAST(CHRM.CheckOut AS DATE) >= CAST(@ValidFrom AS DATE))
				OR
				(@ValidFrom IS NOT NULL AND @ValidTo IS NULL AND CAST(CHRM.CheckOut AS DATE) >= CAST(@ValidFrom AS DATE))
				OR
				(@ValidFrom IS NULL AND @ValidTo IS NOT NULL AND CAST(CHRM.CheckIn AS DATE) <= CAST(@ValidTo AS DATE))
				OR
				(@ValidFrom IS NULL AND @ValidTo IS NULL)
			)
	)

	SELECT 
		* 
	FROM 
		CTE_Transport
	--ORDER BY CreatedOn DESC
	 ORDER BY 
        TransportService,
        CASE WHEN ISNULL(VendorID, 0) <> 0 THEN VendorName END,
        CASE WHEN ISNULL(HotelID, 0) <> 0 THEN HotelName END,
        MISSequence,
        ValidFrom;

    SET NOCOUNT OFF;
END

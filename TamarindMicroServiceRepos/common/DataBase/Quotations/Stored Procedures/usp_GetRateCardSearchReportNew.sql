<<<<<<< HEAD
<<<<<<< HEAD
﻿--declare
--@QuotationID INT = 85
--	,@Action CHAR(1) = 'S'
--exec [Quotations].[usp_GetRateCardSearchReportNew] 90
CREATE PROCEDURE [Quotations].[usp_GetRateCardSearchReportNew] (
	@QuotationID INT = NULL
=======
﻿
CREATE PROCEDURE [Quotations].[usp_GetRateCardSearchReportNew] (
	@QuotationID INT = 531
>>>>>>> dev
=======
﻿
CREATE PROCEDURE [Quotations].[usp_GetRateCardSearchReportNew] (
	@QuotationID INT = 531
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
	,@Action CHAR(1) = NULL
	)
AS
BEGIN
	SET NOCOUNT ON;

	--Guide
	SELECT 'Guide' AS ServiceType
		,GRM.ID AS QGID
		,GRC.ID AS OthersRateCardCommissionID
		,GRM.RateId AS GuideRateID
		,GRM.ReferenceRateDetailID AS GuideRateDetailID
		,GRC.ID AS GuideRateCommissionID
		,GRM.ServiceID AS GuideServiceID
		,GRM.CardNumber
		,GRM.Heading
		,GRM.ContractDate
		,GRM.CityID
		,GRM.VendorID
		,GRM.CurrencyID
		,GRM.LanguageID
		,CT.Name AS City
		,GS.Name AS GuideService
		,VM.VendorName AS Vendor
		,GRM.InfoForOperation
		,GRM.InfoForAgent
		,GRM.InfoForRemark
		,GRM.IsActive
		,GRM.CreatedOn
		,
		--	GRM.CreatedBy,
		GRM.UpdatedOn
		,
		--	GRM.UpdatedBy,
		GRM.Notes
		,GRM.StateID
		,GRM.VendorID
		,L.LANGUAGE
		,CONCAT (
			GRC.MinimumPax
			,' - '
			,GRC.MaximumPax
			) AS PaxRange
		,GRM.ValidFrom
		,GRM.ValidTo
		,GRC.MinimumPax
		,GRC.MaximumPax
		,GRM.MISSequence
		,GRM.CurrencyID
		,CASE GRM.RateCardModeTypeID
			WHEN 1
				THEN 'Contract'
			WHEN 2
				THEN 'Adhoc'
			WHEN 3
				THEN 'Negotiated'
			END AS RateCardType
		,GRM.RateCardModeTypeID
		--,GRC.GrossRate
		,GrossRate=(case when ISnull(GRC.IsGrossRateModified,0)=1 then GRC.ModifiedGrossRate else GRC.GrossRate end)
		,GRC.SellingRates
		,GRC.TaxPercentage
		,GRC.TaxAmount
		,GRC.NetAmountIncludingTax
		,GRC.NetAmountExcludingTax
		--,isnull(O.Disclaimer, 'NA') AS Disclaimer
		,GRM.Disclaimer,
		ISNULL(CONVERT(VARCHAR, GRM.FromDate, 103), '') +
    ' - ' +
    ISNULL(NULLIF(LTRIM(RTRIM(CONVERT(VARCHAR, GRM.ToDate, 103))), ''), CONVERT(VARCHAR, GRM.FromDate, 103)) AS FromToDate

		--,ISNULL(CONVERT(VARCHAR, GRM.ValidFrom, 103), '') + ' - ' + ISNULL(CONVERT(VARCHAR, GRM.ValidTo, 103), '') AS FromToDate
		,GRC.Markup_IsRate
		,GRC.MarkupRate
		,GRM.ReasonID
		,O.QuotationID
		,CASE
			WHEN IsCustom=0 THEN 'RateCard'
			WHEN IsCustom=1 THEN 'CustomRateCard' 
		end 
		as Type,
		O.Currency AS QuoCurrency,
		dbo.fnGetPurchaseRate(GRM.CurrencyID, O.Currency, GETDATE()) AS PurchaseRate,
		GRM.IsSummary,
<<<<<<< HEAD
<<<<<<< HEAD
=======
        GRM.ShowValueAddOns,
		GRM.FromDate as StartDate,
		GRM.ToDate as EndDate,
>>>>>>> dev
=======
        GRM.ShowValueAddOns,
		GRM.FromDate as StartDate,
		GRM.ToDate as EndDate,
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
		(
    SELECT RHM.Notes
    FROM  RateCards.GuideRateMaster RHM 
   
    WHERE RHM.GuideRateID = GRM.RateId
) AS ValueAddOn 
	FROM Quotation.OthersRateCardMaster GRM
	INNER JOIN Quotation.QuotationMaster O ON O.QuotationId = GRM.QuotationID
	INNER JOIN Quotation.OthersRateCardCommission GRC ON GRC.OthersRateRefrenceID = GRM.ID
	LEFT JOIN [Language] L ON L.ID = GRM.LanguageID
	LEFT JOIN City CT ON CT.IATACode = GRM.CityID
	LEFT JOIN VendorMaster VM ON VM.VendorID = GRM.VendorID
	LEFT JOIN GuideServices GS ON GS.Code = GRM.ServiceID
	LEFT JOIN Currency C ON C.Code = GRM.CurrencyID
	WHERE GRM.QuotationID = @QuotationID
		AND GRM.RateType = 1
		AND isnull(GRM.IsActive, 0) = 1
<<<<<<< HEAD
<<<<<<< HEAD
	order by GRM.ID desc
=======
	order by GRM.FromDate,Grm.ToDate desc
>>>>>>> dev
=======
	order by GRM.FromDate,Grm.ToDate desc
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
--monument
	SELECT 
	'Monument' AS ServiceType,
	MRM.ID AS QMID,
	MRM.RateId AS MonumentRateID,
	MRM.ReferenceRateDetailID AS MonumentDetailID,
	CASE
			WHEN IsCustom=0 THEN 'RateCard'
			WHEN IsCustom=1 THEN 'CustomRateCard' 
		end 
		as Type,

	-- Commission JSON aggregation
	(
		SELECT 
		 CRC.ID AS OthersRateCardCommissionID,
			CRC.CommissionRefrenceID AS MonumentCommissionDetailID,
			CRC.CommissionMasterID,
			RCM.RateType ,
			CRC.TaxPercentage,
			CRC.TaxAmount,
			CRC.NetAmountExcludingTax,
			CRC.NetAmountIncludingTax,
			--CRC.GrossRate,
			GrossRate=(case when ISnull(CRC.IsGrossRateModified,0)=1 then CRC.ModifiedGrossRate else CRC.GrossRate end),
			CRC.SellingRates,
			CRC.Markup_IsRate,
			CRC.MarkupRate,
			CRC.AdultReasonId,
			CRC.ChildReasonId
		FROM Quotation.OthersRateCardCommission CRC
		LEFT JOIN RateCommissionMaster RCM ON RCM.CommMasterID = CRC.CommissionMasterID
		WHERE CRC.OthersRateRefrenceID = MRM.ID
		FOR JSON PATH
	) AS CommissionDetailsJson,

	CT.Name AS City,
	VM.VendorName,
	MS.Name AS MonumentService,
	N.Nationality,
	CAST(MRM.ValidFrom AS DATE) AS ValidFrom,
	CAST(MRM.ValidTo AS DATE) AS ValidTo,
	CASE MRM.RateCardModeTypeID
		WHEN 1 THEN 'Contract'
		WHEN 2 THEN 'Adhoc'
		WHEN 3 THEN 'Negotiated'
	END AS RateCardModeType,
	MRM.RateCardModeTypeID,
	MRM.TaxID,
	MRM.CardNumber,
	MRM.Heading,
	MRM.ContractDate,
	MRM.CurrencyID,
	MRM.StateID,
	MRM.VendorID,
	MRM.InfoForOperation,
	MRM.InfoForAgent,
	MRM.InfoForRemark,
	MRM.IsActive,
	MRM.CreatedOn,
	MRM.UpdatedOn,
	MRM.GSTStatus,
	MRM.CityID,
	MS.ClosedOn,
	MS.ID AS MonumentServiceID,
	MRM.NationalityID,
	MRM.MISSequence,
	--ISNULL(O.Disclaimer, 'NA') AS Disclaimer,
	MRM.Disclaimer,
	ISNULL(CONVERT(VARCHAR, MRM.FromDate, 103), '') +
    ' - ' +
    ISNULL(NULLIF(LTRIM(RTRIM(CONVERT(VARCHAR, MRM.ToDate, 103))), ''), CONVERT(VARCHAR, MRM.FromDate, 103)) AS FromToDate

	--ISNULL(CONVERT(VARCHAR, MRM.FromDate, 103), '') + ' - ' + ISNULL(CONVERT(VARCHAR, MRM.ToDate, 103), '') AS FromToDate,
	,MRM.ReasonID,
	O.QuotationID,
	O.Currency AS QuoCurrency,
		dbo.fnGetPurchaseRate(MRM.CurrencyID, O.Currency, GETDATE()) AS PurchaseRate,
<<<<<<< HEAD
<<<<<<< HEAD
		MRM.IsSummary
=======
		MRM.IsSummary,
		MRM.FromDate as StartDate,
		MRM.ToDate as EndDate
>>>>>>> dev
=======
		MRM.IsSummary,
		MRM.FromDate as StartDate,
		MRM.ToDate as EndDate
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
FROM Quotation.OthersRateCardMaster MRM
INNER JOIN Quotation.QuotationMaster O ON O.QuotationId = MRM.QuotationID
LEFT JOIN Nationality N ON N.ID = MRM.NationalityID
LEFT JOIN City CT ON CT.IATACode = MRM.CityID
LEFT JOIN VendorMaster VM ON VM.VendorID = MRM.VendorID
LEFT JOIN MonumentService MS ON MS.ID = MRM.ServiceID
LEFT JOIN Currency Cu ON Cu.Code = MRM.CurrencyID
WHERE MRM.QuotationID = @QuotationID
  AND MRM.RateType = 2
  AND ISNULL(MRM.IsActive, 0) = 1
<<<<<<< HEAD
<<<<<<< HEAD
  order by MRM.ID  desc
=======
  	order by MRM.FromDate,MRM.ToDate desc
>>>>>>> dev
=======
  	order by MRM.FromDate,MRM.ToDate desc
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6


	--Transport
	SELECT 'Transport' AS ServiceType
		,TRM.ID AS TQTID
		,TRM.RateId AS TransportRateID
		,TRM.ReferenceRateDetailID AS TransportRateDetailID
		,CT.Name AS City
		,TS.Name AS TransportService
		,VTM.VehicleType
		,TRM.ValidFrom
		,TRM.ValidTo
		,CurrencyID AS Currency
		,TRM.CardNumber
		,TRM.ContractDate
		,TRM.CurrencyID
		,TRM.StateID
		,TRM.VendorID
		,VM.VendorName
		,TRM.InfoForOperation
		,TRM.InfoForAgent
		,TRM.InfoForRemark
		,TRM.IsActive
		,TRM.CreatedOn
		,TRM.UpdatedOn
		,TRM.GSTStatus
		,TRM.RateCardModeTypeID
		,TRM.CityID
		,TRm.TaxID
		,TRM.SERVICEID AS TransportServceID
		--,isnull(O.Disclaimer, 'NA') AS Disclaimer
		,TRM.Disclaimer
		,CASE
			WHEN IsCustom=0 THEN 'RateCard'
			WHEN IsCustom=1 THEN 'CustomRateCard' 
		end 
		as Type
		,CASE TRM.RateCardModeTypeID
			WHEN 1
				THEN 'Contract'
			WHEN 2
				THEN 'Adhoc'
			WHEN 3
				THEN 'Negotiated'
			END AS RateCardModeType
		,TS.ModeOfTransport
		,CASE 
			WHEN TS.ModeOfTransport IN (
					1
					,2
					)
				THEN 1
			ELSE 0
			END AS Arrival
		,CASE 
			WHEN TS.ModeOfTransport = 1
				THEN 1
			ELSE 0
			END AS Departure
		,VTM.ID AS VehicleCategoryID
		,ISNULL(CONVERT(VARCHAR, TRM.FromDate, 103), '') +
    ' - ' +
    ISNULL(NULLIF(LTRIM(RTRIM(CONVERT(VARCHAR, TRM.ToDate, 103))), ''), CONVERT(VARCHAR, TRM.FromDate, 103)) AS FromToDate

		--,ISNULL(CONVERT(VARCHAR, TRM.FromDate, 103), '') + ' - ' + ISNULL(CONVERT(VARCHAR, TRM.ToDate, 103), '') AS FromToDate
		,TRM.ReasonID
		,O.QuotationID
		,(
			SELECT *
			FROM (
				SELECT TRCD.ID AS OthersRateCardCommissionID,
				TRCD.CommissionRefrenceID AS TransportCommissionDetailID
					,TRCD.CommissionMasterID
					,RCM.RateType
					,TRCD.TaxAmount
					,TRCD.NetAmountExcludingTax
					,TRCD.NetAmountIncludingTax
					,TRCD.Markup_IsRate
					,TRCD.MarkupRate
					--,GrossRate=(case when ISnull(TRCD.IsGrossRateModified,0)=1 then TRCD.ModifiedGrossRate else TRCD.GrossRate end)
					,iSNULL(TRCD.ModifiedGrossRate,GrossRate) as GrossRate
					,TRCD.SellingRates
					,'Detail' AS CommissionType
				--FROM Quotation.OthersRateCardCommission TRCD
				--INNER JOIN RateCommissionMaster RCM ON RCM.CommMasterID = TRCD.CommissionMasterID
				--WHERE TRCD.OthersRateRefrenceID= TRM.ID
				FROM Quotation.OthersRateCardCommission TRCD
				LEFT JOIN RateCommissionMaster RCM ON TRCD.CommissionMasterID = RCM.CommMasterID
				WHERE TRCD.OthersRateRefrenceID = TRM.ID
					AND isnull(TRCD.IsActive, 0) = 1
				) AS CombinedCommissions
			FOR JSON PATH
			) AS TransportRateCommissionDetails,
			O.Currency AS QuoCurrency,
		dbo.fnGetPurchaseRate(TRM.CurrencyID, O.Currency, GETDATE()) AS PurchaseRate,
<<<<<<< HEAD
<<<<<<< HEAD
		TRM.IsSummary
=======
		TRM.IsSummary,
		TRM.FromDate as StartDate,
		TRM.ToDate as EndDate
>>>>>>> dev
=======
		TRM.IsSummary,
		TRM.FromDate as StartDate,
		TRM.ToDate as EndDate
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
	--FROM RateCards.TransportRateMaster TRM
	--INNER JOIN RateCards.TransportRateDetails TRD ON TRD.TransportRateID = TRM.TransportRateID 
	FROM Quotation.OthersRateCardMaster TRM
	INNER JOIN Quotation.QuotationMaster O ON O.QuotationId = TRM.QuotationID
	LEFT JOIN VendorMaster VM ON VM.VendorID = TRM.VendorID
	LEFT JOIN City CT ON CT.IATACode = TRM.CityID
	INNER JOIN TransportServices TS ON TS.Code = TRM.ServiceID
	LEFT JOIN VehicleTypeMaster VTM ON VTM.ID = TRM.VehicleCategoryID
	WHERE TRM.QuotationID = @QuotationId
		AND TRM.RateType = 3
		AND isnull(TRM.IsActive, 0) = 1

<<<<<<< HEAD
<<<<<<< HEAD
		order by TRM.ID desc
=======
		--order by TRM.ID desc
			order by TRM.FromDate,TRM.ToDate desc
>>>>>>> dev
=======
		--order by TRM.ID desc
			order by TRM.FromDate,TRM.ToDate desc
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

	--SpecialService
	

	SELECT 
    'Special Service' AS ServiceType,
    SSRM.ID AS QSSMID,
    SSRM.RateId AS SpecialServiceRateID,
    SSRM.ReferenceRateDetailID AS SpecialServiceRateDetailID,
    CT.Name AS City,
    VM.VendorName,
    CT.ID AS CityID,
    N.Nationality,
    SS.Name AS [TransportService],
    SSRM.TaxID,
    CONVERT(VARCHAR, SSRM.ValidFrom, 106) AS [ValidFrom],
    CONVERT(VARCHAR, SSRM.ValidTo, 106) AS [ValidTo],
    SSRM.CurrencyID AS Currency,
    --ISNULL(O.Disclaimer, 'NA') AS Disclaimer,
	SSRM.Disclaimer,
    SSRM.InfoForOperation,
    SSRM.InfoForRemark,
    SSRM.NationalityID,
    CASE SSRM.RateCardModeTypeID
        WHEN 1 THEN 'Contract'
        WHEN 2 THEN 'Adhoc'
        WHEN 3 THEN 'Negotiated'
    END AS RateCardType,
    SSRM.CardNumber,
    SSRM.RateCardModeTypeID,
    SS.ID AS SpecialServiceID,
    SSRM.ContractDate,
    SSRM.StateID,
    SSRM.VendorID,
    SSRM.InfoForAgent,
    SSRM.IsActive,
    SSRM.GSTStatus,
    SSRM.CityID,
    SS.Name AS SpecialService,
    SSRM.VendorID,
    SSRM.HotelID,
	ISNULL(CONVERT(VARCHAR, SSRM.FromDate, 103), '') +
    ' - ' +
    ISNULL(NULLIF(LTRIM(RTRIM(CONVERT(VARCHAR, SSRM.ToDate, 103))), ''), CONVERT(VARCHAR, SSRM.FromDate, 103)) AS FromToDate

    --ISNULL(CONVERT(VARCHAR, SSRM.FromDate, 103), '') + ' - ' + ISNULL(CONVERT(VARCHAR, SSRM.ToDate, 103), '') AS FromToDate,
    ,SSRM.ReasonID,
    O.QuotationID,
	CASE
			WHEN IsCustom=0 THEN 'RateCard'
			WHEN IsCustom=1 THEN 'CustomRateCard' 
		end 
		as Type,
		 CA.MinimumPax,
    CA.MaximumPax,
    CA.PaxRange,

    -- JSON commissions with RateType included
    (
        SELECT 
		SCRD.ID as OthersRateCardCommissionID,
            SCRD.CommissionRefrenceID AS SpecialServiceRateCommissionID,
            SCRD.CommissionMasterID,
            SCRD.MinimumPax,
            SCRD.MaximumPax,
            SCRD.TaxPercentage,
            SCRD.TaxAmount,
            SCRD.SellingRates,
            --SCRD.GrossRate,
			GrossRate=(case when ISnull(SCRD.IsGrossRateModified,0)=1 then SCRD.ModifiedGrossRate else SCRD.GrossRate end),
            SCRD.Markup_IsRate,
            SCRD.MarkupRate,
            COALESCE(RCM.RateType, 'Consolidated') AS RateType,
			CONVERT(VARCHAR, SCRD.MinimumPax) + ' - ' + CONVERT(VARCHAR, SCRD.MaximumPax) AS PaxRange,
			isnull(SCRD.AdultReasonId,0) as AdultReasonId,
			isnull(SCRD.ChildReasonId,0) as ChildReasonId
        FROM Quotation.OthersRateCardCommission SCRD
        LEFT JOIN RateCommissionMaster RCM ON RCM.CommMasterID = SCRD.CommissionMasterID
        WHERE SCRD.OthersRateRefrenceID = SSRM.ID
        FOR JSON PATH
    ) AS SpecialServiceRateCommissionDetails,
	O.Currency AS QuoCurrency,
		dbo.fnGetPurchaseRate(SSRM.CurrencyID, O.Currency, GETDATE()) AS PurchaseRate,
<<<<<<< HEAD
<<<<<<< HEAD
		SSRM.IsSummary
=======
		SSRM.IsSummary,
		SSRM.FromDate as StartDate,
		SSRM.ToDate as EndDate
>>>>>>> dev
=======
		SSRM.IsSummary,
		SSRM.FromDate as StartDate,
		SSRM.ToDate as EndDate
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

FROM Quotation.OthersRateCardMaster SSRM
INNER JOIN Quotation.QuotationMaster O ON O.QuotationId = SSRM.QuotationID
LEFT JOIN Nationality N ON N.ID = SSRM.NationalityID
LEFT JOIN City CT ON CT.IATACode = SSRM.CityID
LEFT JOIN VendorMaster VM ON VM.VendorID = SSRM.VendorID
LEFT JOIN HotelMaster HM ON HM.HotelID = SSRM.HotelID
LEFT JOIN SpecialServices SS ON SS.ID = SSRM.ServiceID
LEFT JOIN Currency Cu ON Cu.Code = SSRM.CurrencyID

-- CROSS APPLY to fetch first commission record
OUTER APPLY (
    SELECT TOP 1 
        SCRD.MinimumPax,
        SCRD.MaximumPax,
        CONVERT(VARCHAR, SCRD.MinimumPax) + ' - ' + CONVERT(VARCHAR, SCRD.MaximumPax) AS PaxRange
    FROM Quotation.OthersRateCardCommission SCRD
    WHERE SCRD.OthersRateRefrenceID = SSRM.ID
    ORDER BY SCRD.CommissionRefrenceID
) CA

WHERE O.QuotationID = @QuotationId
  AND SSRM.RateType = 4
 AND ISNULL(SSRM.IsActive, 0) = 1
<<<<<<< HEAD
<<<<<<< HEAD
 	order by SSRM.ID desc;
=======
 	--order by SSRM.ID desc;
		order by SSRM.FromDate,SSRM.ToDate desc
>>>>>>> dev
=======
 	--order by SSRM.ID desc;
		order by SSRM.FromDate,SSRM.ToDate desc
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6


		--Hotel
	SELECT 
		Distinct
		'Hotel' AS ServiceType
	,HRM.ID AS QuoHotelRateID
		,HRM.HotelRateID AS HotelRateID
		,HRM.HotelRateDetailID AS HotelRateDetailID
		
		,H.HotelID
		,H.HotelName+' '+HR.Code as HotelName
		,HRM.CityID
		,(SELECT TOP 1 Name from City where IATACode=HRM.CityID) as CityName
		,HRM.RoomCategoryID
		,RoomCat.Name AS RoomCategory
		,HRM.Days
		,CONCAT (
			CASE 
				WHEN SUBSTRING(HRM.Days, 1, 1) = '1'
					THEN 'M'
				ELSE ''
				END
			,CASE 
				WHEN SUBSTRING(HRM.Days, 2, 1) = '1'
					THEN 'T'
				ELSE ''
				END
			,CASE 
				WHEN SUBSTRING(HRM.Days, 3, 1) = '1'
					THEN 'W'
				ELSE ''
				END
			,CASE 
				WHEN SUBSTRING(HRM.Days, 4, 1) = '1'
					THEN 'T'
				ELSE ''
				END
			,CASE 
				WHEN SUBSTRING(HRM.Days, 5, 1) = '1'
					THEN 'F'
				ELSE ''
				END
			,CASE 
				WHEN SUBSTRING(HRM.Days, 6, 1) = '1'
					THEN 'S'
				ELSE ''
				END
			,CASE 
				WHEN SUBSTRING(HRM.Days, 7, 1) = '1'
					THEN 'S'
				ELSE ''
				END
			) AS DaysOfWeek
		,
		CASE WHEN HRM.DAYS = '1111111' THEN 'ALL'
				ELSE
					CONCAT (
					CASE 
						WHEN SUBSTRING(HRM.Days, 1, 1) = '1'
							THEN '1'
						ELSE '-'
						END
					,CASE 
						WHEN SUBSTRING(HRM.Days, 2, 1) = '1'
							THEN '2'
						ELSE '-'
						END
					,CASE 
						WHEN SUBSTRING(HRM.Days, 3, 1) = '1'
							THEN '3'
						ELSE '-'
						END
					,CASE 
						WHEN SUBSTRING(HRM.Days, 4, 1) = '1'
							THEN '4'
						ELSE '-'
						END
					,CASE 
						WHEN SUBSTRING(HRM.Days, 5, 1) = '1'
							THEN '5'
						ELSE '-'
						END
					,CASE 
						WHEN SUBSTRING(HRM.Days, 6, 1) = '1'
							THEN '6'
						ELSE '-'
						END
					,CASE 
						WHEN SUBSTRING(HRM.Days, 7, 1) = '1'
							THEN '7'
						ELSE '-'
						END
					)
				END AS DaysNumber,
		-- New: MealPlan info
		MP.Code AS MealPlanCode
		,MP.Breakfast
		,MP.Lunch
		,MP.Dinner
		--,isnull(QM.Disclaimer, 'NA') AS Disclaimer
		--,isnull(HRM.Disclaimer, 'NA') AS Disclaimer
		,HRM.Disclaimer
		,hrm.OfferTypeID
		,ISNULL(CONVERT(VARCHAR, HRM.CheckIn, 103), '') + ' - ' + ISNULL(CONVERT(VARCHAR, HRM.CheckOut, 103), '') AS FromToDate
		,QM.QuotationID
		,HRM.CurrencyID AS Currency
		,dbo.fnGetPurchaseRate(HRM.CurrencyID, QM.Currency, GETDATE()) AS PurchaseRate
		,HRM.ShowAnnouncement
		,HRM.ShowTransfers
		,HRM.ShowValueAddOns
		,HRM.ShowCancellationDays,
		CASE
			WHEN IsCustom=0 THEN 'RateCard'
			WHEN IsCustom=1 THEN 'CustomRateCard' 
		end 
		as Type,
		(
    SELECT TM.TransferValue 
    FROM RateCards.HotelRateDetails RCD 
    INNER JOIN dbo.TransferMaster TM ON RCD.TransferID = TM.TransferID
    WHERE RCD.HotelRateDetailID = HRM.HotelRateDetailID
) AS TransferValue,
 
-- Hotel Announcements JSON
(
    SELECT 
        C.Name AS City,
        HA.AnnouncementDetails,
        CONVERT(VARCHAR(12), HA.ValidTo, 106) AS ValidTill,
        HA.AnnouncementID,
        HA.ValidTo
    FROM HotelAnnouncement HA
    INNER JOIN City C ON C.IATACode = H.CityIATACode
    WHERE HA.HotelID = HRM.HotelID
    FOR JSON PATH
) AS HotelAnnouncementsJSON,

(
    SELECT RHM.ValueAddOn
    FROM  RateCards.HotelRateMaster RHM 
   
    WHERE RHM.HotelRateID = HRM.HotelRateID
) AS ValueAddOn ,

(SELECT PolicyID,RateCardTypeID,RateCardID,ValidFrom,ValidTo,TsStart,TsEnd,AgentStart,AgentEnd,ChangePercent,ChargeNight,IsActive 
			FROM RateCards.CancellationPolicy RCP WHERE   RCP.RateCardID = HRM.HotelRateID   FOR JSON PATH) CancellationPolicyJSON,

		-- Commission JSON
		(
			SELECT RC.QuotationHotelRateCommissionId AS OthersRateCardCommissionID,
			RC.QuotationHotelRateCommissionId AS RateCommissionID
				,RC.CommissionMasterID
				,RC.CommissionMasterID AS MasterCommissionID
				,RCM.RateType
				,-- Mapped via join
				RC.TaxPercentage
				,RC.TaxAmount
				,RC.GrossAmountIncludingTax AS GrossAmountIncludingTax
				,
				--dbo.fnSearchCalculateROE(ISNULL(RC.GrossAmountIncludingTax, 0), @CheckIn, C1.Code, @CurrencyCode) AS GrossAmountIncludingTax,
				RC.GrossAmountIncludingTax * dbo.fnGetPurchaseRate(C1.Code, QM.Currency, GETDATE()) AS GrossAmountIncludingTax_Con
				,RC.GrossAmountExcludingTax AS GrossAmountExcludingTax
				,
				--dbo.fnSearchCalculateROE(ISNULL(RC.GrossAmountExcludingTax, 0), @CheckIn, C1.Code, @CurrencyCode) as GrossAmountExcludingTax,
				RC.GrossAmountExcludingTax * dbo.fnGetPurchaseRate(C1.Code, QM.Currency, GETDATE()) AS GrossAmountExcludingTax_Con
				,
				--RC.CommisionPercentage,
				--      RC.CommissionAmount as CommissionAmount,
				--      --dbo.fnSearchCalculateROE(ISNULL(RC.CommissionAmount, 0), @CheckIn, C1.Code, @CurrencyCode) AS CommissionAmount,
				--RC.CommissionAmount * dbo.fnGetPurchaseRate(C1.Code,QM.Currency,  GETDATE()) AS CommissionAmount_Con,
				RC.NetAmountIncludingTax AS NetAmountIncludingTax
				,
				--dbo.fnSearchCalculateROE(ISNULL(RC.NetAmountIncludingTax, 0), @CheckIn, C1.Code, @CurrencyCode) as NetAmountIncludingTax,
				RC.NetAmountIncludingTax * dbo.fnGetPurchaseRate(C1.Code, QM.Currency, GETDATE()) AS NetAmountIncludingTax_Con
				,RC.NetAmountExcludingTax AS NetAmountExcludingTax
				,
				--dbo.fnSearchCalculateROE(ISNULL(RC.NetAmountExcludingTax, 0), @CheckIn, C1.Code, @CurrencyCode) as NetAmountExcludingTax,
				RC.NetAmountExcludingTax * dbo.fnGetPurchaseRate(C1.Code, QM.Currency, GETDATE()) AS NetAmountExcludingTax_Con
				,RC.CommisionPercentage
				,GrossRate=(case when ISnull(RC.IsGrossRateModified,0)=1 then RC.ModifiedGrossRate else RC.GrossRate end)
				,RC.IsMarkup
				,RC.MarkupValue
				,RC.SellingRate as SellingRates
				,RC.IsActive
				,RC.IsMarkup AS Markup_IsRate
				,RC.MarkupValue MarkupRate
				,RC.ReasonMasterId AS ReasonID,
				RC.Disclaimer
			FROM Quotation.HotelRateCommissionDetails RC
			--INNER JOIN RateCommissionMaster RCM ON RC.CommissionMasterID = RCM.CommMasterID
			left JOIN RateCommissionMaster RCM ON RC.CommissionMasterID = RCM.CommMasterID
			WHERE RC.QuotationHotelRateID = HRM.ID AND  isnull(RC.IsActive, 0) = 1
			FOR JSON PATH
			) AS CommissionJSON
		,
		-- Meal Overview JSON
		(
			SELECT
				--M.HotelRateMealID,
				--M.QuotationHotelRateMealId AS HotelRateMealID
				M.QuotationHotelRateMealId AS OthersRateCardMealID,
				M.MealTypeID as HotelRateMealID
				,MealType.RateType AS MealType
				,M.GstPercentage
				,M.GstAmount
				,M.SellingRate as SellingRates
				,M.MasterCommissionID
				,M.IsMealDetails
				,M.DefineAmount
				,
				-- Conditionally select NetAmount based on @TaxID
				M.NetAmountIncludingTax AS NetAmountIncludingTax
				,
				--dbo.fnSearchCalculateROE(M.NetAmountIncludingTax, @CheckIn, C1.Code, @CurrencyCode) AS NetAmountIncludingTax,
				M.NetAmountIncludingTax * dbo.fnGetPurchaseRate(C1.Code, QM.Currency, GETDATE()) AS NetAmountIncludingTax_Con
				,M.NetAmountExcludingTax AS NetAmountExcludingTax
				,
				--dbo.fnSearchCalculateROE(M.NetAmountExcludingTax, @CheckIn, C1.Code, @CurrencyCode) AS NetAmountExcludingTax,
				M.NetAmountExcludingTax * dbo.fnGetPurchaseRate(C1.Code, QM.Currency, GETDATE()) AS NetAmountExcludingTax_Con,
				M.ReasonMasterId AS ReasonID,
				M.Disclaimer,
				ISNULL(M.IsSupplementary,0) as IsSupplementary,
				ISNULL(M.IsGross,0) as IsGross,
				ISNULL(M.IsSupplementaryPer,0) as IsSupplementaryPer,
				ISNULL(M.SupplementaryAmt,0) as SupplementaryAmt,
				ISNULL(M.GrossRate,0) as GrossRate
			FROM Quotation.HotelRateMealPlanMaster M
			LEFT JOIN RateCommissionMaster MealType ON M.MasterCommissionID = MealType.CommMasterID
			WHERE M.QuotationHotelRateID = HRM.ID
				AND M.IsActive = 1
			FOR JSON PATH
			) AS MealOverviewJSON
		,(
			SELECT OC.OfferID
				,OC.HotelRateDetailID
				,OC.Days
				,OC.FromDate
				,OC.ToDate
				,OC.TotalNights
				,OC.PaidNights
				,OC.FreeNights
				,OC.IsExtendible
				,OC.IsActive
				,
				-- OfferType label based on OfferTypeID from parent RCD
				CASE 
					WHEN HRM.OfferTypeID = 1
						THEN 'EBO'
					WHEN HRM.OfferTypeID = 2
						THEN 'PayOnStay'
					ELSE 'Unknown'
					END AS OfferType
				,
				-- Offer Commission as nested JSON array including RateType
				(
					SELECT OCC.OfferCommissionID
						,OCC.OfferConfigurationID
						,OCC.MasterCommissionID
						,RCM.RateType
						,-- added from RateCommissionMaster
						OCC.Discount
						,OCC.DiscountAmount
						,OCC.Tax
						,OCC.TaxAmount
						,OCC.PaidNightAmountExcludingTax
						,OCC.PaidNightAmountIncludingTax
						,OCC.FreeNightAmountExcludingTax
						,OCC.FreeNightAmountIncludingTax
						,OCC.GrossAmountExcludingTax
						,OCC.GrossAmountIncludingTax
						,OCC.NetAmountExcludingTax
						,OCC.NetAmountIncludingTax
						,OCC.IsActive
					FROM RateCards.HotelRateOfferConfigurationCommission OCC
					LEFT JOIN RateCommissionMaster RCM ON OCC.MasterCommissionID = RCM.CommMasterID
					WHERE OCC.OfferConfigurationID = OC.OfferID
						AND OCC.IsActive = 1
					FOR JSON PATH
					) AS OfferCommission
			FROM RateCards.HotelRateOfferConfiguration OC
			INNER JOIN RATECARDS.HotelRateDetails RD ON RD.HotelRateDetailID = OC.HotelRateDetailID
			INNER JOIN RATECARDS.HotelRateMaster HM ON HM.HotelRateID = RD.HotelRateID
			WHERE HM.HotelRateID = HRM.HotelRateID
				AND OC.IsActive = 1
			FOR JSON PATH
			) AS OfferConfigurationJSON,
			HRM.IsSummary
			,HRM.CheckIn,HRM.CheckOut,
			HRM.RateCardModeTypeID,
			--isnull(IsSupplementaryPer,0) as IsSupplementaryPer,
			--isnull(SupplementaryAmt,0) AS SupplementaryAmt
			(
				SELECT 
					CASE WHEN MAX(CAST(ISNULL(M.IsSupplementaryPer, 0) AS INT)) = 1 
						 THEN 1 ELSE 0 END 
				FROM 
					Quotation.HotelRateMealPlanMaster M
				WHERE 
					M.QuotationHotelRateID = HRM.Id
			) AS IsSupplementaryPer,
			(
				SELECT 
					TOP 1
					MAX(ISNULL(M.SupplementaryAmt, 0)) 
				FROM 
					Quotation.HotelRateMealPlanMaster M
				WHERE 
					M.QuotationHotelRateID = HRM.Id
			)
			AS SupplementaryAmt
	FROM Quotation.HotelRateCardMaster HRM
	INNER JOIN Quotation.QuotationMaster QM ON QM.QuotationId = HRM.QuotationID
	INNER JOIN HotelMaster H ON HRM.HotelID = H.HotelID
	INNER JOIN HotelRating HR ON HR.ID = H.HotelRatingID
	--INNER JOIN Currency C1 ON HRM.CurrencyID = C1.CurrencyID
	LEFT JOIN Currency C1 ON HRM.CurrencyId = C1.Code
	LEFT JOIN HotelRoomCategory HRC ON HRM.HotelID = HRC.HotelID
		AND HRC.RoomCategoryID = HRM.RoomCategoryID
	LEFT JOIN RoomCategory RoomCat ON HRM.RoomCategoryID = RoomCat.ID
	LEFT JOIN MealPlan MP ON HRM.MealPlanID = MP.ID
		AND MP.IsActive = 1
	WHERE HRM.QuotationID = @QuotationId
		AND isnull(HRM.IsActive, 0) = 1
		--order by HRM.ID desc
				order by HRM.CheckIn,HRM.CheckOut desc

	SET NOCOUNT OFF;
END
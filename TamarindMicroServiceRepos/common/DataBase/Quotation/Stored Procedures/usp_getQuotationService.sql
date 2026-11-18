--declare
--	@QuotationId int= 31,
--	@Action char(1)='S'
CREATE procedure [Quotation].[usp_getQuotationService]
	@QuotationId int= null,
	@Action char(1)=null
AS
BEGIN
	--Guide 1
	--Monument 2
	--Transport 3
	--Special Service 4
	--Hotel 5

	If(ISNULL(@QuotationId,0)<>0 AND @Action='S')
		BEGIN
			--Table 0 GUIDE
			Select 
				DISTINCT
				O.ID,
				ReferenceRateDetailID,
				O.QuotationID,
				QM.QuotationNo,
				O.CityID,
				C.Name as CityName,
				ISNULL(CONVERT(varchar,ValidFrom,103),'')+ ' - '+ISNULL(CONVERT(varchar,ValidTo,103),'') as FromToDate,
				Heading as ServiceName,
				GS.Name as GuideService,
				LanguageID,
				ISNULL(Language,'-') as Language,
			
				 QM.RateCardMode,
				 isnull(QM.Disclaimer,'NA') as Disclaimer,
    (
        SELECT 
            STRING_AGG(
                CASE value
                    WHEN '1' THEN 'Contract'
                    WHEN '2' THEN 'Adhoc'
                    WHEN '3' THEN 'Negotiated'
                    ELSE 'Unknown'
                END, ','
            )
        FROM STRING_SPLIT(QM.RateCardMode, ',')
    ) AS RateCardType,
				
				--CASE
				--	WHEN 
				--		QM.TaxType=1
				--	THEN
				--		--Tax on Sales Amount = (Gross Amount + Mark-Up) * Tax on Sales % 
				--		--Occupancy Selling Amount Formula = Gross Amount + Mark-Up + Tax on Sales Amount 
				--		convert(nvarchar,FORMAT(CAST(cast((
				--			((isnull(OC.GrossRate,0)+isnull(OC.MarkupRate,0))*(ISNULL(QM.TaxonSale, 0) / 100.0))
				--			+
				--			(isnull(OC.GrossRate,0)+isnull(OC.MarkupRate,0))
				--		)as money) AS INT), 'N0', 'en-IN')) 

							
				--	ELSE
				--		convert(nvarchar,FORMAT(CAST(cast((
				--			(isnull(OC.GrossRate,0)+isnull(OC.MarkupRate,0))
				--		)as money) AS INT), 'N0', 'en-IN')) 
							
				--END
				--as SellingRate,
				'Guide' as ServiceType,
				
				-- Commission JSON
				(
					SELECT 
						OC.ID AS OthersRateCardCommissionId,
						OC.CommissionMasterID,
						RCM.RateType,  
						CONVERT(varchar,ISNULL(MinimumPax,0))+' - '+CONVERT(varchar,ISNULL(MaximumPax,0)) as PaxRange,
						--CASE
						--	WHEN 
						--		QM.TaxType=1
						--	THEN
						--		--Tax on Sales Amount = (Gross Amount + Mark-Up) * Tax on Sales % 
						--		--Occupancy Selling Amount Formula = Gross Amount + Mark-Up + Tax on Sales Amount 
						--		convert(nvarchar,FORMAT(CAST(cast((
						--			((isnull(OC.GrossRate,0)+isnull(OC.MarkupRate,0))*(ISNULL(QM.TaxonSale, 0) / 100.0))
						--			+
						--			(isnull(OC.GrossRate,0)+isnull(OC.MarkupRate,0))
						--		)as money) AS INT), 'N0', 'en-IN')) 

							
						--	ELSE
						--		convert(nvarchar,FORMAT(CAST(cast((
						--			(isnull(OC.GrossRate,0)+isnull(OC.MarkupRate,0))
						--		)as money) AS INT), 'N0', 'en-IN')) 
							
						--END
						--as SellingRate
						isnull(SellingRates,0) as SellingRate
						FROM 
							Quotation.OthersRateCardCommission OC 
							LEFT JOIN RateCommissionMaster RCM ON OC.CommissionMasterID = RCM.CommMasterID
						WHERE 
							OC.OthersRateRefrenceID=O.ID
							AND isnull(OC.IsActive,0) = 1
						FOR JSON PATH
				) AS CommissionJSON
			FROM
				Quotation.OthersRateCardMaster O
				INNER JOIN Quotation.QuotationMaster QM ON QM.QuotationId=O.QuotationID
				--LEFT JOIN Quotation.OthersRateCardCommission OC ON O.ID=OC.OthersRateRefrenceID
				LEFT JOIN City C ON O.CityID=C.IATACode
				LEFT JOIN Language L ON L.ID=O.LanguageID
				 LEFT JOIN VendorMaster VM  ON VM.VendorID = O.VendorID
    LEFT JOIN GuideServices GS ON GS.Code = O.ServiceID
			WHERE
				O.QuotationID=@QuotationId
				AND O.RateType=1
				AND isnull(O.IsActive,0)=1




			--Table 1 Monument
			Select 
				DISTINCT
				O.ID,
				ReferenceRateDetailID,
				O.QuotationID,
				QM.QuotationNo,
				O.CityID,
				C.Name as CityName,
				ISNULL(CONVERT(varchar,ValidFrom,103),'')+ ' - '+ISNULL(CONVERT(varchar,ValidTo,103),'') as FromToDate,
				Heading as ServiceName,
				N.ID as NationalityId,
				N.Nationality, 
			 QM.RateCardMode,
			 isnull(QM.Disclaimer,'NA') as Disclaimer,
    (
        SELECT 
            STRING_AGG(
                CASE value
                    WHEN '1' THEN 'Contract'
                    WHEN '2' THEN 'Adhoc'
                    WHEN '3' THEN 'Negotiated'
                    ELSE 'Unknown'
                END, ','
            )
        FROM STRING_SPLIT(QM.RateCardMode, ',')
    ) AS RateCardType,
				--CASE
				--WHEN 
				--	QM.TaxType=1
				--THEN
				--	convert(nvarchar,FORMAT(CAST(cast((
				--		((isnull(OC.GrossRateAdult,0)+isnull(OC.MarkupRate,0))*(ISNULL(QM.TaxonSale, 0) / 100.0))
				--		+
				--		(isnull(OC.GrossRateAdult,0)+isnull(OC.MarkupRate,0))
				--	)as money) AS INT), 'N0', 'en-IN')) 

							
				--ELSE
				--	convert(nvarchar,FORMAT(CAST(cast((
				--		(isnull(OC.GrossRateAdult,0)+isnull(OC.MarkupRate,0))
				--	)as money) AS INT), 'N0', 'en-IN')) 
							
				--END
				--as AdultSellingRate,
				--CASE
				--	WHEN 
				--		QM.TaxType=1
				--	THEN
				--		convert(nvarchar,FORMAT(CAST(cast((
				--			((isnull(OC.GrossRateChild,0)+isnull(OC.MarkupRate,0))*(ISNULL(QM.TaxonSale, 0) / 100.0))
				--			+
				--			(isnull(OC.GrossRateChild,0)+isnull(OC.MarkupRate,0))
				--		)as money) AS INT), 'N0', 'en-IN')) 

							
				--	ELSE
				--		convert(nvarchar,FORMAT(CAST(cast((
				--			(isnull(OC.GrossRateChild,0)+isnull(OC.MarkupRate,0))
				--		)as money) AS INT), 'N0', 'en-IN')) 
							
				--END
				--as ChildSellingRate,
				
				'Monument' as ServiceType,

				-- Commission JSON
				(
					SELECT 
						OC.ID AS OthersRateCardCommissionId,
						OC.CommissionMasterID,
						RCM.RateType,  
						CONVERT(varchar,ISNULL(MinimumPax,0))+' - '+CONVERT(varchar,ISNULL(MaximumPax,0)) as PaxRange,
						--CASE
						--	WHEN 
						--		QM.TaxType=1 AND EXISTS 
						--							(
						--								SELECT 
						--										1
						--								FROM
						--									RateCommissionMaster
						--								WHERE 
						--									RateType = 'Adult'
						--									AND CommMasterID = OC.CommissionMasterID
						--							)
						--	THEN
						--		convert(nvarchar,FORMAT(CAST(cast((
						--			((isnull(OC.GrossRate,0)+isnull(OC.MarkupRate,0))*(ISNULL(QM.TaxonSale, 0) / 100.0))
						--			+
						--			(isnull(OC.GrossRate,0)+isnull(OC.MarkupRate,0))
						--		)as money) AS INT), 'N0', 'en-IN')) 

							 
						--	WHEN
						--		EXISTS 
						--			(
						--				SELECT 
						--						1
						--				FROM
						--					RateCommissionMaster
						--				WHERE 
						--					RateType = 'Adult'
						--					AND CommMasterID = OC.CommissionMasterID
						--			)
						--	THEN
						--		convert(nvarchar,FORMAT(CAST(cast((
						--			(isnull(OC.GrossRate,0)+isnull(OC.MarkupRate,0))
						--		)as money) AS INT), 'N0', 'en-IN')) 
							
						--END
						--as AdultSellingRate,
						--CASE
						--	WHEN 
						--		QM.TaxType=1 AND EXISTS 
						--						(
						--							SELECT 
						--									1
						--							FROM
						--								RateCommissionMaster
						--							WHERE 
						--								RateType = 'Child'
						--								AND CommMasterID = OC.CommissionMasterID
						--						)
						--	THEN
						--		convert(nvarchar,FORMAT(CAST(cast((
						--			((isnull(OC.GrossRate,0)+isnull(OC.MarkupRate,0))*(ISNULL(QM.TaxonSale, 0) / 100.0))
						--			+
						--			(isnull(OC.GrossRate,0)+isnull(OC.MarkupRate,0))
						--		)as money) AS INT), 'N0', 'en-IN')) 

							
						--	WHEN
						--		EXISTS 
						--			(
						--				SELECT 
						--						1
						--				FROM
						--					RateCommissionMaster
						--				WHERE 
						--					RateType = 'Child'
						--					AND CommMasterID = OC.CommissionMasterID
						--			)
						--	THEN
						--		convert(nvarchar,FORMAT(CAST(cast((
						--			(isnull(OC.GrossRate,0)+isnull(OC.MarkupRate,0))
						--		)as money) AS INT), 'N0', 'en-IN')) 
							
						--END
						--as ChildSellingRate
						isnull(SellingRates,0) as SellingRate
					FROM 
						Quotation.OthersRateCardCommission OC 
						LEFT JOIN RateCommissionMaster RCM ON OC.CommissionMasterID = RCM.CommMasterID
					WHERE 
						OC.OthersRateRefrenceID=O.ID
						AND isnull(OC.IsActive,0) = 1
					FOR JSON PATH
				) AS CommissionJSON
			FROM
				Quotation.OthersRateCardMaster O
				INNER JOIN Quotation.QuotationMaster QM ON QM.QuotationId=O.QuotationID
				--LEFT JOIN Quotation.OthersRateCardCommission OC ON O.ID=OC.OthersRateRefrenceID
				LEFT JOIN City C ON O.CityID=C.IATACode
				LEFT JOIN Nationality N ON N.ID = O.NationalityID 
			WHERE
				O.QuotationID=@QuotationId
				AND O.RateType=2
				AND isnull(O.IsActive,0)=1
			
			
			--Table 2 Transport
			Select 
				DISTINCT
				O.ID,
				ReferenceRateDetailID,
				O.QuotationID,
				QM.QuotationNo,
				O.CityID,
				C.Name as CityName,
				ISNULL(CONVERT(varchar,O.ValidFrom,103),'')+ ' - '+ISNULL(CONVERT(varchar,O.ValidTo,103),'') as FromToDate,
				Heading as ServiceName,
				 QM.RateCardMode,
				 isnull(QM.Disclaimer,'NA') as Disclaimer,
    (
        SELECT 
            STRING_AGG(
                CASE value
                    WHEN '1' THEN 'Contract'
                    WHEN '2' THEN 'Adhoc'
                    WHEN '3' THEN 'Negotiated'
                    ELSE 'Unknown'
                END, ','
            )
        FROM STRING_SPLIT(QM.RateCardMode, ',')
    ) AS RateCardType,
				--CASE
				--	WHEN 
				--		QM.TaxType=1
				--	THEN
				--		--Tax on Sales Amount = (Gross Amount + Mark-Up) * Tax on Sales % 
				--		--Occupancy Selling Amount Formula = Gross Amount + Mark-Up + Tax on Sales Amount 
				--		convert(nvarchar,FORMAT(CAST(cast((
				--			((isnull(OC.GrossRate,0)+isnull(OC.MarkupRate,0))*(ISNULL(QM.TaxonSale, 0) / 100.0))
				--			+
				--			(isnull(OC.GrossRate,0)+isnull(OC.MarkupRate,0))
				--		)as money) AS INT), 'N0', 'en-IN')) 

							
				--	ELSE
				--		convert(nvarchar,FORMAT(CAST(cast((
				--			(isnull(OC.GrossRate,0)+isnull(OC.MarkupRate,0))
				--		)as money) AS INT), 'N0', 'en-IN')) 
							
				--END
				--as SellingRate,
				VTM.ID as VehicleId,
				VTM.VehicleType,
				'Transport' as ServiceType,

				
				-- Commission JSON
				(
					SELECT 
						OC.ID AS OthersRateCardCommissionId,
						OC.CommissionMasterID,
						RCM.RateType,  
						CONVERT(varchar,ISNULL(MinimumPax,0))+' - '+CONVERT(varchar,ISNULL(MaximumPax,0)) as PaxRange,
						isnull((select top 1 NetAmountIncludingTax from  Quotation.OthersRateCardCommission where ID=OC.ID AND CommissionMasterID=22),0) as ExtHr,
						isnull((select top 1 NetAmountIncludingTax from  Quotation.OthersRateCardCommission where ID=OC.ID AND CommissionMasterID=21),0) as ExtKm,
						--CASE
						--	WHEN 
						--		QM.TaxType=1
						--	THEN
						--		--Tax on Sales Amount = (Gross Amount + Mark-Up) * Tax on Sales % 
						--		--Occupancy Selling Amount Formula = Gross Amount + Mark-Up + Tax on Sales Amount 
						--		convert(nvarchar,FORMAT(CAST(cast((
						--			((isnull(OC.GrossRate,0)+isnull(OC.MarkupRate,0))*(ISNULL(QM.TaxonSale, 0) / 100.0))
						--			+
						--			(isnull(OC.GrossRate,0)+isnull(OC.MarkupRate,0))
						--		)as money) AS INT), 'N0', 'en-IN')) 

							
						--	ELSE
						--		convert(nvarchar,FORMAT(CAST(cast((
						--			(isnull(OC.GrossRate,0)+isnull(OC.MarkupRate,0))
						--		)as money) AS INT), 'N0', 'en-IN')) 
							
						--END
						--as SellingRate
						isnull(SellingRates,0) as SellingRate
						FROM 
							Quotation.OthersRateCardCommission OC 
							LEFT JOIN RateCommissionMaster RCM ON OC.CommissionMasterID = RCM.CommMasterID
						WHERE 
							OC.OthersRateRefrenceID=O.ID
							AND isnull(OC.IsActive,0) = 1
						FOR JSON PATH
				) AS CommissionJSON
			FROM
				Quotation.OthersRateCardMaster O
				INNER JOIN Quotation.QuotationMaster QM ON QM.QuotationId=O.QuotationID
				--LEFT JOIN Quotation.OthersRateCardCommission OC ON O.ID=OC.OthersRateRefrenceID
				LEFT JOIN City C ON O.CityID=C.IATACode
				LEFT JOIN RateCards.TransportRateDetails TRD ON TRD.TransportRateDetailID=O.TransportModeTypeID
				LEFT JOIN VehicleTypeMaster VTM ON VTM.ID = TRD.VehicleCategoryID
				--LEFT JOIN RateCommissionMaster RCM ON RCM.CommMasterID=OC.CommissionMasterID 
			WHERE
				O.QuotationID=@QuotationId
				AND O.RateType=3
				AND isnull(O.IsActive,0)=1

			--Table 3 Special service 
			Select 
				DISTINCT
				O.ID,
				ReferenceRateDetailID,
				O.QuotationID,
				QM.QuotationNo,
				O.CityID,
				C.Name as CityName,
				ISNULL(CONVERT(varchar,ValidFrom,103),'')+ ' - '+ISNULL(CONVERT(varchar,ValidTo,103),'') as FromToDate,
				Heading as ServiceName,
				N.ID as NationalityId,
				N.Nationality, 
				 QM.RateCardMode,
				 isnull(QM.Disclaimer,'NA') as Disclaimer,
    (
        SELECT 
            STRING_AGG(
                CASE value
                    WHEN '1' THEN 'Contract'
                    WHEN '2' THEN 'Adhoc'
                    WHEN '3' THEN 'Negotiated'
                    ELSE 'Unknown'
                END, ','
            )
        FROM STRING_SPLIT(QM.RateCardMode, ',')
    ) AS RateCardType,
				--CASE
				--WHEN 
				--	QM.TaxType=1
				--THEN
				--	convert(nvarchar,FORMAT(CAST(cast((
				--		((isnull(OC.GrossRateAdult,0)+isnull(OC.MarkupRate,0))*(ISNULL(QM.TaxonSale, 0) / 100.0))
				--		+
				--		(isnull(OC.GrossRateAdult,0)+isnull(OC.MarkupRate,0))
				--	)as money) AS INT), 'N0', 'en-IN')) 

							
				--ELSE
				--	convert(nvarchar,FORMAT(CAST(cast((
				--		(isnull(OC.GrossRateAdult,0)+isnull(OC.MarkupRate,0))
				--	)as money) AS INT), 'N0', 'en-IN')) 
							
				--END
				--as AdultSellingRate,
				--CASE
				--	WHEN 
				--		QM.TaxType=1
				--	THEN
				--		convert(nvarchar,FORMAT(CAST(cast((
				--			((isnull(OC.GrossRateChild,0)+isnull(OC.MarkupRate,0))*(ISNULL(QM.TaxonSale, 0) / 100.0))
				--			+
				--			(isnull(OC.GrossRateChild,0)+isnull(OC.MarkupRate,0))
				--		)as money) AS INT), 'N0', 'en-IN')) 

							
				--	ELSE
				--		convert(nvarchar,FORMAT(CAST(cast((
				--			(isnull(OC.GrossRateChild,0)+isnull(OC.MarkupRate,0))
				--		)as money) AS INT), 'N0', 'en-IN')) 
							
				--END
				--as ChildSellingRate,
				--CASE
				--	WHEN 
				--		QM.TaxType=1
				--	THEN
				--		convert(nvarchar,FORMAT(CAST(cast((
				--			((isnull(OC.GrossRate,0)+isnull(OC.MarkupRate,0))*(ISNULL(QM.TaxonSale, 0) / 100.0))
				--			+
				--			(isnull(OC.GrossRate,0)+isnull(OC.MarkupRate,0))
				--		)as money) AS INT), 'N0', 'en-IN')) 

							
				--	ELSE
				--		convert(nvarchar,FORMAT(CAST(cast((
				--			(isnull(OC.GrossRate,0)+isnull(OC.MarkupRate,0))
				--		)as money) AS INT), 'N0', 'en-IN')) 
							
				--END
				--as ConsolidatedSellingRate,
				'Special Service' as ServiceType,

				-- Commission JSON
				(
					SELECT 
						OC.ID AS OthersRateCardCommissionId,
						OC.CommissionMasterID,
						RCM.RateType,  
						CONVERT(varchar,ISNULL(MinimumPax,0))+' - '+CONVERT(varchar,ISNULL(MaximumPax,0)) as PaxRange,
						--CASE
						--	WHEN 
						--		QM.TaxType=1 AND EXISTS 
						--							(
						--								SELECT 
						--										1
						--								FROM
						--									RateCommissionMaster
						--								WHERE 
						--									RateType = 'Adult'
						--									AND CommMasterID = OC.CommissionMasterID
						--							)
						--	THEN
						--		convert(nvarchar,FORMAT(CAST(cast((
						--			((isnull(OC.GrossRate,0)+isnull(OC.MarkupRate,0))*(ISNULL(QM.TaxonSale, 0) / 100.0))
						--			+
						--			(isnull(OC.GrossRate,0)+isnull(OC.MarkupRate,0))
						--		)as money) AS INT), 'N0', 'en-IN')) 

							 
						--	WHEN
						--		EXISTS 
						--			(
						--				SELECT 
						--						1
						--				FROM
						--					RateCommissionMaster
						--				WHERE 
						--					RateType = 'Adult'
						--					AND CommMasterID = OC.CommissionMasterID
						--			)
						--	THEN
						--		convert(nvarchar,FORMAT(CAST(cast((
						--			(isnull(OC.GrossRate,0)+isnull(OC.MarkupRate,0))
						--		)as money) AS INT), 'N0', 'en-IN')) 
							
						--END
						--as AdultSellingRate,
						--CASE
						--	WHEN 
						--		QM.TaxType=1 AND EXISTS 
						--						(
						--							SELECT 
						--									1
						--							FROM
						--								RateCommissionMaster
						--							WHERE 
						--								RateType = 'Child'
						--								AND CommMasterID = OC.CommissionMasterID
						--						)
						--	THEN
						--		convert(nvarchar,FORMAT(CAST(cast((
						--			((isnull(OC.GrossRate,0)+isnull(OC.MarkupRate,0))*(ISNULL(QM.TaxonSale, 0) / 100.0))
						--			+
						--			(isnull(OC.GrossRate,0)+isnull(OC.MarkupRate,0))
						--		)as money) AS INT), 'N0', 'en-IN')) 

							
						--	WHEN
						--		EXISTS 
						--			(
						--				SELECT 
						--						1
						--				FROM
						--					RateCommissionMaster
						--				WHERE 
						--					RateType = 'Child'
						--					AND CommMasterID = OC.CommissionMasterID
						--			)
						--	THEN
						--		convert(nvarchar,FORMAT(CAST(cast((
						--			(isnull(OC.GrossRate,0)+isnull(OC.MarkupRate,0))
						--		)as money) AS INT), 'N0', 'en-IN')) 
							
						--END
						--as ChildSellingRate,
						--CASE
						--	WHEN 
						--		QM.TaxType=1
						--	THEN
						--		convert(nvarchar,FORMAT(CAST(cast((
						--			((isnull(OC.GrossRate,0)+isnull(OC.MarkupRate,0))*(ISNULL(QM.TaxonSale, 0) / 100.0))
						--			+
						--			(isnull(OC.GrossRate,0)+isnull(OC.MarkupRate,0))
						--		)as money) AS INT), 'N0', 'en-IN')) 

							
						--	ELSE
						--		convert(nvarchar,FORMAT(CAST(cast((
						--			(isnull(OC.GrossRate,0)+isnull(OC.MarkupRate,0))
						--		)as money) AS INT), 'N0', 'en-IN')) 
							
						--END
						--as ConsolidatedSellingRate
						isnull(SellingRates,0) as SellingRate
					FROM 
						Quotation.OthersRateCardCommission OC 
						LEFT JOIN RateCommissionMaster RCM ON OC.CommissionMasterID = RCM.CommMasterID
					WHERE 
						OC.OthersRateRefrenceID=O.ID
						AND isnull(OC.IsActive,0) = 1
					FOR JSON PATH
				) AS CommissionJSON
			FROM
				Quotation.OthersRateCardMaster O
				INNER JOIN Quotation.QuotationMaster QM ON QM.QuotationId=O.QuotationID
				--LEFT JOIN Quotation.OthersRateCardCommission OC ON O.ID=OC.OthersRateRefrenceID
				LEFT JOIN City C ON O.CityID=C.IATACode
				LEFT JOIN Nationality N ON N.ID = O.NationalityID 
			WHERE
				O.QuotationID=@QuotationId
				AND O.RateType=4
				AND isnull(O.IsActive,0)=1

			--Table 4 Hotel
			Select
				Distinct
				HCM.ID,
				HCM.HotelRateID,
				HCM.QuotationID,
				HCM.CityID,
				C.Name as CityName,
				ISNULL(CONVERT(varchar,RVM.RateValidFrom,103),'')+ ' - '+ISNULL(CONVERT(varchar,RVM.RateValidTo,103),'') as FromToDate,
				isnull(HM.HotelName,'')+', '+isnull(C.Name,'') as HotelName,
				isnull(RoomCat.Name,'-') AS RoomCategory,
				Convert(varchar,CheckIn ,103) as CheckIn,
				Convert(varchar,CheckOut ,103) as CheckOut,
				--HCM.Days,
				CONCAT
					(
						CASE WHEN SUBSTRING(HCM.Days,1,1) = '1' THEN 'M' ELSE '' END,
						CASE WHEN SUBSTRING(HCM.Days,2,1) = '1' THEN 'T' ELSE '' END,
						CASE WHEN SUBSTRING(HCM.Days,3,1) = '1' THEN 'W' ELSE '' END,
						CASE WHEN SUBSTRING(HCM.Days,4,1) = '1' THEN 'T' ELSE '' END,
						CASE WHEN SUBSTRING(HCM.Days,5,1) = '1' THEN 'F' ELSE '' END,
						CASE WHEN SUBSTRING(HCM.Days,6,1) = '1' THEN 'S' ELSE '' END,
						CASE WHEN SUBSTRING(HCM.Days,7,1) = '1' THEN 'S' ELSE '' END
					) 
				AS DaysOfWeek,
				isnull(QM.Disclaimer,'NA') as Disclaimer,

				  -- Meal Overview JSON
				(
					SELECT
						DISTINCT
						M.HotelRateMealID,
						M.MealTypeID,
						--M.HotelRateDetailID,
     
						MealType.RateType AS MealType,
						M.GstPercentage,
						M.GstAmount,

						-- Conditionally select NetAmount based on @TaxID
						M.NetAmountIncludingTax as NetAmountIncludingTax_Org,
						M.NetAmountIncludingTax,

						M.NetAmountExcludingTax as NetAmountExcludingTax_Org,
						M.NetAmountExcludingTax,

						M.MasterCommissionID,
       
						M.IsMealDetails,
						M.DefineAmount,
						M.QuotationHotelRateID,
						M.SellingRate,
						M.ReasonMasterId
					FROM 
						Quotation.HotelRateMealPlanMaster M
						LEFT JOIN RateCommissionMaster MealType ON M.MasterCommissionID = MealType.CommMasterID
					WHERE
						M.QuotationHotelRateID = HCM.ID AND M.IsActive = 1
					FOR JSON PATH
				) AS MealOverviewJSON,

				-- Commission JSON
				(
					SELECT 
						DISTINCT
						RC.ID as QuotationHotelRateCommId,
						RC.RateCommisionID,
						RC.QuotationHotelRateID,
						RC.CommissionMasterID,
						RCM.RateType,  -- Mapped via join
						RC.TaxPercentage,
						RC.TaxAmount,
        
						RC.GrossAmountIncludingTax as GrossAmountIncludingTax_Org,
						RC.GrossAmountIncludingTax,
						RC.GrossAmountExcludingTax as GrossAmountExcludingTax_Org,
						RC.GrossAmountExcludingTax,

						RC.CommisionPercentage,
						RC.IsActive,
						RC.GrossRate,
						RC.IsMarkup,
						RC.MarkupValue,
						RC.SellingRate,
						RC.ReasonMasterId
					FROM 
						Quotation.HotelRateCommissionDetails RC
						INNER JOIN RateCommissionMaster RCM ON RC.CommissionMasterID = RCM.CommMasterID
					WHERE 
						RC.QuotationHotelRateID = HCM.ID
						AND RC.IsActive = 1
					FOR JSON PATH
				) AS CommissionJSON
			From
				Quotation.HotelRateCardMaster HCM
				INNER JOIN Quotation.QuotationMaster QM ON QM.QuotationId=HCM.QuotationID
				LEFT JOIN City C ON HCM.CityID=C.IATACode
				LEFT JOIN HotelMaster HM ON HCM.Hotelid=HM.HotelID
				--LEFT JOIN RateCards.HotelRateMaster HRD ON HCM.HotelRateID=HRD.HotelRateID
				LEFT JOIN RateCards.HotelRateDetails HD ON HCM.HotelRateID=HD.HotelRateID
				LEFT JOIN Quotation.RateValidityMaster RVM ON HD.HotelRateDetailID=RVM.HotelRateDetailID
				LEFT JOIN CIty CH ON HM.CityIATACode=CH.IATACode
				LEFT JOIN RoomCategory RoomCat ON HCM.RoomCategoryID = RoomCat.ID
			Where
				HCM.QuotationID=@QuotationId
				AND isnull(HCM.IsActive,0) = 1
		END
		
END
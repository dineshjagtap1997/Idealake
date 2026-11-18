--Declare
<<<<<<< HEAD
<<<<<<< HEAD
--	@CustomRateCardId int =145,
--	@RateCardModeTypeId int=4,
=======
--	@CustomRateCardId int =535,
--	@RateCardModeTypeId int=2,
>>>>>>> dev
=======
--	@CustomRateCardId int =535,
--	@RateCardModeTypeId int=2,
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6


--	@TaxID  INT        = 24,
--	@ValidFrom             DATETIME    = '2025-05-01T00:00:00',
<<<<<<< HEAD
<<<<<<< HEAD
--	--@DisplayRate           VARCHAR(5)  = NULL, 
=======
--	@DisplayRate           VARCHAR(5)  = NULL, 
>>>>>>> dev
=======
--	@DisplayRate           VARCHAR(5)  = NULL, 
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

--	@CurrencyCode VARCHAR(10) = 'INR',
--	@CheckIn DATETIME=null
CREATE procedure [RateCards].[usp_GetCustomRateCardByIdAndType]	

	@CustomRateCardId int =0,
	@RateCardModeTypeId int=0,


	@TaxID  INT        = NULL,
	@ValidFrom             DATETIME    = NULL,
	--@DisplayRate           VARCHAR(5)  = NULL, 

	@CurrencyCode VARCHAR(10) = 'INR',
	@CheckIn DATETIME=''
AS
BEGIN
	--Guide 1
	--Monument 2
	--Transport 3
	--Special Service 4
	--Hotel 5
	IF(@RateCardModeTypeId=1)
		BEGIN
			SELECT
				CHRM.HotelRateID as GuideRateID,
				'CustomRateCard' as Type,
				0 as GuideRateDetailID,
				RC.RateCommisionID as GuideRateCommissionID,
				CHRM.ServiceID as GuideServiceID,
				'' as CardNumber,
				'' as Heading,
				'' as ContractDate,
				CHRM.CityID,
				CHRM.VendorID,
				CHRM.CurrencyID,
				CHRM.LanguageID,

				CT.Name AS City,
				GS.Name AS GuideService,
				--VM.VendorName AS Vendor,
				VM.VendorName ,
				'' as InfoForOperation,
				'' as InfoForAgent,
				'' as InfoForRemark,
				CHRM.IsActive,
				CHRM.CreatedOn,
				CHRM.UpdatedOn,
				'' as Notes,
				0 as StateID,
				CHRM.VendorID,
				L.Language,
			   CONCAT(RC.MinimumPax, ' - ', RC.MaximumPax) AS PaxRange,
			   '' as ValidFrom,
			   '' as ValidTo,
				RC.MinimumPax as PaxMinimum,
				RC.MaximumPax as PaxMaximum,
				0 as MISSequence,
				CHRM.CurrencyID,
				'' AS RateCardType,
				0 as RateCardModeTypeID,
				0 AS HasRules,
				0 AS HasDocument,
				CAST(CAST(dbo.fnSearchCalculateROE(CASE  WHEN @TaxID = 2 THEN RC.NetAmountExcludingTax ELSE RC.NetAmountIncludingTax END, @ValidFrom, @CurrencyCode, CHRM.CurrencyID ) AS NUMERIC(18, 0)) AS VARCHAR(20)) AS [GrossRate],
				CAST(CAST(dbo.fnSearchCalculateROE(CASE  WHEN @TaxID = 2 THEN RC.NetAmountExcludingTax ELSE RC.NetAmountIncludingTax END, @ValidFrom, @CurrencyCode, CHRM.CurrencyID ) AS NUMERIC(18, 0)) AS VARCHAR(20)) AS [SellingRate],

				RC.TaxPercentage,
				RC.TaxAmount,
				RC.NetAmountIncludingTax,
				RC.NetAmountExcludingTax,
				RC.NetAmountExcludingTax * dbo.fnGetPurchaseRate(CHRM.CurrencyID, @CurrencyCode, GETDATE()) AS NetAmountExcludingTax_Con,
				RC.NetAmountIncludingTax * dbo.fnGetPurchaseRate(CHRM.CurrencyID, @CurrencyCode, GETDATE()) AS NetAmountIncludingTax_Con,
				'Guide' as ServiceType
			FROM
				CustomRateCards.HotelRateMaster CHRM WITH (NOLOCK)
				LEFT OUTER JOIN [CustomRateCards].[HotelRateCommisionDetails] RC WITH (NOLOCK) ON RC.HotelRateID = CHRM.HotelRateId
				LEFT OUTER JOIN City CT WITH (NOLOCK) ON CT.IATACode = CHRM.CityID
				LEFT JOIN VendorMaster VM WITH (NOLOCK)  ON VM.VendorID = CHRM.VendorID
				LEFT OUTER JOIN GuideServices GS WITH (NOLOCK)  ON GS.Code = CHRM.ServiceID 
				LEFT OUTER JOIN [Language] L WITH (NOLOCK)  ON L.ID = CHRM.LanguageID
			WHERE
				CHRM.HotelRateID=@CustomRateCardId
				AND CHRM.RateType=1
				AND CHRM.IsActive = 1
			
		END
	ELSE IF(@RateCardModeTypeId=2)
		BEGIN
			SELECT
				
				CHRM.HotelRateID as MonumentRateID,
				'CustomRateCard' as Type,
				0 as MonumentDetailID,
				--RC.RateCommisionID as MonumentCommissionDetailID,
				CT.Name AS City,
				VM.VendorName,
				--'' AS MonumentService,
				 MS.Name AS MonumentService, 
				isnull(N.Nationality,'') as Nationality, 
				'' AS ValidFrom, 
				'' AS ValidTo,
				'' AS RateCardModeType,
				0 as RateCardModeTypeID,
				0 as TaxID,
				'' as CardNumber,
				'' as Heading,
				'' as ContractDate,
				CHRM.CurrencyID,
				0 as StateID,
				CHRM.VendorID,
				'' as InfoForOperation,
				'' as InfoForAgent,
				'' as InfoForRemark,
				CHRM.IsActive,
	
				CHRM.UpdatedOn,
				'' as GSTStatus,
				--0 as RateCardModeTypeID,
		
				CHRM.CityID,
				'' as ClosedOn,
				0 as MonumentServiceID,
				CHRM.NationalityId,
				0 as MISSequence,
				--RCM.RateType,
				0 as CommissionMasterID,


				--RC.NetAmountExcludingTax, 
				--RC.NetAmountIncludingTax,
				0 AS HasRules,
				0 AS HasDocument,
				--CASE 
				--	WHEN @TaxID = 1 THEN 
				--		CAST(CAST(dbo.fnSearchCalculateROE(RC.NetAmountIncludingTax, @ValidFrom, @CurrencyCode, CHRM.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20))  
				--	WHEN @TaxID = 2 THEN 
				--		CAST(CAST(dbo.fnSearchCalculateROE(RC.NetAmountExcludingTax, @ValidFrom, @CurrencyCode, CHRM.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20))  
				--	ELSE 
				--		CAST(CAST(dbo.fnSearchCalculateROE(RC.NetAmountIncludingTax, @ValidFrom, @CurrencyCode, CHRM.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20)) 
				--END AS [GrossRate],
				NULL AS [GrossRateAdult],

				-- GrossRate for Child (CommissionMasterID = 8)
				NULL AS [GrossRateChild],

				--RC.TaxPercentage, 
				--RC.TaxAmount, 
				--RC.NetAmountExcludingTax, 
				--RC.NetAmountIncludingTax,
				CHRM.CreatedOn,
				(
					SELECT *
						FROM
						(
							-- First object: grouped totals
							SELECT
								TRCD.RateCommisionID as MonumentCommissionDetailID,
								TRCD.CommissionMasterID,
								--TRCD.NetAmountExcludingTax, 
								--TRCD.NetAmountIncludingTax,
								CASE 
									WHEN @TaxID = 1 THEN 
										CAST(CAST(dbo.fnSearchCalculateROE(TRCD.NetAmountIncludingTax, @ValidFrom, @CurrencyCode, CHRM.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20))  
									WHEN @TaxID = 2 THEN 
										CAST(CAST(dbo.fnSearchCalculateROE(TRCD.NetAmountExcludingTax, @ValidFrom, @CurrencyCode, CHRM.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20))  
									ELSE 
										CAST(CAST(dbo.fnSearchCalculateROE(TRCD.NetAmountIncludingTax, @ValidFrom, @CurrencyCode, CHRM.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20)) 
								END AS [GrossRate],
								NULL AS [GrossRateAdult],
								TRCD.TaxPercentage, 
								TRCD.TaxAmount, 
								TRCD.NetAmountExcludingTax, 
								TRCD.NetAmountIncludingTax,
<<<<<<< HEAD
<<<<<<< HEAD
=======
								TRCD.NetAmountExcludingTax as NetAmountExcludingTax_Con, 
								TRCD.NetAmountIncludingTax as NetAmountIncludingTax_Con,
>>>>>>> dev
=======
								TRCD.NetAmountExcludingTax as NetAmountExcludingTax_Con, 
								TRCD.NetAmountIncludingTax as NetAmountIncludingTax_Con,
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
								RCM.RateType
							FROM CustomRateCards.HotelRateCommisionDetails TRCD
							INNER JOIN RateCommissionMaster RCM ON RCM.CommMasterID = TRCD.CommissionMasterID
							WHERE TRCD.HotelRateID = CHRM.HotelRateID
						) AS CombinedCommissions
						FOR JSON PATH
				) AS MonumentRateCommissionDetails,
				'Monument' as ServiceType
			FROM
				CustomRateCards.HotelRateMaster CHRM WITH (NOLOCK)
				--LEFT OUTER JOIN [CustomRateCards].[HotelRateCommisionDetails] RC WITH (NOLOCK) ON RC.HotelRateID = CHRM.HotelRateId
				LEFT OUTER JOIN Nationality N WITH (NOLOCK) ON N.ID = CHRM.NationalityID 
				LEFT OUTER JOIN City CT WITH (NOLOCK) ON CT.IATACode = CHRM.CityID
				LEFT JOIN VendorMaster VM WITH (NOLOCK)  ON VM.VendorID = CHRM.VendorID
				--LEFT JOIN RateCommissionMaster RCM 
				--WITH (NOLOCK)  ON  RCM.CommMasterID = RC.CommissionMasterID
				LEFT JOIN MonumentService MS ON MS.ID = CHRM.ServiceID
			WHERE
				CHRM.HotelRateId=@CustomRateCardId
				AND CHRM.RateType=2
				AND CHRM.IsActive = 1
		END
	ELSE IF(@RateCardModeTypeId=3)
		BEGIN
			select 
				0 as TransportRateDetailID,
				CHRM.HotelRateID as TransportRateID,
				'CustomRateCard' as Type,
				CT.Name AS City,
				TS.Name AS  TransportService,
				VTM.VehicleType,
				'' as ValidFrom,
				'' as ValidTo,
				@CurrencyCode AS Currency,
				'' CardNumber,
				'' as ContractDate,
				CHRM.CurrencyID,
				0 as StateID,
				CHRM.VendorID,
				VM.VendorName,
				'' as InfoForOperation,
				'' as InfoForAgent,
				'' as InfoForRemark,
				--'' as IsActive,
				CHRM.CreatedOn,
				CHRM.UpdatedOn,
				'' as GSTStatus,
				0 as RateCardModeTypeID,
				CHRM.CityID,
				0 as TaxID,
				CHRM.ServiceID as TransportServiceID,
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
								 SUM(NetAmountExcludingTax) * dbo.fnGetPurchaseRate(CHRM.CurrencyID, @CurrencyCode, GETDATE()) AS NetAmountExcludingTax_Con,
							   SUM(NetAmountIncludingTax) * dbo.fnGetPurchaseRate(CHRM.CurrencyID, @CurrencyCode, GETDATE()) AS NetAmountIncludingTax_Con,
								'Total' AS CommissionType
							FROM CustomRateCards.HotelRateCommisionDetails TRCD
							WHERE TRCD.HotelRateID = CHRM.HotelRateID
							  AND CommissionMasterID IN (9, 10, 13, 14, 15, 18, 19)

							UNION ALL

							-- Individual commissions
							SELECT
							TRCD.RateCommisionID as TransportCommissionDetailID,
							TRCD.CommissionMasterID,
		
							RCM.RateType,
							TRCD.TaxAmount,
							TRCD.NetAmountExcludingTax,
							TRCD.NetAmountIncludingTax,
							TRCD.NetAmountExcludingTax * dbo.fnGetPurchaseRate(CHRM.CurrencyID, @CurrencyCode, GETDATE()) AS NetAmountExcludingTax_Con,
							TRCD.NetAmountIncludingTax * dbo.fnGetPurchaseRate(CHRM.CurrencyID, @CurrencyCode, GETDATE()) AS NetAmountIncludingTax_Con,
							'Detail' AS CommissionType
							FROM 
								CustomRateCards.HotelRateCommisionDetails TRCD
								INNER JOIN RateCommissionMaster RCM ON RCM.CommMasterID = TRCD.CommissionMasterID
							WHERE 
								TRCD.HotelRateID = CHRM.HotelRateID
								 AND TRCD.CommissionMasterID NOT IN (9, 10, 13, 14, 15, 18, 19)
						) AS CombinedCommissions
						FOR JSON PATH
				) AS TransportRateCommissionDetails,
				'Transport' as ServiceType
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
				AND CHRM.HotelRateID=@CustomRateCardId

		END
	ELSE IF(@RateCardModeTypeId=4)
		BEGIN
			Select
				CHRM.HotelRateId as SpecialServiceRateID,
				'CustomRateCard' as Type,
				0 as SpecialServiceRateDetailID,
				
				CT.Name AS City,
				VM.VendorName,
				CT.ID AS CityID,
				N.Nationality,
				'' AS [TransportService],
				0 as TaxID,
				--0 as CommissionMasterID,

				'' AS [ValidFrom],
				'' AS [ValidTo],

			  

				@CurrencyCode AS Currency,

	
				
		
				'' as InfoForOperation,
				'' as InfoForRemark,
				CHRM.NationalityID,

				'' AS RateCardType,

				'' as CardNumber,
				0 as RateCardModeTypeID,
				CHRM.ServiceID as SpecialServiceID,
				'' as ContractDate,
				CHRM.CurrencyID,
				0 as StateID,
				CHRM.VendorID,
			
				'' as InfoForOperation,
				'' as InfoForRemark,
				'' as InfoForRemark,
				CHRM.IsActive,

				'' as GSTStatus,
				'' as RateCardModeTypeID,
				CHRM.CityID,
				SS.name as SpecialService,

		
				0 AS HasRules,
				0 AS HasDocument,

				--'' AS Ratetype,

				CHRM.VendorID,
				CHRM.HotelID,
				
				CHRM.CreatedOn ,
				
				(
					SELECT *
						FROM
						(
							-- First object: grouped totals
							SELECT
								RateCommisionID as SpecialServiceRateCommissionID,
								CommissionMasterID,
								CONVERT(VARCHAR, MinimumPax) + ' - ' + CONVERT(VARCHAR, MaximumPax) AS PaxRange,
								--CAST(CAST(dbo.fnSearchCalculateROE(NetAmountIncludingTax, @ValidFrom, @CurrencyCode, CHRM.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20))   as NetAmountIncludingTax,
								--CAST(CAST(dbo.fnSearchCalculateROE(NetAmountExcludingTax, @ValidFrom, @CurrencyCode, CHRM.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20))   as NetAmountExcludingTax,
								NetAmountIncludingTax,
								NetAmountExcludingTax,
								NetAmountExcludingTax * dbo.fnGetPurchaseRate(@CurrencyCode, @CurrencyCode, GETDATE()) AS NetAmountExcludingTax_Con,
								NetAmountIncludingTax * dbo.fnGetPurchaseRate(@CurrencyCode, @CurrencyCode, GETDATE()) AS NetAmountIncludingTax_Con,
								
								MinimumPax,
								MaximumPax,
								TaxPercentage,
								TaxAmount,
								COALESCE(RCM.Ratetype, 'Consolidated') AS Ratetype
							FROM
								[CustomRateCards].[HotelRateCommisionDetails]
								LEFT JOIN RateCommissionMaster RCM ON RCM.CommMasterID = [CustomRateCards].[HotelRateCommisionDetails].CommissionMasterID
							WHERE HotelRateID = CHRM.HotelRateID
						) AS CombinedCommissions
						FOR JSON PATH
				) AS SpecialRateCommissionDetails,
				'Special Service' as ServiceType
   			FROM
				CustomRateCards.HotelRateMaster CHRM WITH (NOLOCK)
				--LEFT OUTER JOIN [CustomRateCards].[HotelRateCommisionDetails] RC WITH (NOLOCK) ON RC.HotelRateID = CHRM.HotelRateId
				LEFT OUTER JOIN Nationality N WITH (NOLOCK) ON N.ID = CHRM.NationalityID 
				LEFT OUTER JOIN City CT WITH (NOLOCK) ON CT.IATACode = CHRM.CityID
				LEFT JOIN VendorMaster VM WITH (NOLOCK)  ON VM.VendorID = CHRM.VendorID
				LEFT JOIN SpecialServices SS  ON  SS.ID =  CHRM.ServiceID
	
			WHERE
				CHRM.rateType=4
				AND CHRM.IsActive = 1
				AND CHRM.HotelRateID=@CustomRateCardId
		END
	ELSE IF(@RateCardModeTypeId=5)
		BEGIN
			SELECT
				CHRM.HotelRateID,
				'CustomRateCard' as Type,
				CHRM.HotelID,
				ISNULL(H.HotelName,'-') as HotelName,
				0 as HotelPreferred,
				CHRM.CityID,
				0 AS HotelRateDetailID,
				RoomCategoryID,
				ISNULL(RoomCat.Name,'-') AS RoomCategory,
				0 as MISSequence,
				'' as Days,
				'' as DaysOfWeek,
				0 as RateCardModeTypeID,
				isnull(MP.Code,'-') as MealPlanCode,
				MP.Breakfast,
				MP.Lunch,
				MP.Dinner,
				0 as TransferID,
				'' as TransferValue,
				-- Flags
				0 AS HasRules,
				0 AS HasDocument,
				0 as OfferTypeID,
				CHRM.CurrencyID as Currency,
				dbo.fnGetPurchaseRate(CHRM.CurrencyID,@CurrencyCode,@CheckIn) as PurchaseRate,
				(
					SELECT 
						RC.RateCommisionID as RateCommissionID,
						RCM.CommMasterID as CommissionMasterID,
						RCM.CommMasterID as MasterCommissionID,
						RCM.RateType,
        
						RC.TaxPercentage,
						RC.TaxAmount,

						RC.GrossAmountIncludingTax as GrossAmountIncludingTax_Org,

						--dbo.fnSearchCalculateROE(ISNULL(RC.GrossAmountIncludingTax, 0), @CheckIn, C1.Code, @CurrencyCode) AS GrossAmountIncludingTax,
						RC.GrossAmountIncludingTax as GrossAmountIncludingTax,

						RC.GrossAmountExcludingTax as GrossAmountExcludingTax_Org,

						--dbo.fnSearchCalculateROE(ISNULL(RC.GrossAmountExcludingTax, 0), @CheckIn, C1.Code, @CurrencyCode) as GrossAmountExcludingTax,
						RC.GrossAmountExcludingTax as GrossAmountExcludingTax,

						RC.CommisionPercentage,
						RC.CommissionAmount as CommissionAmount_Org,
						--dbo.fnSearchCalculateROE(ISNULL(RC.CommissionAmount, 0), @CheckIn, C1.Code, @CurrencyCode) AS CommissionAmount,
						RC.CommissionAmount as CommissionAmount,

						RC.NetAmountIncludingTax as NetAmountIncludingTax_Org,

						--dbo.fnSearchCalculateROE(ISNULL(RC.NetAmountIncludingTax, 0), @CheckIn, C1.Code, @CurrencyCode) as NetAmountIncludingTax,
						RC.NetAmountIncludingTax as NetAmountIncludingTax,

						RC.NetAmountExcludingTax as NetAmountExcludingTax_Org,

						--dbo.fnSearchCalculateROE(ISNULL(RC.NetAmountExcludingTax, 0), @CheckIn, C1.Code, @CurrencyCode) as NetAmountExcludingTax,
						RC.NetAmountExcludingTax as NetAmountExcludingTax,

						RC.GrossAmountIncludingTax * dbo.fnGetPurchaseRate(C1.Code, @CurrencyCode, @CheckIn) AS GrossAmountIncludingTax_Con,
						RC.GrossAmountExcludingTax * dbo.fnGetPurchaseRate(C1.Code, @CurrencyCode, @CheckIn) AS GrossAmountExcludingTax_Con,
						RC.CommissionAmount * dbo.fnGetPurchaseRate(C1.Code, @CurrencyCode, @CheckIn) AS CommissionAmount_Con,
						RC.NetAmountIncludingTax * dbo.fnGetPurchaseRate(C1.Code, @CurrencyCode, @CheckIn) AS NetAmountIncludingTax_Con,
						RC.NetAmountExcludingTax * dbo.fnGetPurchaseRate(C1.Code, @CurrencyCode, @CheckIn) AS NetAmountExcludingTax_Con,

						ISNULL(RC.IsTax, 0) as IsTax,
						ISNULL(RC.IsActive, 0) as IsActive

					FROM 
						[CustomRateCards].[HotelRateCommisionDetails] RC WITH (NOLOCK)  
						LEFT OUTER JOIN RateCommissionMaster RCM WITH (NOLOCK) ON
						RC.CommissionMasterID = RCM.CommMasterID
					WHERE 
						RC.HotelRateID = CHRM.HotelRateId
						--AND RCM.Type = 1
						--AND RC.IsActive = 1
					FOR JSON PATH
				) AS CommissionJSON,
					-- Meal Overview JSON
				(
					SELECT
						M.HotelRateMealID,
						0 as HotelRateDetailID,
     
						MealType.RateType AS MealType,
						M.GstPercentage,
						M.GstAmount,

						-- Conditionally select NetAmount based on @TaxID
						M.NetAmountIncludingTax as NetAmountIncludingTax_Org,
						--dbo.fnSearchCalculateROE(M.NetAmountIncludingTax, @CheckIn, C1.Code, @CurrencyCode) AS NetAmountIncludingTax,
						M.NetAmountIncludingTax as NetAmountIncludingTax,

						M.NetAmountExcludingTax as NetAmountExcludingTax_Org,
						--dbo.fnSearchCalculateROE(M.NetAmountExcludingTax, @CheckIn, C1.Code, @CurrencyCode) AS NetAmountExcludingTax,
						M.NetAmountExcludingTax as NetAmountExcludingTax,
						M.NetAmountIncludingTax * dbo.fnGetPurchaseRate(C1.Code, @CurrencyCode, @CheckIn) AS NetAmountIncludingTax_Con,
						M.NetAmountExcludingTax * dbo.fnGetPurchaseRate(C1.Code, @CurrencyCode, @CheckIn) AS NetAmountExcludingTax_Con,
						M.MasterCommissionID,
       
						M.IsMealDetails,
						M.DefineAmount
					FROM 
						[CustomRateCards].[HotelRateMealOverview] M WITH (NOLOCK)
						--LEFT OUTER JOIN RateCommissionMaster MealType  WITH (NOLOCK) ON M.MasterCommissionID = MealType.CommMasterID
						LEFT OUTER JOIN RateCommissionMaster MealType  WITH (NOLOCK) ON M.MealTypeID = MealType.CommMasterID
					WHERE 
						M.HotelRateID = CHRM.HotelRateID
						--AND M.IsActive = 1
					FOR JSON PATH
				) AS MealOverviewJSON,
				'' as OfferConfigurationJSON,
				'' as HotelAnnouncementsJSON,
				'' as ContactDetailsJSON,
				'' as RulesJSON,
				'' as MarketJSON,
				'' as RateSheetJSON,
				CHRM.CreatedOn,
				'Hotel' as ServiceType
			FROM
				CustomRateCards.HotelRateMaster CHRM WITH (NOLOCK)
				LEFT OUTER JOIN HotelMaster H WITH (NOLOCK) ON CHRM.HotelID = H.HotelID
				LEFT OUTER JOIN RoomCategory RoomCat WITH (NOLOCK) ON CHRM.RoomCategoryID = RoomCat.ID
				LEFT OUTER JOIN MealPlan MP WITH (NOLOCK) ON CHRM.MealPlanID = MP.ID AND MP.IsActive = 1
				LEFT OUTER JOIN Currency C1 WITH (NOLOCK) ON CHRM.CurrencyID = C1.Code
			WHERE
				CHRM.RateType=5
				AND CHRM.IsActive = 1 
				AND CHRM.HotelRateID=@CustomRateCardId
		END
END	
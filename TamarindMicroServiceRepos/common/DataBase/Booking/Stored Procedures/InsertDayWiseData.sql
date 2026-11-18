
alter PROCEDURE [Booking].[InsertDayWiseData] 
	@BookingID INT = 333
	,@Action VARCHAR(10)='I'
	,@Id INT = null
	,@OperationBy NVARCHAR(200) = 'feeceb69-c92c-41a9-98de-fa86fcc009e9'
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @EmptyMealList dbo.BookingMealPlanTableType;
	IF @Action = 'I'
	BEGIN
		BEGIN TRY
			BEGIN TRANSACTION;
			IF Not EXISTS (select ID from Booking.DayWiseBooking where BookingID=@BookingID)
			BEGIN
				DECLARE @NewDayWiseIDs TABLE (ID BIGINT);
				-- 1. Hotel operations
				WITH DateRange
				AS (
					SELECT HRM.ID
						,HRM.QuotationNo
						,HRM.ID AS HotelRateID
						,H.HotelID
						,H.HotelName
						,HRM.CityID
						,ct.IATACode
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
						,MP.Code AS MealPlanCode
						,HRM.Breakfast
						,HRM.Lunch
						,HRM.Dinner
						,'NA' AS Disclaimer
						,HRM.OfferTypeID
						,CAST(HRM.CheckIn AS DATE) AS FromDate
						,CAST(HRM.CheckOut AS DATE) AS ToDate
						,CAST(HRM.CheckIn AS DATE) AS StayDate
						,O.ID AS BookingID
						,HRM.CurrencyID AS Currency
						,dbo.fnGetPurchaseRate(HRM.CurrencyID, O.Currency, GETDATE()) AS PurchaseRate
						,RateSummary.SGL_Count
						,RateSummary.DBL_Count
						,RateSummary.EBA_Count
						,RateSummary.EBC_Count
						,RateSummary.CNB_Count
						,CASE 
							WHEN o.SupplierTax_InCluding = 1
								THEN RateSummary.SGL_GrossAmountIncludingTax
							ELSE RateSummary.SGL_GrossAmountExcludingTax
							END AS SGL_GrossRate
						,CASE 
							WHEN o.SupplierTax_InCluding = 1
								THEN RateSummary.DBL_GrossAmountIncludingTax
							ELSE RateSummary.DBL_GrossAmountExcludingTax
							END AS DBL_GrossRate
						,CASE 
							WHEN o.SupplierTax_InCluding = 1
								THEN RateSummary.EBA_GrossAmountIncludingTax
							ELSE RateSummary.EBA_GrossAmountExcludingTax
							END AS EBA_GrossRate
						,CASE 
							WHEN o.SupplierTax_InCluding = 1
								THEN RateSummary.EBC_GrossAmountIncludingTax
							ELSE RateSummary.EBC_GrossAmountExcludingTax
							END AS EBC_GrossRate
						,CASE 
							WHEN o.SupplierTax_InCluding = 1
								THEN RateSummary.CNB_GrossAmountIncludingTax
							ELSE RateSummary.CNB_GrossAmountExcludingTax
							END AS CNB_GrossRate,
							RateSummary.SGL_TaxPercentage
,RateSummary.DBL_TaxPercentage
,RateSummary.EBA_TaxPercentage
,RateSummary.EBC_TaxPercentage
,RateSummary.CNB_TaxPercentage

						,(
							SELECT RC.QuotationHotelRateCommissionId AS RateCommissionID
								,RC.CommissionMasterID
								,RC.CommissionMasterID AS MasterCommissionID
								,RCM.RateType
								,RC.TaxPercentage
								,RC.TaxAmount
								,RC.GrossAmountIncludingTax
								,RC.GrossAmountIncludingTax * dbo.fnGetPurchaseRate(HRM.CurrencyID, O.Currency, GETDATE()) AS GrossAmountIncludingTax_Con
								,RC.GrossAmountExcludingTax
								,RC.GrossAmountExcludingTax * dbo.fnGetPurchaseRate(HRM.CurrencyID, O.Currency, GETDATE()) AS GrossAmountExcludingTax_Con
								,RC.NetAmountIncludingTax
								,RC.NetAmountIncludingTax * dbo.fnGetPurchaseRate(HRM.CurrencyID, O.Currency, GETDATE()) AS NetAmountIncludingTax_Con
								,RC.NetAmountExcludingTax
								,RC.NetAmountExcludingTax * dbo.fnGetPurchaseRate(HRM.CurrencyID, O.Currency, GETDATE()) AS NetAmountExcludingTax_Con
								,RC.CommisionPercentage
								,RC.GrossRate
								,RC.IsMarkup
								,RC.MarkupValue
								,RC.SellingRate
								,RC.IsActive
								,RC.IsMarkup AS Markup_IsRate
								,RC.MarkupValue AS MarkupRate
								,RC.ReasonMasterId AS ReasonID
								,RC.Count
							FROM Booking.HotelRateCommissionDetailsBooking RC
							INNER JOIN RateCommissionMaster RCM ON RC.CommissionMasterID = RCM.CommMasterID
							WHERE RC.QuotationHotelRateID = HRM.ID
								AND RC.IsActive = 1
							FOR JSON PATH
							) AS CommissionJSON
						,(
							SELECT M.QuotationHotelRateMealId AS HotelRateMealID
								,MealType.RateType AS MealType
								,M.GstPercentage
								,M.GstAmount
								,M.SellingRate
								,M.MasterCommissionID
								,M.IsMealDetails
								,M.DefineAmount
								,M.NetAmountIncludingTax
								,M.NetAmountIncludingTax * dbo.fnGetPurchaseRate(HRM.CurrencyID, O.Currency, GETDATE()) AS NetAmountIncludingTax_Con
								,M.NetAmountExcludingTax
								,M.NetAmountExcludingTax * dbo.fnGetPurchaseRate(HRM.CurrencyID, O.Currency, GETDATE()) AS NetAmountExcludingTax_Con
							FROM Booking.HotelRateMealPlanMasterBooking M
							INNER JOIN RateCommissionMaster MealType ON M.MasterCommissionID = MealType.CommMasterID
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
								,CASE 
									WHEN HRM.OfferTypeID = 1
										THEN 'EBO'
									WHEN HRM.OfferTypeID = 2
										THEN 'PayOnStay'
									ELSE 'Unknown'
									END AS OfferType
								,(
									SELECT OCC.OfferCommissionID
										,OCC.OfferConfigurationID
										,OCC.MasterCommissionID
										,RCM.RateType
										,OCC.Discount
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
									INNER JOIN RateCommissionMaster RCM ON OCC.MasterCommissionID = RCM.CommMasterID
									WHERE OCC.OfferConfigurationID = OC.OfferID
										AND OCC.IsActive = 1
									FOR JSON PATH
									) AS OfferCommission
							FROM RateCards.HotelRateOfferConfiguration OC
							INNER JOIN RateCards.HotelRateDetails RD ON RD.HotelRateDetailID = OC.HotelRateDetailID
							INNER JOIN RateCards.HotelRateMaster HM ON HM.HotelRateID = RD.HotelRateID
							WHERE HM.HotelRateID = HRM.HotelRateID
							FOR JSON PATH
							) AS OfferConfigurationJSON
					FROM Booking.HotelRateCardMasterBooking HRM
					INNER JOIN Booking.tbl_Booking O ON O.ID = HRM.BookingID
					INNER JOIN HotelMaster H ON HRM.HotelID = H.HotelID
					INNER JOIN City ct ON ct.IATACode = HRM.CityID
					INNER JOIN HotelRating HR ON HR.ID = H.HotelRatingID
					
					INNER JOIN RoomCategory RoomCat ON HRM.RoomCategoryID = RoomCat.ID
					INNER JOIN MealPlan MP ON HRM.MealPlanID = MP.ID
						AND MP.IsActive = 1
					OUTER APPLY (
						SELECT ISNULL(MAX([SGL_Count]), 0) AS SGL_Count
							,ISNULL(MAX([DBL_Count]), 0) AS DBL_Count
							,ISNULL(MAX([EBA_Count]), 0) AS EBA_Count
							,ISNULL(MAX([EBC_Count]), 0) AS EBC_Count
							,ISNULL(MAX([CNB_Count]), 0) AS CNB_Count
							,MAX(CASE 
									WHEN RateType = 'SGL'
										THEN GrossAmountExcludingTax
									END) AS SGL_GrossAmountExcludingTax
							,MAX(CASE 
									WHEN RateType = 'SGL'
										THEN GrossAmountIncludingTax
									END) AS SGL_GrossAmountIncludingTax
							,MAX(CASE 
									WHEN RateType = 'DBL'
										THEN GrossAmountExcludingTax
									END) AS DBL_GrossAmountExcludingTax
							,MAX(CASE 
									WHEN RateType = 'DBL'
										THEN GrossAmountIncludingTax
									END) AS DBL_GrossAmountIncludingTax
							,MAX(CASE 
									WHEN RateType = 'EBA'
										THEN GrossAmountExcludingTax
									END) AS EBA_GrossAmountExcludingTax
							,MAX(CASE 
									WHEN RateType = 'EBA'
										THEN GrossAmountIncludingTax
									END) AS EBA_GrossAmountIncludingTax
							,MAX(CASE 
									WHEN RateType = 'EBC'
										THEN GrossAmountExcludingTax
									END) AS EBC_GrossAmountExcludingTax
							,MAX(CASE 
									WHEN RateType = 'EBC'
										THEN GrossAmountIncludingTax
									END) AS EBC_GrossAmountIncludingTax
							,MAX(CASE 
									WHEN RateType = 'CNB'
										THEN GrossAmountExcludingTax
									END) AS CNB_GrossAmountExcludingTax
							,MAX(CASE 
									WHEN RateType = 'CNB'
										THEN GrossAmountIncludingTax
									END) AS CNB_GrossAmountIncludingTax,
									        MAX(CASE WHEN RateType = 'SGL' THEN TaxPercentage END) AS SGL_TaxPercentage
        ,MAX(CASE WHEN RateType = 'DBL' THEN TaxPercentage END) AS DBL_TaxPercentage
        ,MAX(CASE WHEN RateType = 'EBA' THEN TaxPercentage END) AS EBA_TaxPercentage
        ,MAX(CASE WHEN RateType = 'EBC' THEN TaxPercentage END) AS EBC_TaxPercentage
        ,MAX(CASE WHEN RateType = 'CNB' THEN TaxPercentage END) AS CNB_TaxPercentage


									
						FROM (
							SELECT RCM2.RateType
								,RC2.Count
								,RC2.GrossAmountExcludingTax
								,RC2.GrossAmountIncludingTax
								,RCM2.RateType + '_Count' AS RateType_Count,
								RC2.TaxPercentage
							FROM Booking.HotelRateCommissionDetailsBooking RC2
							INNER JOIN RateCommissionMaster RCM2 ON RC2.CommissionMasterID = RCM2.CommMasterID
							WHERE RC2.QuotationHotelRateID = HRM.ID
								AND RC2.IsActive = 1
							) AS SourceData
						PIVOT(SUM(Count) FOR RateType_Count IN (
									[SGL_Count]
									,[DBL_Count]
									,[EBA_Count]
									,[EBC_Count]
									,[CNB_Count]
									)) AS PivotCount
						) AS RateSummary
					WHERE HRM.BookingID = @BookingID
						AND hrm.IsActive = 1
				
					UNION ALL
				
					SELECT ID
						,QuotationNo
						,HotelRateID
						,HotelID
						,HotelName
						,CityID
						,IATACode
						,RoomCategoryID
						,RoomCategory
						,Days
						,DaysOfWeek
						,MealPlanCode
						,Breakfast
						,Lunch
						,Dinner
						,Disclaimer
						,OfferTypeID
						,FromDate
						,ToDate
						,DATEADD(DAY, 1, StayDate) AS StayDate
						,BookingID
						,Currency
						,PurchaseRate
						,SGL_Count
						,DBL_Count
						,EBA_Count
						,EBC_Count
						,CNB_Count
						,SGL_GrossRate
						,DBL_GrossRate
						,EBA_GrossRate
						,EBC_GrossRate
						,CNB_GrossRate
						,SGL_TaxPercentage
,DBL_TaxPercentage
,EBA_TaxPercentage
,EBC_TaxPercentage
,CNB_TaxPercentage


						,CommissionJSON
						,MealOverviewJSON
						,OfferConfigurationJSON
					FROM DateRange
					WHERE DATEADD(DAY, 1, StayDate) < ToDate
					)
				INSERT INTO Booking.DayWiseBooking (
					RateTypeID
					,BookingID
					,DayWiseDate
					,City
					,RoomCategory
					,MealPlan
					,Breakfast
					,Lunch
					,Dinner
					,SGL
					,EBA
					,DBL
					,EBC
					,CNB
					,CNB_Rate
					,SGL_Rate
					,EBA_Rate
					,DBL_Rate
					,EBC_Rate
					,Currency
					,CreatedBy
					,CreatedOn
					,IsActive
					,BHRMID
					,XOLock
					,IsOkXO
					,HotelName,
						SGL_TaxPercentage,
	DBL_TaxPercentage,
	EBA_TaxPercentage,
	EBC_TaxPercentage,
	CNB_TaxPercentage


					)OUTPUT INSERTED.ID INTO @NewDayWiseIDs(ID)
				SELECT 5
					,BookingID
					,StayDate
					,IATACode
					,RoomCategory
					,MealPlanCode
					,Breakfast
					,Lunch
					,Dinner
					,SGL_Count
					,EBA_Count
					,DBL_Count
					,EBC_Count
					,CNB_Count
					,CNB_GrossRate
					,SGL_GrossRate
					,EBA_GrossRate
					,DBL_GrossRate
					,EBC_GrossRate
					,Currency
					,@OperationBy
					,GETDATE()
					,1
					,ID
					,0
					,0,HotelName,
						SGL_TaxPercentage,
	DBL_TaxPercentage,
	EBA_TaxPercentage,
	EBC_TaxPercentage,
	CNB_TaxPercentage



				FROM DateRange;

				-- 2. Transport operations
				WITH transDateRange
				AS (
					SELECT TRM.ID AS OthersRateCardMasterID
						,TRM.QuotationNo
						,o.QuotationID
						,TRM.BookingID
						,TRM.CardNumber
						,TRM.ValidFrom 
						,TRM.ValidTo 
						,TRM.ToDate AS EndDate
						,CT.IATACode AS City
						,TS.Code AS TransportServiceID
						,TS.Name AS TransportService
						,VTM.VehicleType
						,VM.VendorID
						,VM.VendorName AS Vendor
						,TRM.CurrencyID
						,TRM.IsActive
						,TRM.CreatedOn
						,TRM.UpdatedOn
						,TRM.CountOfVehicles
						,(
							SELECT SCRD.GrossRate
							FROM Booking.OthersRateCardCommissionBooking SCRD
							WHERE SCRD.OthersRateRefrenceID = TRM.ID
								AND SCRD.CommissionMasterID = 0
							) AS GrossRate
						,CAST(TRM.FromDate AS DATE) AS ServiceDate
						,TRM.ServiceID
					FROM Booking.OthersRateCardMasterBooking TRM
					INNER JOIN Booking.tbl_Booking O ON O.ID = TRM.BookingID
					LEFT JOIN VendorMaster VM ON VM.VendorID = TRM.VendorID
					INNER JOIN City CT ON CT.IATACode = TRM.CityID
					INNER JOIN TransportServices TS ON TS.Code = TRM.ServiceID
					LEFT JOIN VehicleTypeMaster VTM ON VTM.ID = TRM.VehicleCategoryID
					WHERE TRM.BookingID = @bookingID
						AND TRM.RateType = 3
						AND TRM.IsActive = 1
				
					UNION ALL
				
					SELECT d.OthersRateCardMasterID
						,d.QuotationNo
						,d.QuotationID
						,d.BookingID
						,d.CardNumber
						,d.ValidFrom
						,d.ValidTo
						,D.EndDate
						,d.City
						,d.TransportServiceID
						,d.TransportService
						,d.VehicleType
						,d.VendorID
						,d.Vendor
						,d.CurrencyID
						,d.IsActive
						,d.CreatedOn
						,d.UpdatedOn
						,d.CountOfVehicles
						,d.GrossRate
						,DATEADD(DAY, 1, d.ServiceDate)
						,d.ServiceID
					FROM transDateRange d
					WHERE DATEADD(DAY, 1, d.ServiceDate) <= ISNULL(d.EndDate,ServiceDate)
					)
				INSERT INTO Booking.DayWiseBooking (
					RateTypeID
					,QuotationID
					,BookingID
					,DayWiseDate
					,City
					,ServiceName
					,VehicleType
					,Vendor
					,Count
					,GrossRate
					,CreatedBy
					,CreatedOn
					,IsActive
					,BORMID
					,XOLock
					,IsOkXO,
					Currency
					,ServiceID
					)OUTPUT INSERTED.ID INTO @NewDayWiseIDs(ID)
				SELECT 3
					,QuotationID
					,BookingID
					,ServiceDate
					,City
					,TransportService
					,VehicleType
					,VendorID
					,CountOfVehicles
					,GrossRate
					,@OperationBy
					,Getdate()
					,1
					,OthersRateCardMasterID
					,0
					,0,
					CurrencyID
					,ServiceID
				FROM transDateRange
				OPTION (MAXRECURSION 0);

				-- 3. Guide operations
				WITH GuideDateRange
				AS (
					SELECT 'Guide' AS ServiceType
						,GRM.ID AS OthersRateCardMasterID
						,GRM.QuotationNo
						,o.QuotationID
						,GRM.BookingID
						,GRM.CardNumber
						,GRM.ValidFrom 
						,GRM.ValidTo
						,GRM.ToDate AS EndDate
						,CT.IATACode AS City
						,GS.Code AS GuideServiceID
						,GS.Name AS GuideService
						,VM.VendorID
						,VM.VendorName AS Vendor
						,GRM.CurrencyID
						,GRM.IsActive
						,GRM.CreatedOn
						,GRM.UpdatedOn
						,GRC.GrossRate
						,GRC.SellingRates
						,GRC.TaxPercentage
						,GRC.TaxAmount
						,GRC.Markup_IsRate
						,GRC.MarkupRate
						,GRM.ReasonID
						,GRM.CountOfGuide
						,CAST(GRM.FromDate AS DATE) AS ServiceDate,L.ID as langID
						,GRM.ServiceID
					FROM Booking.OthersRateCardMasterBooking GRM
					INNER JOIN Booking.tbl_Booking O ON O.ID = GRM.BookingID
					INNER JOIN Booking.OthersRateCardCommissionBooking GRC ON GRC.OthersRateRefrenceID = GRM.ID
					INNER JOIN [Language] L ON L.ID = GRM.LanguageID
					INNER JOIN City CT ON CT.IATACode = GRM.CityID
					INNER JOIN VendorMaster VM ON VM.VendorID = GRM.VendorID
					INNER JOIN GuideServices GS ON GS.Code = GRM.ServiceID
					Left JOIN Currency C ON C.Code = GRM.CurrencyID
					WHERE GRM.BookingID = @BookingID
						AND GRM.RateType = 1
						AND GRM.IsActive = 1
				
					UNION ALL
				
					SELECT d.ServiceType
						,d.OthersRateCardMasterID
						,d.QuotationNo
						,d.QuotationID
						,d.BookingID
						,d.CardNumber
						,d.ValidFrom
						,d.ValidTo
						,d.EndDate
						,d.City
						,d.GuideServiceID
						,d.GuideService
						,d.VendorID
						,d.Vendor
						,d.CurrencyID
						,d.IsActive
						,d.CreatedOn
						,d.UpdatedOn
						,d.GrossRate
						,d.SellingRates
						,d.TaxPercentage
						,d.TaxAmount
						,d.Markup_IsRate
						,d.MarkupRate
						,d.ReasonID
						,d.CountOfGuide
						,DATEADD(DAY, 1, d.ServiceDate) AS ServiceDate,langID,d.ServiceID
					FROM GuideDateRange d
					WHERE DATEADD(DAY, 1, d.ServiceDate) <= ISNULL(d.EndDate,ServiceDate)
					)
				INSERT INTO Booking.DayWiseBooking (
					RateTypeID
					,QuotationID
					,BookingID
					,DayWiseDate
					,City
					,Guide
					,ServiceName
					,Vendor
					,Count
					,GrossRate
					,CreatedBy
					,CreatedOn
					,Currency
					,IsActive
					,BORMID
					,XOLock
					,IsOkXO,Language,
					ServiceID
					)OUTPUT INSERTED.ID INTO @NewDayWiseIDs(ID)
				SELECT 1
					,QuotationID
					,BookingID
					,ServiceDate
					,City
					,GuideServiceID
					,GuideService
					,VendorID
					,CountOfGuide
					,GrossRate
					,@OperationBy
					,GETDATE()
					,CurrencyID
					,1
					,OthersRateCardMasterID
					,0
					,0,langID,ServiceID
				FROM GuideDateRange
				OPTION (MAXRECURSION 0);

				-- 4. Monument operations
				WITH MonumentDateRange
				AS (
					SELECT 'Monument' AS ServiceType
						,MRM.RateType
						,MRM.ID AS OthersRateCardMasterID
						,MRM.QuotationNo
						,O.QuotationID
						,MRM.BookingID
						,MRM.CardNumber AS BID
						,MRM.ValidFrom
						,MRM.ValidTo
						,MRM.ToDate AS EndDate
						,CT.IATACode AS City
						,MS.ID AS MonumentServiceID
						,MS.Name AS MonumentService
						,VM.VendorID
						,VM.VendorName AS Vendor
						,MRM.CurrencyID
						,MRM.IsActive
						,MRM.CreatedOn
						,MRM.UpdatedOn
						,MRM.ReasonID,n.ID as NationalityID
						,ISNULL((
								SELECT SCRD.GrossRate
								FROM Booking.OthersRateCardCommissionBooking SCRD
								WHERE SCRD.OthersRateRefrenceID = MRM.ID
									AND SCRD.CommissionMasterID = 7
								), 0) AS AdultGrossRate
						,ISNULL(MRM.CountOfAdult, 0) AS CountOfAdult
						,ISNULL((
								SELECT SCRD.GrossRate
								FROM Booking.OthersRateCardCommissionBooking SCRD
								WHERE SCRD.OthersRateRefrenceID = MRM.ID
									AND SCRD.CommissionMasterID = 8
								), 0) AS ChildGrossRate
						,ISNULL(MRM.CountOfChild, 0) AS CountOfChild
						,MRM.FromDate AS ServiceDate
						,MRM.ServiceID
					FROM Booking.OthersRateCardMasterBooking MRM
					INNER JOIN Booking.tbl_Booking O ON O.ID = MRM.BookingID
					INNER JOIN Nationality N ON N.ID = MRM.NationalityID
					INNER JOIN City CT ON CT.IATACode = MRM.CityID
					INNER JOIN VendorMaster VM ON VM.VendorID = MRM.VendorID
					INNER JOIN MonumentService MS ON MS.ID = MRM.ServiceID
					INNER JOIN Currency Cu ON Cu.Code = MRM.CurrencyID
					WHERE MRM.BookingID = @BookingID
						AND MRM.RateType = 2
						AND MRM.IsActive = 1
				
					UNION ALL
				
					SELECT d.ServiceType
						,d.RateType
						,d.OthersRateCardMasterID
						,d.QuotationNo
						,d.QuotationID
						,d.BookingID
						,d.BID
						,d.ValidFrom
						,d.ValidTo
						,d.EndDate
						,d.City
						,d.MonumentServiceID
						,d.MonumentService
						,d.VendorID
						,d.Vendor
						,d.CurrencyID
						,d.IsActive
						,d.CreatedOn
						,d.UpdatedOn
						,d.ReasonID,d.NationalityID
						,d.AdultGrossRate
						,d.CountOfAdult
						,d.ChildGrossRate
						,d.CountOfChild
						,DATEADD(DAY, 1, d.ServiceDate) AS ServiceDate,d.ServiceID
					FROM MonumentDateRange d
					WHERE DATEADD(DAY, 1, d.ServiceDate) <= ISNULL(d.EndDate,ServiceDate)
					)
				INSERT INTO Booking.DayWiseBooking (
					RateTypeID
					,QuotationID
					,BookingID
					,DayWiseDate
					,City
					,ServiceID
					,ServiceName
					,Vendor
					,Adult
					,Child
					,Adult_Rate
					,Child_Rate
					,CreatedOn
					,Currency
					,IsActive
					,CreatedBy
					,BORMID
					,XOLock
					,IsOkXO,Nationality
					)OUTPUT INSERTED.ID INTO @NewDayWiseIDs(ID)
				SELECT RateType
					,QuotationID
					,BookingID
					,ServiceDate AS DayWiseDate
					,City
					,MonumentServiceID AS Monument
					,MonumentService
					,VendorID AS Vendor
					,CountOfAdult
					,CountOfChild
					,AdultGrossRate
					,ChildGrossRate
					,GETDATE() AS CreatedOn
					,CurrencyID AS Currency
					,1
					,@OperationBy
					,OthersRateCardMasterID
					,0
					,0,NationalityID
				FROM MonumentDateRange
				OPTION (MAXRECURSION 0);

				-- 5. Special operations
				WITH SpecialServiceDateRange
				AS (
					SELECT 'Special Service' AS ServiceType
						,SSRM.ID AS OthersRateCardMasterID
						,SSRM.ID AS BKID
						,SSRM.QuotationNo
						,o.QuotationID
						,SSRM.BookingID
						,SSRM.CardNumber AS BID
						,SSRM.ValidFrom 
						,SSRM.ValidTo
						,SSRM.ToDate AS EndDate
						,CT.IATACode AS City
						,SS.ID AS SpecialServiceID
						,SS.Name AS SpecialService
						,VM.VendorID
						,VM.VendorName AS Vendor
						,SSRM.NationalityID
						,N.Nationality
						,SSRM.CurrencyID
						,SSRM.IsActive
						,SSRM.CreatedOn
						,SSRM.UpdatedOn
						,SSRM.RateId AS SpecialServiceRateID
						,SSRM.ReasonID
						,ISNULL(SSRM.Adult, 0) AS Adult
						,ISNULL((
								SELECT SCRD.GrossRate
								FROM Booking.OthersRateCardCommissionBooking SCRD
								WHERE SCRD.OthersRateRefrenceID = SSRM.ID
									AND SCRD.CommissionMasterID = 7
								), 0) AS AdultGrossRate
						,ISNULL(SSRM.PerPersonChild, 0) AS PerPersonChild
						,ISNULL((
								SELECT SCRD.GrossRate
								FROM Booking.OthersRateCardCommissionBooking SCRD
								WHERE SCRD.OthersRateRefrenceID = SSRM.ID
									AND SCRD.CommissionMasterID = 8
								), 0) AS ChildGrossRate
						,ISNULL(SSRM.Consolidate, 0) AS Consolidated
						,ISNULL((
								SELECT SCRD.GrossRate
								FROM Booking.OthersRateCardCommissionBooking SCRD
								WHERE SCRD.OthersRateRefrenceID = SSRM.ID
									AND SCRD.CommissionMasterID = 0
								), 0) AS ConsolidateGrossRate
						,SSRM.FromDate AS ServiceDate
						,SSRM.ServiceID
					FROM Booking.OthersRateCardMasterBooking SSRM
					INNER JOIN Booking.tbl_Booking O ON O.ID = SSRM.BookingID
					INNER JOIN Nationality N ON N.ID = SSRM.NationalityID
					INNER JOIN City CT ON CT.IATACode = SSRM.CityID
					INNER JOIN VendorMaster VM ON VM.VendorID = SSRM.VendorID
					LEFT JOIN HotelMaster HM ON HM.HotelID = SSRM.HotelID
					INNER JOIN SpecialServices SS ON SS.ID = SSRM.ServiceID
					INNER JOIN Currency Cu ON Cu.Code = SSRM.CurrencyID
					WHERE SSRM.BookingID = @BookingID
						AND SSRM.RateType = 4
						AND SSRM.IsActive = 1
				
					UNION ALL
				
					SELECT d.ServiceType
						,d.OthersRateCardMasterID
						,d.BKID
						,d.QuotationNo
						,d.QuotationID
						,d.BookingID
						,d.BID
						,d.ValidFrom
						,d.ValidTo
						,d.EndDate
						,d.City
						,d.SpecialServiceID
						,d.SpecialService
						,d.VendorID
						,d.Vendor
						,d.NationalityID
						,d.Nationality
						,d.CurrencyID
						,d.IsActive
						,d.CreatedOn
						,d.UpdatedOn
						,d.SpecialServiceRateID
						,d.ReasonID
						,d.Adult
						,d.AdultGrossRate
						,d.PerPersonChild
						,d.ChildGrossRate
						,d.Consolidated
						,d.ConsolidateGrossRate
						,DATEADD(DAY, 1, d.ServiceDate) AS ServiceDate,d.ServiceID
					FROM SpecialServiceDateRange d
					WHERE DATEADD(DAY, 1, d.ServiceDate) <= ISNULL(d.EndDate,ServiceDate)
					)
				INSERT INTO Booking.DayWiseBooking (
					RateTypeID
					,QuotationID
					,BookingID
					,DayWiseDate
					,City
					,ServiceID
					,ServiceName
					,Vendor
					,Adult
					,Child
					,Adult_Rate
					,Child_Rate
					,Consolidated
					,CreatedOn
					,Currency
					,CreatedBy
					,bormid
					,XOLock
					,IsOkXO,
					IsActive,Nationality
					)OUTPUT INSERTED.ID INTO @NewDayWiseIDs(ID)
				SELECT 4 AS RateTypeID
					,QuotationID
					,BookingID
					,ServiceDate AS DayWiseDate
					,City
					,SpecialServiceID
					,SpecialService
					,VendorID
					,Adult
					,PerPersonChild
					,AdultGrossRate
					,ChildGrossRate
					,Consolidated
					,GETDATE() AS CreatedOn
					,CurrencyID
					,@OperationBy
					,OthersRateCardMasterID
					,0
					,0,
					1,NationalityID
				FROM SpecialServiceDateRange
				OPTION (MAXRECURSION 0);

					--DECLARE cur CURSOR FOR SELECT ID FROM @NewDayWiseIDs;
					--OPEN cur;
					--FETCH NEXT FROM cur INTO @ID;
					--WHILE @@FETCH_STATUS = 0
					--BEGIN
					--	EXEC Booking.UpdateDayWiseBooking
					--		@Action = 'IXO',
					--		@ID = @ID,@SGL_Rate = NULL,@MealList = @EmptyMealList;
					--	FETCH NEXT FROM cur INTO @ID;
					--END
					--CLOSE cur;
					--DEALLOCATE cur;
					END;
			COMMIT;

			SELECT 'Success' AS STATUS;
		END TRY

		BEGIN CATCH
			ROLLBACK;

			SELECT 'Error' AS STATUS
				,ERROR_MESSAGE() AS ErrorMessage;
		END CATCH
	END
	ELSE IF @Action = 'A'
	BEGIN
		BEGIN TRY
			BEGIN TRANSACTION;
			DECLARE @NewDayWiseID TABLE (ID BIGINT);
			DECLARE @RateTypeID INT;
			DECLARE @value INT;

			SELECT @RateTypeID = RateTypeID
				,@value = CASE 
					WHEN RateTypeID = 5
						THEN BHRMID
					ELSE BORMID
					END
			FROM Booking.DayWiseBooking
			WHERE id = @Id;

			IF @RateTypeID = 5
			BEGIN
				INSERT INTO Booking.DayWiseBooking (
					QuotationID
					,DayWiseDate
					,City
					,ServiceID
					,ServiceName
					,Guide
					,Vendor
					,Currency
					,Adult
					,Child
					,Consolidated
					,BookingID
					,RateTypeID
					,HotelName
					,RoomCategory
					,MealPlan
					,Breakfast
					,Lunch
					,Dinner
					--,ServiceName
					,VehicleType
					,CountOfVehicle
					--,ServiceName
					,CountOfGuide
					,DBL
					,EBA
					,EBC
					,CNB
					,SGL
					,IsActive
					,CreatedBy
					,CreatedOn
					,GrossRate
					,DBL_Rate
					,EBA_Rate
					,EBC_Rate
					,CNB_Rate
					,SGL_Rate
					,Adult_Rate
					,Child_Rate
					,BHRMID
					,BORMID
					,XOLock
					,IsOkXO
					
					)OUTPUT INSERTED.ID INTO @NewDayWiseID(ID)
				SELECT TOP 1 QuotationID
					,DATEADD(DAY, 1, DayWiseDate) AS DayWiseDate
					,City
					,ServiceID
					,ServiceName
					,Guide
					,Vendor
					,Currency
					,Adult
					,Child
					,Consolidated
					,BookingID
					,RateTypeID
					,HotelName
					,RoomCategory
					,MealPlan
					,Breakfast
					,Lunch
					,Dinner
					--,ServiceName
					,VehicleType
					,CountOfVehicle
					--,ServiceName
					,CountOfGuide
					,DBL
					,EBA
					,EBC
					,CNB
					,SGL
					,1
					,@OperationBy
					,GETDATE() AS CurrentDate
					,GrossRate
					,DBL_Rate
					,EBA_Rate
					,EBC_Rate
					,CNB_Rate
					,SGL_Rate
					,Adult_Rate
					,Child_Rate
					,BHRMID
					,BORMID
					,XOLock
					,IsOkXO
					
				FROM Booking.DayWiseBooking
				WHERE BHRMID = @value
				ORDER BY DayWiseDate DESC;
			END
			ELSE
			BEGIN
				INSERT INTO Booking.DayWiseBooking (
					QuotationID
					,DayWiseDate
					,City
					,ServiceID
					,ServiceName
					,Guide
					,Vendor
					,Currency
					,Adult
					,Child
					,Consolidated
					,BookingID
					,RateTypeID
					,HotelName
					,RoomCategory
					,MealPlan
					,Breakfast
					,Lunch
					,Dinner
					--,ServiceName
					,VehicleType
					,CountOfVehicle
					--,ServiceName
					,CountOfGuide
					,DBL
					,EBA
					,EBC
					,CNB
					,SGL
					,IsActive
					,CreatedBy
					,CreatedOn
					,GrossRate
					,DBL_Rate
					,EBA_Rate
					,EBC_Rate
					,CNB_Rate
					,SGL_Rate
					,Adult_Rate
					,Child_Rate
					,BHRMID
					,BORMID
					,XOLock
					,IsOkXO
					)OUTPUT INSERTED.ID INTO @NewDayWiseID(ID)
				SELECT TOP 1 QuotationID
					,DATEADD(DAY, 1, DayWiseDate) AS DayWiseDate
					,City
					,ServiceID
					,ServiceName
					,Guide
					,Vendor
					,Currency
					,Adult
					,Child
					,Consolidated
					,BookingID
					,RateTypeID
					,HotelName
					,RoomCategory
					,MealPlan
					,Breakfast
					,Lunch
					,Dinner
					--,ServiceName
					,VehicleType
					,CountOfVehicle
					--,ServiceName
					,CountOfGuide
					,DBL
					,EBA
					,EBC
					,CNB
					,SGL
					,1
					,@OperationBy
					,GETDATE() AS CurrentDate
					,GrossRate
					,DBL_Rate
					,EBA_Rate
					,EBC_Rate
					,CNB_Rate
					,SGL_Rate
					,Adult_Rate
					,Child_Rate
					,BHRMID
					,BORMID
					,XOLock
					,IsOkXO
				FROM Booking.DayWiseBooking
				WHERE BORMID = @value
				ORDER BY DayWiseDate DESC;
			END
			DECLARE cur CURSOR FOR SELECT ID FROM @NewDayWiseID;
					OPEN cur;
					FETCH NEXT FROM cur INTO @ID;
					WHILE @@FETCH_STATUS = 0
					BEGIN
						EXEC Booking.UpdateDayWiseBooking
							@Action = 'IXO',
							@ID = @ID,@SGL_Rate = NULL,@MealList = @EmptyMealList;
						FETCH NEXT FROM cur INTO @ID;
					END
					CLOSE cur;
					DEALLOCATE cur;
			COMMIT;

			SELECT 'Success' AS STATUS;
		END TRY

		BEGIN CATCH
			ROLLBACK;

			SELECT 'Error' AS STATUS
				,ERROR_MESSAGE() AS ErrorMessage;
		END CATCH
	END
	ELSE IF @Action = 'U'
	BEGIN
    -- Step 1: Deactivate the booking entry
    UPDATE Booking.DayWiseBooking
    SET IsActive = 0,
        ModifiedBy = @OperationBy
    WHERE BookingID = @BookingID
      AND ID = @Id

    -- Step 2: Get the date of the deactivated booking
    DECLARE @Date datetime;
    SELECT @Date = DayWiseDate
    FROM Booking.DayWiseBooking
    WHERE BookingID = @BookingID
      AND ID = @Id;

    -- Step 3: Check if the date was retrieved
    IF @Date IS NOT NULL
    BEGIN
        DECLARE @FormattedDate VARCHAR(10);
        SET @FormattedDate = FORMAT(@Date, 'dd-MM-yyyy');

        SELECT 
            '200' AS returnCode,
            'The entry for ' + @FormattedDate + ' has been removed successfully' AS returnMessage,
            GETDATE() AS LastSavedOn;
			 BEGIN
	 If EXISTS((select * from XO xo inner join DayWiseBooking dwb on dwb.GroupKey = xo.GroupKey and dwb.BookingID=xo.Qut_ID  where   dwb.ID=@ID))
	 BEGIN
	SELECT '201' AS returnCode, GETDATE() as LastSavedOn, 'XO number already exists' AS returnMessage;                                                 

	 END
	 ELSe
	 BEGIN
	  UPDATE Booking.DayWiseBooking
            SET IsOKXO = 0
			,GroupKey = NULL
            WHERE ID = @ID;
	SELECT '200' AS returnCode, GETDATE() as LastSavedOn, 'The selected item has been removed from XO successfully.' AS returnMessage;                                                 

	 END
	 END
    END

    ELSE
    BEGIN
        SELECT 
            '404' AS returnCode,
            'No booking entry found for the provided ID and BookingID.' AS returnMessage,
            GETDATE() AS LastSavedOn;
    END

END
ELSE IF @Action = 'F'
	BEGIN
		BEGIN TRY
			BEGIN TRANSACTION;

			UPDATE Booking.DayWiseBooking
			SET IsOkXO = 1
				,ModifiedBy = @OperationBy
			WHERE BookingID = @BookingID
				AND ID = @Id

			COMMIT;

			SELECT 'Success' AS STATUS;
		END TRY

		BEGIN CATCH
			ROLLBACK;

			SELECT 'Error' AS STATUS
				,ERROR_MESSAGE() AS ErrorMessage;
		END CATCH
	END
END

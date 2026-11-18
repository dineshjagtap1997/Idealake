
ALTER PROCEDURE [Booking].[usp_GetDayWiseServiceData] 
    @BookingID INT = 498,
    @RateTypeID INT = 6
AS
BEGIN
    SET NOCOUNT ON;

    IF (@RateTypeID = 1) --Guide 
    BEGIN

SELECT 
    DB.ID,
    DB.DayWiseDate,
    C.Name AS CityName,
    DB.City,
    DB.ServiceName,
    DB.ServiceID,
    vm.VendorName AS VendorInfo,
    n.Nationality AS NationalityInfo,
    DB.Language,
    DB.RateType,
    DB.Adult,
    DB.Adult_Rate,
    DB.Child,
    DB.Child_Rate,
    DB.GrossRate,
    DB.Consolidated,
    DB.XoLock,
    DB.Count,
    DB.IsOkXO,
    tbl.StartDate,
    tbl.EndDate,
    DB.Currency,
    DB.ISXOGen,

    -- RCTypeFlag logic
    (SELECT 
        CASE 
            WHEN ratecardmodetypeid = 3 THEN '#E8B500' 
            ELSE 
                CASE 
                    WHEN IsCustom = 0 THEN '#52BB00' 
                    WHEN IsCustom = 1 THEN '#FF4141' 
                    ELSE '#E8B500' 
                END 
        END AS RCFlag  
     FROM Booking.OthersRateCardMasterBooking 
     WHERE id = DB.BORMID) AS RCTypeFlag,

    -- CommissionJSON Subquery
    (
        SELECT 
            OC.ID AS OthersRateCardMasterID,
            OC.CommissionMasterID,
            OC.CommissionMasterID AS MasterCommissionID,
            OC.TaxPercentage,
            OC.TaxAmount,
            OC.NetAmountIncludingTax AS GrossAmountIncludingTax,
            OC.NetAmountExcludingTax AS GrossAmountExcludingTax,
            OC.GrossRate,
            OC.MarkupRate,
            OC.Markup_IsRate,
            OC.IsActive
        FROM Booking.OthersRateCardCommissionBooking OC
        WHERE OC.OthersRateRefrenceID = DB.BORMID 
          AND OC.BookingID = @BookingID
        FOR JSON PATH
    ) AS CommissionJSON,

    -- Custom Ratecard logic when IsCustom = 1
   (
                SELECT 
                    HRD.HotelRateID,
                    HRD.CityID,
                    HRD.CurrencyID,
                    HRD.HotelID,
                    HRD.RoomCategoryID,
                    HRD.MealPlanID,
                    HRD.VendorID,
                    HRD.PaymentTypeID,
                    HRD.IsCommission,
                    HRD.IsActive, 
                    ISNULL(c.[Name], '') AS City,
                    hm.HotelName,
                    vm.VendorName AS Vendor,
                    HRD.IsTax,
                    HRD.LanguageID,
                    HRD.VehicleCategoryID,
                    HRD.ServiceID,
                    HRD.NationalityID,
                    HRD.RateType,
                    HRD.RatePreferenceID,
                    HRD.QuotationID,
                    
                    -- Commissions
                    (SELECT 
                        RC.CommisionPercentage AS CommissionPercentage, 
                        RC.*, 
                        RCM.RateType, 
                        RC.CommissionMasterID AS MasterCommissionID, 
                        RC.RateCommisionID AS RateCommissionID
                    FROM [CustomRateCards].[HotelRateCommisionDetails] RC 
                    LEFT JOIN RateCommissionMaster RCM ON RC.CommissionMasterID = RCM.CommMasterID 
                    WHERE RC.HotelRateID = HRD.HotelRateID
                    FOR JSON PATH
                    ) AS Commissions,
					 -- -- Meals
			  (
				SELECT RM.*, RM.DefineAmount as DefinedAmount FROM [CustomRateCards].[HotelRateMealOverview] RM
				WHERE RM.HotelRateID = HRD.HotelRateID
				FOR JSON PATH
			  ) AS Meals
            FROM CustomRateCards.HotelRateMaster HRD 
            LEFT JOIN [dbo].[HotelMaster] hm ON HRD.HotelID = hm.HotelID
            LEFT JOIN [dbo].[City] c ON c.IATACode = HRD.CityID
            LEFT JOIN [dbo].VendorMaster vm ON vm.VendorID = HRD.VendorID
            WHERE HRD.HotelRateID = ORCM.RateID 
              AND DB.RateTypeID = 1
            FOR JSON PATH
        ) AS CustomRateMasterData

FROM Booking.DayWiseBooking DB

-- Joins for related tables
LEFT JOIN Booking.OthersRateCardMasterBooking ORCM ON ORCM.ID = DB.BORMID
LEFT JOIN VendorMaster vm ON vm.VendorID = DB.Vendor
LEFT JOIN Booking.tbl_Booking tbl ON tbl.ID = DB.BookingID
LEFT JOIN Nationality n ON n.ID = DB.Nationality
LEFT JOIN City C ON C.IATACode = DB.City

-- Filters for active bookings with matching RateTypeID
WHERE DB.RateTypeID = 1
  AND DB.BookingID = @BookingID
  AND DB.IsActive = 1

ORDER BY DB.DayWiseDate

-- Return the results as JSON
FOR JSON PATH;



--             SELECT 
--    DB.ID,
--    DB.DayWiseDate,
--    C.Name AS CityName,
--	DB.City,
--    DB.ServiceName,
--    DB.ServiceID,
--    vm.VendorName AS VendorInfo,
--    n.Nationality AS NationalityInfo,
--	Db.Language,
--    DB.RateType,
--    DB.Adult,
--    DB.Adult_Rate,
--    DB.Child,
--    DB.Child_Rate,
--    DB.GrossRate,
--    DB.Consolidated,
--	DB.XoLock,
--	DB.Count,
--	DB.IsOkXO,
--	tbl.StartDate,tbl.EndDate,
--	DB.Currency,
--	DB.ISXOGen,
--(select case when ratecardmodetypeid =3 then '#E8B500' else  (case IsCustom when 0 Then  '#52BB00' when 1 Then '#FF4141' else '#E8B500' End ) end as RCFlag  from Booking.OthersRateCardMasterBooking where id = DB.BORMID) as RCTypeFlag,

--    (
--        SELECT 
--            OC.ID AS OthersRateCardMasterID,
--            OC.CommissionMasterID,
--            OC.CommissionMasterID AS MasterCommissionID,
--           -- RCM.RateType,  -- Mapped via join
--            OC.TaxPercentage,
--            OC.TaxAmount,
--            OC.NetAmountIncludingTax AS GrossAmountIncludingTax,
--            OC.NetAmountExcludingTax AS GrossAmountExcludingTax,
--            OC.GrossRate,
--            OC.MarkupRate,
--            OC.Markup_IsRate,
--            OC.IsActive
--        FROM Booking.OthersRateCardCommissionBooking OC
--      --  INNER JOIN RateCommissionMaster RCM ON OC.CommissionMasterID = RCM.CommMasterID
--        WHERE OC.OthersRateRefrenceID = DB.BORMID and OC.BookingID = @BookingID
--        FOR JSON PATH
--    ) AS CommissionJSON,



--FROM Booking.DayWiseBooking DB
----left JOIN Booking.OthersRateCardMasterBooking ORCM ON ORCM.ID = DB.BORMID
--LEFT JOIN VendorMaster vm ON vm.VendorID = DB.Vendor
--left join Booking.tbl_Booking tbl on tbl.ID =db.BookingID
--LEFT JOIN Nationality n ON n.ID = DB.Nationality
--LEFT JOIN City C ON C.IATACode = DB.City
--WHERE DB.RateTypeID = 1
--  AND DB.BookingID = @BookingID-- AND  ORCM.BookingID = @BookingID
--  AND DB.IsActive = 1
--  Order By 
--  DB.DayWiseDate    
--  FOR JSON PATH
    END
    ELSE IF (@RateTypeID = 2)
    BEGIN
          SELECT 
    DB.ID,
    DB.DayWiseDate,
    C.Name AS CityName,
	DB.City,
    DB.ServiceName,
    DB.ServiceID,
	
    vm.VendorName AS VendorInfo,
    n.Nationality as NationalityInfo,
	DB.Nationality,
	DB.Vendor,
    DB.RateType,
    DB.Adult,
    DB.Adult_Rate,
    DB.Child,
    DB.Child_Rate,
    DB.GrossRate,
    DB.Consolidated,
	DB.XoLock,
	DB.IsOkXO,
	tbl.StartDate,tbl.EndDate,db.Currency,
	DB.ISXOGen,

	DB.count,
(select case when ratecardmodetypeid =3 then '#E8B500' else  (case IsCustom when 0 Then  '#52BB00' when 1 Then '#FF4141' else '#E8B500' End ) end as RCFlag  from Booking.OthersRateCardMasterBooking where id = DB.BORMID) as RCTypeFlag,

    (
        SELECT 
            OC.ID AS OthersRateCardMasterID,
            OC.CommissionMasterID,
            OC.CommissionMasterID AS MasterCommissionID,
            RCM.RateType,  -- Mapped via join
            OC.TaxPercentage,
            OC.TaxAmount,
            OC.NetAmountIncludingTax AS GrossAmountIncludingTax,
            OC.NetAmountExcludingTax AS GrossAmountExcludingTax,
            OC.GrossRate,
			OC.NetAmountIncludingTax,
            OC.NetAmountExcludingTax,
            OC.MarkupRate,
            OC.Markup_IsRate,
            OC.IsActive
        FROM Booking.OthersRateCardCommissionBooking OC
        INNER JOIN RateCommissionMaster RCM ON OC.CommissionMasterID = RCM.CommMasterID
        WHERE OC.OthersRateRefrenceID = DB.BORMID
        FOR JSON PATH
    ) AS CommissionJSON,
	 -- Custom Ratecard logic when IsCustom = 1
   (
                SELECT 
                    HRD.HotelRateID,
                    HRD.CityID,
                    HRD.CurrencyID,
                    HRD.HotelID,
                    HRD.RoomCategoryID,
                    HRD.MealPlanID,
                    HRD.VendorID,
                    HRD.PaymentTypeID,
                    HRD.IsCommission,
                    HRD.IsActive, 
                    ISNULL(c.[Name], '') AS City,
                    hm.HotelName,
                    vm.VendorName AS Vendor,
                    HRD.IsTax,
                    HRD.LanguageID,
                    HRD.VehicleCategoryID,
                    HRD.ServiceID,
                    HRD.NationalityID,
                    HRD.RateType,
                    HRD.RatePreferenceID,
                    HRD.QuotationID,
                    
                    -- Commissions
                    (SELECT 
                        RC.CommisionPercentage AS CommissionPercentage, 
                        RC.*, 
                        RCM.RateType, 
                        RC.CommissionMasterID AS MasterCommissionID, 
                        RC.RateCommisionID AS RateCommissionID
                    FROM [CustomRateCards].[HotelRateCommisionDetails] RC 
                    LEFT JOIN RateCommissionMaster RCM ON RC.CommissionMasterID = RCM.CommMasterID 
                    WHERE RC.HotelRateID = HRD.HotelRateID
                    FOR JSON PATH
                    ) AS Commissions,
					 -- -- Meals
			  (
				SELECT RM.*, RM.DefineAmount as DefinedAmount FROM [CustomRateCards].[HotelRateMealOverview] RM
				WHERE RM.HotelRateID = HRD.HotelRateID
				FOR JSON PATH
			  ) AS Meals
            FROM CustomRateCards.HotelRateMaster HRD 
            LEFT JOIN [dbo].[HotelMaster] hm ON HRD.HotelID = hm.HotelID
            LEFT JOIN [dbo].[City] c ON c.IATACode = HRD.CityID
            LEFT JOIN [dbo].VendorMaster vm ON vm.VendorID = HRD.VendorID
            WHERE HRD.HotelRateID = ORCM.RateID 
              AND DB.RateTypeID = 2
            FOR JSON PATH
        ) AS CustomRateMasterData

FROM Booking.DayWiseBooking DB
LEFT JOIN Booking.OthersRateCardMasterBooking ORCM ON ORCM.ID = DB.BORMID
left join Booking.tbl_Booking tbl on tbl.ID =db.BookingID
LEFT JOIN VendorMaster vm ON vm.VendorID = DB.Vendor
LEFT JOIN Nationality n ON n.ID = DB.Nationality
LEFT JOIN City C ON C.IATACode = DB.City
WHERE DB.RateTypeID = 2
  AND DB.BookingID = @BookingID
  AND DB.IsActive = 1
   Order By 
  DB.DayWiseDate 
      FOR JSON PATH

    END
    ELSE IF (@RateTypeID = 3)
    BEGIN
          SELECT 
    DB.ID,
    DB.DayWiseDate,
    DB.City,
	DB.ServiceID,
    DB.ServiceName,
	C.Name AS CityName,
	DB.Vendor,
    vm.VendorName AS VendorInfo,
    n.Nationality AS NationalityInfo,
	--VT.VehicleType,
	Db.Vehical,
	HRD.VehicleCategoryID,
    VCM.VehicleType AS VehicleCategoryName,
    DB.RateType,
    DB.Adult,
    DB.Adult_Rate,
    DB.Child,
    DB.Child_Rate,
    DB.GrossRate,
    DB.Consolidated,
	DB.XoLock,
	Db.IsOkXO,
	tbl.StartDate,tbl.EndDate,
	DB.Count,
	DB.currency,
	DB.ISXOGen,

(select case when ratecardmodetypeid =3 then '#E8B500' else  (case IsCustom when 0 Then  '#52BB00' when 1 Then '#FF4141' else '#E8B500' End ) end as RCFlag  from Booking.OthersRateCardMasterBooking where id = DB.BORMID) as RCTypeFlag,

    (
        SELECT 
            OC.ID AS OthersRateCardMasterID,
            OC.CommissionMasterID,
            OC.CommissionMasterID AS MasterCommissionID,
            RCM.RateType,  -- Mapped via join
            OC.TaxPercentage,
            OC.TaxAmount,
            OC.NetAmountIncludingTax AS GrossAmountIncludingTax,
            OC.NetAmountExcludingTax AS GrossAmountExcludingTax,
            OC.GrossRate,
            OC.MarkupRate,
            OC.Markup_IsRate,
            OC.IsActive
        FROM Booking.OthersRateCardCommissionBooking OC
        left JOIN RateCommissionMaster RCM ON OC.CommissionMasterID = RCM.CommMasterID
        WHERE OC.OthersRateRefrenceID = DB.BORMID
        FOR JSON PATH
    ) AS CommissionJSON,
	 -- Custom Ratecard logic when IsCustom = 1
   (
                SELECT 
                    HRD.HotelRateID,
                    HRD.CityID,
                    HRD.CurrencyID,
                    HRD.HotelID,
                    HRD.RoomCategoryID,
                    HRD.MealPlanID,
                    HRD.VendorID,
                    HRD.PaymentTypeID,
                    HRD.IsCommission,
                    HRD.IsActive, 
                    ISNULL(c.[Name], '') AS City,
                    hm.HotelName,
                    vm.VendorName AS Vendor,
                    HRD.IsTax,
                    HRD.LanguageID,
                    HRD.VehicleCategoryID,
					 VCM.VehicleType AS VehicleCategoryName,
                    HRD.ServiceID,
                    HRD.NationalityID,
                    HRD.RateType,
                    HRD.RatePreferenceID,
                    HRD.QuotationID,
                    
                    -- Commissions
                    (SELECT 
                        RC.CommisionPercentage AS CommissionPercentage, 
                        RC.*, 
                        RCM.RateType, 
                        RC.CommissionMasterID AS MasterCommissionID, 
                        RC.RateCommisionID AS RateCommissionID
                    FROM [CustomRateCards].[HotelRateCommisionDetails] RC 
                    LEFT JOIN RateCommissionMaster RCM ON RC.CommissionMasterID = RCM.CommMasterID 
                    WHERE RC.HotelRateID = HRD.HotelRateID
                    FOR JSON PATH
                    ) AS Commissions,
					 -- -- Meals
			  (
				SELECT RM.*, RM.DefineAmount as DefinedAmount FROM [CustomRateCards].[HotelRateMealOverview] RM
				WHERE RM.HotelRateID = HRD.HotelRateID
				FOR JSON PATH
			  ) AS Meals
            FROM CustomRateCards.HotelRateMaster HRD 
            LEFT JOIN [dbo].[HotelMaster] hm ON HRD.HotelID = hm.HotelID
            LEFT JOIN [dbo].[City] c ON c.IATACode = HRD.CityID
            LEFT JOIN [dbo].VendorMaster vm ON vm.VendorID = HRD.VendorID
			LEFT JOIN VehicleTypeMaster VCM ON VCM.ID = HRD.VehicleCategoryID 
            WHERE HRD.HotelRateID = ORCM.RateID 
              AND DB.RateTypeID = 3
            FOR JSON PATH
        ) AS CustomRateMasterData
FROM Booking.DayWiseBooking DB
LEFT JOIN Booking.OthersRateCardMasterBooking ORCM ON ORCM.ID = DB.BORMID
left join Booking.tbl_Booking tbl on tbl.ID =db.BookingID
LEFT JOIN VendorMaster vm ON vm.VendorID = DB.Vendor
LEFT JOIN Nationality n ON n.ID = DB.Nationality
--LEFT JOIN VehicleTypeMaster VT ON VT.ID = Db.Vehical
LEFT JOIN City C ON C.IATACode = DB.City
 LEFT JOIN CustomRateCards.HotelRateMaster HRD ON HRD.HotelRateID = ORCM.RateID AND DB.RateTypeID = 3
    LEFT JOIN VehicleTypeMaster VCM ON VCM.ID = HRD.VehicleCategoryID
WHERE DB.RateTypeID = 3
  AND DB.BookingID = @BookingID
  AND DB.IsActive = 1
   Order By 
  DB.DayWiseDate 
    FOR JSON PATH

    END
    ELSE IF (@RateTypeID = 4)
    BEGIN
     SELECT DISTINCT
    DB.ID,
    DB.DayWiseDate,
    DB.City,
    DB.ServiceName,
    DB.ServiceID,

    vm.VendorName AS VendorInfo,
	DB.Vendor,
    n.Nationality AS NationalityInfo,
	DB.Nationality,
    DB.RateType,
    DB.Adult,
    DB.Adult_Rate,
    DB.Child,
    DB.Child_Rate,
    DB.GrossRate,
    DB.Consolidated,
	DB.XoLock,
	DB.IsOkXO,
	--ORCC.MinimumPax,
	--ORCC.MaximumPax,
	--ORCC.TaxAmount,
	ORCM.TaxID,
	ORCM.RatePreferenceID,
	DB.count,tbl.StartDate,tbl.EndDate,db.Currency,
	DB.ISXOGen,

	C.Name AS CityName,
(select case when ratecardmodetypeid =3 then '#E8B500' else  (case IsCustom when 0 Then  '#52BB00' when 1 Then '#FF4141' else '#E8B500' End ) end as RCFlag  from Booking.OthersRateCardMasterBooking where id = DB.BORMID) as RCTypeFlag,

    (
        SELECT 
            OC.ID AS OthersRateCardMasterID,
            OC.CommissionMasterID,
            OC.CommissionMasterID AS MasterCommissionID,
            isnull(RCM.RateType,'Consolidated') as RateType,  -- Mapped via join
            OC.TaxPercentage,
            OC.TaxAmount,
            OC.NetAmountExcludingTax AS GrossAmountExcludingTax,
            OC.NetAmountIncludingTax AS GrossAmountIncludingTax,
            OC.GrossRate,
            OC.MarkupRate,
            OC.Markup_IsRate,
            OC.IsActive
        FROM Booking.OthersRateCardCommissionBooking OC
        LEFT JOIN RateCommissionMaster RCM ON OC.CommissionMasterID = RCM.CommMasterID
        WHERE OC.OthersRateRefrenceID = DB.BORMID
        FOR JSON PATH
    ) AS CommissionJSON,
	 -- Custom Ratecard logic when IsCustom = 1
   (
                SELECT 
                    HRD.HotelRateID,
                    HRD.CityID,
                    HRD.CurrencyID,
                    HRD.HotelID,
                    HRD.RoomCategoryID,
                    HRD.MealPlanID,
                    HRD.VendorID,
                    HRD.PaymentTypeID,
                    HRD.IsCommission,
                    HRD.IsActive, 
                    ISNULL(c.[Name], '') AS City,
                    hm.HotelName,
                    vm.VendorName AS Vendor,
                    HRD.IsTax,
                    HRD.LanguageID,
                    HRD.VehicleCategoryID,
                    HRD.ServiceID,
                    HRD.NationalityID,
                    HRD.RateType,
                    HRD.RatePreferenceID,
                    HRD.QuotationID,
                    
                    -- Commissions
                    (SELECT 
                        RC.CommisionPercentage AS CommissionPercentage, 
                        RC.*, 
                        RCM.RateType, 
                        RC.CommissionMasterID AS MasterCommissionID, 
                        RC.RateCommisionID AS RateCommissionID
                    FROM [CustomRateCards].[HotelRateCommisionDetails] RC 
                    LEFT JOIN RateCommissionMaster RCM ON RC.CommissionMasterID = RCM.CommMasterID 
                    WHERE RC.HotelRateID = HRD.HotelRateID
                    FOR JSON PATH
                    ) AS Commissions,
					 -- -- Meals
			  (
				SELECT RM.*, RM.DefineAmount as DefinedAmount FROM [CustomRateCards].[HotelRateMealOverview] RM
				WHERE RM.HotelRateID = HRD.HotelRateID
				FOR JSON PATH
			  ) AS Meals
            FROM CustomRateCards.HotelRateMaster HRD 
            LEFT JOIN [dbo].[HotelMaster] hm ON HRD.HotelID = hm.HotelID
            LEFT JOIN [dbo].[City] c ON c.IATACode = HRD.CityID
            LEFT JOIN [dbo].VendorMaster vm ON vm.VendorID = HRD.VendorID
            WHERE HRD.HotelRateID = ORCM.RateID 
              AND DB.RateTypeID = 4
            FOR JSON PATH
        ) AS CustomRateMasterData
FROM Booking.DayWiseBooking DB
LEFT JOIN Booking.OthersRateCardMasterBooking ORCM ON ORCM.ID = DB.BORMID
left join Booking.tbl_Booking tbl on tbl.ID =db.BookingID
INNER JOIN Booking.OthersRateCardCommissionBooking ORCC ON ORCC.OthersRateRefrenceID = ORCM.ID
LEFT JOIN VendorMaster vm ON vm.VendorID = DB.Vendor
LEFT JOIN Nationality n ON n.ID = DB.Nationality
left JOIN City c on c.IATACode=DB.City

WHERE DB.RateTypeID = 4
  AND DB.BookingID = @BookingID
  AND DB.IsActive = 1
   Order By 
  DB.DayWiseDate 
  FOR JSON PATH

    END
    ELSE IF (@RateTypeID = 5)
    BEGIN
   
   
   --dwb.*,

   SELECT dwb.ID, dwb.QuotationID, dwb.DayWiseDate, dwb.City, dwb.ServiceID, dwb.ServiceName, dwb.Guide, dwb.Language, dwb.Vehical, dwb.Vendor, dwb.Currency, dwb.Count, dwb.Adult, dwb.Child, dwb.Consolidated, dwb.Nationality, dwb.TotalCost, dwb.ServiceType, dwb.IsLock, dwb.RateCardStatus, dwb.BookingID, dwb.RateTypeID, dwb.HotelName, dwb.RoomCategory, dwb.RateType, dwb.MealPlan, dwb.VehicleType, dwb.CountOfVehicle, dwb.CountOfGuide, dwb.CountOfAdult, dwb.CountOfChild, dwb.SpecialSerivice, dwb.VendorInfo, dwb.NationalityInfo, dwb.DBL, dwb.EBA, dwb.EBC, dwb.CNB, dwb.SGL, dwb.IsActive, dwb.CreatedBy, dwb.CreatedOn, dwb.ModifiedBy, dwb.ModifiedOn, dwb.GroupKey, dwb.GrossRate, dwb.RateID, dwb.RateDetailID, dwb.DBL_Rate, dwb.EBA_Rate, dwb.EBC_Rate, dwb.CNB_Rate, dwb.SGL_Rate, dwb.Adult_Rate, dwb.Child_Rate, dwb.TCountRate, dwb.BHRMID, dwb.BORMID, dwb.XOLock, dwb.IsOkXO, dwb.ParentID, dwb.QuotationSequence, dwb.IsXoGen, dwb.Twin, dwb.Twin_Rate,
   dwb.SGL_TaxPercentage,dwb.DBL_TaxPercentage,dwb.EBA_TaxPercentage,dwb.EBC_TaxPercentage,dwb.CNB_TaxPercentage,
c.Name AS CityName, HM.HotelID, RoomCat.ID AS RoomCatID
,MP.ID as MealPlanID,MP.Breakfast,MP.Lunch,MP.Dinner,o.StartDate,o.EndDate,
  --(select case IsCustom when 0 Then '#52BB00' when 1 Then '#FF4141' else '#E8B500' End as RCFlag  from Booking.HotelRateCardMasterBooking where id = dwb.bhrmid) as RCTypeFlag,
  		(select case when ratecardmodetypeid =3 then '#E8B500' else  (case IsCustom when 0 Then  '#52BB00' when 1 Then '#FF4141' else '#E8B500' End ) end as RCFlag  from Booking.HotelRateCardMasterBooking where id = dwb.BHRMID) as RCTypeFlag,

  (
        SELECT 
            RC.QuotationHotelRateCommissionId AS RateCommissionID,
            RC.CommissionMasterID,
            RC.CommissionMasterID AS MasterCommissionID,
            RCM.RateType,
			HMPM.MealTypeID,
			HMPM.NetAmountIncludingTax AS MealNetAmountIncludingTax,
			HMPM.NetAmountExcludingTax AS MealNetAmountExcludingTax,
            --RC.TaxPercentage,
            --RC.TaxAmount,
            RC.GrossAmountIncludingTax,
           -- RC.GrossAmountIncludingTax * dbo.fnGetPurchaseRate(dwb.Currency, dwb.Currency, GETDATE()) AS GrossAmountIncludingTax_Con,
            RC.GrossAmountExcludingTax,
            --RC.GrossAmountExcludingTax * dbo.fnGetPurchaseRate(dwb.Currency, dwb.Currency, GETDATE()) AS GrossAmountExcludingTax_Con,
            RC.NetAmountIncludingTax,
            --RC.NetAmountIncludingTax * dbo.fnGetPurchaseRate(dwb.Currency, dwb.Currency, GETDATE()) AS NetAmountIncludingTax_Con,
            RC.NetAmountExcludingTax
            --RC.NetAmountExcludingTax * dbo.fnGetPurchaseRate(dwb.Currency, dwb.Currency, GETDATE()) AS NetAmountExcludingTax_Con,
            --RC.CommisionPercentage,
            --RC.GrossRate,
            --RC.IsMarkup,
            --RC.MarkupValue,
            --RC.SellingRate,
            --RC.IsActive,
            --RC.IsMarkup AS Markup_IsRate,
            --RC.MarkupValue AS MarkupRate,
            --RC.ReasonMasterId AS ReasonID,
          --  RC.Count
        FROM Booking.HotelRateCommissionDetailsBooking RC
        INNER JOIN RateCommissionMaster RCM ON RC.CommissionMasterID = RCM.CommMasterID
		left JOIN Booking.HotelRateMealPlanMasterBooking HMPM ON --HMPM.HotelRateDetailID = RC.HotelRateDetailID 
		RCM.CommMasterID= HMPM.MasterCommissionID
        WHERE RC.QuotationHotelRateID = dwb.bhrmid AND dwb.IsActive = 1 
        FOR JSON PATH
    ) AS HotelCommissionJSON,
	  (
    SELECT
        M.QuotationHotelRateMealId as HotelRateMealID, MealType.RateType AS MealType,M.GstPercentage,M.GstAmount,
		M.SellingRate,
		M.MasterCommissionID,
       
        M.IsMealDetails,
        M.DefineAmount,
		 -- Conditionally select NetAmount based on @TaxID
		M.NetAmountIncludingTax as NetAmountIncludingTax,
		--dbo.fnSearchCalculateROE(M.NetAmountIncludingTax, @CheckIn, C1.Code, @CurrencyCode) AS NetAmountIncludingTax,
		M.NetAmountIncludingTax * dbo.fnGetPurchaseRate(HRM.CurrencyID,  o.Currency,  GETDATE()) AS NetAmountIncludingTax_Con,

		M.NetAmountExcludingTax as NetAmountExcludingTax,
       --dbo.fnSearchCalculateROE(M.NetAmountExcludingTax, @CheckIn, C1.Code, @CurrencyCode) AS NetAmountExcludingTax,
	    M.NetAmountExcludingTax * dbo.fnGetPurchaseRate(HRM.CurrencyID,  o.Currency,  GETDATE()) AS NetAmountExcludingTax_Con,
		M.HotelRateDetailID,
		ISNULL(M.IsSupplementary,0) as IsSupplementary,
		ISNULL(M.IsGross,0) as IsGross

	FROM Booking.HotelRateMealPlanMasterBooking M
    LEFT JOIN RateCommissionMaster MealType ON M.MasterCommissionID = MealType.CommMasterID
	Left Join Booking.HotelRateCardMasterBooking HRM on HRM.ID=dwb.BHRMID

    WHERE M.QuotationHotelRateID = dwb.BHRMID AND (M.IsActive = 1)AND dwb.IsActive = 1
    FOR JSON PATH
) AS MealOverviewJSON,
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
					FROM Booking.HotelRateOfferConfigurationCommissionBooking OCC
					LEFT JOIN RateCommissionMaster RCM ON OCC.MasterCommissionID = RCM.CommMasterID
					INNER JOIN RateCards.HotelRateOfferConfiguration OC on OCC.OfferConfigurationID = OC.OfferID
			INNER JOIN RATECARDS.HotelRateDetails RD ON RD.HotelRateDetailID = OC.HotelRateDetailID
			INNER JOIN RATECARDS.HotelRateMaster HRM ON HRM.HotelRateID = RD.HotelRateID
					WHERE 
					occ.BookingHotelRateID = dwb.bhrmid and
						 OCC.IsActive = 1 FOR JSON PATH)
					AS OfferCommission,
					 -- Custom Ratecard logic when IsCustom = 1
   (
                SELECT 
                    HRD.HotelRateID,
                    HRD.CityID,
                    HRD.CurrencyID,
                    HRD.HotelID,
                    HRD.RoomCategoryID,
                    HRD.MealPlanID,
                    HRD.VendorID,
                    HRD.PaymentTypeID,
                    HRD.IsCommission,
                    HRD.IsActive, 
                    ISNULL(c.[Name], '') AS City,
                    hm.HotelName,
                    vm.VendorName AS Vendor,
                    HRD.IsTax,
                    HRD.LanguageID,
                    HRD.VehicleCategoryID,
                    HRD.ServiceID,
                    HRD.NationalityID,
                    HRD.RateType,
                    HRD.RatePreferenceID,
                    HRD.QuotationID,
                    
                    -- Commissions
                    (SELECT 
                        RC.CommisionPercentage AS CommissionPercentage, 
                        RC.*, 
                        RCM.RateType, 
                        RC.CommissionMasterID AS MasterCommissionID, 
                        RC.RateCommisionID AS RateCommissionID
                    FROM [CustomRateCards].[HotelRateCommisionDetails] RC 
                    LEFT JOIN RateCommissionMaster RCM ON RC.CommissionMasterID = RCM.CommMasterID 
                    WHERE RC.HotelRateID = HRD.HotelRateID
                    FOR JSON PATH
                    ) AS Commissions,
					 -- -- Meals
			  (
				SELECT RM.*, RM.DefineAmount as DefinedAmount FROM [CustomRateCards].[HotelRateMealOverview] RM
				WHERE RM.HotelRateID = HRD.HotelRateID
				FOR JSON PATH
			  ) AS Meals
            FROM CustomRateCards.HotelRateMaster HRD 
            LEFT JOIN [dbo].[HotelMaster] hm ON HRD.HotelID = hm.HotelID
            LEFT JOIN [dbo].[City] c ON c.IATACode = HRD.CityID
            LEFT JOIN [dbo].VendorMaster vm ON vm.VendorID = HRD.VendorID
            WHERE HRD.HotelRateID = ORCM.HotelRateID 
              AND dwb.RateTypeID =  5
            FOR JSON PATH
        ) AS CustomRateMasterData

FROM Booking.DayWiseBooking dwb 
inner join Booking.tbl_Booking o on o.ID=dwb.BookingID
LEFT JOIN Booking.HotelRateCardMasterBooking ORCM ON ORCM.ID=dwb.BHRMID
left JOIN City c on c.IATACode=dwb.City
Left JOIN HotelMaster HM on Upper(HM.HotelName)=Upper(dwb.HotelName)
LEFT JOIN RoomCategory RoomCat ON dwb.RoomCategory = RoomCat.Name
--Left Join MealPlan MP on MP.Code=dwb.MealPlan


LEFT JOIN MealPlan MP ON ORCM.MealPlanID = MP.ID
		AND MP.IsActive = 1

WHERE dwb.RateTypeID = 5
  AND dwb.BookingID = @BookingID AND dwb.IsActive = 1
   Order By 
  dwb.DayWiseDate 
      FOR JSON PATH;

	END
	   ELSE IF (@RateTypeID = 6)
    BEGIN
          SELECT 
    DB.ID,
    DB.DayWiseDate,
    C.Name AS CityName,
	DB.City,
    DB.ServiceName,
    DB.ServiceID,
	
    vm.VendorName AS VendorInfo,
    n.Nationality as NationalityInfo,
    DB.RateType,
    DB.Adult,
    DB.Adult_Rate,
    DB.Child,
    DB.Child_Rate,
    DB.GrossRate,
    DB.Consolidated,
	DB.XoLock,
	DB.IsOkXO,
	tbl.StartDate,tbl.EndDate,db.Currency as Currency,
	DB.ISXOGen,

	DB.count,
	motmaster.MOTNameORNumber,
				MOT.MOT,
				motrate.ClassTypeID,
				CT.Class,
				motmaster.Sector as Sectors,
(select case when ratecardmodetypeid =3 then '#E8B500' else  (case IsCustom when 0 Then  '#52BB00' when 1 Then '#FF4141' else '#E8B500' End ) end as RCFlag  from Booking.OthersRateCardMasterBooking where id = DB.BORMID) as RCTypeFlag,

    (
        SELECT 
            OC.ID AS OthersRateCardMasterID,
            OC.CommissionMasterID,
            OC.CommissionMasterID AS MasterCommissionID,
            RCM.RateType,  -- Mapped via join
            OC.TaxPercentage,
            OC.TaxAmount,
            OC.NetAmountIncludingTax AS GrossAmountIncludingTax,
            OC.NetAmountExcludingTax AS GrossAmountExcludingTax,
            OC.GrossRate,
            OC.MarkupRate,
            OC.Markup_IsRate,
            OC.IsActive
        FROM Booking.OthersRateCardCommissionBooking OC
        INNER JOIN RateCommissionMaster RCM ON OC.CommissionMasterID = RCM.CommMasterID
        WHERE OC.OthersRateRefrenceID = DB.BORMID
        FOR JSON PATH
    ) AS CommissionJSON
FROM Booking.DayWiseBooking DB
LEFT JOIN Booking.OthersRateCardMasterBooking ORCM ON ORCM.ID = DB.BORMID
left join Booking.tbl_Booking tbl on tbl.ID =db.BookingID
LEFT JOIN VendorMaster vm ON vm.VendorID = DB.Vendor
LEFT JOIN Nationality n ON n.ID = DB.Nationality
LEFT JOIN City C ON C.IATACode = DB.City
LEFT JOIN RateCards.MOTRateDetail motrate on motrate.MOTRateDetailID=db.RateDetailID
LEFT JOIN RateCards.MOTRateMaster motmaster on motmaster.ID=motrate.MOTRateID
LEFT JOIN MOT  MOT ON MOT.ID = motmaster.TravelModeTypeID
LEFT JOIN ClassType CT ON CT.ID = motrate.ClassTypeID
WHERE DB.RateTypeID = 6
  AND DB.BookingID = @BookingID
  AND DB.IsActive = 1
   Order By 
  DB.DayWiseDate 
      FOR JSON PATH

    END
	--AND dwb.ID IN (2987)
END;
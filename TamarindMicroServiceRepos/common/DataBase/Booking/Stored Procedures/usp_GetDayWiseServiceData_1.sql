
CREATE PROCEDURE [Booking].[usp_GetDayWiseServiceData_1] @BookingID INT = NULL
	,@RateTypeID INT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	IF (@RateTypeID = 1)
	BEGIN
		SELECT 
(
    SELECT
        DB.ID,
        DB.DayWiseDate,
        DB.City,
        DB.ServiceName,
        vm.VendorName AS VendorInfo,
        n.Nationality AS NationalityInfo,
        DB.RateType,
        DB.Adult,
        DB.Adult_Rate,
        DB.Child,
        DB.Child_Rate,
        DB.GrossRate,
        DB.Consolidated,
		DB.BookingID,
        (
            SELECT
                OC.ID AS OthersRateCardMasterID,
                OC.CommissionMasterID,
                OC.CommissionMasterID AS MasterCommissionID,
                RCM.RateType AS CommissionRateType,
                OC.TaxPercentage,
                OC.TaxAmount,
                OC.NetAmountExcludingTax AS GrossAmountIncludingTax,
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
    LEFT JOIN VendorMaster vm ON vm.VendorID = ORCM.VendorID
    LEFT JOIN Nationality n ON n.ID = ORCM.NationalityID
    WHERE DB.RateTypeID = 1 AND DB.BookingID = @BookingID AND DB.IsActive=1
    FOR JSON PATH, ROOT('BookingInfo')
) AS BookingWithCommission;
	END
	ELSE IF (@RateTypeID = 2)
	BEGIN
		SELECT 
(
    SELECT
        DB.ID,
        DB.DayWiseDate,
        DB.City,
        DB.ServiceName,
        vm.VendorName AS VendorInfo,
        n.Nationality AS NationalityInfo,
        DB.RateType,
        DB.Adult,
        DB.Adult_Rate,
        DB.Child,
        DB.Child_Rate,
        DB.GrossRate,
        DB.Consolidated,
		DB.BookingID,
        (
            SELECT
                OC.ID AS OthersRateCardMasterID,
                OC.CommissionMasterID,
                OC.CommissionMasterID AS MasterCommissionID,
                RCM.RateType AS CommissionRateType,
                OC.TaxPercentage,
                OC.TaxAmount,
                OC.NetAmountExcludingTax AS GrossAmountIncludingTax,
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
    LEFT JOIN VendorMaster vm ON vm.VendorID = ORCM.VendorID
    LEFT JOIN Nationality n ON n.ID = ORCM.NationalityID
    WHERE DB.RateTypeID = 2 AND DB.BookingID = @BookingID AND DB.IsActive=1
    FOR JSON PATH, ROOT('BookingInfo')
) AS BookingWithCommission;
	END
	ELSE IF (@RateTypeID = 3)
	BEGIN
	
		SELECT 
(
    SELECT
        DB.ID,
        DB.DayWiseDate,
        DB.City,
        DB.ServiceName,
        vm.VendorName AS VendorInfo,
        n.Nationality AS NationalityInfo,
        DB.RateType,
        DB.Adult,
        DB.Adult_Rate,
        DB.Child,
        DB.Child_Rate,
        DB.GrossRate,
        DB.Consolidated,
		DB.BookingID,
        (
            SELECT
                OC.ID AS OthersRateCardMasterID,
                OC.CommissionMasterID,
                OC.CommissionMasterID AS MasterCommissionID,
                RCM.RateType AS CommissionRateType,
                OC.TaxPercentage,
                OC.TaxAmount,
                OC.NetAmountExcludingTax AS GrossAmountIncludingTax,
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
    LEFT JOIN VendorMaster vm ON vm.VendorID = ORCM.VendorID
    LEFT JOIN Nationality n ON n.ID = ORCM.NationalityID
    WHERE DB.RateTypeID = 3 AND DB.BookingID = @BookingID AND DB.IsActive=1
    FOR JSON PATH, ROOT('BookingInfo')
) AS BookingWithCommission;



		--FROM Booking.DayWiseBooking DB
		--LEFT JOIN VehicleTypeMaster vtm ON vtm.ID = db.VehicleType
		--LEFT JOIN VendorMaster vm ON vm.VendorID = db.Vendor
		--WHERE RateTypeID = 3
		--	AND BookingID = @BookingID
	END
	ELSE IF (@RateTypeID = 4)
	BEGIN
		
		SELECT 
(
    SELECT
        DB.ID,
        DB.DayWiseDate,
        DB.City,
        DB.ServiceName,
        vm.VendorName AS VendorInfo,
        n.Nationality AS NationalityInfo,
        DB.RateType,
        DB.Adult,
        DB.Adult_Rate,
        DB.Child,
        DB.Child_Rate,
        DB.GrossRate,
        DB.Consolidated,
		DB.BookingID,
        (
            SELECT
                OC.ID AS OthersRateCardMasterID,
                OC.CommissionMasterID,
                OC.CommissionMasterID AS MasterCommissionID,
                RCM.RateType AS CommissionRateType,
                OC.TaxPercentage,
                OC.TaxAmount,
                OC.NetAmountExcludingTax AS GrossAmountIncludingTax,
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
    LEFT JOIN VendorMaster vm ON vm.VendorID = ORCM.VendorID
    LEFT JOIN Nationality n ON n.ID = ORCM.NationalityID
    WHERE DB.RateTypeID = 4 AND DB.BookingID = @BookingID AND DB.IsActive=1
    FOR JSON PATH, ROOT('BookingInfo')
) AS BookingWithCommission;

			
			--and db.ID = 6131
			--	select 
			--DB.ID,
			--DB.DayWiseDate,
			--City,
			--DB.ServiceName,
			--vm.VendorName as VendorInfo,
			--n.Nationality as NationalityInfo,
			--DB.RateType,
			--db.Adult,
			--db.Adult_Rate,
			--db.Child,
			--db.Child_Rate,
			--DB.GrossRate,
			--DB.Consolidated
			--from Booking.DayWiseBooking DB
			--left Join VendorMaster vm on vm.VendorID=db.Vendor
			--	left Join Nationality n on n.ID = DB.Nationality
			--where RateTypeID=4 and BookingID=@BookingID
	END
	ELSE IF (@RateTypeID = 5)
	BEGIN
		SELECT DB.ID
			,DB.DayWiseDate
			,c.Name AS City
			,DB.HotelName
			,DB.RoomCategory
			,SGL
			,DBL
			,EBA
			,EBC
			,CNB
			,SGL_Rate
			,DBL_Rate
			,EBA_Rate
			,EBC_Rate
			,CNB_Rate
			,GrossRate
			,DB.MealPlan
			,DB.Breakfast
			,DB.Lunch
			,DB.Dinner
			,DB.BookingID
		FROM Booking.DayWiseBooking DB
		LEFT JOIN City c ON c.IATACode = db.City
		WHERE RateTypeID = 5
			AND BookingID = @BookingID
	END
END;
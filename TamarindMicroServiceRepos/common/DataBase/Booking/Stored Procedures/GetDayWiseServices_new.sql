
CREATE PROCEDURE [Booking].[GetDayWiseServices_new]
    @BookingID INT,
    @Action VARCHAR(10),
    @Id INT = NULL,
    @OperationBy NVARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @Action = 'I'
    BEGIN
	--hotel
        BEGIN TRY
            BEGIN TRANSACTION;
			--For hotel
			WITH DateRange AS (
                --new logic for hotel
				SELECT
    HRM.ID,
    HRM.QuotationNo,
    HRM.ID AS HotelRateID,
    H.HotelID,
    H.HotelName,
    HRM.CityID,
	ct.Name,
    HRM.RoomCategoryID,
    RoomCat.Name AS RoomCategory,

    HRM.Days,
    CONCAT(
        CASE WHEN SUBSTRING(HRM.Days,1,1) = '1' THEN 'M' ELSE '' END,
        CASE WHEN SUBSTRING(HRM.Days,2,1) = '1' THEN 'T' ELSE '' END,
        CASE WHEN SUBSTRING(HRM.Days,3,1) = '1' THEN 'W' ELSE '' END,
        CASE WHEN SUBSTRING(HRM.Days,4,1) = '1' THEN 'T' ELSE '' END,
        CASE WHEN SUBSTRING(HRM.Days,5,1) = '1' THEN 'F' ELSE '' END,
        CASE WHEN SUBSTRING(HRM.Days,6,1) = '1' THEN 'S' ELSE '' END,
        CASE WHEN SUBSTRING(HRM.Days,7,1) = '1' THEN 'S' ELSE '' END
    ) AS DaysOfWeek,

    MP.Code AS MealPlanCode,
    MP.Breakfast,
    MP.Lunch,
    MP.Dinner,
    'NA' AS Disclaimer,

    HRM.OfferTypeID,
     CAST(HRM.CheckIn AS DATE) AS FromDate,
     CAST(HRM.CheckOut AS DATE) AS ToDate,
    CAST(HRM.CheckIn AS DATE) AS StayDate,
    O.ID as BookingID,
    HRM.CurrencyID AS Currency,
    dbo.fnGetPurchaseRate(HRM.CurrencyID, O.Currency, GETDATE()) AS PurchaseRate,

    -- Count and GrossRate per RateType
    RateSummary.SGL_Count,
    RateSummary.DBL_Count,
    RateSummary.EBA_Count,
    RateSummary.EBC_Count,
    RateSummary.CNB_Count,

    CASE WHEN o.SupplierTax_InCluding = 1 THEN RateSummary.SGL_GrossAmountIncludingTax
         ELSE RateSummary.SGL_GrossAmountExcludingTax END AS SGL_GrossRate,

    CASE WHEN o.SupplierTax_InCluding = 1 THEN RateSummary.DBL_GrossAmountIncludingTax
         ELSE RateSummary.DBL_GrossAmountExcludingTax END AS DBL_GrossRate,

    CASE WHEN o.SupplierTax_InCluding = 1 THEN RateSummary.EBA_GrossAmountIncludingTax
         ELSE RateSummary.EBA_GrossAmountExcludingTax END AS EBA_GrossRate,

    CASE WHEN o.SupplierTax_InCluding = 1 THEN RateSummary.EBC_GrossAmountIncludingTax
         ELSE RateSummary.EBC_GrossAmountExcludingTax END AS EBC_GrossRate,

    CASE WHEN o.SupplierTax_InCluding = 1 THEN RateSummary.CNB_GrossAmountIncludingTax
         ELSE RateSummary.CNB_GrossAmountExcludingTax END AS CNB_GrossRate,
		 
    (
        SELECT 
            RC.QuotationHotelRateCommissionId AS RateCommissionID,
            RC.CommissionMasterID,
            RC.CommissionMasterID AS MasterCommissionID,
            RCM.RateType,
            RC.TaxPercentage,
            RC.TaxAmount,
            RC.GrossAmountIncludingTax,
            RC.GrossAmountIncludingTax * dbo.fnGetPurchaseRate(HRM.CurrencyID, O.Currency, GETDATE()) AS GrossAmountIncludingTax_Con,
            RC.GrossAmountExcludingTax,
            RC.GrossAmountExcludingTax * dbo.fnGetPurchaseRate(HRM.CurrencyID, O.Currency, GETDATE()) AS GrossAmountExcludingTax_Con,
            RC.NetAmountIncludingTax,
            RC.NetAmountIncludingTax * dbo.fnGetPurchaseRate(HRM.CurrencyID, O.Currency, GETDATE()) AS NetAmountIncludingTax_Con,
            RC.NetAmountExcludingTax,
            RC.NetAmountExcludingTax * dbo.fnGetPurchaseRate(HRM.CurrencyID, O.Currency, GETDATE()) AS NetAmountExcludingTax_Con,
            RC.CommisionPercentage,
            RC.GrossRate,
            RC.IsMarkup,
            RC.MarkupValue,
            RC.SellingRate,
            RC.IsActive,
            RC.IsMarkup AS Markup_IsRate,
            RC.MarkupValue AS MarkupRate,
            RC.ReasonMasterId AS ReasonID,
            RC.Count
        FROM Booking.HotelRateCommissionDetailsBooking RC
        INNER JOIN RateCommissionMaster RCM ON RC.CommissionMasterID = RCM.CommMasterID
        WHERE RC.QuotationHotelRateID = HRM.ID AND RC.IsActive = 1
        FOR JSON PATH
    ) AS CommissionJSON,
	(
        SELECT
            M.QuotationHotelRateMealId AS HotelRateMealID,
            MealType.RateType AS MealType,
            M.GstPercentage,
            M.GstAmount,
            M.SellingRate,
            M.MasterCommissionID,
            M.IsMealDetails,
            M.DefineAmount,
            M.NetAmountIncludingTax,
            M.NetAmountIncludingTax * dbo.fnGetPurchaseRate(HRM.CurrencyID, O.Currency, GETDATE()) AS NetAmountIncludingTax_Con,
            M.NetAmountExcludingTax,
            M.NetAmountExcludingTax * dbo.fnGetPurchaseRate(HRM.CurrencyID, O.Currency, GETDATE()) AS NetAmountExcludingTax_Con
        FROM Booking.HotelRateMealPlanMasterBooking M
        LEFT JOIN RateCommissionMaster MealType ON M.MasterCommissionID = MealType.CommMasterID
        WHERE M.QuotationHotelRateID = HRM.ID AND M.IsActive = 1
        FOR JSON PATH
    ) AS MealOverviewJSON,
    (
        SELECT 
            OC.OfferID,
            OC.HotelRateDetailID,
            OC.Days,
            OC.FromDate,
            OC.ToDate,
            OC.TotalNights,
            OC.PaidNights,
            OC.FreeNights,
            OC.IsExtendible,
            OC.IsActive,
            CASE 
                WHEN HRM.OfferTypeID = 1 THEN 'EBO'
                WHEN HRM.OfferTypeID = 2 THEN 'PayOnStay'
                ELSE 'Unknown'
            END AS OfferType,
            (
                SELECT 
                    OCC.OfferCommissionID,
                    OCC.OfferConfigurationID,
                    OCC.MasterCommissionID,
                    RCM.RateType,
                    OCC.Discount,
                    OCC.DiscountAmount,
                    OCC.Tax,
                    OCC.TaxAmount,
                    OCC.PaidNightAmountExcludingTax,
                    OCC.PaidNightAmountIncludingTax,
                    OCC.FreeNightAmountExcludingTax,
                    OCC.FreeNightAmountIncludingTax,
                    OCC.GrossAmountExcludingTax,
                    OCC.GrossAmountIncludingTax,
                    OCC.NetAmountExcludingTax,
                    OCC.NetAmountIncludingTax,
                    OCC.IsActive
                FROM RateCards.HotelRateOfferConfigurationCommission OCC
                LEFT JOIN RateCommissionMaster RCM ON OCC.MasterCommissionID = RCM.CommMasterID
                WHERE OCC.OfferConfigurationID = OC.OfferID AND OCC.IsActive = 1
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
LEFT JOIN HotelMaster H ON HRM.HotelID = H.HotelID
LEFT join City ct on ct.IATACode =HRM.CityID
LEFT JOIN HotelRating HR ON HR.ID = H.HotelRatingID
LEFT JOIN HotelRoomCategory HRC ON HRM.HotelID = HRC.HotelID AND HRC.RoomCategoryID = HRM.RoomCategoryID
LEFT JOIN RoomCategory RoomCat ON HRM.RoomCategoryID = RoomCat.ID
LEFT JOIN MealPlan MP ON HRM.MealPlanID = MP.ID AND MP.IsActive = 1

OUTER APPLY (
    SELECT 
        ISNULL(MAX([SGL_Count]), 0) AS SGL_Count,
        ISNULL(MAX([DBL_Count]), 0) AS DBL_Count,
        ISNULL(MAX([EBA_Count]), 0) AS EBA_Count,
        ISNULL(MAX([EBC_Count]), 0) AS EBC_Count,
        ISNULL(MAX([CNB_Count]), 0) AS CNB_Count,

        MAX(CASE WHEN RateType = 'SGL' THEN GrossAmountExcludingTax END) AS SGL_GrossAmountExcludingTax,
        MAX(CASE WHEN RateType = 'SGL' THEN GrossAmountIncludingTax END) AS SGL_GrossAmountIncludingTax,

        MAX(CASE WHEN RateType = 'DBL' THEN GrossAmountExcludingTax END) AS DBL_GrossAmountExcludingTax,
        MAX(CASE WHEN RateType = 'DBL' THEN GrossAmountIncludingTax END) AS DBL_GrossAmountIncludingTax,

        MAX(CASE WHEN RateType = 'EBA' THEN GrossAmountExcludingTax END) AS EBA_GrossAmountExcludingTax,
        MAX(CASE WHEN RateType = 'EBA' THEN GrossAmountIncludingTax END) AS EBA_GrossAmountIncludingTax,

        MAX(CASE WHEN RateType = 'EBC' THEN GrossAmountExcludingTax END) AS EBC_GrossAmountExcludingTax,
        MAX(CASE WHEN RateType = 'EBC' THEN GrossAmountIncludingTax END) AS EBC_GrossAmountIncludingTax,

        MAX(CASE WHEN RateType = 'CNB' THEN GrossAmountExcludingTax END) AS CNB_GrossAmountExcludingTax,
        MAX(CASE WHEN RateType = 'CNB' THEN GrossAmountIncludingTax END) AS CNB_GrossAmountIncludingTax


    FROM (
        SELECT 
            RCM2.RateType,
            RC2.Count,
            RC2.GrossAmountExcludingTax,
            RC2.GrossAmountIncludingTax,
            RCM2.RateType + '_Count' AS RateType_Count
        FROM Booking.HotelRateCommissionDetailsBooking RC2
        INNER JOIN RateCommissionMaster RCM2 ON RC2.CommissionMasterID = RCM2.CommMasterID
        WHERE RC2.QuotationHotelRateID = HRM.ID AND RC2.IsActive = 1
    ) AS SourceData
    PIVOT (
        SUM(Count) FOR RateType_Count IN (
            [SGL_Count], [DBL_Count], [EBA_Count], [EBC_Count], [CNB_Count]
        )
    ) AS PivotCount
) AS RateSummary

WHERE 
    HRM.BookingID = @BookingID
    AND hrm.IsActive = 1
    



   UNION ALL

    SELECT 
        ID,
        QuotationNo,
        HotelRateID,
        HotelID,
        HotelName,
        CityID,
        Name,
        RoomCategoryID,
        RoomCategory,
        Days,
        DaysOfWeek,
        MealPlanCode,
        Breakfast,
        Lunch,
        Dinner,
        Disclaimer,
        OfferTypeID,
        FromDate,
        ToDate,
        DATEADD(DAY, 1, StayDate) AS StayDate,
        BookingID,
        Currency,
        PurchaseRate,
        SGL_Count,
        DBL_Count,
        EBA_Count,
        EBC_Count,
        CNB_Count,
        SGL_GrossRate,
        DBL_GrossRate,
        EBA_GrossRate,
        EBC_GrossRate,
        CNB_GrossRate,
        CommissionJSON,
        MealOverviewJSON,
        OfferConfigurationJSON
    FROM DateRange
    WHERE DATEADD(DAY, 1, StayDate) < ToDate
)
insert into Booking.DayWiseBooking(RateTypeID,BookingID,DayWiseDate,City,RoomCategory,MealPlan,Breakfast,Lunch,
Dinner,SGL,EBA,DBL,EBC,CNB,CNB_Rate,SGL_Rate,EBA_Rate,DBL_Rate,EBC_Rate,Currency,CreatedBy,CreatedOn,IsActive,BHRMID)

SELECT 
    5,
    BookingID,
    StayDate,
    Name ,
    RoomCategory,
    MealPlanCode,
    Breakfast,
    Lunch,
    Dinner,
    SGL_Count,
    EBA_Count,
    DBL_Count,
    EBC_Count,
    CNB_Count,
    CNB_GrossRate,
    SGL_GrossRate,
    EBA_GrossRate,
    DBL_GrossRate,
    EBC_GrossRate,
    Currency,
	@OperationBy,GETDATE(),1,ID
FROM DateRange;




            COMMIT;
            SELECT 'Success' AS Status;
        END TRY
        BEGIN CATCH
            ROLLBACK;
            SELECT 'Error' AS Status, ERROR_MESSAGE() AS ErrorMessage;
        END CATCH
    --transport
	  BEGIN TRY
            BEGIN TRANSACTION;

		WITH transDateRange AS (
    SELECT 
        TRM.ID AS OthersRateCardMasterID,
        TRM.QuotationNo,
		o.QuotationID,
        TRM.BookingID,
        TRM.CardNumber,
        TRM.ValidFrom AS StartDate,
        TRM.ValidTo AS EndDate,
        CT.Name AS City,
        TS.Code AS TransportServiceID,
        TS.Name AS TransportService,
        VTM.VehicleType,
        VM.VendorID,
        VM.VendorName AS Vendor,
        TRM.CurrencyID,
        TRM.IsActive,
        TRM.CreatedOn,
        TRM.UpdatedOn,
        TRM.CountOfVehicles,
        (SELECT SCRD.GrossRate 
         FROM Booking.OthersRateCardCommissionBooking SCRD 
         WHERE SCRD.OthersRateRefrenceID = TRM.ID AND SCRD.CommissionMasterID = 0) AS GrossRate,
        CAST(TRM.ValidFrom AS DATE) AS ServiceDate
    FROM Booking.OthersRateCardMasterBooking TRM
    INNER JOIN Booking.tbl_Booking O ON O.ID = TRM.BookingID
    LEFT JOIN VendorMaster VM ON VM.VendorID = TRM.VendorID
    LEFT JOIN City CT ON CT.IATACode = TRM.CityID
    INNER JOIN TransportServices TS ON TS.Code = TRM.ServiceID
    LEFT JOIN VehicleTypeMaster VTM ON VTM.ID = TRM.VehicleCategoryID
    WHERE TRM.BookingID = @bookingID AND TRM.RateType = 3 AND TRM.IsActive = 1

    UNION ALL

    SELECT 

        d.OthersRateCardMasterID,
        d.QuotationNo,
		d.QuotationID,
        d.BookingID,
        d.CardNumber,
        d.StartDate,
        d.EndDate,
        d.City,
        d.TransportServiceID,
        d.TransportService,
        d.VehicleType,
        d.VendorID,
        d.Vendor,
        d.CurrencyID,
        d.IsActive,
        d.CreatedOn,
        d.UpdatedOn,
        d.CountOfVehicles,
        d.GrossRate,
        DATEADD(DAY, 1, d.ServiceDate)
    FROM transDateRange d
    WHERE DATEADD(DAY, 1, d.ServiceDate) <= d.EndDate
)

INSERT INTO Booking.DayWiseBooking(
    RateTypeID, QuotationID, BookingID, DayWiseDate, City,
    TransportServive, VehicleType, Vendor, CountOfVehicle, GrossRate,CreatedBy,CreatedOn,IsActive,BORMID
)
SELECT  
    3,
    QuotationID,
    BookingID,
    ServiceDate,
    City,
    TransportService,
    VehicleType,
    Vendor,
    CountOfVehicles,
    GrossRate,@OperationBy,Getdate(),1,OthersRateCardMasterID
FROM transDateRange
OPTION (MAXRECURSION 0);


		  COMMIT;
            SELECT 'Success' AS Status;
        END TRY
        BEGIN CATCH
            ROLLBACK;
            SELECT 'Error' AS Status, ERROR_MESSAGE() AS ErrorMessage;
        END CATCH
    
	 --Guide
	  BEGIN TRY
            BEGIN TRANSACTION;

	WITH GuideDateRange AS (
    -- Anchor member
    SELECT 
        'Guide' AS ServiceType,
        GRM.ID AS OthersRateCardMasterID,
        GRM.QuotationNo,
        o.QuotationID,
        GRM.BookingID,
        GRM.CardNumber,
        GRM.ValidFrom AS StartDate,
        GRM.ValidTo AS EndDate,
        CT.Name AS City,
        GS.Code AS GuideServiceID,
        GS.Name AS GuideService,
        VM.VendorID,
        VM.VendorName AS Vendor,
        GRM.CurrencyID,
        GRM.IsActive,
        GRM.CreatedOn,
        GRM.UpdatedOn,
        GRC.GrossRate,
        GRC.SellingRates,
        GRC.TaxPercentage,
        GRC.TaxAmount,
        GRC.Markup_IsRate,
        GRC.MarkupRate,
        GRM.ReasonID,
        GRM.CountOfGuide,
        CAST(GRM.ValidFrom AS DATE) AS ServiceDate
    FROM Booking.OthersRateCardMasterBooking GRM
    INNER JOIN Booking.tbl_Booking O ON O.ID = GRM.BookingID
    INNER JOIN Booking.OthersRateCardCommissionBooking GRC ON GRC.OthersRateRefrenceID = GRM.ID
    LEFT JOIN [Language] L ON L.ID = GRM.LanguageID
    LEFT JOIN City CT ON CT.IATACode = GRM.CityID
    LEFT JOIN VendorMaster VM ON VM.VendorID = GRM.VendorID
    LEFT JOIN GuideServices GS ON GS.Code = GRM.ServiceID
    LEFT JOIN Currency C ON C.Code = GRM.CurrencyID
    WHERE 
        GRM.BookingID = @BookingID AND 
        GRM.RateType = 1 AND 
        GRM.IsActive = 1

    UNION ALL

    -- Recursive member
    SELECT 
        d.ServiceType,
        d.OthersRateCardMasterID,
        d.QuotationNo,
        d.QuotationID,
        d.BookingID,
        d.CardNumber,
        d.StartDate,
        d.EndDate,
        d.City,
        d.GuideServiceID,
        d.GuideService,
        d.VendorID,
        d.Vendor,
        d.CurrencyID,
        d.IsActive,
        d.CreatedOn,
        d.UpdatedOn,
        d.GrossRate,
        d.SellingRates,
        d.TaxPercentage,
        d.TaxAmount,
        d.Markup_IsRate,
        d.MarkupRate,
        d.ReasonID,
        d.CountOfGuide,
        DATEADD(DAY, 1, d.ServiceDate) AS ServiceDate
    FROM GuideDateRange d
    WHERE DATEADD(DAY, 1, d.ServiceDate) <= d.EndDate
)

-- Final insert
INSERT INTO Booking.DayWiseBooking (
    RateTypeID, QuotationID, BookingID, DayWiseDate, City,
    Guide, GuideService, Vendor, CountOfGuide, GrossRate, CreatedBy, CreatedOn, Currency,IsActive,BORMID
)
SELECT  
    1,
    QuotationID,
    BookingID,
    ServiceDate,
    City,
    GuideServiceID, 
    GuideService, 
    VendorID,
    CountOfGuide,
    GrossRate,
    @OperationBy,
    GETDATE(),
    CurrencyID,1,OthersRateCardMasterID
FROM GuideDateRange
OPTION (MAXRECURSION 0);
  COMMIT;
            SELECT 'Success' AS Status;
        END TRY
        BEGIN CATCH
            ROLLBACK;
            SELECT 'Error' AS Status, ERROR_MESSAGE() AS ErrorMessage;
        END CATCH

		 --Monument
	  BEGIN TRY
            BEGIN TRANSACTION;

	WITH MonumentDateRange AS (
    -- Anchor member
    SELECT 
        'Monument' AS ServiceType,
		MRM.RateType,
        MRM.ID AS OthersRateCardMasterID,
        MRM.QuotationNo,
        O.QuotationID,
        MRM.BookingID,
        MRM.CardNumber AS BID,
        MRM.ValidFrom AS StartDate,
        MRM.ValidTo AS EndDate,
        CT.Name AS City,
        MS.ID AS MonumentServiceID,
        MS.Name AS MonumentService,
        VM.VendorID,
        VM.VendorName AS Vendor,
        MRM.CurrencyID,
        MRM.IsActive,
        MRM.CreatedOn,
        MRM.UpdatedOn,
        MRM.ReasonID,

        ISNULL((
            SELECT SCRD.GrossRate 
            FROM Booking.OthersRateCardCommissionBooking SCRD 
            WHERE SCRD.OthersRateRefrenceID = MRM.ID AND SCRD.CommissionMasterID = 7
        ), 0) AS AdultGrossRate,

        ISNULL(MRM.CountOfAdult, 0) AS CountOfAdult,

        ISNULL((
            SELECT SCRD.GrossRate 
            FROM Booking.OthersRateCardCommissionBooking SCRD 
            WHERE SCRD.OthersRateRefrenceID = MRM.ID AND SCRD.CommissionMasterID = 8
        ), 0) AS ChildGrossRate,

        ISNULL(MRM.CountOfChild, 0) AS CountOfChild,

        MRM.ValidFrom AS ServiceDate -- required for recursion
    FROM Booking.OthersRateCardMasterBooking MRM
    INNER JOIN Booking.tbl_Booking O ON O.ID = MRM.BookingID
    LEFT JOIN Nationality N ON N.ID = MRM.NationalityID 
    LEFT JOIN City CT ON CT.IATACode = MRM.CityID
    LEFT JOIN VendorMaster VM ON VM.VendorID = MRM.VendorID
    LEFT JOIN MonumentService MS ON MS.ID = MRM.ServiceID
    LEFT JOIN Currency Cu ON Cu.Code = MRM.CurrencyID 
    WHERE 
        MRM.BookingID = @BookingID
        AND MRM.RateType = 2 
        AND MRM.IsActive = 1

    UNION ALL

    -- Recursive member
    SELECT 
        d.ServiceType,
		d.RateType,
        d.OthersRateCardMasterID,
        d.QuotationNo,
        d.QuotationID,
        d.BookingID,
        d.BID, 
        d.StartDate,
        d.EndDate,
        d.City,
        d.MonumentServiceID,
        d.MonumentService,
        d.VendorID,
        d.Vendor,
        d.CurrencyID,
        d.IsActive,
        d.CreatedOn,
        d.UpdatedOn,
        d.ReasonID,
        d.AdultGrossRate,
        d.CountOfAdult,
        d.ChildGrossRate,
        d.CountOfChild,
        DATEADD(DAY, 1, d.ServiceDate) AS ServiceDate
    FROM MonumentDateRange d
    WHERE DATEADD(DAY, 1, d.ServiceDate) <= d.EndDate
)



 INSERT INTO Booking.DayWiseBooking (
     RateTypeID, QuotationID, BookingID, DayWiseDate, City,
     ServiceID, ServiceName, Vendor, Adult, Child,
     Adult_Rate, Child_Rate, CreatedOn, Currency,IsActive,CreatedBy,BORMID
 )

SELECT
	RateType,
    QuotationID,
    BookingID,
	ServiceDate AS DayWiseDate,
    City,
    MonumentServiceID AS Monument,
    MonumentService,
    VendorID AS Vendor,
    CountOfAdult,
    CountOfChild,
    AdultGrossRate,
    ChildGrossRate,
    GETDATE() AS CreatedOn,
    CurrencyID AS Currency,1,@OperationBy,OthersRateCardMasterID
FROM MonumentDateRange
OPTION (MAXRECURSION 0);
  COMMIT;
            SELECT 'Success' AS Status;
        END TRY
        BEGIN CATCH
            ROLLBACK;
            SELECT 'Error' AS Status, ERROR_MESSAGE() AS ErrorMessage;
        END CATCH

		 --Special
	  BEGIN TRY
            BEGIN TRANSACTION;

			WITH SpecialServiceDateRange AS (
    -- Anchor member
    SELECT 
        'Special Service' AS ServiceType,
        SSRM.ID AS OthersRateCardMasterID,
        SSRM.ID AS BKID, 
        SSRM.QuotationNo,
		o.QuotationID,
        SSRM.BookingID,
        SSRM.CardNumber AS BID,
        SSRM.ValidFrom AS StartDate,
        SSRM.ValidTo AS EndDate,
        CT.Name AS City,
        SS.ID AS SpecialServiceID,
        SS.Name AS SpecialService,
        VM.VendorID,
        VM.VendorName AS Vendor,
        SSRM.NationalityID,
        N.Nationality,
        SSRM.CurrencyID,
        SSRM.IsActive,
        SSRM.CreatedOn,
        SSRM.UpdatedOn,
        SSRM.RateId AS SpecialServiceRateID,
        SSRM.ReasonID,
        ISNULL(SSRM.Adult, 0) AS Adult,
        
        ISNULL((
            SELECT SCRD.GrossRate 
            FROM Booking.OthersRateCardCommissionBooking SCRD 
            WHERE SCRD.OthersRateRefrenceID = SSRM.ID AND SCRD.CommissionMasterID = 7
        ), 0) AS AdultGrossRate,
        
        ISNULL(SSRM.PerPersonChild, 0) AS PerPersonChild,
        
        ISNULL((
            SELECT SCRD.GrossRate 
            FROM Booking.OthersRateCardCommissionBooking SCRD 
            WHERE SCRD.OthersRateRefrenceID = SSRM.ID AND SCRD.CommissionMasterID = 8
        ), 0) AS ChildGrossRate,

        ISNULL(SSRM.Consolidate, 0) AS Consolidated,

        ISNULL((
            SELECT SCRD.GrossRate 
            FROM Booking.OthersRateCardCommissionBooking SCRD 
            WHERE SCRD.OthersRateRefrenceID = SSRM.ID AND SCRD.CommissionMasterID = 0
        ), 0) AS ConsolidateGrossRate,

        SSRM.ValidFrom AS ServiceDate -- starting point for recursion
    FROM Booking.OthersRateCardMasterBooking SSRM
    INNER JOIN Booking.tbl_Booking O ON O.ID = SSRM.BookingID
    LEFT JOIN Nationality N ON N.ID = SSRM.NationalityID
    LEFT JOIN City CT ON CT.IATACode = SSRM.CityID
    LEFT JOIN VendorMaster VM ON VM.VendorID = SSRM.VendorID
    LEFT JOIN HotelMaster HM ON HM.HotelID = SSRM.HotelID
    LEFT JOIN SpecialServices SS ON SS.ID = SSRM.ServiceID
    LEFT JOIN Currency Cu ON Cu.Code = SSRM.CurrencyID
    WHERE SSRM.BookingID = @BookingID
      AND SSRM.RateType = 4
      AND SSRM.IsActive = 1

    UNION ALL

    -- Recursive member to generate next day's data
    SELECT 
        d.ServiceType,
        d.OthersRateCardMasterID,
        d.BKID,
        d.QuotationNo,
		d.QuotationID,
        d.BookingID,
        d.BID, -- reuse
        d.StartDate,
        d.EndDate,
        d.City,
        d.SpecialServiceID,
        d.SpecialService,
        d.VendorID,
        d.Vendor,
        d.NationalityID,
        d.Nationality,
        d.CurrencyID,
        d.IsActive,
        d.CreatedOn,
        d.UpdatedOn,
        d.SpecialServiceRateID,
        d.ReasonID,
        d.Adult,
        d.AdultGrossRate,
        d.PerPersonChild,
        d.ChildGrossRate,
        d.Consolidated,
        d.ConsolidateGrossRate,
        DATEADD(DAY, 1, d.ServiceDate) AS ServiceDate
    FROM SpecialServiceDateRange d
    WHERE DATEADD(DAY, 1, d.ServiceDate) <= d.EndDate
)

-- Final output or insert
-- Uncomment the below block to insert into your target table
 INSERT INTO Booking.DayWiseBooking (
     RateTypeID, QuotationID, BookingID, DayWiseDate, City,
     ServiceID, ServiceName, Vendor, Adult, Child,
     Adult_Rate, Child_Rate, Consolidated, CreatedOn, Currency,CreatedBy,BORMID
 )

SELECT
    4 AS RateTypeID,
    QuotationID,
    BookingID,
    ServiceDate AS DayWiseDate,
    City,
    SpecialServiceID,
    SpecialService,
    VendorID,
    Adult,
    PerPersonChild,
    AdultGrossRate,
    ChildGrossRate,
    Consolidated,
    
    GETDATE() AS CreatedOn,
    CurrencyID,
	@OperationBy,
	OthersRateCardMasterID
FROM SpecialServiceDateRange
OPTION (MAXRECURSION 0);

			 COMMIT;
            SELECT 'Success' AS Status;
        END TRY
        BEGIN CATCH
            ROLLBACK;
            SELECT 'Error' AS Status, ERROR_MESSAGE() AS ErrorMessage;
        END CATCH

    END
END

select * from Booking.DayWiseBooking
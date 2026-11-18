
CREATE PROCEDURE [Booking].[GetDayWiseServices]
    @BookingID INT,
    @Action VARCHAR(10),
    @Id INT = NULL,
    @OperationBy NVARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;

	SELECT
	hrm.ID,
	HRM.QuotationNo as QuotationNo,
	HRM.ID AS HotelRateID,
        H.HotelID,
        H.HotelName,
        HRM.CityID,
    
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

      
        -- New: MealPlan info
        MP.Code AS MealPlanCode,
        MP.Breakfast,
        MP.Lunch,
        MP.Dinner,
		'NA' as Disclaimer,
		 
 
		hrm.OfferTypeID,	
		ISNULL(CONVERT(varchar,HRM.CheckIn,103),'')+ ' - '+ISNULL(CONVERT(varchar,HRM.CheckOut,103),'') as FromToDate,
		
		O.BookingID,
		HRM.CurrencyID as Currency,
dbo.fnGetPurchaseRate(HRM.CurrencyID, o.Currency,  GETDATE()) as PurchaseRate,



       -- Commission JSON
(
    SELECT 
        RC.QuotationHotelRateCommissionId as RateCommissionID,
        RC.CommissionMasterID,
		RC.CommissionMasterID as MasterCommissionID,
        RCM.RateType,  -- Mapped via join
        RC.TaxPercentage,
        RC.TaxAmount,

		  RC.GrossAmountIncludingTax as GrossAmountIncludingTax,
        --dbo.fnSearchCalculateROE(ISNULL(RC.GrossAmountIncludingTax, 0), @CheckIn, C1.Code, @CurrencyCode) AS GrossAmountIncludingTax,
		  RC.GrossAmountIncludingTax * dbo.fnGetPurchaseRate(HRM.CurrencyID, O.Currency,  GETDATE()) AS GrossAmountIncludingTax_Con,

        RC.GrossAmountExcludingTax as GrossAmountExcludingTax,
        --dbo.fnSearchCalculateROE(ISNULL(RC.GrossAmountExcludingTax, 0), @CheckIn, C1.Code, @CurrencyCode) as GrossAmountExcludingTax,
		 RC.GrossAmountExcludingTax * dbo.fnGetPurchaseRate(HRM.CurrencyID, O.Currency,  GETDATE()) AS GrossAmountExcludingTax_Con,

        --RC.CommisionPercentage,
  --      RC.CommissionAmount as CommissionAmount,
  --      --dbo.fnSearchCalculateROE(ISNULL(RC.CommissionAmount, 0), @CheckIn, C1.Code, @CurrencyCode) AS CommissionAmount,
		--RC.CommissionAmount * dbo.fnGetPurchaseRate(C1.Code,QM.Currency,  GETDATE()) AS CommissionAmount_Con,

        RC.NetAmountIncludingTax as NetAmountIncludingTax,
        --dbo.fnSearchCalculateROE(ISNULL(RC.NetAmountIncludingTax, 0), @CheckIn, C1.Code, @CurrencyCode) as NetAmountIncludingTax,
		 RC.NetAmountIncludingTax * dbo.fnGetPurchaseRate(HRM.CurrencyID, O.Currency,  GETDATE()) AS NetAmountIncludingTax_Con,

        RC.NetAmountExcludingTax as NetAmountExcludingTax,
        --dbo.fnSearchCalculateROE(ISNULL(RC.NetAmountExcludingTax, 0), @CheckIn, C1.Code, @CurrencyCode) as NetAmountExcludingTax,
		RC.NetAmountExcludingTax * dbo.fnGetPurchaseRate(HRM.CurrencyID, O.Currency,  GETDATE()) AS NetAmountExcludingTax_Con,
      
        RC.CommisionPercentage,
     
        
		RC.GrossRate,

		RC.IsMarkup,
		RC.MarkupValue,
		RC.SellingRate,

        RC.IsActive,

		RC.IsMarkup as Markup_IsRate,
		RC.MarkupValue MarkupRate,
		RC.ReasonMasterId as ReasonID,
		RC.Count
		
		FROM
   Booking.HotelRateCommissionDetailsBooking RC
						INNER JOIN RateCommissionMaster RCM ON RC.CommissionMasterID = RCM.CommMasterID
					WHERE 
						RC.QuotationHotelRateID = HRM.ID and (RC.IsActive = 1)
    FOR JSON PATH
) AS CommissionJSON,




        -- Meal Overview JSON
       (
    SELECT
        --M.HotelRateMealID,
		M.QuotationHotelRateMealId as HotelRateMealID,
     
        MealType.RateType AS MealType,
        M.GstPercentage,
        M.GstAmount,

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
	    M.NetAmountExcludingTax * dbo.fnGetPurchaseRate(HRM.CurrencyID,  o.Currency,  GETDATE()) AS NetAmountExcludingTax_Con
    FROM Booking.HotelRateMealPlanMasterBooking M
    LEFT JOIN RateCommissionMaster MealType ON M.MasterCommissionID = MealType.CommMasterID
    WHERE M.QuotationHotelRateID = HRM.ID AND (M.IsActive = 1)
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
		

        -- OfferType label based on OfferTypeID from parent RCD
        CASE 
            WHEN HRM.OfferTypeID = 1 THEN 'EBO'
            WHEN HRM.OfferTypeID = 2 THEN 'PayOnStay'
            ELSE 'Unknown'
        END AS OfferType,

        -- Offer Commission as nested JSON array including RateType
        (
            SELECT 
                OCC.OfferCommissionID,
                OCC.OfferConfigurationID,
                OCC.MasterCommissionID,
                RCM.RateType, -- added from RateCommissionMaster
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
            LEFT JOIN RateCommissionMaster RCM 
                ON OCC.MasterCommissionID = RCM.CommMasterID
            WHERE OCC.OfferConfigurationID = OC.OfferID
              AND OCC.IsActive = 1
            FOR JSON PATH
        ) AS OfferCommission

    FROM RateCards.HotelRateOfferConfiguration OC
	INNER JOIN RATECARDS.HotelRateDetails RD on RD.HotelRateDetailID=OC.HotelRateDetailID
	INNER JOIN RATECARDS.HotelRateMaster HM on HM.HotelRateID=RD.HotelRateID
	
    WHERE HM.HotelRateID = HRM.HotelRateID 
      --AND OC.IsActive = 1
    FOR JSON PATH
) AS OfferConfigurationJSON
from
	Booking.HotelRateCardMasterBooking HRM
	INNER JOIN Booking.tbl_Booking O ON O.ID=HRM.BookingID
    LEFT JOIN HotelMaster H ON HRM.HotelID = H.HotelID
    LEFT JOIN HotelRating HR ON HR.ID = H.HotelRatingID
    --LEFT JOIN Currency C1 ON HRM.CurrencyID = C1.CurrencyID
    LEFT JOIN HotelRoomCategory HRC ON HRM.HotelID = HRC.HotelID AND HRC.RoomCategoryID = HRM.RoomCategoryID
    LEFT JOIN RoomCategory RoomCat ON HRM.RoomCategoryID = RoomCat.ID
   
    LEFT JOIN MealPlan MP ON HRM.MealPlanID = MP.ID AND MP.IsActive = 1

    WHERE 
       HRM.BookingID=28
				AND (isnull(HRM.IsActive,0) = 1) 
				and hrm.id = 4
END;

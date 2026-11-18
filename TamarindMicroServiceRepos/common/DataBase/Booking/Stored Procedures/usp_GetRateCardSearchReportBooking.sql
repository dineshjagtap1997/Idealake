
--exec [Booking].[usp_GetRateCardSearchReportBooking] 326
CREATE PROCEDURE [Booking].[usp_GetRateCardSearchReportBooking]
(
@BookingID  INT         = 291,
@Action char(1)			= '0'
    
)
AS
BEGIN
    SET NOCOUNT ON;  




	--Guide

    SELECT 
	O.QuotationID,
	O.EnquiryID,
	   'Guide' as ServiceType,
		GRM.ID as OthersRateCardMasterID,
	    GRM.QuotationNo as QuotationNo,
	    GRM.BookingID as BookID,
		GRM.CardNumber as BookingID,
		GRM.ValidFrom as StartDate,
        GRM.ValidTo as EndDate,
		CT.Name AS City,
		GS.Code as GuideServiceID,
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
		GRM.CountOfGuide
	,QQ.QuotationNo
	,te.EnquiryID as EnquiryNo

    FROM Booking.OthersRateCardMasterBooking GRM
   Left JOIN Booking.tbl_Booking O ON O.ID=GRM.BookingID
   
    INNER JOIN Booking.OthersRateCardCommissionBooking GRC  ON GRC.OthersRateRefrenceID = GRM.ID
	 LEFT JOIN [Language] L ON L.ID = GRM.LanguageID
    LEFT JOIN City CT  ON CT.IATACode = GRM.CityID
    LEFT JOIN VendorMaster VM  ON VM.VendorID = GRM.VendorID
    LEFT JOIN GuideServices GS ON GS.Code = GRM.ServiceID
    LEFT JOIN Currency C ON C.Code = GRM.CurrencyID
	LEFT JOIn Quotation.QuotationMaster QQ ON  QQ.QuotationID = O.QuotationID
LEFT JOIn tbl_Enquiry te ON  te.EQID = O.EnquiryID


    WHERE 
	GRM.BookingID=@BookingID
				AND GRM.RateType=1
				AND (isnull(GRM.IsActive,0)=1 or @Action = '0')
				Order by GRM.QuotationNo AsC
  --Monument

  SELECT 
  
	O.QuotationID,
	O.EnquiryID,
	   'Monument' as ServiceType,
	    MRM.ID as OthersRateCardMasterID,
	    MRM.QuotationNo as QuotationNo,
	    MRM.BookingID as BookID,
		MRM.CardNumber as BookingID,
		MRM.ValidFrom as StartDate,
        MRM.ValidTo as EndDate,
		CT.Name AS City,
		MS.ID as MonumentServiceID,
        MS.Name AS MonumentService,
		VM.VendorID,
        VM.VendorName AS Vendor,
		MRM.CurrencyID,
		MRM.IsActive,
		MRM.CreatedOn,
		MRM.UpdatedOn,
	    		
		MRM.ReasonID,
		(select SCRD.GrossRate from Booking.OthersRateCardCommissionBooking SCRD where OthersRateRefrenceID = MRM.ID and SCRD.CommissionMasterID = 7 ) as AdultGrossRate ,		
		MRM.CountOfAdult,
		(select SCRD.GrossRate from Booking.OthersRateCardCommissionBooking SCRD where OthersRateRefrenceID = MRM.ID and SCRD.CommissionMasterID = 8 ) as ChildGrossRate ,		
		MRM.CountOfChild
	,QQ.QuotationNo
	,te.EnquiryID as EnquiryNo


   FROM Booking.OthersRateCardMasterBooking MRM
   Left JOIN Booking.tbl_Booking O ON O.ID=MRM.BookingID
    --LEFT JOIN Booking.OthersRateCardCommissionBooking CRC  ON CRC.OthersRateRefrenceID = MRM.ID
    left JOIN Nationality N  ON N.ID = MRM.NationalityID 
    LEFT JOIN City CT 
        ON CT.IATACode = MRM.CityID
    LEFT JOIN VendorMaster VM 
        ON VM.VendorID = MRM.VendorID
    LEFT JOIN MonumentService MS 
        ON MS.ID = MRM.ServiceID
    LEFT JOIN Currency Cu 
        ON Cu.Code = MRM.CurrencyID 
		LEFT JOIn Quotation.QuotationMaster QQ ON  QQ.QuotationID = O.QuotationID
LEFT JOIn tbl_Enquiry te ON  te.EQID = O.EnquiryID

    WHERE 
      
   MRM.BookingID=@BookingID
				AND MRM.RateType=2
				AND (isnull(MRM.IsActive,0)=1 or @Action = '0')
		Order by MRM.QuotationNo AsC
--Transport

SELECT 

	O.QuotationID,
	O.EnquiryID,
	'Transport' as ServiceType,
		TRM.ID as OthersRateCardMasterID,
	    TRM.QuotationNo as QuotationNo,
		TRM.ID AS BKID, 
		TRM.BookingID as BookID,
		TRM.CardNumber as BookingID,
		TRM.ValidFrom as StartDate,
        TRM.ValidTo as EndDate,
        CT.Name AS City,
		TS.Code as TransportServiceID,
        TS.Name AS TransportService,
        VTM.VehicleType,
		VM.VendorID,
        VM.VendorName AS Vendor,
		TRM.CurrencyID,
		TRM.IsActive,
		TRM.CreatedOn,
		TRM.UpdatedOn,
		TRM.CountOfVehicles,
		(select SCRD.GrossRate from Booking.OthersRateCardCommissionBooking SCRD where OthersRateRefrenceID = TRM.ID and SCRD.CommissionMasterID = 0 ) as GrossRate 		,QQ.QuotationNo
	,te.EnquiryID as EnquiryNo
	from
	Booking.OthersRateCardMasterBooking TRM
	left JOIN Booking.tbl_Booking O ON O.ID=TRM.BookingID
    LEFT JOIN VendorMaster VM ON VM.VendorID = TRM.VendorID
    LEFT JOIN City CT ON CT.IATACode = TRM.CityID
    INNER JOIN TransportServices TS ON TS.Code = TRM.ServiceID
    LEFT JOIN VehicleTypeMaster VTM ON VTM.ID = TRM.VehicleCategoryID
	LEFT JOIn Quotation.QuotationMaster QQ ON  QQ.QuotationID = O.QuotationID
LEFT JOIn tbl_Enquiry te ON  te.EQID = O.EnquiryID
    WHERE 
       	TRM.BookingID=@BookingID
				AND TRM.RateType=3
				AND (isnull(TRM.IsActive,0)=1  or @Action = '0')
		Order by TRM.QuotationNo AsC

--SpecialService
      SELECT 
	  
	O.QuotationID,
	O.EnquiryID,
		'Special Service' as ServiceType,		
		SSRM.ID as OthersRateCardMasterID,
		SSRM.ID AS BKID, 
		SSRM.QuotationNo as QuotationNo,
		SSRM.BookingID as BookID,
		SSRM.CardNumber as BookingID,
		SSRM.ValidFrom as StartDate,
        SSRM.ValidTo as EndDate,
        CT.Name AS City,
		SS.ID as SpecialServiceID,
        SS.name as SpecialService,
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
		SSRM.Adult,
		(select SCRD.GrossRate from Booking.OthersRateCardCommissionBooking SCRD where OthersRateRefrenceID = SSRM.ID and SCRD.CommissionMasterID = 7 ) as AdultGrossRate ,		
		SSRM.PerPersonChild,
        (select SCRD.GrossRate from Booking.OthersRateCardCommissionBooking SCRD where OthersRateRefrenceID = SSRM.ID and SCRD.CommissionMasterID = 8 ) as ChildGrossRate ,
		SSRM.consolidate as Consolidated,
		isnull((select SCRD.GrossRate from Booking.OthersRateCardCommissionBooking SCRD where OthersRateRefrenceID = SSRM.ID and SCRD.CommissionMasterID = 0 ),0) as ConsolidateGrossRate ,QQ.QuotationNo
	,te.EnquiryID as EnquiryNo

FROM 
		Booking.OthersRateCardMasterBooking SSRM
				left JOIN Booking.tbl_Booking O ON O.ID=SSRM.BookingID				
    LEFT JOIN Nationality N 
        ON N.ID = SSRM.NationalityID
   
    LEFT JOIN City CT 
        ON CT.IATACode = SSRM.CityID
    LEFT JOIN VendorMaster VM 
        ON VM.VendorID = SSRM.VendorID
    LEFT JOIN HotelMaster HM 
        ON HM.HotelID = SSRM.HotelID
    LEFT JOIN SpecialServices SS 
        ON SS.ID = SSRM.ServiceID
    LEFT JOIN Currency Cu 
        ON Cu.Code = SSRM.CurrencyID	
		LEFT JOIn Quotation.QuotationMaster QQ ON  QQ.QuotationID = O.QuotationID
LEFT JOIn tbl_Enquiry te ON  te.EQID = O.EnquiryID
    WHERE 	
	SSRM.BookingID=@BookingID
				AND SSRM.RateType=4
				AND (isnull(SSRM.IsActive,0)=1 or @Action = '0')
       		Order by SSRM.QuotationNo AsC
--Hotel

 SELECT
 
	O.QuotationID,
	O.EnquiryID,
	'Hotel' as ServiceType,
	HRM.QuotationNo as QuotationNo,
	HRM.ID AS HotelRateID,
        H.HotelID,
        H.HotelName,
        HRM.CityID,
		city.Name as CityName,	
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
        HRM.Breakfast,
        HRM.Lunch,
        HRM.Dinner,
		'NA' as Disclaimer,
		
 
		hrm.OfferTypeID,	
		ISNULL(CONVERT(varchar,HRM.CheckIn,103),'')+ ' - '+ISNULL(CONVERT(varchar,HRM.CheckOut,103),'') as FromToDate,
		
		O.BookingID,
		o.ID as BookID,
		CM.CurrencyCode as Currency,
		--HRM.CurrencyID as Currency,
dbo.fnGetPurchaseRate(HRM.CurrencyID, CM.CurrencyCode,  GETDATE()) as PurchaseRate,

isnull((select Case (select TaxType from Quotation.QuotationMaster where  QuotationID in (o.QuotationID))
	When 0 then NetAmountExcludingTax else NetAmountIncludingTax End as DinnerGrossRate
	FROM Booking.HotelRateMealPlanMasterBooking M
    WHERE M.QuotationHotelRateID = HRM.ID AND (M.IsActive = 1) and BookingID = @BookingID and
	M.MasterCommissionID in (select top 1 CommMasterID from RateCommissionMaster where RateType = 'Breakfast' )
),0) as BreakfastGrossRate,

isnull((select Case (select TaxType from Quotation.QuotationMaster where  QuotationID in (o.QuotationID))
	When 0 then NetAmountExcludingTax else NetAmountIncludingTax End as DinnerGrossRate
	FROM Booking.HotelRateMealPlanMasterBooking M
    WHERE M.QuotationHotelRateID = HRM.ID AND (M.IsActive = 1) and BookingID = @BookingID and
	M.MasterCommissionID in (select top 1 CommMasterID from RateCommissionMaster where RateType = 'Lunch' )
),0) as LunchGrossRate,

isnull((select Case (select TaxType from Quotation.QuotationMaster where  QuotationID in (o.QuotationID))
	When 0 then NetAmountExcludingTax else NetAmountIncludingTax End as DinnerGrossRate
	FROM Booking.HotelRateMealPlanMasterBooking M
    WHERE M.QuotationHotelRateID = HRM.ID AND (M.IsActive = 1) and BookingID = @BookingID and
	M.MasterCommissionID in (select top 1 CommMasterID from RateCommissionMaster where RateType = 'Dinner' )
),0) as DinnerGrossRate,

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
		  RC.GrossAmountIncludingTax * dbo.fnGetPurchaseRate(HRM.CurrencyID, CM.CurrencyCode,  GETDATE()) AS GrossAmountIncludingTax_Con,

        RC.GrossAmountExcludingTax as GrossAmountExcludingTax,
        --dbo.fnSearchCalculateROE(ISNULL(RC.GrossAmountExcludingTax, 0), @CheckIn, C1.Code, @CurrencyCode) as GrossAmountExcludingTax,
		 RC.GrossAmountExcludingTax * dbo.fnGetPurchaseRate(HRM.CurrencyID, CM.CurrencyCode,  GETDATE()) AS GrossAmountExcludingTax_Con,

        --RC.CommisionPercentage,
  --      RC.CommissionAmount as CommissionAmount,
  --      --dbo.fnSearchCalculateROE(ISNULL(RC.CommissionAmount, 0), @CheckIn, C1.Code, @CurrencyCode) AS CommissionAmount,
		--RC.CommissionAmount * dbo.fnGetPurchaseRate(C1.Code,QM.Currency,  GETDATE()) AS CommissionAmount_Con,

        RC.NetAmountIncludingTax as NetAmountIncludingTax,
        --dbo.fnSearchCalculateROE(ISNULL(RC.NetAmountIncludingTax, 0), @CheckIn, C1.Code, @CurrencyCode) as NetAmountIncludingTax,
		 RC.NetAmountIncludingTax * dbo.fnGetPurchaseRate(HRM.CurrencyID,CM.CurrencyCode,  GETDATE()) AS NetAmountIncludingTax_Con,

        RC.NetAmountExcludingTax as NetAmountExcludingTax,
        --dbo.fnSearchCalculateROE(ISNULL(RC.NetAmountExcludingTax, 0), @CheckIn, C1.Code, @CurrencyCode) as NetAmountExcludingTax,
		RC.NetAmountExcludingTax * dbo.fnGetPurchaseRate(HRM.CurrencyID, CM.CurrencyCode,  GETDATE()) AS NetAmountExcludingTax_Con,
      
        RC.CommisionPercentage,
     
        
		RC.GrossRate,

		RC.IsMarkup,
		RC.MarkupValue,
		RC.SellingRate,

        RC.IsActive,

		RC.IsMarkup as Markup_IsRate,
		RC.MarkupValue MarkupRate,
		RC.ReasonMasterId as ReasonID,
		RC.Count,
		RC.Breakfast,
		RC.Lunch,
		RC.Dinner
		FROM
   Booking.HotelRateCommissionDetailsBooking RC
						INNER JOIN RateCommissionMaster RCM ON RC.CommissionMasterID = RCM.CommMasterID
					WHERE 
						RC.QuotationHotelRateID = HRM.ID and (RC.IsActive = 1 or @Action = '0')
		ORDER BY RCM.CommMasterID ASC
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
	   M.NetAmountIncludingTax * dbo.fnGetPurchaseRate(HRM.CurrencyID,  CM.CurrencyCode,  GETDATE()) AS NetAmountIncludingTax_Con,

       M.NetAmountExcludingTax as NetAmountExcludingTax,
	   M.IsSupplementary as IsSupplementary,
	   M.IsGross as IsGross,
       --dbo.fnSearchCalculateROE(M.NetAmountExcludingTax, @CheckIn, C1.Code, @CurrencyCode) AS NetAmountExcludingTax,
	    M.NetAmountExcludingTax * dbo.fnGetPurchaseRate(HRM.CurrencyID,  CM.CurrencyCode,  GETDATE()) AS NetAmountExcludingTax_Con
    FROM Booking.HotelRateMealPlanMasterBooking M
    LEFT JOIN RateCommissionMaster MealType ON M.MasterCommissionID = MealType.CommMasterID
    WHERE M.QuotationHotelRateID = HRM.ID AND (M.IsActive = 1  or @Action = '0')
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
      AND OC.IsActive = 1
    FOR JSON PATH
) AS OfferConfigurationJSON,
QQ.QuotationNo
	,te.EnquiryID as EnquiryNo
from
	Booking.HotelRateCardMasterBooking HRM
	INNER JOIN Booking.tbl_Booking O ON O.ID=HRM.BookingID
    LEFT JOIN HotelMaster H ON HRM.HotelID = H.HotelID
    LEFT JOIN HotelRating HR ON HR.ID = H.HotelRatingID
	LEFT JOIN CurrencyMaster CM ON O.Currency = CM.id
    --LEFT JOIN Currency C1 ON HRM.CurrencyID = C1.CurrencyID
    LEFT JOIN HotelRoomCategory HRC ON HRM.HotelID = HRC.HotelID AND HRC.RoomCategoryID = HRM.RoomCategoryID
    LEFT JOIN RoomCategory RoomCat ON HRM.RoomCategoryID = RoomCat.ID
    LEFT JOIN City city ON city.IATACode = HRM.CityID
    LEFT JOIN MealPlan MP ON HRM.MealPlanID = MP.ID AND MP.IsActive = 1
	LEFT JOIn Quotation.QuotationMaster QQ ON  QQ.QuotationID = O.QuotationID
LEFT JOIn tbl_Enquiry te ON  te.EQID = O.EnquiryID
    WHERE 
       HRM.BookingID=@BookingID
				AND (isnull(HRM.IsActive,0) = 1 or @Action = '0')
				

    SET NOCOUNT OFF;
END

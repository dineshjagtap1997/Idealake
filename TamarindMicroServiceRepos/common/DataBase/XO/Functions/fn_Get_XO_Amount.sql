Create FUNCTION [XO].[fn_Get_XO_Amount]
(
@BookingID INT=51,
@GroupKey INT=89
)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @Amount DECIMAL(18,2) = 0;
    DECLARE @RateType INT = 0;

    SELECT TOP 1 @RateType = RateTypeID 
    FROM Booking.DayWiseBooking 
    WHERE BookingID = @BookingID AND GroupKey = @GroupKey;

    IF (@RateType = 5)
    BEGIN
		SELECT 
			@Amount = SUM(
				ISNULL(CASE WHEN B.SupplierTax_InCluding = 0 THEN HRC_SGL.GrossAmountExcludingTax ELSE HRC_SGL.GrossAmountIncludingTax END, 0) * 
					CASE WHEN ISNULL(DWB.SGL, '') NOT IN ('', '0') THEN DWB.SGL ELSE 0 END +

				ISNULL(CASE WHEN B.SupplierTax_InCluding = 0 THEN HRC_DBL.GrossAmountExcludingTax ELSE HRC_DBL.GrossAmountIncludingTax END, 0) * 
					CASE WHEN ISNULL(DWB.DBL, '') NOT IN ('', '0') THEN DWB.DBL ELSE 0 END +

				ISNULL(CASE WHEN B.SupplierTax_InCluding = 0 THEN HRC_DBL.GrossAmountExcludingTax ELSE HRC_DBL.GrossAmountIncludingTax END, 0) * 
					CASE WHEN ISNULL(DWB.Twin, '') NOT IN ('', '0') THEN DWB.Twin ELSE 0 END +

				ISNULL(CASE WHEN B.SupplierTax_InCluding = 0 THEN HRC_EBA.GrossAmountExcludingTax ELSE HRC_EBA.GrossAmountIncludingTax END, 0) * 
					CASE WHEN ISNULL(DWB.EBA, '') NOT IN ('', '0') THEN DWB.EBA ELSE 0 END +

				ISNULL(CASE WHEN B.SupplierTax_InCluding = 0 THEN HRC_EBC.GrossAmountExcludingTax ELSE HRC_EBC.GrossAmountIncludingTax END, 0) * 
					CASE WHEN ISNULL(DWB.EBC, '') NOT IN ('', '0') THEN DWB.EBC ELSE 0 END +

				ISNULL(CASE WHEN B.SupplierTax_InCluding = 0 THEN HRC_CNB.GrossAmountExcludingTax ELSE HRC_CNB.GrossAmountIncludingTax END, 0) * 
					CASE WHEN ISNULL(DWB.CNB, '') NOT IN ('', '0') THEN DWB.CNB ELSE 0 END +
			-- Meal Charges — only if DWB value = 1 and RVM = 0, and person count > 0
				CASE 
					WHEN ISNULL(MP_BF.IsSupplementary, 0) = 1 AND ISNULL(MP.Breakfast, 0) = 0 THEN
						ISNULL(CASE WHEN B.SupplierTax_InCluding = 0 THEN MP_BF.NetAmountExcludingTax ELSE MP_BF.NetAmountIncludingTax END, 0) *
						(
							CASE WHEN ISNULL(DWB.SGL, '') NOT IN ('', '0') THEN DWB.SGL ELSE 0 END +
							CASE WHEN ISNULL(DWB.DBL, '') NOT IN ('', '0') THEN DWB.DBL * 2 ELSE 0 END +
							CASE WHEN ISNULL(DWB.Twin, '') NOT IN ('', '0') THEN DWB.Twin * 2 ELSE 0 END +
							CASE WHEN ISNULL(DWB.EBA, '') NOT IN ('', '0') THEN DWB.EBA ELSE 0 END +
							CASE WHEN ISNULL(DWB.EBC, '') NOT IN ('', '0') THEN DWB.EBC ELSE 0 END +
							CASE WHEN ISNULL(DWB.CNB, '') NOT IN ('', '0') THEN DWB.CNB ELSE 0 END
						)
					ELSE 0
				END +
				CASE 
					WHEN ISNULL(MP_Lunch.IsSupplementary, 0) = 1 AND ISNULL(MP.Lunch, 0) = 0 THEN
						ISNULL(CASE WHEN B.SupplierTax_InCluding = 0 THEN MP_Lunch.NetAmountExcludingTax ELSE MP_Lunch.NetAmountIncludingTax END, 0) *
						(
							CASE WHEN ISNULL(DWB.SGL, '') NOT IN ('', '0') THEN DWB.SGL ELSE 0 END +
							CASE WHEN ISNULL(DWB.DBL, '') NOT IN ('', '0') THEN DWB.DBL * 2 ELSE 0 END +
							CASE WHEN ISNULL(DWB.Twin, '') NOT IN ('', '0') THEN DWB.Twin * 2 ELSE 0 END +
							CASE WHEN ISNULL(DWB.EBA, '') NOT IN ('', '0') THEN DWB.EBA ELSE 0 END +
							CASE WHEN ISNULL(DWB.EBC, '') NOT IN ('', '0') THEN DWB.EBC ELSE 0 END +
							CASE WHEN ISNULL(DWB.CNB, '') NOT IN ('', '0') THEN DWB.CNB ELSE 0 END
						)
					ELSE 0
				END +
				CASE 
					WHEN ISNULL(MP_Dinner.IsSupplementary, 0) = 1 AND ISNULL(MP.Dinner, 0) = 0 THEN
						ISNULL(CASE WHEN B.SupplierTax_InCluding = 0 THEN MP_Dinner.NetAmountExcludingTax ELSE MP_Dinner.NetAmountIncludingTax END, 0) *
						(
							CASE WHEN ISNULL(DWB.SGL, '') NOT IN ('', '0') THEN DWB.SGL ELSE 0 END +
							CASE WHEN ISNULL(DWB.DBL, '') NOT IN ('', '0') THEN DWB.DBL * 2 ELSE 0 END +
							CASE WHEN ISNULL(DWB.Twin, '') NOT IN ('', '0') THEN DWB.Twin * 2 ELSE 0 END +
							CASE WHEN ISNULL(DWB.EBA, '') NOT IN ('', '0') THEN DWB.EBA ELSE 0 END +
							CASE WHEN ISNULL(DWB.EBC, '') NOT IN ('', '0') THEN DWB.EBC ELSE 0 END +
							CASE WHEN ISNULL(DWB.CNB, '') NOT IN ('', '0') THEN DWB.CNB ELSE 0 END
						)
					ELSE 0
				END
			)
			FROM Booking.DayWiseBooking DWB
			LEFT JOIN Booking.tbl_Booking B ON DWB.BookingID=B.ID and B.ID=@BookingID
			LEFT JOIN Booking.HotelRateCommissionDetailsBooking HRC_SGL 
				ON HRC_SGL.QuotationHotelRateID = DWB.BHRMID AND HRC_SGL.CommissionMasterID = 1
			LEFT JOIN Booking.HotelRateCommissionDetailsBooking HRC_DBL 
				ON HRC_DBL.QuotationHotelRateID = DWB.BHRMID AND HRC_DBL.CommissionMasterID = 2
			LEFT JOIN Booking.HotelRateCommissionDetailsBooking HRC_EBA 
				ON HRC_EBA.QuotationHotelRateID = DWB.BHRMID AND HRC_EBA.CommissionMasterID = 3
			LEFT JOIN Booking.HotelRateCommissionDetailsBooking HRC_EBC 
				ON HRC_EBC.QuotationHotelRateID = DWB.BHRMID AND HRC_EBC.CommissionMasterID = 23
			LEFT JOIN Booking.HotelRateCommissionDetailsBooking HRC_CNB 
				ON HRC_CNB.QuotationHotelRateID = DWB.BHRMID AND HRC_CNB.CommissionMasterID = 24
			LEFT JOIN Booking.HotelRateMealPlanMasterBooking MP_BF 
				ON MP_BF.QuotationHotelRateID = DWB.BHRMID AND MP_BF.MasterCommissionID = 4
			LEFT JOIN Booking.HotelRateMealPlanMasterBooking MP_Lunch 
				ON MP_Lunch.QuotationHotelRateID = DWB.BHRMID AND MP_Lunch.MasterCommissionID = 5
			LEFT JOIN Booking.HotelRateMealPlanMasterBooking MP_Dinner 
				ON MP_Dinner.QuotationHotelRateID = DWB.BHRMID AND MP_Dinner.MasterCommissionID = 6
			Left Join Booking.[HotelRateCardMasterBooking] BHRM on BHRM.ID= DWB.BHRMID
			LEFT JOIN [RateCards].[HotelRateDetails] HRD on BHRM.HotelRateDetailID=HRD.HotelRateDetailID
			LEFT JOIN dbo.MealPlan MP ON HRD.MealPlanID = MP.ID
		WHERE DWB.BookingID = @BookingID AND DWB.GroupKey = @GroupKey;
    END
    ELSE
    BEGIN
        SELECT
		@Amount = SUM(
		CASE 
        WHEN DWB.RateTypeID IN (1, 3) THEN 
            CASE 
                WHEN ISNULL(B.SupplierTax_InCluding, 0) = 0 THEN
                    ISNULL(DWB.Count, 0) * ISNULL(ORCB.NetAmountExcludingTax, 0) 
                ELSE
                    ISNULL(DWB.Count, 0) * ISNULL(ORCB.NetAmountIncludingTax, 0) 
            END

        WHEN DWB.RateTypeID IN (2, 4) THEN 
            CASE 
                WHEN  ISNULL(B.SupplierTax_InCluding, 0) = 0 THEN
                    ISNULL(DWB.Adult, 0) * ISNULL(ORCB_ADULT.NetAmountExcludingTax, 0) +
                    ISNULL(DWB.Child, 0) * ISNULL(ORCB_CHILD.NetAmountExcludingTax, 0) 
					 + ISNULL(DWB.Consolidated, 0) * ISNULL(ORCB_CONSILIDATE.NetAmountExcludingTax, 0) 
					
                ELSE
                    ISNULL(DWB.Adult, 0) * ISNULL(ORCB_ADULT.NetAmountIncludingTax, 0) +
                    ISNULL(DWB.Child, 0) * ISNULL(ORCB_CHILD.NetAmountIncludingTax, 0) 
					+ ISNULL(DWB.Consolidated, 0) * ISNULL(ORCB_CONSILIDATE.NetAmountIncludingTax, 0)
            END

        ELSE 0
		END
			)
			FROM Booking.DayWiseBooking DWB
			LEFT JOIN Booking.tbl_Booking B ON DWB.BookingID=B.ID and B.ID=@BookingID
			LEFT JOIN Booking.OthersRateCardMasterBooking ORMB ON ORMB.ID = DWB.BORMID
			LEFT JOIN Booking.OthersRateCardCommissionBooking ORCB 
				ON ORCB.OthersRateRefrenceID = ORMB.ID AND DWB.RateTypeID IN (1, 3) and ORCB.CommissionMasterID NOT IN (21,22)
			LEFT JOIN Booking.HotelRateCardMasterBooking HRMB ON HRMB.ID = DWB.BHRMID
			LEFT JOIN Booking.OthersRateCardCommissionBooking ORCB_ADULT 
				ON ORCB_ADULT.OthersRateRefrenceID = ORMB.ID AND ORCB_ADULT.CommissionMasterID = 7
			LEFT JOIN Booking.OthersRateCardCommissionBooking ORCB_CHILD 
				ON ORCB_CHILD.OthersRateRefrenceID = ORMB.ID AND ORCB_CHILD.CommissionMasterID = 8
			LEFT JOIN Booking.OthersRateCardCommissionBooking ORCB_CONSILIDATE
				ON ORCB_CONSILIDATE.OthersRateRefrenceID = ORMB.ID and DWB.RateTypeID IN(2,4) AND ORCB_CONSILIDATE.CommissionMasterID NOT IN (7,8)
			WHERE DWB.BookingID = @BookingID AND DWB.GroupKey = @GroupKey
			  --AND (DWB.RateTypeID <> 3 OR ORCB.CommissionMasterID NOT IN (21, 22));

    END
    RETURN ISNULL(@Amount, 0);
END

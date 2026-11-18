
CREATE PROCEDURE [Booking].[usp_HotelDayWiseService_new145]
      @HotelID             INT              = 1
    , @HotelRateDetailID   INT              = NULL
    , @CheckIn             DATE             = '2025-08-01'
    , @CheckOut            DATE             = '2025-08-02'
    , @QuotationID         INT              = NULL
    , @BookingID           INT              = 20
    , @UserID              UNIQUEIDENTIFIER = NULL
    , @RateID              BIGINT           = 1
    , @RateDetailID        NVARCHAR(MAX)    = '7,8'
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @SupplierTax_InCluding TINYINT = 0;

    SELECT  TOP 1
            @SupplierTax_InCluding = SupplierTax_InCluding
    FROM    Booking.tbl_Booking
    WHERE   ID = @BookingID;
    DECLARE @NewHR TABLE
    (
        QuotationHotelRateID INT   PRIMARY KEY,
        HotelRateDetailID    INT,
        HotelRateID          INT
    );

    INSERT  Booking.HotelRateCardMasterBooking
           (HotelRateID, HotelRateDetailID, HotelID, CardNumber, ContractDate,
            Days, RoomCategoryID, MealPlanID, CurrencyID,
            -- CurrencyName,
            InfoForRemark, StateID, GstStatus, CityID, Heading, InfoForAgent,
            InfoForOperation, PaymentTypeID, RateCardModeTypeID, RateTypeID,
            ValueAddOn, IsActive, QuotationID, Disclaimer, CheckIn, CheckOut,
            BookingID, AddedFromBooking, IsCustom)
    OUTPUT  inserted.ID,  -- or inserted.QuotationHotelRateID if that’s the identity
        inserted.HotelRateDetailID,
        inserted.HotelRateID
    INTO    @NewHR (QuotationHotelRateID, HotelRateDetailID, HotelRateID)
    SELECT  DISTINCT
            HRD.HotelRateID,
            HRD.HotelRateDetailID,
            HRM.HotelID,
            HRM.CardNumber,
            HRM.ContractDate,
            HRD.Days,
            HRD.RoomCategoryID,
            HRD.MealPlanID,
            HRM.CurrencyID,
            HRM.InfoForRemark,
            HRM.StateID,
            HRM.GstStatus,
            HRM.CityID,
            HRM.Heading,
            HRM.InfoForAgent,
            HRM.InfoForOperation,
            HRM.PaymentTypeID,
            HRM.RateCardModeTypeID,
            HRM.RateTypeID,
            HRM.ValueAddOn,
            HRD.IsActive,
            @QuotationID,
            '',
            @CheckIn,
            @CheckOut,
            @BookingID,
            1,
            0
    FROM    RateCards.HotelRateDetails HRD
    LEFT    JOIN RateCards.HotelRateMaster HRM
               ON HRD.HotelRateID = HRM.HotelRateID
    WHERE   HRD.HotelRateDetailID IN
           (SELECT value FROM STRING_SPLIT(@RateDetailID, ','));

    INSERT  Booking.HotelRateCommissionDetailsBooking
           (QuotationHotelRateID, RateCommisionID, CommissionMasterID,
            GrossRate, TaxPercentage, TaxAmount, GrossAmountIncludingTax,
            GrossAmountExcludingTax, CommisionPercentage, CreatedOn,
            CreatedBy, IsActive, HotelRateID, HotelRateDetailID, QuotationID,
            NetAmountIncludingTax, NetAmountExcludingTax, BookingID,
            AddedFromBooking)
    SELECT  n.QuotationHotelRateID,
            RCD.RateCommisionID,
            ISNULL(RCD.CommissionMasterID, 0),
            CASE WHEN ISNULL(@SupplierTax_InCluding, 0) = 0
                     THEN RCD.NetAmountExcludingTax
                 ELSE RCD.NetAmountIncludingTax
            END,
            ISNULL(RCD.TaxPercentage, 0),
            ISNULL(RCD.TaxAmount, 0),
            ISNULL(RCD.GrossAmountIncludingTax, 0),
            ISNULL(RCD.GrossAmountExcludingTax, 0),
            ISNULL(RCD.CommisionPercentage, 0),
            GETDATE(),
            @UserID,
            ISNULL(RCD.IsActive, 0),
            n.HotelRateID,
            n.HotelRateDetailID,
            @QuotationID,
            RCD.NetAmountIncludingTax,
            RCD.NetAmountExcludingTax,
            @BookingID,
            1
    FROM    @NewHR                             AS n
    JOIN    RateCards.RateCommisionDetails     AS RCD
               ON RCD.HotelRateDetailID = n.HotelRateDetailID;

  
    INSERT  Booking.HotelRateMealPlanMasterBooking
           (QuotationHotelRateID, MealTypeID, GstPercentage, GstAmount,
            NetAmountIncludingTax, NetAmountExcludingTax, IsActive, CreatedBy,
            CreatedOn, MasterCommissionID, IsMealDetails, DefineAmount,
            HotelRateID, HotelRateDetailID, QuotationID, AddedFromBooking)
    SELECT  n.QuotationHotelRateID,
            MP.ID,
            HMM.GstPercentage,
            HMM.GstAmount,
            HMM.NetAmountIncludingTax,
            HMM.NetAmountExcludingTax,
            HMM.IsActive,
            @UserID,
            GETDATE(),
            HMM.MasterCommissionID,
            HMM.IsMealDetails,
            HMM.DefineAmount,
            n.HotelRateID,
            n.HotelRateDetailID,
            @QuotationID,
            1
    FROM    @NewHR                             AS n
    JOIN    RateCards.HotelMealOverviewMaster  AS HMM
               ON HMM.HotelRateDetailID = n.HotelRateDetailID
    JOIN    MealPlan                           AS MP
               ON MP.ID = HMM.MealTypeID
              AND MP.IsActive = 1
    WHERE   HMM.IsActive = 1;

    /* ------------------------------------------------------------------ */
    /* 4. Day‑wise booking rows                                           */
    /* ------------------------------------------------------------------ */
    ;WITH DateRange AS
    (
        SELECT @CheckIn AS [Date]
        UNION ALL
        SELECT DATEADD(DAY, 1, [Date])
        FROM   DateRange
        WHERE  [Date] < @CheckOut
    )
    INSERT  Booking.DayWiseBooking
           (DayWiseDate, City, HotelName, RoomCategory,
            DBL, EBA, EBC, CNB, SGL,
            DBL_Rate, EBA_Rate, EBC_Rate, CNB_Rate, SGL_Rate,
            MealPlan, Breakfast, Lunch, Dinner,
            RateTypeID, ServiceName, IsActive, CreatedBy, CreatedOn,
            RateID, RateDetailID, GrossRate, Currency,
            BookingID, BHRMID, Vendor)
    SELECT  d.[Date],
            HRM.CityID,
            H.HotelName,
            RC.Name,
            0,0,0,0,0,
            0,0,0,0,0,
            MP.Code, MP.Breakfast, MP.Lunch, MP.Dinner,
            5, 'Hotel', 1, @UserID, GETDATE(),
            n.HotelRateID,
            n.HotelRateDetailID,
            0,
            HRM.CurrencyID,
            @BookingID,
            n.QuotationHotelRateID,  
            HRM.VendorID
    FROM        DateRange d
    CROSS JOIN  @NewHR n
    JOIN        RateCards.HotelRateMaster  HRM
                 ON HRM.HotelRateID = n.HotelRateID
    JOIN        RateCards.HotelRateDetails RCD
                 ON RCD.HotelRateDetailID = n.HotelRateDetailID
    JOIN        HotelMaster               H
                 ON H.HotelID = HRM.HotelID
    LEFT JOIN   RoomCategory              RC
                 ON RC.ID = RCD.RoomCategoryID
    LEFT JOIN   MealPlan                  MP
                 ON MP.ID = RCD.MealPlanID
                AND MP.IsActive = 1
    OPTION (MAXRECURSION 0);

    /* ------------------------------------------------------------------ */
    /* 5. Return message                                                  */
    /* ------------------------------------------------------------------ */
    SELECT '200'   AS returnCode,
           'New record(s) added successfully.' AS returnMessage;
		   
END

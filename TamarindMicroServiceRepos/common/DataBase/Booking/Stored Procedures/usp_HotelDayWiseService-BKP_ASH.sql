
CREATE PROCEDURE [Booking].[usp_HotelDayWiseService-BKP_ASH]
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
 DECLARE @SupplierTax_InCluding  TINYINT      = 0,
            @QuotationHotelRateID   INT;

    SELECT TOP 1
           @SupplierTax_InCluding = SupplierTax_InCluding
    FROM   Booking.tbl_Booking
    WHERE  ID = @BookingID;

    DECLARE
          @C_HotelRateID         BIGINT
        , @C_HotelRateDetailID   INT
        , @C_HotelID             INT
        , @C_CardNumber          NVARCHAR(50)
        , @C_ContractDate        DATETIME
        , @C_Days                NVARCHAR(100)
        , @C_RoomCategoryID      INT
        , @C_MealPlanID          INT
        , @C_CurrencyID          NVARCHAR(10)
        , @C_InfoForRemark       NVARCHAR(MAX)
        , @C_StateID             INT
        , @C_GstStatus           NVARCHAR(10)
        , @C_CityID              NVARCHAR(10)
        , @C_Heading             NVARCHAR(200)
        , @C_InfoForAgent        NVARCHAR(MAX)
        , @C_InfoForOperation    NVARCHAR(MAX)
        , @C_PaymentTypeID       INT
        , @C_RateCardModeTypeID  INT
        , @C_RateTypeID          INT
        , @C_ValueAddOn          NVARCHAR(MAX)
        , @C_IsActive            BIT
        , @C_VendorID            INT;        

    DECLARE CUR_HotelRates CURSOR FOR
    SELECT  HRD.HotelRateID,
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
            HRM.VendorID
    FROM    RateCards.HotelRateDetails HRD
    LEFT    JOIN RateCards.HotelRateMaster HRM
              ON HRD.HotelRateID = HRM.HotelRateID
    WHERE   HRD.HotelRateDetailID IN (SELECT value FROM STRING_SPLIT(@RateDetailID, ','))
    GROUP BY
            HRD.HotelRateID, HRD.HotelRateDetailID, HRM.HotelID, HRM.CardNumber,
            HRM.ContractDate, HRD.Days, HRD.RoomCategoryID, HRD.MealPlanID,
            HRM.CurrencyID, HRM.InfoForRemark, HRM.StateID, HRM.GstStatus, HRM.CityID,
            HRM.Heading, HRM.InfoForAgent, HRM.InfoForOperation, HRM.PaymentTypeID,
            HRM.RateCardModeTypeID, HRM.RateTypeID, HRM.ValueAddOn, HRD.IsActive,
            HRM.VendorID;

    BEGIN TRY
        BEGIN TRANSACTION;

        OPEN CUR_HotelRates;
        FETCH NEXT FROM CUR_HotelRates
        INTO
            @C_HotelRateID,        @C_HotelRateDetailID, @C_HotelID,        @C_CardNumber,
            @C_ContractDate,       @C_Days,              @C_RoomCategoryID, @C_MealPlanID,
            @C_CurrencyID,         @C_InfoForRemark,     @C_StateID,        @C_GstStatus,
            @C_CityID,             @C_Heading,           @C_InfoForAgent,   @C_InfoForOperation,
            @C_PaymentTypeID,      @C_RateCardModeTypeID,@C_RateTypeID,     @C_ValueAddOn,
            @C_IsActive,           @C_VendorID;

        WHILE @@FETCH_STATUS = 0
        BEGIN
           
            INSERT  Booking.HotelRateCardMasterBooking
                   (HotelRateID, HotelRateDetailID, HotelID, CardNumber, ContractDate,
                    Days, RoomCategoryID, MealPlanID, CurrencyID,
                    InfoForRemark, StateID, GstStatus, CityID, Heading,
                    InfoForAgent, InfoForOperation, PaymentTypeID,
                    RateCardModeTypeID, RateTypeID, ValueAddOn,
                    IsActive, QuotationID, Disclaimer,
                    CheckIn, CheckOut, BookingID,
                    AddedFromBooking, IsCustom)
            VALUES (@C_HotelRateID,        @C_HotelRateDetailID, @C_HotelID,     @C_CardNumber,
                    @C_ContractDate,       @C_Days,              @C_RoomCategoryID, @C_MealPlanID,
                    @C_CurrencyID,         @C_InfoForRemark,     @C_StateID,     @C_GstStatus,
                    @C_CityID,             @C_Heading,           @C_InfoForAgent, @C_InfoForOperation,
                    @C_PaymentTypeID,      @C_RateCardModeTypeID,@C_RateTypeID,  @C_ValueAddOn,
                    @C_IsActive,           @QuotationID,         '',
                    @CheckIn,              @CheckOut,            @BookingID,
                    1,                     0);

            SET @QuotationHotelRateID = SCOPE_IDENTITY();

            INSERT Booking.HotelRateCommissionDetailsBooking
                   (QuotationHotelRateID, RateCommisionID, CommissionMasterID,
                    GrossRate, TaxPercentage, TaxAmount,
                    GrossAmountIncludingTax, GrossAmountExcludingTax,
                    CommisionPercentage, CreatedOn, CreatedBy, IsActive,
                    HotelRateID, HotelRateDetailID, QuotationID,
                    NetAmountIncludingTax, NetAmountExcludingTax,
                    BookingID, AddedFromBooking)
            SELECT  @QuotationHotelRateID,
                    RCD.RateCommisionID,
                    ISNULL(RCD.CommissionMasterID,0),
                    CASE WHEN @SupplierTax_InCluding = 0
                             THEN RCD.NetAmountExcludingTax
                         ELSE RCD.NetAmountIncludingTax
                    END,
                    ISNULL(RCD.TaxPercentage,0),
                    ISNULL(RCD.TaxAmount,0),
                    ISNULL(RCD.GrossAmountIncludingTax,0),
                    ISNULL(RCD.GrossAmountExcludingTax,0),
                    ISNULL(RCD.CommisionPercentage,0),
                    GETDATE(),
                    @UserID,
                    ISNULL(RCD.IsActive,0),
                    @C_HotelRateID,
                    @C_HotelRateDetailID,
                    @QuotationID,
                    RCD.NetAmountIncludingTax,
                    RCD.NetAmountExcludingTax,
                    @BookingID,
                    1
            FROM    RateCards.RateCommisionDetails RCD
            WHERE   RCD.HotelRateDetailID = @C_HotelRateDetailID;
			INSERT  Booking.HotelRateMealPlanMasterBooking
                   (QuotationHotelRateID, MealTypeID, GstPercentage, GstAmount,
                    NetAmountIncludingTax, NetAmountExcludingTax, IsActive,
                    CreatedBy, CreatedOn, MasterCommissionID,
                    IsMealDetails, DefineAmount,
                    HotelRateID, HotelRateDetailID, QuotationID, AddedFromBooking)
            SELECT  @QuotationHotelRateID,
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
                    @C_HotelRateID,
                    @C_HotelRateDetailID,
                    @QuotationID,
                    1
            FROM    RateCards.HotelMealOverviewMaster HMM
            JOIN    MealPlan MP
                    ON MP.ID = HMM.MealTypeID
                   AND MP.IsActive = 1
            WHERE   HMM.HotelRateDetailID = @C_HotelRateDetailID
              AND   HMM.IsActive = 1;

         ;WITH DateRange AS
            (
                SELECT @CheckIn AS [Date]
                UNION ALL
                SELECT DATEADD(DAY,1,[Date])
                FROM   DateRange
                WHERE  [Date] < @CheckOut
            )
            INSERT  Booking.DayWiseBooking
                   (DayWiseDate, City, HotelName, RoomCategory,
                    DBL,EBA,EBC,CNB,SGL,
                    DBL_Rate,EBA_Rate,EBC_Rate,CNB_Rate,SGL_Rate,
                    MealPlan, Breakfast, Lunch, Dinner,
                    RateTypeID, ServiceName, IsActive,
                    CreatedBy, CreatedOn,
                    RateID, RateDetailID, GrossRate, Currency,
                    BookingID, BHRMID, Vendor)
            SELECT  d.[Date],
                    HRM.CityID,
                    H.HotelName,
                    RC.Name,
                    0,0,0,0,0,
                    0,0,0,0,0,
                    MP.Code, MP.Breakfast, MP.Lunch, MP.Dinner,
                    5, 'Hotel', 1,
                    @UserID, GETDATE(),
                    @C_HotelRateID,
                    @C_HotelRateDetailID,
                    0,
                    HRM.CurrencyID,
                    @BookingID,
                    @QuotationHotelRateID,
                    @C_VendorID
            FROM        DateRange d
            JOIN        RateCards.HotelRateMaster HRM
                          ON HRM.HotelRateID = @C_HotelRateID
            JOIN        RateCards.HotelRateDetails RCD
                          ON RCD.HotelRateDetailID = @C_HotelRateDetailID
            JOIN        HotelMaster H
                          ON H.HotelID = HRM.HotelID
            LEFT JOIN   RoomCategory RC  ON RC.ID = RCD.RoomCategoryID
            LEFT JOIN   MealPlan     MP  ON MP.ID = RCD.MealPlanID
                                         AND MP.IsActive = 1
            OPTION (MAXRECURSION 0);

            
            FETCH NEXT FROM CUR_HotelRates
            INTO  @C_HotelRateID,        @C_HotelRateDetailID, @C_HotelID,        @C_CardNumber,
                  @C_ContractDate,       @C_Days,              @C_RoomCategoryID, @C_MealPlanID,
                  @C_CurrencyID,         @C_InfoForRemark,     @C_StateID,        @C_GstStatus,
                  @C_CityID,             @C_Heading,           @C_InfoForAgent,   @C_InfoForOperation,
                  @C_PaymentTypeID,      @C_RateCardModeTypeID,@C_RateTypeID,     @C_ValueAddOn,
                  @C_IsActive,           @C_VendorID;
        END 

        CLOSE CUR_HotelRates;
        DEALLOCATE CUR_HotelRates;

     SELECT '200'   AS returnCode,
               'New record(s) added successfully.' AS returnMessage;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        IF CURSOR_STATUS('global','CUR_HotelRates') >= 0
        BEGIN
            CLOSE CUR_HotelRates;
            DEALLOCATE CUR_HotelRates;
        END

        DECLARE @ErrMsg  NVARCHAR(4000) = ERROR_MESSAGE(),
                @ErrSev  INT            = ERROR_SEVERITY(),
                @ErrState INT           = ERROR_STATE();

        RAISERROR (@ErrMsg,@ErrSev,@ErrState);
    END CATCH
END

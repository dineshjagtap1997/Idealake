namespace TamarindAstra_Operations.Model
{
    public class HotelRateCard
    {
    }
    public class HotelRateDetailsSearchResponseDto
    {

        public int? QuoHotelRateID { get; set; }
        public long HotelRateID { get; set; }
        public long HotelID { get; set; }
        public string HotelName { get; set; }
        public string CityID { get; set; }
        public long HotelRateDetailID { get; set; }
        public int RoomCategoryID { get; set; }
        public string RoomCategory { get; set; }
        public string MISSequence { get; set; }
        public string Days { get; set; }
        public string DaysOfWeek { get; set; }
        public string DaysNumber { get; set; }
        public string MealPlanCode { get; set; }
        public bool? Breakfast { get; set; }
        public bool? Lunch { get; set; }
        public bool? Dinner { get; set; }

        // These will be JSON strings in SQL
        public string CommissionJSON { get; set; }
        public string MealOverviewJSON { get; set; }
        public string OfferConfigurationJSON { get; set; }

        public string HotelAnnouncementsJSON { get; set; }

        public string CancellationPolicyJSON { get; set; }
        public string MarketJSON { get; set; }
        public string RateSheetJSON { get; set; }
        public bool HasRules { get; set; } = true;
        public bool HasDocument { get; set; } = true;
        public int? OfferTypeID { get; set; }

        public string Disclaimer { get; set; }

        public string? FromToDate { get; set; }
        public long? QuotationID { get; set; }

        public bool? ShowCancellationDays { get; set; }
        public bool? ShowValueAddOns { get; set; }
        public bool? ShowTransfers { get; set; }
        public bool? ShowAnnouncement { get; set; }


        public string TransferValue { get; set; }

        public string ValueAddOn { get; set; }

        public List<HotelRateCommissionDetailResponseDto> Commissions { get; set; } = new();
        public List<HotelRateMealResponseDto> Meals { get; set; } = new();
        public List<HotelRateOfferConfigurationSearchDto> Offers { get; set; } = new();
        public List<HotelAnnouncement> HotelAnnouncement { get; set; } = new();

        public List<HotelRateCancellationPolicy> CancellationPolicy { get; set; } = new();

        public string Type { get; set; }
        public string CityName { get; set; }
        public int? Count { get; set; }
        public string Currency { get; set; }
        public string QuotationNo { get; set; }
        public int BookID { get; set; }
        public decimal PurchaseRate { get; set; }
        public bool? IsSummary { get; set; }
        public decimal BreakfastGrossRate { get; set; }
        public decimal LunchGrossRate { get; set; }
        public decimal DinnerGrossRate { get; set; }

        public int EnquiryID { get; set; }
        public string EnquiryNo { get; set; }
        public int? RateCardModeTypeID { get; set; }
        public decimal? SupplementaryAmt { get; set; }
        public bool? IsSupplementaryPer { get; set; }
    }

    public class HotelRateCommissionDetailResponseDto : HotelRateCommission
    {
    }
    public class HotelRateCommission : RateCardBase
    {
        public long OthersRateCardCommissionID { get; set; }
        public long RateCommissionID { get; set; }
        public int MasterCommissionID { get; set; }
        public decimal TaxPercentage { get; set; }
        public decimal TaxAmount { get; set; }
        public decimal GrossAmountIncludingTax { get; set; }
        public decimal GrossAmountExcludingTax { get; set; }
        public decimal NetAmountIncludingTax { get; set; }
        public decimal NetAmountExcludingTax { get; set; }
        public decimal CommissionPercentage { get; set; }
        public decimal CommissionAmount { get; set; }

        public decimal GrossAmountIncludingTax_Con { get; set; }
        public decimal GrossAmountExcludingTax_Con { get; set; }
        public decimal NetAmountIncludingTax_Con { get; set; }
        public decimal NetAmountExcludingTax_Con { get; set; }

        public decimal CommissionAmount_Con { get; set; }
        public long HotelRateDetailID { get; set; }
        public bool IsTax { get; set; }
        public string RateType { get; set; }

        public bool? Markup_IsRate { get; set; }
        public decimal? MarkupRate { get; set; }

        public int? ReasonID { get; set; }

        public decimal? SellingRates { get; set; }

        public decimal? GrossRate { get; set; }
        public int? Count { get; set; }
        public bool? Breakfast { get; set; }
        public bool? Lunch { get; set; }
        public bool? Dinner { get; set; }

    }
    public class HotelRateMealResponseDto : HotelMeal
    {
        public long OthersRateCardMealID { get; set; }
        public int MasterCommissionID { get; set; }
        public int HotelRateMealID { get; set; }
        public long HotelRateDetailID { get; set; }
        public int MealTypeID { get; set; }
        public decimal NetAmountIncludingTax_Con { get; set; }
        public decimal NetAmountExcludingTax_Con { get; set; }
        public int? ReasonID { get; set; }
        public decimal? SellingRates { get; set; }

        public decimal? GrossRate { get; set; }

        public bool? IsSupplementary { get; set; }
        public bool? IsGross { get; set; }

        public decimal? SupplementaryAmt { get; set; }
        public bool? IsSupplementaryPer { get; set; }
    }
    public class HotelMeal : RateCardBase
    {
        public bool IsMealDetails { get; set; }
        public bool DefinedAmount { get; set; }
        public string MealType { get; set; }
        public decimal GstPercentage { get; set; }
        public decimal GstAmount { get; set; }
        public decimal NetAmountIncludingTax { get; set; }
        public decimal NetAmountExcludingTax { get; set; }
    }
    public class HotelRateOfferConfigurationSearchDto : HotelRateOfferConfigurationResponseDto
    {
        public string OfferType { get; set; }

    }
    public class HotelRateOfferConfigurationResponseDto : HotelRateOfferConfiguration
    {
    }
    public class HotelRateOfferConfiguration : RateCardBase
    {
        public long OfferID { get; set; }
        public long HotelRateDetailID { get; set; }
        public int Days { get; set; }
        public string FromDate { get; set; }
        public string ToDate { get; set; }
        public int TotalNights { get; set; }
        public int PaidNights { get; set; }
        public int FreeNights { get; set; }
        public bool IsExtendible { get; set; }
        public bool IsDeleted { get; set; }

        public List<HotelRateOfferConfigurationCommission> OfferCommission { get; set; } = new();
    }

    public class HotelRateOfferConfigurationCommission
    {
        public long OfferCommissionID { get; set; }
        public long OfferConfigurationID { get; set; }
        public int MasterCommissionID { get; set; }
        public decimal Discount { get; set; }
        public decimal DiscountAmount { get; set; }
        public decimal TaxPercentage { get; set; }
        public decimal TaxAmount { get; set; }
        public decimal PaidNightAmountExcludingTax { get; set; }
        public decimal PaidNightAmountIncludingTax { get; set; }
        public decimal FreeNightAmountExcludingTax { get; set; }
        public decimal FreeNightAmountIncludingTax { get; set; }
        public decimal GrossAmountExcludingTax { get; set; }
        public decimal GrossAmountIncludingTax { get; set; }
        public decimal NetAmountExcludingTax { get; set; }
        public decimal NetAmountIncludingTax { get; set; }
        public bool IsActive { get; set; }

        public string RateType { get; set; }
    }
    public class HotelAnnouncement
    {
        public int AnnouncementID { get; set; } = 0;
        public int HotelID { get; set; }
        public int HeaderID { get; set; }
        public string AnnouncementDetails { get; set; }
        public DateTime? ValidTo { get; set; } = null;
        public string Action { get; set; }
        public string CityID { get; set; }

        public string ChainIATACode { get; set; }
        public Guid? OperationBy { get; set; }
    }
    public class HotelRateCancellationPolicy
    {
        public long PolicyID { get; set; }
        public RateCardType RateCardTypeID { get; set; }
        public long RateCardID { get; set; }
        public string ValidFrom { get; set; }
        public string ValidTo { get; set; }
        public string TsStart { get; set; }
        public string TsEnd { get; set; }
        public string AgentStart { get; set; }
        public string AgentEnd { get; set; }
        public string ChangePercent { get; set; }
        public string ChargeNight { get; set; }
        public bool IsActive { get; set; }
        public string CreatedBy { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime CreatedOn { get; set; }
        public DateTime UpdatedOn { get; set; }

        public Guid? OperationBy { get; set; }

    }
    public class CustomRateMaster : HotelRateDetail
    {
        public string CityID { get; set; }//City*
        public string CurrencyID { get; set; }//Currency*
        public long HotelID { get; set; }//Hotel*
        public long VendorID { get; set; }//Vendor*
        public int PaymentTypeID { get; set; }//Direct Commission/ BTC commission
        public bool IsCommission { get; set; }
        public bool IsTax { get; set; } //Including/ExcludingTax
        public string LanguageID { get; set; }//Language*
        public int VehicleCategoryID { get; set; }//Vehical Category*

        public string VehicleCategoryName { get; set; }
        public int ServiceID { get; set; }//Service*
        public string ValueAddOn { get; set; }//Service Discription*
        public int NationalityID { get; set; }//Nationality*
        public long QuotationID { get; set; }
        public int RatePreferenceID { get; set; }

        public List<CustomRateCommission> Commissions { get; set; } = new();
        public List<HotelRateMealRequestDto> Meals { get; set; } = new();

        public DateTime? CheckIn { get; set; }
        public DateTime? CheckOut { get; set; }

        public string XORemark { get; set; }//Xo Remark*
        public string Validfrom { get; set; }
        public string ValidTo { get; set; }
        public RateCardModeType RateCardModeTypeID { get; set; }//Rate Type*
        public long BookingID { get; set; }

    }
    public class CustomRateCommission : HotelRateCommission
    {
        public bool IsAmtIncludedInBasic { get; set; }
        public int MinimumPax { get; set; }
        public int MaximumPax { get; set; }
    }
    public enum OfferType
    {
        None = 0,
        EBO = 1,
        PayOrStay = 2
    }
    public class HotelRateDetail : RateCardBase
    {
        public long HotelRateDetailID { get; set; }
        public long HotelRateID { get; set; }
        public int RoomCategoryID { get; set; }//Room Category
        public TaxPreference TaxID { get; set; }
        public string Days { get; set; } //Days Applicable*
        public bool FIT { get; set; } //FIt 
        public bool GIT { get; set; } //GIT
        public int MealPlanID { get; set; }
        public int TransferID { get; set; }
        public int MinNights { get; set; }
        public int MaxNights { get; set; }
        public int RateTypeID { get; set; }
        public OfferType OfferTypeID { get; set; }
        public string MISSequence { get; set; }
        public int BusinessType { get; set; }
    }
    public class HotelRateMealRequestDto : HotelMeal
    {
        public int MasterCommissionID { get; set; }
        public int HotelRateMealID { get; set; }
        public long HotelRateDetailID { get; set; }
        public int MealTypeID { get; set; }
    }
}

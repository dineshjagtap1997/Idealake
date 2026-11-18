using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Hotel;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel
{
    public class HotelRateDetailsSearchResponseDto
    {
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
        public int? HotelPreferred { get; set; }
        public string PreferedDaterange { get; set; }
        public string RateValidityRange { get; set; }
        public string UserName { get; set; }

        // These will be JSON strings in SQL
        public string CommissionJSON { get; set; }
        public string MealOverviewJSON { get; set; }
        public string OfferConfigurationJSON { get; set; }
        public string HotelOfferRateCardJSON { get; set; }
        public string MarketJSON { get; set; }
        public string RateSheetJSON { get; set; }
        public bool HasRules { get; set; } = true;
        public bool HasDocument { get; set; } = true;
        public int? OfferTypeID { get; set; }

        public string Currency { get; set; }

        public decimal PurchaseRate { get; set; }
        public int? TransferID { get; set; }

        public string TransferValue { get; set; }

        public int? RateCardModeTypeID { get; set; }
        public List<HotelRateCommissionSearch> Commissions { get; set; } = new();
        public List<HotelRateMealSearchResponse> Meals { get; set; } = new();
        public List<HotelRateOfferConfigurationSearchDto> Offers { get; set; } = new();
        public List<HotelRateOfferRateCardDto> HotelOfferRateCard { get; set; } = new();
        public List<HotelRateMarketMasterLookup> Markets { get; set; } = new();
        public List<HotelRatesheetMasterLookup> RateSheets { get; set; } = new();
        public List<HotelAnnouncement> HotelAnnouncement { get; set; } = new();

        public List<HotelContactDetails> HotelContactDetails { get; set; } = new();
        public List<RateRuleResponseDto> RateRuleResponse { get; set; } = new();
        
        public string Type { get; set; }

        public string ValueAddOn { get; set; }

        public string InfoForOperation { get; set; }
        public string InfoForRemark { get; set; }
        public string CityName { get; set; }

        public Guid? CreatedBy { get; set; }
        public string HotelType { get; set; }
        public string ZoneName { get; set; }

        public string VendorName { get; set; }

        public string ExtraBedMattress { get; set; }

       public bool? CreditApplicable { get; set; }
        public string CreditCurrencyCode { get; set; }

        public int? CreditPeriod { get; set; }

        public decimal CreditAmount { get; set; }

        public string CreditApproveBy { get; set; }

        public string EmailFinance { get; set; }
        public string CardNumber { get; set; }

        public string BookFrom { get; set; }
        public string BookTo { get; set; }

        public bool? IsCommission { get; set; }

        public bool? Direct_BTC { get; set; }


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

    public class HotelContactDetails
    {
        public int? ParentID { get; set; }
        public byte? TypeID { get; set; }
        public bool? IsPrimaryContact { get; set; }
        public int? SalutationID { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string DesignationOrDepartment { get; set; }
        public string EmailID { get; set; }
        public string OfficeNo { get; set; }
        public string MobileNo { get; set; }
        public string FaxNo { get; set; }
        public DateTime? DateOfBirth { get; set; }
        public string CityIATACode { get; set; }
        public DateTime? InsertedDate { get; set; }
        public bool IsActive { get; set; }
        public bool? IsAccStatement { get; set; }
        public bool? IsCC { get; set; }
        public bool? IsForContracting { get; set; }
        public bool? IsBills { get; set; }
        public Guid? CreatedBy { get; set; }
        public Guid? OperationBy { get; set; }
        public int? ContactDetailsID { get; set; }
        public int? ID { get; set; }
        public string Action { get; set; }
    }

}

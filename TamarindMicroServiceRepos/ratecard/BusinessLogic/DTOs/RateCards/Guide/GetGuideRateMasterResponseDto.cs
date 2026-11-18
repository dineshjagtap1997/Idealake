using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Guide;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Guide
{
    public class GetGuideRateResponseDto : GuideRate
    {
        public string City { get; set; }
        public string Vendor { get; set; }
        public string GuideService { get; set; }
        public string Currency { get; set; }
        public string RateCardMode { get; set; }
        public string NetAmountIncludingTax { get; set; }
        public string TaxPercentage { get; set; }
        public string TaxAmount { get; set; }
        public string NetAmountExcludingTax { get; set; }
        public string SellingRate { get; set; }
        public string PaxRange { get; set; }
        public string Language { get; set; }
        //Guide Rate properties 
        public long GuideRateID { get; set; }
        public RateCardModeType RateCardModeTypeID { get; set; }
        public string CurrencyID { get; set; }
        public int VendorID { get; set; }
        public string LanguageID { get; set; }
        public string CityID { get; set; }
        public int GuideServiceID { get; set; }
        public int StateID { get; set; }
        public string GstStatus { get; set; }
        public string ValueAddOn { get; set; }
        //public string GuideService { get; set; }

        //GuideRate Details properties

        public long GuideRateDetailID { get; set; }
        public TaxPreference TaxID { get; set; }
        public string ValidFrom { get; set; }
        public string ValidTo { get; set; }
        public string MISSequence { get; set; }

        public long SpecialServiceRateID { get; set; }
        public long SpecialServiceRateDetailID { get; set; }
        public int NationalityID { get; set; }
        public RatePreference RatePreferenceID { get; set; }

        public string Nationality { get; set; }
        //public string PaxRange { get; set; }
        //public string Language { get; set; }
        //public decimal? SellingRate { get; set; }

        public decimal? GrossRate { get; set; }
        public long? BookingID { get; set; }
    }
}

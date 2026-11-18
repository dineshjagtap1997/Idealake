using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Guide
{
    public class GuideRate : RateCardBase
    {
        public long GuideRateID { get; set; }
        public RateCardModeType RateCardModeTypeID { get; set; }
        public string CurrencyID { get; set; }
        public int VendorID { get; set; }
        public string LanguageID { get; set; }
        public string CityID { get; set; }
        public int? GuideServiceID { get; set; }
        public int StateID { get; set; }
        public string GstStatus { get; set; }
        public string ValueAddOn { get; set; }
        public string GuideService { get; set; }
    }
}

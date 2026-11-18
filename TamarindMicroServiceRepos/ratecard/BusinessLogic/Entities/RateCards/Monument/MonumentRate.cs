using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Monument
{
    public class MonumentRate : RateCardBase
    {
        public long MonumentRateID { get; set; }
        public RateCardModeType RateCardModeTypeID { get; set; }
        public string CurrencyID { get; set; }
        public int VendorID { get; set; }
        public int MonumentServiceID { get; set; }
        public string CityID { get; set; }
        public int StateID { get; set; }
        public string GstStatus { get; set; }

        public string MonumentService { get; set; }
    }
}

using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.SpecialService
{
    public class SpecialServiceRate : RateCardBase
    {
        public long SpecialServiceRateID { get; set; }
        public int SpecialServiceID { get; set; }
        public RateCardModeType RateCardModeTypeID { get; set; }
        public string CityID { get; set; }
        public int StateID { get; set; }
        public string GstStatus { get; set; }
        public int HotelID { get; set; }
        public string CurrencyID { get; set; }
        public int VendorID { get; set; }
        public int HrsPerDay { get; set; }
        public int KmPerDay { get; set; }
        public string SpecialService { get; set; }
    }
}

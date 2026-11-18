using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Hotel
{
    public class HotelRate : RateCardBase
    {
        public long HotelRateID { get; set; }
        public string CityID { get; set; }
        public int HotelID { get; set; }
        public int VendorID { get; set; }
        public string CurrencyID { get; set; }
        public RateCardModeType RateCardModeTypeID { get; set; }
        public PaymentType PaymentTypeID { get; set; }
        public string ValueAddOn { get; set; }
        public int RateTypeID { get; set; }
        public int StateID { get; set; }
        public string GstStatus { get; set; }
        public string RateType { get; set; }
        public string CityName { get; set; }
        public string HotelName { get; set; }
        public string DirectPayment { get; set; }
        public string BTCCommission { get; set; }
        public string ActionName { get; set; }
        public string PaymentType { get; set; }
        public bool IsCommission { get; set; }
    }
}

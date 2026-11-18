namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Hotel
{
    public class HotelRateValidity : RateCardBase
    {
        public long RateValidityID { get; set; }
        public string BookFrom { get; set; }
        public string BookTo { get; set; }
        public string RateValidFrom { get; set; }
        public string RateValidTo { get; set; }
        public long HotelRateDetailID { get; set; }
    }
}

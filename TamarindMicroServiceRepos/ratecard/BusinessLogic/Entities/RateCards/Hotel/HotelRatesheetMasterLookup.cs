namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Hotel
{
    public class HotelRatesheetMasterLookup
    {
        public int ID { get; set; }
        public int RateSheetID { get; set; }
        public long HotelRateID { get; set; }
        public int IsActive { get; set; }
    }
    public class HotelRateMarketMasterLookup
    {
        public int ID { get; set; }
        public int MarketRateID { get; set; }
        public string MarketName { get; set; }
        public long HotelRateID { get; set; }
        public int IsActive { get; set; }
    }
    public class HotelOfferRateSheetMasterLookup : HotelRatesheetMasterLookup
    {
        public long HotelOfferID { get; set; }
        public string RateTypeName { get; set; }
    }
    public class HotelOfferMarketMasterLookup : HotelRateMarketMasterLookup
    {
        public long HotelOfferID { get; set; }
    }
    public class HotelOfferMapping
    {
        public int ID { get; set; }
        public int HotelID { get; set; }
        public long HotelOfferID { get; set; }
        public int IsActive { get; set; }
        public string HotelName { get; set; }
    }
}

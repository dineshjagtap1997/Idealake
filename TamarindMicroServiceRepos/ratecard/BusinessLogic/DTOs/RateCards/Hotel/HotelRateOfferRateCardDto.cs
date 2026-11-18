namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel
{
    public class HotelRateOfferRateCardDto
    {
        public int HotelOfferID { get; set; }
        public string CardNumber { get; set; }
        public string Heading { get; set; }
        public string City { get; set; }
        public string VendorName { get; set; }
        public string HotelGroupName { get; set; }
        public bool IsActive { get; set; }
        public DateTime ValidFrom { get; set; }
        public DateTime ValidTo { get; set; }
        public string Rule { get; set; }
        public bool HasRules { get; set; }
        public bool HasDocument { get; set; }
        public List<HotelDetail> HotelDetailsJson { get; set; }
    }

    public class HotelDetail
    {
        public int HotelID { get; set; }
        public string HotelName { get; set; }
    }
}
namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.HotelOffer
{
    public class HotelOfferSearchResponseDto
    {

        public string City { get; set; }
        public string HotelGroupName { get; set; }
        public string CityID { get; set; }
        public string VendorName { get; set; }
        public string HotelName { get; set; }
        public string Heading { get; set; }
        public DateTime? ValidFrom { get; set; }
        public DateTime? ValidTo { get; set; }
        public long HotelOfferID { get; set; }
        public bool? IsActive { get; set; }
        public string CardNumber { get; set; }
        public string RateSheet { get; set; }
        public string MarketName { get; set; }
        public string StayFromTo { get; set; }
        public string HotelRating { get; set; }
        public string IsHotelVendor { get; set; }
        public string VendorHotelName { get; set; }

        public string InfoForOps { get; set; }
       
        public string IATACode { get; set; }
        public int HotelRatingID { get; set; }
      
        public string CardNo { get; set; }
    }
}

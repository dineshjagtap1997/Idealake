namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.HotelOffer
{
    public class HotelOfferSearchRequestDto
    {

       
        public string City { get; set; }
        public int? HotelVendorName { get; set; }
        public string HotelGroup { get; set; }
        public string RateHeader { get; set; }
        public string ValidFrom { get; set; }  // Expecting "yyyy-MM-dd" format
        public string ValidTo { get; set; }
        public string Action { get; set; }
    }
}

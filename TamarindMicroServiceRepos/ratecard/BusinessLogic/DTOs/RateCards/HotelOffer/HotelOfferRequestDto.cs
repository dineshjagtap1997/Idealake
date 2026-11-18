using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.HotelOffer;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.HotelOffer
{
    public class HotelOfferRequestDto : HotelOfferRate
    {
        public string City { get; set; }
        public string HotelName { get; set; }
        public string VendorName { get; set; }
        public string HotelGroupName { get; set; }
    }
}

using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.HotelOffer;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.HotelOffer
{
    public class HotelOfferResponseDto : HotelOfferRate
    {
        public int? TotalCount { get; set; }
       public string HotelGroupName { get; set; }
        public string CityName { get; set; }
    }
}

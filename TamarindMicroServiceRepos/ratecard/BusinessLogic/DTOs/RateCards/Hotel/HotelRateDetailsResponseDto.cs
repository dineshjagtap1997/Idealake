using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Guide;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Hotel;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel
{
    public class HotelRateDetailsResponseDto : HotelRateDetail
    {
        public string MealPlan { get; set; }
        public string TransferValue { get; set; }
        public string RoomCategory { get; set; }
        public string DaysNumber { get; set; }
        public List<HotelRateCommissionDetailResponseDto> Commissions { get; set; } = new();
        public List<HotelRateValidityResponseDto> Validities { get; set; } = new();
        public List<HotelRateMealResponseDto> Meals { get; set; } = new();
        public List<HotelRateOfferConfiguration> OfferConfiguration { get; set; } = new();
    
        //public HotelRateOfferConfigurationRequestDto OfferConfiguration { get; set; }
    }
}

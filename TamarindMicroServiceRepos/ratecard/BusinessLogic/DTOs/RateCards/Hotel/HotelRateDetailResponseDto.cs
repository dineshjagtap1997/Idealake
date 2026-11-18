using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Hotel;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel
{
    public class HotelRateDetailResponseDto : HotelRateDetail
    {
        public string MealPlan { get; set; }
        public string Transfer { get; set; }
        public string RoomCategory { get; set; }
        public string RateType { get; set; }
        public IEnumerable<HotelRateCommissionDetailResponseDto> Commissions { get; set; }
        public IEnumerable<HotelRateValidityResponseDto> Validities { get; set; }
        public IEnumerable<HotelRateMealResponseDto> Meals { get; set; }
        public HotelRateOfferConfigurationResponseDto OfferConfiguration { get; set; }
    }
}

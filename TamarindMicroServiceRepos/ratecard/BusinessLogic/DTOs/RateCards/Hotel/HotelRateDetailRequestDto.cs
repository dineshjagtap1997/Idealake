using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Hotel;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel
{
    public class HotelRateDetailRequestDto : HotelRateDetail
    {
        public List<HotelRateCommissionDetailRequestDto> Commissions { get; set; }
        public List<HotelRateValidityRequestDto> Validities { get; set; }
        public List<HotelRateMealRequestDto> Meals { get; set; }
        public List<HotelRateOfferConfigurationRequestDto> OfferConfiguration { get; set; }
    }
}

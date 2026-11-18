using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Hotel.CancellationPolicy;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel.CancellationPolicy
{
    public class HotelRateCancellationPolicyDto : HotelRateCancellationPolicy
    {
        public string Action { get; set; }
    }
}

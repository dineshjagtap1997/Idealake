using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel.CancellationPolicy;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Hotel.CancellationPolicy
{
    public interface IUpdateHotelRatePolicyRepository
    {
        Task<ApiResponseWrapper> UpdateHotelRatePolicy(HotelRateCancellationPolicyDto hotelRatePolicy);
    }
}

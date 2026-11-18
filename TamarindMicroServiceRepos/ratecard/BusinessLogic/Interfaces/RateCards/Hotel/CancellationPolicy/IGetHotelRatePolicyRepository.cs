using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel.CancellationPolicy;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Hotel.CancellationPolicy
{
    public interface IGetHotelRatePolicyRepository
    {
        Task<IEnumerable<HotelRateCancellationPolicyDto>> GetAllHotelRateCancellationPolicyAsync(HotelRateCancellationPolicyDto hotelRatePolicy);
        Task<HotelRateCancellationPolicyDto> GetHotelRateCancellationPolicyAsync(HotelRateCancellationPolicyDto hotelRatePolicy);
    }
}

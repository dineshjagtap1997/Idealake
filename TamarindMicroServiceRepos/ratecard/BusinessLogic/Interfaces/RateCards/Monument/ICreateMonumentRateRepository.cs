using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Monument;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Monument
{
    public interface ICreateMonumentRateRepository
    {
        Task<ApiResponseWrapper> CreateMonumentRateAsync(MonumentRateRequestDto request);
        Task<ApiResponseWrapper> CreateMonumentRateDetailAsync(MonumentRateDetailRequestDto request);
        Task<ApiResponseWrapper> CopyMonumentRateAsync(MonumentRateRequestDto request);
        Task<ApiResponseWrapper> CreateNegotiateMonumentRateAsync(CustomHotelRateRequestDto request);
    }
}

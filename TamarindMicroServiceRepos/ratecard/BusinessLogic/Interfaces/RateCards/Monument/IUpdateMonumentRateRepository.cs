using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Monument;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Monument
{
    public interface IUpdateMonumentRateRepository
    {
        Task<ApiResponseWrapper> UpdateMonumentRateAsync(MonumentRateRequestDto request);
        Task<ApiResponseWrapper> UpdateMonumentRateDetailAsync(MonumentRateDetailRequestDto request);
    }
}

using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.SpecialService;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.SpecialService
{
    public interface IUpdateSpecialServiceRateRepository
    {
        Task<ApiResponseWrapper> UpdateSpecialServiceRateAsync(SpecialServiceRateRequestDto request);
        Task<ApiResponseWrapper> UpdateSpecialServiceRateDetailAsync(SpecialServiceDetailRequestDto request);
    }
}

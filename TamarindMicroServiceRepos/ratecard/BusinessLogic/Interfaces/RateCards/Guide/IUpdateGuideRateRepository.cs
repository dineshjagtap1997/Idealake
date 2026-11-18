using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Guide;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Guide
{
    public interface IUpdateGuideRateRepository
    {
        Task<ApiResponseWrapper> UpdateGuideRateAsync(GuideRateRequestDto request);
        Task<ApiResponseWrapper> UpdateGuideRateDetailAsync(GuideRateDetailRequestDto request);
    }
}

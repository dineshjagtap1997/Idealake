using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Guide;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Guide
{
    public interface ICreateGuideRateRepository
    {
        Task<ApiResponseWrapper> CreateGuideRateAsync(GuideRateRequestDto request);
        Task<ApiResponseWrapper> CreateGuideRateDetailAsync(GuideRateDetailRequestDto request);
        Task<ApiResponseWrapper> CopyGuideRateAsync(GuideRateRequestDto request);
        Task<ApiResponseWrapper> CreateNegotiateGuideRateAsync(CustomHotelRateRequestDto request);
    }
}

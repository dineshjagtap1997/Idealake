using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.SpecialService;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.SpecialService
{
    public interface ICreateSpecialServiceRateRepository
    {
        Task<ApiResponseWrapper> CreateSpecialServiceRateAsync(SpecialServiceRateRequestDto request);
        Task<ApiResponseWrapper> CreateSpecialServiceRateDetailAsync(SpecialServiceDetailRequestDto request);
        Task<ApiResponseWrapper> CopySpecialServiceRateAsync(SpecialServiceRateRequestDto request);
        Task<ApiResponseWrapper> CreateNegotiateSpecialServiceRateAsync(CustomHotelRateRequestDto request);
    }
}

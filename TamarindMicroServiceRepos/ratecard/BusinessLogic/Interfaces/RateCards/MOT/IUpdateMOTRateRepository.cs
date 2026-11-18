using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.MOT;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.MOT
{
    public interface IUpdateMOTRateRepository
    {
        Task<ApiResponseWrapper> UpdateMOTRateAsync(UpdateMOTRateRequestDto request);
        Task<ApiResponseWrapper> UpdateMOTRateDetailAsync(UpdateMOTRateDetailRequestDto request);
    }
}

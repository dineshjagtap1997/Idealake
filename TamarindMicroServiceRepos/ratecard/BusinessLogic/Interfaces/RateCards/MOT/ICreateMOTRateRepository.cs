using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.MOT;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.MOT
{
    public interface ICreateMOTRateRepository
    {
        Task<ApiResponseWrapper> CreateMOTRateAsync(CreateMOTRateRequestDto request);
        Task<ApiResponseWrapper> CreateMOTRateDetailAsync(CreateMOTRateDetailRequestDto request);
        Task<ApiResponseWrapper> CreateNegotiateMOTRateAsync(CustomHotelRateRequestDto request);
    }
}

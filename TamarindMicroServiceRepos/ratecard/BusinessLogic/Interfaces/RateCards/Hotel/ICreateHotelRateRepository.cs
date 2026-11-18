using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Hotel
{
    public interface ICreateHotelRateRepository
    {
        Task<ApiResponseWrapper> CreateHotelRateCardAsync(HotelRateRequestDto request);
        Task<ApiResponseWrapper> CreateHotelRateDetailAsync(HotelRateDetailRequestDto request);
        Task<ApiResponseWrapper> CopyHotelRateAsync(HotelRateRequestDto request);
        Task<ApiResponseWrapper> CreateCustomHotelRateCardAsync(CustomHotelRateRequestDto request,RateCardType type);
        Task<ApiResponseWrapper> CreateNegotiateHotelRateCardAsync(CustomHotelRateRequestDto request, RateCardType type);
    }
}

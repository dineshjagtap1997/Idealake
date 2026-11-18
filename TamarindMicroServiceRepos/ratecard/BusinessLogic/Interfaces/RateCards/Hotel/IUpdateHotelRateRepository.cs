using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Hotel
{
    public interface IUpdateHotelRateRepository
    {
        Task<ApiResponseWrapper> UpdateHotelRateCardAsync(HotelRateRequestDto request);
        Task<ApiResponseWrapper> UpdateHotelRateDetailAsync(HotelRateDetailRequestDto request);
        Task<ApiResponseWrapper> UpdateCustomHotelRateCardAsync(CustomHotelRateRequestDto request,RateCardType type);
    }
}

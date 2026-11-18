using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.HotelOffer;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.HotelOffer
{
    public interface ICreateHotelOfferRateRepository
    {
        Task<ApiResponseWrapper> CreateHotelOfferAsync(HotelOfferRequestDto request);
    }
}

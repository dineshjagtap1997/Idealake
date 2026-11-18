using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel.Document;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Hotel
{
    public interface IGetHotelRateCardRepository
    {
        Task<IEnumerable<HotelRateResponseDto>> GetAllHotelRateCardsAsync(HotelRateRequestDto filter);
        Task<IEnumerable<HotelRateDetailsResponseDto>> GetAllHotelRateDetailsByIdAsync(long id, int pageNumber, int pageSize);
        Task<HotelRateDetailResponseDto> GetHotelRateDetailsByIDAsync(long id);
        Task<IEnumerable<HotelRateResponseDto>> GetHotelRateCardByIDAsync(long id);
        Task<IEnumerable<HotelRateDocumentResponseDto>> GetHotelRateDocumentsAsync(UploadDocumentRequestDto request);
        Task<IEnumerable<HotelRateResponseDto>> GetRateCardNumberAsync(HotelRateRequestDto filter);
        Task<IEnumerable<HotelRateResponseDto>> GetRateCardHeadingsAsync(HotelRateRequestDto filter);
        Task<IEnumerable<HotelRateResponseDto>> GetRateCardHotelServicesAsync(HotelRateRequestDto filter);
        Task<IEnumerable<HotelRateDetailsSearchResponseDto>> GetRateCardHotelSearchServicesAsync(HotelRateSearchInputDto filter);
        Task<IEnumerable<CustomHotelRateRequestDto>> GetAllCustomHotelRateCardsAsync(CustomHotelRateRequestDto filter);
        Task<IEnumerable<CustomHotelRateRequestDto>> GetCustomHotelRateCardByIDAsync(long id,RateCardType type);
    }
}

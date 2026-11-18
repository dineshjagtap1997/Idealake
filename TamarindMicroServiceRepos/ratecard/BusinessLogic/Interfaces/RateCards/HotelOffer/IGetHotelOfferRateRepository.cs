using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.HotelOffer;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.HotelOffer.Document;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Monument;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.HotelOffer
{
    public interface IGetHotelOfferRateRepository
    {
        Task<HotelOfferResponseDto> GetHotelOfferByIDAsync(long id);
        Task<IEnumerable<HotelOfferResponseDto>> GetAllHotelOffersAsync(HotelOfferRequestDto filter);
        Task<IEnumerable<HotelOfferDocumentResponseDto>> GetHotelOfferRateDocumentsAsync(UploadDocumentRequestDto request);
        Task<IEnumerable<HotelOfferSearchResponseDto>> GetAllHotelOfferRateCardReportAsync(HotelOfferSearchRequestDto filter);
    }
}

using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Monument;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Monument.Document;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.MOT;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Monument
{
    public interface IGetMonumentRateRepository
    {
        Task<IEnumerable<GetAllMonumentRateResponseDto>> GetAllMonumentRateAsync(MonumentRateRequestDto filter);
        Task<IEnumerable<GetMonumentRateDetailResponseDto>> GetAllMonumentRateDetailsByIdAsync(long id, int pageNumber, int pageSize);
        Task<GetMonumentRateResponseDto> GetMonumentRateByIdAsync(long id);
        Task<GetMonumentRateDetailResponseDto> GetMonumentRateDetailByIdAsync(long id);
        Task<IEnumerable<MonumentRateDocumentResponseDto>> GetMonumentRateDocumentsAsync(UploadDocumentRequestDto request);
        Task<IEnumerable<GetAllMonumentRateResponseDto>> GetRateCardNumberAsync(MonumentRateRequestDto filter);
        Task<IEnumerable<GetAllMonumentRateResponseDto>> GetRateCardHeadingsAsync(MonumentRateRequestDto filter);
        Task<IEnumerable<GetAllMonumentRateResponseDto>> GetRateCardMonumentServicesAsync(MonumentRateRequestDto filter);

        Task<IEnumerable<GetMonumentRateSearchResponseDto>> GetAllMonumentRateCardReportAsync(GetMonumentRateSearchRequestDto filter);
    }
}

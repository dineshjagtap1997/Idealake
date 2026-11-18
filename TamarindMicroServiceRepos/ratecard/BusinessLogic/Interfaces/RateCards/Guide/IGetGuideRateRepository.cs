using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Guide;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Guide.Document;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Guide
{
    public interface IGetGuideRateRepository
    {
        Task<GetGuideRateResponseDto> GetGuideRateByIdAsync(long id);
        Task<IEnumerable<GetGuideRateResponseDto>> GetAllGuideRateAsync(GuideRateRequestDto filter);
        Task<IEnumerable<GetGuideRateDetailResponseDto>> GetAllGuideRateDetailsByIdAsync(long id, int pageNumber, int pageSize);
        Task<GetGuideRateDetailResponseDto> GetGuideRateDetailsByIdAsync(long id);
        Task<IEnumerable<GuideRateDocumentResponseDto>> GetGuideRateDocumentsAsync(UploadDocumentRequestDto request);
        Task<IEnumerable<GetGuideRateResponseDto>> GetRateCardNumberAsync(GuideRateRequestDto filter);
        Task<IEnumerable<GetGuideRateResponseDto>> GetRateCardHeadingsAsync(GuideRateRequestDto filter);
        Task<IEnumerable<GetGuideRateResponseDto>> GetRateCardGuideServicesAsync(GuideRateRequestDto filter);

        Task<IEnumerable<GetGuideRateSearchResponseDto>> GetAllGuideRateCardReportAsync(GetGuideRateSearchRequestDto filter);
    }
}

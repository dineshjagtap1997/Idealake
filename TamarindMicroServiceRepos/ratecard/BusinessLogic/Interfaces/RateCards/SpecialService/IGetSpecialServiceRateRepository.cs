using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.SpecialService;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.SpecialService.Document;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.SpecialService
{
    public interface IGetSpecialServiceRateRepository
    {
        Task<IEnumerable<GetAllSpecialServiceRateResponseDto>> GetAllSpecialServiceRateAsync(SpecialServiceRateRequestDto filter);
        Task<IEnumerable<GetSpecialServiceRateDetailResponseDto>> GetAllSpecialServiceRateDetailsByIdAsync(long id, int pageNumber, int pageSize);
        Task<GetSpecialServiceRateResponseDto> GetSpecialServiceRateByIdAsync(long id);
        Task<GetSpecialServiceRateDetailResponseDto> GetSpecialServiceRateDetailByIdAsync(long id);
        Task<IEnumerable<SpecialServiceDocumentResponseDto>> GetSpecialServiceRateDocumentsAsync(UploadDocumentRequestDto request);
        Task<IEnumerable<GetAllSpecialServiceRateResponseDto>> GetRateCardNumberAsync(SpecialServiceRateRequestDto filter);
        Task<IEnumerable<GetAllSpecialServiceRateResponseDto>> GetRateCardHeadingsAsync(SpecialServiceRateRequestDto filter);
        Task<IEnumerable<GetAllSpecialServiceRateResponseDto>> GetRateCardSpecialServicesAsync(SpecialServiceRateRequestDto filter);

        Task<IEnumerable<GetSpecialServiceSearchResponseDto>> GetAllSpecialServiceRateSearchReportAsync(GetSpecialServiceSearchRequestDto filter);

    }
}

using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.MOT;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.MOT.Document;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.MOT
{
    public interface IGetMOTRateRepository
    {
        Task<GetMOTRateResponseDto> GetMOTRateByIdAsync(long id);
        Task<IEnumerable<GetMOTRateResponseDto>> GetAllMOTRateAsync(MOTRateFilter filter);
        Task<IEnumerable<GetMOTRateDetailResponseDto>> GetAllMOTRateDetailsByIdAsync(long id, int pageNumber, int pageSize);
        Task<GetMOTRateDetailResponseDto> GetMOTRateDetailByIdAsync(long id);
        Task<IEnumerable<MOTDocumentResponseDto>> GetMotRateDocumentsAsync(UploadDocumentRequestDto request);
        Task<IEnumerable<GetMOTRateSearchResponseDto>> GetAllMOTRateCardReportAsync(GetMOTRateSearchRequestDto filter);

    }
}

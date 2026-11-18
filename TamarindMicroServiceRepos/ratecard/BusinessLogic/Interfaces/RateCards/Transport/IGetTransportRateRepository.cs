using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Transport;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Transport.Document;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Transport
{
    public interface IGetTransportRateRepository
    {
        Task<IEnumerable<TransportRateResponseDto>> GetAllTransportRateAsync(TransportRateRequestDto filter);
        Task<IEnumerable<TransportRateDetailResponseDto>> GetAllTransportRateDetailsByIdAsync(long id, int pageNumber, int pageSize);
        Task<TransportRateResponseDto> GetTransportRateByIdAsync(long id);
        Task<TransportRateDetailResponseDto> GetTransportRateDetailsByIdAsync(long id);
        Task<IEnumerable<TransportDocumentResponseDto>> GetTransportRateDocumentsAsync(UploadDocumentRequestDto request);
        Task<IEnumerable<TransportRateResponseDto>> GetRateCardNumberAsync(TransportRateRequestDto filter);
        Task<IEnumerable<TransportRateResponseDto>> GetRateCardHeadingsAsync(TransportRateRequestDto filter);
        Task<IEnumerable<TransportRateResponseDto>> GetRateCardTransportServicesAsync(TransportRateRequestDto filter);

        Task<IEnumerable<TransportRateSearchResponseDto>> GetAllTransportRateSearchReportAsync(TransportRateCardSearchRequest filter);
    }
}

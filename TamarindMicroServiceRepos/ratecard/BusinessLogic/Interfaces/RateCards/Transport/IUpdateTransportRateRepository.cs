using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Transport;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Transport
{
    public interface IUpdateTransportRateRepository
    {
        Task<ApiResponseWrapper> UpdateTransportServiceRateAsync(TransportRateRequestDto request);
        Task<ApiResponseWrapper> UpdateTransportServiceRateDetailAsync(TransportRateDetailRequestDto request);
    }
}

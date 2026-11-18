using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Transport;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Transport
{
    public interface ICreateTransportRateRepository 
    {
        Task<ApiResponseWrapper> CreateTransportServiceRateAsync(TransportRateRequestDto request);
        Task<ApiResponseWrapper> CreateTransportServiceRateDetailAsync(TransportRateDetailRequestDto request);
        Task<ApiResponseWrapper> CopyTransportRateAsync(TransportRateRequestDto request);
        Task<ApiResponseWrapper> CreateNegotiateTransportServiceRateAsync(CustomHotelRateRequestDto request);
    }
}

using CommonClass;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Transport;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Helpers;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Transport;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Logic.RateCards.Transport
{
    public class UpdateTransportRateLogic : IUpdateRateCardLogic
    {
        private readonly IUpdateTransportRateRepository _updateTransportRateRepository;
        public UpdateTransportRateLogic(IUpdateTransportRateRepository updateTransportRateRepository)
        {
            _updateTransportRateRepository = updateTransportRateRepository;
        }

        public Task<ResponseModel> UpdateRateCancellationPolicyAsync(RequestModel request)
        {
            throw new NotImplementedException();
        }

        public async Task<ResponseModel> UpdateRateCardAsync(RequestModel request)
        {
            TransportRateRequestDto req = CommonHelper.DecryptAndDeserialize<string, TransportRateRequestDto>(request.RequestText);
            var result = await _updateTransportRateRepository.UpdateTransportServiceRateAsync(req);
            return CommonHelper.CreateApiResponse(true, result);
        }

        public async Task<ResponseModel> UpdateRateDetailAsync(RequestModel request)
        {
            TransportRateDetailRequestDto req = CommonHelper.DecryptAndDeserialize<string, TransportRateDetailRequestDto>(request.RequestText);
            var result = await _updateTransportRateRepository.UpdateTransportServiceRateDetailAsync(req);
            return CommonHelper.CreateApiResponse(true, result);
        }

        public Task<ResponseModel> UpdateCustomRateCardAsync(RequestModel request, RateCardType type)
        {
            throw new NotImplementedException();
        }
    }
}

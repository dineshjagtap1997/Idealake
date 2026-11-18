using CommonClass;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Transport;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Helpers;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Transport;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Logic.RateCards.Transport
{
    public class CreateTransportRateLogic : ICreateRateCardLogic
    {
        private readonly ICreateTransportRateRepository _createTransportRateRepository;
        public CreateTransportRateLogic(ICreateTransportRateRepository createTransportRateRepository)
        {
            this._createTransportRateRepository = createTransportRateRepository;
        }

        public Task<ResponseModel> CreateRateCancellationPolicyAsync(RequestModel request)
        {
            throw new NotImplementedException();
        }

        public async Task<ResponseModel> CreateRateCardAsync(RequestModel request)
        {
            TransportRateRequestDto req = CommonHelper.DecryptAndDeserialize<string, TransportRateRequestDto>(request.RequestText);
            var result = await _createTransportRateRepository.CreateTransportServiceRateAsync(req);
            return CommonHelper.CreateApiResponse(true, result);
        }

        public async Task<ResponseModel> CreateRateDetailAsync(RequestModel request)
        {
            TransportRateDetailRequestDto req = CommonHelper.DecryptAndDeserialize<string, TransportRateDetailRequestDto>(request.RequestText);
            var result = await _createTransportRateRepository.CreateTransportServiceRateDetailAsync(req);
            var flag = true;
            if (result.RateCardID == 0)
            {
                flag = false;
            }
            return CommonHelper.CreateApiResponse(flag, result);
        }
        public async Task<ResponseModel> CreateRateCopyAsync(RequestModel request)
        {
            TransportRateRequestDto req = CommonHelper.DecryptAndDeserialize<string, TransportRateRequestDto>(request.RequestText);
            var result = await _createTransportRateRepository.CopyTransportRateAsync(req);
            return CommonHelper.CreateApiResponse(true, result);
        }

        public Task<ResponseModel> CreateCustomRateCardAsync(RequestModel request, RateCardType type)
        {
            throw new NotImplementedException();
        }

        public async Task<ResponseModel> CreateNegotiateRateCardAsync(RequestModel request, RateCardType type)
        {
            CustomHotelRateRequestDto req = CommonHelper.DecryptAndDeserialize<string, CustomHotelRateRequestDto>(request.RequestText);
            var result = await _createTransportRateRepository.CreateNegotiateTransportServiceRateAsync(req);
            return CommonHelper.CreateApiResponse(true, result);
        }
    }
}

using CommonClass;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Monument;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Helpers;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Monument;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Logic.RateCards.Monument
{
    public class CreateMonumentRateLogic : ICreateRateCardLogic
    {
        private readonly ICreateMonumentRateRepository _createMonumentRateRepository;

        public CreateMonumentRateLogic(ICreateMonumentRateRepository createMonumentRateRepository)
        {
            _createMonumentRateRepository = createMonumentRateRepository;
        }

        public Task<ResponseModel> CreateRateCancellationPolicyAsync(RequestModel request)
        {
            throw new NotImplementedException();
        }

        public async Task<ResponseModel> CreateRateCardAsync(RequestModel request)
        {
            MonumentRateRequestDto req = CommonHelper.DecryptAndDeserialize<string, MonumentRateRequestDto>(request.RequestText);
            var result = await _createMonumentRateRepository.CreateMonumentRateAsync(req);
            return CommonHelper.CreateApiResponse(true, result);
        }

        public async Task<ResponseModel> CreateRateDetailAsync(RequestModel request)
        {
            MonumentRateDetailRequestDto req = CommonHelper.DecryptAndDeserialize<string, MonumentRateDetailRequestDto>(request.RequestText);
            var result = await _createMonumentRateRepository.CreateMonumentRateDetailAsync(req);
            var flag = true;
            if (result.RateCardID == 0)
            {
                flag = false;
            }
            return CommonHelper.CreateApiResponse(flag, result);
        }

        public async Task<ResponseModel> CreateRateCopyAsync(RequestModel request)
        {
            MonumentRateRequestDto req = CommonHelper.DecryptAndDeserialize<string, MonumentRateRequestDto>(request.RequestText);
            var result = await _createMonumentRateRepository.CopyMonumentRateAsync(req);
            return CommonHelper.CreateApiResponse(true, result);
        }

        public Task<ResponseModel> CreateCustomRateCardAsync(RequestModel request, RateCardType type)
        {
            throw new NotImplementedException();
        }
        public async Task<ResponseModel> CreateNegotiateRateCardAsync(RequestModel request, RateCardType type)
        {
            CustomHotelRateRequestDto req = CommonHelper.DecryptAndDeserialize<string, CustomHotelRateRequestDto>(request.RequestText);
            var result = await _createMonumentRateRepository.CreateNegotiateMonumentRateAsync(req);
            return CommonHelper.CreateApiResponse(true, result);
        }
    }
}

using CommonClass;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Monument;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Helpers;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Monument;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Logic.RateCards.Monument
{
    public class UpdateMonumentRateLogic : IUpdateRateCardLogic
    {
        private readonly IUpdateMonumentRateRepository _updateMonumentRateRepository;
        public UpdateMonumentRateLogic(IUpdateMonumentRateRepository updateMonumentRateRepository)
        {
            _updateMonumentRateRepository = updateMonumentRateRepository;
        }

        public Task<ResponseModel> UpdateRateCancellationPolicyAsync(RequestModel request)
        {
            throw new NotImplementedException();
        }

        public async Task<ResponseModel> UpdateRateCardAsync(RequestModel request)
        {
            MonumentRateRequestDto req = CommonHelper.DecryptAndDeserialize<string, MonumentRateRequestDto>(request.RequestText);
            var result = await _updateMonumentRateRepository.UpdateMonumentRateAsync(req);
            return CommonHelper.CreateApiResponse(true, result);
        }

        public async Task<ResponseModel> UpdateRateDetailAsync(RequestModel request)
        {
            MonumentRateDetailRequestDto req = CommonHelper.DecryptAndDeserialize<string, MonumentRateDetailRequestDto>(request.RequestText);
            var result = await _updateMonumentRateRepository.UpdateMonumentRateDetailAsync(req);
            return CommonHelper.CreateApiResponse(true, result);
        }

        public Task<ResponseModel> UpdateCustomRateCardAsync(RequestModel request, RateCardType type)
        {
            throw new NotImplementedException();
        }
    }
}

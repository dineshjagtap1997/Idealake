using CommonClass;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Guide;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Helpers;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Guide;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Logic.RateCards.Guide
{
    public class UpdateGuideRateCardLogic : IUpdateRateCardLogic
    {
        private readonly IUpdateGuideRateRepository _updateGuideRateRepository;
        public UpdateGuideRateCardLogic(IUpdateGuideRateRepository updateGuideRateRepository)
        {
            _updateGuideRateRepository = updateGuideRateRepository;
        }

        public Task<ResponseModel> UpdateRateCancellationPolicyAsync(RequestModel request)
        {
            throw new NotImplementedException();
        }

        public async Task<ResponseModel> UpdateRateCardAsync(RequestModel request)
        {
            GuideRateRequestDto req = CommonHelper.DecryptAndDeserialize<string, GuideRateRequestDto>(request.RequestText);
            var result = await _updateGuideRateRepository.UpdateGuideRateAsync(req);
            return CommonHelper.CreateApiResponse(true, result);
        }

        public async Task<ResponseModel> UpdateRateDetailAsync(RequestModel request)
        {
            GuideRateDetailRequestDto req = CommonHelper.DecryptAndDeserialize<string, GuideRateDetailRequestDto>(request.RequestText);
            var result = await _updateGuideRateRepository.UpdateGuideRateDetailAsync(req);
            return CommonHelper.CreateApiResponse(true, result);
        }

        public Task<ResponseModel> UpdateCustomRateCardAsync(RequestModel request, RateCardType type)
        {
            throw new NotImplementedException();
        }
    }
}

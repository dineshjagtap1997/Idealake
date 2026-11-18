using CommonClass;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.MOT;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Helpers;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.MOT;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Logic.RateCards.MOT
{
    public class UpdateMOTRateCardLogic : IUpdateRateCardLogic
    {
        private readonly IUpdateMOTRateRepository _updateMOTRateRepository;

        public UpdateMOTRateCardLogic(IUpdateMOTRateRepository updateMOTRateRepository)
        {
            _updateMOTRateRepository = updateMOTRateRepository;
        }

        public Task<ResponseModel> UpdateRateCancellationPolicyAsync(RequestModel request)
        {
            throw new NotImplementedException();
        }

        public async Task<ResponseModel> UpdateRateCardAsync(RequestModel request)
        {
            UpdateMOTRateRequestDto req = CommonHelper.DecryptAndDeserialize<string, UpdateMOTRateRequestDto>(request.RequestText);
            var result = await _updateMOTRateRepository.UpdateMOTRateAsync(req);
            return CommonHelper.CreateApiResponse(true, result);
        }

        public async Task<ResponseModel> UpdateRateDetailAsync(RequestModel request)
        {
            UpdateMOTRateDetailRequestDto req = CommonHelper.DecryptAndDeserialize<string, UpdateMOTRateDetailRequestDto>(request.RequestText);
            var result = await _updateMOTRateRepository.UpdateMOTRateDetailAsync(req);
            return CommonHelper.CreateApiResponse(true, result);
        }

        public Task<ResponseModel> UpdateCustomRateCardAsync(RequestModel request, RateCardType type)
        {
            throw new NotImplementedException();
        }
    }
}

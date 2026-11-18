using CommonClass;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.SpecialService;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Helpers;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.SpecialService;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Logic.RateCards.SpecialService
{
    public class UpdateSpecialServiceRateLogic : IUpdateRateCardLogic
    {
        private readonly IUpdateSpecialServiceRateRepository _updateSpecialServiceRateRepository;
        public UpdateSpecialServiceRateLogic(IUpdateSpecialServiceRateRepository updateSpecialServiceRateRepository)
        {
            _updateSpecialServiceRateRepository = updateSpecialServiceRateRepository;
        }

        public Task<ResponseModel> UpdateRateCancellationPolicyAsync(RequestModel request)
        {
            throw new NotImplementedException();
        }

        public async Task<ResponseModel> UpdateRateCardAsync(RequestModel request)
        {
            SpecialServiceRateRequestDto req = CommonHelper.DecryptAndDeserialize<string, SpecialServiceRateRequestDto>(request.RequestText);
            var result = await _updateSpecialServiceRateRepository.UpdateSpecialServiceRateAsync(req);
            return CommonHelper.CreateApiResponse(true, result);
        }

        public async Task<ResponseModel> UpdateRateDetailAsync(RequestModel request)
        {
            SpecialServiceDetailRequestDto req = CommonHelper.DecryptAndDeserialize<string, SpecialServiceDetailRequestDto>(request.RequestText);
            var result = await _updateSpecialServiceRateRepository.UpdateSpecialServiceRateDetailAsync(req);
            return CommonHelper.CreateApiResponse(true, result);
        }

        public Task<ResponseModel> UpdateCustomRateCardAsync(RequestModel request, RateCardType type)
        {
            throw new NotImplementedException();
        }
    }
}

using CommonClass;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Guide;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Helpers;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Guide;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Logic.RateCards.Guide
{
    public class CreateGuideRateCardLogic : ICreateRateCardLogic
    {
        private readonly ICreateGuideRateRepository _createGuideRateRepository;
        public CreateGuideRateCardLogic(ICreateGuideRateRepository createGuideRateRepository) {
            _createGuideRateRepository = createGuideRateRepository;
        }

        public Task<ResponseModel> CreateRateCancellationPolicyAsync(RequestModel request)
        {
            throw new NotImplementedException();
        }

        public async Task<ResponseModel> CreateRateCardAsync(RequestModel request)
        {
            GuideRateRequestDto req = CommonHelper.DecryptAndDeserialize<string, GuideRateRequestDto>(request.RequestText);
            var result =  await _createGuideRateRepository.CreateGuideRateAsync(req);
            return CommonHelper.CreateApiResponse(true, result);
        }
        public async Task<ResponseModel> CreateRateDetailAsync(RequestModel request)
        {
            GuideRateDetailRequestDto req = CommonHelper.DecryptAndDeserialize<string, GuideRateDetailRequestDto>(request.RequestText);
            var result = await _createGuideRateRepository.CreateGuideRateDetailAsync(req);
            return CommonHelper.CreateApiResponse(true, result);
        }

        public async Task<ResponseModel> CreateRateCopyAsync(RequestModel request)
        {
            GuideRateRequestDto req = CommonHelper.DecryptAndDeserialize<string, GuideRateRequestDto>(request.RequestText);
            var result = await _createGuideRateRepository.CopyGuideRateAsync(req);
            return CommonHelper.CreateApiResponse(true, result);
        }

        public Task<ResponseModel> CreateCustomRateCardAsync(RequestModel request,RateCardType type)
        {
            throw new NotImplementedException();
        }

        public async Task<ResponseModel> CreateNegotiateRateCardAsync(RequestModel request, RateCardType type)
        {
            CustomHotelRateRequestDto req = CommonHelper.DecryptAndDeserialize<string, CustomHotelRateRequestDto>(request.RequestText);
            var result = await _createGuideRateRepository.CreateNegotiateGuideRateAsync(req);
            return CommonHelper.CreateApiResponse(true, result);
        }
    }
}

using CommonClass;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.SpecialService;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Helpers;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.SpecialService;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Logic.RateCards.SpecialService
{
    public class CreateSpecialServiceRateLogic : ICreateRateCardLogic
    {
        private readonly ICreateSpecialServiceRateRepository _createSpecialServiceRateRepository;
        public CreateSpecialServiceRateLogic(ICreateSpecialServiceRateRepository createSpecialServiceRateRepository)
        {
            _createSpecialServiceRateRepository = createSpecialServiceRateRepository;
        }

        public Task<ResponseModel> CreateRateCancellationPolicyAsync(RequestModel request)
        {
            throw new NotImplementedException();
        }

        public async Task<ResponseModel> CreateRateCardAsync(RequestModel request)
        {
            SpecialServiceRateRequestDto req = CommonHelper.DecryptAndDeserialize<string, SpecialServiceRateRequestDto>(request.RequestText);
            var result = await _createSpecialServiceRateRepository.CreateSpecialServiceRateAsync(req);
            return CommonHelper.CreateApiResponse(true, result);
        }

        public async Task<ResponseModel> CreateRateDetailAsync(RequestModel request)
        {
            SpecialServiceDetailRequestDto req = CommonHelper.DecryptAndDeserialize<string, SpecialServiceDetailRequestDto>(request.RequestText);
            var result = await _createSpecialServiceRateRepository.CreateSpecialServiceRateDetailAsync(req);
            var flag = true;
            if (result.RateCardID == 0)
            {
                flag = false;
            }
            return CommonHelper.CreateApiResponse(flag, result);
        }
        public async Task<ResponseModel> CreateRateCopyAsync(RequestModel request)
        {
            SpecialServiceRateRequestDto req = CommonHelper.DecryptAndDeserialize<string, SpecialServiceRateRequestDto>(request.RequestText);
            var result = await _createSpecialServiceRateRepository.CopySpecialServiceRateAsync(req);
            return CommonHelper.CreateApiResponse(true, result);
        }

        public Task<ResponseModel> CreateCustomRateCardAsync(RequestModel request, RateCardType type)
        {
            throw new NotImplementedException();
        }

        public async Task<ResponseModel> CreateNegotiateRateCardAsync(RequestModel request, RateCardType type)
        {
            CustomHotelRateRequestDto req = CommonHelper.DecryptAndDeserialize<string, CustomHotelRateRequestDto>(request.RequestText);
            var result = await _createSpecialServiceRateRepository.CreateNegotiateSpecialServiceRateAsync(req);
            return CommonHelper.CreateApiResponse(true, result);
        }
    }
}

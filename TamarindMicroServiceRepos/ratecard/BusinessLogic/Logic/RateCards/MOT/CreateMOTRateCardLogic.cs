using CommonClass;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.MOT;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Helpers;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.MOT;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Logic.RateCards.MOT
{
    public class CreateMOTRateCardLogic : ICreateRateCardLogic
    {
        private readonly ICreateMOTRateRepository _createMOTRateRepository;
        public CreateMOTRateCardLogic(ICreateMOTRateRepository createMOTRateRepository)
        {
            _createMOTRateRepository = createMOTRateRepository;
        }

        public Task<ResponseModel> CreateRateCancellationPolicyAsync(RequestModel request)
        {
            throw new NotImplementedException();
        }

        public async Task<ResponseModel> CreateRateCardAsync(RequestModel request)
        {
            CreateMOTRateRequestDto req = CommonHelper.DecryptAndDeserialize<string, CreateMOTRateRequestDto>(request.RequestText);
            var result = await _createMOTRateRepository.CreateMOTRateAsync(req);
            return CommonHelper.CreateApiResponse(true, result);
        }

        public async Task<ResponseModel> CreateRateDetailAsync(RequestModel request)
        {
            CreateMOTRateDetailRequestDto req = CommonHelper.DecryptAndDeserialize<string, CreateMOTRateDetailRequestDto>(request.RequestText);
            var result = await _createMOTRateRepository.CreateMOTRateDetailAsync(req);
            return CommonHelper.CreateApiResponse(true, result);
        }

        public Task<ResponseModel> CreateRateCopyAsync(RequestModel request)
        {
            throw new NotImplementedException();
        }

        public Task<ResponseModel> CreateCustomRateCardAsync(RequestModel request, RateCardType type)
        {
            throw new NotImplementedException();
        }

        public async Task<ResponseModel> CreateNegotiateRateCardAsync(RequestModel request, RateCardType type)
        {
            CustomHotelRateRequestDto req = CommonHelper.DecryptAndDeserialize<string, CustomHotelRateRequestDto>(request.RequestText);
            var result = await _createMOTRateRepository.CreateNegotiateMOTRateAsync(req);
            return CommonHelper.CreateApiResponse(true, result);
        }
    }
}

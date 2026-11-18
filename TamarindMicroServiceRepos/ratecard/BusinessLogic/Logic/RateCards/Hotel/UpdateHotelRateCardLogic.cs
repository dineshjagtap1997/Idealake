using CommonClass;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel.CancellationPolicy;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Helpers;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Hotel;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Hotel.CancellationPolicy;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Logic.RateCards.Hotel
{
    public class UpdateHotelRateCardLogic : IUpdateRateCardLogic
    {
        private readonly IUpdateHotelRateRepository _updateHotelRateRepository;
        private readonly IUpdateHotelRatePolicyRepository _updateHotelRatePolicyRepository;
        public UpdateHotelRateCardLogic(IUpdateHotelRateRepository updateHotelRateRepository,
            IUpdateHotelRatePolicyRepository updateHotelRatePolicyRepository)
        {
            _updateHotelRateRepository = updateHotelRateRepository;
            _updateHotelRatePolicyRepository = updateHotelRatePolicyRepository;
        }

        public async Task<ResponseModel> UpdateRateCancellationPolicyAsync(RequestModel request)
        {
            HotelRateCancellationPolicyDto req = CommonHelper.DecryptAndDeserialize<string, HotelRateCancellationPolicyDto>(request.RequestText);
            var result = await _updateHotelRatePolicyRepository.UpdateHotelRatePolicy(req);
            return CommonHelper.CreateApiResponse(true, result);
        }

        public async Task<ResponseModel> UpdateRateCardAsync(RequestModel request)
        {
            HotelRateRequestDto req = CommonHelper.DecryptAndDeserialize<string, HotelRateRequestDto>(request.RequestText);
            var result = await _updateHotelRateRepository.UpdateHotelRateCardAsync(req);
            return CommonHelper.CreateApiResponse(true, result);
        }

        public async Task<ResponseModel> UpdateRateDetailAsync(RequestModel request)
        {
            HotelRateDetailRequestDto req = CommonHelper.DecryptAndDeserialize<string, HotelRateDetailRequestDto>(request.RequestText);
            var result = await _updateHotelRateRepository.UpdateHotelRateDetailAsync(req);
            return CommonHelper.CreateApiResponse(true, result);
        }

        public async Task<ResponseModel> UpdateCustomRateCardAsync(RequestModel request,RateCardType type)
        {
            CustomHotelRateRequestDto req = CommonHelper.DecryptAndDeserialize<string, CustomHotelRateRequestDto>(request.RequestText);
            var result = await _updateHotelRateRepository.UpdateCustomHotelRateCardAsync(req,type);
            return CommonHelper.CreateApiResponse(true, result);
        }
    }
}

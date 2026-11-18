using CommonClass;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.HotelOffer;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Helpers;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.HotelOffer;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Logic.RateCards.HotelOffer
{
    public class UpdateHotelOfferRateLogic : IUpdateRateCardLogic
    {
        private readonly IUpdateHotelOfferRateRepository _updateHotelOfferRateRepository;
        public UpdateHotelOfferRateLogic(IUpdateHotelOfferRateRepository updateHotelOfferRateRepository)
        {
            _updateHotelOfferRateRepository = updateHotelOfferRateRepository;
        }
        public Task<ResponseModel> UpdateRateCancellationPolicyAsync(RequestModel request)
        {
            throw new NotImplementedException();
        }

        public async Task<ResponseModel> UpdateRateCardAsync(RequestModel request)
        {
            HotelOfferRequestDto hotelOfferRequest = CommonHelper.DecryptAndDeserialize<string, HotelOfferRequestDto>(request.RequestText);
           var response = await _updateHotelOfferRateRepository.UpdateHotelOfferAsync(hotelOfferRequest);
           return CommonHelper.CreateApiResponse(true, response);
        }

        public Task<ResponseModel> UpdateRateDetailAsync(RequestModel request)
        {
            throw new NotImplementedException();
        }

        public Task<ResponseModel> UpdateCustomRateCardAsync(RequestModel request, RateCardType type)
        {
            throw new NotImplementedException();
        }
    }
}

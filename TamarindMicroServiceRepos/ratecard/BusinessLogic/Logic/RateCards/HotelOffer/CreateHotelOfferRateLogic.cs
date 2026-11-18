using CommonClass;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.HotelOffer;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Helpers;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.HotelOffer;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Logic.RateCards.HotelOffer
{
    public class CreateHotelOfferRateLogic : ICreateRateCardLogic
    {
        private readonly ICreateHotelOfferRateRepository _createHotelOfferRateRepository;
        public CreateHotelOfferRateLogic(ICreateHotelOfferRateRepository createHotelOfferRateRepository)
        {
            _createHotelOfferRateRepository = createHotelOfferRateRepository;
        }
        public Task<ResponseModel> CreateRateCancellationPolicyAsync(RequestModel request)
        {
            throw new NotImplementedException();
        }

        public async Task<ResponseModel> CreateRateCardAsync(RequestModel request)
        {
            HotelOfferRequestDto hotelOfferRequest = CommonHelper.DecryptAndDeserialize<string, HotelOfferRequestDto>(request.RequestText);
            var response = await _createHotelOfferRateRepository.CreateHotelOfferAsync(hotelOfferRequest);
            return CommonHelper.CreateApiResponse(true, response);
        }

        public Task<ResponseModel> CreateRateDetailAsync(RequestModel request)
        {
            throw new NotImplementedException();
        }
        public Task<ResponseModel> CreateRateCopyAsync(RequestModel request)
        {
            throw new NotImplementedException();
        }
        public Task<ResponseModel> CreateCustomRateCardAsync(RequestModel request, RateCardType type)
        {
            throw new NotImplementedException();
        }

        public Task<ResponseModel> CreateNegotiateRateCardAsync(RequestModel request, RateCardType type)
        {
            throw new NotImplementedException();
        }
    }
}

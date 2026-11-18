using CommonClass;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.HotelOffer;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Monument;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Helpers;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.HotelOffer;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Logic.RateCards.HotelOffer
{
    public class GetHotelOfferRateLogic : IGetRateCardLogic
    {
        private readonly IGetHotelOfferRateRepository _getHotelOfferRateRepository;
        public GetHotelOfferRateLogic(IGetHotelOfferRateRepository getHotelOfferRateRepository)
        {
            _getHotelOfferRateRepository = getHotelOfferRateRepository;
        }
        public Task<ResponseModel> GetAllRateCancellationPolicyAsync(RequestModel request)
        {
            throw new NotImplementedException();
        }

        public async Task<ResponseModel> GetAllRateCardsAsync(RequestModel request)
        {
            HotelOfferRequestDto filter = CommonHelper.DecryptAndDeserialize<string, HotelOfferRequestDto>(request.RequestText);
            var response = await _getHotelOfferRateRepository.GetAllHotelOffersAsync(filter);
            return CommonHelper.CreateApiResponse(response);

        }

        public Task<ResponseModel> GetAllRateDetailsByIDAsync(long id, int pageNumber, int pageSize)
        {
            throw new NotImplementedException();
        }

        public Task<ResponseModel> GetRateCancellationPolicyByIDAsync(RequestModel request)
        {
            throw new NotImplementedException();
        }

        public async Task<ResponseModel> GetRateCardByIDAsync(long id)
        {
            var result = await _getHotelOfferRateRepository.GetHotelOfferByIDAsync(id);
            return CommonHelper.CreateApiResponse(result);
        }

        public async Task<ResponseModel> GetRateCardDocumentsAsync(RequestModel request)
        {
            UploadDocumentRequestDto filter = CommonHelper.DecryptAndDeserialize<string, UploadDocumentRequestDto>(request.RequestText);
            var result = await _getHotelOfferRateRepository.GetHotelOfferRateDocumentsAsync(filter);
            return CommonHelper.CreateApiResponse(result);
        }

        public Task<ResponseModel> GetRateCardHeadingsAsync(RequestModel request)
        {
            throw new NotImplementedException();
        }

        public Task<ResponseModel> GetRateCardNumbersAsync(RequestModel request)
        {
            throw new NotImplementedException();
        }

        public Task<ResponseModel> GetRateCardServicesAsync(RequestModel request)
        {
            throw new NotImplementedException();
        }

        public Task<ResponseModel> GetRateDetailByIDAsync(long id)
        {
            throw new NotImplementedException();
        }

        public async Task<ResponseModel> GetAllRateSearchReportCardsAsync(RequestModel request)
        {
            HotelOfferSearchRequestDto req = CommonHelper.DecryptAndDeserialize<string, HotelOfferSearchRequestDto>(request.RequestText);

            var result = await _getHotelOfferRateRepository.GetAllHotelOfferRateCardReportAsync(req);

            return CommonHelper.CreateApiResponse(result);
        }

        public Task<ResponseModel> GetAllCustomRateCardsAsync(RequestModel request)
        {
            throw new NotImplementedException();
        }

        public Task<ResponseModel> GetCustomRateCardByIDAsync(long id, RateCardType type)
        {
            throw new NotImplementedException();
        }
    }
}

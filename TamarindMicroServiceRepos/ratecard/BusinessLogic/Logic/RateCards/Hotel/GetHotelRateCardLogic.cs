using CommonClass;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel.CancellationPolicy;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Helpers;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Hotel;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Hotel.CancellationPolicy;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Logic.RateCards.Hotel
{
    public class GetHotelRateCardLogic : IGetRateCardLogic
    {
        private readonly IGetHotelRateCardRepository _getHotelRateCardRepository;
        private readonly IGetHotelRatePolicyRepository _getHotelRatePolicyRepository;
        public GetHotelRateCardLogic(IGetHotelRateCardRepository getHotelRateCardRepository,
            IGetHotelRatePolicyRepository getHotelRatePolicyRepository) {
            _getHotelRateCardRepository = getHotelRateCardRepository;
            _getHotelRatePolicyRepository = getHotelRatePolicyRepository;
        }

        public async Task<ResponseModel> GetAllRateCancellationPolicyAsync(RequestModel request)
        {
            HotelRateCancellationPolicyDto filter = CommonHelper.DecryptAndDeserialize<string, HotelRateCancellationPolicyDto>(request.RequestText);
            var response = await _getHotelRatePolicyRepository.GetAllHotelRateCancellationPolicyAsync(filter);
            return CommonHelper.CreateApiResponse(response);
        }

        public async Task<ResponseModel> GetAllRateCardsAsync(RequestModel request)
        {
            HotelRateRequestDto filter = CommonHelper.DecryptAndDeserialize<string, HotelRateRequestDto>(request.RequestText);
            var response = await _getHotelRateCardRepository.GetAllHotelRateCardsAsync(filter);
            return CommonHelper.CreateApiResponse(response);
        }

        public async Task<ResponseModel> GetAllCustomRateCardsAsync(RequestModel request)
        {
            CustomHotelRateRequestDto filter = CommonHelper.DecryptAndDeserialize<string, CustomHotelRateRequestDto>(request.RequestText);
            var response = await _getHotelRateCardRepository.GetAllCustomHotelRateCardsAsync(filter);
            return CommonHelper.CreateApiResponse(response);
        }

        public async Task<ResponseModel> GetAllRateDetailsByIDAsync(long id, int pageNumber, int pageSize)
        {
            var response = await _getHotelRateCardRepository.GetAllHotelRateDetailsByIdAsync(id, pageNumber, pageSize);
            return CommonHelper.CreateApiResponse(response);
        }

        public async Task<ResponseModel> GetRateCancellationPolicyByIDAsync(RequestModel request)
        {
            HotelRateCancellationPolicyDto filter = CommonHelper.DecryptAndDeserialize<string, HotelRateCancellationPolicyDto>(request.RequestText);
            var response = await _getHotelRatePolicyRepository.GetHotelRateCancellationPolicyAsync(filter);
            IEnumerable<HotelRateCancellationPolicyDto> responseList = [response];
            return CommonHelper.CreateApiResponse(responseList);
        }

        public async Task<ResponseModel> GetRateCardByIDAsync(long id)
        {
            var response = await _getHotelRateCardRepository.GetHotelRateCardByIDAsync(id);
            return CommonHelper.CreateApiResponse(response);
        }

        public async Task<ResponseModel> GetCustomRateCardByIDAsync(long id, RateCardType type)
        {
            var response = await _getHotelRateCardRepository.GetCustomHotelRateCardByIDAsync(id,type);
            return CommonHelper.CreateApiResponse(response);
        }

        public async Task<ResponseModel> GetRateCardDocumentsAsync(RequestModel request)
        {
            UploadDocumentRequestDto filter = CommonHelper.DecryptAndDeserialize<string, UploadDocumentRequestDto>(request.RequestText);
            var response = await _getHotelRateCardRepository.GetHotelRateDocumentsAsync(filter);
            return CommonHelper.CreateApiResponse(response);
        }

        public async Task<ResponseModel> GetRateCardHeadingsAsync(RequestModel request)
        {
            HotelRateRequestDto filter = CommonHelper.DecryptAndDeserialize<string, HotelRateRequestDto>(request.RequestText);
            var result = await _getHotelRateCardRepository.GetRateCardHeadingsAsync(filter);
            return CommonHelper.CreateApiResponse(result);
        }

        public async Task<ResponseModel> GetRateCardNumbersAsync(RequestModel request)
        {
            HotelRateRequestDto filter = CommonHelper.DecryptAndDeserialize<string, HotelRateRequestDto>(request.RequestText);
            var result = await _getHotelRateCardRepository.GetRateCardNumberAsync(filter);
            return CommonHelper.CreateApiResponse(result);
        }

        public async Task<ResponseModel> GetRateCardServicesAsync(RequestModel request)
        {
            HotelRateRequestDto filter = CommonHelper.DecryptAndDeserialize<string, HotelRateRequestDto>(request.RequestText);
            var response = await _getHotelRateCardRepository.GetRateCardHotelServicesAsync(filter);
            return CommonHelper.CreateApiResponse(response);
        }

        public async Task<ResponseModel> GetRateDetailByIDAsync(long id)
        {
            var response = await _getHotelRateCardRepository.GetHotelRateDetailsByIDAsync(id);
            return CommonHelper.CreateApiResponse(response);
        }

        //public async Task<ResponseModel> GetAllRateSearchReportCardsAsync(RequestModel request)
        //{
        //    throw new NotImplementedException();
        //}

        public async Task<ResponseModel> GetAllRateSearchReportCardsAsync(RequestModel req)

        {

            HotelRateSearchInputDto res = CommonHelper.DecryptAndDeserialize<string, HotelRateSearchInputDto>(req.RequestText);

            var result = await _getHotelRateCardRepository.GetRateCardHotelSearchServicesAsync(res);

            return CommonHelper.CreateApiResponse(result);

        }
    }
}

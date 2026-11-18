using CommonClass;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Guide;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Helpers;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Guide;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Logic.RateCards.Guide
{
    public class GetGuideRateCardLogic : IGetRateCardLogic
    {
        private readonly IGetGuideRateRepository _getGuideRateRepository;
        public GetGuideRateCardLogic(IGetGuideRateRepository getGuideRateRepository)
        {
            _getGuideRateRepository = getGuideRateRepository;
        }

        public Task<ResponseModel> GetAllRateCancellationPolicyAsync(RequestModel request)
        {
            throw new NotImplementedException();
        }

        public async Task<ResponseModel> GetAllRateCardsAsync(RequestModel request)
        {
            GuideRateRequestDto filter = CommonHelper.DecryptAndDeserialize<string, GuideRateRequestDto>(request.RequestText);
            var result = await _getGuideRateRepository.GetAllGuideRateAsync(filter);
            return CommonHelper.CreateApiResponse(result);
        }

        public async Task<ResponseModel> GetRateCardNumbersAsync(RequestModel request)
        {
            GuideRateRequestDto filter = CommonHelper.DecryptAndDeserialize<string, GuideRateRequestDto>(request.RequestText);
            var result = await _getGuideRateRepository.GetRateCardNumberAsync(filter);
            return CommonHelper.CreateApiResponse(result);
        }

        public async Task<ResponseModel> GetRateCardHeadingsAsync(RequestModel request)
        {
            GuideRateRequestDto filter = CommonHelper.DecryptAndDeserialize<string, GuideRateRequestDto>(request.RequestText);
            var result = await _getGuideRateRepository.GetRateCardHeadingsAsync(filter);
            return CommonHelper.CreateApiResponse(result);
        }

        public async Task<ResponseModel> GetRateCardServiceAsync(RequestModel request)
        {
            GuideRateRequestDto filter = CommonHelper.DecryptAndDeserialize<string, GuideRateRequestDto>(request.RequestText);
            var result = await _getGuideRateRepository.GetRateCardGuideServicesAsync(filter);
            return CommonHelper.CreateApiResponse(result);
        }

        public async Task<ResponseModel> GetAllRateDetailsByIDAsync(long id, int pageNumber, int pageSize)
        {
            var result = await _getGuideRateRepository.GetAllGuideRateDetailsByIdAsync(id,pageNumber,pageSize);
            return CommonHelper.CreateApiResponse(result);
        }

        public Task<ResponseModel> GetRateCancellationPolicyByIDAsync(RequestModel request)
        {
            throw new NotImplementedException();
        }

        public async Task<ResponseModel> GetRateCardByIDAsync(long id)
        {
            var result = await _getGuideRateRepository.GetGuideRateByIdAsync(id);
            return CommonHelper.CreateApiResponse(result);
        }

        public async Task<ResponseModel> GetRateCardDocumentsAsync(RequestModel request)
        {
            UploadDocumentRequestDto filter = CommonHelper.DecryptAndDeserialize<string, UploadDocumentRequestDto>(request.RequestText);
            var result = await _getGuideRateRepository.GetGuideRateDocumentsAsync(filter);
            return CommonHelper.CreateApiResponse(result);
        }

        public async Task<ResponseModel> GetRateDetailByIDAsync(long id)
        {
            var result = await _getGuideRateRepository.GetGuideRateDetailsByIdAsync(id);
            return CommonHelper.CreateApiResponse(result);
        }

        public async Task<ResponseModel> GetRateCardServicesAsync(RequestModel request)
        {
            GuideRateRequestDto filter = CommonHelper.DecryptAndDeserialize<string, GuideRateRequestDto>(request.RequestText);
            var response = await _getGuideRateRepository.GetRateCardGuideServicesAsync(filter);
            return CommonHelper.CreateApiResponse(response);
        }

        public async Task<ResponseModel> GetAllRateSearchReportCardsAsync(RequestModel request)
        {
            GetGuideRateSearchRequestDto filter = CommonHelper.DecryptAndDeserialize<string, GetGuideRateSearchRequestDto>(request.RequestText);
            var result = await _getGuideRateRepository.GetAllGuideRateCardReportAsync(filter);
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

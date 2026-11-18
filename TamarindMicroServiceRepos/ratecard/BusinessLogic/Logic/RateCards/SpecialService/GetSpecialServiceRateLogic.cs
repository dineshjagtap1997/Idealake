using CommonClass;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.SpecialService;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Helpers;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.SpecialService;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Logic.RateCards.SpecialService
{
    public class GetSpecialServiceRateLogic : IGetRateCardLogic
    {
        private readonly IGetSpecialServiceRateRepository _getSpecialServiceRateRepository;
        public GetSpecialServiceRateLogic(IGetSpecialServiceRateRepository getSpecialServiceRateRepository)
        {
            _getSpecialServiceRateRepository = getSpecialServiceRateRepository;
        }

        public Task<ResponseModel> GetAllRateCancellationPolicyAsync(RequestModel request)
        {
            throw new NotImplementedException();
        }

        public async Task<ResponseModel> GetAllRateCardsAsync(RequestModel request)
        {
            SpecialServiceRateRequestDto req = CommonHelper.DecryptAndDeserialize<string, SpecialServiceRateRequestDto>(request.RequestText);
            var result = await _getSpecialServiceRateRepository.GetAllSpecialServiceRateAsync(req);
            return CommonHelper.CreateApiResponse(result);
        }

        public async Task<ResponseModel> GetAllRateDetailsByIDAsync(long id, int pageNumber, int pageSize)
        {
            var result = await _getSpecialServiceRateRepository.GetAllSpecialServiceRateDetailsByIdAsync(id, pageNumber, pageSize);
            return CommonHelper.CreateApiResponse(result);
        }

        public Task<ResponseModel> GetRateCancellationPolicyByIDAsync(RequestModel request)
        {
            throw new NotImplementedException();
        }

        public async Task<ResponseModel> GetRateCardByIDAsync(long id)
        {
            var result = await _getSpecialServiceRateRepository.GetSpecialServiceRateByIdAsync(id);
            return CommonHelper.CreateApiResponse(result);
        }

        public async Task<ResponseModel> GetRateCardDocumentsAsync(RequestModel request)
        {
            UploadDocumentRequestDto filter = CommonHelper.DecryptAndDeserialize<string, UploadDocumentRequestDto>(request.RequestText);
            var result = await _getSpecialServiceRateRepository.GetSpecialServiceRateDocumentsAsync(filter);
            return CommonHelper.CreateApiResponse(result);
        }

        public async Task<ResponseModel> GetRateCardHeadingsAsync(RequestModel request)
        {
            SpecialServiceRateRequestDto filter = CommonHelper.DecryptAndDeserialize<string, SpecialServiceRateRequestDto>(request.RequestText);
            var result = await _getSpecialServiceRateRepository.GetRateCardHeadingsAsync(filter);
            return CommonHelper.CreateApiResponse(result);
        }

        public async Task<ResponseModel> GetRateCardNumbersAsync(RequestModel request)
        {
            SpecialServiceRateRequestDto filter = CommonHelper.DecryptAndDeserialize<string, SpecialServiceRateRequestDto>(request.RequestText);
            var result = await _getSpecialServiceRateRepository.GetRateCardNumberAsync(filter);
            return CommonHelper.CreateApiResponse(result);
        }

        public async Task<ResponseModel> GetRateCardServicesAsync(RequestModel request)
        {
            SpecialServiceRateRequestDto filter = CommonHelper.DecryptAndDeserialize<string, SpecialServiceRateRequestDto>(request.RequestText);
            var response = await _getSpecialServiceRateRepository.GetRateCardSpecialServicesAsync(filter);
            return CommonHelper.CreateApiResponse(response);
        }

        public async Task<ResponseModel> GetRateDetailByIDAsync(long id)
        {
            var result = await _getSpecialServiceRateRepository.GetSpecialServiceRateDetailByIdAsync(id);
            return CommonHelper.CreateApiResponse(result);
        }

        //public async Task<ResponseModel> GetAllRateSearchReportCardsAsync(RequestModel request)
        //{
        //    GetSpecialServiceSearchRequestDto req = CommonHelper.DecryptAndDeserialize<string, GetSpecialServiceSearchRequestDto>(request.RequestText);
        //    var result = await _getSpecialServiceRateRepository.GetAllSpecialServiceRateSearchReportAsync(req);
        //    return CommonHelper.CreateApiResponse(result);
        //}

        public async Task<ResponseModel> GetAllRateSearchReportCardsAsync(RequestModel request)
        {
            GetSpecialServiceSearchRequestDto req = CommonHelper.DecryptAndDeserialize<string, GetSpecialServiceSearchRequestDto>(request.RequestText);
            var result = await _getSpecialServiceRateRepository.GetAllSpecialServiceRateSearchReportAsync(req);
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

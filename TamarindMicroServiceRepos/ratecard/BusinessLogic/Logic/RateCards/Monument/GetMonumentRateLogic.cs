using CommonClass;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Monument;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.MOT;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Helpers;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Monument;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Logic.RateCards.Monument
{
    public class GetMonumentRateLogic : IGetRateCardLogic
    {
        private readonly IGetMonumentRateRepository _getMonumentRateRepository;
        public GetMonumentRateLogic(IGetMonumentRateRepository getMonumentRateRepository)
        {
            _getMonumentRateRepository = getMonumentRateRepository;
        }

        public Task<ResponseModel> GetAllRateCancellationPolicyAsync(RequestModel request)
        {
            throw new NotImplementedException();
        }

        public async Task<ResponseModel> GetAllRateCardsAsync(RequestModel request)
        {
            MonumentRateRequestDto req = CommonHelper.DecryptAndDeserialize<string, MonumentRateRequestDto>(request.RequestText);
            var result = await _getMonumentRateRepository.GetAllMonumentRateAsync(req);
            return CommonHelper.CreateApiResponse(result);
        }

        public async Task<ResponseModel> GetAllRateDetailsByIDAsync(long id, int pageNumber, int pageSize)
        {
            var result = await _getMonumentRateRepository.GetAllMonumentRateDetailsByIdAsync(id, pageNumber, pageSize);
            return CommonHelper.CreateApiResponse(result);
        }

        public Task<ResponseModel> GetRateCancellationPolicyByIDAsync(RequestModel request)
        {
            throw new NotImplementedException();
        }

        public async Task<ResponseModel> GetRateCardByIDAsync(long id)
        {
            var result = await _getMonumentRateRepository.GetMonumentRateByIdAsync(id);
            IEnumerable<GetMonumentRateResponseDto> resultList = [result];
            return CommonHelper.CreateApiResponse(resultList);
        }

        public async Task<ResponseModel> GetRateCardDocumentsAsync(RequestModel request)
        {
            UploadDocumentRequestDto filter = CommonHelper.DecryptAndDeserialize<string, UploadDocumentRequestDto>(request.RequestText);
            var result = await _getMonumentRateRepository.GetMonumentRateDocumentsAsync(filter);
            return CommonHelper.CreateApiResponse(result);
        }

        public async Task<ResponseModel> GetRateCardHeadingsAsync(RequestModel request)
        {
            MonumentRateRequestDto filter = CommonHelper.DecryptAndDeserialize<string, MonumentRateRequestDto>(request.RequestText);
            var result = await _getMonumentRateRepository.GetRateCardHeadingsAsync(filter);
            return CommonHelper.CreateApiResponse(result);
        }

        public async Task<ResponseModel> GetRateCardNumbersAsync(RequestModel request)
        {
            MonumentRateRequestDto filter = CommonHelper.DecryptAndDeserialize<string, MonumentRateRequestDto>(request.RequestText);
            var result = await _getMonumentRateRepository.GetRateCardNumberAsync(filter);
            return CommonHelper.CreateApiResponse(result);
        }

        public async Task<ResponseModel> GetRateCardServicesAsync(RequestModel request)
        {
            MonumentRateRequestDto filter = CommonHelper.DecryptAndDeserialize<string, MonumentRateRequestDto>(request.RequestText);
            var response = await _getMonumentRateRepository.GetRateCardMonumentServicesAsync(filter);
            return CommonHelper.CreateApiResponse(response);
        }

        public async Task<ResponseModel> GetRateDetailByIDAsync(long id)
        {
            var result = await _getMonumentRateRepository.GetMonumentRateDetailByIdAsync(id);
            return CommonHelper.CreateApiResponse(result);
        }

        //public async Task<ResponseModel> GetAllRateSearchReportCardsAsync(RequestModel request)
        //{
        //    GetMonumentRateSearchRequestDto req = CommonHelper.DecryptAndDeserialize<string, GetMonumentRateSearchRequestDto>(request.RequestText);
        //    var result = await _getMonumentRateRepository.GetAllMonumentRateCardReportAsync(req);
        //    return CommonHelper.CreateApiResponse(result);
        //}
        public async Task<ResponseModel> GetAllRateSearchReportCardsAsync(RequestModel request)

        {

            GetMonumentRateSearchRequestDto req = CommonHelper.DecryptAndDeserialize<string, GetMonumentRateSearchRequestDto>(request.RequestText);

            var result = await _getMonumentRateRepository.GetAllMonumentRateCardReportAsync(req);

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

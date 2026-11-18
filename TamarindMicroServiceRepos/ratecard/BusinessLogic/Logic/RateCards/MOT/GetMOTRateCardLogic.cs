using CommonClass;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.MOT;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Helpers;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.MOT;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Logic.RateCards.MOT
{
    public class GetMOTRateCardLogic : IGetRateCardLogic
    {
        private readonly IGetMOTRateRepository _getMOTRateRepository;
        public GetMOTRateCardLogic(IGetMOTRateRepository getMOTRateRepository)
        {
            _getMOTRateRepository = getMOTRateRepository;
        }

        public async Task<ResponseModel> GetAllRateCardsAsync(RequestModel request)
        {
            MOTRateFilter req = CommonHelper.DecryptAndDeserialize<string, MOTRateFilter>(request.RequestText);
            var result = await _getMOTRateRepository.GetAllMOTRateAsync(req);
            return CommonHelper.CreateApiResponse(result);
        }

        public async Task<ResponseModel> GetRateCardByIDAsync(long id)
        {
            var result = await _getMOTRateRepository.GetMOTRateByIdAsync(id);
            return CommonHelper.CreateApiResponse(result);
        }

        public async Task<ResponseModel> GetAllRateDetailsByIDAsync(long id, int pageNumber, int pageSize)
        {
            var result = await _getMOTRateRepository.GetAllMOTRateDetailsByIdAsync(id, pageNumber, pageSize);
            return CommonHelper.CreateApiResponse(result);
        }

        public async Task<ResponseModel> GetRateDetailByIDAsync(long id)
        {
            var result = await _getMOTRateRepository.GetMOTRateDetailByIdAsync(id);
            return CommonHelper.CreateApiResponse(result);
        }

        public async Task<ResponseModel> GetRateCardDocumentsAsync(RequestModel request)
        {
            UploadDocumentRequestDto filter = CommonHelper.DecryptAndDeserialize<string, UploadDocumentRequestDto>(request.RequestText);
            var result = await _getMOTRateRepository.GetMotRateDocumentsAsync(filter);
            return CommonHelper.CreateApiResponse(result);
        }

        public Task<ResponseModel> GetAllRateCancellationPolicyAsync(RequestModel request)
        {
            throw new NotImplementedException();
        }

        public Task<ResponseModel> GetRateCancellationPolicyByIDAsync(RequestModel request)
        {
            throw new NotImplementedException();
        }

        public Task<ResponseModel> GetRateCardNumbersAsync(RequestModel request)
        {
            throw new NotImplementedException();
        }

        public Task<ResponseModel> GetRateCardHeadingsAsync(RequestModel request)
        {
            throw new NotImplementedException();
        }

        public Task<ResponseModel> GetRateCardServicesAsync(RequestModel request)
        {
            throw new NotImplementedException();
        }

        //public async Task<ResponseModel> GetAllRateSearchReportCardsAsync(RequestModel request)
        //{
        //    throw new NotImplementedException();
        //}
        public async Task<ResponseModel> GetAllRateSearchReportCardsAsync(RequestModel request)

        {

            GetMOTRateSearchRequestDto req = CommonHelper.DecryptAndDeserialize<string, GetMOTRateSearchRequestDto>(request.RequestText);

            var result = await _getMOTRateRepository.GetAllMOTRateCardReportAsync(req);

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

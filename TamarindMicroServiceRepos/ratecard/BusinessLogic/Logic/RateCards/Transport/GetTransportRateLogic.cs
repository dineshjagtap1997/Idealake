using CommonClass;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Transport;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Helpers;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Transport;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Logic.RateCards.Transport
{
    public class GetTransportRateLogic : IGetRateCardLogic
    {

        private readonly IGetTransportRateRepository _getTransportRateRepository;
        public GetTransportRateLogic(IGetTransportRateRepository getTransportRateRepository)
        {
            _getTransportRateRepository = getTransportRateRepository;
        }
        public Task<ResponseModel> GetAllRateCancellationPolicyAsync(RequestModel request)
        {
            throw new NotImplementedException();
        }

        public async Task<ResponseModel> GetAllRateCardsAsync(RequestModel request)
        {
            TransportRateRequestDto req = CommonHelper.DecryptAndDeserialize<string, TransportRateRequestDto>(request.RequestText);
            var result = await _getTransportRateRepository.GetAllTransportRateAsync(req);
            return CommonHelper.CreateApiResponse(result);
        }

        public async Task<ResponseModel> GetAllRateDetailsByIDAsync(long id, int pageNumber, int pageSize)
        {
            var result = await _getTransportRateRepository.GetAllTransportRateDetailsByIdAsync(id, pageNumber, pageSize);
            return CommonHelper.CreateApiResponse(result);
        }

        public Task<ResponseModel> GetRateCancellationPolicyByIDAsync(RequestModel request)
        {
            throw new NotImplementedException();
        }

        public async Task<ResponseModel> GetRateCardByIDAsync(long id)
        {
            var result = await _getTransportRateRepository.GetTransportRateByIdAsync(id);
            return CommonHelper.CreateApiResponse(result);
        }

        public async Task<ResponseModel> GetRateCardDocumentsAsync(RequestModel request)
        {
            UploadDocumentRequestDto documentRequestDto = CommonHelper.DecryptAndDeserialize<string, UploadDocumentRequestDto>(request.RequestText);
            var response = await _getTransportRateRepository.GetTransportRateDocumentsAsync(documentRequestDto);
            return CommonHelper.CreateApiResponse(response);
        }

        public async Task<ResponseModel> GetRateCardHeadingsAsync(RequestModel request)
        {
            TransportRateRequestDto filter = CommonHelper.DecryptAndDeserialize<string, TransportRateRequestDto>(request.RequestText);
            var result = await _getTransportRateRepository.GetRateCardHeadingsAsync(filter);
            return CommonHelper.CreateApiResponse(result);
        }

        public async Task<ResponseModel> GetRateCardNumbersAsync(RequestModel request)
        {
            TransportRateRequestDto filter = CommonHelper.DecryptAndDeserialize<string, TransportRateRequestDto>(request.RequestText);
            var result = await _getTransportRateRepository.GetRateCardNumberAsync(filter);
            return CommonHelper.CreateApiResponse(result);
        }

        public async Task<ResponseModel> GetRateCardServicesAsync(RequestModel request)
        {
            TransportRateRequestDto filter = CommonHelper.DecryptAndDeserialize<string, TransportRateRequestDto>(request.RequestText);
            var response = await _getTransportRateRepository.GetRateCardTransportServicesAsync(filter);
            return CommonHelper.CreateApiResponse(response);
        }

        public Task<ResponseModel> GetRateDetailByIDAsync(long id)
        {
            throw new NotImplementedException();
        }

        public async Task<ResponseModel> GetAllRateSearchReportCardsAsync(RequestModel request)
        {
            TransportRateCardSearchRequest req = CommonHelper.DecryptAndDeserialize<string, TransportRateCardSearchRequest>(request.RequestText);
            var result = await _getTransportRateRepository.GetAllTransportRateSearchReportAsync(req);
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

using CommonClass;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Logic.RateCards
{
    public interface IGetRateCardLogic
    {
        Task<ResponseModel> GetAllRateCardsAsync(RequestModel request);
        Task<ResponseModel> GetAllRateDetailsByIDAsync(long id,int pageNumber, int pageSize);
        Task<ResponseModel> GetRateDetailByIDAsync(long id);
        Task<ResponseModel> GetRateCardByIDAsync(long id);
        Task<ResponseModel> GetRateCardDocumentsAsync(RequestModel request);
        Task<ResponseModel> GetAllRateCancellationPolicyAsync(RequestModel request);
        Task<ResponseModel> GetRateCancellationPolicyByIDAsync(RequestModel request);
        Task<ResponseModel> GetRateCardNumbersAsync(RequestModel request);
        Task<ResponseModel> GetRateCardHeadingsAsync(RequestModel request);
        Task<ResponseModel> GetRateCardServicesAsync(RequestModel request);
        Task<ResponseModel> GetAllRateSearchReportCardsAsync(RequestModel request);
        Task<ResponseModel> GetAllCustomRateCardsAsync(RequestModel request);
        Task<ResponseModel> GetCustomRateCardByIDAsync(long id, RateCardType type);
    }
}

using CommonClass;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Logic.RateCards
{
    public interface ICreateRateCardLogic
    {
        Task<ResponseModel> CreateRateCardAsync(RequestModel request);
        Task<ResponseModel> CreateRateDetailAsync(RequestModel request);
        Task<ResponseModel> CreateRateCancellationPolicyAsync(RequestModel request);
        Task<ResponseModel> CreateRateCopyAsync(RequestModel request);
        Task<ResponseModel> CreateCustomRateCardAsync(RequestModel request,RateCardType type);
        Task<ResponseModel> CreateNegotiateRateCardAsync(RequestModel request, RateCardType type);
    }
}

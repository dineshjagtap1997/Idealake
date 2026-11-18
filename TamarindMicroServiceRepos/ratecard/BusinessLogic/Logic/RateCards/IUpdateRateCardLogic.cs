using CommonClass;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Logic.RateCards
{
    public interface IUpdateRateCardLogic
    {
        Task<ResponseModel> UpdateRateCardAsync(RequestModel request);
        Task<ResponseModel> UpdateRateDetailAsync(RequestModel request);
        Task<ResponseModel> UpdateRateCancellationPolicyAsync(RequestModel request);
        Task<ResponseModel> UpdateCustomRateCardAsync(RequestModel request,RateCardType type);
    }
}

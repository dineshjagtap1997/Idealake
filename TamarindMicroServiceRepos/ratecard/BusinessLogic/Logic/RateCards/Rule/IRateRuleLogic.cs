using CommonClass;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Logic.RateCards.Rule
{
    public interface IRateRuleLogic
    {
        Task<ResponseModel> GetRateRuleByIDAsync(long ID, int rateCardType);
        Task<ResponseModel> GetRateRuleAsync(long rateCardID,int rateCardTypeID);
        Task<ResponseModel> UpdateRateRuleAsync(RequestModel request, int rateCardType);
        Task<ResponseModel> CreateRateRuleAsync(RequestModel request, int rateCardType);
    }
}

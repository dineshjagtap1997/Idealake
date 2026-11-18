using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Implementations.Repositories.RateCards
{
    public interface IRateRulesRepository
    {
        Task<RateRuleResponseDto> GetRateRuleByIDAsync(long ID, int RateCardTypeID);
        Task<IEnumerable<RateRuleResponseDto>> GetRateRuleAsync(long rateCardID, int rateCardTypeID);
        Task<ApiResponseWrapper> UpdateRateRuleAsync(RateRuleRequestDto request,int RateCardTypeID);
        Task<ApiResponseWrapper> CreateRateRuleAsync(RateRuleRequestDto request, int RateCardTypeID);
    }
}

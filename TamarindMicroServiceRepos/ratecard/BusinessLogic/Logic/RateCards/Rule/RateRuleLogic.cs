using CommonClass;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Helpers;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Implementations.Repositories.RateCards;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Logic.RateCards.Rule
{
    public class RateRuleLogic : IRateRuleLogic
    {
        private readonly IRateRulesRepository _rateRulesRepository;
        public RateRuleLogic(IRateRulesRepository rateRulesRepository)
        {
            _rateRulesRepository = rateRulesRepository;
        }
        public async Task<ResponseModel> CreateRateRuleAsync(RequestModel request,int rateCardType)
        {
            RateRuleRequestDto req = CommonHelper.DecryptAndDeserialize<string, RateRuleRequestDto>(request.RequestText);
            var response =  await _rateRulesRepository.CreateRateRuleAsync(req, rateCardType);
            var flag = true;
            if(response.RateCardID == 0)
            {
                flag = false;
            }
            return CommonHelper.CreateApiResponse(flag, response);
        }

        public async Task<ResponseModel> GetRateRuleAsync(long rateCardID, int rateCardTypeID)
        {
            var result = await _rateRulesRepository.GetRateRuleAsync(rateCardID, rateCardTypeID);
            return CommonHelper.CreateApiResponse(result);
        }

        public async Task<ResponseModel> GetRateRuleByIDAsync(long ID, int rateCardType)
        {
            var result = await _rateRulesRepository.GetRateRuleByIDAsync(ID, rateCardType);
            IEnumerable<RateRuleResponseDto> ruleResponse = [result];
            return CommonHelper.CreateApiResponse(ruleResponse);
        }

        public async Task<ResponseModel> UpdateRateRuleAsync(RequestModel request, int rateCardType)
        {
            RateRuleRequestDto req = CommonHelper.DecryptAndDeserialize<string, RateRuleRequestDto>(request.RequestText);
            var response = await _rateRulesRepository.UpdateRateRuleAsync(req, rateCardType);
            return CommonHelper.CreateApiResponse(true, response);
        }
    }
}

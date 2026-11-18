using Dapper;
using System.Data;
using TamarindAstra.Common;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Implementations.Repositories.RateCards
{
    public class RateRulesRepository : IRateRulesRepository
    {
        public async Task<ApiResponseWrapper> CreateRateRuleAsync(RateRuleRequestDto request, int RateCardTypeID)
        {
            var respone = new ApiResponseWrapper();
            var parameter = new DynamicParameters();
            parameter.Add("@Operation", "INSERT");
            parameter.Add("@ID", request.ID);
            parameter.Add("@RateCardTypeID", RateCardTypeID);
            parameter.Add("@RateCardID", request.RateCardID);
            parameter.Add("@RuleID", request.RuleID);
            parameter.Add("@MISSeqeunce", request.MISSequence);
            parameter.Add("@ApplicableID", request.ApplicableID);
            parameter.Add("@Description", request.Description);
            parameter.Add("@OperationBy", request.OperationBy);
            //parameter.Add("@OperationBy", Guid.NewGuid().ToString());
            parameter.Add("@IsActive", request.IsActive);
            parameter.Add("@GuideRateID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            await SqlHelper.SaveAsync("RateCards.Usp_CreateOrUpdateRules", parameter);
            var ID =  Convert.ToInt64(parameter.Get<string>("@GuideRateID"));
            if(ID != 0)
            {
                TamarindAstra.Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(ID), "Usp_CreateOrUpdateRules");
                respone.RateCardID = ID;
                respone.Message = "New rate rule configuration added successfully";
                return respone;
            }
            else
            {
                respone.RateCardID = 0;
                respone.Message = "Rule for similar combination already exist";
                return respone;
            }
            
        }

        public async Task<IEnumerable<RateRuleResponseDto>> GetRateRuleAsync(long rateCardID,int rateCardTypeID)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "GETALL");
            parameters.Add("@ID", 0);
            parameters.Add("@RateCardID", rateCardID);
            parameters.Add("@RateCardTypeID", rateCardTypeID);
            var result = await SqlHelper.QueryAsync<RateRuleResponseDto, DynamicParameters>("RateCards.Usp_GetRateRules", parameters);
            return result;
        }

        public async Task<RateRuleResponseDto> GetRateRuleByIDAsync(long ID,int RateCardTypeID)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "GETBYID");
            parameters.Add("@ID", ID);
            parameters.Add("@RateCardID", 0);
            var result = await SqlHelper.QuerySingleAsync<RateRuleResponseDto, DynamicParameters>("RateCards.Usp_GetRateRules", parameters);
            return result;
        }

        public async Task<ApiResponseWrapper> UpdateRateRuleAsync(RateRuleRequestDto request,int RateCardTypeID)
        {
            var mongorequest = request;
            var respone = new ApiResponseWrapper();
            var parameter = new DynamicParameters();
            parameter.Add("@Operation", "UPDATE");
            parameter.Add("@ID", request.ID);
            parameter.Add("@RateCardTypeID", RateCardTypeID);
            parameter.Add("@RuleID", request.RuleID);
            parameter.Add("@MISSeqeunce", request.MISSequence);
            parameter.Add("@ApplicableID", request.ApplicableID);
            parameter.Add("@Description", request.Description);
            parameter.Add("@IsActive", request.IsActive);
            parameter.Add("@OperationBy", request.OperationBy);
            parameter.Add("@GuideRateID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            await SqlHelper.SaveAsync("RateCards.Usp_CreateOrUpdateRules", parameter);
            TamarindAstra.Common.RabbitMQService.StoreDataInQueue(mongorequest, Convert.ToInt32(request.ID), "Usp_CreateOrUpdateRules");
            respone.Message = "Rate rule configuration updated successfully";
            return respone;
        }
    }
}

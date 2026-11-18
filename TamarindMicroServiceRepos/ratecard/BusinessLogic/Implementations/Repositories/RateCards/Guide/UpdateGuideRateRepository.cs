using Dapper;
using System.Data;
using TamarindAstra.Common;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Guide;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Guide;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Implementations.Repositories.RateCards.Guide
{
    public class UpdateGuideRateRepository : IUpdateGuideRateRepository
    {
        public async Task<ApiResponseWrapper> UpdateGuideRateAsync(GuideRateRequestDto request)
        {
            var respone = new ApiResponseWrapper();
            var parameters = GetGuideRateParameters(request);

            await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_GuideRateCard", parameters);
            respone.RateCardID = Convert.ToInt64(parameters.Get<string>("@GuideRateID"));
            respone.CardNumber = parameters.Get<string>("@CardNumber");
            TamarindAstra.Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(respone.RateCardID), "CreateOrUpdate_GuideRateCard");

            respone.Message = "Rate configuration updated successfully";
            return respone;
        }

        public async Task<ApiResponseWrapper> UpdateGuideRateDetailAsync(GuideRateDetailRequestDto request)
        {
            var respone = new ApiResponseWrapper();
            var parameters = GetGuideRateDetailParameters(request);

            await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_GuideRateDetail", parameters);
            respone.RateCardID = Convert.ToInt64(parameters.Get<string>("@GuideRateDetailID"));
            TamarindAstra.Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(respone.RateCardID), "CreateOrUpdate_GuideRateDetail");
            respone.Message = "Rate configuration updated successfully";
            await UpdateGuideRateCommissionDetailAsync(request.Commissions);
            return respone;
        }
        private static async Task UpdateGuideRateCommissionDetailAsync(List<GuideRateCommissionDetailRequestDto> request)
        {
            foreach (var commission in request)
            {
                var parameters = GetGuideRateCommissionDetailParameters(commission);
                await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_GuideRateCommissionDetail", parameters);
            }
        }
        private static DynamicParameters GetGuideRateParameters(GuideRateRequestDto request)
        {
            var parameter = new DynamicParameters();
            parameter.Add("@Operation", "UPDATE");
            parameter.Add("@ID", request.GuideRateID);
            parameter.Add("@ContractDate", request.ContractDate);
            parameter.Add("@CurrencyID", request.CurrencyID);
            parameter.Add("@Heading", request.Heading);
            parameter.Add("@RateCardModeTypeID", (int)request.RateCardModeTypeID);
            parameter.Add("@LanguageID", request.LanguageID);
            parameter.Add("@VendorID", request.VendorID);
            parameter.Add("@CityID", request.CityID);
            parameter.Add("@GuideServiceID", request.GuideServiceID);
            parameter.Add("@InfoForOperation", request.InfoForOperation);
            parameter.Add("@InfoForRemark", request.InfoForRemark);
            parameter.Add("@InfoForAgent", request.InfoForAgent);
            parameter.Add("@StateID", request.StateID);
            parameter.Add("@GstStatus", request.GstStatus);
            parameter.Add("@IsActive", request.IsActive);
            parameter.Add("@Notes", request.ValueAddOn);
            parameter.Add("@GuideRateID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            parameter.Add("@CardNumber", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            parameter.Add("@UpdatedBy", request.OperationBy);
         //   parameter.Add("@UpdatedBy", Guid.NewGuid().ToString());

            return parameter;
        }
        private static DynamicParameters GetGuideRateDetailParameters(GuideRateDetailRequestDto request)
        {
            var parameter = new DynamicParameters();
            parameter.Add("@Operation", "UPDATE");
            parameter.Add("@ID", request.GuideRateDetailID);
            parameter.Add("@TaxID", request.TaxID);
            parameter.Add("@ValidFrom", CommonFunctions.ParseDate(request.ValidFrom));
            parameter.Add("@ValidTo", CommonFunctions.ParseDate(request.ValidTo));
            parameter.Add("@MISSequence", request.MISSequence);
            parameter.Add("@IsActive", request.IsActive);
            parameter.Add("@UpdatedBy", request.OperationBy);
            parameter.Add("@GuideRateDetailID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            return parameter;
        }
        private static DynamicParameters GetGuideRateCommissionDetailParameters(GuideRateCommissionDetailRequestDto request)
        {
            var parameter = new DynamicParameters();
            parameter.Add("@Operation", "UPDATE");
            parameter.Add("@ID", request.GuideRateCommissionID);
            parameter.Add("@TaxPercentage", request.TaxPercentage);
            parameter.Add("@TaxAmount", request.TaxAmount);
            parameter.Add("@NetAmountIncludingTax", request.NetAmountIncludingTax);
            parameter.Add("@NetAmountExcludingTax", request.NetAmountExcludingTax);
            parameter.Add("@PaxMinimum", request.PaxMinimum);
            parameter.Add("@PaxMaximum", request.PaxMaximum);
            parameter.Add("@GuideRateDetailID", request.GuideRateDetailID);
            parameter.Add("@IsActive", request.IsActive);
            parameter.Add("@UpdatedBy", request.OperationBy);
            parameter.Add("@GuideRateCommissionID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            return parameter;
        }
    }
}

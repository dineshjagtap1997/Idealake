using Dapper;
using System.Data;
using TamarindAstra.Common;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Monument;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Monument;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Implementations.Repositories.RateCards.Monument
{
    public class UpdateMonumentRateRepository : IUpdateMonumentRateRepository
    {
        public async Task<ApiResponseWrapper> UpdateMonumentRateAsync(MonumentRateRequestDto request)
        {
            var respone = new ApiResponseWrapper();
            var parameters = GetMonumentRateParameters(request);

            await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_MonumentRateCard", parameters);
            respone.RateCardID = Convert.ToInt64(parameters.Get<string>("@MonumentRateID"));
            respone.CardNumber = parameters.Get<string>("@CardNumber");
            TamarindAstra.Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(respone.RateCardID), "CreateOrUpdate_MonumentRateCard");
            respone.Message = "Rate configuration updated successfully";
            return respone;
        }

        public async Task<ApiResponseWrapper> UpdateMonumentRateDetailAsync(MonumentRateDetailRequestDto request)
        {
            var respone = new ApiResponseWrapper();
            var parameters = GetMonumentRateDetailParameters(request);

            await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_MonumentRateDetail", parameters);
            respone.RateCardID = Convert.ToInt64(parameters.Get<string>("@MonumentRateDetailID"));
            TamarindAstra.Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(respone.RateCardID), "CreateOrUpdate_MonumentRateDetail");
            respone.Message = "Rate configuration updated successfully";
            await UpdateMonumentRateCommissionDetailAsync(request.Commissions);
            return respone;
        }
        private static async Task UpdateMonumentRateCommissionDetailAsync(List<MonumentRateCommissionDetailRequestDto> request)
        {
            foreach (var commission in request)
            {
                var parameters = GetMonumentRateCommissionDetailParameters(commission);
                await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_MonumentRateCommissionDetails", parameters);
            }
        }
        private static DynamicParameters GetMonumentRateCommissionDetailParameters(MonumentRateCommissionDetailRequestDto request)
        {
            var parameter = new DynamicParameters();
            parameter.Add("@Operation", "UPDATE");
            parameter.Add("@ID", request.MonumentCommissionDetailID);
            parameter.Add("@TaxPercentage", request.TaxPercentage);
            parameter.Add("@TaxAmount", request.TaxAmount);
            parameter.Add("@NetAmountIncludingTax", request.NetAmountIncludingTax);
            parameter.Add("@NetAmountExcludingTax", request.NetAmountExcludingTax);
            parameter.Add("@MonumentDetailID", request.MonumentDetailID);
            parameter.Add("@IsActive", request.IsActive);
            parameter.Add("@UpdatedBy", request.OperationBy);
            parameter.Add("@MonumentRateCommissionID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);

            return parameter;
        }
        private static DynamicParameters GetMonumentRateDetailParameters(MonumentRateDetailRequestDto request)
        {
            var parameter = new DynamicParameters();
            parameter.Add("@Operation", "UPDATE");
            parameter.Add("@ID", request.MonumentDetailID);
            parameter.Add("@TaxID", request.TaxID);
            parameter.Add("@NationalityID", request.NationalityID);
            parameter.Add("@ValidFrom", CommonFunctions.ParseDate(request.ValidFrom));
            parameter.Add("@ValidTo", CommonFunctions.ParseDate(request.ValidTo));
            parameter.Add("@MISSequence", request.MISSequence);
            parameter.Add("@IsActive", request.IsActive);
            parameter.Add("@UpdatedBy", request.OperationBy);
            parameter.Add("@MonumentRateID", request.MonumentRateID);
            parameter.Add("@MonumentRateDetailID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            return parameter;
        }
        private static DynamicParameters GetMonumentRateParameters(MonumentRateRequestDto request)
        {
            var parameter = new DynamicParameters();
            parameter.Add("@Operation", "UPDATE");
            parameter.Add("@ID",request.MonumentRateID);
            parameter.Add("@ContractDate", CommonFunctions.ParseDate(request.ContractDate));
            parameter.Add("@CurrencyID", request.CurrencyID);
            parameter.Add("@Heading", request.Heading);
            parameter.Add("@RateCardModeTypeID", (int)request.RateCardModeTypeID);
            parameter.Add("@VendorID", request.VendorID);
            parameter.Add("@CityID", request.CityID);
            parameter.Add("@MonumentServiceID", request.MonumentServiceID);
            parameter.Add("@InfoForOperation", request.InfoForOperation);
            parameter.Add("@InfoForRemark", request.InfoForRemark);
            parameter.Add("@InfoForAgent", request.InfoForAgent);
            parameter.Add("@GSTStatus", request.GstStatus);
            parameter.Add("@StateID", request.StateID);
            parameter.Add("@IsActive", request.IsActive);
            parameter.Add("@MonumentRateID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            parameter.Add("@CardNumber", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            parameter.Add("@UpdatedBy", request.OperationBy);

            return parameter;
        }
    }
}

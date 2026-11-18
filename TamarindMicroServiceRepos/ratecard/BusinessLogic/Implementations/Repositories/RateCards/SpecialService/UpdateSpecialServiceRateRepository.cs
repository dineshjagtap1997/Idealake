using Dapper;
using System.Data;
using TamarindAstra.Common;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.SpecialService;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.SpecialService;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Implementations.Repositories.RateCards.SpecialService
{
    public class UpdateSpecialServiceRateRepository : IUpdateSpecialServiceRateRepository
    {
        public async Task<ApiResponseWrapper> UpdateSpecialServiceRateAsync(SpecialServiceRateRequestDto request)
        {
            var respone = new ApiResponseWrapper();
            var parameters = GetSpecialServiceRateParameters(request);

            await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_SpecialServiceRateCard", parameters);
            respone.RateCardID = Convert.ToInt64(parameters.Get<string>("@SpecialServiceRateID"));
            respone.CardNumber = parameters.Get<string>("@CardNumber");
            TamarindAstra.Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(respone.RateCardID), "CreateOrUpdate_SpecialServiceRateCard");
            respone.Message = "Rate configuration updated successfully";
            return respone;
        }

        public async Task<ApiResponseWrapper> UpdateSpecialServiceRateDetailAsync(SpecialServiceDetailRequestDto request)
        {
            var respone = new ApiResponseWrapper();
            var parameters = GetSpecialServiceRateDetailParameters(request);

            await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_SpecialServiceRateDetail", parameters);
            respone.RateCardID = Convert.ToInt64(parameters.Get<string>("@SpecialServiceRateDetailID"));
            TamarindAstra.Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(respone.RateCardID), "CreateOrUpdate_SpecialServiceRateDetail");
            respone.Message = "Rate configuration updated successfully";
            await UpdateSpecialServiceRateCommissionDetailAsync(request.Commissions);
            return respone;
        }

        private static async Task UpdateSpecialServiceRateCommissionDetailAsync(List<SpecialServiceRateCommissionDetailRequestDto> request)
        {
            foreach (var commission in request)
            {
                var parameters = GetSpecialServiceRateCommissionDetailParameters(commission);
                await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_SpecialServiceRateCommissionDetail", parameters);
            }
        }
        private static DynamicParameters GetSpecialServiceRateCommissionDetailParameters(SpecialServiceRateCommissionDetailRequestDto request)
        {
            var parameter = new DynamicParameters();
            parameter.Add("@Operation", "UPDATE");
            parameter.Add("@ID", request.SpecialServiceRateCommissionID);
            parameter.Add("@MinimumPax", request.MinimumPax);
            parameter.Add("@MaximumPax", request.MaximumPax);
            parameter.Add("@TaxPercentage", request.TaxPercentage);
            parameter.Add("@TaxAmount", request.TaxAmount);
            parameter.Add("@NetAmountIncludingTax", request.NetAmountIncludingTax);
            parameter.Add("@NetAmountExcludingTax", request.NetAmountExcludingTax);
            parameter.Add("@IsActive", request.IsActive);
            parameter.Add("@UpdatedBy", request.OperationBy);
            //parameter.Add('@MonumentRateCommissionID', request.SpecialServiceRateCommissionID);
            parameter.Add("@SpecialServiceRateCommissionID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            return parameter;
        }
        private static DynamicParameters GetSpecialServiceRateDetailParameters(SpecialServiceDetailRequestDto request)
        {
            var parameter = new DynamicParameters();
            parameter.Add("@Operation", "UPDATE");
            parameter.Add("@ID", request.SpecialServiceRateDetailID);
            parameter.Add("@TaxID", (int)request.TaxID);
            parameter.Add("@ValidFrom", CommonFunctions.ParseDate(request.ValidFrom));
            parameter.Add("@ValidTo", CommonFunctions.ParseDate(request.ValidTo));
            parameter.Add("@MISSequence", request.MISSequence);
            parameter.Add("@NationalityID", request.NationalityID);
            parameter.Add("@RatePreferenceID", (int)request.RatePreferenceID);
            parameter.Add("@IsActive", request.IsActive);
            parameter.Add("@IsActive", request.IsActive);
            parameter.Add("@UpdatedBy", request.OperationBy);
            parameter.Add("@SpecialServiceRateID", request.SpecialServiceRateID);
            parameter.Add("@SpecialServiceRateDetailID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            return parameter;
        }
        private static DynamicParameters GetSpecialServiceRateParameters(SpecialServiceRateRequestDto request)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "UPDATE");
            parameters.Add("@ID", request.SpecialServiceRateID);
            parameters.Add("@ContractDate", CommonFunctions.ParseDate(request.ContractDate));
            parameters.Add("@CurrencyID", request.CurrencyID);
            parameters.Add("@Heading", request.Heading);
            parameters.Add("@RateCardModeTypeID", (int)request.RateCardModeTypeID);
            parameters.Add("@VendorID", request.VendorID);
            parameters.Add("@CityID", request.CityID);
            parameters.Add("@SpecialServiceID", request.SpecialServiceID);
            parameters.Add("@InfoForOperation", request.InfoForOperation);
            parameters.Add("@InfoForRemark", request.InfoForRemark);
            parameters.Add("@InfoForAgent", request.InfoForAgent);
            parameters.Add("@GSTStatus", request.GstStatus);
            parameters.Add("@StateID", request.StateID);
            parameters.Add("@HrsPerDay", request.HrsPerDay);
            parameters.Add("@KmPerDay", request.KmPerDay);
            parameters.Add("@IsActive", request.IsActive);
            parameters.Add("@SpecialServiceRateID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            parameters.Add("@CardNumber", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            parameters.Add("@HotelId", request.HotelID);
            parameters.Add("@UpdatedBy", request.OperationBy);
            return parameters;
        }
    }
}

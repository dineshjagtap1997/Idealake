using Dapper;
using System.Data;
using TamarindAstra.Common;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Transport;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Transport;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Implementations.Repositories.RateCards.Transport
{
    public class UpdateTransportRateRepository : IUpdateTransportRateRepository
    {
        public async Task<ApiResponseWrapper> UpdateTransportServiceRateAsync(TransportRateRequestDto request)
        {
            var respone = new ApiResponseWrapper();
            var parameters = GetTransportServiceRateParameters(request);

            await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_TransportRateCard", parameters);
            respone.RateCardID = Convert.ToInt64(parameters.Get<string>("@TransportRateID"));
            respone.CardNumber = parameters.Get<string>("@CardNumber");
            TamarindAstra.Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(respone.RateCardID), "CreateOrUpdate_TransportRateCard");
            respone.Message = "Rate configuration updated successfully";
            return respone;
        }
        public async Task<ApiResponseWrapper> UpdateTransportServiceRateDetailAsync(TransportRateDetailRequestDto request)
        {
            var respone = new ApiResponseWrapper();
            var parameters = GetTransportServiceRateDetailParameters(request);

            await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_TransportRateDetail", parameters);
            respone.RateCardID = Convert.ToInt64(parameters.Get<string>("@TransportRateDetailID"));
            TamarindAstra.Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(respone.RateCardID), "CreateOrUpdate_TransportRateDetail");
            respone.Message = "Rate configuration updated successfully";
            await UpdateSpecialServiceRateCommissionDetailAsync(request.Commissions);
            return respone;
        }
        private static async Task UpdateSpecialServiceRateCommissionDetailAsync(List<TransportRateCommissionDetailRequestDto> request)
        {
            foreach (var commission in request)
            {
                var parameters = GetTransportServiceRateCommissionDetailParameters(commission);
                await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_TransportRateCommissionDetail", parameters);
            }
        }
        private static DynamicParameters GetTransportServiceRateCommissionDetailParameters(TransportRateCommissionDetailRequestDto request)
        {
            var parameter = new DynamicParameters();
            parameter.Add("@Operation", "UPDATE");
            parameter.Add("@ID", request.TransportCommissionDetailID);
            parameter.Add("@IsAmtIncludedInTax", request.IsAmtIncludedInBasic);
            parameter.Add("@TaxPercentage", request.TaxPercentage);
            parameter.Add("@TaxAmount", request.TaxAmount);
            parameter.Add("@NetAmountIncludingTax", request.NetAmountIncludingTax);
            parameter.Add("@NetAmountExcludingTax", request.NetAmountExcludingTax);
            parameter.Add("@IsActive", request.IsActive);
            parameter.Add("@UpdatedBy", request.OperationBy);
            parameter.Add("@TransportRateCommissionID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            return parameter;
        }
        private static DynamicParameters GetTransportServiceRateDetailParameters(TransportRateDetailRequestDto request)
        {
            var parameter = new DynamicParameters();
            parameter.Add("@Operation", "UPDATE");
            parameter.Add("@ID", request.TransportRateDetailID);
            parameter.Add("@TaxID", (int)request.TaxID);
            parameter.Add("@ValidFrom", CommonFunctions.ParseDate(request.ValidFrom));
            parameter.Add("@ValidTo", CommonFunctions.ParseDate(request.ValidTo));
            parameter.Add("@MISSequence", request.MISSequence);
            parameter.Add("@VehicleCategoryID", request.VehicleCategoryID);
            parameter.Add("@VehicleBaseID", (int)request.VehicleBaseID);
            parameter.Add("@IsActive", request.IsActive);
            parameter.Add("@TransportRateID", request.TransportRateID);
            parameter.Add("@IsActive", request.IsActive);
            parameter.Add("@UpdatedBy", request.OperationBy);
            parameter.Add("@TransportRateDetailID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            //parameter.Add("@TransportRateCommissionID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            return parameter;
        }
        private static DynamicParameters GetTransportServiceRateParameters(TransportRateRequestDto request)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "UPDATE");
            parameters.Add("@ID", request.TransportRateID);
            parameters.Add("@ContractDate", CommonFunctions.ParseDate(request.ContractDate));
            parameters.Add("@CurrencyID", request.CurrencyID);
            parameters.Add("@Heading", request.Heading);
            parameters.Add("@RateCardModeTypeID", (int)request.RateCardModeTypeID);
            parameters.Add("@VendorID", request.VendorID);
            parameters.Add("@CityID", request.CityID);
            parameters.Add("@CityID2", request.CityID2);
            parameters.Add("@InfoForOperation", request.InfoForOperation);
            parameters.Add("@InfoForRemark", request.InfoForRemark);
            parameters.Add("@InfoForAgent", request.InfoForAgent);
            parameters.Add("@GSTStatus", request.GstStatus);
            parameters.Add("@StateID", request.StateID);
            parameters.Add("@IsActive", request.IsActive);
            parameters.Add("@TransportServiceID", request.TransportServiceID);
            parameters.Add("@HotelID", request.HotelID);
            parameters.Add("@HotelZone", request.HotelZone);
            parameters.Add("@TransportModeTypeID", request.TransportModeTypeID);
            parameters.Add("@TransportRateID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            parameters.Add("@CardNumber", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            parameters.Add("@UpdatedBy", request.OperationBy);
            return parameters;

        }
    }
}

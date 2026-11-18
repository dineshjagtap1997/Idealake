using Dapper;
using System.Data;
using TamarindAstra.Common;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel.CancellationPolicy;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Hotel.CancellationPolicy;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Implementations.Repositories.RateCards.Hotel.CancellationPolicy
{
    public class CreateHotelRatePolicyRepository : ICreateHotelRatePolicyRepository
    {
        public async Task<ApiResponseWrapper> CreateHotelRatePolicy(HotelRateCancellationPolicyDto hotelRatePolicy)
        {
            var respone = new ApiResponseWrapper();
            var parameter = new DynamicParameters();
            parameter.Add("@Operation", "INSERT");
            parameter.Add("@ID", hotelRatePolicy.PolicyID);
            parameter.Add("@RateCardTypeID", (int)hotelRatePolicy.RateCardTypeID);
            parameter.Add("@RateCardID", hotelRatePolicy.RateCardID);
            parameter.Add("@ValidFrom", CommonFunctions.ParseDate(hotelRatePolicy.ValidFrom));
            parameter.Add("@ValidTo", CommonFunctions.ParseDate(hotelRatePolicy.ValidTo));
            parameter.Add("@TsStart", hotelRatePolicy.TsStart);
            parameter.Add("@TsEnd", hotelRatePolicy.TsEnd);
            parameter.Add("@AgentStart", hotelRatePolicy.AgentStart);
            parameter.Add("@AgentEnd", hotelRatePolicy.AgentEnd);
            parameter.Add("@ChangePercent", hotelRatePolicy.ChangePercent);
            parameter.Add("@ChargeNight", hotelRatePolicy.ChargeNight);
            parameter.Add("@IsActive", hotelRatePolicy.IsActive);
            parameter.Add("@LogID", dbType: DbType.Int64, size: 100, direction: ParameterDirection.Output);
            await SqlHelper.SaveAsync("RateCards.Usp_CreateOrUpdate_RateCardCancellationPolicy", parameter);
            respone.RateCardID = Convert.ToInt64(parameter.Get<Int64>("@LogID"));
            
            if (respone.RateCardID > 0)
            {
                Common.RabbitMQService.StoreDataInQueue(hotelRatePolicy, Convert.ToInt32(respone.RateCardID), "Usp_CreateOrUpdate_RateCardCancellationPolicy");
                respone.Message = "Cancellation Policy Created Successfully";
            }
            return respone;



        }
    }
}

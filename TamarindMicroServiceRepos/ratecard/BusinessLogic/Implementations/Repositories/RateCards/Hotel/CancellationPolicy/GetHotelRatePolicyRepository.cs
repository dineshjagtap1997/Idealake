using Dapper;
using TamarindAstra.Common;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel.CancellationPolicy;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Hotel.CancellationPolicy;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Implementations.Repositories.RateCards.Hotel.CancellationPolicy
{
    public class GetHotelRatePolicyRepository : IGetHotelRatePolicyRepository
    {
        public async Task<IEnumerable<HotelRateCancellationPolicyDto>> GetAllHotelRateCancellationPolicyAsync(HotelRateCancellationPolicyDto hotelRatePolicy)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "GETALL");
            parameters.Add("@RateCardID", hotelRatePolicy.RateCardID);
            parameters.Add("@PolicyID", hotelRatePolicy.PolicyID);
            var result = await SqlHelper.QueryAsync<HotelRateCancellationPolicyDto, DynamicParameters>("RateCards.Usp_GetRateCancellationPolicy", parameters);
            return result;
        }

        public async Task<HotelRateCancellationPolicyDto> GetHotelRateCancellationPolicyAsync(HotelRateCancellationPolicyDto hotelRatePolicy)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "GETBYID");
            parameters.Add("@PolicyID", hotelRatePolicy.PolicyID);
            parameters.Add("@RateCardID", hotelRatePolicy.RateCardID);
            var result = await SqlHelper.QuerySingleAsync<HotelRateCancellationPolicyDto, DynamicParameters>("RateCards.Usp_GetRateCancellationPolicy", parameters);
            return result;
        }
    }
}

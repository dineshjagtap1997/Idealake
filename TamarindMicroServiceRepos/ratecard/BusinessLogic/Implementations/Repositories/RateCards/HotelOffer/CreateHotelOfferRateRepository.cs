using Dapper;
using System.Data;
using TamarindAstra.Common;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.HotelOffer;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Hotel;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.HotelOffer;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Implementations.Repositories.RateCards.HotelOffer
{
    public class CreateHotelOfferRateRepository : ICreateHotelOfferRateRepository
    {
        public async Task<ApiResponseWrapper> CreateHotelOfferAsync(HotelOfferRequestDto request)
        {
            var respone = new ApiResponseWrapper();
            var parameters = GetHotelOfferParameters(request);
            await SqlHelper.SaveAsync("[RateCards].[CreateOrUpdate_HotelOffer]", parameters);
            respone.RateCardID = Convert.ToInt64(parameters.Get<string>("@HotelOfferID"));
            respone.CardNumber = parameters.Get<string>("@CardNumber");
            respone.Message = "Hotel offer created successfully";
            request.CardNumber = respone.CardNumber;
            await CreateHotelOfferRateSheetAsync(request.RateSheet, respone.RateCardID);
            await CreateHotelOfferRateMarketAsync(request.Market, respone.RateCardID);
            await CreateHotelMappingAsync(request.Hotels, respone.RateCardID);
            TamarindAstra.Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(respone.RateCardID), "CreateOrUpdate_HotelOffer");
            return respone;
        }
        private static async Task CreateHotelOfferRateSheetAsync(List<HotelOfferRateSheetMasterLookup> ratesheetMasters, long hotelOfferID)
        {
            if (ratesheetMasters == null || ratesheetMasters.Count == 0) return;
            foreach (var item in ratesheetMasters)
            {
                var parameters = new DynamicParameters();
                parameters.Add("@Operation", "ADD");
                parameters.Add("@HotelOfferID", hotelOfferID);
                parameters.Add("@RateSheetID", item.RateSheetID);
                await SqlHelper.SaveAsync("[RateCards].[CreateOrUpdate_HotelOfferMarketSheet]", parameters);
            }
        }
        private static async Task CreateHotelMappingAsync(List<HotelOfferMapping> hotels, long hotelOfferID)
        {
            if (hotels == null || hotels.Count == 0) return;
            foreach (var item in hotels)
            {
                var parameters = new DynamicParameters();
                parameters.Add("@Operation", "ADD");
                parameters.Add("@HotelOfferID", hotelOfferID);
                parameters.Add("@HotelID", item.HotelID);
                await SqlHelper.SaveAsync("[RateCards].[CreateOrUpdate_HotelOfferMapping]", parameters);
            }
        }
        private static async Task CreateHotelOfferRateMarketAsync(List<HotelOfferMarketMasterLookup> ratesheetMasters, long hotelOfferID)
        {
            if (ratesheetMasters == null || ratesheetMasters.Count == 0) return;
            foreach (var item in ratesheetMasters)
            {
                var parameters = new DynamicParameters();
                parameters.Add("@Operation", "ADD");
                parameters.Add("@HotelOfferID", hotelOfferID);
                parameters.Add("@MarketRateID", item.MarketRateID);
                await SqlHelper.SaveAsync("[RateCards].[CreateOrUpdate_HotelOfferMarket]", parameters);
            }
        }
        private static DynamicParameters GetHotelOfferParameters(HotelOfferRequestDto request)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "INSERT");
            parameters.Add("@HospitalityPartnerID",(int) request.HospitalityPartnerID);
            parameters.Add("@CityID", request.CityID);
            parameters.Add("@HotelID", request.HotelID);
            parameters.Add("@HotelGroupID", request.HotelGroupID);
            parameters.Add("@VendorID", request.VendorID);
            parameters.Add("@Heading", request.Heading);
            parameters.Add("@ValidFrom", CommonFunctions.ParseDate(request.ValidFrom));
            parameters.Add("@ValidTo", CommonFunctions.ParseDate(request.ValidTo));
            parameters.Add("@InfoForOperation", request.InfoForOperation);
            parameters.Add("@Rule", request.Rule);
            parameters.Add("@IsMarketOrAgent", request.IsMarketOrAgent);
            parameters.Add("@IsActive", request.IsActive);
            parameters.Add("@HotelOfferID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            parameters.Add("@CardNumber", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            parameters.Add("@CreatedBy", request.OperationBy);
            return parameters;
        }
    }
}

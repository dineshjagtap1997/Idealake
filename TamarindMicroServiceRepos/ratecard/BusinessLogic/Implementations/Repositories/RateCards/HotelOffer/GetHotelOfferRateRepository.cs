using Dapper;
using Newtonsoft.Json;
using TamarindAstra.Common;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.HotelOffer;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.HotelOffer.Document;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Monument;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Hotel;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.HotelOffer;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Implementations.Repositories.RateCards.HotelOffer
{
    public class GetHotelOfferRateRepository : IGetHotelOfferRateRepository
    {
        //public async Task<IEnumerable<HotelOfferResponseDto>> GetAllHotelOffersAsync(HotelOfferRequestDto filter)
        //{
        //    var parameters = new DynamicParameters();
        //    parameters.Add("@Operation", "GETALL");
        //    parameters.Add("@CardNumber", filter.CardNumber);
        //    parameters.Add("@City", filter.City);
        //    parameters.Add("@Vendor", filter.VendorName);
        //    parameters.Add("@Hotel", filter.HotelName);
        //    parameters.Add("@Heading", filter.Heading);
        //    parameters.Add("@ValidFrom", filter.ValidFrom);

        //    parameters.Add("@ValidTo", filter.ValidTo);
        //    parameters.Add("@IsActive", filter.IsActive);
        //    parameters.Add("@PageSize", filter.PageSize);
        //    parameters.Add("@PageNumber", filter.PageNumber);
        //    var result = await SqlHelper.QueryAsync<HotelOfferResponseDto, DynamicParameters>("[RateCards].[Get_HotelOffer]", parameters);
        //    return result;
        //}

        public async Task<IEnumerable<HotelOfferResponseDto>> GetAllHotelOffersAsync(HotelOfferRequestDto filter)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "GETALL");
            parameters.Add("@CardNumber", filter.CardNumber);
            parameters.Add("@City", filter.City);
            parameters.Add("@Vendor", filter.VendorName);
            parameters.Add("@Hotel", filter.HotelName);
            parameters.Add("@Heading", filter.Heading);
            parameters.Add("@ValidFrom", filter.ValidFrom);
            parameters.Add("@ValidTo", filter.ValidTo);
            parameters.Add("@IsActive", filter.IsActive);
            parameters.Add("@PageSize", filter.PageSize);
            parameters.Add("@PageNumber", filter.PageNumber);

            // Step 1: Get raw results (with JSON column)
            var rawResults = await SqlHelper.QueryAsync<dynamic, DynamicParameters>(
                "[RateCards].[Get_HotelOffer]", parameters);

            // Step 2: Deserialize into typed objects
            var finalList = new List<HotelOfferResponseDto>();
            foreach (var item in rawResults)
            {
                var dto = new HotelOfferResponseDto
                {
                    HotelOfferID = item.HotelOfferID,
                    CardNumber = item.CardNumber,
                    Heading = item.Heading,
                    City = item.City,
                    VendorName = item.VendorName,
                    IsActive = item.IsActive,
                    HasRules = item.HasRules,
                    HasDocument  = item.HasDocument,
                    ValidFrom = item.ValidFrom,
                    ValidTo = item.ValidTo,
                    Rule = item.Rule,
                    TotalCount = item.TotalCount,
                    HotelGroupName = item.HotelGroupName

                };

                // Deserialize JSON safely
                if (item.HotelDetailsJson != null)
                {
                    dto.Hotels = JsonConvert.DeserializeObject<List<HotelOfferMapping>>(item.HotelDetailsJson.ToString());
                }

                finalList.Add(dto);
            }

            return finalList;
        }


        public async Task<HotelOfferResponseDto> GetHotelOfferByIDAsync(long id)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "GET_RATE_BYID");
            parameters.Add("@ID", id);
            var (hotelOfferResponse, marketResponse, ratesheetResponse, hotelOfferMappingresponse) = await SqlHelper.QueryMultipleAsync<HotelOfferResponseDto, HotelOfferMarketMasterLookup, HotelOfferRateSheetMasterLookup,HotelOfferMapping, DynamicParameters>("[RateCards].[Get_HotelOffer]", parameters);
            var response = hotelOfferResponse?.FirstOrDefault() ?? new HotelOfferResponseDto();

            response.Market = marketResponse?.ToList() ?? [];
            response.RateSheet = ratesheetResponse?.ToList() ?? [];
            response.Hotels = hotelOfferMappingresponse?.ToList() ?? [];
            return response;
        }

        public async Task<IEnumerable<HotelOfferDocumentResponseDto>> GetHotelOfferRateDocumentsAsync(UploadDocumentRequestDto request)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@CardNo", request.CardNumber);
            parameters.Add("@DocumentName", request.DocumentName);
            parameters.Add("@ParentID", request.ParentID);
            var result = await SqlHelper.QueryAsync<HotelOfferDocumentResponseDto, DynamicParameters>("[dbo].[usp_SearchHotelOfferUploadDocuments]", parameters);
            return result;
        }
        public async Task<IEnumerable<HotelOfferSearchResponseDto>> GetAllHotelOfferRateCardReportAsync(HotelOfferSearchRequestDto filter)
        {
            var parameters = new DynamicParameters();

            parameters.Add("@CityID", filter.City);
            parameters.Add("@HotelID", filter.HotelVendorName);
            parameters.Add("@HotelGroup", filter.HotelGroup);
            parameters.Add("@RateHeader", filter.RateHeader);
            parameters.Add("@ValidFrom", filter.ValidFrom);
            parameters.Add("@ValidTo", filter.ValidTo);

            var result = await SqlHelper.QueryAsync<HotelOfferSearchResponseDto, DynamicParameters>(
                "[RateCards].[usp_SearchHotelOffers]",
                parameters
            );

            return result;
        }

    }
}

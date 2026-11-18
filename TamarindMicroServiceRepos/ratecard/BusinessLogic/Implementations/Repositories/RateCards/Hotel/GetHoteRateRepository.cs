
using Dapper;
using MongoDB.Driver;
using MongoDB.Driver.Linq;
using Newtonsoft.Json;
using System.Data;
using TamarindAstra.Common;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel.Document;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Hotel;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Hotel;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Implementations.Repositories.RateCards.Hotel
{
    public class GetHotelRateCardRepository : IGetHotelRateCardRepository
    {
        public async Task<IEnumerable<HotelRateResponseDto>> GetAllHotelRateCardsAsync(HotelRateRequestDto filter)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "GETALL");
            parameters.Add("@CardNumber", filter.CardNumber);
            parameters.Add("@RateCardModeTypeID", filter.RateCardModeType);
            parameters.Add("@Heading", filter.Heading);
            parameters.Add("@ContractDate", filter.ContractDate);
            parameters.Add("@HotelID", filter.HotelName);
            parameters.Add("@IsActive", filter.Active);
            parameters.Add("@CityID", filter.City);
            parameters.Add("@PaymentTypeID", filter.PaymentType);
            parameters.Add("@PageSize", filter.PageSize);
            parameters.Add("@PageNumber", filter.PageNumber);
            var result = await SqlHelper.QueryAsync<HotelRateResponseDto, DynamicParameters>("[RateCards].[Usp_GetHotelRateCards]", parameters);
            return result;
        }

        public async Task<IEnumerable<CustomHotelRateRequestDto>> GetAllCustomHotelRateCardsAsync(CustomHotelRateRequestDto filter)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "GETALL");
            parameters.Add("@CardNumber", filter.CardNumber);
            parameters.Add("@RateCardModeTypeID", filter.RateCardModeType);
            parameters.Add("@Heading", filter.Heading);
            parameters.Add("@ContractDate", filter.ContractDate);
            parameters.Add("@HotelID", filter.HotelName);
            parameters.Add("@IsActive", filter.Active);
            parameters.Add("@CityID", filter.City);
            parameters.Add("@PaymentTypeID", filter.PaymentTypeID);
            parameters.Add("@PageSize", filter.PageSize);
            parameters.Add("@PageNumber", filter.PageNumber);
            var result = await SqlHelper.QueryAsync<CustomHotelRateRequestDto, DynamicParameters>("[Customratecards].[Usp_GetHotelRateCards]", parameters);
            return result;
        }
        public async Task<IEnumerable<CustomHotelRateRequestDto>> GetCustomHotelRateCardByIDAsync(long id, RateCardType type)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "GET_RATEDETAILS_BYID");
            parameters.Add("@ID", id);
            parameters.Add("@RateType", (int)type);
            var jsonList = await SqlHelper.QueryAsync<string, DynamicParameters>("Customratecards.[Usp_GetHotelRateCards]", parameters);
            // Fix: Deserialize each JSON string in the list and aggregate the results  
            string jsonArray = string.Join("", jsonList);
            var result = JsonConvert.DeserializeObject<List<CustomHotelRateRequestDto>>(jsonArray);
            return result;
        }
        public async Task<IEnumerable<HotelRateDetailsResponseDto>> GetAllHotelRateDetailsByIdAsync(long id, int pageNumber, int pageSize)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "GET_RATEDETAILS_BYID");
            parameters.Add("@ID", id);
            parameters.Add("@PageSize", pageSize);
            parameters.Add("@PageNumber", pageNumber);
            var jsonList = await SqlHelper.QueryAsync<string, DynamicParameters>("[RateCards].[Usp_GetHotelRateCards]", parameters);
            // Fix: Deserialize each JSON string in the list and aggregate the results  
            string jsonArray = string.Join("", jsonList);
            var result = JsonConvert.DeserializeObject<List<HotelRateDetailsResponseDto>>(jsonArray);
            //var result = jsonArray.Select(json => JsonConvert.DeserializeObject<HotelRateDetailsResponseDto>(jsonArray)).ToList();
            return result;
        }
        public async Task<HotelRateDetailResponseDto> GetHotelRateDetailsByIDAsync(long id)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "GET_RATEDETAIL_BYID");
            parameters.Add("@ID", id);
            var (hotelRateDetails, mealOverview, rateValidity, rateCommission) = await SqlHelper.QueryMultipleAsync<HotelRateDetailResponseDto, HotelRateMealResponseDto, HotelRateValidityResponseDto, HotelRateCommissionDetailResponseDto, DynamicParameters>("[RateCards].[Usp_GetHotelRateCards]", parameters);

            HotelRateDetailResponseDto response = hotelRateDetails.FirstOrDefault();

            var offerParameters = new DynamicParameters();
            parameters.Add("@HotelDetailID", id);
            var (offerConfiguration, offerCommission) = await SqlHelper.QueryMultipleAsync<HotelRateOfferConfigurationResponseDto, HotelRateOfferConfigurationCommission, DynamicParameters>("RateCards.Get_HotelRateOfferConfigurations", offerParameters);

            var offer = offerConfiguration.FirstOrDefault();

            response.Meals = mealOverview;
            response.Commissions = rateCommission;
            response.Validities = rateValidity;
            if (offer is not null)
            {
                response.OfferConfiguration = offer;
                response.OfferConfiguration.OfferCommission = offerCommission.ToList();
            }
            return response;
        }
        public async Task<IEnumerable<HotelRateResponseDto>> GetHotelRateCardByIDAsync(long id)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "GET_RATE_BYID");
            parameters.Add("@ID", id);
            var (hotelRateResponse, marketResponse, ratesheetResponse, voucherResponse) = await SqlHelper.QueryMultipleAsync<HotelRateResponseDto, HotelRateMarketResponseDto, HotelRatesheetResponseDto, HotelRateVoucherResponseDto, DynamicParameters>("[RateCards].[Usp_GetHotelRateCards]", parameters);
            var response = hotelRateResponse?.FirstOrDefault() ?? new HotelRateResponseDto();

            // Assign values correctly
            response.Market = marketResponse?.ToList() ?? [];
            response.Ratesheet = ratesheetResponse?.ToList() ?? [];
            response.Voucher = voucherResponse?.ToList() ?? [];
            return [response];
        }
        public async Task<IEnumerable<HotelRateDocumentResponseDto>> GetHotelRateDocumentsAsync(UploadDocumentRequestDto request)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@HotelCardNo", request.CardNumber);
            parameters.Add("@HotelID", request.HotelID);
            parameters.Add("@UploadedBy", request.UploadedBy);
            parameters.Add("@ParentID", request.ParentID);
            parameters.Add("@DocumentName", request.DocumentName);
            var result = await SqlHelper.QueryAsync<HotelRateDocumentResponseDto, DynamicParameters>("[dbo].[usp_SearchHotelUploadDocuments]", parameters);
            return result;
        }
        public async Task<IEnumerable<HotelRateResponseDto>> GetRateCardNumberAsync(HotelRateRequestDto filter)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "GET_RATECARDNO");
            parameters.Add("@CardNumber", filter.CardNumber);
            var result = await SqlHelper.QueryAsync<HotelRateResponseDto, DynamicParameters>("[RateCards].[Usp_GetHotelRateCards]", parameters);
            return result;
        }
        public async Task<IEnumerable<HotelRateResponseDto>> GetRateCardHeadingsAsync(HotelRateRequestDto filter)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "GET_RATECARDHEADER");
            parameters.Add("@Heading", filter.Heading);
            var result = await SqlHelper.QueryAsync<HotelRateResponseDto, DynamicParameters>("[RateCards].[Usp_GetHotelRateCards]", parameters);
            return result;
        }
        public async Task<IEnumerable<HotelRateResponseDto>> GetRateCardHotelServicesAsync(HotelRateRequestDto filter)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "GET_RATECARD_SERVICE");
            parameters.Add("@HotelService", filter.HotelService);
            var result = await SqlHelper.QueryAsync<HotelRateResponseDto, DynamicParameters>("[RateCards].[Usp_GetHotelRateCards]", parameters);
            return result;
        }
        public async Task<IEnumerable<HotelRateDetailsSearchResponseDto>> GetRateCardHotelSearchServicesAsync(HotelRateSearchInputDto filter)
        {
            var parameters = new DynamicParameters();
            //parameters.Add("@Operation", "GET_HOTEL_RATECARD");
            parameters.Add("@CityID", filter.CityID);
            parameters.Add("@HotelID", filter.HotelID);
            parameters.Add("@CheckIn", filter.CheckIn);
            parameters.Add("@CheckOut", filter.CheckOut);
            parameters.Add("@Occupancy", filter.Occupancy != null ? string.Join(",", filter.Occupancy) : null);

            parameters.Add("@CurrencyCode", filter.CurrencyCode);
            parameters.Add("@RateCardModeType", filter.RateCardModeType);
            parameters.Add("@TaxID", filter.TaxID);
            parameters.Add("@RatingFrom", filter.RatingFrom);
            parameters.Add("@RatingTo", filter.RatingTo);
            parameters.Add("@MISSequence", filter.MISSequence);
            parameters.Add("@PreferredMarketIDs", filter.PreferredMarketIDs);
            //parameters.Add("@RateSheetIDs", filter.RateSheetIDs);
            parameters.Add("@RateSheetIDs", filter.RateSheetIDs != null ? string.Join(",", filter.RateSheetIDs) : null);
            parameters.Add("@PreferredHotel", filter.PreferredHotel);
            parameters.Add("@QuotationID", filter.QuotationID);
            parameters.Add("@IsFromBooking", filter.IsFromBooking);
            parameters.Add("@BookingID", filter.BookingID);

            parameters.Add("@FIT", filter.FIT);
            parameters.Add("@GIT", filter.GIT);
            parameters.Add("@BusinessType", filter.BusinessType);
            parameters.Add("@VendorID", filter.VendorID);
            parameters.Add("@HotelRateID", filter.HotelRateID);

            parameters.Add("@IsRateCardSearch", filter.IsRateCardSearch);

            //    var resultRaw = await SqlHelper.QueryAsync<dynamic, DynamicParameters>(
            //    "[RateCards].[usp_SearchHotelRateCardsNew]",
            //    parameters
            //);




            var resultRaw = await SqlHelper.QueryAsync<dynamic, DynamicParameters>(
          "[RateCards].[usp_SearchHotelRateCards]",
          parameters
      );
            var result = new List<HotelRateDetailsSearchResponseDto>();

            //foreach (var row in resultRaw)
            //{
            //    var dto = new HotelRateDetailsSearchResponseDto
            //    {
            //        HotelRateID = row.HotelRateID,
            //        HotelID = row.HotelID,
            //        HotelName = row.HotelName,
            //        CityID = row.CityID,
            //        HotelRateDetailID = row.HotelRateDetailID,
            //        RoomCategoryID = row.RoomCategoryID,
            //        RoomCategory = row.RoomCategory,
            //        MISSequence = row.MISSequence,
            //        Days = row.Days,
            //        DaysOfWeek = row.DaysOfWeek,
            //        MealPlanCode = row.MealPlanCode,
            //        Breakfast = row.Breakfast,
            //        Lunch = row.Lunch,
            //        Dinner = row.Dinner,
            //        HasDocument = row.HasDocument,
            //        HasRules = row.HasRules,
            //        OfferTypeID = row.OfferTypeID,
            //        Currency = row.Currency,
            //        PurchaseRate = row.PurchaseRate,
            //        RateCardModeTypeID = row.RateCardModeTypeID,
            //        HotelPreferred = row.HotelPreferred,
            //        TransferID = row.TransferID,
            //        TransferValue = row.TransferValue,

            //        // Manual JSON deserialization
            //        Commissions = SafeDeserialize<List<HotelRateCommissionSearch>>(row.CommissionJSON),
            //        Meals = SafeDeserialize<List<HotelRateMealSearchResponse>>(row.MealOverviewJSON),
            //        Offers = SafeDeserialize<List<HotelRateOfferConfigurationSearchDto>>(row.OfferConfigurationJSON),
            //        Markets = SafeDeserialize<List<HotelRateMarketMasterLookup>>(row.MarketJSON),
            //        RateSheets = SafeDeserialize<List<HotelRatesheetMasterLookup>>(row.RateSheetJSON),
            //        HotelAnnouncement = SafeDeserialize<List<HotelAnnouncement>>(row.HotelAnnouncementsJSON),
            //        HotelContactDetails = SafeDeserialize<List<HotelContactDetails>>(row.ContactDetailsJSON),
            //        RateRuleResponse = SafeDeserialize<List<RateRuleResponseDto>>(row.RulesJSON)


            //    };

            //    result.Add(dto);
            //}

            foreach (var row in resultRaw)
            {
                if (IsDateMatching(row.Days?.ToString(), filter.CheckIn, filter.CheckOut) || row.Type?.ToString()== "CustomRateCard")
                {
                    var dto = new HotelRateDetailsSearchResponseDto
                    {
                        HotelRateID = Convert.ToInt64(row.HotelRateID),
                        HotelID = Convert.ToInt64(row.HotelID),
                        HotelName = row.HotelName?.ToString(),
                        CityID = row.CityID?.ToString(),
                        CityName = row.CityName?.ToString(),
                        HotelRateDetailID = Convert.ToInt64(row.HotelRateDetailID),
                        RoomCategoryID = Convert.ToInt32(row.RoomCategoryID),
                        RoomCategory = row.RoomCategory?.ToString(),
                        MISSequence = row.MISSequence?.ToString(), // This was likely the main issue
                        Days = row.Days?.ToString(),
                        DaysOfWeek = row.DaysOfWeek?.ToString(),
                        DaysNumber = row.DaysNumber?.ToString(),
                        MealPlanCode = row.MealPlanCode?.ToString(),
                        Breakfast = row.Breakfast as bool? ?? false,
                        Lunch = row.Lunch as bool? ?? false,
                        Dinner = row.Dinner as bool? ?? false,
                        HotelPreferred = row.HotelPreferred as int? ?? 0,
                        IsCommission = row.IsCommission as bool? ?? false,
                        PreferedDaterange = row.PreferedDaterange?.ToString(),
                        RateValidityRange = row.RateValidityRange?.ToString(),
                        HasDocument = row.HasDocument as bool? ?? false,
                        HasRules = row.HasRules as bool? ?? false,
                        OfferTypeID = row.OfferTypeID as int? ?? 0,
                        Currency = row.Currency?.ToString(),
                        PurchaseRate = row.PurchaseRate != null ? Convert.ToDecimal(row.PurchaseRate) : 0,
                        RateCardModeTypeID = row.RateCardModeTypeID as int? ?? 0,
                        TransferID = row.TransferID as int? ?? 0,
                        TransferValue = row.TransferValue?.ToString(),
                        Type = row.Type?.ToString(),
                        ValueAddOn = row.ValueAddOn?.ToString(),
                        InfoForOperation = row.InfoForOperation?.ToString(),
                        InfoForRemark = row.InfoForRemark?.ToString(),
                        CreatedBy = row.CreatedBy as Guid?,
                        UserName = row.UserName?.ToString(),


                        HotelType = row.HotelType?.ToString(),
                        ZoneName = row.ZoneName?.ToString(),
                        VendorName = row.VendorName?.ToString(),
                        ExtraBedMattress = row.ExtraBedMattress?.ToString(),
                        CreditApplicable = row.CreditApplicable as bool?,
                        CreditCurrencyCode = row.CreditCurrencyCode?.ToString(),
                        CreditPeriod = row.CreditPeriod as int?,
                        CreditAmount = row.CreditAmount != null ? Convert.ToDecimal(row.CreditAmount) : 0,
                        CreditApproveBy = row.CreditApproveBy?.ToString(),
                        EmailFinance = row.EmailFinance?.ToString(),
                        CardNumber = row.CardNumber?.ToString(),
                        BookFrom = row.BookFrom?.ToString(),
                        BookTo = row.BookTo?.ToString(),
                        Direct_BTC = row.Direct_BTC as bool ?,

                        // Manual JSON deserialization
                        Commissions = SafeDeserialize<List<HotelRateCommissionSearch>>(row.CommissionJSON?.ToString()),
                        HotelOfferRateCard = SafeDeserialize<List<HotelRateOfferRateCardDto>>(row.HotelOfferRateCardJSON?.ToString()),
                        Meals = SafeDeserialize<List<HotelRateMealSearchResponse>>(row.MealOverviewJSON?.ToString()),
                        Offers = SafeDeserialize<List<HotelRateOfferConfigurationSearchDto>>(row.OfferConfigurationJSON?.ToString()),
                        Markets = SafeDeserialize<List<HotelRateMarketMasterLookup>>(row.MarketJSON?.ToString()),
                        RateSheets = SafeDeserialize<List<HotelRatesheetMasterLookup>>(row.RateSheetJSON?.ToString()),
                        HotelAnnouncement = SafeDeserialize<List<HotelAnnouncement>>(row.HotelAnnouncementsJSON?.ToString()),
                        HotelContactDetails = SafeDeserialize<List<HotelContactDetails>>(row.ContactDetailsJSON?.ToString()),
                        RateRuleResponse = SafeDeserialize<List<RateRuleResponseDto>>(row.RulesJSON?.ToString())
                    };
                    result.Add(dto);
                }
                

            }


            return result;
        }

        public static bool IsDateMatching(string daysBinary, DateTime checkIn, DateTime checkOut)
        {
            // Day mapping: index 0 = Monday, ..., index 6 = Sunday
            var weekdayMap = new[] { "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun" };

            // Step 1: Decode binary pattern into active weekday names
            var activeWeekdays = daysBinary
                .Select((bit, idx) => bit == '1' ? weekdayMap[idx] : null)
                .Where(x => x != null)
                .ToHashSet();

            // Step 2: Iterate from CheckIn to CheckOut
            for (DateTime date = checkIn.Date; date <= checkOut.Date; date = date.AddDays(1))
            {
                string dayName = GetDayName(date.DayOfWeek); // e.g., "Mon", "Tue", etc.
                if (activeWeekdays.Contains(dayName))
                    return true;
            }

            return false;
        }

        private static string GetDayName(DayOfWeek dayOfWeek)
        {
            return dayOfWeek switch
            {
                DayOfWeek.Monday => "Mon",
                DayOfWeek.Tuesday => "Tue",
                DayOfWeek.Wednesday => "Wed",
                DayOfWeek.Thursday => "Thu",
                DayOfWeek.Friday => "Fri",
                DayOfWeek.Saturday => "Sat",
                DayOfWeek.Sunday => "Sun",
                _ => ""
            };
        }


        //private T SafeDeserialize<T>(string json)
        //{
        //    if (string.IsNullOrWhiteSpace(json)) return default;
        //    try
        //    {
        //        return JsonConvert.DeserializeObject<T>(json);
        //    }
        //    catch
        //    {
        //        return default; // Optionally log this
        //    }
        //}
        private T SafeDeserialize<T>(string json) where T : new()
        {
            if (string.IsNullOrWhiteSpace(json))
                return new T();

            try
            {
                return JsonConvert.DeserializeObject<T>(json);
            }
            catch
            {
                return new T();
            }
        }

    }
}

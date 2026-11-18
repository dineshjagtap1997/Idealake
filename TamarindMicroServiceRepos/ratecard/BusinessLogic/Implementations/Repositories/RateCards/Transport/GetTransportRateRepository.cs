using Dapper;
using System.Text.Json;
using TamarindAstra.Common;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Transport;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Transport.Document;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Transport;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Implementations.Repositories.RateCards.Transport
{
    public class GetTransportRateRepository : IGetTransportRateRepository
    {
        public async Task<IEnumerable<TransportRateResponseDto>> GetAllTransportRateAsync(TransportRateRequestDto filter)
        {
            var parameters = GetAllTransportRateParameters(filter);
            var result = await SqlHelper.QueryAsync<TransportRateResponseDto, DynamicParameters>("[RateCards].Usp_GetTransportRateCards", parameters);
            return result;
        }
        public async Task<IEnumerable<TransportDocumentResponseDto>> GetTransportRateDocumentsAsync(UploadDocumentRequestDto request)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@TransportCardNo", request.TransportCardNo);
            parameters.Add("@TransportServiceID", request.TransportServiceID);
            parameters.Add("@UploadedBy", request.UploadedBy);
            parameters.Add("@VendorID", request.VendorID);
            parameters.Add(@"ParentID", request.ParentID);
            var result = await SqlHelper.QueryAsync<TransportDocumentResponseDto, DynamicParameters>("[dbo].[usp_SearchTransportUploadDocuments]", parameters);
            return result;
        }
        private static DynamicParameters GetAllTransportRateParameters(TransportRateRequestDto filter)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "GETALL");
            parameters.Add("@IsActive", filter.Active);
            parameters.Add("@PageSize", filter.PageSize);
            parameters.Add("@PageNumber", filter.PageNumber);
            parameters.Add("@CardNumber", filter.CardNumber);
            parameters.Add("@RateCardModeTypeID", filter.RateCardModeType);
            parameters.Add("@Heading", filter.Heading);
            parameters.Add("@ContractDate", filter.ContractDate);
            parameters.Add("@ServiceID", filter.TransportServiceName);
            parameters.Add("@VendorID", filter.Vendor);
            parameters.Add("@HotelID", filter.HotelName);
            parameters.Add("@CityID", filter.City);
            return parameters;
        }

        public async Task<TransportRateResponseDto> GetTransportRateByIdAsync(long id)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "GET_RATE_BYID");
            parameters.Add("@ID", id);
            var result = await SqlHelper.QuerySingleAsync<TransportRateResponseDto, DynamicParameters>("[RateCards].[Usp_GetTransportRateCards]", parameters);
            return result;
        }

        public async Task<TransportRateDetailResponseDto> GetTransportRateDetailsByIdAsync(long id)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "GET_RATEDETAIL_BYID");
            parameters.Add("@ID", id);
            var (transportRateDetails, transportRateCommissionDetails) = await SqlHelper.QueryMultipleAsync<TransportRateDetailResponseDto, TransportRateCommissionDetailResponseDto, DynamicParameters>("[RateCards].[Usp_GetTransportRateCards]", parameters);


            var defaultRate = transportRateDetails.FirstOrDefault();
            defaultRate.Commissions = transportRateCommissionDetails.ToList();
            return defaultRate;
        }

        public async Task<IEnumerable<TransportRateDetailResponseDto>> GetAllTransportRateDetailsByIdAsync(long id, int pageNumber, int pageSize)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "GET_RATEDETAILS_BYID");
            parameters.Add("@ID", id);
            //var transportRateDetails = await SqlHelper.QueryAsync<TransportRateDetailResponseDto, DynamicParameters>("[RateCards].[Usp_GetTransportRateCards]", parameters);

            var flatResult = await SqlHelper.QueryAsync<TransportRateDetailFlatDto, DynamicParameters>("[RateCards].[Usp_GetTransportRateCards]", parameters);
            var commissionLookup = flatResult
    .Where(x => x.TransportCommissionDetailID.HasValue)
    .ToLookup(x => x.TransportRateDetailID);

            var transportRateDetails = flatResult
    .GroupBy(x => x.TransportRateDetailID)
    .Select(g =>
    {
        var first = g.First();
        return new TransportRateDetailResponseDto
        {
            TransportRateDetailID = first.TransportRateDetailID,
            TransportRateID = first.TransportRateID,
            ValidFrom = first.ValidFrom,
            ValidTo = first.ValidTo,
            MISSequence = first.MISSequence,
            TaxID = first.TaxID,
            IsActive = first.IsActive,
            ValidityDate = first.ValidityDate,
            VehicleCategoryID = first.VehicleCategoryID,
            VehicleBaseID = first.VehicleBaseID,
            VehicleType = first.VehicleType,
            VehicleName = first.VehicleName,
            Commissions = commissionLookup[first.TransportRateDetailID]
                .Select(c => new TransportRateCommissionDetailResponseDto
                {
                    TransportCommissionDetailID = c.TransportCommissionDetailID.Value,
                    TransportRateDetailID = c.TransportRateDetailID,
                    CommissionMasterID = c.CommissionMasterID,
                    IsAmtIncludedInBasic = c.IsAmtIncludedInBasic,
                    RateType = c.RateType,
                    TaxAmount = c.TaxAmount,
                    TaxPercentage = c.TaxPercentage,
                    NetAmountIncludingTax = c.NetAmountIncludingTax,
                    NetAmountExcludingTax = c.NetAmountExcludingTax,
                }).ToList()

        };
    }).ToList();

            return transportRateDetails;
        }

        public async Task<IEnumerable<TransportRateResponseDto>> GetRateCardNumberAsync(TransportRateRequestDto filter)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "GET_RATECARDNO");
            parameters.Add("@CardNumber", filter.CardNumber);
            var result = await SqlHelper.QueryAsync<TransportRateResponseDto, DynamicParameters>("[RateCards].[Usp_GetTransportRateCards]", parameters);
            return result;
        }

        public async Task<IEnumerable<TransportRateResponseDto>> GetRateCardHeadingsAsync(TransportRateRequestDto filter)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "GET_RATECARDHEADER");
            parameters.Add("@Heading", filter.Heading);
            var result = await SqlHelper.QueryAsync<TransportRateResponseDto, DynamicParameters>("[RateCards].[Usp_GetTransportRateCards]", parameters);
            return result;
        }

        public async Task<IEnumerable<TransportRateResponseDto>> GetRateCardTransportServicesAsync(TransportRateRequestDto filter)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "GET_RATECARD_SERVICE");
            parameters.Add("@ServiceID", filter.TransportServiceName);
            var result = await SqlHelper.QueryAsync<TransportRateResponseDto, DynamicParameters>("[RateCards].[Usp_GetTransportRateCards]", parameters);
            return result;
        }

        public async Task<IEnumerable<TransportRateSearchResponseDto>> GetAllTransportRateSearchReportAsync(TransportRateCardSearchRequest filter)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@DisplayRate", filter.CurrencyID);
            parameters.Add("@RateCardModeTypeID", filter.RateCardModeType);
            parameters.Add("@TaxID", filter.TaxID);
            parameters.Add("@Service", filter.TransportServiceID);
            parameters.Add("@CityIata", filter.CityID);
            parameters.Add("@VendorID", filter.VendorID);
            parameters.Add("@ValidFrom", filter.ValidFrom);
            parameters.Add("@ValidTo", filter.ValidTo);
            parameters.Add("@VTypeID", filter.VehicleCategoryID);
            parameters.Add("@QuotationID", filter.QuotationID);
            parameters.Add("@BookingID", filter.BookingID);
            parameters.Add("@TransportRateID", filter.TransportRateID);

            //var resultRaw = await SqlHelper.QueryAsync<TransportRateSearchResponseDto, DynamicParameters>(
            //    "[RateCards].[usp_GetTransportRateCardSearchReport]",
            //    parameters
            //);
            var resultRaw = await SqlHelper.QueryAsync<TransportRateSearchResponseDto, DynamicParameters>(
               "[RateCards].[usp_GetTransportRateCardSearchReportNew]",
               parameters
           );
            var result = new List<TransportRateSearchResponseDto>();

            foreach (var row in resultRaw)
            {
                var dto = new TransportRateSearchResponseDto
                {
                    TransportRateID = row.TransportRateID,
                    RateCardModeType = row.RateCardModeType,
                    TransportModeType = row.TransportModeType,
                    TaxID = row.TaxID,
                    TransportServiceID = row.TransportServiceID,
                    HotelID = row.HotelID,
                    VendorID = row.VendorID,
                    HotelZone = row.HotelZone,
                    CityID = row.CityID,
                    //CityID2 = row.CityID2,
                    CurrencyID = row.CurrencyID,
                    StateID = row.StateID,
                    GstStatus = row.GstStatus,
                    VendorName = row.VendorName,
                    City1 = row.City1,
                    TransportServiceName = row.TransportServiceName,
                    HotelZoneName = row.HotelZoneName,
                    VehicleCategoryID = row.VehicleCategoryID,
                    VehicleBaseID = row.VehicleBaseID,
                    ValidFrom = row.ValidFrom,
                    ValidTo = row.ValidTo,
                    MISSequence = row.MISSequence,
                    VehicleType = row.VehicleType,
                    VehicleName = row.VehicleName,
                    TransportService = row.TransportService,
                    //VehicleBaseType = row.VehicleBaseType,
                    //SellingRate = row.SellingRate,
                    Language = row.Language,
                    TransportRateDetailID = row.TransportRateDetailID,
                    Type = row.Type,
                    QuotationID = row.QuotationID,
                    RateCardModeTypeID=row.RateCardModeTypeID,
                    InfoForOperation = row.InfoForOperation,
                    InfoForRemark = row.InfoForRemark,
                    XORemark = row. XORemark,
                    XORemarkName = row. XORemarkName,
                    CardNumber =row.CardNumber,
                    //GrossRate = row.GrossRate,

                    // Safe JSON deserialization from string to list
                    Commissions = SafeDeserialize<List<TransportServiceRateCommissionDetailSearch>>(row.TransportRateCommissionDetails),


                };

                result.Add(dto);
            }


            return result;
        }
        private static T SafeDeserialize<T>(string json)
        {
            if (string.IsNullOrWhiteSpace(json))
                return default;

            try
            {
                return JsonSerializer.Deserialize<T>(json);
            }
            catch (JsonException)
            {
                return default;
            }
        }

    }

}

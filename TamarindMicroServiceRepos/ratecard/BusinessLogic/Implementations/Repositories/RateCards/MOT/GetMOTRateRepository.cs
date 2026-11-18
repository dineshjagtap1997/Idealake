using AutoMapper;
using Dapper;
using NPOI.SS.UserModel;
using System.Text.Json;
using TamarindAstra.Common;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Guide;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Guide.Document;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.MOT;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.MOT.Document;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.MOT;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.MOT;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Implementations.Repositories.RateCards.MOT
{
    public class GetMOTRateRepository : IGetMOTRateRepository
    {
        private readonly IMapper _mapper;

        public async Task<IEnumerable<GetMOTRateResponseDto>> GetAllMOTRateAsync(MOTRateFilter filter)
        {
            var parameters = GetMOTRateFilterParameters(filter);
            var result = await SqlHelper.QueryAsync<GetMOTRateResponseDto, DynamicParameters>("[RateCards].Get_MOTRate", parameters);
            return result;
        }
        public async Task<GetMOTRateResponseDto> GetMOTRateByIdAsync(long id)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "GETBYID");
            parameters.Add("@ID", id);
            var result = await SqlHelper.QuerySingleAsync<GetMOTRateResponseDto, DynamicParameters>("[RateCards].Get_MOTRate", parameters);
            return result;
        }
        public async Task<IEnumerable<GetMOTRateDetailResponseDto>> GetAllMOTRateDetailsByIdAsync(long id, int pageNumber, int pageSize)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "GETALLDETAILS_BYID");
            parameters.Add("@ID", id);
            var motRateDetails = await SqlHelper.QueryAsync<GetMOTRateDetailResponseDto, DynamicParameters>("[RateCards].Get_MOTRate", parameters);
            if (motRateDetails == null || !motRateDetails.Any()) return motRateDetails;

            var motRateDetailID = motRateDetails.FirstOrDefault().MOTRateDetailID;
            foreach (var detail in motRateDetails)
            {
                var motRateCommissionDetails = await SqlHelper.QueryAsync<MOTRateCommissionDetail, DynamicParameters>("[RateCards].Get_MOTRate", GetMOTRateCommissionParameters(motRateDetailID));
                if (motRateCommissionDetails != null && motRateCommissionDetails.Any())
                {
                    detail.Commissions = motRateCommissionDetails.ToList();
                }
            }
            return motRateDetails;
        }
        private static DynamicParameters GetMOTRateCommissionParameters(long id)
        {
            var parameter = new DynamicParameters();
            parameter.Add("@Operation", "GETCOMMISSION_BYID");
            parameter.Add("@ID", id);
            return parameter;
        }
        public async Task<GetMOTRateDetailResponseDto> GetMOTRateDetailByIdAsync(long id)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "GETDETAIL_BYID");
            parameters.Add("@ID", id);
            var (motRateDetails, motRateCommissionDetails) = await SqlHelper.QueryMultipleAsync<GetMOTRateDetailResponseDto, MOTRateCommissionDetail, DynamicParameters>("[RateCards].Get_MOTRate", parameters);
            var defaultRateDetail = motRateDetails.FirstOrDefault();
            defaultRateDetail.Commissions = motRateCommissionDetails.ToList();
            return defaultRateDetail;
        }
        private static DynamicParameters GetMOTRateFilterParameters(MOTRateFilter filter)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@DisplayRate", filter.DisplayRate);
            parameters.Add("@RateCardModeTypeID", filter.RateCardModeType);
            parameters.Add("@TaxID", Convert.ToString(filter.TaxID));
            parameters.Add("@CityIata", filter.CityIata);
            parameters.Add("@Service", filter.Service);
            parameters.Add("@Vendor", filter.Vendor);
            parameters.Add("@NationalityID", filter.NationalityID);
            parameters.Add("@Adult", filter.Adult);
            parameters.Add("@Child", filter.Child);
            parameters.Add("@ValidFrom", filter.ValidFrom);
            parameters.Add("@ValidTo", filter.ValidTo);
            parameters.Add("@QuotationID", filter.QuotationID);
            parameters.Add("@BookingID", filter.BookingID);
            parameters.Add("@MOTRateID", filter.MOTRateID);
            parameters.Add("@Operation", "GETALL");
            parameters.Add("@IsActive", filter.IsActive);
            parameters.Add("@PageSize", filter.PageSize);
            parameters.Add("@PageNumber", filter.PageNumber);
            parameters.Add("@CardNumber", filter.CardNumber);
            parameters.Add("@RateCardModeType", filter.RateCardModeType);
            parameters.Add("@Heading", filter.Heading);
            parameters.Add("@ContractDate", filter.ContractDate);
            parameters.Add("@MOT", filter.MOT);
            parameters.Add("@Vendor", filter.Vendor);
            return parameters;
        }
        //public async Task<IEnumerable<GetAllMotRateResponseDto>> GetRateCardMOTServicesAsync(CreateMOTRateRequestDto filter)
        //{
        //    var parameters = new DynamicParameters();
        //    parameters.Add("@Operation", "GET_RATECARD_SERVICE");
        //    parameters.Add("@Monument", filter.MonumentService);
        //    var result = await SqlHelper.QueryAsync<GetAllMonumentRateResponseDto, DynamicParameters>("[RateCards].[Get_MonumentRate]", parameters);
        //    return result;
        //}

        public async Task<IEnumerable<MOTDocumentResponseDto>> GetMotRateDocumentsAsync(UploadDocumentRequestDto request)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@MOTCardNo", request.CardNumber);
            parameters.Add("@MOTID", request.MOTRateID);
            parameters.Add("@UploadedBy", request.UploadedBy);
            var result = await SqlHelper.QueryAsync<MOTDocumentResponseDto, DynamicParameters>("[dbo].[usp_SearchMOTUploadDocuments]", parameters);
            return result;
        }
        private static List<T> SafeDeserialize<T>(string json)
        {
            if (string.IsNullOrWhiteSpace(json))
                return new List<T>();

            try
            {
                return JsonSerializer.Deserialize<List<T>>(json, new JsonSerializerOptions
                {
                    PropertyNameCaseInsensitive = true
                }) ?? new List<T>();
            }
            catch
            {
                return new List<T>();
            }
        }
        public async Task<IEnumerable<GetMOTRateSearchResponseDto>> GetAllMOTRateCardReportAsync(GetMOTRateSearchRequestDto filter)
        {
            var parameters = new DynamicParameters();

            parameters.Add("@DisplayRate", filter.CurrencyID);
            parameters.Add("@RateCardModeTypeID", filter.RateCardModeType);
            parameters.Add("@TaxID", filter.TaxID);
            parameters.Add("@CityIata", filter.CityID);
            parameters.Add("@Service", filter.MOTServiceID);
            parameters.Add("@Vendor", filter.VendorID);
            parameters.Add("@NationalityID", filter.NationalityID);
            parameters.Add("@Adult", filter.Adult);
            parameters.Add("@Child", filter.Child);
            parameters.Add("@ValidFrom", filter.ValidFrom);
            parameters.Add("@ValidTo", filter.ValidTo);
            parameters.Add("@QuotationID", filter.QuotationID);
            parameters.Add("@BookingID", filter.BookingID);
            parameters.Add("@MOTRateID", filter.MOTRateID);
            parameters.Add("@TravelModeTypeID", filter.TravelModeTypeID);
            parameters.Add("@ClassTypeID", filter.ClassTypeID);

            var flatResult = await SqlHelper.QueryAsync<GetMOTRateSearchResponseDto, DynamicParameters>(
              "[RateCards].[usp_GetMOTRateCardSearchReportNew]", parameters
          );
            // Deserialize CommissionJSON for each record
            foreach (var row in flatResult)
            {
                row.Commissions = SafeDeserialize<MOTRateCommissionDetailSearch>(row.CommissionJSON);
            }

            return flatResult;

            //var groupedResult = flatResult
            //    .GroupBy(x => x.MOTRateDetailID)
            //    .Select(group =>
            //    {
            //        var first = group.First();

            //        // Map main DTO from the first grouped item
            //        var mappedDto = _mapper.Map<GetMOTRateSearchResponseDto>(first);

            //        // Map commissions list
            //        mappedDto.Commissions = _mapper.Map<List<MOTRateCommissionDetailSearch>>(
            //            group.Where(c => c.MOTCommissionDetailID.HasValue).ToList()
            //        );

            //        return mappedDto;
            //    })
            //    .ToList();

            return flatResult;
        }

    }
}

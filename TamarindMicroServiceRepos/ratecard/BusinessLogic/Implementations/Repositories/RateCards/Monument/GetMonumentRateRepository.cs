using AutoMapper;
using Dapper;
using TamarindAstra.Common;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Monument;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Monument.Document;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Monument;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Implementations.Repositories.RateCards.Monument
{
    public class GetMonumentRateRepository : IGetMonumentRateRepository
    {
        private readonly IMapper _mapper;

        public GetMonumentRateRepository(IMapper mapper)
        {
            _mapper = mapper;
        }
        public async Task<IEnumerable<GetAllMonumentRateResponseDto>> GetAllMonumentRateAsync(MonumentRateRequestDto filter)
        {
            var parameters = GetAllMonumentRateFilterParameters(filter);
            var result = await SqlHelper.QueryAsync<GetAllMonumentRateResponseDto, DynamicParameters>("[RateCards].Get_MonumentRate", parameters);
            return result;
        }

        public async Task<IEnumerable<GetMonumentRateDetailResponseDto>> GetAllMonumentRateDetailsByIdAsync(long id, int pageNumber, int pageSize)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "GET_RATEDETAILS_BYRATEID");
            parameters.Add("@ID", id);
            parameters.Add("@PageSize", pageSize);
            parameters.Add("@PageNumber", pageNumber);
            //var monumentRateDetails = await SqlHelper.QueryAsync<GetAllMonumentRateDetailResponseDto, DynamicParameters>("[RateCards].Get_MonumentRate", parameters);
            var flatResult = await SqlHelper.QueryAsync<MonumentRateDetailFlatDto, DynamicParameters>("[RateCards].Get_MonumentRate", parameters);
            var commissionLookup = flatResult
    .Where(x => x.MonumentCommissionDetailID.HasValue)
    .ToLookup(x => x.MonumentDetailID);

            var monumentRateDetails = flatResult
    .GroupBy(x => x.MonumentDetailID)
    .Select(g =>
    {
        var first = g.First();
        return new GetMonumentRateDetailResponseDto
        {
            MonumentDetailID = first.MonumentDetailID,
            TaxID = first.TaxID,
            ValidFrom = first.ValidFrom,
            ValidTo = first.ValidTo,
            MISSequence = first.MISSequence,
            IsActive = first.IsActive,
            ValidityDate = first.ValidityDate,
            Nationality = first.Nationality,
            NationalityID = first.NationalityID,
            Commissions = commissionLookup[first.MonumentDetailID]
            .Select(c => new MonumentRateCommissionDetailRequestDto
            {
                Ratetype = c.Ratetype,
                MonumentCommissionDetailID = c.MonumentCommissionDetailID ?? 0,
                TaxAmount = c.TaxAmount,
                CommissionMasterID = c.CommissionMasterID,
                TaxPercentage = c.TaxPercentage,
                NetAmountIncludingTax = c.NetAmountIncludingTax,
                NetAmountExcludingTax = c.NetAmountExcludingTax
            }).ToList()

        };
    }).ToList();
            return monumentRateDetails;
        }

        public async Task<GetMonumentRateResponseDto> GetMonumentRateByIdAsync(long id)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "GET_RATE_BYID");
            parameters.Add("@ID", id);
            var result = await SqlHelper.QuerySingleAsync<GetMonumentRateResponseDto, DynamicParameters>("[RateCards].Get_MonumentRate", parameters);
            return result;
        }

        public async Task<GetMonumentRateDetailResponseDto> GetMonumentRateDetailByIdAsync(long id)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "GET_RATEDETAIL_BYID");
            parameters.Add("@ID", id);
            var (monumentRateDetails, monumentRateCommissionDetails) = await SqlHelper.QueryMultipleAsync<GetMonumentRateDetailResponseDto, MonumentRateCommissionDetailRequestDto, DynamicParameters>("[RateCards].Get_MonumentRate", parameters);
            var defaultRateDetail = monumentRateDetails.FirstOrDefault();
            defaultRateDetail.Commissions = monumentRateCommissionDetails.ToList();
            return defaultRateDetail;
        }

        private static DynamicParameters GetAllMonumentRateFilterParameters(MonumentRateRequestDto filter)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "GETALL");
            parameters.Add("@IsActive", filter.Active);
            parameters.Add("@PageSize", filter.PageSize);
            parameters.Add("@PageNumber", filter.PageNumber);
            parameters.Add("@CardNumber", filter.CardNumber);
            parameters.Add("@RateCardModeType", filter.RateCardModeType);
            parameters.Add("@Heading", filter.Heading);
            parameters.Add("@ContractDate", filter.ContractDate);
            parameters.Add("@Monument", filter.MonumentService);
            parameters.Add("@Vendor", filter.Vendor);
            parameters.Add("@City", filter.City);
            return parameters;
        }

        public async Task<IEnumerable<MonumentRateDocumentResponseDto>> GetMonumentRateDocumentsAsync(UploadDocumentRequestDto request)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@MonumentCardNo", request.MonumentCardNo);
            parameters.Add("@MonumentName", request.MonumentName);
            parameters.Add("@UploadedBy", request.UploadedBy);
            parameters.Add("@ParentID", request.ParentID);
            var result = await SqlHelper.QueryAsync<MonumentRateDocumentResponseDto, DynamicParameters>("[dbo].[usp_SearchMonumentUploadDocuments]", parameters);
            return result;
        }

        public async Task<IEnumerable<GetAllMonumentRateResponseDto>> GetRateCardNumberAsync(MonumentRateRequestDto filter)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "GET_RATECARDNO");
            parameters.Add("@CardNumber", filter.CardNumber);
            var result = await SqlHelper.QueryAsync<GetAllMonumentRateResponseDto, DynamicParameters>("[RateCards].Get_MonumentRate", parameters);
            return result;
        }

        public async Task<IEnumerable<GetAllMonumentRateResponseDto>> GetRateCardHeadingsAsync(MonumentRateRequestDto filter)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "GET_RATECARDHEADER");
            parameters.Add("@Heading", filter.Heading);
            var result = await SqlHelper.QueryAsync<GetAllMonumentRateResponseDto, DynamicParameters>("[RateCards].Get_MonumentRate", parameters);
            return result;
        }

        public async Task<IEnumerable<GetAllMonumentRateResponseDto>> GetRateCardMonumentServicesAsync(MonumentRateRequestDto filter)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "GET_RATECARD_SERVICE");
            parameters.Add("@Monument", filter.MonumentService);
            var result = await SqlHelper.QueryAsync<GetAllMonumentRateResponseDto, DynamicParameters>("[RateCards].[Get_MonumentRate]", parameters);
            return result;
        }

        public async Task<IEnumerable<GetMonumentRateSearchResponseDto>> GetAllMonumentRateCardReportAsync(GetMonumentRateSearchRequestDto filter)
        {
            var parameters = new DynamicParameters();

            parameters.Add("@DisplayRate", filter.CurrencyID);
            parameters.Add("@RateCardModeTypeID", filter.RateCardModeType);
            parameters.Add("@TaxID", Convert.ToString(filter.TaxID));
            parameters.Add("@CityIata", filter.CityID);
            parameters.Add("@Service", filter.MonumentServiceID);
            parameters.Add("@Vendor", filter.VendorID);
            parameters.Add("@NationalityID", filter.NationalityID);
            parameters.Add("@Adult", filter.Adult);
            parameters.Add("@Child", filter.Child);
            parameters.Add("@ValidFrom", filter.ValidFrom);
            parameters.Add("@ValidTo", filter.ValidTo);
            parameters.Add("@QuotationID", filter.QuotationID);
            parameters.Add("@BookingID", filter.BookingID);
            parameters.Add("@MonumentRateID", filter.MonumentRateID);
            //var flatResult = await SqlHelper.QueryAsync<GetMonumentRateSearchResponseDto, DynamicParameters>(
            //    "[RateCards].[usp_GetMonumentRateCardSearchReport]", parameters
            //);
            var flatResult = await SqlHelper.QueryAsync<GetMonumentRateSearchResponseDto, DynamicParameters>(
              "[RateCards].[usp_GetMonumentRateCardSearchReportNew]", parameters
          );

            var groupedResult = flatResult
                .GroupBy(x => x.MonumentDetailID)
                .Select(group =>
                {
                    var first = group.First();

                    // Map main DTO from the first grouped item
                    var mappedDto = _mapper.Map<GetMonumentRateSearchResponseDto>(first);

                    // Map commissions list
                    mappedDto.Commissions = _mapper.Map<List<MonumentRateCommissionDetailSearch>>(
                        group.Where(c => c.MonumentCommissionDetailID.HasValue).ToList()
                    );

                    return mappedDto;
                })
                .ToList();

            return (IEnumerable<GetMonumentRateSearchResponseDto>)groupedResult;
        }

    }
}

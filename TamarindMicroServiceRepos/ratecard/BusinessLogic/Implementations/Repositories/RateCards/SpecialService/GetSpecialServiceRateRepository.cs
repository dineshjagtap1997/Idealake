using AutoMapper;
using Dapper;
using TamarindAstra.Common;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.SpecialService;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.SpecialService.Document;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.SpecialService;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Implementations.Repositories.RateCards.SpecialService
{
    public class GetSpecialServiceRateRepository : IGetSpecialServiceRateRepository
    {

        private readonly IMapper _mapper;

        public GetSpecialServiceRateRepository(IMapper mapper)
        {
            _mapper = mapper;
        }
        public async Task<IEnumerable<GetAllSpecialServiceRateResponseDto>> GetAllSpecialServiceRateAsync(SpecialServiceRateRequestDto filter)
        {
            var parameters = GetAllSpecialServiceRateFilterParameters(filter);
            var result = await SqlHelper.QueryAsync<GetAllSpecialServiceRateResponseDto, DynamicParameters>("[RateCards].Get_SpecialServiceRate", parameters);
            return result;
        }

        public async Task<IEnumerable<GetSpecialServiceRateDetailResponseDto>> GetAllSpecialServiceRateDetailsByIdAsync(long id, int pageNumber, int pageSize)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "GET_RATEDETAILS_BYRATEID");
            parameters.Add("@ID", id);
            parameters.Add("@PageSize", pageSize);
            parameters.Add("@PageNumber", pageNumber);
            // var specialServiceRateDetails = await SqlHelper.QueryAsync<GetAllSpecialServiceRateDetailResponseDto, DynamicParameters>("[RateCards].Get_SpecialServiceRate", parameters);
            var flatResult = await SqlHelper.QueryAsync<SpecialServiceRateDetailFlatDto, DynamicParameters>("[RateCards].Get_SpecialServiceRate", parameters);
            var commissionLookup = flatResult.Where(x => x.SpecialServiceRateCommissionID.HasValue)
            .ToLookup(x => x.SpecialServiceRateDetailID);

            var specialServiceRateDetails = flatResult
            .GroupBy(x => x.SpecialServiceRateDetailID)
            .Select(g =>
                {
                    var first = g.First();
                    return new GetSpecialServiceRateDetailResponseDto
                    {
                        SpecialServiceRateDetailID = first.SpecialServiceRateDetailID,
                        TaxID = first.TaxID,
                        ValidFrom = first.ValidFrom,
                        ValidTo = first.ValidTo,
                        RatePreferenceID = first.RatePreferenceID,
                        RatePreference = first.RatePreference,
                        MISSequence = first.MISSequence,
                        IsActive = first.IsActive,
                        SpecialServiceRateID = first.SpecialServiceRateID,
                        ValidityDate = first.ValidityDate,
                        Nationality = first.Nationality,
                        NationalityID = first.NationalityID,
                        Commissions = commissionLookup[first.SpecialServiceRateDetailID]
                        .Select(c => new GetSpecialServiceRateCommissionDetailResponseDto
                        {
                            Ratetype = c.Ratetype,
                            SpecialServiceRateCommissionID = c.SpecialServiceRateCommissionID ?? 0,
                            TaxAmount = c.TaxAmount,
                            CommissionMasterID = c.CommissionMasterID,
                            TaxPercentage = c.TaxPercentage,
                            NetAmountIncludingTax = c.NetAmountIncludingTax,
                            NetAmountExcludingTax = c.NetAmountExcludingTax,
                            MinimumPax = c.MinimumPax,
                            MaximumPax = c.MaximumPax,
                        }).ToList()
                    };
                }).ToList();
            return specialServiceRateDetails;
        }

        public async Task<GetSpecialServiceRateResponseDto> GetSpecialServiceRateByIdAsync(long id)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "GET_RATE_BYID");
            parameters.Add("@ID", id);
            var result = await SqlHelper.QuerySingleAsync<GetSpecialServiceRateResponseDto, DynamicParameters>("[RateCards].Get_SpecialServiceRate", parameters);
            return result;
        }

        public async Task<GetSpecialServiceRateDetailResponseDto> GetSpecialServiceRateDetailByIdAsync(long id)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "GET_RATEDETAIL_BYID");
            parameters.Add("@ID", id);
            var (specialServiceRateDetails, specialServiceRateCommissionDetails) = await SqlHelper.QueryMultipleAsync<GetSpecialServiceRateDetailResponseDto, GetSpecialServiceRateCommissionDetailResponseDto, DynamicParameters>("[RateCards].Get_SpecialServiceRate", parameters);
            var defaultRateDetail = specialServiceRateDetails.FirstOrDefault();
            defaultRateDetail.Commissions = specialServiceRateCommissionDetails.ToList();
            return defaultRateDetail;
        }
        private static DynamicParameters GetAllSpecialServiceRateFilterParameters(SpecialServiceRateRequestDto filter)
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
            parameters.Add("@SpecialService", filter.SpecialService);
            parameters.Add("@Vendor", filter.Vendor);
            parameters.Add("@City", filter.City);
            return parameters;
        }

        public async Task<IEnumerable<SpecialServiceDocumentResponseDto>> GetSpecialServiceRateDocumentsAsync(UploadDocumentRequestDto request)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@SpecialServiceCardNo", request.SpecialServiceCardNo);
            parameters.Add("@SpecialService", request.SpecialService);
            parameters.Add("@UploadedBy", request.UploadedBy);
            parameters.Add("@ParentID", request.ParentID);
            var result = await SqlHelper.QueryAsync<SpecialServiceDocumentResponseDto, DynamicParameters>("[dbo].[usp_SearchSpecialServiceUploadDocuments]", parameters);
            return result;
        }

        public async Task<IEnumerable<GetAllSpecialServiceRateResponseDto>> GetRateCardNumberAsync(SpecialServiceRateRequestDto filter)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "GET_RATECARDNO");
            parameters.Add("@CardNumber", filter.CardNumber);
            var result = await SqlHelper.QueryAsync<GetAllSpecialServiceRateResponseDto, DynamicParameters>("[RateCards].Get_SpecialServiceRate", parameters);
            return result;
        }

        public async Task<IEnumerable<GetAllSpecialServiceRateResponseDto>> GetRateCardHeadingsAsync(SpecialServiceRateRequestDto filter)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "GET_RATECARDHEADER");
            parameters.Add("@Heading", filter.Heading);
            var result = await SqlHelper.QueryAsync<GetAllSpecialServiceRateResponseDto, DynamicParameters>("[RateCards].Get_SpecialServiceRate", parameters);
            return result;
        }

        public async Task<IEnumerable<GetAllSpecialServiceRateResponseDto>> GetRateCardSpecialServicesAsync(SpecialServiceRateRequestDto filter)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "GET_RATECARD_SERVICE");
            parameters.Add("@SpecialService", filter.SpecialService);
            var result = await SqlHelper.QueryAsync<GetAllSpecialServiceRateResponseDto, DynamicParameters>("[RateCards].[Get_SpecialServiceRate]", parameters);
            return result;
        }

        //public async Task<IEnumerable<GetSpecialServiceSearchResponseDto>> GetAllSpecialServiceRateSearchReportAsync(GetSpecialServiceSearchRequestDto filter)
        //{
        //    var parameters = new DynamicParameters();
        //    parameters.Add("@DisplayRate", filter.CurrencyID);
        //    parameters.Add("@RateCardModeTypeID", filter.RateCardModeTypeID);
        //    parameters.Add("@TaxID", Convert.ToString(filter.TaxID));
        //    parameters.Add("@CityIata", filter.CityID);
        //    parameters.Add("@Service", filter.SpecialServiceRateID);
        //    parameters.Add("@VendorID", filter.VendorID);
        //    parameters.Add("@NationalityID", filter.NationalityID);
        //    parameters.Add("@Adult", filter.Adult);
        //    parameters.Add("@Child", filter.Child);
        //    parameters.Add("@ValidFrom", filter.ValidFrom);
        //    parameters.Add("@ValidTo", filter.ValidTo);
        //    var result = await SqlHelper.QueryAsync<GetSpecialServiceSearchResponseDto, DynamicParameters>("[RateCards].[usp_GetSpecialServiceRateCardSearchReport]", parameters);
        //    return result;
        //}

        public async Task<IEnumerable<GetSpecialServiceSearchResponseDto>> GetAllSpecialServiceRateSearchReportAsync(GetSpecialServiceSearchRequestDto filter)

        {

            var parameters = new DynamicParameters();

            parameters.Add("@DisplayRate", filter.CurrencyID);
            parameters.Add("@RateCardModeTypeID", filter.RateCardModeType);
            parameters.Add("@TaxID", filter.TaxID);
            parameters.Add("@CityIata", filter.CityID);
            parameters.Add("@Service", filter.SpecialServiceID);
            parameters.Add("@VendorID", filter.VendorID);
            parameters.Add("@NationalityID", filter.NationalityID);
            parameters.Add("@Adult", filter.Adult);
            parameters.Add("@Child", filter.Child);
            parameters.Add("@ValidFrom", filter.ValidFrom);
            parameters.Add("@ValidTo", filter.ValidTo);
            parameters.Add("@QuotationID", filter.QuotationID);
            parameters.Add("@BookingID", filter.BookingID);
            parameters.Add("@SpecialServiceRateID", filter.SpecialServiceRateID);
            // Execute stored procedure and get flat result

            var flatResult = await SqlHelper.QueryAsync<GetSpecialServiceSearchResponseDto, DynamicParameters>(

                "[RateCards].[usp_GetSpecialServiceRateCardSearchReportNew]", parameters

            );


            var groupedResult = flatResult
    .GroupBy(x => x.SpecialServiceRateID)
    .Select(group =>
    {
        var first = group.First();

        var dto = _mapper.Map<GetSpecialServiceSearchResponseDto>(first);
        dto.Commissions = group
            .Where(c => c.SpecialServiceRateCommissionID.HasValue)
            .Select(c => _mapper.Map<SpecialServiceRateCommissionDetailSearch>(c))
            .ToList();

        return dto;
    })
    .ToList();



            return (IEnumerable<GetSpecialServiceSearchResponseDto>)groupedResult;

        }
    }
}

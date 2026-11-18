using Dapper;
using System.Data;
using TamarindAstra.Common;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Guide;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Guide.Document;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Guide;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Implementations.Repositories.RateCards.Guide
{
    public class GetGuideRateRepository : IGetGuideRateRepository
    {
        public async Task<IEnumerable<GetGuideRateResponseDto>> GetAllGuideRateAsync(GuideRateRequestDto filter)
        {
            var parameters = GetAllGuideRateFilterParameters(filter);
            var result = await SqlHelper.QueryAsync<GetGuideRateResponseDto, DynamicParameters>("[RateCards].[Get_GuideRateCard]", parameters);
            return result;
        }

        public async Task<IEnumerable<GetGuideRateResponseDto>> GetRateCardNumberAsync(GuideRateRequestDto filter)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "GET_RATECARDNO");
            parameters.Add("@CardNumber", filter.CardNumber);
            var result = await SqlHelper.QueryAsync<GetGuideRateResponseDto, DynamicParameters>("[RateCards].[Get_GuideRateCard]", parameters);
            return result;
        }

        public async Task<IEnumerable<GetGuideRateResponseDto>> GetRateCardHeadingsAsync(GuideRateRequestDto filter)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "GET_RATECARDHEADER");
            parameters.Add("@Heading", filter.Heading);
            var result = await SqlHelper.QueryAsync<GetGuideRateResponseDto, DynamicParameters>("[RateCards].[Get_GuideRateCard]", parameters);
            return result;
        }
        private static DynamicParameters GetAllGuideRateFilterParameters(GuideRateRequestDto filter)
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
            parameters.Add("@GuideServiceID", filter.GuideService);
            parameters.Add("@CityID", filter.City);
            parameters.Add("@VendorID", filter.Vendor);
            return parameters;
        }
        public async Task<GetGuideRateResponseDto> GetGuideRateByIdAsync(long id)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "GET_RATE_BYID");
            parameters.Add("@Id", id);
            var result = await SqlHelper.QueryAsync<GetGuideRateResponseDto, DynamicParameters>("[RateCards].[Get_GuideRateCard]", parameters);
            return result.FirstOrDefault();
        }
        public async Task<IEnumerable<GetGuideRateDetailResponseDto>> GetAllGuideRateDetailsByIdAsync(long id, int pageNumber, int pageSize)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "GET_RATEDETAILS_BYID");
            parameters.Add("@Id", id);
            parameters.Add("@PageSize", pageSize);
            parameters.Add("@PageNumber", pageNumber);

            var flatResult = await SqlHelper.QueryAsync<GuideRateDetailFlatDto, DynamicParameters>("[RateCards].[Get_GuideRateCard]", parameters);
            var commissionLookup = flatResult
            .Where(x => x.GuideRateCommissionID.HasValue)
            .ToLookup(x => x.GuideRateDetailID);

            var guideRateDetails = flatResult
        .GroupBy(x => x.GuideRateDetailID)
        .Select(g => {
        var first = g.First();
        return new GetGuideRateDetailResponseDto
        {
            GuideRateDetailID = first.GuideRateDetailID,
            ValidFrom = first.ValidFrom,
            ValidTo = first.ValidTo,
            MISSequence = first.MISSequence,
            TaxID = first.TaxID,
            IsActive = first.IsActive,
            ValidityDate = first.ValidityDate,
            Commissions = commissionLookup[first.GuideRateDetailID]
                .Select(c => new GuideRateCommissionDetailRequestDto
                {
                    GuideRateCommissionID = c.GuideRateCommissionID.Value,
                    TaxAmount = c.TaxAmount ?? 0,
                    TaxPercentage = c.TaxPercentage ?? 0,
                    PaxMinimum = c.PaxMinimum ?? 0,
                    PaxMaximum = c.PaxMaximum ?? 0,
                    NetAmountIncludingTax = c.NetAmountIncludingTax ?? 0,
                    NetAmountExcludingTax = c.NetAmountExcludingTax ?? 0,
                }).ToList()
        };
    }).ToList();

            return guideRateDetails;
        }
        public async Task<GetGuideRateDetailResponseDto> GetGuideRateDetailsByIdAsync(long id)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "GET_RATEDETAIL_BYID");
            parameters.Add("@ID", id);
            var (result, guideCommissionDetails) = await SqlHelper.QueryMultipleAsync<GetGuideRateDetailResponseDto, GetGuideRateCommissionDetailResponseDto, DynamicParameters>("[RateCards].[Get_GuideRateCard]", parameters);
            GetGuideRateDetailResponseDto response = result.FirstOrDefault();
            //response.Commissions = guideCommissionDetails.FirstOrDefault();
            return response;
        }
        public async Task<IEnumerable<GuideRateDocumentResponseDto>> GetGuideRateDocumentsAsync(UploadDocumentRequestDto request)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@GuideCardNo", request.GuideCardNo);
            parameters.Add("@GuideService", request.GuideService);
            parameters.Add("@UploadedBy", request.UploadedBy);
            parameters.Add("@ParentID", request.ParentID);
            var result = await SqlHelper.QueryAsync<GuideRateDocumentResponseDto, DynamicParameters>("usp_SearchGuideUploadDocuments", parameters);
            return result;
        }

        public async Task<IEnumerable<GetGuideRateResponseDto>> GetRateCardGuideServicesAsync(GuideRateRequestDto filter)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "GET_RATECARD_SERVICE");
            parameters.Add("@GuideService", filter.GuideService);
            var result = await SqlHelper.QueryAsync<GetGuideRateResponseDto, DynamicParameters>("[RateCards].[Get_GuideRateCard]", parameters);
            return result;
        }

        public async Task<IEnumerable<GetGuideRateSearchResponseDto>> GetAllGuideRateCardReportAsync(GetGuideRateSearchRequestDto filter)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@DisplayRate", filter.CurrencyID);
            parameters.Add("@RateCardModeType", filter.RateCardModeType);
            parameters.Add("@TaxID", Convert.ToString(filter.TaxID));
            parameters.Add("@CityIata", filter.CityID);
            parameters.Add("@Service", filter.GuideServiceID);
            parameters.Add("@Vendor", filter.VendorID);
            parameters.Add("@Language", filter.LanguageID);
            parameters.Add("@NoofPax", filter.PaxMaximum);
            parameters.Add("@ValidFrom", filter.ValidFrom);
            parameters.Add("@ValidTo", filter.ValidTo);
            parameters.Add("@QuotationID", filter.QuotationID);
            parameters.Add("@BookingID", filter.BookingID);
            parameters.Add("@GuidRateID", filter.GuidRateID);
            //var result = await SqlHelper.QueryAsync<GetGuideRateSearchResponseDto, DynamicParameters>("[RateCards].[usp_GetGuideRateCardSearchReport]", parameters);
            var result = await SqlHelper.QueryAsync<GetGuideRateSearchResponseDto, DynamicParameters>("[RateCards].[usp_GetGuideRateCardSearchReportNew]", parameters);
            return result;
        }
    }
}

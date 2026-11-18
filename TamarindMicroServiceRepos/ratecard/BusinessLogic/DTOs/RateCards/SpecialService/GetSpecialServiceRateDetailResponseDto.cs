using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Monument;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.SpecialService;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.SpecialService
{
    public class GetSpecialServiceRateDetailResponseDto : SpecialServiceRateDetail
    {
        public string TaxPreference { get; set; }
        public string RatePreference { get; set; }
        public string ValidityDate { get; set; }
        public string Nationality { get; set; }
        public List<GetSpecialServiceRateCommissionDetailResponseDto> Commissions { get; set; }
    }
}

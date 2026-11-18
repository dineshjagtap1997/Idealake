using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.SpecialService;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.SpecialService
{
    public class GetAllSpecialServiceRateDetailResponseDto: SpecialServiceRateDetail
    {
        public string ValidatityDate { get; set; }
        public string Nationality { get; set; }
        public string RatePreference { get; set; }
        public int MinimumPax { get; set; }
        public int MaximumPax { get; set; }
    }
}

using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Guide;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Guide
{
    public class GuideRateDetailFlatDto: GuideRateDetail
    {
        // Commission fields
        public long? GuideRateCommissionID { get; set; }
        public decimal? TaxAmount { get; set; }
        public decimal? TaxPercentage { get; set; }
        public int? PaxMinimum { get; set; }
        public int? PaxMaximum { get; set; }
        public decimal? NetAmountIncludingTax { get; set; }
        public decimal? NetAmountExcludingTax { get; set; }
        public string ValidityDate { get; set; }
    }
    public class GetAllGuideDetailRateResponseDto : GetGuideRateDetailResponseDto
    {

    }
}
